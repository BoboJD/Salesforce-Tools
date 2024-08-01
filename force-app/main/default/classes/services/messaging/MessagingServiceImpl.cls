@SuppressWarnings('PMD.CognitiveComplexity')
public inherited sharing class MessagingServiceImpl implements IMessagingService{

	@TestVisible
	private static List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

	private Messaging.SingleEmailMessage lastEmail(){
		return !emails.isEmpty() ? emails[emails.size() - 1] : null;
	}

	public Messaging.EmailFileAttachment prepareFileAttachment(String fileName, Blob body){
		Messaging.EmailFileAttachment fileAttachment = new Messaging.EmailFileAttachment();
		fileAttachment.setFileName(fileName);
		fileAttachment.setBody(body);
		return fileAttachment;
	}

	public void newSingleEmailMessage(){
		emails.add(new Messaging.SingleEmailMessage());
	}

	public void setTargetObjectId(Id targetObjectId){
		lastEmail()?.setTargetObjectId(targetObjectId);
	}

	public void setWhatId(Id whatId){
		lastEmail()?.setWhatId(whatId);
	}

	public void setToAddress(String toAddress){
		setToAddresses(new List<String>{toAddress});
	}

	public void setToAddresses(Set<String> toAddresses){
		setToAddresses(new List<String>(toAddresses));
	}

	public void setToAddresses(List<String> toAddresses){
		lastEmail()?.setToAddresses(toAddresses);
	}

	public void setCcAddresses(List<String> ccAddresses){
		lastEmail()?.setCcAddresses(ccAddresses);
	}

	public void setBccAddress(String bccAddress){
		setBccAddresses(new List<String>{bccAddress});
	}

	public void setBccAddresses(List<String> bccAddresses){
		lastEmail()?.setBccAddresses(bccAddresses);
	}

	public void setSubject(String subject){
		lastEmail()?.setSubject(subject);
	}

	public void setHtmlBody(String htmlBody){
		lastEmail()?.setHtmlBody(htmlBody);
	}

	public void setSaveAsActivity(Boolean saveAsActivity){
		lastEmail()?.setSaveAsActivity(saveAsActivity);
	}

	public void setUseSignature(Boolean useSignature){
		lastEmail()?.setUseSignature(useSignature);
	}

	public void setFileAttachments(List<Messaging.EmailFileAttachment> emailFileAttachments){
		lastEmail()?.setFileAttachments(emailFileAttachments);
	}

	public void setSenderDisplayName(String senderDisplayName){
		lastEmail()?.setSenderDisplayName(senderDisplayName);
	}

	public void setReplyTo(String replyTo){
		lastEmail()?.setReplyTo(replyTo);
	}

	public List<Messaging.SendEmailResult> sendEmails(){
		List<Messaging.SendEmailResult> sendEmailResults;
		if(!emails.isEmpty())
			sendEmailResults = Test.isRunningTest() ? new List<Messaging.SendEmailResult>() : Messaging.sendEmail(emails);
		emails.clear();
		return sendEmailResults;
	}
}