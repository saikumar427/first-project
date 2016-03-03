<%@ page import="com.eventbee.general.DbUtil" %>
<link rel="stylesheet" type="text/css" href="/home/index.css" />
<%
request.setAttribute("mtype","Network Ticket Selling");
request.setAttribute("stype","My Network Event Listing");
String evtid=request.getParameter("groupid");
String evtname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{evtid});
request.setAttribute("tasktitle","Eventbee Partner network > Update Information ");

%>
<script language="javascript" src="/home/js/popup.js">
         	function dummy(){}
	</script>	

<jsp:include page='mytabsmenu.jsp' >
<jsp:param  name='homelink'  value='ntsapp' />
</jsp:include>
<jsp:include page='/ntspartner/editpartner.jsp' />


