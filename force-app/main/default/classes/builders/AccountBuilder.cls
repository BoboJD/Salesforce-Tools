@IsTest
public inherited sharing class AccountBuilder extends SObjectBuilder{

	private AccountBuilder(){
		super();
	}

	private SObjectType getSObjectType(){
		return Account.SObjectType;
	}

	public Account build(){
		return (Account)buildRecord();
	}

	public static AccountBuilder newAccount(String name){
		return new AccountBuilder()
			.withName(name);
	}

	public static AccountBuilder newAccount(){
		return newAccount('TestAccount');
	}

	public AccountBuilder withName(String name){
		setFieldValue(Account.Name, name);
		return this;
	}
}