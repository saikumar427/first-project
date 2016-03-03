package com.eventbee.regcaheloader;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;

import com.eventbee.cachemanage.CacheLoader;
import com.eventbee.cachemanage.CacheManager;
import com.eventbee.general.EbeeConstantsF;
import com.eventbee.util.CoreConnector;


public class GlobalStaticCacheLoader implements CacheLoader {
	
   private long refreshInterval=8*60*60*1000;
   private long maxIdleTime=24*60*60*1000;
   Map <String,String> cMap;
   private String netWorkUrl="http://localhost/customevents/globalstaticloader.jsp";
   public String getNetWorkUrl() {
	return netWorkUrl;
   }
   public void setNetWorkUrl(String netWorkUrl) {
	this.netWorkUrl = netWorkUrl;
  }
public long getRefreshInterval(){return refreshInterval;}
   public void setRefreshInterval(long ri){refreshInterval=ri;}
   public long getMaxIdleTime(){return maxIdleTime;}
   public void setMaxIdleTime(long mtime){maxIdleTime=mtime;}
   public void setConfigMap(Map<String,String> cMap){this.cMap=cMap;}
   public Map <String,String> getConfigMap(){return cMap;}
   public Map load(String groupid){
	     
   Map<String, String> params=new HashMap<String, String>();   
   
    CoreConnector cn=new CoreConnector(getNetWorkUrl());
    cn.setArguments(params);
    cn.setTimeout(500000);try{
    	cn.MPost();   
    }catch(Exception e){System.out.println("Exception EventStaticCacheLoader "+e.getMessage());}    

    return null;
   
   }
}
