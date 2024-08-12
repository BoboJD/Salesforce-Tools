global inherited sharing class OrganizationsSelector extends fflib_SObjectSelector implements IOrganizationsSelector{

	global static IOrganizationsSelector newInstance(){
		return (IOrganizationsSelector)Application.Selector.newInstance(Organization.SObjectType);
	}

	global override List<SObjectField> getSObjectFieldList() {
		return new List<SObjectField>{
			Organization.IsSandbox
		};
	}

	global override SObjectType getSObjectType(){
		return Organization.SObjectType;
	}

	global List<Organization> selectAll(){
		return Database.query(newQueryFactory(false, false, true).toSOQL());
	}
}