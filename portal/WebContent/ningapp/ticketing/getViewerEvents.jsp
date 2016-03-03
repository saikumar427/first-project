<%@ page import="java.util.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.authentication.Authenticate" %>
<%@ page import="com.eventbee.editevent.EditEventDB"%>
<%!
String query="select eventid ,eventname,to_char(start_date,'MM/DD')as startdate, created_at"
+"  from eventinfo  where status='ACTIVE' and "
+" mgr_id  =CAST(? AS INTEGER) and eventid in(select evt_id from price)" 
+" and eventid not in(select eventid::integer from group_events)" 
+" and end_date>=now() "
+" order by startdate limit 9";	  

Vector GetNingEventDetails(int limit, String userid){
Vector v=new Vector();
DBManager dbmanager=new DBManager();
StatusObj stobj=dbmanager.executeSelectQuery(query,new String []{userid});
for(int i=0;i<stobj.getCount();i++){
HashMap hm=new HashMap();
hm.put("startdate",dbmanager.getValue(i,"startdate",""));
hm.put("eventname",dbmanager.getValue(i,"eventname","").replaceAll("'","'"));
hm.put("eventid",dbmanager.getValue(i,"eventid",""));
v.addElement(hm);
}
return v;	  
}	

Vector getEventGroups(String userid){
Vector eventgroupsvector= new Vector();
DBManager dbm =new DBManager();
HashMap groupdetails= null;		
String Query="select distinct c.group_title,c.event_groupid , b.start_date"
              +" from group_events a, eventinfo b,  user_groupevents c"
		+" where a.eventid in(select CAST(evt_id AS VARCHAR) from price) and status='ACTIVE' and end_date>=now() and a.eventid=CAST(b.eventid AS VARCHAR)"
		+" and c.userid=? and c.event_groupid=a.event_groupid"
		+" order by b.start_date";
StatusObj statobj=dbm.executeSelectQuery(Query,new String[] {userid});
if(statobj.getStatus())	{
for(int k=0;k<statobj.getCount();k++){
groupdetails =new HashMap();			
groupdetails.put("group_title",dbm.getValue(k,"group_title",""));
groupdetails.put("event_groupid",dbm.getValue(k,"event_groupid",""));
eventgroupsvector.add(groupdetails);
}

}

return eventgroupsvector;
}

Vector getGroupEvents(String event_groupid){
Vector groupeventsvector= new Vector();
DBManager dbm =new DBManager();
HashMap eventdetails= null;		
String Query="select a.eventid,b.eventname,to_char(start_date,'MM/DD')as startdate, created_at from group_events a, eventinfo b where a.event_groupid=? and a.eventid in(select evt_id::varchar from price) and status='ACTIVE' and end_date>=now() and a.eventid=b.eventid::varchar order by position"; 
StatusObj statobj=dbm.executeSelectQuery(Query,new String[] {event_groupid});
if(statobj.getStatus())	{
for(int k=0;k<statobj.getCount();k++){
eventdetails =new HashMap();			
eventdetails.put("eventid",dbm.getValue(k,"eventid",""));
eventdetails.put("eventname",dbm.getValue(k,"eventname",""));
eventdetails.put("startdate",dbm.getValue(k,"startdate",""));
groupeventsvector.add(eventdetails);
}

}

return groupeventsvector;
}

%>





<% 
boolean displayevents=false;
session.setAttribute("platform","ning");
session.setAttribute("ningoid",request.getParameter("oid"));
session.setAttribute("ningvid",request.getParameter("vid"));
String userid=DbUtil.getVal("select ebeeid from ebee_ning_link where nid=?",new String[]{request.getParameter("oid")});
Vector groupsvector=new Vector();
if(userid!=null && !"".equals(userid))
groupsvector=getEventGroups(userid);
String view=request.getParameter("view");
String ownerstatus=request.getParameter("ownerstatus");	 
EditEventDB evtDB=new EditEventDB();
String cnr=null;
%>
<style>
#topmorginevent {
width:480px;
height:27px;
margin-top:6px;
border-bottom:1px dotted #EE9C00;
}	
#topmorginevent1 {
width:480px;
height:27px;
margin-top:6px;

}	
</style>
<div id="fullbody">
<%
int limit=9;
String oid=request.getParameter("oid");
String oname=request.getParameter("oname");
%>
<div id="eventsbody" align="left" style="overflow : auto;">
<%
Vector events=new Vector();
if(userid!=null && !"".equals(userid))
events = GetNingEventDetails(limit, userid);

for(int i=0;i<events.size();i++){
displayevents=true;
HashMap event=(HashMap)events.get(i);

String eventname=GenUtil.TruncateData((String)event.get("eventname"),40);

eventname=eventname.replace("'","");

eventname=eventname.replace("&","");
String eventid=(String)event.get("eventid");
cnr=evtDB.getConfig(eventid,"event.cnr");
if(cnr==null || "".equals(cnr.trim()))
cnr="Register";
cnr=GenUtil.TruncateData(cnr,18);
%>
<div id="topmorginevent">

<div id="eventsname"><%=event.get("startdate")%>&nbsp;&nbsp;<a href="#" onClick='registerEvent(<%=event.get("eventid")%>);'><%=eventname%></a></div>


<div  id="register" align="right"><a href="#" onClick='registerEvent(<%=event.get("eventid")%>);'><%=cnr%></a></div>


</div>

<%
}



if(groupsvector!=null&&groupsvector.size()>0){
HashMap fetchedGroups=new HashMap();
for(int j=0;j<groupsvector.size();j++){
HashMap groupdetailsHash=(HashMap)groupsvector.elementAt(j);
String group_title=(String)groupdetailsHash.get("group_title");
String event_groupid=(String)groupdetailsHash.get("event_groupid");
if(fetchedGroups.containsKey(event_groupid) ) {

continue;
}
fetchedGroups.put(event_groupid,"F");
Vector groupEventsList=getGroupEvents(event_groupid);
if(groupEventsList.size()>0){
displayevents=true;
%>
<div id="topmorginevent1">
<div id="eventsname"><b><%=group_title%></b></div>
</div>
<%

for(int k=0;k<groupEventsList.size();k++){
HashMap eventdetailsHash=(HashMap)groupEventsList.elementAt(k);
String eventid=(String)eventdetailsHash.get("eventid");
String eventname=(String)eventdetailsHash.get("eventname");
eventname=GenUtil.TruncateData((String)eventdetailsHash.get("eventname"),40);
cnr=evtDB.getConfig(eventid,"event.cnr");
if(cnr==null || "".equals(cnr.trim()))
cnr="Register";
cnr=GenUtil.TruncateData(cnr,18);

%>
<div id="topmorginevent">
<div id="eventsname">&nbsp;&nbsp;&nbsp;<%=eventdetailsHash.get("startdate")%>&nbsp;&nbsp;<a href="#" onClick='registerEvent(<%=eventid%>);'><%=eventname%></a></div>


<div  id="register" align="right"><a href="#" onClick='registerEvent(<%=eventid%>);'><%=cnr%></a></div>

</div>
<%}}}}%>
 
<%
if(!displayevents){
%>

<div id="comment" align="center">
No Upcoming Events with Registration
</div>
<%
}
%>
</div> 
<%
if("true".equalsIgnoreCase(ownerstatus)){

%>
<div id="panel"  align="center" >
<a href="#" onClick="gotoCanvas();" >Click here to list/manage your event</a>
</div>
<%	
}
%>


</div>