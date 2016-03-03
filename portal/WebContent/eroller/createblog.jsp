<%@ page import="java.util.*,java.net.*,java.io.*,com.eventbee.authentication.*,com.eventbee.util.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>

<jsp:include page="/auth/authenticate.jsp" />

<%
String rollercontext=(application.getInitParameter("rollercontext")!=null)?application.getInitParameter("rollercontext"):"/roller";
String act=(String)session.getAttribute("rolleract");
session.removeAttribute("rolleract");



Authenticate authData= AuthUtil.getAuthData(pageContext);
String serverurl="http://"+EbeeConstantsF.get("serveraddress","192.168.0.50:8080");

if(authData !=null){
String tempact="";

	if(act !=null){
	
		if("comments".equals(act) ){
			String commentsuri="";
			commentsuri=(session.getAttribute("commentsuri") !=null)?"&requri="+(String)session.getAttribute("commentsuri"):"";
			tempact="&act="+act+commentsuri;
		}else{
			
			tempact="&act="+act;
		}
	}//end of act !=null
	response.sendRedirect(serverurl+rollercontext+"/elogger.jsp?userid="+authData.getUserID()+tempact);
}
%>

