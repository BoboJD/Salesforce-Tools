global class ExceptionUtils{

	global static Boolean isCustom(Exception e){
		return e instanceof CustomException;
	}

	global static Boolean isDuplicatesDetected(Exception e){
		return e.getMessage().contains(ExceptionConstants.DUPLICATES_DETECTED);
	}

	global static Boolean isRestrictedPicklist(Exception e){
		return e.getMessage().contains(ExceptionConstants.INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST);
	}

	global static Boolean isRestrictedPicklist(Exception e, SObjectField picklist){
		return isRestrictedPicklist(e) && e.getMessage().contains(SObjectFieldUtils.getFieldApiName(picklist));
	}

	global static Boolean isUnknown(Exception e){
		return e.getMessage().contains(ExceptionConstants.UNKNOWN);
	}

	global static Boolean isValidationRule(Exception e){
		return e.getMessage().contains(ExceptionConstants.FIELD_CUSTOM_VALIDATION);
	}
}