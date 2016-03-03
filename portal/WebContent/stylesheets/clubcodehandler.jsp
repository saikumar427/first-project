<%@ page import="java.util.*,com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.customconfig.*,com.eventbee.useraccount.AccountDB" %>

<%

String unitid=null;
String groupid=null;
String clubcode=request.getParameter("code");
String module=request.getParameter("mod");
String fortype=request.getParameter("FT");

boolean invalidrequest=true;
String forumid=null;
	if(clubcode !=null){
		HashMap hm=AccountDB.getUnitInfo(clubcode);
		if(hm!=null){
			unitid=(String)hm.get("unitid");
			groupid=(String)hm.get("clubid");
			if("13579".equals(EbeeConstantsF.get("defaultunitid","13578")))
			unitid="13579";
		}
	}
	
	if(unitid==null)unitid="13579";
	if(groupid==null)groupid="-100";

	
	if("forum".equals(module) ){
		if("rss".equals(fortype) ){
		invalidrequest=false;
		 forumid=request.getParameter("id");
		 if(forumid==null||"".equals(forumid.trim()))
			 forumid=DbUtil.getVal("select forumid  from forum a where groupid="+groupid+" order by createdat desc",null);
			if(forumid==null)forumid="0";
			response.sendRedirect("/portal/discussionforums/logic/rssshowForumTopics.jsp?forumid="+forumid);
		}
	}

	
	
	if(invalidrequest){
		out.println("invalid request");
	}
	

%>
