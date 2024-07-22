@IsTest
private class TimeUtilsTest{

	@IsTest
	static void currentTimeIsInferiorToWithNullShouldReturnFalse(){
	  Test.startTest();
	  Boolean theValueAfter = TimeUtils.currentTimeIsInferiorTo(null);
	  Test.stopTest();

	  Assert.isFalse(theValueAfter);
	}

	@IsTest
	static void currentTimeIsInferiorToWithInferiorTimeShouldReturnTrue(){
	  Test.startTest();
	  Boolean theValueAfter = TimeUtils.currentTimeIsInferiorTo(Time.newInstance(9, 30, 0, 0));
	  Test.stopTest();

	  Assert.isTrue(theValueAfter);
	}

	@IsTest
	static void currentTimeIsSuperiorToWithNullShouldReturnFalse(){
	  Test.startTest();
	  Boolean theValueAfter = TimeUtils.currentTimeIsSuperiorTo(null);
	  Test.stopTest();

	  Assert.isFalse(theValueAfter);
	}

	@IsTest
	static void currentTimeIsSuperiorToWithSuperiorTimeShouldReturnTrue(){
	  Test.startTest();
	  Boolean theValueAfter = TimeUtils.currentTimeIsSuperiorTo(Time.newInstance(18, 0, 0, 0));
	  Test.stopTest();

	  Assert.isTrue(theValueAfter);
	}

	@IsTest
	static void formatShouldReturnAEmptyString(){
	  Test.startTest();
	  String theValueAfter = TimeUtils.format(null);
	  Test.stopTest();

	  Assert.equals('', theValueAfter);
	}

	@IsTest
	static void formatShouldReturnANonEmptyString(){
	  Test.startTest();
	  String theValueAfter = TimeUtils.format(Time.newInstance(10, 30, 0, 0));
	  Test.stopTest();

	  Assert.equals('10H30', theValueAfter);
	}
}