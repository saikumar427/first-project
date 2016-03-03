<%@ page import="java.util.*,com.eventbee.general.*,com.themes.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>

<%
String userid="";
	Authenticate authData=AuthUtil.getAuthData(pageContext);
	if(authData!=null)
		out.print("authenticated");
	else
		out.print("nonauth");	
		
%>	
	