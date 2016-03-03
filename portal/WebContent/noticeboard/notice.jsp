<%@ page import="com.eventbee.general.*,java.io.*, java.util.*,java.sql.*,com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>

<%
	String mes=(String)request.getAttribute("message");
	if(mes==null)
		mes=request.getParameter("message");
	session.removeAttribute("noticehash");
	String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";
	HashMap hm=(HashMap)session.getAttribute("groupinfo");

String redirmes= LinkUtil.getRedirectPage( hm);
String groupid=request.getParameter("GROUPID");
String grouptype=request.getParameter("GROUPTYPE");
String from =request.getParameter("from");
String pname=request.getParameter("pname");
%>
<jsp:include page='/auth/checkpermission.jsp'/>
<jsp:include page='/stylesheets/CoreRequestMap.jsp' />
<% request.setAttribute("tasktitle","Noticeboard");
      String link="";
      String evtname="";
	HashMap urlmap=PageUtil.getPageNameAndUrl(request.getParameter("PS"),request.getParameter("GROUPID"));
	
	
	if("events".equals(from))
	{
	link="<a href='/mytasks/eventmanage.jsp?GROUPID="+request.getParameter("GROUPID")+"&evtname="+pname+"'>Back to Manage page</a>";
	}
	else{  
	      
		
		link="<a href='/mytasks/clubmanage.jsp?GROUPID="+request.getParameter("GROUPID")+"'>Back to Manage page</a>";
	}	
  %>

<table align='center' width='100%' >
 <tr height="50"><td></td></tr>
<tr><td class='inform' align='center'><%=mes %> </td></tr>

<tr><td class='inform' align='center'><%=link%></td></tr>
<tr height="80"><td></td></tr>

</table>
