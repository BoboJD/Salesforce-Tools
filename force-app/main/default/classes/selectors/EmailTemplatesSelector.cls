global inherited sharing class EmailTemplatesSelector extends fflib_SObjectSelector implements IEmailTemplatesSelector{

	global static IEmailTemplatesSelector newInstance(){
		return (IEmailTemplatesSelector)Application.Selector.newInstance(EmailTemplate.SObjectType);
	}

	global override List<SObjectField> getSObjectFieldList(){
		return new List<SObjectField>{
			EmailTemplate.Id,
			EmailTemplate.HtmlValue,
			EmailTemplate.Subject
		};
	}

	global override SObjectType getSObjectType(){
		return EmailTemplate.SObjectType;
	}

	global EmailTemplate selectByDeveloperName(String developerName){
		EmailTemplate emailTemplate;
		if(String.isNotBlank(developerName)){
			List<EmailTemplate> emailTemplates = Database.query(newQueryFactory().setCondition('DeveloperName = :developerName').toSOQL());
			if(!emailTemplates.isEmpty())
				emailTemplate = emailTemplates[0];
		}
		return emailTemplate;
	}
}