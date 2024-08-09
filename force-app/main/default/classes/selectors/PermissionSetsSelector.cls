global inherited sharing class PermissionSetsSelector extends fflib_SObjectSelector implements IPermissionSetsSelector{
	private static Map<String, Id> idByName;

	global static PermissionSetsSelector newInstance(){
		return (PermissionSetsSelector)Application.Selector.newInstance(PermissionSet.SObjectType);
	}

	global List<SObjectField> getSObjectFieldList(){
		return new List<SObjectField>{
			PermissionSet.Id,
			PermissionSet.Name
		};
	}

	global SObjectType getSObjectType(){
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