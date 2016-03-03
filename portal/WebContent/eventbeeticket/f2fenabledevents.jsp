<%@ page import="java.util.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>
<%@ page import="java.util.*,java.sql.*,com.eventbee.general.EventbeeConnection,com.eventbee.event.EventDB,com.eventbee.event.*" %>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.eventbee.f2f.F2FEventDB"%>




<%
String evttype=request.getParameter("evttype");
String userid="";
Authenticate authData=AuthUtil.getAuthData(pageContext);
if(authData !=null){
	userid=authData.getUserID();
}
request.setAttribute("subtabtype","F2FPages");
%>
<form>
<%
Vector v=new Vector();
F2FEventDB.getCustomPosterData(v,userid);
if(v.size()>0){
	if("event".equalsIgnoreCase(evttype)){
		
		%>
		<table width='100%' border="0" cellpadding="0" cellspacing="0" height="10" class='beelet-header'>
		<tr ><td>Eventbee Network Ticket Selling Enabled Events</td>
		</tr>
		</table>
		<%
	}else{%>
		<div class='memberbeelet-header'>Eventbee Network Ticket Selling Enabled Events</div>
	<%}
	%>
	<table cellpadding="0" cellspacing="0" align="center" width="100%">  
	<%--
	<tr class="colheader">
				<td width='30%' class="colheader">Event</td>
				<td width="60%">Description</td>
				<td></td>

		</tr>--%>
	<%
	String base="oddbase";
	for(int i=0;i<v.size();i++){
		if(i%2==0)
			base="evenbase";
		else
			base="oddbase";
		HashMap hm=(HashMap)v.elementAt(i);
		String pattserver=ShortUrlPattern.get((String)GenUtil.getHMvalue(hm,"username",""));
		%>
		<tr class="<%=base%>"> 
		<td align="left"  align='left' width='50%'><a href=<%=pattserver%>/event?eventid=<%=GenUtil.getHMvalue(hm,"groupid","")%>><%= GenUtil.TruncateData( GenUtil.getHMvalue(hm,"eventname",""),15)%></a></td>
		<%
		String isagent=GenUtil.getHMvalue(hm,"isagent","");

		if ("Yes".equalsIgnoreCase(isagent)){
		%>
			<td align="center">Participant</td>
		<%}else{%>
			<td align="center" >&raquo; <a href="/portal/eventbeeticket/check.jsp?UNITID=13579&setid=<%=GenUtil.getHMvalue(hm,"settingid","")%>&GROUPID=<%=GenUtil.getHMvalue(hm,"groupid","")%>">Participate</a></td>
		<%}%>
		</td>
		</tr>
		<tr class="<%=base%>"> 
		<td class="<%=base%>" colspan='2' align='left'><%=(String)GenUtil.getHMvalue(hm,"startdate","")%>, <%=(String)GenUtil.getHMvalue(hm,"city","")%>, 
		<%
		String state=GenUtil.getHMvalue(hm,"state","");
		if("".equals(state)|| state==null){}
		else{%>
			<%=(String)GenUtil.getHMvalue(hm,"state","")%>,
		<%}%>
		<%=(String)GenUtil.getHMvalue(hm,"country","")%>
		</td></tr>
	<%}%>
	</table>
	
<%}%>
</form>




