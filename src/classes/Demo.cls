public class Demo extends Plug {

    public Integer queryCount    =   0;

    public override Object execute( Object objectData ) {

        SObjectType sObjType;
        if(objectData instanceof String) {
            sObjType        =   ( (SObject) Type.forName( ( String )objectData ).newInstance() ).getSObjectType();
        }
        
        String listType = 'List<' + sObjType + '>';
        List<SObject> castRecords   =   ( List<SObject> )Type.forName( listType ).newInstance();
    
        try {
            castRecords                 =   Database.query( 'SELECT  id, Name FROM '+ objectData );
        }
        catch ( Exception expObj ) {
            Map<String,Object> errorMap =   new Map<String,Object>();
            errorMap.put( expObj.getMessage(),expObj );
            error( errorMap );
            error( 'Error occured!',errorMap );
        }
        return castRecords;

    }

    public override Object execute() {
        queryCount += 1;
        return queryCount;
    }

    public override Object execute( Object data,Map<String,Object> config ) {
        
        return data;
    }


    public void demoMethodOne( String objectName ) {

        //query the records
        //if successful then pass them to SortRecords plugit for sorting records
        //if failed then handle in HandleFailCase plugit
        Pluggable queryAndSortPlug      =   exec( objectName ).pass( 'SortRecords' ).fail( 'HandleFailCase' );
        
       
        
        Pluggable queryCountPlug        =   exec();

        Map<String,Object> configMap    =   new Map<String,Object>();
        configMap.put( objectName,queryCountPlug );

        Pluggable executeWithConfigPlug =   exec( 'objData',configMap );    

        
        execute( 'Contact',configMap,executeWithConfigPlug );  
        execute( 'Contact',configMap,'CallbackFunctionality' );      
        

        //pipe result to SortRecords plugit
        Pluggable queryAndSortPlug2      =   exec( objectName ).pipe( 'SortRecords' );

        //pipe result to SortRecords plugit with additional configuration map
        Pluggable queryAndSortPlug3      =   exec( objectName ).pipe( 'SortRecords',configMap );

        
        Pluggable queryAndSortPlug4      =   exec( objectName ).pass( queryAndSortPlug2 );
        Pluggable queryAndSortPlug5      =   exec( objectName ).pass( queryAndSortPlug2,configMap );

        //pass result to SortRecords plugit with additional configuration map
        Pluggable queryAndSortPlug6      =   exec( objectName ).pass( 'SortRecords',configMap );

        //pass configuration map in addition to result
        Pluggable queryPlug1             =   exec( objectName ).pipe( configMap );
        Pluggable queryPlug2             =   exec( objectName ).pipe( queryAndSortPlug2,configMap );

        Object executeObj                =  execute();
        Integer count                    =  Integer.valueof( executeObj );
        
        //pipe results if condition is satisfied
        Pluggable queryPlug3             =   exec( objectName ).pipeif( count < 5 ,queryAndSortPlug2 ); 
        Pluggable queryPlug4             =   exec( objectName ).pipeif( count < 5 ,'SortRecords' );
        Pluggable queryPlug5             =   exec( objectName ).pipeif( count < 5 ,'SortRecords',configMap );   
        

        Pluggable queryAndSortPlug1      =   exec( objectName );


        //execute steps
        List<String> algo               =   new List<String>();
        algo.add( 'CallbackFunctionality' );
        exec( algo,queryAndSortPlug1,configMap );
        pipe( algo,configMap );


    }
    
    public void demoMethodTwo( String objectName ) {
        Pluggable queryCountPlug        =   exec();
        Map<String,Object> configMap    =   new Map<String,Object>();
        configMap.put( objectName,queryCountPlug );
        Pluggable queryAndSortPlug2     =   exec( objectName ).pipe( 'SortRecords' );

        //query the records and pass the result to SortRecords plugit
        Pluggable handleFailPlug        =   exec( objectName ).pass( 'SortRecords' ).fail( queryAndSortPlug2,configMap );    
    }

    public void demoMethodThree( String objectName ) {
        Pluggable queryCountPlug        =   exec();
        Map<String,Object> configMap    =   new Map<String,Object>();
        configMap.put( objectName,queryCountPlug );
        Pluggable queryAndSortPlug2     =   exec( objectName ).pipe( 'SortRecords' );

        //query the records and pass the result to SortRecords plugit
        //if failed then handle in HandleFailCase plugit
        Pluggable handleFailPlug        =   exec( objectName ).pass( 'SortRecords' ).fail( 'HandleFailCase',configMap ); 

       execute();
       
    }

}