const removeSpaces = stringValue => {
	return stringValue?.replace(/\s+/g, '');
};

const getPastedData = event => {
	const clipboardData = event.clipboardData || window.clipboardData;
	return clipboardData.getData('Text');
};

const transformPastedArrayIntoListOfObject = event => {
	const pastedData = getPastedData(event);
	let clipRows = pastedData.split('\n');
	for(let i = 0; i < clipRows.length; i++){
		clipRows[i] = clipRows[i].split('\t');
	}
	const jsonObj = [];
	for(let i = 0; i < clipRows.length - 1; i++){
		let item = {};
		for(let j = 0; j < clipRows[i].length; j++){
			if(clipRows[i][j] !== '\r' && clipRows[i][j].length !== 0){
				item[j] = clipRows[i][j];
			}
		}
		jsonObj.push(item);
	}
	return jsonObj;
};

const copyTextToClipboard = content => {
	let tempTextAreaField = document.createElement('textarea');
	tempTextAreaField.style = 'position:fixed;top:-5rem;height:1px;width:10px;';
	tempTextAreaField.value = content;
	document.body.appendChild(tempTextAreaField);
	tempTextAreaField.select();
	document.execCommand('copy');
	tempTextAreaField.remove();
};

const pad = theNumber => {
	return theNumber < 10 ? '0' + theNumber : theNumber;
};

const boldString = (theInput, text) => {
	return theInput.replace(new RegExp('('+text.split(' ').join('|')+')','ig'), '<mark>$1</mark>');
};

const format = (stringToFormat, formattingArguments) => {
	let formattedString = stringToFormat;
	if(formattingArguments){
		for(let i = 0; i < formattingArguments.length; i++)
			formattedString = formattedString.replace('{'+i+'}', formattingArguments[i]);
	}
	return formattedString;
};

const containsAtLeastOneOfTheTerms = (textToVerify, terms) => {
	if(!textToVerify || !terms) return false;
	for(let i = 0; i < terms.length; i++){
		if(terms[i] && textToVerify.includes(terms[i]))
			return true;
	}
	return false;
};

export {
	removeSpaces,
	getPastedData,
	transformPastedArrayIntoListOfObject,
	copyTextToClipboard,
	pad,
	boldString,
	format,
	containsAtLeastOneOfTheTerms
};