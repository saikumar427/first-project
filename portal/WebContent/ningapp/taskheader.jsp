<%@ page import="com.eventbee.general.*"%>

<%



  response.addHeader("P3P", "CP=\"CAO PSA OUR\""); 


	 	String tmp_subtitle="";
	 	
	String title="Event Register Application";

if("nts".equals(request.getParameter("appname")))
 title="Partner Network Application";	
%>


<table ><tr><td align='left' >
<img  src="http://www.eventbee.com/home/images/logo_big.jpg" border='0'/></td>
<td align='left' width='500' valign='center' class='gadget' ><b><%=title%></b></td>

<%
String url="/ningapp/ticketing/canvasownerpagebeelets.jsp;jsessionid="+session.getId();

if(!"No".equals(request.getParameter("showhome"))){
%>
<td ><a href='<%=url%>'  id="homelink">Home</a></td>


<td> | </td>
<td >



<a href='http://help.eventbee.com' target="_blank" id="helplink">Help</a></td>
<%}%>
</tr></table>
<table width="100%">

<tr>

 	<td <%=  (request.getAttribute("tasktitle")!=null)?"class='desiborderfull'":""  %>     >
	
	 <%
	 if(request.getAttribute("tasktitle") !=null){ %>
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
 
