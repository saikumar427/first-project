<%@ page import="com.eventbee.general.*" %>
<%@ page import="org.eventbee.sitemap.util.Presentation" %>
<%
String groupid=Presentation.GetRequestParam(request,  new String []{"eid","eventid", "id","groupid"});
request.setAttribute("CustomLNF_Type","EventDetails");
request.setAttribute("CustomLNF_ID",groupid);
String evtname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{groupid});
String listurl="/event?eid="+groupid;

String evtlink="<a href='"+listurl+"'>"+evtname+"</a>";


request.setAttribute("tasktitle",evtlink+" > Upgrade/Edit Registration");

request.setAttribute("stype","Events");
%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%	
	taskpage="/customevents/upgraderegistration.jsp";
	footerpage="/main/eventfootermain.jsp";
%>
<%@ include file="/templates/taskpagebottom.jsp" %>
		      		
