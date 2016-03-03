<%@ page import="com.eventbee.general.*" %>

<link rel="stylesheet" type="text/css" href="/home/index.css" />
<script language="javascript" src="/home/js/popup.js">
         	function dummy(){}
	</script>	

<%

request.setAttribute("tasktitle",  "Add Event > Event Details");

%>

<jsp:include page="/ningapp/taskheader.jsp"/> 

<%
request.setAttribute("mtype","Events");
request.setAttribute("stype","Events");
%>

<jsp:include page='/createevent/addevent.jsp'>
<jsp:param  name='GROUPID'  value='<%=request.getParameter("GROUPID")%>' />
<jsp:param  name='platform'  value='ning' />
</jsp:include>

