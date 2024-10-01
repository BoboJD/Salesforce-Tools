global inherited sharing class tlz_ContentDocumentLinks extends fflib_SObjectDomain implements tlz_IContentDocumentLinks{

	global tlz_ContentDocumentLinks(List<ContentDocumentLink> contentDocumentLinks){
		super(contentDocumentLinks);
	}

	global override void onBeforeInsert(){
		resetStoredData();
		ContentDocumentLinkShareType.handleInsert(this).setShareTypeIAndVisiblityAll();
	}

	global override void onAfterInsert(){
		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new List<SObjectType>{ ContentVersion.SObjectType });
		ContentDocumentLinkRecord.handleInsert(this, uow).updateRecordIdIfEmpty();
		uow.commitWork();
	}

	private void resetStoredData(){
		ContentDocumentLinkShareType.storedContentDocumentById = null;
	}

	global class Constructor implements fflib_SObjectDomain.IConstructable{
		global fflib_SObjectDomain construct(List<SObject> sObjects){
			return new tlz_ContentDocumentLinks(sObjects);
		}
	}
}