@IsTest
public inherited sharing class ContactBuilder extends SObjectBuilder{

	private ContactBuilder(){
		super();
	}

	private SObjectType getSObjectType(){
		return Contact.SObjectType;
	}

	public Contact build(){
		return (Contact)buildRecord();
	}

	public static ContactBuilder newContact(){
		return new ContactBuilder()
			.withFirstName('Contact')
			.withLastName('Test')
			.withMobilePhone('0606060606')
			.withEmail('toto@toto.fr');
	}

	public ContactBuilder withEmail(String email){
		setFieldValue(Contact.Email, email);
		return this;
	}

	public ContactBuilder withFirstName(String firstName){
		setFieldValue(Contact.FirstName, firstName);
		return this;
	}

	public ContactBuilder withLastName(String lastName){
		setFieldValue(Contact.LastName, lastName);
		return this;
	}

	public ContactBuilder withMobilePhone(String mobilePhone){
		setFieldValue(Contact.MobilePhone, mobilePhone);
		return this;
	}
}