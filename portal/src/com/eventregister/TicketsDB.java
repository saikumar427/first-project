package com.eventregister;

import java.util.ArrayList;
import java.util.HashMap;
//import java.util.*;
//import com.eventbee.general.*;

import com.eventbee.general.DBManager;
import com.eventbee.general.DbUtil;
import com.eventbee.general.StatusObj;


public class TicketsDB{

private  String memberTicketsQuery="select price_id from event_communities where eventid=?";
private  String DiscountsQuery="select 'yes' from coupon_master where groupid=? and coupontype='General'";
private  String ConfigQuery="select * from config where config_id=(select config_id from eventinfo where eventid=CAST(? AS BIGINT))";
private  String datesQuery="select price_id,to_char(startdate,'yyyy') as start_yy,to_char(startdate,'mm') as start_mm,to_char(startdate,'dd') as start_dd,"
                   +"to_char(enddate,'yyyy') as end_yy,to_char(enddate,'mm') as end_mm,to_char(enddate,'dd') as end_dd,starttime,endtime,endstatus,startstatus,soldstatus from recurring_event_tickets_info where evt_id=CAST(? AS BIGINT) and eventdate=? and displaystatus<>'N'";
private  String datesQueryfortckturl="select price_id,to_char(startdate,'yyyy') as start_yy,to_char(startdate,'mm') as start_mm,to_char(startdate,'dd') as start_dd,"
    +"to_char(enddate,'yyyy') as end_yy,to_char(enddate,'mm') as end_mm,to_char(enddate,'dd') as end_dd,starttime,endtime,endstatus,startstatus,soldstatus from recurring_event_tickets_info where evt_id=CAST(? AS BIGINT) and eventdate=?";

HashMap getrecurringEventdetails(String eventid,String evtdate,String ticketurlcode)
{



HashMap detailsMap=new HashMap();
try{
 DBManager db=new DBManager();
 String query=datesQuery;
 if(ticketurlcode!=null && !"".equals(ticketurlcode) &&!"null".equals(ticketurlcode)) query=datesQueryfortckturl;
 StatusObj sb=db.executeSelectQuery(query,new String[]{eventid,evtdate});

  if(sb.getStatus()){
    for(int i=0;i<sb.getCount();i++){
     HashMap hmap=new HashMap();
     hmap.put("startYear",db.getValue(i,"start_yy",""));
     hmap.put("startMonth",db.getValue(i,"start_mm",""));
     hmap.put("startDay",db.getValue(i,"start_dd",""));
     hmap.put("endYear",db.getValue(i,"end_yy",""));
     hmap.put("endMonth",db.getValue(i,"end_mm",""));
     hmap.put("endDay",db.getValue(i,"end_dd",""));
     hmap.put("starttime",(db.getValue(i,"starttime","")==null|| "".equals(db.getValue(i,"starttime","")) )?"01:00":db.getValue(i,"starttime","")   );
     hmap.put("endtime",(db.getValue(i,"endtime","")==null|| "".equals(db.getValue(i,"endtime","")) )?"01:00":db.getValue(i,"endtime","")   );
     hmap.put("endstatus",db.getValue(i,"endstatus",""));
     hmap.put("startstatus",db.getValue(i,"startstatus",""));
     hmap.put("soldstatus",db.getValue(i,"soldstatus",""));
     detailsMap.put(db.getValue(i,"price_id",""),hmap);
   }
 }
}
catch(Exception e){
System.out.println("exception in getrecurringEventdetails"+e.getMessage());

}
return detailsMap;

}


public  HashMap getConfigValuesFromDb(String eventid){
  HashMap confighm=new HashMap();
  try{
    DBManager db=new DBManager();
    StatusObj sb=db.executeSelectQuery(ConfigQuery,new String[]{eventid});
   if(sb.getStatus()){
     for(int i=0;i<sb.getCount();i++){
     confighm.put(db.getValue(i,"name",""),db.getValue(i,"value",""));
    }
   }
  }
catch(Exception e){
	System.out.println("exception in gettingConfigValuesFromDb"+e.getMessage());
   }

 return confighm;
}


public HashMap getMemberTicketsMap(String eventid){
HashMap memberTicketsMap=new HashMap();
try{
DBManager db=new DBManager();
StatusObj sb=db.executeSelectQuery(memberTicketsQuery,new String[]{eventid});
if(sb.getStatus())
{
for(int i=0;i<sb.getCount();i++){
memberTicketsMap.put(db.getValue(i,"price_id","0"),"");
}
}
}
catch(Exception e){
System.out.println("exception in getMemberTicketsMap"+e.getMessage());

}

return memberTicketsMap;
}


public boolean isCouponcodeExists(String eventid){
  boolean flag=false;
 try{
    String couponExists=DbUtil.getVal(DiscountsQuery,new String[]{eventid});
    if("yes".equals(couponExists))
    flag=true;
    else
    flag=false;

  }
  catch(Exception e){
        System.out.println("exception in isCouponcodeExists"+e.getMessage());
    }
   return flag;
}

public String getRecurringEventDates(String eventid,String purpose){

String query="select  to_char(zone_startdate+cast(cast(to_timestamp(COALESCE(zone_start_time,'00'),'HH24:MI:SS') as text) as time ),'Dy, Mon DD, YYYY HH12:MI AM') as evt_start_date"
	      +" from event_dates where eventid=CAST(? AS BIGINT) and (zone_startdate+cast(cast(to_timestamp(COALESCE(zone_start_time,'00'),'HH24:MI:SS') as text) as time ))>=current_date order by (zone_startdate+cast(cast(to_timestamp(COALESCE(zone_start_time,'00'),'HH24:MI:SS') as text) as time ))";
ArrayList al=new ArrayList();
DBManager db=new DBManager();
String str=null;
StatusObj stob=db.executeSelectQuery(query,new String[]{eventid} );
if(stob.getStatus()){
for(int i=0;i<stob.getCount();i++){
al.add(db.getValue(i,"evt_start_date",""));
}
}
return getRecurringDatesForEventTickets(al,purpose,eventid);
}

String getRecurringDatesForEventTickets(ArrayList al,String purpose,String eventid){
String str=null;
if(al!=null&&al.size()>0){
if("tickets".equals(purpose))
str="<select name='eventdate' id='eventdate'  onchange=getTicketsJsonBefore('"+eventid+"');>";
else
str="<select name='event_date' id='event_date' onchange=showAttendeesList('"+eventid+"');>";
for(int i=0;i<al.size();i++){
str=str+"<option value='"+(String)al.get(i)+"'>"+(String)al.get(i)+"</option>";
}
str=str+"</select>";

}
return str;

}





}