<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
"http://www.w3.org/TR/html4/strict.dtd">
<%@ page import="java.util.*, com.eventbee.general.formatting.*, com.eventbee.general.*"%>
<%@ taglib uri="/tags/struts-bean" prefix="bean" %>
<%@ taglib uri="/tags/struts-tiles" prefix="tiles" %>
<%@ taglib uri="/tags/struts-logic" prefix="logic" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<META Http-Equiv="Cache-Control" Content="no-cache">
<META Http-Equiv="Pragma" Content="no-cache">
<META Http-Equiv="Expires" Content="0">
<meta name="revisit-after" content="7 days" />
<meta name="ROBOTS" content="ALL" />
<meta http-equiv="keywords" name="keywords" content="online registration" />

<title>Eventbee - Online Event Management, Event Registration, Membership
Management, Email Marketing and Ticket Selling software </title>

<meta name="Description" content="Easy to use web based Event Management
solution that includes Event Registration/Ticketing, Email Marketing,
Event Photos,
Event Blogs and Membership Management" />

<meta name="Keywords" content="online ticketing, event ticketing, event
payments, email marketing, event blogs, membership management, event
credit card payments, event photos, event blogging, event communities,
membership payments, online memberships, event community, event
networking, event social networking, event promotion, event listing, local
events,registration software,conference software,conference
registration,event registration,training registration,registration,online
registration,on line registration,registration service,seminar
registration,event registration service,online registration
software,online event registration software,online conference
registration" />

<%@ include file="/main/customlnf.jsp" %>
 <%
 
 String oid=(String)session.getAttribute("ningoid");

 if(request.getAttribute("CUSTOM_CSS")!=null){ %>
<link rel="stylesheet" type="text/css" href="/home/customlisting.css" />
<link rel="icon" href="/home/images/favicon.ico" type="image/x-icon">
<link rel="shortcut icon" href="/home/images/favicon.ico" type="image/x-icon">

<style type="text/css">
<%=(String)request.getAttribute("CUSTOM_CSS")%>
<%
if(session.getAttribute("ning_style_"+oid)!=null){%>
<%=(String)session.getAttribute("ning_style_"+oid)%>
<%}%>

</style>
<%}else if(request.getAttribute("CUSTOM_LAYOUT_CSS")!=null){

%>

<style type="text/css">
<%=(String)request.getAttribute("CUSTOM_LAYOUT_CSS")%>
<%
if(session.getAttribute("ning_style_"+oid)!=null){%>
<%=(String)session.getAttribute("ning_style_"+oid)%>
<%}%>
</style>
<%}else{%>
<style>
<%


if(session.getAttribute("ning_style_"+oid)!=null){%>
<%=(String)session.getAttribute("ning_style_"+oid)%>
<%}%>
</style>

  <link rel="stylesheet" type="text/css" href="/home/index.css" />
<link rel="stylesheet" type="text/css" href='/home/homepage.css' /> 
<%}%>
<link rel="stylesheet" type="text/css" href="/home/css/niftyCorners.css" />

</head>
<body>
<tiles:insert attribute="head" />
 <div >

<div >


 
 
 
<script type="text/javascript" src="/home/js/getcontent.js">
function dummy(){}
</script>

<% 
 	String  SSLProtocol=EbeeConstantsF.get("SSLProtocol","https");
	String serveraddress="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");
	String sslserveraddress=SSLProtocol+"://"+EbeeConstantsF.get("sslserveraddress","www.eventbee.com");
	session.setAttribute("HTTP_SERVER_ADDRESS",serveraddress); 
	session.setAttribute("HTTPS_SERVER_ADDRESS",sslserveraddress); 
	
 	String tmp_subtitle="";
 	String navdata="";
 	String containerwidth="950";
	%>

<%if("Y".equals(request.getAttribute("CUSTOM_HTML_LAYOUT")) || "yes".equals(request.getParameter("fbcontext"))){%>
		

<%}else{%>
<table width="100%" align="center" id="container">

<tr>

 	<td <%=  (request.getAttribute("tasktitle")!=null)?"class='taskheader'":""  %>     >
	
	 <% if(request.getAttribute("tasktitle") !=null){ %>
	 	<div  style='float:left'>
		 <%=request.getAttribute("tasktitle") %>
		 </div>
		 <% }%>
		
		 <% if(request.getAttribute("tasksubtitle") !=null)
	 tmp_subtitle=((String)request.getAttribute("tasksubtitle")).trim();
	  if("".equals(tmp_subtitle))
		tmp_subtitle=" ";
	  %>
	  <% if(request.getAttribute("tasktitle") !=null){%>
	   <div style='float:right'><%=tmp_subtitle%></div>
	   <%}%>
	</td>
 	
 </tr>
 </table>
 <%}
 

 %>
 
<%if("Y".equals(request.getAttribute("CUSTOM_HTML_LAYOUT"))){

	if(request.getAttribute("CUSTOM_NAVHTML")!=null){
			navdata=(String)request.getAttribute("CUSTOM_NAVHTML");
			containerwidth="800";
	}
	
%>
<table width="100%" align="center">
		<tr>
			<%if(navdata!=null && !"".equals(navdata)){%>
			<td width='150' valign='top'><%=navdata%></td>
			<%}%>
			<td width='<%=containerwidth%>' valign='top'>
				<table  width="100%" align="center" cellspacing="0" >
					<tr>
						<td  colspan='5'>
							<% if(request.getAttribute("taskheader") !=null){ %>
							<%=request.getAttribute("taskheader") %>
							<% }%>
		 					
		 				</td>
		 			</tr>
		 			
		 			<tr>
		 				<td valign="top" class="tasktitle" width='100%' >
      						<% if(request.getAttribute("tasktitle") !=null){ %>
	 
		 						<%=request.getAttribute("tasktitle") %>
		 
		 					<% }%>
									 
						</td>
					</tr>
					<tr height="4"><td>&nbsp;</td></tr>			 
		
					<tr>
						<td>
							<div align="center" >
							<tiles:insert attribute="content" />
	
							</div>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr height='5'><td></td></tr>
</table>

<%}else{%>
<div align="center"  >
	
<tiles:insert attribute="content" />
	
</div>
<%}%>

</div>
<%if(!"yes".equals(request.getParameter("fbcontext"))){%>
<tiles:insert attribute="footer" />
<%}%>
 </div>   
 
</body>
</html>

