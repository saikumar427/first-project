<%@ page import="com.eventbee.general.DbUtil,com.eventbee.general.GenUtil" %>
<%@ page import="com.eventregister.TicketsDB,java.util.HashMap" %>
<%@ page import="com.eventbee.general.StatusObj,com.eventbee.general.DBManager" %>
<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>


<%!
final String themeQuery="select themetype,themecode from user_roller_themes where refid=? and module=?";
HashMap getThemeCodeAndType(String refid){
HashMap hm=new HashMap();
DBManager db=new DBManager();
StatusObj sb=db.executeSelectQuery(themeQuery,new String[]{refid,"event"});
if(sb.getStatus())
{
hm.put("themetype",db.getValue(0,"themetype",""));
hm.put("themecode",db.getValue(0,"themecode",""));
}
return hm;
}
%>

<%
String csscontent=null;
String themetype=null;
String themecode=null;
String eid=request.getParameter("eid");
String customtheme=request.getParameter("customtheme");
HashMap themeDetails=getThemeCodeAndType(eid);
if(themeDetails!=null){
	themetype=(String)themeDetails.get("themetype");
	themecode=(String)themeDetails.get("themecode");
}
if("no".equals(customtheme) && "CUSTOM".equals(themetype)){
	csscontent=DbUtil.getVal("select cssurl  from ebee_roller_def_themes where module =? and themecode=?",new String[]{"event","basic"});
}
else{
	if("DEFAULT".equals(themetype))
		csscontent=DbUtil.getVal("select cssurl  from ebee_roller_def_themes where module =? and themecode=?",new String[]{"event",themecode});
	else if("CUSTOM".equals(themetype))
		csscontent=DbUtil.getVal("select cssurl  from user_custom_roller_themes where refid=?",new String[]{eid});
	else{
		csscontent=DbUtil.getVal("select cssurl  from user_customized_themes where themeid=? and module='event'",new String[]{themecode});
	}
}
TicketsDB ticketInfo=new TicketsDB();
HashMap configMap=ticketInfo.getConfigValuesFromDb(eid);
boolean isrecurringevent=("Y".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.recurring","N")));
boolean registrationAllowed=("Yes".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.poweredbyEB","no")));
boolean isrsvpd=("Yes".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.rsvp.enabled","no")));
%>
	<html>
	<head>
	<style>
	<%=csscontent%>
	#attendeeinfo{
		padding-left:10px;
	}
	#leftlist li{
	margin-left:15px;
	}
	</style>
	<script type='text/javascript' language='JavaScript' src='/home/js/jQuery.js'></script>
	<script type='text/javascript' language='JavaScript' src='/home/js/prototype.js'></script>
	<script type='text/javascript' language='JavaScript' src='/home/js/ajax.js'>function ajaxdummy(){ }</script>
	<script src='/home/js/widget/iframehelper.js' type='text/javascript'></script>
	<script type="text/javascript" src="/home/js/whosattending.js" ></script>
	</head>
	<body>
	<script>
	iframeQuantity = 12;
	oldHeight = 0;
	scrollIframe = false;
	oldScrollIframe = false;
	document.body.style.overflow = "hidden";
	</script>
	<ul id="leftList"  style="margin:0px; padding:0px;">
	  	<table width="100%" class="rightboxcontent">
	    <tr><td>
	    <%if(isrecurringevent){%>
		<%@ include file='/customevents/recurring.jsp' %>
		<%TicketsDBZ tktdb=new TicketsDBZ();
		String eventdatedropdown=tktdb.getRecurringEventDates(eid,"attendeelist");
		if(eventdatedropdown==null)
			eventdatedropdown="<select onchange=showAttendeesList('"+eid+"'); id='event_date' name='event_date' style='display: block;'></select>";
		%>
	    <table >
	    <tr><td><% if(eventdatedropdown!= null && !"".equals(eventdatedropdown)){%><%=eventdatedropdown%><%}%></td><tr>
	    </table>
	    <%}%>
	    </td></tr>
	    <tr><td>
	     <div id='attendeeinfo'> </div>
		 <div id='whosattendingimageload'><center>Loading...<br> <img src="/home/images/ajax-loader.gif"></center></div>
	    <%if(isrsvpd){%>
	    <script>
		showAttendeesList("<%=eid%>");
		//getRsvpAttendeeList
		</script>
	    <%}else{%>
	    <script>showAttendeesList("<%=eid%>")</script>
	    <%}%>
	    </td></tr>
		<tr><td height='10px'></td></tr>
		<tr><td align="left"><a href="/" target="_blank"><img src="/main/images/home/poweredbyeventbee.jpg" alt="Powered by Eventbee Online Registration & Ticketing" title="Powered by Eventbee" border="0">
	   </td></tr> </table>
		</ul>
		<div id="generatedIFrames" style="display: none;"></div>
		<script>window.setInterval(generateIFrames,100);</script>
		
		
		</body>
		</html>
		