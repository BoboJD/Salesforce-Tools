public inherited sharing class ContentVersions extends fflib_SObjectDomain implements IContentVersions{

	public ContentVersions(List<ContentVersion> contentVersions){
		super(contentVersions);
	}

	public override void onBeforeInsert(){
		ContentVersionDefaultValue.handleInsert(this).setDefaultFieldValueBasedOnJSON();
	}

	public override void onAfterInsert(){
		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new List<SObjectType>{
			ContentVersion.SObjectType, ContentDocument.SObjectType, ContentDocumentLink.SObjectType
		});
		ContentVersionRecordRelation.handleInsert(this, uow).handleRecordIdIfFilled();
		ContentVersionPrivateFile.handleInsert(this, uow).handlePrivateFile();
		uow.commitWork();
	}

	public class Constructor implements fflib_SObjectDomain.IConstructable{
		public fflib_SObjectDomain construct(List<SObject> sObjects){
			return new ContentVersions(sObjects);
		}
	}
}