<%@ page import="java.io.*, java.util.*, com.eventbee.looknfeel.LooknFeel" %>
<%@ page import="com.eventbee.authentication.*,com.eventbee.general.*,org.eventbee.sitemap.util.LinksGenerator" %>
<%@ page import="com.eventbee.general.EbeeConstantsF" %>

<% 
	//request.setAttribute("tasktitle","Login");
	request.setAttribute("tabtype","community");
	String supportmail=EbeeConstantsF.get("support.email","support@beeport.com");
%>

<table   width='100%'  cellspacing="0">

<tr>
<td colspan='2'>
	<table border="0" width="100%" align="center">
		<tr>
		<%--if("13579".equals(request.getParameter("UNITID"))){--%>
		<td align="center">To avail this feature, please  <a href='/portal/community.jsp?FP=content' >Login</a>.<br/>
		If you see this error message repeatedly, please close all your browser windows and
		launch new browser session to access our website. If you need further assistance,
		please contact <a href='mailto://<%=supportmail%>'><%=supportmail%></a>
		</td>
		<%--}else{%>
		<td align="center">To avail this feature, please  <a href='/portal/pmemberlogin.jsp?UNITID=<%=request.getParameter("UNITID")%>&GROUPID=<%=request.getParameter("GROUPID")%>&FP=content' >Login</a>.<br/>
		If you see this error message repeatedly, please close all your browser windows and
		launch new browser session to access our website. If you need further assistance,
		please contact <a href='mailto://<%=supportmail%>'><%=supportmail%></a>
		</td>
		<%}--%>
		</tr>
		
	</table>

</td>
</tr>
</table>
