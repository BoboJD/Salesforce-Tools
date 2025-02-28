global inherited sharing class tlz_PermissionSetsSelector extends fflib_SObjectSelector implements tlz_IPermissionSetsSelector{
	private static Map<String, Id> idByName;

	global static tlz_PermissionSetsSelector newInstance(){
		return (tlz_PermissionSetsSelector)Application.Selector.newInstance(PermissionSet.SObjectType);
	}

	global override List<SObjectField> getSObjectFieldList(){
		return new List<SObjectField>{
			PermissionSet.Id,
			PermissionSet.Name
		};
	}

	global override SObjectType getSObjectType(){
		return PermissionSet.SObjectType;
	}

	global Map<String, Id> mapIdByName(){
		if(idByName == null){
			idByName = new Map<String, Id>();
			for(PermissionSet permissionSet : Database.query(newQueryFactory().toSOQL()))
				idByName.put(permissionSet.Name, permissionSet.Id);
		}
		return idByName;
	}
}