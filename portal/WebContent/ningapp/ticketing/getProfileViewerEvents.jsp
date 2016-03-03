<%@ page import="java.util.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.authentication.Authenticate" %>
<%@ page import="com.eventbee.editevent.EditEventDB"%>
<%!
String query="select eventid ,eventname,to_char(start_date,'MM/DD')as startdate, created_at"
+"  from eventinfo  where status='ACTIVE' and "
+" mgr_id  =CAST(? AS INTEGER) and eventid in(select evt_id from price)" 
+" and eventid not in(select CAST(eventid AS INTEGER) from group_events)" 
+" and end_date>=now() "
+" order by startdate limit ?";	  

Vector GetNingEventDetails(int limit, String userid){
Vector v=new Vector();
DBManager dbmanager=new DBManager();
StatusObj stobj=dbmanager.executeSelectQuery(query,new String []{userid, ""+limit});
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
//String Query="select group_title,event_groupid from user_groupevents where userid=?"
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
Vector groupsvector=getEventGroups(userid);
String view=request.getParameter("view");
String ownerstatus=request.getParameter("ownerstatus");	 
String domain=request.getParameter("domain");	 
String username=DbUtil.getVal("select login_name from authentication where user_id = ?",new String[]{userid});
String eventurl="";
EditEventDB evtDB=new EditEventDB();
String cnr=null;
%>
<link href="http://www.eventbee.com/home/ning/css/style.css" rel="stylesheet" type="text/css" />






<%
int limit=15;
String oid=request.getParameter("oid");
String oname=request.getParameter("oname");

%>

<style>
#fullbody {
width:710px;
height:auto;
align: center;
}
#eventsbody	{
width:710px;
height:600;
overflow: auto;
/*background-color:#f5f5f5;*/
align: center;
padding-left: 5px;
}	
	
#topmorginevent {
width:685px;
height:27px;
margin-top:6px;
border-bottom:1px dotted #EE9C00;

}	
#topmorginevent1 {
width:685px;
height:27px;
margin-top:6px;

}	

#eventsname {
width: 350;
height:27px;
/*background-color:#e6e6e6;*/
float:left;
}
#register {
width: 310;
height:27px;
/*background-color:#f5f5f5;*/
float:right;
padding-left:5px;
}
a {
font-size:14px;
}
        
#panel	{
width:700px;
height:28px;
text-align:center;
border:#EE9C00 solid;
padding:13px 0px 0px 0px;
}


        
        
</style>

<div id="fullbody">

<div id="eventsbody" align="left" >
<%

String style="";
if(request.getParameter("bgColor")!=null){
 style= "body{"
+"background: "+request.getParameter("bgColor")+";"
+"text-align: center;"
+"padding: 0;"
+"font: 62.5% verdana, sans-serif;"
+"color:"+request.getParameter("fontColor")+";"
+"}"
+"#container {"
+"margin: 0 auto;"
+"text-align: left;"
+"width: 700px;"
+"color: "+request.getParameter("fontColor")+";"
+"background:"+request.getParameter("bgColor")+";"
+"padding: 0px;"
+"}"
+"a {"
+"color: "+request.getParameter("anchorColor")+";"
+"}"
+".medium {"
+"font: bold 20px veradana, sans-serif;"
+"color:"+request.getParameter("fontColor")+";"
+"}";
}
 

%>

<style>
<%=style%>
</style>


<%
Vector events = GetNingEventDetails(limit, userid);

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
eventurl="/event?eid="+eventid+"&oid="+oid+"&context=ning&domain="+domain+"&bgColor="+request.getParameter("bgColor")+"&fontColor="+request.getParameter("fontColor")+"&anchorColor="+request.getParameter("anchorColor");

%>

<div id="topmorginevent">
<table width="100%" align="center"><tr>
<td id="eventsname" ><span class="eventstyle"><%=event.get("startdate")%>&nbsp;&nbsp;<a href="<%=eventurl%>"  ><%=eventname%></a></span>
</td>

<td  id="register"  align="right"><span class="eventstyle"><a href="/event?eid=<%=event.get("eventid")%>&oid=<%=oid%>&domain=<%=domain%>&context=ning"><%=cnr%></a></span>
</td></tr>
</table>
</div>

<%
}


String base="evenbase";
if(groupsvector!=null&&groupsvector.size()>0){
HashMap fetchedGroups=new HashMap();
for(int j=0;j<groupsvector.size();j++){
if(j%2==0) base="evenbase";
else
base="oddbase";
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
eventurl="/event?eid="+eventid+"&oid="+oid+"&context=ning&domain="+domain;

%>

<div id="topmorginevent">

<table width="100%" align="center"><tr>
<td id="eventsname" ><span class="eventstyle">&nbsp;&nbsp;&nbsp;<%=eventdetailsHash.get("startdate")%>&nbsp;&nbsp;<a href="<%=eventurl%>"  ><%=eventname%></a></span>
</td>

<td  id="register"  align="right"><span class="eventstyle"><a href="/event?eid=<%=eventid%>&oid=<%=oid%>&context=ning&domain=<%=domain%>"><%=cnr%></a></span>

</td></tr>
</table>
</div> 
<%}%> 
<%}}}%>




 
<%
if(!displayevents){
%>
<br/>
<br/>
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
<a href='/ningapp/ticketing/canvasownerpagebeelets.jsp;jsessionid=<%=session.getId()%>?oid=<%=oid%>'  >Click here to list/manage your event</a>
</div>
<%	
}
%>
</div>
