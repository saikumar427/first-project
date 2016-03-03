package com.eventbee.regcaheloader;

import java.util.HashMap;
import java.util.Map;

import com.eventbee.cachemanage.CacheLoader;
import com.eventregister.SeatingDBHelper;

public class SeatingVenueLoader implements CacheLoader{
	
 	long refreshInterval=30*1000;
	long maxIdleTime=60*1000;
	Map <String,String> cMap;
	public long getRefreshInterval(){return refreshInterval;}
	public void setRefreshInterval(long ri){refreshInterval=ri;}
	public long getMaxIdleTime(){return maxIdleTime;}
	public void setMaxIdleTime(long mtime){maxIdleTime=mtime;}
	public void setConfigMap(Map<String,String> cMap){this.cMap=cMap;}
	public Map <String,String> getConfigMap(){return cMap;}
   
   public Map load(String token){
	   
	   Map seatingVenueDetailsMap=new HashMap();	
	   String[] ids = token.split("_");
	   String groupid=ids[0];
	   String venueid=ids[1];
	   System.out.println("#### SeatingVenueLoader groupid: "+groupid+" venueid: "+venueid);
	   seatingVenueDetailsMap.put("venue_layout", SeatingDBHelper.GetVenueLayout(venueid));
	   seatingVenueDetailsMap.put("allcoted_ticketid_for_seatgroupid", SeatingDBHelper.getAllcotedTicketidForSeatgroupid(groupid,venueid));
	   seatingVenueDetailsMap.put("venue_sections", SeatingDBHelper.getSection(venueid));
	   seatingVenueDetailsMap.put("allotedseats", SeatingDBHelper.getAllotedSeats(groupid,""));
	   seatingVenueDetailsMap.put("ticket_seat_colors", SeatingDBHelper.getTicketSeatColors(groupid));
	   seatingVenueDetailsMap.put("ticket_group_details", SeatingDBHelper.getTicketGroupdetails(groupid));
	   seatingVenueDetailsMap.put("seattickets_group_details", SeatingDBHelper.getSeatingTicketGroupdetails(groupid));
	   
	   
	   return seatingVenueDetailsMap;
	   
   }



}
