const FilterType = {
	CHECKBOX: 1,
	properties: {
		1: { name: 'checkbox', value: 1 }
	}
};

class FilterOption{
	label;
	type;
	options = [];
	value = [];

	constructor(label, type){
		this.label = label;
		this.type = type;
	}

	static newCheckbox(label){
		return new FilterOption(label, FilterType.CHECKBOX);
	}
}

export{
	FilterType,
	FilterOption
};