/*
 * Copyright (c) 2016-2017 FinancialForce.com, inc.  All rights reserved.
 */
@isTest
global class fflib_Inheritor implements IA, IB, IC
{
	global interface IA {String doA();}
    global interface IB {String doB();}
    global interface IC {String doC();}

    global String doA(){return 'Did A';}
    global String doB(){return 'Did B';}
    global String doC(){return 'Did C';}
}