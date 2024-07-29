const getUrlParamValue = (url, key) => {
	return new URL(url).searchParams.get(key);
};

export {
	getUrlParamValue
};