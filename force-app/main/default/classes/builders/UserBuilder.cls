@IsTest
public inherited sharing class UserBuilder extends SObjectBuilder{

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

	private SObjectType getSObjectType(){
		return User.SObjectType;
	}

	public User build(){
		return (User)buildRecord();
	}

	public static UserBuilder newUser(){
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

	public static UserBuilder newChatterFreeUser(){
		return newUser()
			.withProfile(profileByName.get(ProfileConstants.CHATTER_FREE_USER))
			.withFirstName('Chatter Free')
			.withLastName('User');
	}

	public UserBuilder withAlias(String alias){
		setFieldValue(User.Alias, alias);
		return this;
	}

	public UserBuilder withEmail(String email){
		setFieldValue(User.Email, email);
		return this;
	}

	public UserBuilder withEmailEncodingKey(String emailEncodingKey){
		setFieldValue(User.EmailEncodingKey, emailEncodingKey);
		return this;
	}

	public UserBuilder withFirstName(String firstName){
		setFieldValue(User.FirstName, firstName);
		return this;
	}

	public UserBuilder withLanguageLocaleKey(String languageLocaleKey){
		setFieldValue(User.LanguageLocaleKey, languageLocaleKey);
		return this;
	}

	public UserBuilder withLastName(String lastName){
		setFieldValue(User.LastName, lastName);
		return this;
	}

	public UserBuilder withLocaleSidKey(String localeSidKey){
		setFieldValue(User.LocaleSidKey, localeSidKey);
		return this;
	}

	public UserBuilder withProfile(Profile profile){
		setFieldValue(User.ProfileId, profile.Id);
		return this;
	}

	public UserBuilder withTimeZoneSidKey(String timeZoneSidKey){
		setFieldValue(User.TimeZoneSidKey, timeZoneSidKey);
		return this;
	}

	public UserBuilder withUsername(String username){
		setFieldValue(User.Username, username);
		return this;
	}
}