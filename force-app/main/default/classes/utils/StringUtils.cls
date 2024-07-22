public inherited sharing class StringUtils{

	public static String convertNullToEmpty(String value){
		return String.isBlank(value) ? Constants.EMPTY : value;
	}

	public static String formatNumber(Decimal nb){
		if(nb == null) return null;
		String str = String.valueOf(nb);
		str = str.replace('.', ',');
		List<String> strSplit = str.split(',');
		String strToReturn = '';
		List<String> leftStr = strSplit[0].split('');
		for(Integer i = 0; i < leftStr.size(); i++){
			Integer indexReverted = leftStr.size() - 1 - i;
			strToReturn += leftStr[i];
			if(Math.mod(indexReverted, 3) == 0)
				strToReturn += ' ';
		}
		strToReturn = strToReturn.removeEnd(' ');
		if(strSplit.size() > 1)
			strToReturn += ',' + strSplit[1];
		return strToReturn;
	}

	public static String formatCurrency(Decimal nb){
		return nb == null ? null : formatNumber(nb) + ' €';
	}

	public static String formatPercent(Decimal nb){
		return nb == null ? null : formatNumber(nb) + ' %';
	}

	public static Boolean isMobilePhone(String phoneNumber){
		return phoneNumber.startsWith('06') || phoneNumber.startsWith('07') || phoneNumber.startsWith('+336') || phoneNumber.startsWith('+337') || phoneNumber.startsWith('336') || phoneNumber.startsWith('337');
	}

	public static String setMobilePhoneInternational(String mobilePhone){
		if(String.isNotBlank(mobilePhone)){
			mobilePhone = mobilePhone.replace('+', '');
			if(mobilePhone.startsWith('00'))
				mobilePhone = mobilePhone.replaceFirst('00', '');
			if(mobilePhone.startsWith('0'))
				mobilePhone = mobilePhone.replaceFirst('0', '33');
			if(mobilePhone.startsWith('33'))
				return mobilePhone;
			return mobilePhone;
		}
		return null;
	}

	public static Boolean containsAtLeastOneOfTheTerms(String textToVerify, List<String> terms){
		if(String.isBlank(textToVerify) || terms == null) return false;
		for(String term : terms){
			if(String.isBlank(term)) continue;
			if(textToVerify.containsIgnoreCase(term))
				return true;
		}
		return false;
	}
}