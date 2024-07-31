import LightningDatatable from 'lightning/datatable';
import numberWithWarning from './numberWithWarning.html';
import currencyWithWarning from './currencyWithWarning.html';
import textWithWarning from './textWithWarning.html';

export default class Datatable extends LightningDatatable{
	static customTypes = {
		numberWithWarning: {
			template: numberWithWarning,
			standardCellLayout: true,
			typeAttributes: [
				'displayWarning',
				'warningMessage'
			]
		},
		currencyWithWarning: {
			template: currencyWithWarning,
			standardCellLayout: true,
			typeAttributes: [
				'displayWarning',
				'warningMessage',
				'currencyCode'
			]
		},
		textWithWarning: {
			template: textWithWarning,
			standardCellLayout: true,
			typeAttributes: [
				'displayWarning',
				'warningMessage'
			]
		}
	};
}