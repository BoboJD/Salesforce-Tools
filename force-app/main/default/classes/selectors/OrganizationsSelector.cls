public inherited sharing class OrganizationsSelector extends fflib_SObjectSelector implements IOrganizationsSelector{

	public static IOrganizationsSelector newInstance(){
		return (IOrganizationsSelector)Application.Selector.newInstance(Organization.SObjectType);
	}

	public List<SObjectField> getSObjectFieldList() {
		return new List<SObjectField>{
			Organization.IsSandbox
		};
	}

	public SObjectType getSObjectType(){
		return Organization.SObjectType;
	}

	public List<Organization> selectAll(){
		return Database.query(newQueryFactory(false, false, true).toSOQL());
	}
}