@isTest
public class ClassNamePluggableFactoryStrategyTest {
	
	@isTest
	public static void  getInstanceTestMethodServiceNameBlank() {
		ClassNamePluggableFactoryStrategy pluggableFactoryStrategyObj	=	new ClassNamePluggableFactoryStrategy();
		try {
			pluggableFactoryStrategyObj.getInstance(' ');
		}
		catch ( Exception expObj ) {
			System.debug( expObj );
			System.assertEquals( 'Service class name blank',expObj.getMessage() );
		}
	}

	@isTest
	public static void  getInstanceTestMethodServiceTypeNull() {
		ClassNamePluggableFactoryStrategy pluggableFactoryStrategyObj	=	new ClassNamePluggableFactoryStrategy();
		try {
			pluggableFactoryStrategyObj.getInstance( '//' );
		}
		catch (Exception expObj) {
			System.assertEquals( 'Invalid service class name : //',expObj.getMessage() );
		}
	}

	@isTest
	public static void  getInstanceTestMethodWithServiceName1() {
		
		ClassNamePluggableFactoryStrategy pluggableFactoryStrategyObj	=	new ClassNamePluggableFactoryStrategy();
		Test.startTest();
			Object serviceTypeObj	=	pluggableFactoryStrategyObj.getInstance( 'Demo' );
		Test.stopTest();
		
		System.assertNotEquals( null,serviceTypeObj );
	}

	@isTest
	public static void  getInstanceTestMethodWithServiceName2() {
		ClassNamePluggableFactoryStrategy pluggableFactoryStrategyObj	=	new ClassNamePluggableFactoryStrategy();

		Test.startTest();
			PluggableFactory.plugin( ClassNamePluggableFactoryStrategy.Class,'Demo' );
		Test.stopTest();
		
	}
}