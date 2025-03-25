import publishRefreshEvent from '@salesforce/apex/RefreshEventPublisherController.publishRefreshEvent';

export const refreshView = () => {
	publishRefreshEvent();
};