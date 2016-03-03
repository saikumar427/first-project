package com.eventbee.cachemanage;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
import java.util.Timer;
import java.util.TimerTask;



public  class CacheManager  {
	private static Timer gltimer;
	private static long gltimerinterval=15*60*1000;
	
	private static Map<String,InstanceWatcher> globalMap = new HashMap<String, InstanceWatcher>();
	private static Map<String, CacheLoader> instanceMap=new HashMap<String,CacheLoader>();
	
	static {startWatch();}
	
	public static void maxIdealTimeChecker() {	
    	//System.out.println(":::glbl timeout:::");
		  Set<String> globalkeys= globalMap.keySet();
	      Set<String> idealkeys=new HashSet<String>();
	      for(String key:globalkeys){
	    	  InstanceWatcher iw=globalMap.get(key);	      
	    	  if(!iw.isLoading() && (iw.now()-iw.getLastAccessTime()>iw. getMaxIdleTime())){
	    		  iw.setDataHash(null);	    	
	    		  idealkeys.add(key);
	    	  }   
	      } 
	      try{	  //System.out.println(":::glbl timeout list:::"+idealkeys);
	    	  for(String key:idealkeys)
	    	   clearData(key);	 
	        }catch(Exception e){System.out.println("clear ideal keys from CaheManager"+e.getMessage());}

   }
	
	public static Map<String, InstanceWatcher> getGlobalMap() {
		return globalMap;
	}

	public static void setGlobalMap(Map<String, InstanceWatcher> globalMap) {
		CacheManager.globalMap = globalMap;
	}

	protected static  void startWatch(){
		gltimer = new Timer(true);
        gltimer.schedule(new TimerTask() {			
			@Override
			public void run() {
				maxIdealTimeChecker();				
			}
		}, 0, gltimerinterval);
	
	}
	
	protected void stopWatch(){
		if(gltimer!=null) 
		gltimer.cancel();
        
	}
	
	
	public void setInstanceMap(Map <String, CacheLoader> imap){ 
	  //spring loading
		instanceMap=imap;
	}
	public static Map<String, CacheLoader> getInstanceMap(){
		return instanceMap;
	}

	protected static CacheLoader getCacheLoader(String context){
		return instanceMap.get(context);
	}
	
	public static long getGltimerinterval() {
		return gltimerinterval;
	}

	public static void setGltimerinterval(long gltimerinterval) {
		CacheManager.gltimerinterval = gltimerinterval;
	}
	
	private static boolean createInstance(String token, String context){
		if(instanceMap == null) {return false;}
		if(!instanceMap.containsKey(context)){System.out.println("invalid context invoked"); return false;}//log: invalid context invoked
	
		//System.out.println("First instance of context:: "+context+"  token::"+token);
		String mapToken=token+"_"+context;
		if(!globalMap.containsKey(mapToken)){
			InstanceWatcher inw=new InstanceWatcher();
			globalMap.put(mapToken,inw);
			inw.setToken(token);
			inw.setContext(context);
			//inw.startWatch();
			
			
		}
		return true;
	}
	
	public static void updateData(String mapToken, Map newKeysMap, boolean syncKeys){
		if(globalMap.containsKey(mapToken)){
			//System.out.println("Update data token::"+mapToken);
			InstanceWatcher inw=globalMap.get(mapToken);
			inw.mergeLoadedData(newKeysMap, syncKeys);
		}
	
	}

	public static void clearData(String mapToken){
		//System.out.println("CacheManager clearData mapToken:::: "+mapToken+" globalMap:::: "+globalMap);
		if(globalMap.containsKey(mapToken)) {
			//System.out.println("clearData for:::: "+mapToken);
		   //globalMap.get(mapToken).stopWatch();
		   globalMap.remove(mapToken);
		}
	}
	public static boolean getInitStatus(String mapToken){
		if(globalMap.containsKey(mapToken)) {
		  	InstanceWatcher inw=globalMap.get(mapToken);
			return inw.isInit();		   
		}
		return false;
	}


	public static Map getData(String token, String context){
		//System.out.println("getData  context:: "+context+"  token::"+token);
		String mapToken=token+"_"+context;
		if(globalMap.containsKey(mapToken)){
			InstanceWatcher inw=globalMap.get(mapToken);
			if(inw.isValidData()) 
			return inw.getData();
			//System.out.println("NOT Valid Data "+context+"  token::"+token);
			inw.refreshData();
			inw.setInit(false);
			return inw.getData();
		}else{
			return createInstance(token, context)?getData(token, context):null;
		}
	}
	
	public  void refreshData(String mapToken){
		//System.out.println("refreshData  mapToken:: "+mapToken);
		if(globalMap.containsKey(mapToken)){
			InstanceWatcher inw=globalMap.get(mapToken);
			inw.refreshData();
		}
	}

}
