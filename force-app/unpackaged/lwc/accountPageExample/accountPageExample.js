import { LightningElement, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { CurrentPageReference } from 'lightning/navigation';
import { IsConsoleNavigation, EnclosingTabId, getFocusedTabInfo, setTabLabel, setTabIcon, openSubtab, closeTab } from 'lightning/platformWorkspaceApi';
import { displaySpinner } from 'c/utils';

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
		if(this.page.isFirstStep){
			this.page.incrementStep();
		}else if(this.page.isSecondStep){
			this.page.incrementStep();
		}
	}

	doCancel(){
		displaySpinner(this);
		this.navigateToRecord(this.accountId);
	}

	navigateToRecord(recordId){
		this.openSubtab({
			type: 'standard__recordPage',
			attributes: { recordId, actionName: 'view' }
		});
	}

	async openSubtab(pageReference){
		if(this.isConsoleNavigation){
			const { parentTabId } = await getFocusedTabInfo();
			await openSubtab(parentTabId, { pageReference, focus: true });
			await closeTab(this.enclosingTabId);
		}else{
			this[NavigationMixin.Navigate](pageReference);
		}
	}
}