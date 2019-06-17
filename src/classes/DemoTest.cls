@isTest
public class DemoTest {
	@isTest
	public static void execteTestMethodWithoutException() {
		Test.startTest();
			Demo demoObj	=	new Demo();
			demoObj.demoMethodOne( 'Account' );
		Test.stopTest();
        System.assertEquals( 2,demoObj.queryCount );
	}

	@isTest
	public static void execteTestMethodWithException1() {
		Test.startTest();
			Demo demoObj	=	new Demo();
			demoObj.demoMethodOne( 'Case' );
		Test.stopTest();
		System.assertEquals( 2,demoObj.queryCount );
	}

	@isTest
	public static void execteTestMethodWithException2() {
		Test.startTest();
			Demo demoObj	=	new Demo();
			demoObj.demoMethodTwo( 'Case' );
		Test.stopTest();
		System.assertEquals( 1,demoObj.queryCount );
	}

	@isTest
	public static void execteTestMethodWithException3() {
		Test.startTest();
			Demo demoObj	=	new Demo();
			demoObj.demoMethodThree( 'Case' );
		Test.stopTest();
		System.assertEquals( 2,demoObj.queryCount );
	}
}