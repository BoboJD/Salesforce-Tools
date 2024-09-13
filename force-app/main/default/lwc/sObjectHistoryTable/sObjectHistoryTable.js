import { LightningElement, api, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import BEFORE_FIELD from '@salesforce/schema/SObjectHistory__c.Before__c';
import AFTER_FIELD from '@salesforce/schema/SObjectHistory__c.After__c';
import SOBJECT_FIELD from '@salesforce/schema/SObjectHistory__c.SObject__c';

export default class SObjectHistoryTable extends LightningElement{
	@api recordId;
	@track record;
	objectApiName;

	@wire(getRecord, { recordId: '$recordId', fields: [BEFORE_FIELD, AFTER_FIELD, SOBJECT_FIELD] })
	wiredRecord({ data }){
		if(data)
			this.objectApiName = data.fields[SOBJECT_FIELD.fieldApiName].value;
		this.record = data;
	}

	@wire(getObjectInfo, { objectApiName: '$objectApiName' })
		objectInfo;

	get isLoaded(){
		return this.objectInfo?.data && this.record;
	}

	get data(){
		const data = [];
		const sobjectBefore = JSON.parse(this.record.fields[BEFORE_FIELD.fieldApiName].value);
		const sobjectAfter = JSON.parse(this.record.fields[AFTER_FIELD.fieldApiName].value);
		for(const field in this.objectInfo.data.fields){
			let allowed = field.endsWith('__c') || field === 'Name' || field === 'OwnerId';
			if(!allowed)
				continue;
			if(sobjectAfter[field] !== sobjectBefore[field]){
				data.push({
					field: this.objectInfo.data.fields[field].label,
					before: sobjectBefore[field],
					after: sobjectAfter[field]
				});
			}
		}
		return data;
	}

	get columns(){
		return [
			{ label: 'Field', fieldName: 'field' },
			{ label: 'Before', fieldName: 'before' },
			{ label: 'After', fieldName: 'after' }
		];
	}
}