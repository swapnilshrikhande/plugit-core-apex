public class ClassNamePluggableFactoryStrategy implements PluggableFactoryStrategy {
        
    public static final String NS_SPLITTER   = '\\.';
    public static final String CLASS_BLANK_MESSAGE = 'Service class name blank';
    public static final String INVALID_CLASS_MESSAGE = 'Invalid service class name : {0}';

    public class ClassNamePluggableFactoryStrategyException extends Exception {}

    public Object getInstance(String serviceClassName) {

        if( String.isBlank(serviceClassName) )
            throw new ClassNamePluggableFactoryStrategyException (CLASS_BLANK_MESSAGE);

        List<String> parts = serviceClassName.split(ns_splitter,2);

        Type serviceType;

        if( parts.size() == 1  ) {
            serviceType = Type.forName(parts[0]);   
        } else if( parts.size() == 2 ) {
            //parts[0]=namespace
            //parts[1]=component name
            serviceType = Type.forName(parts[0],parts[1]);  
        }

        if( serviceType == null ) {
            throw new ClassNamePluggableFactoryStrategyException (String.format(
                  INVALID_CLASS_MESSAGE
                , new List<String>{serviceClassName}
            ));
        }

        return serviceType.newInstance();
    }
}