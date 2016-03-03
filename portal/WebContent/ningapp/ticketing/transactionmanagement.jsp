<%@ page import="com.eventbee.general.DbUtil" %>
<link rel="stylesheet" type="text/css" href="/home/index.css" />
<%
request.setAttribute("mtype","Transaction Management");

String evtid=request.getParameter("GROUPID");
String pageToInclude="";
String evtname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{evtid});
String link="<a href='/ningapp/ticketing/eventmanage.jsp?evtname="+evtname+"&GROUPID="+evtid+"'>"+evtname+"</a>";

if("google".equals(request.getParameter("type"))){
request.setAttribute("stype","Google Transactions");
pageToInclude="/googlepaypaltransactions/vendortransactions.jsp";
request.setAttribute("tasktitle","Event Manage > "+link+ " > Google Transaction Management" );
}
if("paypal".equals(request.getParameter("type"))){
request.setAttribute("stype","PayPal Transactions");
pageToInclude="/googlepaypaltransactions/vendortransactions.jsp";
request.setAttribute("tasktitle","Event Manage > "+link+ " > PayPal Transaction Management" );
}
if("eventbee".equals(request.getParameter("type"))){
request.setAttribute("stype","Eventbee Transactions");
pageToInclude="/googlepaypaltransactions/eventbeetransactions.jsp";
request.setAttribute("tasktitle","Event Manage > "+link+ " > Eventbee Transaction Management" );
}
%>
<script type="text/javascript" language="JavaScript" src="/home/js/advajax.js">
        function dummy2() { }
</script>

<jsp:include page='/ningapp/mytabsmenu.jsp' >
<jsp:param  name='eventregister'  value='app' />
</jsp:include>
<jsp:include page='<%=pageToInclude%>' />


