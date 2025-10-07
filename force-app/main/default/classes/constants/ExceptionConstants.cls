global class ExceptionConstants{
	global static final String DUPLICATES_DETECTED = 'DUPLICATES_DETECTED';
	global static final String ENTITY_IS_DELETED = 'ENTITY_IS_DELETED';
	global static final String FIELD_CUSTOM_VALIDATION = 'FIELD_CUSTOM_VALIDATION_EXCEPTION';
	global static final String INVALID_ID_FIELD = 'INVALID_ID_FIELD';
	global static final String INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST = 'INVALID_OR_NULL_FOR_RESTRICTED_PICKLIST';
	global static final String READ_TIMED_OUT = 'Read timed out';
	global static final String UNABLE_TO_LOCK_ROW = 'UNABLE_TO_LOCK_ROW';
	global static final String UNKNOWN = 'UNKNOWN_EXCEPTION';
	@TestVisible private ExceptionConstants(){} // Fix for coverage
}