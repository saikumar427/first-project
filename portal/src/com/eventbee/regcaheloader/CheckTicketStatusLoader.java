package com.eventbee.regcaheloader;

import java.util.HashMap;
import java.util.Map;

import com.eventbee.cachemanage.CacheLoader;
import com.eventbee.general.DBManager;
import com.eventbee.general.StatusObj;

public class CheckTicketStatusLoader implements CacheLoader{
	
 	long refreshInterval=30*1000;
	long maxIdleTime=60*1000;
	Map <String,String> cMap;
   public long getRefreshInterval(){return refreshInterval;}
   public void setRefreshInterval(long ri){refreshInterval=ri;}
   public long getMaxIdleTime(){return maxIdleTime;}
   public void setMaxIdleTime(long mtime){maxIdleTime=mtime;}
   public void setConfigMap(Map<String,String> cMap){this.cMap=cMap;}
   public Map <String,String> getConfigMap(){return cMap;}
   
   //final String TICKETS_DETAILS_VIEW="select groupname,ticket_groupid,price_id,ticket_name,networkcommission from tickets_details_view where eventid=?";

   public Map load(String groupid){
	  System.out.println("#### CheckTicketStatusLoader groupid: "+groupid);
	  Map checkstatusMap=new HashMap();
	  
	  DBManager db=new DBManager();
	  String pricequery="select (max_ticket-sold_qty) as remaining_qty, price_id as "
				 +" ticketid from price a where evt_id=CAST(? AS BIGINT) and price_id not "
				 +"in (select ticketid from event_reg_locked_tickets where "
				 +"eventid=? ) union "
				 +"select a.max_ticket-a.sold_qty-sum(locked_qty)  as remaining_qty, "
				 +"ticketid from event_reg_locked_tickets b,  price a " 
				 +"where eventid=? and a.price_id=b.ticketid "
              +"group by ticketid, a.max_ticket, a.sold_qty";
	  StatusObj sb=db.executeSelectQuery(pricequery,new String[]{groupid,groupid,groupid});
	
	  checkstatusMap.put("remaining_status_obj", sb);
	  checkstatusMap.put("remaining_dbmanager", db);
	  
	  return checkstatusMap;
   }



}
