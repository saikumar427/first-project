<%@ page import="com.eventbee.general.DbUtil" %>
<link rel="stylesheet" type="text/css" href="/home/index.css" />
<%
request.setAttribute("mtype","Events");
String evtid=request.getParameter("GROUPID");
String evtname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{evtid});
String link="<a href='/ningapp/ticketing/eventmanage.jsp?evtname="+evtname+"&GROUPID="+evtid+"'>"+evtname+"</a>";
String Myevents="<a href='/ningapp/ticketing/canvasownerpagebeelets.jsp;jsessionid="+session.getId()+"'>My Events</a>";
request.setAttribute("tasktitle", Myevents+" > Event Manage > "+link+" > Registration Report");

//request.setAttribute("tasktitle","Event Manage > "+link+" > Registration Report ");

%>
<script type="text/javascript" language="JavaScript" src="/home/js/advajax.js">
        function dummy2() { }
</script>

<jsp:include page='/ningapp/taskheader.jsp' />

<jsp:include page='/listreport/reg_reports.jsp' />


