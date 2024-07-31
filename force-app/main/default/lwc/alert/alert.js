import { LightningElement, api } from 'lwc';
import label from './labels';

export default class Alert extends LightningElement{
	@api theme = 'basic';
	@api message;
	@api closable = false;
	label = label;

	get className(){
		return 'slds-notify slds-notify_alert' + (this.hasVariation ? ` slds-alert_${this.theme}`: '');
	}

	get iconName(){
		return `utility:${this.theme}`;
	}

	get hasVariation(){
		return this.theme && this.theme !== 'basic';
	}
}