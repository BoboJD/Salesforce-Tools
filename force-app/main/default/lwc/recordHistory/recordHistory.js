import{ LightningElement, api, wire } from 'lwc';
import { hideSpinner } from 'c/utils';
import { loadStyle } from 'lightning/platformResourceLoader';
import recordHistoryCss from '@salesforce/resourceUrl/recordHistoryCss';
import getHistory from '@salesforce/apex/RecordHistoryController.getHistory';
import label from './labels';

const COLUMNS = [
	{
		label: label.HistoryNumber,
		fieldName: 'recordLink',
		type: 'url',
		typeAttributes: {
			label: { fieldName: 'Name' },
			target: '_blank'
		}
	},
	{
		label: label.CreatedBy,
		fieldName: 'userLink',
		type: 'url',
		typeAttributes: {
			label: { fieldName: 'tlz__CreatedByName__c' },
			target: '_blank'
		}
	},
	{
		label: label.CreatedAt,
		fieldName: 'CreatedDate',
		type: 'date',
		typeAttributes: {
			year: 'numeric',
			month: 'short',
			day: '2-digit',
			hour: '2-digit',
			minute: '2-digit'
		}
	}
];

export default class RecordHistory extends LightningElement{
	@api recordId;
	@api numberOfRows = 4;
	label = label;
	columns = COLUMNS;
	allRecords = [];
	visibleRecords = [];
	currentIndex = 0;

	@wire(getHistory,{ recordId: '$recordId' })
	wiredRecords({ data }){
		if(data){
			this.allRecords = data.map(row => ({
				...row,
				recordLink: `/lightning/r/${row.Id}/view`,
				userLink: `/lightning/r/${row.CreatedById}/view`
			}));
			this.visibleRecords = this.allRecords.slice(0, this.numberOfRows);
			this.currentIndex = this.numberOfRows;
		}
		hideSpinner(this);
	}

	connectedCallback(){
		loadStyle(this, recordHistoryCss);
	}

	handleLoadMore(){
		const nextIndex = this.currentIndex + this.numberOfRows;
		const moreRecords = this.allRecords.slice(this.currentIndex, nextIndex);
		this.visibleRecords = [...this.visibleRecords, ...moreRecords];
		this.currentIndex = nextIndex;
	}

	get showLoadMore(){
		return this.currentIndex < this.allRecords.length;
	}
}