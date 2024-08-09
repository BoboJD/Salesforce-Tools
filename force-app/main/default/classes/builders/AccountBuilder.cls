@IsTest
global inherited sharing class AccountBuilder extends SObjectBuilder{

	private AccountBuilder(){
		super();
	}

	private SObjectType getSObjectType(){
		return Account.SObjectType;
	}

	global Account build(){
		return (Account)buildRecord();
	}

	global static AccountBuilder newAccount(String name){
		return new AccountBuilder()
			.withName(name);
	}

	global static AccountBuilder newAccount(){
		return newAccount('TestAccount');
	}

	global AccountBuilder withName(String name){
		setFieldValue(Account.Name, name);
		return this;
	}
}