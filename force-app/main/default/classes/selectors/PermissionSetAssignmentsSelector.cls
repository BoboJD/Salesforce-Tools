global inherited sharing class PermissionSetAssignmentsSelector extends fflib_SObjectSelector implements IPermissionSetAssignmentsSelector{

	global static PermissionSetAssignmentsSelector newInstance(){
		return (PermissionSetAssignmentsSelector)Application.Selector.newInstance(PermissionSetAssignment.SObjectType);
	}

	global override List<SObjectField> getSObjectFieldList(){
		return new List<SObjectField>{
			PermissionSetAssignment.Id,
			PermissionSetAssignment.AssigneeId
		};
	}

	global override SObjectType getSObjectType(){
		return PermissionSetAssignment.SObjectType;
	}

	global Map<Id, List<PermissionSetAssignment>> mapByUserId(Set<Id> userIds){
		Map<Id, List<PermissionSetAssignment>> permissionSetAssignmentsByUserId = new Map<Id, List<PermissionSetAssignment>>();
		if(!userIds.isEmpty()){
			fflib_QueryFactory queryFactory = newQueryFactory();
			new PermissionSetsSelector().configureQueryFactoryFields(queryFactory, 'PermissionSet');
			for(PermissionSetAssignment permissionSetAssignment : Database.query(queryFactory.setCondition('AssigneeId IN :userIds').toSOQL())){
				if(!permissionSetAssignmentsByUserId.containsKey(permissionSetAssignment.AssigneeId))
					permissionSetAssignmentsByUserId.put(permissionSetAssignment.AssigneeId, new List<PermissionSetAssignment>());
				permissionSetAssignmentsByUserId.get(permissionSetAssignment.AssigneeId).add(permissionSetAssignment);
			}
		}
		return permissionSetAssignmentsByUserId;
	}
}