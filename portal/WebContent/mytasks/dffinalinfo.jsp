<%@ page import="com.eventbee.general.DbUtil" %>




<%
String clubid=request.getParameter("GROUPID");
String forumid=request.getParameter("forumid");

try{
	clubid=""+Integer.parseInt(clubid);
}
catch(Exception e){
	clubid="-1";
}
String clubname="";
if(!"-1".equals(clubid))
clubname=DbUtil.getVal("select clubname from clubinfo where clubid=?",new String[]{clubid});
if(clubname==null)
clubname="Community";
String clubmanagelink="<a href='/mytasks/clubmanage.jsp?type=Community&GROUPID="+clubid+"'/>"+clubname+"</a>";
String custompurpose=DbUtil.getVal("select 'yes' from layout_config where refid=? and idtype=? ",new String [] {clubid,"COMMUNITY_HUBID"});
String forumname=DbUtil.getVal("select forumname from forum where forumid=? and groupid=?",new String []{forumid,clubid});
String clubnamelink="<a href='/hub/clubview.jsp?GROUPID="+clubid+"'/>"+clubname+"</a>";


if(custompurpose!=null){			 
		request.setAttribute("CustomLNF_Type","HubPage");
		request.setAttribute("CustomLNF_ID",clubid);
		request.setAttribute("tasktitle",forumname);
		if(clubname!=null)
		request.setAttribute("taskheader",clubnamelink);
     }else{

request.setAttribute("tasktitle","Community Manage > "+clubmanagelink+" > Done");


request.setAttribute("mtype","My Console");
request.setAttribute("stype","Community");
}

%>
<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/discussionforums/logic/dffinalinfo.jsp";
%>
	    
	    
<%@ include file="/templates/taskpagebottom.jsp" %>
	