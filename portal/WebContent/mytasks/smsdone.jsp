<%@ page import="com.eventbee.general.DbUtil" %>
<%@ page import="com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.general.*" %>



<%
String groupid=" ",forumid="",topicid="";
HashMap sh=(HashMap)session.getAttribute("smshash");

if(sh!=null)
{
 groupid=(String)sh.get("groupid");
 forumid=(String)sh.get("forumid");
 topicid=(String)sh.get("topicid");
}


String forumname=DbUtil.getVal("select forumname from forum where forumid=? and groupid=?",new String []{forumid,groupid});
String clubname=DbUtil.getVal("select clubname from clubinfo where clubid=?",new String []{groupid});
String clubnamelink="<a href='/hub/clubview.jsp?GROUPID="+groupid+"'/>"+GenUtil.TruncateData(clubname,35)+"</a>";
String forumlink="<a href='/guesttasks/showForumTopics.jsp?forumid="+forumid+"&GROUPID="+groupid+"'/>"+GenUtil.TruncateData(forumname,35)+"</a>";
String topiclink="<a href='/guesttasks/showTopicMessages.jsp?topicid="+topicid+"&forumid="+forumid+"&GROUPID="+groupid+"'/>View Topic</a>";
String custompurpose=DbUtil.getVal("select 'yes' from layout_config where refid=? and idtype=? ",new String [] {groupid,"COMMUNITY_HUBID"});
if(custompurpose!=null){
	request.setAttribute("CustomLNF_Type","HubPage");
	request.setAttribute("CustomLNF_ID",groupid);
	request.setAttribute("tasktitle",forumname);
	if(clubname!=null)
		request.setAttribute("taskheader",clubnamelink);
}else
	request.setAttribute("tasktitle",clubnamelink+" > "+forumlink+" > "+topiclink+" >  Post Reply");



%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/sms/done.jsp";
	%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	

	
		

	
	