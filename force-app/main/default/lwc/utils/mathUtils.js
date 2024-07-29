const val = number => {
	return number == null || isNaN(number) ? 0 : number;
};

const round = (number, nbOfDecimal = 2) => {
	return Math.round(val(number) * Math.pow(10, nbOfDecimal)) / Math.pow(10, nbOfDecimal);
};

const formatNumber = (number, minimumFractionDigits = 2) => {
	return new Intl.NumberFormat('fr-FR', { minimumFractionDigits }).format(val(number));
};

const formatCurrency = (number, minimumFractionDigits = 2) => {
	return new Intl.NumberFormat('fr-FR', { style: 'currency', currency: 'EUR', minimumFractionDigits }).format(val(number));
};

export{
	val,
	round,
	formatNumber,
	formatCurrency
};