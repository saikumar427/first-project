package com.eventbee.regcaheloader;

import java.util.HashMap;
import java.util.Map;

import com.eventbee.cachemanage.CacheLoader;
import com.eventbee.general.DBManager;
import com.eventbee.general.StatusObj;

public class RegFormActionLoader implements CacheLoader{
	
 	long refreshInterval=30*1000;
	long maxIdleTime=60*1000;
	Map <String,String> cMap;
   public long getRefreshInterval(){return refreshInterval;}
   public void setRefreshInterval(long ri){refreshInterval=ri;}
   public long getMaxIdleTime(){return maxIdleTime;}
   public void setMaxIdleTime(long mtime){maxIdleTime=mtime;}
   public void setConfigMap(Map<String,String> cMap){this.cMap=cMap;}
   public Map <String,String> getConfigMap(){return cMap;}
   
   final String GET_TICKETS_QUERY="select groupname,ticket_groupid,price_id,ticket_name,networkcommission from tickets_details_view where eventid=?";

   public Map load(String groupid){
	  System.out.println("#### RegFormActionLoader groupid: "+groupid);
	  Map regFormActionMap=new HashMap();
	  
	  regFormActionMap.put("ticket_details_view", getTicketDetails(groupid));
	
	  return regFormActionMap;
   }
   
   HashMap getTicketDetails(String eid){
	    HashMap ticketsMap=new HashMap();
	    DBManager db=new DBManager();
	    StatusObj sb=db.executeSelectQuery(GET_TICKETS_QUERY,new String[]{eid});
	    if(sb.getStatus()){
	    for(int i=0;i<sb.getCount();i++){
	    HashMap priceMap=new HashMap();
	    priceMap.put("ticketname",db.getValue(i,"ticket_name",""));
	    priceMap.put("groupname",db.getValue(i,"groupname",""));
	    priceMap.put("ticket_groupid",db.getValue(i,"ticket_groupid",""));
	    priceMap.put("price_id",db.getValue(i,"price_id",""));
		String ntscommission=db.getValue(i,"networkcommission","0.00");
		ntscommission=ntscommission==null?"0.00":ntscommission;
		if(Double.parseDouble(ntscommission)<0)
			ntscommission="0";
		priceMap.put("nts_commission",ntscommission);
	    ticketsMap.put(db.getValue(i,"price_id",""),priceMap);
	    }
	    }
		
	     return ticketsMap;

	    }



}
