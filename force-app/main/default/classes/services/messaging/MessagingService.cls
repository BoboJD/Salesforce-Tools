@SuppressWarnings('PMD.CognitiveComplexity')
global inherited sharing class MessagingService{

	private static IMessagingService service;

	global static Messaging.EmailFileAttachment prepareFileAttachment(String fileName, Blob body){
		return service().prepareFileAttachment(fileName, body);
	}

	global static void newSingleEmailMessage(){
		service().newSingleEmailMessage();
	}

	global static void setTargetObjectId(Id targetObjectId){
		service().setTargetObjectId(targetObjectId);
	}

	global static void setWhatId(Id whatId){
		service().setWhatId(whatId);
	}

	global static void setOrgWideEmailAddressId(String orgWideEmailAddress){
		service().setOrgWideEmailAddressId(orgWideEmailAddress);
	}

	global static void setToAddress(String toAddress){
		service().setToAddress(toAddress);
	}

	global static void setToAddresses(Set<String> toAddresses){
		service().setToAddresses(toAddresses);
	}

	global static void setToAddresses(List<String> toAddresses){
		service().setToAddresses(toAddresses);
	}

	global static void setCcAddresses(List<String> ccAddresses){
		service().setCcAddresses(ccAddresses);
	}

	global static void setBccAddress(String bccAddress){
		service().setBccAddress(bccAddress);
	}

	global static void setBccAddresses(List<String> bccAddresses){
		service().setBccAddresses(bccAddresses);
	}

	global static void setSubject(String subject){
		service().setSubject(subject);
	}

	global static void setHtmlBody(String htmlBody){
		service().setHtmlBody(htmlBody);
	}

	global static void setSaveAsActivity(Boolean saveAsActivity){
		service().setSaveAsActivity(saveAsActivity);
	}

	global static void setUseSignature(Boolean useSignature){
		service().setUseSignature(useSignature);
	}

	global static void setFileAttachments(List<Messaging.EmailFileAttachment> emailFileAttachments){
		service().setFileAttachments(emailFileAttachments);
	}

	global static void setSenderDisplayName(String senderDisplayName){
		service().setSenderDisplayName(senderDisplayName);
	}

	global static void setReplyTo(String replyTo){
		service().setReplyTo(replyTo);
	}

	global static List<Messaging.SendEmailResult> sendEmails(){
		return service().sendEmails();
	}

	private static IMessagingService service(){
		if(service == null)
			service = (IMessagingService)Application.Service.newInstance(IMessagingService.class);
		return service;
	}
}