import { NavigationMixin } from 'lightning/navigation';
import { getFocusedTabInfo, openSubtab, closeTab, refreshTab } from 'lightning/platformWorkspaceApi';

export const openInSubtab = async(cmp, pageReference, closeCurrentTab = false, refreshParentTab = false) => {
	if(cmp.isConsoleNavigation){
		const { parentTabId, tabId } = await getFocusedTabInfo();
		await openSubtab(parentTabId || tabId, { pageReference, focus: true });
		if(refreshParentTab){
			await refreshTab(parentTabId || tabId);
		}
		if(closeCurrentTab && parentTabId){
			await closeTab(cmp.enclosingTabId);
		}
	}else if(closeCurrentTab){
		cmp[NavigationMixin.Navigate](pageReference);
	}else{
		cmp[NavigationMixin.GenerateUrl](pageReference).then(url => { window.open(url); });
	}
};

export const navigateToRecord = async(cmp, recordId, closeCurrentTab = false, refreshParentTab = false) => {
	await openInSubtab(cmp, {
		type: 'standard__recordPage',
		attributes: { recordId, actionName: 'view' }
	}, closeCurrentTab, refreshParentTab);
};

export const navigateToURL = async(cmp, url, closeCurrentTab = false, refreshParentTab = false) => {
	if(url.startsWith('http')){
		if(closeCurrentTab){
			window.location.replace(url);
		}else{
			window.open(url);
		}
	}else{
		await openInSubtab(cmp, {
			type: 'standard__webPage',
			attributes: { url }
		}, closeCurrentTab, refreshParentTab);
	}
};

export const navigateToRelationshipPage = async(cmp, recordId, relationshipApiName, closeCurrentTab = false, refreshParentTab = false) => {
	await openInSubtab(cmp, {
		type: 'standard__recordRelationshipPage',
		attributes: { recordId, relationshipApiName, actionName: 'view' }
	}, closeCurrentTab, refreshParentTab);
};

export const navigateToComponent = async(cmp, componentName, state, closeCurrentTab = false, refreshParentTab = false) => {
	await openInSubtab(cmp, {
		type: 'standard__component',
		attributes: { componentName },
		state
	}, closeCurrentTab, refreshParentTab);
};

export const previewFile = (cmp, selectedRecordId) => {
	cmp[NavigationMixin.Navigate]({
		type: 'standard__namedPage',
		attributes: {
			pageName: 'filePreview'
		},
		state: {
			selectedRecordId
		}
	});
};