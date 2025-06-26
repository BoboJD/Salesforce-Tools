@IsTest
private class MessagingServiceTest{

	@IsTest
	static void prepareFileAttachmentShouldReturnFileAttachment(){
		String fileName = 'fileName';
		Blob body = Blob.valueOf('Test');

		Test.startTest();
		Messaging.EmailFileAttachment fileAttachment = MessagingService.prepareFileAttachment(fileName, body);
		Test.stopTest();

		Assert.equals(fileName, fileAttachment.getFileName());
		Assert.equals(body, fileAttachment.getBody());
	}

	@IsTest
	static void newSingleEmailMessageShouldAddOneEmailToEmailLists(){
		Test.startTest();
		MessagingService.newSingleEmailMessage();
		Test.stopTest();

		Assert.equals(1, MessagingServiceImpl.emails.size());
	}

	@IsTest
	static void setTargetObjectIdShouldModifyTargetObjectIdOnLastEmailAdded(){
		Id targetObjectId = fflib_IDGenerator.generate(Schema.Contact.SObjectType);

		MessagingService.newSingleEmailMessage();

		Test.startTest();
		MessagingService.setTargetObjectId(targetObjectId);
		Test.stopTest();

		Assert.equals(targetObjectId, MessagingServiceImpl.emails[0].getTargetObjectId());
	}

	@IsTest
	static void setWhatIdShouldModifyWhatIdOnLastEmailAdded(){
		Id whatId = fflib_IDGenerator.generate(Schema.Account.SObjectType);

		MessagingService.newSingleEmailMessage();

		Test.startTest();
		MessagingService.setWhatId(whatId);
		Test.stopTest();

		Assert.equals(whatId, MessagingServiceImpl.emails[0].getWhatId());
	}

	@IsTest
	static void setOrgWideEmailAddressInProductionShouldModifyOrgWideEmailAddressOnLastEmailAdded(){
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		tlz_IOrganizationsSelector organizationsSelectorMock = new Mocks.tlz_OrganizationsSelector(mocks);
		tlz_IOrgWideEmailAddressesSelector orgWideEmailAddressesSelectorMock = new Mocks.tlz_OrgWideEmailAddressesSelector(mocks);

		Organization organization = (Organization)TestUtils.setReadableFields(new Organization(), new Map<SObjectField, Object>{
			Schema.Organization.IsSandbox => false
		});

		OrgWideEmailAddress orgWideEmailAddress = new OrgWideEmailAddress(
			Id = fflib_IDGenerator.generate(Schema.OrgWideEmailAddress.SObjectType),
			Address = 'toto@totot.fr'
		);

		mocks.startStubbing();
		mocks.when(organizationsSelectorMock.sObjectType()).thenReturn(Schema.Organization.SObjectType);
		mocks.when(organizationsSelectorMock.selectAll()).thenReturn(new List<Organization>{organization});
		mocks.when(orgWideEmailAddressesSelectorMock.sObjectType()).thenReturn(Schema.OrgWideEmailAddress.SObjectType);
		mocks.when(orgWideEmailAddressesSelectorMock.selectByAddress(orgWideEmailAddress.Address)).thenReturn(orgWideEmailAddress);
		mocks.stopStubbing();

		Application.Selector.setMock(organizationsSelectorMock);
		Application.Selector.setMock(orgWideEmailAddressesSelectorMock);

		MessagingService.newSingleEmailMessage();

		Test.startTest();
		MessagingService.setOrgWideEmailAddressId(orgWideEmailAddress.Address);
		Test.stopTest();

		((tlz_IOrganizationsSelector)mocks.verify(organizationsSelectorMock)).selectAll();
		((tlz_IOrgWideEmailAddressesSelector)mocks.verify(orgWideEmailAddressesSelectorMock)).selectByAddress(orgWideEmailAddress.Address);

		Assert.equals(orgWideEmailAddress.Id, MessagingServiceImpl.emails[0].getOrgWideEmailAddressId());
	}

