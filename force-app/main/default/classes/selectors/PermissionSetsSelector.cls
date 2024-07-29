public inherited sharing class PermissionSetsSelector extends fflib_SObjectSelector implements IPermissionSetsSelector{
	private static Map<String, Id> idByName;

	public static PermissionSetsSelector newInstance(){
		return (PermissionSetsSelector)Application.Selector.newInstance(PermissionSet.SObjectType);
	}

	public List<SObjectField> getSObjectFieldList(){
		return new List<SObjectField>{
			PermissionSet.Id,
			PermissionSet.Name
		};
	}

	public SObjectType getSObjectType(){
		return PermissionSet.SObjectType;
	}

	public Map<String, Id> mapIdByName(){
		if(idByName == null){
			idByName = new Map<String, Id>();
			for(PermissionSet permissionSet : Database.query(newQueryFactory().toSOQL()))
				idByName.put(permissionSet.Name, permissionSet.Id);
		}
		return idByName;
	}
}