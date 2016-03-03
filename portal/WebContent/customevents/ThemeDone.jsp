
<%@ page import="java.io.*, java.util.*,java.sql.*,com.eventbee.oppertunities.OpperInfo,com.eventbee.general.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*" %>
<jsp:include page="/auth/authenticate.jsp" />
<%
String contextpath="/manager".equals( request.getContextPath() )?"/manager":"/portal"; 
String platform=(String)session.getAttribute("platform");
System.out.println("platform in theemdoen:::"+platform);
 String url="mytasks/myevents.jsp?type=Events";
	    if("ning".equals(platform)){		
		url="ningapp/ticketing/canvasownerpagebeelets.jsp";
	 }
	 System.out.println("url in theemdoen:::"+url);
HashMap hm=(HashMap)session.getAttribute("groupinfo");
String evtname="";
String redirmes= LinkUtil.getRedirectPage( hm);
Authenticate authData=AuthUtil.getAuthData(pageContext);
String userid=(authData !=null)?authData.getUserID():"";
String username=(authData !=null)?authData.getLoginName():"";
String operation=request.getParameter("operation");
//String message=(String)session.getAttribute("message");
//message=EbeeConstantsF.get(message, message);
String message="Theme updated successfully";
String from=request.getParameter("from");
evtname=request.getParameter("evtname");
if(evtname!=null)
	evtname=java.net.URLEncoder.encode(request.getParameter("evtname"));
%>

<html title="Lifestyle" sub-title="<%=operation %>">
<body>
 
	<%
	request.setAttribute("tabtype","community");
	String purpose=request.getParameter("type");
	request.setAttribute("type","event");
	
	if("add".equals(from))	
	request.setAttribute("linktohighlight","theme");
	else{
	request.setAttribute("linktohighlight","pagecontent");
	message="Updated Template";
	}
	if("Events".equals(purpose)){
		request.setAttribute("linktohighlight","Theme");	
		request.setAttribute("subtabtype","My Pages");
	}
	else{
		request.setAttribute("subtabtype","My Page");
		request.setAttribute("linktohighlight","Theme");
		}
%>

<table align="center" width="100%" >
<tr><td height='30'></td></tr>
<tr ><td align="center" class="inform" ><%=(message==null)?"Template updated successfully":message %> </td></tr>

<tr><td align="center" class="inform" > 
<%if("eventpages".equals(request.getParameter("frompage")))
{
 if ("Theme".equals(request.getParameter("operation"))||"Edit CSS".equals(request.getParameter("operation"))||"Edit Template".equals(request.getParameter("operation"))){%>
<a href='<%=contextpath %>/<%=url%>'> Back to Events</a>
&nbsp;<%}else{%>
<a href='<%=contextpath %>/mytasks/eventmanage.jsp?GROUPID=<%=request.getParameter("GROUPID") %>&evtname=<%=evtname %>'> Back to Event Manage</a>                    
<% }
}
else{

if("PUBLICPAGES".equals(request.getParameter("PS")))
{%>
<a href='<%=contextpath %>/mytasks/publicpages.jsp'>Back to Publicpages</a>
<%}
else{%>

<a href='<%=contextpath %>/mytasks/clubmanage.jsp?GROUPID=<%=request.getParameter("GROUPID") %>'> Back to  Manage</a>
<%}}%>
</td></tr>
<tr><td height='210'></td></tr>


</table>



