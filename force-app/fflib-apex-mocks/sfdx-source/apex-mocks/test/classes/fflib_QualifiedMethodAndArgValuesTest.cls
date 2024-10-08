@isTest
global class fflib_QualifiedMethodAndArgValuesTest
{
    @isTest
    private static void equalsReturnsExpectedResults()
    {
        fflib_QualifiedMethod qm1 = new fflib_QualifiedMethod('Type1', 'Method1', new List<Type>{ Integer.class } );
        fflib_MethodArgValues mav1 = new fflib_MethodArgValues(new List<Object>{ 'hello' });
        Object obj1 = 'hello';

        fflib_QualifiedMethodAndArgValues qmaav = new fflib_QualifiedMethodAndArgValues(qm1, mav1, obj1);

        fflib_QualifiedMethod qm2 = qmaav.getQualifiedMethod();
        fflib_MethodArgValues mav2 = qmaav.getMethodArgValues();
        Object obj2 = qmaav.getMockInstance();
        String string1 = qmaav.toString();

        System.Assert.areEqual(qm1, qm2);
        System.Assert.areEqual(mav1, mav2);
        System.Assert.areEqual(obj1, obj2);
        System.Assert.areEqual('Type1.Method1(Integer) with args: [hello]', string1);

    }
}
