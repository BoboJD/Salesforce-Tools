public with sharing class TestBatchJob implements Database.Batchable<SObject>{

	public Database.QueryLocator start(Database.BatchableContext bc){
		return Database.getQueryLocator('SELECT Id FROM Account');
	}

	public void execute(Database.BatchableContext bc, List<Account> accounts){}

	public void finish(Database.BatchableContext bc){}
}