<%@ page import=" java.util.*" %>
<%@ page import="com.eventbee.general.*" %>
<%!
	String DELETE_PHOTO="delete from config where name='eventpage.logo.url' and config_id=? ";
	String DELETE_MESSAGE="delete from config where name='eventpage.logo.message' and config_id=? ";
%>

<%
	String eventid=request.getParameter("groupid");
	String image=request.getParameter("image");
	String message=request.getParameter("message");
	
	String configid="select config_id from eventinfo where eventid=?";
	String config_id=DbUtil.getVal(configid, new String[]{eventid});
	DbUtil.executeUpdateQuery(DELETE_PHOTO,new String[]{config_id});
	DbUtil.executeUpdateQuery("insert into config(config_id, name, value) values (?,'eventpage.logo.url',?)",new String[]{config_id,image});
	
	DbUtil.executeUpdateQuery(DELETE_MESSAGE,new String[]{config_id});
	DbUtil.executeUpdateQuery("insert into config(config_id, name, value) values (?,'eventpage.logo.message',?)",new String[]{config_id,message});
%>