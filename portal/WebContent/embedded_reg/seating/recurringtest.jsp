<%@ page import="java.util.*,com.eventbee.general.*"%>

<%!
private  String datesQuery="select price_id,to_char(startdate,'yyyy') as start_yy,to_char(startdate,'mm') as start_mm,to_char(startdate,'dd') as start_dd,"
                   +"to_char(enddate,'yyyy') as end_yy,to_char(enddate,'mm') as end_mm,to_char(enddate,'dd') as end_dd,starttime,endtime,endstatus,startstatus,soldstatus from recurring_event_tickets_info where evt_id=? and eventdate=? and displaystatus<>'N'";

void getrecurringEventdetails(String eventid,String evtdate)
{



HashMap detailsMap=new HashMap();
try{
 DBManager db=new DBManager();
 StatusObj sb=db.executeSelectQuery(datesQuery,new String[]{eventid,evtdate});

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

}
%>


<%
getrecurringEventdetails("798989222","Thu, Apr 14, 2011 09:00 AM");

%>