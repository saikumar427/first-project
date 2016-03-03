<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.photos.*"%>
<%@ page import="java.util.*"%>

<%

String DELETE_IMAGES="delete from network_ticketselling_images where image_id=? and refid=?";
if("mgr".equals(request.getParameter("type")))
		DELETE_IMAGES="delete from mgr_participant_images where image_id=? and refid=?";
	

StatusObj statobj=null;

statobj=DbUtil.executeUpdateQuery(DELETE_IMAGES, new String [] {request.getParameter("imgid"),request.getParameter("groupid")});

if(statobj.getStatus())
	out.print("success");

%>