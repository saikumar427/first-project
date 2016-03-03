<%@ page import="java.util.*,com.eventbee.general.*" %>

<%!
	  String query="select eventid ,eventname,to_char(start_date,'MM/DD')as startdate, created_at"
	                 +"  from eventinfo  where status='ACTIVE' and "
	                 +" mgr_id in(select distinct ebeeid from ebee_ning_link where nid =?) and eventid in(select evt_id from price)" 
	                 +" and end_date>=now() order by created_at desc limit ?";	  
	  
	  Vector GetNingEventDetails(int limit, String oid){
		  Vector v=new Vector();
		  DBManager dbmanager=new DBManager();
		  StatusObj stobj=dbmanager.executeSelectQuery(query,new String []{oid, ""+limit});
		  for(int i=0;i<stobj.getCount();i++){
			HashMap hm=new HashMap();
			hm.put("startdate",dbmanager.getValue(i,"startdate",""));
			hm.put("eventname",dbmanager.getValue(i,"eventname","").replaceAll("'","'"));
			hm.put("eventid",dbmanager.getValue(i,"eventid",""));
			v.addElement(hm);
	  	  }
	  	  return v;	  
	  }	  
%>
<link href="http://test.eventbee.com:9090/home/ning/css/style.css" rel="stylesheet" type="text/css" />
<div id="fullbody">
	  
	  <div id="header"></div>	  
	  
<%
	  int limit=9;
	  String oid=request.getParameter("oid");
	  if("true".equalsIgnoreCase(request.getParameter("ownerstatus"))){
	  limit=9;
%>
	  <br/>
	  <div id="comment" style="padding:25px 0px 0px 0px;" align="center">
	  <div id="arrow"></div>
	  <a href='#' onClick='gotoCanvas();' >Click here</a> to list a new event / manage your existing events
	  </div>
<%	
	  }
%>
	  
	  
	  
	  

	  <div id="eventsbody">
	<%
         Vector events = GetNingEventDetails(limit, oid);
	  if(events.size()==0){
	 %>
	  	<br/>
	  	<div id="comment" style="padding:25px 0px 0px 0px;" align="center">
	  	<div id="arrow"></div>
	  	 No Upcoming Events with Registration
	  	</div>
	  <%
	  }else{
	  	for(int i=0;i<events.size();i++){
	  	HashMap event=(HashMap)events.get(i);
	  %>
	  	<div id="topmorginevent">
	  		
	  		<div id="eventsname"><div class="eventstyle"><a href="#" onClick='registerEvent(<%=event.get("eventid")%>);' class="blackText" ><%=event.get("startdate")%>&nbsp;&nbsp;&nbsp;<%=event.get("eventname")%></a></div>
	  		</div>
	  		<div  id="register"><a href="#" onClick='registerEvent(<%=event.get("eventid")%>);'><img src="http://test.eventbee.com:9090/home/ning/images/register.gif" width="72" height="27" border="0" /></a></div>
	 		 <div style="clear:both"></div>
	 		 <div style="clear:both"></div>
 	 </div>
	 
	   	<%
	   	}
	   }
	   	%>
		
	</div>  
		<div id="footer">
			<!--
				<div id="previous"><a href="#"><img src="http://test.eventbee.com:9090/home/ning/images/previous.gif" width="72" height="27" border="0" /></a></div>
				<div id="next"><a href="#"><img src="http://test.eventbee.com:9090/home/ning/images/next.gif" width="72" height="27" border="0" /></a></div>
			-->
		</div>

</div>