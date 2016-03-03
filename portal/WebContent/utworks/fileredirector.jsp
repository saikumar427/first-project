<%@ page import="com.eventbee.general.*" %>
<%@ page import="java.util.*,java.io.*" %>
<%
	String file=request.getParameter(".file");
	String action=request.getParameter("submit");
%>	
	<% if(file==null || "".equals(file.trim())){ %>
		<jsp:forward page="file.jsp" />
	<%}else if("Create File".equals(action)){ %>
		<jsp:forward page="createfile.jsp" />	
        <%}%>
