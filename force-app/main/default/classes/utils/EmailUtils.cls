global class EmailUtils{

	global static String getDomain(String email){
		if(String.isNotBlank(email)){
			List<String> parts = email.split('@');
			if(parts.size() > 1)
				return parts[1];
		}
		return '';
	}
}