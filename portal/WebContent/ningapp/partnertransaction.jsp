<%@ page import="com.eventbee.general.DbUtil" %>
<link rel="stylesheet" type="text/css" href="/home/index.css" />
<%
String oid=request.getParameter("oid");
String platform=request.getParameter("platform");
if("manager".equals(request.getParameter("filter"))){
String evtid=request.getParameter("GROUPID");
String evtname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{evtid});
String link="<a href='/ningapp/ticketing/eventmanage.jsp?evtname="+evtname+"&GROUPID="+evtid+"'>"+evtname+"</a>";
request.setAttribute("tasktitle","Event Manage > "+link+" > Report ");
}else{
request.setAttribute("mtype","Network Ticket Selling");
request.setAttribute("stype","My Earnings");
String evtid=request.getParameter("GROUPID");
String evtname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{evtid});
String link="";
if("ning".equals(platform)){
link=evtname;
}else{
link="<a href='/ningapp/earningstab'>"+evtname+"</a>";
}
request.setAttribute("tasktitle","Event Manage > "+link+" > Report ");

}
%>
<jsp:include page='/ningapp/mytabsmenu.jsp' >
<jsp:param  name='homelink'  value='ntsapp' />
<jsp:param name="oid" value="<%=oid%>" />

</jsp:include>

<jsp:include page='/ntspartner/transaction.jsp' />
