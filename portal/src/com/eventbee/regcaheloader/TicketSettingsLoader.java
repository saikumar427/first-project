package com.eventbee.regcaheloader;

import java.util.HashMap;
import java.util.Map;

import com.event.dbhelpers.DisplayAttribsDB;
import com.eventbee.cachemanage.CacheLoader;
import com.eventbee.general.DBManager;
import com.eventbee.general.DbUtil;
import com.eventbee.general.GenUtil;
import com.eventbee.general.StatusObj;
import com.eventregister.TicketingInfo;
import com.eventregister.TicketsDB;

public class TicketSettingsLoader implements CacheLoader{

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
	  
	  Map ticketSettingsMap=new HashMap();	
	  TicketsDB ticketdb=new TicketsDB();
	  	  
	  HashMap configMap=ticketdb.getConfigValuesFromDb(groupid);
	  ticketSettingsMap.put("configmap", configMap); 
	  	  
	  if(ticketdb.isCouponcodeExists(groupid))ticketSettingsMap.put("discountExists", "yes");
	  else ticketSettingsMap.put("discountExists", "no");
	  	  
	  String currencyformat=DbUtil.getVal("select currency_symbol from currency_symbols where currency_code in (select currency_code from event_currency where eventid=?)",new String[]{groupid});
	  if(currencyformat==null) currencyformat="$";
	  ticketSettingsMap.put("currencyformat", currencyformat);
	  	  
	  if("YES".equals(GenUtil.getHMvalue(configMap,"event.seating.enabled","")))
		  ticketSettingsMap.put("seatticketid",com.eventregister.SeatingDBHelper.getAllticketid(groupid));
	  	  
	  ticketSettingsMap.put("TicketDisplayOptionsMap",DisplayAttribsDB.getAttribValues(groupid,"TicketDisplayOptions"));
	  ticketSettingsMap.put("RegFlowWordingsMap",DisplayAttribsDB.getAttribValues(groupid,"RegFlowWordings"));
	  
	  TicketingInfo ticketingInfo = new TicketingInfo();
	  ticketSettingsMap.put("tktFormatMap", ticketingInfo.getTicketMessage(groupid));
	  
	  return ticketSettingsMap;
	   
   }

}
