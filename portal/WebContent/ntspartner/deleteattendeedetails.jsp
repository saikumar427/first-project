<%@ page import="com.eventbee.general.*"%>
<%
StatusObj statob=null;	
String eid=request.getParameter("groupid");
String attendeekey=request.getParameter("attendeekey");
String transactionid=request.getParameter("transactionid");
statob=DbUtil.executeUpdateQuery("update eventattendee set eventid=-eventid where transactionid=? and attendeekey=? and eventid=?", new String []{transactionid,attendeekey,eid});
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.ERROR,"deleteattendeedetails.jsp page "," updating event attendee status is  "+statob.getStatus(),"",null);

%>
<status>success</status>
