global class PluggableFactory {
    
    private static PluggableFactoryStrategy plugitFactory;
    
    static {
        //default service strategy
        setStrategy(ClassNamePluggableFactoryStrategy.Class);
    }
    
    global static void setStrategy(Type strategyClassType){
        plugitFactory = getFactoryInstance(strategyClassType);
    }
    
    global static Pluggable plugin(String plugitName){
        return (Pluggable) plugitFactory.getInstance(plugitName);
    }

    global static Pluggable plugin(Type strategyClassType, String plugitName){
        PluggableFactoryStrategy plugitFactoryL = getFactoryInstance(strategyClassType);
        return (Pluggable) plugitFactoryL.getInstance(plugitName);
    }
    
    private static PluggableFactoryStrategy getFactoryInstance(Type strategyClassType){
        return (PluggableFactoryStrategy)strategyClassType.newInstance();
    }
}