<%@ page import="com.eventbee.general.*,com.eventbee.authentication.Authenticate" %>

<%
String authid="";
Authenticate authData=AuthUtil.getAuthData(pageContext);
if(authData!=null)authid=authData.getUserID();
String evtid=request.getParameter("eid");
String userid=DbUtil.getVal("select mgr_id from eventinfo where eventid=?",new String[]{evtid});
String evtname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{evtid});
if(!authid.equals(userid)){
request.setAttribute("tasktitle", evtname+" > Network Ticket Selling - Participate" );
}else{
String link="<a href='/mytasks/eventmanage.jsp?GROUPID="+evtid+"'>"+evtname+"</a>";
request.setAttribute("tasktitle", link+" > Network Ticket Selling - Participate" );
}
request.setAttribute("stype","Events");
%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%	
	taskpage="/guesttasks/networkparticipation.jsp";
	footerpage="/main/eventfootermain.jsp";
%>
<%@ include file="/templates/taskpagebottom.jsp" %>
		      		
	