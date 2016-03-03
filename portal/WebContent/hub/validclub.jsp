<%@page import="com.eventbee.general.*" %>
<%
	String validclub=DbUtil.getVal("select 'yes' as club from clubinfo where clubid=? ", new String[]{request.getParameter("GROUPID")});
	
	if(!"yes".equals(validclub)){
	String title=com.eventbee.general.EbeeConstantsF.get("club.label","Bee Hive");
	title=(title.equalsIgnoreCase("HUB"))?"Hub":"Communities";
		request.setAttribute("tabtype","club");
		//request.setAttribute("tasktitle",title);
		//request.setAttribute("tasksubtitle","Invalid URI");
		request.setAttribute("message","Invalid "+title+" URI ");
		GenUtil.Redirect(response,"/guesttasks/invaliduri.jsp?message=Invalid"+title+"URI");
		
	%>
		<%--jsp:forward page='/stylesheets/invaliduri.jsp' /--%>
	<%}%>	
