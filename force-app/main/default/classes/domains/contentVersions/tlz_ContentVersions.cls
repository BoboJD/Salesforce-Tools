global inherited sharing class tlz_ContentVersions extends fflib_SObjectDomain implements tlz_IContentVersions{

	global tlz_ContentVersions(List<ContentVersion> contentVersions){
		super(contentVersions);
	}

	global override void onBeforeInsert(){
		ContentVersionDefaultValue.handleInsert(this).setDefaultFieldValueBasedOnJSON();
	}

	global override void onAfterInsert(){
		fflib_ISObjectUnitOfWork uow = Application.UnitOfWork.newInstance(new List<SObjectType>{
			ContentVersion.SObjectType, ContentDocument.SObjectType, ContentDocumentLink.SObjectType
		});
		ContentVersionRecordRelation.handleInsert(this, uow).handleRecordIdIfFilled();
		ContentVersionPrivateFile.handleInsert(this, uow).handlePrivateFile();
		uow.commitWork();
	}

	global class Constructor implements fflib_SObjectDomain.IConstructable{
		global fflib_SObjectDomain construct(List<SObject> sObjects){
			return new tlz_ContentVersions(sObjects);
		}
	}
}