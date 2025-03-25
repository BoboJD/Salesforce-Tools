import { NavigationMixin } from 'lightning/navigation';
import { getFocusedTabInfo, openSubtab, closeTab } from 'lightning/platformWorkspaceApi';

export const openInSubtab = async(cmp, pageReference, closeCurrentTab = false) => {
	if(cmp.isConsoleNavigation){
		const { parentTabId, tabId } = await getFocusedTabInfo();
		await openSubtab(parentTabId || tabId, { pageReference, focus: true });
		if(closeCurrentTab && parentTabId){
			await closeTab(cmp.enclosingTabId);
		}
	}else{
		cmp[NavigationMixin.Navigate](pageReference);
	}
};

export const navigateToRecord = async(cmp, recordId, closeCurrentTab = false) => {
	await openInSubtab(cmp, {
		type: 'standard__recordPage',
		attributes: { recordId, actionName: 'view' }
	}, closeCurrentTab);
};

export const navigateToURL = async(cmp, url, closeCurrentTab = false) => {
	await openInSubtab(cmp, {
		type: 'standard__webPage',
		attributes: { url }
	}, closeCurrentTab);
};

export const navigateToRelationshipPage = async(cmp, recordId, relationshipApiName, closeCurrentTab = false) => {
	await openInSubtab(cmp, {
		type: 'standard__recordRelationshipPage',
		attributes: { recordId, relationshipApiName, actionName: 'view' }
	}, closeCurrentTab);
};