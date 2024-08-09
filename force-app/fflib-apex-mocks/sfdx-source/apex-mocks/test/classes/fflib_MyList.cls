/*
 Copyright (c) 2014-2017 FinancialForce.com, inc.  All rights reserved.
 */

/**
 * @nodoc
 */
@isTest
global with sharing class fflib_MyList implements IList
{
	global interface IList
	{
		void add(String value);
		void add(String value1, String value2, String value3, String value4);
		void addMore(String value);
		void add(String[] value); // Test methods with the same name and number of params
		String get(Integer index);
		String get2(Integer index, String value); // This is just a method signature to allow me to test stubbing a method with multiple arguments
		void clear();
		Boolean isEmpty();
		void set(Integer index, Object value);
	}

	global void add(String[] value)
	{
	}

	global void add(String value)
	{
	}

	global void add(String value1, String value2, String value3, String value4)
	{
	}

	global void addMore(String value)
	{
	}

	global String get(Integer index)
	{
		return 'fred';
	}

	global void clear()
	{
	}

	global Boolean isEmpty()
	{
		return true;
	}

	global void set(Integer index, Object value)
	{
	}

	global String get2(Integer index, String value)
	{
		return 'mary';
	}

	global static String getStubClassName()
	{
		return fflib_ApexMocks.extractTypeName(new fflib_ApexMocks().mock(fflib_MyList.class));
	}
}