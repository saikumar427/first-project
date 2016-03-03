<%@ page import="java.util.*,com.eventbee.general.DBManager,com.eventbee.general.DbUtil,com.eventbee.general.StatusObj"%>


<%!
public class TicketsDBZ{

public String getRecurringEventDates(String eventid,String purpose){

String query="select  to_char(zone_startdate+cast(cast(to_timestamp(COALESCE(zone_start_time,'00'),'HH24:MI:SS') as text) as time ),'Dy, Mon DD, YYYY HH12:MI AM') as evt_start_date"
	      +" from event_dates where eventid=? and (zone_startdate+cast(cast(to_timestamp(COALESCE(zone_start_time,'00'),'HH24:MI:SS') as text) as time ))>=current_date order by (zone_startdate+cast(cast(to_timestamp(COALESCE(zone_start_time,'00'),'HH24:MI:SS') as text) as time ))";
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
str="<select name='eventdate' id='eventdate'  onchange=getTicketsJson('"+eventid+"');>";
else
str="<select name='event_date' id='event_date' onchange=showAttendeesList('"+eventid+"');>";
for(int i=0;i<al.size();i++){
str=str+"<option val='"+(String)al.get(i)+"'>"+(String)al.get(i)+"</option>";
}
str=str+"</select>";

}
return str;

}

}
%>