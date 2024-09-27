public with sharing class TestIterator implements Database.Batchable<CustomIterator>, Database.StateFul{
	public static Decimal numberOfLoop = 0;
	private List<CustomLoop> iterations;

	public TestIterator(List<CustomLoop> iterations){
		this.iterations = iterations;
	}

	public Iterable<CustomLoop> start(Database.BatchableContext bc){
		return (Iterable<CustomLoop>)iterations;
	}

	public void execute(Database.BatchableContext bc, List<CustomIterator> iterations){
		for(CustomLoop iteration : (List<CustomLoop>)iterations)
			numberOfLoop += 1;
	}

	public void finish(Database.BatchableContext bc){}

	public class CustomLoop extends CustomIterator{}
}