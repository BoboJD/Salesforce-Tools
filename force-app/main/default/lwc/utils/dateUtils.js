import { pad } from './stringUtils';

const withoutTime = dateTime => {
	let date = new Date(dateTime.getTime());
	date.setHours(0, 0, 0, 0);
	return date;
};

const dateAreEquals = (firstDate, secondDate) => {
	return withoutTime(firstDate).getTime() === withoutTime(secondDate).getTime();
};

const addDays = (date, daysToAdd) => {
	let d = new Date(date);
	d.setDate(d.getDate() + daysToAdd);
	return d;
};

const addWorkDays = (datStartDate, lngNumberOfWorkingDays, blnIncSat, blnIncSun) => {
	let intWorkingDays = 5;
	let intNonWorkingDays = 2;
	let intStartDay = datStartDate.getDay(); // 0=Sunday ... 6=Saturday
	let intOffset;
	let intModifier = 0;

	if (blnIncSat){ intWorkingDays++; intNonWorkingDays--; }
	if (blnIncSun){ intWorkingDays++; intNonWorkingDays--; }
	let newDate = new Date(datStartDate);
	if (lngNumberOfWorkingDays >= 0){
		// Moving Forward
		if (!blnIncSat && blnIncSun){
			intOffset = intStartDay;
		} else {
			intOffset = intStartDay - 1;
		}
		// Special start Saturday rule for 5 day week
		if (intStartDay === 6 && !blnIncSat && !blnIncSun){
			intOffset -= 6;
			intModifier = 1;
		}
	} else {
		// Moving Backward
		if (blnIncSat && !blnIncSun){
			intOffset = intStartDay - 6;
		} else {
			intOffset = intStartDay - 5;
		}
		// Special start Sunday rule for 5 day week
		if (intStartDay === 0 && !blnIncSat && !blnIncSun){
			intOffset++;
			intModifier = 1;
		}
	}
	// ~~ is used to achieve integer division for both positive and negative numbers
	newDate.setTime(datStartDate.getTime() + (Number((~~((lngNumberOfWorkingDays + intOffset) / intWorkingDays) * intNonWorkingDays) + lngNumberOfWorkingDays + intModifier)*86400000));
	return newDate;
};

const addMonths = (dt, monthsToAdd) => {
	let theDate = new Date(dt);
	let d = theDate.getDate();
	theDate.setMonth(theDate.getMonth() + monthsToAdd);
	if (theDate.getDate() !== d){
		theDate.setDate(0);
	}
	return theDate;
};

const addYears = (date, yearsToAdd) => {
	let d = new Date(date);
	d.setFullYear(d.getFullYear() + yearsToAdd);
	return d;
};

const formatDate = theDate => {
	return [pad(theDate.getDate()), pad(theDate.getMonth()+1),theDate.getFullYear()].join('/');
};

const formatDatetime = theDate => {
	return formatDate(theDate) + ' à ' + [pad(theDate.getHours()), pad(theDate.getMinutes())].join('h');
};

const formatDateToSfDateFormat = theDate => {
	return [theDate.getFullYear(), pad(theDate.getMonth()+1),pad(theDate.getDate())].join('-');
};

const monthsBetween = (startDate, endDate) => {
	let months;
	months = (endDate.getFullYear() - startDate.getFullYear()) * 12;
	months -= startDate.getMonth();
	months += endDate.getMonth();
	return months <= 0 ? 0 : months;
};

const listOfYearsBetween = (startDate, endDate) => {
	let listOfYears = [];
	let first = startDate.getFullYear();
	let second = endDate.getFullYear();
	for(let year = first; year <= second; year++) listOfYears.push(year);
	return listOfYears;
};

const treatAsUTC = date => {
	let result = new Date(date);
	result.setMinutes(result.getMinutes() - result.getTimezoneOffset());
	return result;
};

const daysBetween = (startDate, endDate) => {
	let millisecondsPerDay = 24 * 60 * 60 * 1000;
	return (treatAsUTC(endDate) - treatAsUTC(startDate)) / millisecondsPerDay;
};

const getLastSunday = (year, month) => {
	let d = addMonths(new Date(year, month, 1), 1);
	d.setDate(d.getDate() - d.getDay());
	return d;
};

const convertArrayOfSfDateToArrayOfDate = arrayOfSfDate => {
	let arrayOfDate = [];
	arrayOfSfDate.forEach(sfDate => arrayOfDate.push(new Date(sfDate)));
	return arrayOfDate;
};

const findFirstBusinessDayOfMonth = (year, month) => {
	let offset = 1;
	let result = null;
	if('undefined' === typeof year || null === year)
		year = new Date().getFullYear();
	if('undefined' === typeof month || null === month)
		month = new Date().getMonth();
	do{
		result = new Date(year, month, offset);
		offset++;
	}while(0 === result.getDay() || 6 === result.getDay());
	return result;
};

export {
	dateAreEquals,
	withoutTime,
	addDays,
	addWorkDays,
	addMonths,
	addYears,
	formatDate,
	formatDatetime,
	formatDateToSfDateFormat,
	monthsBetween,
	listOfYearsBetween,
	daysBetween,
	getLastSunday,
	convertArrayOfSfDateToArrayOfDate,
	findFirstBusinessDayOfMonth
};