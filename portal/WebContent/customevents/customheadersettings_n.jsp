<%@ page import="com.eventbee.general.*" %>
<%
String header="";
String footer=null;
String groupid=(String)request.getAttribute("GROUPID");

DBManager dbmanager=new DBManager();
StatusObj statobj=dbmanager.executeSelectQuery("select * from configure_looknfeel where refid=? and idtype=? ",new String []{groupid,"eventdetails"});
if(statobj.getStatus()){
header=dbmanager.getValue(0,"headerhtml",null);
footer=dbmanager.getValue(0,"footerhtml",null);
}
String preview=request.getParameter("preview");
if("eventdetails".equalsIgnoreCase(preview))
{
request.setAttribute("BASIC_EVENT_HEADER",request.getParameter("headerhtml"));
request.setAttribute("BASICEVENTFOOTER",request.getParameter("footerhtml"));
}else{
if(header!=null)
request.setAttribute("BASIC_EVENT_HEADER",header);
if(footer!=null && !"".equals(footer))
request.setAttribute("BASICEVENTFOOTER",footer);
}
%>