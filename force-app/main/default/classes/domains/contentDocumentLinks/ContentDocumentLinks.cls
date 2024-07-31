public inherited sharing class ContentDocumentLinks extends fflib_SObjectDomain implements IContentDocumentLinks{

	public ContentDocumentLinks(List<ContentDocumentLink> contentDocumentLinks){
		super(contentDocumentLinks);
	}

	public override void onBeforeInsert(){
		resetStoredData();
		ContentDocumentLinkShareType.handleInsert(this).setShareTypeIAndVisiblityAll();
	}

	public override void onAfterInsert(){
		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new List<SObjectType>{ ContentVersion.SObjectType });
		ContentDocumentLinkRecord.handleInsert(this, uow).updateRecordIdIfEmpty();
		uow.commitWork();
	}

	private void resetStoredData(){
		ContentDocumentLinkShareType.storedContentDocumentById = null;
	}

	public class Constructor implements fflib_SObjectDomain.IConstructable{
		public fflib_SObjectDomain construct(List<SObject> sObjects){
			return new ContentDocumentLinks(sObjects);
		}
	}
}