	@IsTest
	static void setOrgWideEmailAddressInSandboxShouldModifyOrgWideEmailAddressOnLastEmailAdded(){
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		tlz_IOrganizationsSelector organizationsSelectorMock = new Mocks.tlz_OrganizationsSelector(mocks);
		tlz_IOrgWideEmailAddressesSelector orgWideEmailAddressesSelectorMock = new Mocks.tlz_OrgWideEmailAddressesSelector(mocks);

		Organization organization = (Organization)TestUtils.setReadableFields(new Organization(), new Map<SObjectField, Object>{
			Schema.Organization.IsSandbox => true
		});

		OrgWideEmailAddress orgWideEmailAddress = new OrgWideEmailAddress(
			Id = fflib_IDGenerator.generate(Schema.OrgWideEmailAddress.SObjectType),
			Address = 'toto@totot.fr'
		);

		mocks.startStubbing();
		mocks.when(organizationsSelectorMock.sObjectType()).thenReturn(Schema.Organization.SObjectType);
		mocks.when(organizationsSelectorMock.selectAll()).thenReturn(new List<Organization>{organization});
		mocks.when(orgWideEmailAddressesSelectorMock.sObjectType()).thenReturn(Schema.OrgWideEmailAddress.SObjectType);
		mocks.when(orgWideEmailAddressesSelectorMock.selectByAddress(orgWideEmailAddress.Address)).thenReturn(orgWideEmailAddress);
		mocks.stopStubbing();

		Application.Selector.setMock(organizationsSelectorMock);
		Application.Selector.setMock(orgWideEmailAddressesSelectorMock);

		MessagingService.newSingleEmailMessage();

		Test.startTest();
		MessagingService.setOrgWideEmailAddressId(orgWideEmailAddress.Address);
		Test.stopTest();

		((tlz_IOrganizationsSelector)mocks.verify(organizationsSelectorMock)).selectAll();
		((tlz_IOrgWideEmailAddressesSelector)mocks.verify(orgWideEmailAddressesSelectorMock, 0)).selectByAddress(orgWideEmailAddress.Address);

		Assert.isNull(MessagingServiceImpl.emails[0].getOrgWideEmailAddressId());
	}

	@IsTest
	static void setOrgWideEmailAddressWithAddressNotFoundShouldThrowError(){
		fflib_ApexMocks mocks = new fflib_ApexMocks();
		tlz_IOrganizationsSelector organizationsSelectorMock = new Mocks.tlz_OrganizationsSelector(mocks);

		Organization organization = (Organization)TestUtils.setReadableFields(new Organization(), new Map<SObjectField, Object>{
			Schema.Organization.IsSandbox => false
		});

		mocks.startStubbing();
		mocks.when(organizationsSelectorMock.sObjectType()).thenReturn(Schema.Organization.SObjectType);
		mocks.when(organizationsSelectorMock.selectAll()).thenReturn(new List<Organization>{organization});
		mocks.stopStubbing();

		Application.Selector.setMock(organizationsSelectorMock);

		MessagingService.newSingleEmailMessage();

		Test.startTest();
		String errorMessage;
		try{
			MessagingService.setOrgWideEmailAddressId('toto@totot.fr');
		}catch(Exception e){
			errorMessage = e.getMessage();
		}
		Test.stopTest();

		((tlz_IOrganizationsSelector)mocks.verify(organizationsSelectorMock)).selectAll();

		Assert.messageContains(errorMessage, 'OrgWideEmailAddress "toto@totot.fr" not found.');
	}

	@IsTest
	static void setToAddressShouldModifyToAddressesOnLastEmailAdded(){
		String toAddress = 'test@test.fr';

		MessagingService.newSingleEmailMessage();

		Test.startTest();
		MessagingService.setToAddress(toAddress);
		Test.stopTest();

		Assert.equals(new List<String>{toAddress}, MessagingServiceImpl.emails[0].getToAddresses());
	}

	@IsTest
	static void setToAddressesWithSetOfStringShouldModifyToAddressesOnLastEmailAdded(){
		Set<String> toAddresses = new Set<String>{'test@test.fr'};

		MessagingService.newSingleEmailMessage();

		Test.startTest();
		MessagingService.setToAddresses(toAddresses);
		Test.stopTest();

		Assert.equals(new List<String>(toAddresses), MessagingServiceImpl.emails[0].getToAddresses());
	}

	@IsTest
	static void setToAddressesShouldModifyToAddressesOnLastEmailAdded(){
		List<String> toAddresses = new List<String>{'test@test.fr'};

		MessagingService.newSingleEmailMessage();

		Test.startTest();
		MessagingService.setToAddresses(toAddresses);
		Test.stopTest();

		Assert.equals(toAddresses, MessagingServiceImpl.emails[0].getToAddresses());
	}

