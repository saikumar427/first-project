<%@ page import="com.eventbee.general.*" %>
<%	
String groupid=request.getParameter("groupid");
String password=DbUtil.getVal("select password from view_security where eventid=?",new String[]{groupid});
String pwd=request.getParameter("upassword");
if(password.equals(pwd)){	
	session.setAttribute("EVENT_PASSWORD_AUTH_DONE_"+groupid,"Y");
	out.print("Success");
}else
	out.print("error");

%>