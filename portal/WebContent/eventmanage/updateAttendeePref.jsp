<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.event.DateTime,com.eventbee.editevent.EditEventDB"%>
<%@ page import="com.eventbee.general.*,java.sql.*"%>
<%@ page import="com.eventbee.general.formatting.*"%>
<%@ page import="com.eventbee.general.validations.DateValidation"%>
<%@ page import="com.eventbee.general.*,com.eventbee.context.ContextConstants,com.eventbee.authentication.*" %>
<%
String CONFIG_INFO_INSERT="insert into config(config_id, name, value) select config_id,?,? from eventinfo where eventid=?";
 String CONFIG_KEY_DELETE="delete from config where config_id=(select config_id from eventinfo where eventid=?) and name=?";

 
String pref_val=request.getParameter("prefval");
String groupid=request.getParameter("GROUPID");

EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, "Updateattendeepref.jsp", "null","pref_value is "+pref_val,null);
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, "Updateattendeepref.jsp", "null","groupid is "+groupid,null);
String str=""; 
if("yes".equalsIgnoreCase(pref_val)){
str="Show Attendee List";
pref_val="No";
}else{
pref_val="Yes";
str="Hide Attendee List";
}
String purpose=request.getParameter("purpose");
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, "Updateattendeepref.jsp", "null", "purpose value is"+purpose,null);
if ("attendeePage".equalsIgnoreCase(purpose))
{
StatusObj statobj=DbUtil.executeUpdateQuery(CONFIG_KEY_DELETE,new String[]{groupid,"attedeepage.attendee.show"});
statobj=DbUtil.executeUpdateQuery(CONFIG_INFO_INSERT,new String[]{"attedeepage.attendee.show",pref_val,groupid});
}else{
StatusObj statobj=DbUtil.executeUpdateQuery(CONFIG_KEY_DELETE,new String[]{groupid,"eventpage.attendee.show"});
statobj=DbUtil.executeUpdateQuery(CONFIG_INFO_INSERT,new String[]{"eventpage.attendee.show",pref_val,groupid});
}
%>

<%
if ("attendeePage".equalsIgnoreCase(purpose)){%>
<a HREF='#' onClick='configureEventView("eventattendeepref1","/portal/eventmanage/updateAttendeePref.jsp?purpose=attendeepage&GROUPID=<%=groupid%>&prefval=<%=pref_val%>","<%=pref_val%>","Attendee list preferences updated successfully")' ><%=str%></a>
<%}else{%>
<a HREF='#' onClick='configureEventView("eventattendeepref","/portal/eventmanage/updateAttendeePref.jsp?purpose=event&GROUPID=<%=groupid%>&prefval=<%=pref_val%>","<%=pref_val%>","Attendee list preferences updated successfully")' ><%=str%></a>
<%}%>

