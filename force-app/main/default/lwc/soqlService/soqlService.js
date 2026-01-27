import queryApex from '@salesforce/apex/SoqlServiceController.query';
import countQueryApex from '@salesforce/apex/SoqlServiceController.countQuery';
import getSObjectListApex from '@salesforce/apex/SoqlServiceController.getSObjectList';
import getFieldsForSObjectApex from '@salesforce/apex/SoqlServiceController.getFieldsForSObject';

const query = queryString => {
	return queryApex({ queryString });
};

const countQuery = queryString => {
	return countQueryApex({ queryString });
};

const getSObjectList = () => {
	return getSObjectListApex();
};

const getFieldsForSObject = sObjectApiName => {
	return getFieldsForSObjectApex({ sObjectApiName });
};

export {
	query,
	countQuery,
	getSObjectList,
	getFieldsForSObject
};