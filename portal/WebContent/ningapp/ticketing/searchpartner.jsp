<%@ page import="com.eventbee.general.DbUtil" %>
<link rel="stylesheet" type="text/css" href="/home/index.css" />
<%
	request.setAttribute("mtype","Events");
	String evtid=request.getParameter("gid");
	String filter=request.getParameter("filter");	
	String evtname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{evtid});
	String link="<a href='/ningapp/ticketing/eventmanage.jsp?evtname="+evtname+"&GROUPID="+evtid+"'>"+evtname+"</a>";
	String Myevents="<a href='/ningapp/ticketing/canvasownerpagebeelets.jsp;jsessionid="+session.getId()+"'>My Events</a>";
        
	
	if("Approved".equals(filter)){
	request.setAttribute("tasktitle", Myevents+" > Event Manage > "+link+" > Approved Partners");
	
	}
	else if("Pending".equals(filter)){
	request.setAttribute("tasktitle", Myevents+" > Event Manage > "+link+" > Pending Partners");	
	}
	else if("Suspended".equals(filter))
	{
	request.setAttribute("tasktitle", Myevents+" > Event Manage > "+link+" > Suspended Partners");	
	}
	else{
	request.setAttribute("tasktitle", Myevents+" > Event Manage > "+link+" > Search Partner");	
	}
%>
<jsp:include page='/ningapp/taskheader.jsp' />
<jsp:include page='/eventbeeticket/searchpartner.jsp'>
<jsp:param  name='platform'  value='ning' />
</jsp:include>
