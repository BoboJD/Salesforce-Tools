global inherited sharing class tlz_OrgWideEmailAddressesSelector extends fflib_SObjectSelector implements tlz_IOrgWideEmailAddressesSelector{
	private static Map<String, OrgWideEmailAddress> recordByEmail;

	global static tlz_IOrgWideEmailAddressesSelector newInstance(){
		return (tlz_IOrgWideEmailAddressesSelector)Application.Selector.newInstance(OrgWideEmailAddress.SObjectType);
	}

	global override List<SObjectField> getSObjectFieldList(){
		return new List<SObjectField>{
			OrgWideEmailAddress.Id,
			OrgWideEmailAddress.Address
		};
	}

	global override SObjectType getSObjectType(){
		return OrgWideEmailAddress.SObjectType;
	}

	global Map<String, OrgWideEmailAddress> mapAll(){
		if(recordByEmail == null){
			recordByEmail = new Map<String, OrgWideEmailAddress>();
			for(OrgWideEmailAddress orgWideEmailAddress : Database.query(newQueryFactory(false, false, true).toSOQL()))
				recordByEmail.put(orgWideEmailAddress.Address, orgWideEmailAddress);
		}
		return recordByEmail;
	}

	global OrgWideEmailAddress selectByAddress(String address){
		OrgWideEmailAddress orgWideEmailAddress;
		if(String.isNotBlank(address)){
			Map<String, OrgWideEmailAddress> recordByEmail = mapAll();
			orgWideEmailAddress = recordByEmail.get(address);
		}
		return orgWideEmailAddress;
	}
}