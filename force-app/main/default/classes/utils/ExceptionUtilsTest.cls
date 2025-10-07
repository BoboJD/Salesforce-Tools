@IsTest
private class ExceptionUtilsTest{

	@IsTest
	static void isCustomWithSfErrorShouldReturnFalse(){
		Test.startTest();
		Boolean isCustomException;
		try{
			String toto;
			toto.startsWith('attempt to dereference a null object here !');
		}catch(Exception e){
			isCustomException = ExceptionUtils.isCustom(e);
		}
		Test.stopTest();

		Assert.isFalse(isCustomException);
	}

	@IsTest
	static void isCustomWithCustomExceptionShouldReturnTrue(){
		Test.startTest();
		Boolean isCustomException = ExceptionUtils.isCustom(new CustomException('toto'));
		Test.stopTest();

		Assert.isTrue(isCustomException);
	}

	@IsTest
	static void isDuplicatesDetectedWithFieldCustomValidationExceptionShouldReturnFalse(){
		Test.startTest();
		Boolean isDuplicatesDetected = ExceptionUtils.isDuplicatesDetected(new CustomException('toto'+ExceptionConstants.FIELD_CUSTOM_VALIDATION+': tutu'));
		Test.stopTest();

		Assert.isFalse(isDuplicatesDetected);
	}

	@IsTest
	static void isDuplicatesDetectedWithDuplicatesDetectedExceptionShouldReturnTrue(){
		Test.startTest();
		Boolean isDuplicatesDetected = ExceptionUtils.isDuplicatesDetected(new CustomException('toto'+ExceptionConstants.DUPLICATES_DETECTED+': tutu'));
		Test.stopTest();

		Assert.isTrue(isDuplicatesDetected);
	}

	@IsTest
	static void isInvalidIdWithFieldCustomValidationExceptionShouldReturnFalse(){
		Test.startTest();
		Boolean isInvalidId = ExceptionUtils.isInvalidId(new CustomException('toto'+ExceptionConstants.FIELD_CUSTOM_VALIDATION+': tutu'));
		Test.stopTest();

		Assert.isFalse(isInvalidId);
	}

	@IsTest
	static void isInvalidIdWithInvalidIdFieldExceptionShouldReturnTrue(){
		Test.startTest();
		Boolean isInvalidId = ExceptionUtils.isInvalidId(new CustomException('toto'+ExceptionConstants.INVALID_ID_FIELD+': tutu'));
		Test.stopTest();

		Assert.isTrue(isInvalidId);
	}

	@IsTest
	static void isReadTimedOutWithFieldCustomValidationExceptionShouldReturnFalse(){
		Test.startTest();
		Boolean isReadTimedOut = ExceptionUtils.isReadTimedOut(new CustomException('toto'+ExceptionConstants.FIELD_CUSTOM_VALIDATION+': tutu'));
		Test.stopTest();

		Assert.isFalse(isReadTimedOut);
	}

	@IsTest
	static void isReadTimedOutWithReadTimedOutExceptionShouldReturnTrue(){
		Test.startTest();
		Boolean isReadTimedOut = ExceptionUtils.isReadTimedOut(new CustomException('toto'+ExceptionConstants.READ_TIMED_OUT+': tutu'));
		Test.stopTest();

		Assert.isTrue(isReadTimedOut);
	}

	@IsTest
	static void isRestrictedPicklistWithFieldCustomValidationExceptionShouldReturnFalse(){
		Test.startTest();
		Boolean isRestrictedPicklist = ExceptionUtils.isRestrictedPicklist(new CustomException('toto'+ExceptionConstants.FIELD_CUSTOM_VALIDATION+': tutu'));
		Test.stopTest();

		Assert.isFalse(isRestrictedPicklist);
	}

	@IsTest
	static void isRestrictedPicklistWithRestrictedPicklistExceptionShouldReturnTrue(){
		Test.startTest();
		Boolean isRestrictedPicklist = ExceptionUtils.isRestrictedPicklist(new CustomException('toto'+ExceptionConstants.INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST+': tutu'));
		Test.stopTest();

		Assert.isTrue(isRestrictedPicklist);
	}

	@IsTest
	static void isRestrictedPicklistWithPicklistInParamsShouldReturnTrue(){
		Test.startTest();
		Boolean isRestrictedPicklist = ExceptionUtils.isRestrictedPicklist(new CustomException('toto'+ExceptionConstants.INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST+': [tlz__FormFactor__c]'), Log__c.FormFactor__c);
		Test.stopTest();

		Assert.isTrue(isRestrictedPicklist);
	}

	@IsTest
	static void isUnableToLockRowWithRestrictedPicklistExceptionShouldReturnFalse(){
		Test.startTest();
		Boolean isUnableToLockRow = ExceptionUtils.isUnableToLockRow(new CustomException('toto'+ExceptionConstants.INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST+': tutu'));
		Test.stopTest();

		Assert.isFalse(isUnableToLockRow);
	}

	@IsTest
	static void isUnableToLockRowWithUnableToLockRowExceptionShouldReturnTrue(){
		Test.startTest();
		Boolean isUnableToLockRow = ExceptionUtils.isUnableToLockRow(new CustomException('toto'+ExceptionConstants.UNABLE_TO_LOCK_ROW+': tutu'));
		Test.stopTest();

		Assert.isTrue(isUnableToLockRow);
	}

	@IsTest
	static void isUnknownWithRestrictedPicklistExceptionShouldReturnFalse(){
		Test.startTest();
		Boolean isUnknown = ExceptionUtils.isUnknown(new CustomException('toto'+ExceptionConstants.INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST+': tutu'));
		Test.stopTest();

		Assert.isFalse(isUnknown);
	}

	@IsTest
	static void isUnknownWithUnknownExceptionShouldReturnTrue(){
		Test.startTest();
		Boolean isUnknown = ExceptionUtils.isUnknown(new CustomException('toto'+ExceptionConstants.UNKNOWN+': tutu'));
		Test.stopTest();

		Assert.isTrue(isUnknown);
	}

	@IsTest
	static void isValidationRuleWithRestrictedPicklistExceptionShouldReturnFalse(){
		Test.startTest();
		Boolean isValidationRule = ExceptionUtils.isValidationRule(new CustomException('toto'+ExceptionConstants.INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST+': tutu'));
		Test.stopTest();

		Assert.isFalse(isValidationRule);
	}

	@IsTest
	static void isValidationRuleWithFieldCustomValidationExceptionShouldReturnTrue(){
		Test.startTest();
		Boolean isValidationRule = ExceptionUtils.isValidationRule(new CustomException('toto'+ExceptionConstants.FIELD_CUSTOM_VALIDATION+': tutu'));
		Test.stopTest();

		Assert.isTrue(isValidationRule);
	}
}