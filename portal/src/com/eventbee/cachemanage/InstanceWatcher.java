package com.eventbee.cachemanage;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.Timer;
import java.util.TimerTask;

public class InstanceWatcher extends TimerTask{
	private long lastAccessTime=now();
	private long lastFetchTime=0;
	private long refreshInterval=0;
	private long maxIdleTime=0;
	private String context;
	private String token;
	private boolean loading=false;
	private Map dataHash=null;
	private boolean init=false;
	public Map getDataHash() {
		return dataHash;
	}

	public void setDataHash(Map dataHash) {
		this.dataHash = dataHash;
	}

	private CacheLoader dataLoader;
	public long getLastAccessTime() {
		return lastAccessTime;
	}

	public boolean isLoading() {
		return loading;
	}

	public void setLoading(boolean loading) {
		this.loading = loading;
	}

	public void setLastAccessTime(long lastAccessTime) {
		this.lastAccessTime = lastAccessTime;
	}

	public long getMaxIdleTime() {
		return maxIdleTime;
	}

	public void setMaxIdleTime(long maxIdleTime) {
		this.maxIdleTime = maxIdleTime;
	}

	private Timer timer;
	private CacheManager cacheManager;

	protected boolean isValidData(){
		try{
		//	System.out.println("validata  dataHash"+dataHash);			
			if(dataHash==null)
			{System.out.println("invalid dataHash"+token);	
				return false;
			}
			else if((now()-lastFetchTime<refreshInterval) ){return true;}
			else {
				//System.out.println("refresh time laps::"+token);	
				
				return false;}			
		}catch(Exception e){
			System.out.println("exception validate data"+e.getMessage());
			return false;
		}
	}
	
	@Override
    public void run() {
        if(now()-lastAccessTime > maxIdleTime){
        	timer.cancel();
        	dataHash=null;
        	System.out.println("time out:::"+token+"_"+context);
        	cacheManager.clearData(token+"_"+context);
        	
        }
    }
	
	protected void startWatch(){
		
        //running timer task as daemon thread
        timer = new Timer(true);
        timer.schedule(this, 0, 60*1000);
	
	}
	
	protected void stopWatch(){
		if(timer!=null) timer.cancel();
        dataHash=null;
	}
	
	
	protected void setContext(String context){
		this.dataLoader = cacheManager.getCacheLoader(context);
		this.context=context;
		this.refreshInterval=dataLoader.getRefreshInterval();
		this.maxIdleTime=dataLoader.getMaxIdleTime();
	}
	
	protected void setToken(String token){
		this.token=token;
	}

	protected void  refreshData(){
      
      	if(dataHash==null) this.init=true;
		if(this.loading) return;
		this.loading=true;
		//System.out.println("watcher:::refreshdata context: "+context);
		Map latestDataHash=dataLoader.load(token);
		lastFetchTime=now();
		mergeLoadedData(latestDataHash,false);
		latestDataHash=null;
		loading=false;
	}

	public boolean isInit() {
		return init;
	}

	public void setInit(boolean init) {
		this.init = init;
	}

	protected Map getData(){
		lastAccessTime=now();
		return dataHash;
	}
	
	public long now(){
		return new java.util.Date().getTime();
	}
	
	protected void mergeLoadedData(Map latestDataHash, boolean syncKeys){
	//enumerate keys in latestDataHash and load into global dataHash
	//if synckeys, remove all extra keys dataHash that are not in latestDataHash
	//	dataHash=dataHash==null?new HashMap():dataHash;
		if(this.dataHash==null)this.dataHash=new HashMap();
		if(latestDataHash==null)return;
		Set<String> latestdatakeys= latestDataHash.keySet();		
		  for(String key:latestdatakeys)
			   this.dataHash.put(key, latestDataHash.get(key));
		  if(syncKeys){			  
				  Set<String> datakeys=new HashSet<String>();
			      datakeys= (this.dataHash.keySet());
			      Set<String> datakeys1=new HashSet<String>();
			      for(String key:datakeys){
			    	  datakeys1.add(key);
			      }             
			      try{			 
			  Iterator<String> it=datakeys1.iterator();
			  while(it.hasNext()){			   
				     String key=it.next(); 
			    	if(!latestdatakeys.contains(key))
			    	this.dataHash.remove(key);			    	
			    	 
				  }
			      }catch(Exception e){System.out.println("mrege data sync exception "+e.getMessage());
				  e.printStackTrace();				  
			  }
			  
		  }
						
	}

}
