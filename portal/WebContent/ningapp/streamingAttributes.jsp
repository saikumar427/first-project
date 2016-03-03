<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.event.EventInfoDb" %>
<%@ page import="com.eventbee.eventpartner.*" %>
<link rel="stylesheet" type="text/css" href="/home/index.css" />
<%
request.setAttribute("mtype","Network Ticket Selling");
request.setAttribute("stype","My Network Event Listing");
String evtid=request.getParameter("groupid");
String evtname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{evtid});
request.setAttribute("tasktitle","Eventbee Partner network > Customization ");

%>
<jsp:include page='mytabsmenu.jsp' >
<jsp:param  name='homelink'  value='ntsapp' />
</jsp:include>

<jsp:include page='/ntspartner/streamingAttributes.jsp' />

