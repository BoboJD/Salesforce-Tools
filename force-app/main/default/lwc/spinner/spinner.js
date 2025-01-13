import { LightningElement, api, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import loadingFox from '@salesforce/resourceUrl/loadingFox';
import USER_ID from '@salesforce/user/Id';
import LOADING_PICTURE_FIELD from '@salesforce/schema/User.LoadingPicture__c';
import ROTATION_FIELD from '@salesforce/schema/User.ActivateRotation__c';

export default class Spinner extends LightningElement{
	@api hideByDefault = false;
	@api size;
	@api isFixed = false;
	@api top = 0;
	@track spinner = {
		visible: true,
		picture: loadingFox,
		rotation: false
	};

	@wire(getRecord, {
		recordId: USER_ID,
		fields: [LOADING_PICTURE_FIELD, ROTATION_FIELD]
	})wireuser({ data }){
		if(data?.fields[LOADING_PICTURE_FIELD.fieldApiName]?.value){
			this.spinner.picture = data.fields[LOADING_PICTURE_FIELD.fieldApiName].value;
			if(data.fields[ROTATION_FIELD.fieldApiName])
				this.spinner.rotation = data.fields[ROTATION_FIELD.fieldApiName].value;
		}
	}

	get className(){
		return 'loading-fox'
			+ (this.size ? ' fox-size__'+ this.size : '')
			+ (this.isFixed ? ' fox-fixed' : '')
			+ (this.spinner.rotation ? ' infinite-rotate' : '');
	}

	get style(){
		return `top: ${this.top}px`;
	}

	connectedCallback(){
		if(this.hideByDefault) this.spinner.visible = false;
	}

	@api
	show(){
		this.spinner.visible = true;
	}

	@api
	hide(){
		this.spinner.visible = false;
	}
}