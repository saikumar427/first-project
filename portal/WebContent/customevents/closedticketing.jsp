<%@ page import="com.eventbee.general.EbeeConstantsF" %>
<%@ page import="com.eventbee.general.formatting.EventbeeStrings" %>

<%

	String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";
	//String eunitid=request.getParameter("UNITID");
	String club_title=EbeeConstantsF.get("club.label","Bee Hive");
	String code=("Bee Hive".equalsIgnoreCase(club_title))?"beehive":"hub";
	
	
%>
<%//request.setAttribute("tasktitle",EventbeeStrings.getDisplayName(club_title,"Beehive"));%>
<%//request.setAttribute("tasksubtitle","Error");%>
<html title='<%=EventbeeStrings.getDisplayName(club_title,"Beehive")%>' sub-title='Error'>
<body>

<%@ include file="/templates/taskpagetop.jsp" %>

<%	
	taskpage="/customevents/eventmessage.jsp";%>
	
	<%
	//footerpage="/main/eventfootermain.jsp";
%>

<table valign="bottom">
<%@ include file="/templates/taskpagebottom.jsp" %>
	</table>
</body>.
</html>