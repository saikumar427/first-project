<%@ page import="com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.general.EbeeConstantsF" %>

<%
	String count=request.getParameter("count");
	if(count==null || "".equals(count.trim())) count="0";
	String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"manager":"portal";
	String message=null;
	if("0".equals(count))
		 message=" Email sent to "+count+" member(s)";
	else
		message="Email sent to "+count+" member(s)";
%>  
<% 	
request.setAttribute("tasktitle","Invite Event Manager");
//request.setAttribute("subtabtype","F2FPages");
%>

    <table align="center" width="100%">        
        <tr><td class="inform" align="center" ><%=message%></td></tr>
      			
        <tr><td class="inform" width="100%" align="center" >
		<table width="80%" align='center' border='0'>
		<tr>
			<td align="right" width='43%' >
</td>
			<td align='center' width='10'></td>
				<td align="left">
					 <a href="<%=request.getContextPath()%>/eventdetails/events.jsp?evttype=event">Events List</a>
				</td>
				
			</tr>
		</table>
	</td></tr>
    </table>
