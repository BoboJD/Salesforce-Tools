const isEmpty = obj => {
	return obj === null || obj === undefined || obj === '';
};

const isEmptyObject = obj => {
	if(obj){
		for(let property in obj){
			if({}.hasOwnProperty.call(obj, property)){
				return false;
			}
		}
	}
	return true;
};

const arrayHasChanged = (arrayBefore, arrayAfter) => {
	let changes, i, itemBefore, itemAfter, j, len;
	changes = [];
	for(i = j = 0, len = arrayBefore.length; j < len; i = ++j){
		itemBefore = arrayBefore[i];
		itemAfter = arrayAfter[i];
		if(JSON.stringify(itemBefore) !== JSON.stringify(itemAfter))
			changes.push(itemAfter);
	}
	return changes;
};

const objectHasChanged = (objectBefore, objectAfter) => {
	if(JSON.stringify(objectBefore) === JSON.stringify(objectAfter))
		return false;
	return arrayHasChanged(objectBefore, objectAfter);
};

const objectHasNotChanged = (objectBefore, objectAfter) => {
	return !objectHasChanged(objectBefore, objectAfter);
};

const recursiveDeepCopy = item => {
	if (!item){ return item; } // null, undefined values check

	let result;

	// normalizing primitives if someone did new String('aaa'), or new Number('444');
	[Number, String, Boolean].forEach(type => {
		if (item instanceof type){
			result = type(item);
		}
	});

	if (typeof result == 'undefined'){
		if (Object.prototype.toString.call(item) === '[object Array]'){
			result = [];
			item.forEach((child, index) => {
				result[index] = recursiveDeepCopy(child);
			});
		} else if (typeof item == 'object'){
			// testing that this is DOM
			if (item.nodeType && typeof item.cloneNode == 'function'){
				result = item.cloneNode(true);
			} else if (!item.prototype){ // check that this is a literal
				if (item instanceof Date){
					result = new Date(item);
				} else {
					// it is an object literal
					result = {};
					for (let i in item){
						if({}.hasOwnProperty.call(item, i))
							result[i] = recursiveDeepCopy(item[i]);
					}
				}
			} else {
				// depending what you would like here,
				// just keep the reference, or create new object
				if (item.constructor){
					// would not advice to do that, reason? Read below
					result = new item.constructor();
				} else {
					result = item;
				}
			}
		} else {
			result = item;
		}
	}

	return result;
};

export {
	isEmpty,
	isEmptyObject,
	objectHasChanged,
	objectHasNotChanged,
	recursiveDeepCopy
};