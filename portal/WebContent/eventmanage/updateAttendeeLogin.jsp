<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.*,java.sql.*"%>

<%
String UPDATEQRY="update eventinfo set showlogin=? where eventid=?";
 
String pref_val=request.getParameter("prefval");
String groupid=request.getParameter("GROUPID");
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, "updateAttendeeLogin.jsp", "null","pref_value is "+pref_val,null);
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, "updateAttendeeLogin.jsp", "null","groupid is "+groupid,null);
String str=""; 
if("Yes".equalsIgnoreCase(pref_val)){
str="Show Eventbee Login Box During Registration";
pref_val="No";
}else{
pref_val="Yes";
str="Hide Eventbee Login Box During Registration";
}
String purpose=request.getParameter("purpose");
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, "updateAttendeeLogin.jsp", "null", "purpose value is"+purpose,null);
if ("event".equalsIgnoreCase(purpose)){
StatusObj statobj=DbUtil.executeUpdateQuery(UPDATEQRY,new String[]{pref_val,groupid});
}
%>

<%
if ("event".equalsIgnoreCase(purpose)){%>
<a HREF='#' onClick='configureEventView("eventattendeelogin","/portal/eventmanage/updateAttendeeLogin.jsp?purpose=event&GROUPID=<%=groupid%>&prefval=<%=pref_val%>","<%=pref_val%>","Updated Eventbee Login Box Display Setting")' ><%=str%></a>
<%}%>

