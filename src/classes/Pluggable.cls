global interface Pluggable {
    
    Object  execute();
    Object  execute(Object data);
    Object  execute(Object data, Map<String,Object> config);
    Object  execute(Object data, Map<String,Object> config, Pluggable callback);
    Object  execute(Object data, Map<String,Object> config, String callback);


    Pluggable  exec();
    Pluggable  exec(Object data);
    Pluggable  exec(Object data, Map<String,Object> config);

    //self pipe
    Pluggable  pipe();
    Pluggable  pipe(Map<String,Object> config);
    
    //pipe to another plugit
    Pluggable  pipe(Pluggable plugit);
    Pluggable  pipe(Pluggable plugit, Map<String,Object> config);
    Pluggable  pipe(String plugit);
    Pluggable  pipe(String plugit, Map<String,Object> config);
    
    //execution passed
    Pluggable  pass(Pluggable plugit);
    Pluggable  pass(Pluggable plugit,Map<String,Object> config);
    Pluggable  pass(String plugit);
    Pluggable  pass(String plugit, Map<String,Object> config);
    
    //execution failed
    Pluggable  fail(Pluggable plugit);
    Pluggable  fail(Pluggable plugit,Map<String,Object> config);
    Pluggable  fail(String plugit);
    Pluggable  fail(String plugit, Map<String,Object> config);

    //conditional pipe
    Pluggable  pipeif( Boolean condition, Pluggable plugit);
    Pluggable  pipeif( Boolean condition, Pluggable plugit , Map<String,Object> config );
    Pluggable  pipeif( Boolean condition, String plugit);
    Pluggable  pipeif( Boolean condition, String plugit , Map<String,Object> config );

    //conditional execution
    Pluggable  execif( Boolean condition, Pluggable plugit, Object data, Map<String,Object> config );
    Pluggable  execif( Boolean condition, String plugit, Object data, Map<String,Object> config );

    
    //set errors, check errors
    void error(Map<String,Object> errorMap);
    void error(String key,Object obj);
    Map<String,Object> errors();
    Boolean hasErrors();

    //get most recent execution result
    Object result();
    //set result, this value is automatically piped to next Pluggable
    Object result(Object value);

    //execute plugitlist in bulk    
    Pluggable exec(List<String> algorithmList, Object data, Map<String,Object> config);
    Pluggable pipe(List<String> algorithmList, Map<String,Object> config);
}