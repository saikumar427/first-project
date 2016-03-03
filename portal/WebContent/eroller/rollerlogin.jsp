<%@ page import="java.util.*,java.net.*,java.io.*,com.eventbee.authentication.*,com.eventbee.util.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>

<%

String rollercontext=(application.getInitParameter("rollercontext")!=null)?application.getInitParameter("rollercontext"):"/roller";
Authenticate authData= AuthUtil.getAuthData(pageContext);
String serverurl="http://"+EbeeConstantsF.get("serveraddress","192.168.1.51:8080");
String act=request.getParameter("act");

String requri=request.getParameter("requri");//this is for comments

if(act !=null){
	session.setAttribute("rolleract",act);
	

}



if(     requri !=null && "comments".equals(act) )
session.setAttribute("commentsuri",requri);
else 
session.removeAttribute("commentsuri");
	



if(authData !=null){

String tempact=(act !=null)?"&act="+act:"";

response.sendRedirect(serverurl+rollercontext+"/elogger.jsp?userid="+authData.getUserID()+tempact);
}else{
response.sendRedirect("/portal/auth/listauth.jsp?purpose=createblog&entryunitid=13579" );
}
%>
