public interface IMessagingService{
	Messaging.EmailFileAttachment prepareFileAttachment(String fileName, Blob body);
	void newSingleEmailMessage();
	void setTargetObjectId(Id targetObjectId);
	void setWhatId(Id whatId);
	void setToAddress(String toAddress);
	void setToAddresses(Set<String> toAddresses);
	void setToAddresses(List<String> toAddresses);
	void setCcAddresses(List<String> ccAddresses);
	void setBccAddress(String bccAddress);
	void setBccAddresses(List<String> bccAddresses);
	void setSubject(String subject);
	void setHtmlBody(String htmlBody);
	void setSaveAsActivity(Boolean saveAsActivity);
	void setUseSignature(Boolean useSignature);
	void setFileAttachments(List<Messaging.EmailFileAttachment> emailFileAttachments);
	void setSenderDisplayName(String senderDisplayName);
	void setReplyTo(String replyTo);
	List<Messaging.SendEmailResult> sendEmails();
}