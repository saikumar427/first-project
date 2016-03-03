<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.forum.ForumDB" %>
<%@ page import="java.util.*"%>

<%!
   final static String FILE_NAME="discussionforums/logic/deletetopics.jsp";
%>	   
<jsp:include page="/stylesheets/CoreRequestMap.jsp" />
<%
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"deletetopics.jsp","Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
	int res=0;
	String message="";
	String forumid=request.getParameter("forumid");
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,FILE_NAME,"Topics/Messages to Delete",EventbeeLogger.LOG_START_PAGE,null);
	String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";
	String msgid[]=request.getParameterValues("msgid");
	
	String pagetype=request.getParameter("page");
	if(pagetype==null || "".equals(pagetype.trim())) 
		pagetype="Message";
	if(msgid!=null && msgid.length > 0)
		res=ForumDB.deleteDiscForum(msgid,"single","Yes");
		
	message=(""+res)+pagetype+"(s) Deleted ";		
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,FILE_NAME,"Topics/Messages ",message,null);
	response.sendRedirect(PageUtil.appendLinkWithGroup(appname+"/mytasks/dffinalinfo.jsp?message="+message+"&forumid="+forumid,(HashMap)request.getAttribute("REQMAP")));
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,FILE_NAME,"Topics/Messages to Delete",EventbeeLogger.LOG_END_PAGE,null);
%>
