global abstract class Plug implements Pluggable {
    //private Object              instream;
    private Object              outstream;
    
    //private Map<String,Object> out;
    private Map<String,Object> errorMap;
    
    global class PlugException extends Exception {}
    
    global virtual Object execute(){
        throw new PlugException('Invalid Plugit : execute()  or execute(data) or execute(data,config) must be overriden. Please refer to the documentation.');
    }

    global virtual Object  execute(Object data){
        //nop
        //if not overriden try to fallback to simpler method
        return this.execute();
    }

    global virtual Object execute(Object data,Map<String,Object> config) {
        //nop
        //if not overriden try to fallback to simpler method
        return this.execute(data);
    }

    global virtual Object execute(Object data, Map<String,Object> config,Pluggable callback){
        result( this.execute(data,config) );
        return pipe(callback).result();
    }

    global virtual Object execute(Object data, Map<String,Object> params, String callback){
        return execute(data, params, plugin(callback) );
    }
    
    global virtual Pluggable  exec() {
        this.result( this.execute() );
        return this;
    }    

    global virtual Pluggable  exec(Object data) {
        this.result( this.execute( data ) );
        return this;
    }

    global virtual Pluggable  exec(Object data, Map<String,Object> config){
        this.result( this.execute( data,config ) );
        return this;
    }

    global virtual Pluggable  pipe(){
        this.result( this.execute( result() ) );
        return this;
    }

    global virtual Pluggable  pipe(Map<String,Object> config){
        this.result( this.execute( result() , config) );
        return this;
    }

	//always
    global virtual Pluggable  pipe(Pluggable plugit,Map<String,Object> config){

        //fall through to fail state if the current plugit fails
        if( this.hasErrors() )
            return this;

        plugit.result(  plugit.execute( this.result() , config )  );
        
        return plugit;
    }

    global virtual Pluggable  pipe(String plugitName,Map<String,Object> config){
        return pipe( plugin(plugitName) ,  config );
    }

    global virtual Pluggable  pipe(Pluggable plugit){

        //fall through to fail state if the current plugit fails
        if( this.hasErrors() )
            return this;

        plugit.result(  plugit.execute( this.result() )  );
        
        return plugit;
    }

    global virtual Pluggable  pipe(String plugitName){
        return this.pipe( plugin( plugitName ) );
    }
    
    //execute a nanoservice on success
    global virtual Pluggable  pass(Pluggable plugit){
        return this.pipe(plugit);
    }

    //execute a nanoservice on success
    global virtual Pluggable  pass(String plugitName){
        return this.pipe( plugitName );
    }
    //execute a nanoservice on success
    global virtual Pluggable  pass(Pluggable plugit,Map<String,Object> config){
        return this.pipe(plugit,config);
    }

    //execute a nanoservice on success
    global virtual Pluggable  pass(String plugitName,Map<String,Object> config){
        return this.pipe( plugitName, config );
    }

    //execution failed
    global virtual Pluggable fail(Pluggable plugit){
        
        if( this.hasErrors() == true ){
            plugit.error(this.errors());
            plugit.result( plugit.execute( result() ) );
            return plugit;       
        } else {
            //nop
            return this;
        }
    }

    //execute a nanoservice on failure
    global virtual Pluggable fail(String plugit){
        if( this.hasErrors() == true ) {
            return fail( plugin( plugit ) );
        }

        return this;
    }

    //execution failed
    global virtual Pluggable fail(Pluggable plugit,Map<String,Object> config){
        
        if( this.hasErrors() == true ){
            plugit.error(this.errors());
            plugit.result( plugit.execute( result() , config ) );
            return plugit;       
        } else {
            //nop
            return this;
        }
    }

    //execute a nanoservice on failure
    global virtual Pluggable fail(String plugit,Map<String,Object> config){
        if( this.hasErrors() == true ) {
            return fail( plugin( plugit ) , config );
        }

        return this;
    }
    
    
    global virtual Pluggable  pipeif(Boolean condition,Pluggable plugit){
        
        if( condition ) {
            return this.pipe(plugit);
        } 
        
        return this;
    }

    global virtual Pluggable  pipeif(Boolean condition,Pluggable plugit,Map<String,Object> config){
        
        if( condition ) {
            return this.pipe(plugit,config);
        } 
        
        return this;
    }

    global  Pluggable  execif( Boolean condition, Pluggable plugit, Object data, Map<String,Object> config ){
        if( condition ) {
           return plugit.exec(data,config);
        }

        return this;
    }

    global virtual Pluggable  pipeif(Boolean condition,String plugitName){
        return pipeif(condition,plugin(plugitName));
    }    

    global virtual Pluggable  pipeif(Boolean condition,String plugitName,Map<String,Object> config){
        return pipeif(condition,plugin(plugitName),config);
    }

    global  Pluggable  execif( Boolean condition, String plugitName, Object data, Map<String,Object> config ){
        return execif(condition, plugin(plugitName), data, config );   
    }

    //set error, this will cause to execute any fail callbacks
    global virtual void error(Map<String,Object> errorMap){
        this.errorMap = errorMap;
    }

    global virtual void error(String key,Object result){

        if( errorMap == null )
            errorMap = new Map<String,Object>();

        errorMap.put(key,result);
	}

    //errors if any
    global virtual Map<String,Object> errors(){
        return errorMap;
    }

    global virtual Boolean hasErrors(){
        return errorMap != null && !errorMap.isEmpty();
    }

    //final result of the nano plugit
    global virtual Object result() {
        return this.outstream;
    }

    //set result, this is same as returning value from execute
    //this value is automatically piped in to the next chained nanoservice
    global virtual Object result(Object value) {
        return this.outstream = value;
    }
    
    //plugit discovery
    global virtual Pluggable plugin( String plugitName ){
        return PluggableFactory.plugin( plugitName );
    }

    //execute an algorithm
    global virtual Pluggable exec(List<String> algorithmList,Object data,Map<String,Object> config){
        Pluggable lastService = this;
        
        for(String algorithm : algorithmList  ) {

            if( lastService == this ) {
                lastService = plugin(algorithm).exec(data,config);
            } else {
                lastService = lastService.pipe(algorithm,config);
            }

            if( lastService.hasErrors() )
                break;
        }

        return lastService;
    }

    global Pluggable pipe(List<String> algorithmList, Map<String,Object> config){
        Pluggable lastService = this;
        
        for(String algorithm : algorithmList  ) {

            lastService = lastService.pipe(algorithm,config);
            
            if( lastService.hasErrors() )
                break;
        }

        return lastService;   
    }


}