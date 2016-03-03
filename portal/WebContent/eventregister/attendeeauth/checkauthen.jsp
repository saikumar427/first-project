<%@ page import="com.eventbee.authentication.*"%>
<%@ page import="com.eventbee.general.*"%>

<%
Authenticate aucheck=AuthUtil.getAuthData(pageContext);
if(aucheck!=null){
	out.print("authsucess");
}else{
	out.print("authfail");
}
%>
