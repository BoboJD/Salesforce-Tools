@IsTest
global inherited sharing class ContactBuilder extends SObjectBuilder{

	private ContactBuilder(){
		super();
	}

	private SObjectType getSObjectType(){
		return Contact.SObjectType;
	}

	global Contact build(){
		return (Contact)buildRecord();
	}

	global static ContactBuilder newContact(){
		return new ContactBuilder()
			.withFirstName('Contact')
			.withLastName('Test')
			.withMobilePhone('0606060606')
			.withEmail('toto@toto.fr');
	}

	global ContactBuilder withEmail(String email){
		setFieldValue(Contact.Email, email);
		return this;
	}

	global ContactBuilder withFirstName(String firstName){
		setFieldValue(Contact.FirstName, firstName);
		return this;
	}

	global ContactBuilder withLastName(String lastName){
		setFieldValue(Contact.LastName, lastName);
		return this;
	}

	global ContactBuilder withMobilePhone(String mobilePhone){
		setFieldValue(Contact.MobilePhone, mobilePhone);
		return this;
	}
}