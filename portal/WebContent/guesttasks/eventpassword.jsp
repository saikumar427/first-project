<%@ page import="com.eventbee.general.*" %>
<%@ page import="org.eventbee.sitemap.util.Presentation" %>
<%
String groupid=Presentation.GetRequestParam(request,  new String []{"eid","eventid", "id", "GROUPID", "gid"});
request.setAttribute("CustomLNF_Type","EventDetails");
request.setAttribute("CustomLNF_ID",groupid);
String evtname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{groupid});
String listurl="/eventdetails/event.jsp?eventid="+groupid;
//String evtlink="<a href='"+listurl+"'>"+evtname+"</a>";

//request.setAttribute("tasktitle",  evtname+" - Password protection" );
request.setAttribute("stype","Events");
%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%	
	taskpage="/customevents/eventpasswordform.jsp";
	footerpage="/main/eventfootermain.jsp";
%>
<%@ include file="/templates/taskpagebottom.jsp" %>
		      		
	