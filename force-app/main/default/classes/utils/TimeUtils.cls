public inherited sharing class TimeUtils{

	public static Boolean currentTimeIsInferiorTo(Time startTime){
		Boolean isBeforeMinTime = false;
		if(startTime != null){
			Integer nowHour = Test.isRunningTest() ? 7 : Datetime.now().hour();
			Integer nowMinutes = Test.isRunningTest() ? 0 : Datetime.now().minute();
			if(nowHour < startTime.hour() || (nowHour == startTime.hour() && nowMinutes < startTime.minute()))
				isBeforeMinTime = true;
		}
		return isBeforeMinTime;
	}

	public static Boolean currentTimeIsSuperiorTo(Time finishTime){
		Boolean isAfterMaxTime = false;
		if(finishTime != null){
			Integer nowHour = Test.isRunningTest() ? 22 : Datetime.now().hour();
			Integer nowMinutes = Test.isRunningTest() ? 0 : Datetime.now().minute();
			if(nowHour > finishTime.hour() || (nowHour == finishTime.hour() && nowMinutes > finishTime.minute()))
				isAfterMaxTime = true;
		}
		return isAfterMaxTime;
	}

	public static String format(Time timeToFormat){
		if(timeToFormat != null){
			String formatMinute = timeToFormat.minute() == 00 ? '' : String.valueOf(timeToFormat.minute());
			return timeToFormat.hour()+'H'+formatMinute;
		}
		return '';
	}
}