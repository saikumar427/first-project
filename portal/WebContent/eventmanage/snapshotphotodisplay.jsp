<%@ page import="java.io.*, java.util.*,java.sql.*,com.eventbee.general.EventbeeConnection" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.photos.*" %>



<%!
String UPDATE_PHOTO_LOCATION=" update eventinfo set photourl=? where eventid=? ";
String UPDATE_ATTENDEE_PHOTO=" update eventinfo set attendeepagephoto=? where eventid=? ";

%>


<%
String photouploadurl=request.getParameter("photouploadurl");
String groupid=request.getParameter("GROUPID");
String purpose=request.getParameter("purpose");
String partnerid=request.getParameter("partnerid");

EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, "snapshotphotodisplay.jsp", "null", "photouploadurl value is"+photouploadurl,null);
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, "snapshotphotodisplay.jsp", "null", "groupid value is"+groupid,null);
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, "snapshotphotodisplay.jsp", "null", "purpose value is"+purpose,null);

if("attendee".equalsIgnoreCase(purpose)){
		
		if(photouploadurl!=null&&!"".equals(photouploadurl)){
			DbUtil.executeUpdateQuery(UPDATE_ATTENDEE_PHOTO,new String[]{photouploadurl,groupid});
		}
}else if("partner".equalsIgnoreCase(purpose)){
		
		if(photouploadurl!=null&&!"".equals(photouploadurl)){
		DbUtil.executeUpdateQuery("delete from partner_event_photos where eventid=? and partnerid=?",new String[]{groupid,partnerid});
		DbUtil.executeUpdateQuery("insert into partner_event_photos(partnerid,photourl,eventid)values(?,?,?)",new String[]{partnerid,photouploadurl,groupid});

		}
}else{

		
		if(photouploadurl!=null&&!"".equals(photouploadurl)){
			DbUtil.executeUpdateQuery(UPDATE_PHOTO_LOCATION,new String[]{photouploadurl,groupid});
		}
}
%>
<script>
window.opener.location.reload();
//window.opener.document.getElementById('showmessage').innerHTML='abssdsdsd';
window.close();
</script>
