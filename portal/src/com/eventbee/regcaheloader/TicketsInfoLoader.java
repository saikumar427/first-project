package com.eventbee.regcaheloader;

import java.util.HashMap;
import java.util.Map;

import com.eventbee.cachemanage.CacheLoader;
import com.eventbee.cachemanage.CacheManager;
import com.eventbee.general.DBManager;
import com.eventbee.general.GenUtil;
import com.eventbee.general.StatusObj;
import com.eventregister.TicketingInfo;

public class TicketsInfoLoader implements CacheLoader{
	
 	long refreshInterval=30*1000;
	long maxIdleTime=60*1000;
	Map <String,String> cMap;
   public long getRefreshInterval(){return refreshInterval;}
   public void setRefreshInterval(long ri){refreshInterval=ri;}
   public long getMaxIdleTime(){return maxIdleTime;}
   public void setMaxIdleTime(long mtime){maxIdleTime=mtime;}
   public void setConfigMap(Map<String,String> cMap){this.cMap=cMap;}
   public Map <String,String> getConfigMap(){return cMap;}
   
   final String TICKTES_INFO="select * from tickets_info where eventid=? ";
   final String HOLD_QTY="select sum(locked_qty) as holdqty,ticketid  from event_reg_locked_tickets where eventid=? group by ticketid";
   final String IS_SEATING_EVENT="SELECT ticketid from seat_tickets where eventid=CAST(? AS BIGINT)";
   public Map load(String groupid){
	  System.out.println("#### TicketsInfoLoader groupid: "+groupid);
	  Map ticketsInfoMap=new HashMap();
	  DBManager db=new DBManager();
	  StatusObj sb=db.executeSelectQuery(TICKTES_INFO,new String[]{groupid});
	  ticketsInfoMap.put("TicketsInfoStatusObj", sb);
	  ticketsInfoMap.put("TicketsInfoDBManager", db);
	  try{
		  Map ticketSettingsMap=CacheManager.getData(groupid, "ticketsettings");	
		  HashMap configMap=(HashMap)ticketSettingsMap.get("configmap");
		  if(!"Y".equals(GenUtil.getHMvalue(configMap,"event.recurring","N"))){
			  TicketingInfo ticketingInfo = new TicketingInfo();
			  ticketsInfoMap.put("checkTicket", ticketingInfo.checkTicket(groupid,""));
		  }
	  }catch(Exception e){System.out.println("Exception in TicketsInfoLoader at checkTicket() minmaxmap calculations: "+e.getMessage()); }
	  return ticketsInfoMap;
   }

}
