public class ExceptionUtils{

	public static Boolean isCustom(Exception e){
		return e instanceof CustomException;
	}

	public static Boolean isDuplicatesDetected(Exception e){
		return e.getMessage().contains(ExceptionConstants.DUPLICATES_DETECTED);
	}

	public static Boolean isRestrictedPicklist(Exception e){
		return e.getMessage().contains(ExceptionConstants.INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST);
	}

	public static Boolean isRestrictedPicklist(Exception e, SObjectField picklist){
		return isRestrictedPicklist(e) && e.getMessage().contains(SObjectFieldUtils.getFieldApiName(picklist));
	}

	public static Boolean isUnknown(Exception e){
		return e.getMessage().contains(ExceptionConstants.UNKNOWN);
	}

	public static Boolean isValidationRule(Exception e){
		return e.getMessage().contains(ExceptionConstants.FIELD_CUSTOM_VALIDATION);
	}
}