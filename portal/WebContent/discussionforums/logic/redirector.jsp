<%@ page import="com.eventbee.general.*" %>
<%
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"redirector.jsp","Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
	String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";
        String clubid=request.getParameter("GROUPID");
        String forumid=request.getParameter("forumid");
        String topicid=request.getParameter("topicid");
        

%>


<%if("Post Reply".equalsIgnoreCase(request.getParameter("submit"))){
 
 %>
	<jsp:forward page='/mytasks/entermsginfo.jsp' >
	<jsp:param name='GROUPID' value='<%=clubid%>'/>
			<jsp:param name='forumid' value='<%=forumid%>'/>
		</jsp:forward>
<%}else if("Send Message".equalsIgnoreCase(request.getParameter("submit"))){
	response.sendRedirect(appname+"/auth/listauth.jsp?GROUPID="+request.getParameter("GROUPID")+"&purpose=sendmessage&msgto="+request.getParameter("msgto")+"&forumid="+forumid+"&topicid="+topicid);
}else if("Delete".equalsIgnoreCase(request.getParameter("submit"))){%>
	<jsp:forward page='deletetopics.jsp' />
<%}%>

