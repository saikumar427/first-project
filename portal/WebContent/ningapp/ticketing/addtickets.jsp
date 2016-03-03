<%@ page import="com.eventbee.general.*" %>

<link rel="stylesheet" type="text/css" href="/home/index.css" />
<script language="javascript" src="/home/js/popup.js">
         	function dummy(){}
	</script>	

<%
String groupid=request.getParameter("GROUPID");
String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{groupid});

if(eventname==null)
eventname=" ";
String link="<a href='/ningapp/ticketing/eventmanage.jsp;jsessionid="+session.getId()+"?eventname="+eventname+"&GROUPID="+groupid+"'>"+eventname+"</a>";
String Myevents="<a href='/ningapp/ticketing/canvasownerpagebeelets.jsp;jsessionid="+session.getId()+"'>My Events</a>";
request.setAttribute("tasktitle", Myevents+" > Event Manage > "+link+" > add tickets");
//request.setAttribute("tasktitle","Event Manage > "+link+" > add tickets");

%>

<jsp:include page="/ningapp/taskheader.jsp"/> 

<%
request.setAttribute("mtype","Events");
request.setAttribute("stype","Events");
%>
<jsp:include page='/editeventprice/addtickets.jsp'>
<jsp:param  name='GROUPID'  value='<%=request.getParameter("GROUPID")%>' />
<jsp:param  name='platform'  value='ning' />

</jsp:include>

