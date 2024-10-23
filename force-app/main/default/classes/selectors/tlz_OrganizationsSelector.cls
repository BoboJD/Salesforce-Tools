global inherited sharing class tlz_OrganizationsSelector extends fflib_SObjectSelector implements tlz_IOrganizationsSelector{

	global static tlz_IOrganizationsSelector newInstance(){
		return (tlz_IOrganizationsSelector)Application.Selector.newInstance(Organization.SObjectType);
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