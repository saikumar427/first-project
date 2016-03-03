<%@ page import="com.eventbee.general.*,com.eventbee.authentication.*,java.util.*" %>


<%

String view=request.getParameter("view");
String oid=request.getParameter("oid");
String name=request.getParameter("on");
String domain=request.getParameter("d");
String ownerstatus=request.getParameter("os");
if(ownerstatus==null)
ownerstatus="true";
String appname=request.getParameter("app");
session.setAttribute("domain",domain);
session.setAttribute("ning_oid",oid);
String partnerid=request.getParameter("partnerid");
session.setAttribute("partnerid",partnerid);
AuthDB adb=new AuthDB();
Authenticate au=null;
Authenticate authData=(Authenticate)session.getAttribute("authData");
String ebeeid=DbUtil.getVal("select ebeeid from ebee_ning_link where nid=?",new String[]{oid});

if(request.getParameter("bg")!=null){
   String style=   "body{"
		+"background-color: "+request.getParameter("bg")+";"
		+"color:"+request.getParameter("fc")+";"
		+"padding:1px;"
		+"padding-bottom:10px;}"
		+"a {"
		+"color: "+request.getParameter("ac")+";"
		+"}"
		+"input.button{"
		+"display:inline-block;"
		+"width:auto;"
		+"border:1px solid #aaa;"
		+"font-size:1em;"
		+"text-decoration:none;"
		+"color:"+request.getParameter("ac")+";"
		+"overflow:visible;"
		+"white-space:nowrap;"
		+"line-height:1em!important;"
		+"padding:.35em .6em .45em;"
		+"cursor:pointer;}"
		+".smallestfont {"
		+"font-family: Verdana, Arial, Helvetica, sans-serif;"
		+"font-size: 10px; font-weight: lighter; }";
              session.setAttribute("ning_style_"+oid,style);
     
           }

System.out.println("session in gae can avs page"+session.getId());

if(ebeeid==null){


response.sendRedirect("/portal/ningapp/ticketing/canvasAuthscreen.jsp;jsessionid="+session.getId()+"?oid="+oid+"&appname="+appname);	
return;
}
else{


au=adb.authenicateUserByID(ebeeid);
session.setAttribute("authData",au);
if("eventregister".equals(appname)){
//response.sendRedirect("/portal/ningapp/ticketing/canvasownerpagebeelets.jsp;jsessionid="+session.getId());	

response.sendRedirect("/portal/ningapp/ticketing/getProfileViewerEvents.jsp;jsessionid="+session.getId()+"?ownerstatus="+ownerstatus+"&oid="+oid+"&domain="+domain);	



}
else{
response.sendRedirect("http://www.eventbee.com/portal/ningapp/ntstabview.jsp;jsessionid="+session.getId()+"?oid="+oid);	
}
 }


%>