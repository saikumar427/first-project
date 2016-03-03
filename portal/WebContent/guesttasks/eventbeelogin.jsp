<%@ page import="com.eventbee.general.*"%>

<%
String login_name=null;
String evtname=null;
if((String)session.getAttribute("evtmgrname")!=null)
	login_name=(String)session.getAttribute("evtmgrname");
else if((String)session.getAttribute("evtmgrname")==null)
      login_name=DbUtil.getVal("select au.login_name from authentication au,eventinfo e where au.user_id=e.mgr_id and eventid=?",new String[]{request.getParameter("GROUPID")});

if((String)session.getAttribute("evtname")!=null)
	evtname=(String)session.getAttribute("evtname");
else if((String)session.getAttribute("evtname")==null)
	evtname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{request.getParameter("GROUPID")});

String listurl=ShortUrlPattern.get(login_name)+"/event?eventid="+request.getParameter("GROUPID");
String evtlink="<a href='"+listurl+"'>"+evtname+"</a>";
String tktlink="<a href='/guesttasks/regticket.jsp?GROUPID="+request.getParameter("GROUPID")+"'>Tickets</a>";
request.setAttribute("tasktitle","Event Registration > "+evtlink+" > "+tktlink+" > Login");
request.setAttribute("stype","Events");
%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/eventregister/reg/eventbeelogin.jsp";
%>
	      		
<%@ include file="/templates/taskpagebottom.jsp" %>
		