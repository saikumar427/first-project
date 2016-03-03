package com.eventbee.regcaheloader;

import java.util.HashMap;
import java.util.Map;

import com.customquestions.CustomAttribsDB;
import com.eventbee.cachemanage.CacheLoader;
import com.eventregister.ProfilePageDisplay;
import com.eventregister.RegistrationTiketingManager;

public class BaseProfileLoader implements CacheLoader{
	
 	long refreshInterval=30*1000;
	long maxIdleTime=60*1000;
	Map <String,String> cMap;
   public long getRefreshInterval(){return refreshInterval;}
   public void setRefreshInterval(long ri){refreshInterval=ri;}
   public long getMaxIdleTime(){return maxIdleTime;}
   public void setMaxIdleTime(long mtime){maxIdleTime=mtime;}
   public void setConfigMap(Map<String,String> cMap){this.cMap=cMap;}
   public Map <String,String> getConfigMap(){return cMap;}
   
   public Map load(String groupid){
	  System.out.println("#### BaseProfileLoader groupid: "+groupid);
	  Map baseProfileMap=new HashMap();
	  ProfilePageDisplay profilePageDisplay = new ProfilePageDisplay();
	  baseProfileMap.put("attribsfortickets", profilePageDisplay.getAttribsForTickets("0",groupid));
	  baseProfileMap.put("attribsforalltickets", profilePageDisplay.getAttribsForAllTickets(groupid));
	  
	  CustomAttribsDB ticketcustomattribs=new CustomAttribsDB();
	  baseProfileMap.put("customattribset", ticketcustomattribs.getCustomAttribSet(groupid,"EVENT" ));
	  baseProfileMap.put("ticketlevelattributes", ticketcustomattribs.getTicketLevelAttributes(groupid));
	  
	  RegistrationTiketingManager regTktMgr=new RegistrationTiketingManager();
	  baseProfileMap.put("profilepagetemplate", regTktMgr.getVelocityTemplate(groupid,"profile_page"));
	  return baseProfileMap;
   }

}
