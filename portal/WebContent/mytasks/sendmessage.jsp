<%@ page import="com.eventbee.general.*" %>

<%

String clubid=request.getParameter("GROUPID");
String forumid=request.getParameter("forumid");
String topicid=request.getParameter("topicid");
String forumname=DbUtil.getVal("select forumname from forum where forumid=? and groupid=?",new String []{forumid,clubid});
String clubname=DbUtil.getVal("select clubname from clubinfo where   clubid=?",new String []{clubid});
String clubnamelink="<a href='/hub/clubview.jsp?GROUPID="+clubid+"'/>"+GenUtil.TruncateData(clubname,35)+"</a>";
String forumlink="<a href='/guesttasks/showForumTopics.jsp?forumid="+forumid+"&GROUPID="+clubid+"'/>"+GenUtil.TruncateData(forumname,35)+"</a>";
String topiclink="<a href='/guesttasks/showTopicMessages.jsp?topicid="+topicid+"&forumid="+forumid+"&GROUPID="+clubid+"'/>View Topic</a>";
String custompurpose=DbUtil.getVal("select 'yes' from layout_config where refid=? and idtype=? ",new String [] {clubid,"COMMUNITY_HUBID"});
if(custompurpose!=null){
	request.setAttribute("CustomLNF_Type","HubPage");
	request.setAttribute("CustomLNF_ID",clubid);
	request.setAttribute("tasktitle",forumname);
	if(clubname!=null)
		request.setAttribute("taskheader",clubnamelink);
}else
	request.setAttribute("tasktitle", clubnamelink+" > "+forumlink+" > "+topiclink+" > Send Message");

%>



<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/discussionforums/logic/sendmessage.jsp";
	footerpage="/main/communityfootermain.jsp";
%>
	    
	    
<%@ include file="/templates/taskpagebottom.jsp" %>
	