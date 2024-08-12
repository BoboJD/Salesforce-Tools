global inherited sharing class DecimalUtils{

	global static Decimal round(Decimal theNumber){
		return round(theNumber, 2);
	}

	global static Decimal round(Decimal theNumber, Integer decimalPlaces){
		return returnsZeroIfNull(theNumber).setScale(decimalPlaces, RoundingMode.HALF_UP);
	}

	global static Decimal roundDown(Decimal theNumber){
		return roundDown(theNumber, 2);
	}

	global static Decimal roundDown(Decimal theNumber, Integer decimalPlaces){
		Decimal factor = Decimal.valueOf(10).pow(decimalPlaces);
		Decimal mutipliedNumber = returnsZeroIfNull(theNumber) * factor;
		return mutipliedNumber.round(RoundingMode.DOWN) / factor;
	}

	global static Decimal returnsZeroIfNull(Decimal value){
		return value != null ? value : 0;
	}

	global static Boolean notGreaterThan0(Decimal value){
		return !(value > 0);
	}

	global static Decimal parse(String decimalString){
		return String.isBlank(decimalString) ? 0 : Decimal.valueOf(removeExtraCharactersInString(decimalString));
	}

	private static String removeExtraCharactersInString(String decimalString){
		return decimalString.replace('%', '').replace(',', '.').replaceAll(' ', '');
	}
}