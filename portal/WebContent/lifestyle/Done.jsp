
<%@ page import="java.io.*, java.util.*,java.sql.*,com.eventbee.oppertunities.OpperInfo,com.eventbee.general.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*" %>
<jsp:include page="/auth/authenticate.jsp" />
<%
String contextpath="/manager".equals( request.getContextPath() )?"/manager":"/portal"; 

HashMap hm=(HashMap)session.getAttribute("groupinfo");

String redirmes= LinkUtil.getRedirectPage( hm);
Authenticate authData=AuthUtil.getAuthData(pageContext);
String userid=(authData !=null)?authData.getUserID():"";
String username=(authData !=null)?authData.getLoginName():"";
String operation=request.getParameter("operation");
String message=(String)session.getAttribute("message");

if(message==null){
	
		if("Theme".equals(operation) )message=EbeeConstantsF.get("lifestyle.theme.update.done"   ,"Theme added successfully"   );
		
		if("Edit Template".equals(operation) )message=EbeeConstantsF.get("lifestyle.themetemplate.edit.done"   ,"Theme template updated successfully"   );
		if("Edit CSS".equals(operation) )message=EbeeConstantsF.get("lifestyle.themecss.edit.done"   ,"Theme css updated successfully"   );
	
		if("Delete Template".equals(operation) )message=EbeeConstantsF.get("lifestyle.themetemplate.remove.done"   ,"Theme template updated successfully"   );
		if("Delete CSS".equals(operation) )message=EbeeConstantsF.get("lifestyle.themecss.remove.done"   ,"Theme css updated successfully"   );
}

message=EbeeConstantsF.get(message, message);
%>

<html title="Lifestyle" sub-title="<%=operation %>">
<body>
<% 
	//request.setAttribute("tasktitle","Lifestyle");
	//request.setAttribute("tasksubtitle",operation);
	request.setAttribute("tabtype","lifstyle");
	request.setAttribute("subtabtype","mynetwork");
	request.setAttribute("linktohighlight","theme");
	
	//http://192.168.1.50:8080/portal/editprofiles/managemypage.jsp?userid=12370&UNITID=13579
%>
<%@ include file="/stylesheets/toplnf.jsp" %>
<table align="center" width="100%" >
<tr><td align="center" class="inform"><%=(message==null)?"Done Successfully":message %> </td></tr>

<tr><td align="center" class="inform"> 
<a href='<%=contextpath %>/lifestyle/lifestyle.jsp?userid=<%=userid %>&type=Network'>Back to My Lifestyle</a> 
&nbsp;

<%--<a href="/member/<%=username %>">My Lifestyle Page</a>--%>

</td></tr>
</table>

<%@ include file="/stylesheets/bottomlnf.jsp" %>


