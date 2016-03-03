<%@ page import=" java.util.*" %>
<%@ page import="com.eventbee.general.*" %>
<%!
	String UPDATE_MESSAGE="update partner_event_photos set message=? where eventid=? and partnerid=?";
%>
<%
/*	String eventid=request.getParameter("groupid");
	String partnerid=request.getParameter("partnerid");
	String message=request.getParameter("message");	
	String isexist=DbUtil.getVal("select 'Yes' from partner_event_photos where eventid=? and partnerid=?",new String[]{eventid,partnerid});
	if(isexist==null)
	DbUtil.executeUpdateQuery("insert into partner_event_photos(partnerid,message,eventid)values(?,?,?)",new String[]{partnerid,message,eventid});
	else
	DbUtil.executeUpdateQuery(UPDATE_MESSAGE,new String[]{message,eventid,partnerid});*/
	
%>


	