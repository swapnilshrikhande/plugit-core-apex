# Plugit : A Module Framework For Apex 

Ever wondered if the apex software blocks can be easily installed and plugged in into each other ?
- Plugit tries to solve above problem by providing a base framework to design services which can be combined together using a keyword driven approach.
- Implements [Fluent Interface](https://en.wikipedia.org/wiki/Fluent_interface) 

## Installation
- Managed Package (1.1 beta) : [Installation Link](https://login.salesforce.com/packaging/installPackage.apexp?p0=04t2v000000sxpX)
- Source Code : [https://github.com/swapnilshrikhande/plugit-core-apex](https://github.com/swapnilshrikhande/plugit-core-apex)


## Key Features
- Develop modular and interoperable apex services called as plugits 
- Supports extensible service factory to add custom service factory
- Service factory can be extended to hide implementation details of the service, i.e. the name of the service can be a local class or can be a remote service. Thus without changing the consumer we can swap the service implementation from local class to a external service. (eg AWS Lambda)
- All default methods can be overriden to extend the framework
- Use pipe keyword to easily chain multiple plugits like below


### typical usage example
```
// load QueryAccounts plugit and pipe its output to next plugit and so on

Pluggable resultPlug = plugin('QueryAccounts')
    .exec( seedData)
    .pipe('ProcessActiveAccounts')
    .pipe('NotifyInActiveAccountOwners')
    .pass('HandleAccountSuccess')
    .fail('SendEmailToAdmin') //invoked if any of the plugit fails
    .fail('LogDebugToFile');

if( resultPlug.hasErrors() ){
    //access resultPlug.errors();
} else {
   Object result  = resultPlug.result();
}

```

## Complete Sample Usage

### Extend ```Plug``` base class
```
public class Calculator extends Plug {
	
    public override Object execute(Object data) {
        
        Pluggable addService = plugin('AdditionService')
            .exec( data )
            .pass( 'AdditionServicePassed' )
            .fail( 'AdditionServiceFailed' );

        Object resultValue = addService.result();

        if(  resultValue == null ){
        	System.debug( 'Errors In The Service '+addService.errors());
        }

        return resultValue;
    }
}

public class AdditionService extends Plug {
    public override Object execute(Object data) {

        Map<String,Decimal> dataMap = (Map<String,Decimal>)data;

        try {
            no1 = Integer.valueOf(dataMap.get('no1'));
            no2 = Integer.valueOf(dataMap.get('no2'));

            output('result',no1+no2);
            
            return no1+no2;

        } catch (Exception exp){
            //sets error state
            error('AdditionServiceException',exp);
        }
        
        return null;
    }
}

public class AdditionServicePassed extends Plug {

	public override Object execute(Object data) {

        System.debug(' outputResult ='+Decimal.valueOf(data));

        return data;
    }
}


public class AdditionServiceFailed extends Plug {

	public override Object execute(Object data) {

        //handle errors errors
        for( String errorKey : this.errors().keySet() ) {
        	System.debug(errorKey +' : '+ ((Exception)errors.get(errorKey)) );
            //handle errors here
        }

        return null;
    }
}

```

### Invoke as a normal class or from another Plugit

#### Normal Class : 
```
Object result = Plug.plugin('CalculatorNanoService')
                    .exec(new Map<String,Decimal>{
                        'no1' => 1,
                        'no2' => 50
                    });

```

#### Another Plugit : 
```
plugin('CalculatorNanoService')
      .exec(new Map<String,Decimal>{
	    'no1' => 1,
	    'no2' => null
      });
```

### References
- [https://en.wikipedia.org/wiki/Fluent_interface](https://en.wikipedia.org/wiki/Fluent_interface)
- [https://martinfowler.com/bliki/FluentInterface.html](https://martinfowler.com/bliki/FluentInterface.html)






