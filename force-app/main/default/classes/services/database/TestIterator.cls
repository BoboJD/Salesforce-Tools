global with sharing class TestIterator implements Database.Batchable<CustomIterator>, Database.StateFul{
	global static Decimal numberOfLoop = 0;
	private List<CustomLoop> iterations;

	global TestIterator(List<CustomLoop> iterations){
		this.iterations = iterations;
	}

	global Iterable<CustomLoop> start(Database.BatchableContext bc){
		return (Iterable<CustomLoop>)iterations;
	}

	global void execute(Database.BatchableContext bc, List<CustomIterator> iterations){
		for(CustomLoop iteration : (List<CustomLoop>)iterations)
			numberOfLoop += 1;
	}

	global void finish(Database.BatchableContext bc){}

	global class CustomLoop extends CustomIterator{}
}