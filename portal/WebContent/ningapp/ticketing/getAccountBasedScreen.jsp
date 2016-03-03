<%@ page import="com.eventbee.general.*,com.eventbee.authentication.*,java.util.*" %>

<%
String from=request.getParameter("from");
String view=request.getParameter("view");
String oid=request.getParameter("oid");
String name=request.getParameter("oname");
String domain=request.getParameter("domain");
String ownerstatus=request.getParameter("ownerstatus");
String appname=request.getParameter("appname");
session.setAttribute("domain",domain);
session.setAttribute("ning_oid",oid);


AuthDB adb=new AuthDB();
Authenticate au=null;
Authenticate authData=(Authenticate)session.getAttribute("authData");
String ebeeid=DbUtil.getVal("select ebeeid from ebee_ning_link where nid=?",new String[]{oid});
if(ebeeid==null){
response.sendRedirect("/portal/ningapp/ticketing/Authscreen.jsp?oid="+oid+"&appname="+appname+"&from="+from);	
return;
}
else{

au=adb.authenicateUserByID(ebeeid);


session.setAttribute("authData",au);
if("eventregister".equals(appname)){
response.sendRedirect("/portal/ningapp/ticketing/getViewerEvents.jsp?oid="+oid+"&ownerstatus="+ownerstatus+"&domain="+domain);	
}if("nts".equals(appname)){
response.sendRedirect("/portal/ningapp/profileview.jsp?oid="+oid+"&ownerstatus="+ownerstatus+"&domain="+domain);	
}
  }

%>