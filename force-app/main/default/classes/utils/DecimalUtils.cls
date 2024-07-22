public inherited sharing class DecimalUtils{

	public static Decimal round(Decimal theNumber){
		return round(theNumber, 2);
	}
	
	public static Decimal round(Decimal theNumber, Integer decimalPlaces){
		return returnsZeroIfNull(theNumber).setScale(decimalPlaces, RoundingMode.HALF_UP);
	}

	public static Decimal roundDown(Decimal theNumber){
		return roundDown(theNumber, 2);
	}

	public static Decimal roundDown(Decimal theNumber, Integer decimalPlaces){
		Decimal factor = Decimal.valueOf(10).pow(decimalPlaces);
		Decimal mutipliedNumber = returnsZeroIfNull(theNumber) * factor;
		return mutipliedNumber.round(RoundingMode.DOWN) / factor;
	}

	public static Decimal returnsZeroIfNull(Decimal value){
		return value != null ? value : 0;
	}

	public static Boolean notGreaterThan0(Decimal value){
		return !(value > 0);
	}

	public static Decimal parse(String decimalString){
		return String.isBlank(decimalString) ? 0 : Decimal.valueOf(removeExtraCharactersInString(decimalString));
	}

	private static String removeExtraCharactersInString(String decimalString){
		return decimalString.replace('%', '').replace(',', '.').replaceAll(' ', '');
	}
}