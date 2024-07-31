import { LightningElement } from 'lwc';

export default class DisablePullToRefresh extends LightningElement{

	connectedCallback(){
		this.disablePullToRefresh();
	}

	disablePullToRefresh(){
		this.dispatchEvent(new CustomEvent('updatescrollsettings', {
			detail: {
				isPullToRefreshEnabled: false
			},
			bubbles: true,
			composed: true
		}));
	}
}