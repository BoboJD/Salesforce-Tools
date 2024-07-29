const sortBy = (field, reverse, primer) => {
	const key = primer
		? function(x){ return primer(x[field]); }
		: function(x){ return x[field]; };

	return function(a, b){
		let A = key(a);
		let B = key(b);
		return reverse * ((A > B) - (B > A));
	};
};

const sortArrayOfObject = (array, property, sortDirection='asc') => {
	const reverse = sortDirection !== 'asc' ? -1 : 1;
	return Object.assign([],
		array.sort(sortBy(property, reverse))
	);
};

export {
	sortArrayOfObject,
	sortBy
};