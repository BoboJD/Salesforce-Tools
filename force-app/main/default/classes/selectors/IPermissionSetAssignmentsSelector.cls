global interface IPermissionSetAssignmentsSelector extends fflib_ISObjectSelector{
	Map<Id, List<PermissionSetAssignment>> mapByUserId(Set<Id> userIds);
}