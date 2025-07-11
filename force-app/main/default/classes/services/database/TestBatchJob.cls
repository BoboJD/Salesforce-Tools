global with sharing class TestBatchJob implements Database.Batchable<SObject>{

	global Database.QueryLocator start(Database.BatchableContext bc){
		return Database.getQueryLocator('SELECT Id FROM Account');
	}

	global void execute(Database.BatchableContext bc, List<Account> accounts){}

	global void finish(Database.BatchableContext bc){}
}