import { api, LightningElement } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import { recursiveDeepCopy } from 'c/utils';
import chartJs from '@salesforce/resourceUrl/chartJs';

export default class Chart extends LightningElement{
	@api config;
	@api height;
	isInitialized = false;
	chart;

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
		if(!this.isInitialized) this.loadScriptsThenInitChart();
	}

	loadScriptsThenInitChart(){
		this.isInitialized = true;
		loadScript(this, chartJs).then(() => {
			this.initChart();
		});
	}

	initChart(){
		const ctx = this.template.querySelector('canvas').getContext('2d');
		this.chart = new window.Chart(ctx, recursiveDeepCopy(this.config));
	}
}