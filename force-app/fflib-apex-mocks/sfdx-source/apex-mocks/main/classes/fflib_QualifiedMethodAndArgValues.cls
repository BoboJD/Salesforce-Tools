/*
 Copyright (c) 2016-2017 FinancialForce.com, inc.  All rights reserved.
 */

/**
 * @group Core
 */
global with sharing class fflib_QualifiedMethodAndArgValues
{
	private final fflib_QualifiedMethod qm;
	private final fflib_MethodArgValues args;
	private final Object mockInstance;

	global fflib_QualifiedMethodAndArgValues(fflib_QualifiedMethod qm, fflib_MethodArgValues args, Object mockInstance)
	{
		this.qm = qm;
		this.args = args;
		this.mockInstance = mockInstance;
	}

	global fflib_QualifiedMethod getQualifiedMethod()
	{
		return qm;
	}

	global fflib_MethodArgValues getMethodArgValues()
	{
		return args;
	}

	global Object getMockInstance()
	{
		return mockInstance;
	}

	global override String toString()
	{
		return qm + ' with args: [' + String.join(args.argValues, '],[') + ']';
	}
}