/**
 * RollupHelper
 * Permet d'effectuer des rollups (récapitulatifs de cumul) sur des champs Lookup
 *
 * @see https://gist.github.com/grotib/838a40928d17d241f974319f04336bc3/edit
 *
 * @version 1.0
 * @author Thibault Weber - HARDIS
 */
@SuppressWarnings('PMD')
global without sharing class RollupHelper{

	//Liste des types d'aggregation possibles
	global Enum Aggregation {COUNT, SUM, MIN, MAX, CONCAT, AVG}

	//Liste des opérateurs disponibles dans les filtres de Rollup
	global Enum Operator {
		EQ,
		NOT_EQ,
		SUP,
		SUP_EQ,
		INF,
		INF_EQ,
		CONTAINS,
		NOT_CONTAINS,
		CONTAINS_IGNORE_CASE,
		NOT_CONTAINS_IGNORE_CASE,
		STARTS_WITH,
		NOT_STARTS_WITH,
		STARTS_WITH_IGNORE_CASE,
		NOT_STARTS_WITH_IGNORE_CASE
	}


	private Schema.sObjectField lookupField;
	private Map<Id, sObject> parentById = new Map<Id, sObject>();
	private List<Rollup> rollups = new List<Rollup>();




	/********************************************************************************************************************************/
	/********************************************************************************************************************************/
	/*																																*/
	/*														CONSTRUCTEURS															*/
	/*																																*/
	/********************************************************************************************************************************/
	/********************************************************************************************************************************/


	/**
	 * Constructeur pour être appelé depuis un Trigger
	 *
	 * @param Schema.sObjectField lookupField: le champ Lookup faisant la liaison entre l'enfant et le parent
	 */
	global RollupHelper(Schema.sObjectField lookupField){

		this(Trigger.isDelete ? Trigger.old : Trigger.new, lookupField);

	}



	/**
	 * Constructeur indépendant pouvant être appelé en dehors d'un contexte de Trigger
	 *
	 * @param List<sObject> records: Liste des objets enfants
	 * @param Schema.sObjectField lookupField: le champ Lookup faisant la liaison entre l'enfant et le parent
	 */
	global RollupHelper(List<sObject> records, Schema.sObjectField lookupField){

		if(Trigger.isExecuting && Trigger.isBefore)
			return;

		this.lookupField = lookupField;

		sObject tempSObject = lookupField.getDescribe().getReferenceTo()[0].newSObject();

		for(sObject record : records){
			if(record.get(lookupField) != null){
				tempSObject = tempSObject.clone();
				tempSObject.put('Id', record.get(lookupField));
				this.parentById.put((Id) record.get(lookupField), tempSObject);
			}
		}
	}






	/********************************************************************************************************************************/
	/********************************************************************************************************************************/
	/*																																*/
	/*													METHODES PUBLIQUES															*/
	/*																																*/
	/********************************************************************************************************************************/
	/********************************************************************************************************************************/



	/**
	 * Ajout d'un nouveau champ à récapituler
	 *
	 * @param Rollup rollup: Wrapper class de "Rollup"
	 */
	global void addRollup(Rollup rollup){
		this.rollups.add(rollup);
	}



	/**
	 * Exectute de recalcul des champs rollups
	 *
	 */
	global void process(){

		if(this.parentById.isEmpty())
			return;

		/**
		 * Construction de la requête des enfants
		 *
		 */

		Set<String> fieldsToQuery = new Set<String>{'Id', this.lookupField.getDescribe().getName()};		//Liste de champs à requêter dans le SELECT

		String childrenQueryOrderBy = '';


		for(Rollup rollup : this.rollups){

			fieldsToQuery.addAll(rollup.getFieldsToQuery());

			if(String.isNotBlank(rollup.concatOrderBy))
				childrenQueryOrderBy = ' ORDER BY ' + rollup.concatOrderBy;

			//Vide les champs rollup des parents
			for(sObject parent : this.parentById.values()){
				rollup.aggregateRecordValue(parent, null);
			}
		}


		Set<Id> parentIds = this.parentById.keySet();

		String childrenQuery = 'SELECT ' + String.join(new List<String>(fieldsToQuery), ', ') +
				' FROM ' + getSObjectTypeOfLookupField(this.lookupField).getDescribe().getName() +
				' WHERE ' + this.lookupField.getDescribe().getName() + ' IN :parentIds' +
				childrenQueryOrderBy;


		/**
		 * Aggregations des champs enfants sur les parents
		 *
		 */
		sObject parentRecord;
		List<sObject> children = Database.query(childrenQuery);
		for(Rollup rollup : this.rollups){
			for(sObject child : children){
				if(rollup.recordFulfillCondition(child)){
					parentRecord = this.parentById.get((Id) child.get(this.lookupField));
					rollup.aggregateRecordValue(this.parentById.get((Id) child.get(this.lookupField)), child);
				}
			}

			if(rollup.aggr == Aggregation.AVG && parentRecord != null && ((Decimal)parentRecord.get(rollup.rollupField)) != null)
				parentRecord.put(rollup.rollupField, ((Decimal)parentRecord.get(rollup.rollupField))/children.size());
		}




		/**
		 * Update des parents
		 *
		 */
		update this.parentById.values();
	}




	/********************************************************************************************************************************/
	/********************************************************************************************************************************/
	/*																																*/
	/*													METHODES PRIVEES															*/
	/*																																*/
	/********************************************************************************************************************************/
	/********************************************************************************************************************************/


	/**
	 * Récupère le sObjet dont provient le champ passé en paramètre
	 * Exemple: Si on lui passe Contact.AccountId, il retournera l'objet Contact
	 *
	 * @param SObjectField lookupField: Un champ de type Lookup
	 * @return sObjectType: le Sobject sur lequel est le champ passé en paramètre
	 */
	private static sObjectType getSObjectTypeOfLookupField(SObjectField lookupField){

		for(sObjectType so : lookupField.getDescribe().getReferenceTo()){
			for(ChildRelationship child : so.getDescribe().getChildRelationships()){
				if(child.getField() == lookupField){
					return child.getChildSObject();
				}
			}
		}

		return null;
	}


	/**
	 * Retourne la valeur maximale des 2 valeurs passées en paramètres
	 * Fonctionne avec des nombres, textes, dates, boolean...
	 *
	 * @param Object value1: 1ere valeur
	 * @param Object value2: 2eme valeur
	 * @return Object: La plus grande des 2 valeurs
	 */
	private static Object getMax(Object value1, Object value2){

		if(value1 == null)
			return value2;
		else if(value2 == null)
			return value1;
		else if(value1 instanceOf Decimal)
			return (Object) Math.max((Decimal) value1, (Decimal) value2);
		else if(value1 instanceOf DateTime)
			return ( (DateTime) value1 > (DateTime) value2 ? value1 : value2 );
		else if(value1 instanceOf String)
			return ( String.valueOf(value1) > String.valueOf(value2) ? value1 : value2 );
		else if(value1 instanceOf Boolean)
			return ( (Boolean) value1 || (Boolean) value2 ? true : false );

		return null;
	}


	/**
	 * Retourne la valeur minimale des 2 valeurs passées en paramètres
	 * Fonctionne avec des nombres, textes, dates, boolean...
	 *
	 * @param Object value1: 1ere valeur
	 * @param Object value2: 2eme valeur
	 * @return Object: La plus petite des 2 valeurs
	 */
	private static Object getMin(Object value1, Object value2){
		if(value1 == null)
			return value2;
		else if(value2 == null)
			return value1;
		else
				return (getMax(value1, value2) == value1 ? value2 : value1);
	}


	/**
	 * Retourne la valeur passée en paramètre ou 0 si cette valeur est nulle
	 *
	 * @param value
	 *
	 * @return la valeur passée en paramètre ou 0 si cette valeur est nulle
	 */
	private static Integer getIntegerValue(Object value){
		return (value == null ? 0 : (Integer) value);
	}


	/**
	 * Retourne la valeur passée en paramètre ou 0 si cette valeur est nulle
	 *
	 * @param value
	 *
	 * @return la valeur passée en paramètre ou 0 si cette valeur est nulle
	 */
	private static Decimal getDecimalValue(Object value){
		return (value == null ? 0 : (Decimal) value);
	}


	/********************************************************************************************************************************/
	/********************************************************************************************************************************/
	/*																																*/
	/*														WRAPPER CLASSES															*/
	/*																																*/
	/********************************************************************************************************************************/
	/********************************************************************************************************************************/


	/**
	 * Wrapper class correspondant à un champ à récapituler
	 *
	 */
	global class Rollup{

		global Schema.sObjectField rollupField;
		global Aggregation aggr;
		private Schema.sObjectField fieldToRollup;
		private String concatSeparator;
		private String concatOrderBy;
		private List<RollupFilter> filters = new List<RollupFilter>();

		private Schema.DisplayType rollupFieldType;


		/**
		 * Constructeur pour les Rollup de type COUNT
		 */
		global Rollup(Schema.sObjectField rollupField){
			this(rollupField, Aggregation.COUNT, null, null, null);
		}


		/**
		 * Constructeur pour les Rollup de type SUM, MAX, MIN et AVG
		 */
		global Rollup(Schema.sObjectField rollupField, Aggregation aggregation, Schema.sObjectField fieldToRollup){
			this(rollupField, aggregation, fieldToRollup, null, null);
		}


		/**
		 * Constructeurs pour les Rollup de type CONCAT
		 */
		global Rollup(Schema.sObjectField rollupField, Aggregation aggregation, Schema.sObjectField fieldToRollup, String concatSeparator){
			this(rollupField, aggregation, fieldToRollup, concatSeparator, null);
		}

		global Rollup(Schema.sObjectField rollupField, Aggregation aggregation, Schema.sObjectField fieldToRollup, String concatSeparator, String concatOrderBy){
			this.rollupField = rollupField;
			this.aggr = aggregation;
			this.fieldToRollup = fieldToRollup;
			this.concatSeparator = concatSeparator;
			this.concatOrderBy = concatOrderBy;

			this.rollupFieldType = rollupField.getDescribe().getType();
		}





		/**
		 * Ajoute une condition sur les records enfants
		 *
		 * @param Schema.sObjectField field : Le champ de l'objet enfant sur lequel ajouter une condition
		 * @param Operator operator : L'operateur de la condition (egal, supérieur, contient, ...), Cf. Enum "Operator"
		 * @param Object value : La valeur du filtre
		 */
		global void addFilter(Schema.sObjectField field, Operator operator, Object value){
			this.filters.add(new RollupFilter(field, operator, value));
		}


		/**
		 * Retourne la liste de tous les champs nécéssaires (dans le SELECT des enfants) pour pouvoir traiter ce Rollup
		 *
		 * @return Set<String>: la liste des noms API des champs nécéssaires
		 */
		private Set<String> getFieldsToQuery(){
			Set<String> fieldsToQuery = new Set<String>();

			if(this.fieldToRollup != null)
				fieldsToQuery.add(this.fieldToRollup.getDescribe().getName());		//Le champ à aggréger sur l'objet enfant

			if(!this.filters.isEmpty()){
				for(RollupFilter cond : this.filters)
					fieldsToQuery.add(cond.field.getDescribe().getName());		//Le champ sur lequel on a une condition
			}

			return fieldsToQuery;
		}


		/**
		 * Vérifie si un record vérifie toutes les filters du Rollup
		 *
		 * @param sObject record: le record à vérifier
		 * @return Boolean: True si le record satisfait toutes les filters, False sinon
		 */
		private Boolean recordFulfillCondition(sObject record){

			for(RollupFilter cond : this.filters){
				if(!cond.recordFulfillCondition(record))
					return false;
			}
			return true;
		}


		/**
		 * Aggrège une valeur dans le champ Rollup
		 *
		 * @param sObject parentRecord:
		 * @param sObject childRecord:
		 */
		private void aggregateRecordValue(sObject parentRecord, sObject childRecord){

			Object oldValue;
			Object valueToAggregate;
			Object newValue;


			if(childRecord == null){
				newValue = (this.aggr == Aggregation.COUNT || this.aggr == Aggregation.SUM ? 0 : null);
			}
			else{

				oldValue = parentRecord.get(this.rollupField);
				valueToAggregate = (this.aggr == Aggregation.COUNT ? 1 : childRecord.get(this.fieldToRollup));

				if(this.aggr == Aggregation.MAX) {
					newValue = getMax(oldValue, valueToAggregate);
				}
				else if(this.aggr == Aggregation.MIN) {
					newValue = getMin(oldValue, valueToAggregate);
				}
				else if(this.aggr == Aggregation.CONCAT) {
					newValue = (oldValue == null ? '' : oldValue + this.concatSeparator) + valueToAggregate;
				}
				else if(this.aggr == Aggregation.AVG){
					newValue = oldValue != null ? (Decimal) oldValue + (Decimal) valueToAggregate : 0 + (Decimal) valueToAggregate;
				}
				else if(this.rollupFieldType == Schema.DisplayType.Integer) {
					newValue = getIntegerValue(oldValue) + getIntegerValue(valueToAggregate);
				}
				else {
					newValue = getDecimalValue(oldValue) + getDecimalValue(valueToAggregate);
				}
			}


			parentRecord.put(this.rollupField, newValue);

		}

	}









	/**
	 * Wrapper class correspondant à une condition de Rollup
	 *
	 */
	private class RollupFilter{

		private Schema.sObjectField field;
		private Operator ope;
		private String value;


		/**
		 * Constructeur
		 *
		 * @param Schema.sObjectField field : Le champ de l'objet enfant sur lequel ajouter une condition
		 * @param Operator operator : L'operateur de la condition (egal, supérieur, contient, ...), Cf. Enum "Operator"
		 * @param Object value : La valeur du filtre
		 */
		private RollupFilter(Schema.sObjectField field, Operator operator, Object value){
			this.field = field;
			this.ope = operator;
			this.value = String.valueOf(value);
		}


		/**
		 * Vérifie si un record vérifie cette condition
		 *
		 * @param sObject record: le record à vérifier
		 * @return Boolean: True si le record satisfait cette condition, False sinon
		 */
		private Boolean recordFulfillCondition(sObject record){

			String fieldValue = String.valueOf(record.get(this.field));

			if(this.ope == Operator.EQ)
				return fieldValue == this.value;
			else if(this.ope == Operator.NOT_EQ)
				return fieldValue != this.value;
			else if(this.ope == Operator.SUP)
				return fieldValue > this.value;
			else if(this.ope == Operator.INF)
				return fieldValue < this.value;
			else if(this.ope == Operator.SUP_EQ)
				return fieldValue >= this.value;
			else if(this.ope == Operator.INF_EQ)
				return fieldValue <= this.value;
			else if(this.ope == Operator.CONTAINS)
				return fieldValue.contains(this.value);
			else if(this.ope == Operator.NOT_CONTAINS)
				return !fieldValue.contains(this.value);
			else if(this.ope == Operator.CONTAINS_IGNORE_CASE)
				return fieldValue.containsIgnoreCase(this.value);
			else if(this.ope == Operator.NOT_CONTAINS_IGNORE_CASE)
				return !fieldValue.containsIgnoreCase(this.value);
			else if(this.ope == Operator.STARTS_WITH)
				return fieldValue.startsWith(this.value);
			else if(this.ope == Operator.NOT_STARTS_WITH)
				return !fieldValue.startsWith(this.value);
			else if(this.ope == Operator.STARTS_WITH_IGNORE_CASE)
				return fieldValue.startsWithIgnoreCase(this.value);
			else if(this.ope == Operator.NOT_STARTS_WITH_IGNORE_CASE)
				return !fieldValue.startsWithIgnoreCase(this.value);

			return false;
		}

	}

}