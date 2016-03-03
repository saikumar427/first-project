
<%@ page import="java.io.IOException,java.util.*,com.eventbee.proxysignup.ProxySignupDB"%>
<%@ page import="com.eventbee.authentication.*,com.eventbee.context.ContextConstants,com.eventbee.general.*"%>
<%@ page import="com.eventbee.coupon.*,com.eventbee.event.BeeletController,com.eventbee.event.ticketinfo.*"%>
<%@ page import="com.eventbee.event.EventDB" %>

<%

String eventurl="";
String groupid=request.getParameter("GROUPID");
String code=request.getParameter("code");

String username="";
	HashMap evthm=EventDB.getEventInfo(groupid);
		   
	if(evthm!=null){
	username=(String)evthm.get("username");
	}
	
String	eventinfo1=DbUtil.getVal("select url from event_custom_urls where eventid=?",new String[]{groupid});
if(eventinfo1==null){
eventinfo1=eventinfo1=ShortUrlPattern.get(username)+"/event?eventid="+groupid;
	

 eventurl=eventinfo1+"&code="+code;
 }
 else
 {
 eventurl=eventinfo1+"/discount?code="+code;
 }
%>


<table  width='100%'><tr><td colspan='4'><div id='url'  ><textarea cols="44" rows="3"  name='urltext' onClick="this.select()"><%=eventurl%></textarea></div></td></tr> </table>                                                        
