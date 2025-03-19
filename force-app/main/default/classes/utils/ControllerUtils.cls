global inherited sharing class ControllerUtils{

	global static Map<String, Object> success(){
		return success(new Map<String, Object>());
	}

	global static Map<String, Object> success(String attr, Object valueToReturn){
		return success(new Map<String, Object>{ attr => valueToReturn });
	}

	global static Map<String, Object> success(Map<String, Object> returnValueByAttr){
		Map<String, Object> result = new Map<String, Object>();
		result.put(Constants.STATUS, Constants.SUCCESS);
		for(String attr : returnValueByAttr.keySet())
			result.put(attr, returnValueByAttr.get(attr));
		return result;
	}

	global static Map<String, Object> error(String errorMessage){
		return new Map<String, Object>{
			Constants.STATUS => Constants.ERROR,
			Constants.CUSTOM_ERROR => true,
			Constants.MESSAGE => errorMessage
		};
	}

	global static Map<String, Object> error(Exception e){
		return new Map<String, Object>{
			Constants.STATUS => Constants.ERROR,
			Constants.CUSTOM_ERROR => ExceptionUtils.isCustom(e),
			Constants.MESSAGE => e.getMessage()
		};
	}
}