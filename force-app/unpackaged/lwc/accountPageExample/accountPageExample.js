import { LightningElement, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { CurrentPageReference } from 'lightning/navigation';
import { IsConsoleNavigation, EnclosingTabId, setTabLabel, setTabIcon } from 'lightning/platformWorkspaceApi';
import { navigateToRecord } from 'c/utils';

export default class AccountPageExample extends NavigationMixin(LightningElement){
	@wire(IsConsoleNavigation) isConsoleNavigation;
	@wire(EnclosingTabId) enclosingTabId;
	accountId;
	pageReady = false;

	@wire(CurrentPageReference)
	getStateParameters(currentPageReference){
		if(currentPageReference)
			this.accountId = currentPageReference.state.tlz__accountId;
		if(!this.isConsoleNavigation && this.connected)
			this.reloadCurrentPage(currentPageReference);
	}

	reloadCurrentPage(currentPageReference){
		this.connected = false;
		this[NavigationMixin.GenerateUrl](currentPageReference).then(url => { window.location.replace(url); });
	}

	get steps(){
		return ['Page 1', 'Page 2', 'Last Page'];
	}

	get types(){
		return [
			{ value: 'A', label: 'A' },
			{ value: 'B', label: 'B' },
			{ value: 'C', label: 'C' },
			{ value: 'D', label: 'D' },
			{ value: 'E', label: 'E' },
			{ value: 'F', label: 'F' },
			{ value: 'G', label: 'G' },
			{ value: 'H', label: 'H' }
		];
	}

	get page(){
		return this.template.querySelector('c-page');
	}

	connectedCallback(){
		this.connected = true;
		if(this.isConsoleNavigation)
			this.changeTabLabelAndIcon();
	}

	changeTabLabelAndIcon(){
		setTabLabel(this.enclosingTabId, 'Page Test');
		setTabIcon(this.enclosingTabId, 'utility:insert_template', { iconAlt: 'Page Test' });
	}

	renderedCallback(){
		if(!this.pageReady)
			this.pageReady = !!this.page;
	}

	doNext(){
		if(this.page.isFirstStep)
			this.page.incrementStep();
		else if(this.page.isSecondStep)
			this.page.incrementStep();
	}

	doCancel(){
		navigateToRecord(this, this.accountId, true);
	}
}