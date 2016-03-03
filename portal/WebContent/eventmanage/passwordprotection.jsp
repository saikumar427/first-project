<%@ page import=" java.util.*" %>
<%@ page import="com.eventbee.general.*" %>
<%!
	String DELETE_PASSWORD="delete from view_security where eventid=? ";
%>
<%
	String eventid=request.getParameter("groupid");
	String password=request.getParameter("password");
	StatusObj statobjn=null;
	if("".equals(password.trim()))
	{
		DbUtil.executeUpdateQuery(DELETE_PASSWORD,new String[]{eventid});
	}else
	{
		DbUtil.executeUpdateQuery(DELETE_PASSWORD,new String[]{eventid});
		statobjn= DbUtil.executeUpdateQuery("insert into view_security(eventid,password) values(?,?)",new String[]{eventid,password});
		//statobjn = DbUtil.executeUpdateQuery("update view_security set password=? where eventid=?",new String[]{password,eventid});
	}
%>


	