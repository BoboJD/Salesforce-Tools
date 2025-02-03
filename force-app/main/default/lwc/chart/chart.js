import { api, LightningElement } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import { recursiveDeepCopy } from 'c/utils';
import chartJs from '@salesforce/resourceUrl/chartJs';

export default class Chart extends LightningElement{
	@api config;
	isInitalized = false;
	chart;
	@api height;

	get chartStyle(){
		if(this.height)
			return `height: ${this.height}px`;
		return null;
	}

	@api
	reloadChart(){
		this.chart.destroy();
		this.initChart();
	}

	renderedCallback(){
		if(!this.isInitalized) this.loadScriptsThenInitChart();
	}

	loadScriptsThenInitChart(){
		loadScript(this, chartJs).then(() => {
			this.isInitalized = true;
			this.initChart();
		});
	}

	initChart(){
		const ctx = this.template.querySelector('canvas').getContext('2d');
		this.chart = new window.Chart(ctx, recursiveDeepCopy(this.config));
	}
}