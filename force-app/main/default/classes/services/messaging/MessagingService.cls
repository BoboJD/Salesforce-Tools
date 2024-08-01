@SuppressWarnings('PMD.CognitiveComplexity')
public inherited sharing class MessagingService{

	private static IMessagingService service;

	public static Messaging.EmailFileAttachment prepareFileAttachment(String fileName, Blob body){
		return service().prepareFileAttachment(fileName, body);
	}

	public static void newSingleEmailMessage(){
		service().newSingleEmailMessage();
	}

	public static void setTargetObjectId(Id targetObjectId){
		service().setTargetObjectId(targetObjectId);
	}

	public static void setWhatId(Id whatId){
		service().setWhatId(whatId);
	}

	public static void setToAddress(String toAddress){
		service().setToAddress(toAddress);
	}

	public static void setToAddresses(Set<String> toAddresses){
		service().setToAddresses(toAddresses);
	}

	public static void setToAddresses(List<String> toAddresses){
		service().setToAddresses(toAddresses);
	}

	public static void setCcAddresses(List<String> ccAddresses){
		service().setCcAddresses(ccAddresses);
	}

	public static void setBccAddress(String bccAddress){
		service().setBccAddress(bccAddress);
	}

	public static void setBccAddresses(List<String> bccAddresses){
		service().setBccAddresses(bccAddresses);
	}

	public static void setSubject(String subject){
		service().setSubject(subject);
	}

	public static void setHtmlBody(String htmlBody){
		service().setHtmlBody(htmlBody);
	}

	public static void setSaveAsActivity(Boolean saveAsActivity){
		service().setSaveAsActivity(saveAsActivity);
	}

	public static void setUseSignature(Boolean useSignature){
		service().setUseSignature(useSignature);
	}

	public static void setFileAttachments(List<Messaging.EmailFileAttachment> emailFileAttachments){
		service().setFileAttachments(emailFileAttachments);
	}

	public static void setSenderDisplayName(String senderDisplayName){
		service().setSenderDisplayName(senderDisplayName);
	}

	public static void setReplyTo(String replyTo){
		service().setReplyTo(replyTo);
	}

	public static List<Messaging.SendEmailResult> sendEmails(){
		return service().sendEmails();
	}

	private static IMessagingService service(){
		if(service == null)
			service = (IMessagingService)Application.Service.newInstance(IMessagingService.class);
		return service;
	}
}