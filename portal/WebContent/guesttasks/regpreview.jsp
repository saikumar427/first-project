<%@ page import="com.eventbee.general.*" %>

<%
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","")+"/";
String evtname=null;

if((String)session.getAttribute("evtname")!=null)
	evtname=(String)session.getAttribute("evtname");
else if((String)session.getAttribute("evtname")==null)
	evtname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{request.getParameter("GROUPID")});

String listurl=serveraddress+"event?eid="+request.getParameter("GROUPID");
String evtlink="<a href='"+listurl+"'>"+evtname+"</a>";
String tktlink="<a href='/guesttasks/regticket.jsp?GROUPID="+request.getParameter("GROUPID")+"'>Tickets</a>";
String attdetlink="<a href='/guesttasks/personalInfo.jsp?GROUPID="+request.getParameter("GROUPID")+"'>Attendee Details</a>";
request.setAttribute("tasktitle","Event Registration > "+evtlink+" > "+tktlink+" > "+attdetlink+" > Preview");
request.setAttribute("stype","Events");

%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/eventregister/reg/preview.jsp";
	%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	