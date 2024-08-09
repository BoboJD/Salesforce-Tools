global class IntegerUtils{

	global static Integer returnsZeroIfNull(Integer value){
		return value != null ? value : 0;
	}
}