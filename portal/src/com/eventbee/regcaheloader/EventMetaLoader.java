package com.eventbee.regcaheloader;

import java.util.HashMap;
import java.util.Map;

import com.eventbee.cachemanage.CacheLoader;
import com.eventbee.general.DBManager;
import com.eventbee.general.DbUtil;
import com.eventbee.general.StatusObj;

public class EventMetaLoader implements CacheLoader{
	
	
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
	   Map<String,String> metaMap=new HashMap<String,String>();	
	   String status=null,canceled_by="";
	   DBManager dbm=new DBManager();
	   StatusObj sbj=dbm.executeSelectQuery("select status,cancel_by from eventinfo where eventid =?::bigint", new String[]{groupid});
	   if(sbj.getStatus() && sbj.getCount()>0){
		   status=dbm.getValue(0,"status","");
		   canceled_by=dbm.getValue(0,"cancel_by","");
	   }
	   
	   //DbUtil.getVal("select status,cancel_by from eventinfo where eventid =?::bigint" ,new String[]{groupid});
	   if(status==null)	{
		   String userid=DbUtil.getVal("select userid from user_groupevents where event_groupid =?" ,new String[]{groupid});
		   metaMap.put("userid_group",userid);
		   return metaMap;
	   }
	   metaMap.put("status",status);
	   metaMap.put("canceledby",canceled_by);
	   String password=DbUtil.getVal("select password from view_security where eventid=?",new String[]{groupid});
	   metaMap.put("event_password",password);	  
	   return metaMap;
	   
   }

}
