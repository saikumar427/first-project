<%@ page import="com.eventbee.general.DbUtil" %>
<link rel="stylesheet" type="text/css" href="/home/index.css" />
<%
if("manager".equals(request.getParameter("filter"))){
request.setAttribute("mtype","Events");
String evtid=request.getParameter("GROUPID");
String evtname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{evtid});
String link="<a href='/ningapp/ticketing/eventmanage.jsp?evtname="+evtname+"&GROUPID="+evtid+"'>"+evtname+"</a>";

request.setAttribute("tasktitle","Event Manage > "+link+" > Transaction Report ");
}else{
request.setAttribute("mtype","Network Ticket Selling");
request.setAttribute("stype","My Earnings");
String evtid=request.getParameter("GROUPID");
String evtname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{evtid});
String link="<a href='/ningapp/ticketing/eventmanage.jsp?evtname="+evtname+"&GROUPID="+evtid+"'>"+evtname+"</a>";

request.setAttribute("tasktitle","Event Manage > "+link+" >Transaction Report ");
}
%>
<script type="text/javascript" language="JavaScript" src="/home/js/advajax.js">
        function dummy2() { }
</script>

<script type="text/javascript" language="JavaScript" src="/home/js/ajax.js">
        function dummy3() { }
</script>
<jsp:include page='/ningapp/taskheader.jsp' />
<jsp:include page='/ntspartner/transaction.jsp' />


