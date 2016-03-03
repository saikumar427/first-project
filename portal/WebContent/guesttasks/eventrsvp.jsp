<%@ page import="com.eventbee.general.*" %>
<%
 String serveraddress="http://"+EbeeConstantsF.get("serveraddress","")+"/";

String login_name="";
String evtname="";

request.setAttribute("CustomLNF_Type","EventDetails");
request.setAttribute("CustomLNF_ID",request.getParameter("GROUPID"));


if((String)session.getAttribute("evtname")!=null)
	evtname=(String)session.getAttribute("evtname");
else if((String)session.getAttribute("evtname")==null)
	evtname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{request.getParameter("GROUPID")});

String listurl=serveraddress+"event?eid="+request.getParameter("GROUPID");
if("FB".equals(request.getParameter("context"))){
listurl+="&context=FB";
}
String evtlink="<a href='"+listurl+"'>"+evtname+"</a>";

 
 
 
 
 
 // request.setAttribute("mtype","My Console");
 // request.setAttribute("stype","Events");
 request.setAttribute("tasktitle",evtlink+" > Attendee Details");
  %>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/eventregister/eventrsvp.jsp";
	footerpage="/main/eventfootermain.jsp";
%>
	      		
<%@ include file="/templates/taskpagebottom.jsp" %>
	

	