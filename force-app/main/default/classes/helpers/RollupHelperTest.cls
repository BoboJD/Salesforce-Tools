@IsTest
private class RollupHelperTest{

	@IsTest
	static void testRollupHelper(){
		User standardUser = UserBuilder.newStandardUser().build();
		System.runAs(standardUser){
			Account acc = AccountBuilder.newAccount().build();

			List<Contact> contacts = new List<Contact>{
				new Contact(LastName = 'test1', AccountId = acc.Id, MailingStreet = '30 rue', MailingPostalCode = '33000', MailingCity = 'Bdx', Phone = '0505050505', Email = 'toto@toto.fr', MobilePhone = '0606060606'),
				new Contact(LastName = 'test2', AccountId = acc.Id, MailingStreet = '30 rue', MailingPostalCode = '33000', MailingCity = 'Bdx', Phone = '0505050505', MobilePhone = '0606060606'),
				new Contact(LastName = 'test3', AccountId = acc.Id, DoNotCall = true, MailingStreet = '30 rue', MailingPostalCode = '33000', MailingCity = 'Bdx', Phone = '0505050505', MobilePhone = '0606060606')
			};
			insert contacts;

			Test.startTest();
			RollupHelper rolls = new RollupHelper(contacts, Contact.AccountId);

			RollupHelper.Rollup countRollup = new RollupHelper.Rollup(Account.NumberOfEmployees);
			countRollup.addFilter(Contact.DoNotCall, RollupHelper.Operator.NOT_EQ, false);
			rolls.addRollup(countRollup);


			RollupHelper.Rollup concatRollup = new RollupHelper.Rollup(Account.Description, RollupHelper.Aggregation.CONCAT, Contact.LastName, ' - ', 'LastName');
			concatRollup.addFilter(Contact.DoNotCall, RollupHelper.Operator.EQ, false);
			rolls.addRollup(concatRollup);


			RollupHelper.Rollup maxRollup = new RollupHelper.Rollup(Account.Name, RollupHelper.Aggregation.MAX, Contact.LastName);
			maxRollup.addFilter(Contact.LastName, RollupHelper.Operator.CONTAINS, 'test');
			rolls.addRollup(maxRollup);

			RollupHelper.Rollup minRollup = new RollupHelper.Rollup(Account.AccountNumber, RollupHelper.Aggregation.MIN, Contact.LastName);
			minRollup.addFilter(Contact.LastName, RollupHelper.Operator.NOT_CONTAINS, 'abcd');
			rolls.addRollup(minRollup);

			rolls.process();
			Test.stopTest();

			acc = [SELECT Id, Name, AccountNumber, NumberOfEmployees, Description FROM Account WHERE Id = :acc.Id][0];

			Assert.equals(1, acc.NumberOfEmployees);
			Assert.equals('test1 - test2', acc.Description);
			Assert.equals('test3', acc.Name);
			Assert.equals('test1', acc.AccountNumber);
		}
	}
}