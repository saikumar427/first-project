<%@ page import="com.eventbee.general.*" %>
<%	
String groupid=request.getParameter("groupid");
String trackcode=request.getParameter("trackcode").toLowerCase();
String password=request.getParameter("password");
String pwd=DbUtil.getVal("select password from trackurls where eventid=? and lower(trackingcode)=?",new String[]{groupid,trackcode});
if(pwd.equals(password)){
out.print("Success");
}else{
out.print("fail");
}

%>