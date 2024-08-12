@IsTest
global inherited sharing class UserBuilder extends SObjectBuilder{

	private static Map<String, Profile> profileByName{
		get{
			if(profileByName == null){
				profileByName = new Map<String, Profile>();
				for(Profile profile : [SELECT Id, Name FROM Profile])
					profileByName.put(profile.Name, profile);
			}
			return profileByName;
		}set;
	}

	private UserBuilder(){
		super();
	}

	global override SObjectType getSObjectType(){
		return User.SObjectType;
	}

	global User build(){
		return (User)buildRecord();
	}

	global static UserBuilder newUser(){
		String orgId = UserInfo.getOrganizationId();
		String uniqueName = orgId + TestUtils.generateUniqueName();
		return new UserBuilder()
			.withEmail(uniqueName + '@testxx' + orgId + '.org')
			.withUsername(uniqueName + '@testxx' + orgId + '.org')
			.withEmailEncodingKey('ISO-8859-1')
			.withAlias(uniqueName.substring(18, 23))
			.withTimeZoneSidKey('Europe/Paris')
			.withLocaleSidKey('fr_FR_EURO')
			.withLanguageLocaleKey('fr');
	}

	global static UserBuilder newChatterFreeUser(){
		return newUser()
			.withProfile(profileByName.get(ProfileConstants.CHATTER_FREE_USER))
			.withFirstName('Chatter Free')
			.withLastName('User');
	}


	global static UserBuilder newStandardUser(){
		return newUser()
			.withProfile(profileByName.get(ProfileConstants.STANDARD_USER))
			.withFirstName('Standard')
			.withLastName('User');
	}

	global UserBuilder withAdmin(Boolean admin){
		setFieldValue(User.Admin__c, admin);
		return this;
	}

	global UserBuilder withAlias(String alias){
		setFieldValue(User.Alias, alias);
		return this;
	}

	global UserBuilder withEmail(String email){
		setFieldValue(User.Email, email);
		return this;
	}

	global UserBuilder withEmailEncodingKey(String emailEncodingKey){
		setFieldValue(User.EmailEncodingKey, emailEncodingKey);
		return this;
	}

	global UserBuilder withFirstName(String firstName){
		setFieldValue(User.FirstName, firstName);
		return this;
	}

	global UserBuilder withLanguageLocaleKey(String languageLocaleKey){
		setFieldValue(User.LanguageLocaleKey, languageLocaleKey);
		return this;
	}

	global UserBuilder withLastName(String lastName){
		setFieldValue(User.LastName, lastName);
		return this;
	}

	global UserBuilder withLocaleSidKey(String localeSidKey){
		setFieldValue(User.LocaleSidKey, localeSidKey);
		return this;
	}

	global UserBuilder withProfile(Profile profile){
		setFieldValue(User.ProfileId, profile.Id);
		return this;
	}

	global UserBuilder withTimeZoneSidKey(String timeZoneSidKey){
		setFieldValue(User.TimeZoneSidKey, timeZoneSidKey);
		return this;
	}

	global UserBuilder withUsername(String username){
		setFieldValue(User.Username, username);
		return this;
	}
}