	@IsTest
	static void setCcAddressesShouldModifyCcAddressesOnLastEmailAdded(){
		List<String> ccAddresses = new List<String>{'test@test.fr'};

		MessagingService.newSingleEmailMessage();

		Test.startTest();
		MessagingService.setCcAddresses(ccAddresses);
		Test.stopTest();

		Assert.equals(ccAddresses, MessagingServiceImpl.emails[0].getCcAddresses());
	}

	@IsTest
	static void setBccAddressShouldModifyBccAddressesOnLastEmailAdded(){
		String bccAddress = 'test@test.fr';

		MessagingService.newSingleEmailMessage();

		Test.startTest();
		MessagingService.setBccAddress(bccAddress);
		Test.stopTest();

		Assert.equals(new List<String>{bccAddress}, MessagingServiceImpl.emails[0].getBccAddresses());
	}

	@IsTest
	static void setBccAddressesShouldModifyBccAddressesOnLastEmailAdded(){
		List<String> bccAddresses = new List<String>{'test@test.fr'};

		MessagingService.newSingleEmailMessage();

		Test.startTest();
		MessagingService.setBccAddresses(bccAddresses);
		Test.stopTest();

		Assert.equals(bccAddresses, MessagingServiceImpl.emails[0].getBccAddresses());
	}

	@IsTest
	static void setSubjectShouldModifySubjectOnLastEmailAdded(){
		String subject = 'sujet';

		MessagingService.newSingleEmailMessage();

		Test.startTest();
		MessagingService.setSubject(subject);
		Test.stopTest();

		Assert.equals(subject, MessagingServiceImpl.emails[0].getSubject());
	}

	@IsTest
	static void setHtmlBodyShouldModifyHtmlBodyOnLastEmailAdded(){
		String htmlBody = '<html>';

		MessagingService.newSingleEmailMessage();

		Test.startTest();
		MessagingService.setHtmlBody(htmlBody);
		Test.stopTest();

		Assert.equals(htmlBody, MessagingServiceImpl.emails[0].getHtmlBody());
	}

	@IsTest
	static void setSaveAsActivityShouldModifySaveAsActivityOnLastEmailAdded(){
		Boolean saveAsActivity = true;

		MessagingService.newSingleEmailMessage();

		Test.startTest();
		MessagingService.setSaveAsActivity(saveAsActivity);
		Test.stopTest();

		Assert.equals(saveAsActivity, MessagingServiceImpl.emails[0].getSaveAsActivity());
	}

	@IsTest
	static void setUseSignatureShouldModifyUseSignatureOnLastEmailAdded(){
		Boolean useSignature = true;

		MessagingService.newSingleEmailMessage();

		Test.startTest();
		MessagingService.setUseSignature(useSignature);
		Test.stopTest();

		Assert.equals(useSignature, MessagingServiceImpl.emails[0].getUseSignature());
	}

	@IsTest
	static void setFileAttachmentsShouldModifyFileAttachmentsOnLastEmailAdded(){
		List<Messaging.EmailFileAttachment> emailFileAttachments = new List<Messaging.EmailFileAttachment>{
			new Messaging.EmailFileAttachment()
		};

		MessagingService.newSingleEmailMessage();

		Test.startTest();
		MessagingService.setFileAttachments(emailFileAttachments);
		Test.stopTest();

		Assert.equals(emailFileAttachments, MessagingServiceImpl.emails[0].getFileAttachments());
	}

	@IsTest
	static void setSenderDisplayNameShouldModifySenderDisplayNameOnLastEmailAdded(){
		String senderDisplayName = 'toto';

		MessagingService.newSingleEmailMessage();

		Test.startTest();
		MessagingService.setSenderDisplayName(senderDisplayName);
		Test.stopTest();

		Assert.equals(senderDisplayName, MessagingServiceImpl.emails[0].getSenderDisplayName());
	}

	@IsTest
	static void setReplyToShouldModifyReplyToOnLastEmailAdded(){
		String replyTo = 'toto';

		MessagingService.newSingleEmailMessage();

		Test.startTest();
		MessagingService.setReplyTo(replyTo);
		Test.stopTest();

		Assert.equals(1, MessagingServiceImpl.emails.size());
		Assert.equals(replyTo, MessagingServiceImpl.emails[0].getReplyTo());
	}

	@IsTest
	static void sendEmailsShouldSendListOfEmailsThenClearIt(){
		MessagingService.newSingleEmailMessage();

		Test.startTest();
		List<Messaging.SendEmailResult> emailResults = MessagingService.sendEmails();
		Test.stopTest();

		Assert.isNotNull(emailResults);
		Assert.equals(0, MessagingServiceImpl.emails.size());
	}
}