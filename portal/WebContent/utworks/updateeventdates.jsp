
<%@ page import="com.eventbee.general.*" %>
<%@ page import="java.util.*" %>
<%@ include file="timezoneConversions.jsp" %>
<%!
void updateEventDates(){
try{
String query="update event_dates set zone_startdate=eventdate,zone_enddate=eventdate,zone_start_time=e.starttime,zone_end_time=e.endtime   from eventinfo e where event_dates.eventid=e.eventid";
StatusObj sb=DbUtil.executeUpdateQuery(query,new String[]{});
System.out.println("sb.getStatus()---"+sb.getStatus());
if(sb.getStatus()){
String query1="select eventid,eventdate,to_char(zone_startdate,'yyyy') as start_yy,to_char(zone_startdate,'mm') as start_mm,to_char(zone_startdate,'dd') as start_dd,"
               +"to_char(zone_enddate,'yyyy') as end_yy,to_char(zone_enddate,'mm') as end_mm,to_char(zone_enddate,'dd') as end_dd,zone_start_time as starttime,zone_end_time as endtime from event_dates";
DBManager db=new DBManager();
sb=db.executeSelectQuery(query1,null);
if(sb.getStatus()){
ArrayList al=new ArrayList();
for(int i=0;i<sb.getCount();i++){
HashMap <String,String>hmap=new HashMap<String,String>();
hmap.put("startYear",db.getValue(i,"start_yy",""));
hmap.put("startMonth",db.getValue(i,"start_mm",""));
hmap.put("startDay",db.getValue(i,"start_dd",""));
hmap.put("endYear",db.getValue(i,"end_yy",""));
hmap.put("endMonth",db.getValue(i,"end_mm",""));
hmap.put("endDay",db.getValue(i,"end_dd",""));
hmap.put("starttime",(db.getValue(i,"starttime","")==null|| "".equals(db.getValue(i,"starttime","")) )?"01:00":db.getValue(i,"starttime","")   );
hmap.put("endtime",(db.getValue(i,"endtime","")==null|| "".equals(db.getValue(i,"endtime","")) )?"01:00":db.getValue(i,"endtime","")   );
hmap.put("eventid",db.getValue(i,"eventid",""));    
hmap.put("eventdate",db.getValue(i,"eventdate",""));    
getTimezones(hmap,db.getValue(i,"eventid",""));
DbUtil.executeUpdateQuery("update event_dates set est_startdate=?,est_enddate=?,est_start_time=?,est_end_time=? where eventid=? and eventdate=to_date(?,'yyyy-mm-dd')",new String[]{hmap.get("startdate"),hmap.get("enddate"),hmap.get("starttime"),hmap.get("endtime"),hmap.get("eventid"),hmap.get("eventdate")});
}
}
}
    
}
catch(Exception e){

}

}









%>


<%

updateEventDates();

%>