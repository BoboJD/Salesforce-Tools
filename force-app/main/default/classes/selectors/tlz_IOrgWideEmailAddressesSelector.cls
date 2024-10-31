global interface tlz_IOrgWideEmailAddressesSelector extends fflib_ISObjectSelector{
	Map<String, OrgWideEmailAddress> mapAll();
	OrgWideEmailAddress selectByAddress(String address);
}