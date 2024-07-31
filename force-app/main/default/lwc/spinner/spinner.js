import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import loadingFox from '@salesforce/resourceUrl/loadingFox';
import USER_ID from '@salesforce/user/Id';
import PHOTO_CHARGEMENT_FIELD from '@salesforce/schema/User.LoadingPicture__c';
import ROTATION_FIELD from '@salesforce/schema/User.ActivateRotation__c';

export default class Spinner extends LightningElement{
	@api hideByDefault = false;
	@api size;
	@api isFixed = false;
	@api top = 0;
	loadingFox = loadingFox;
	displaySpinner = true;
	infiniteRotate = false;

	@wire(getRecord, {
		recordId: USER_ID,
		fields: [PHOTO_CHARGEMENT_FIELD, ROTATION_FIELD]
	})wireuser({ data }){
		if(data){
			if(data.fields.LoadingPicture__c && data.fields.LoadingPicture__c.value){
				this.loadingFox = data.fields.LoadingPicture__c.value;
				if(data.fields.ActivateRotation__c)
					this.infiniteRotate = data.fields.ActivateRotation__c.value;
			}
		}
	}

	get className(){
		return 'loading-fox'
			+ (this.size ? ' fox-size__'+ this.size : '')
			+ (this.isFixed ? ' fox-fixed' : '')
			+ (this.infiniteRotate ? ' infinite-rotate' : '');
	}

	get style(){
		return `top: ${this.top}px`;
	}

	connectedCallback(){
		if(this.hideByDefault) this.displaySpinner = false;
	}

	@api
	show(){
		this.displaySpinner = true;
	}

	@api
	hide(){
		this.displaySpinner = false;
	}
}