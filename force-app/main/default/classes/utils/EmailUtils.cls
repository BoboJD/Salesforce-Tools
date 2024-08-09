global class EmailUtils{

	global static String getDomain(String email){
		if(String.isNotBlank(email))
			return email.split('@')[1];
		return '';
	}
}