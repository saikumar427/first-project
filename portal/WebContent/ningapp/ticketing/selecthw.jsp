<%@ page import="com.eventbee.general.DbUtil" %>
<link rel="stylesheet" type="text/css" href="/home/index.css" />
<%
request.setAttribute("mtype","Events");
String evtid=request.getParameter("groupid");

String evtname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{evtid});
String link="<a href='/ningapp/ticketing/attendeelist_report.jsp?evtname="+evtname+"&GROUPID="+evtid+"'>"+evtname+"</a>";

request.setAttribute("tasktitle","Event Manage > "+link+" > Name Tags ");

%>
<script type="text/javascript" language="JavaScript" src="/home/js/advajax.js">
        function dummy2() { }
</script>

<jsp:include page='/ningapp/taskheader.jsp' />

<jsp:include page='/listreport/selecthw.jsp' />


