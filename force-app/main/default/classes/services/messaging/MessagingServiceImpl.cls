@SuppressWarnings('PMD.CognitiveComplexity')
global inherited sharing class MessagingServiceImpl implements IMessagingService{

	@TestVisible
	private static List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

	private Messaging.SingleEmailMessage lastEmail(){
		return !emails.isEmpty() ? emails[emails.size() - 1] : null;
	}

	global Messaging.EmailFileAttachment prepareFileAttachment(String fileName, Blob body){
		Messaging.EmailFileAttachment fileAttachment = new Messaging.EmailFileAttachment();
		fileAttachment.setFileName(fileName);
		fileAttachment.setBody(body);
		return fileAttachment;
	}

	global void newSingleEmailMessage(){
		emails.add(new Messaging.SingleEmailMessage());
	}

	global void setTargetObjectId(Id targetObjectId){
		lastEmail()?.setTargetObjectId(targetObjectId);
	}

	global void setWhatId(Id whatId){
		lastEmail()?.setWhatId(whatId);
	}

	global void setOrgWideEmailAddressId(String orgWideEmailAddress){
		List<Organization> orgs = tlz_OrganizationsSelector.newInstance().selectAll();
		if(!orgs.isEmpty() && !orgs[0].IsSandbox){
			OrgWideEmailAddress emailAddress = tlz_OrgWideEmailAddressesSelector.newInstance().selectByAddress(orgWideEmailAddress);
			if(emailAddress == null)
				throw new MessagingException('OrgWideEmailAddress "'+orgWideEmailAddress+'" not found.');
			lastEmail()?.setOrgWideEmailAddressId(emailAddress.Id);
		}
	}

	global void setToAddress(String toAddress){
		setToAddresses(new List<String>{toAddress});
	}

	global void setToAddresses(Set<String> toAddresses){
		setToAddresses(new List<String>(toAddresses));
	}

	global void setToAddresses(List<String> toAddresses){
		lastEmail()?.setToAddresses(toAddresses);
	}

	global void setCcAddresses(List<String> ccAddresses){
		lastEmail()?.setCcAddresses(ccAddresses);
	}

	global void setBccAddress(String bccAddress){
		setBccAddresses(new List<String>{bccAddress});
	}

	global void setBccAddresses(List<String> bccAddresses){
		lastEmail()?.setBccAddresses(bccAddresses);
	}

	global void setSubject(String subject){
		lastEmail()?.setSubject(subject);
	}

	global void setHtmlBody(String htmlBody){
		lastEmail()?.setHtmlBody(htmlBody);
	}

	global void setSaveAsActivity(Boolean saveAsActivity){
		lastEmail()?.setSaveAsActivity(saveAsActivity);
	}

	global void setUseSignature(Boolean useSignature){
		lastEmail()?.setUseSignature(useSignature);
	}

	global void setFileAttachments(List<Messaging.EmailFileAttachment> emailFileAttachments){
		lastEmail()?.setFileAttachments(emailFileAttachments);
	}

	global void setSenderDisplayName(String senderDisplayName){
		lastEmail()?.setSenderDisplayName(senderDisplayName);
	}

	global void setReplyTo(String replyTo){
		lastEmail()?.setReplyTo(replyTo);
	}

	global List<Messaging.SendEmailResult> sendEmails(){
		List<Messaging.SendEmailResult> sendEmailResults;
		if(!emails.isEmpty())
			sendEmailResults = Test.isRunningTest() ? new List<Messaging.SendEmailResult>() : Messaging.sendEmail(emails);
		emails.clear();
		return sendEmailResults;
	}

	private class MessagingException extends Exception{}
}