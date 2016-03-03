<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%
String purpose=request.getParameter("purpose");
String partnerid=request.getParameter("partnerid");
String UPDATE_PHOTO_LOCATION=" update eventinfo set photourl=null where eventid=? ";
String UPDATE_ATTENDEE_PHOTO=" update eventinfo set attendeepagephoto=null where eventid=? ";
String UPDATE_PARTNER_PHOTO=" delete from partner_event_photos  where eventid=? and partnerid=?";

String groupid= request.getParameter("GROUPID");
if("event".equalsIgnoreCase(purpose))
	DbUtil.executeUpdateQuery(UPDATE_PHOTO_LOCATION,new String[]{groupid});
else if("partner".equalsIgnoreCase(purpose))
	DbUtil.executeUpdateQuery(UPDATE_PARTNER_PHOTO,new String[]{groupid,partnerid});
else
 	DbUtil.executeUpdateQuery(UPDATE_ATTENDEE_PHOTO,new String[]{groupid});
%>
