<%@ page import="java.util.*,com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.customconfig.*" %>



<%!
	boolean isManagerLoggedIn(List moderatorlist,String userid){
		boolean logged=false;
		List templist=new ArrayList();
		if(moderatorlist !=null){
			int modsize=moderatorlist.size();
			for(int i=0;i<modsize;i++){
				Map manmap=(Map)moderatorlist.get(i);
				templist.add((String)manmap.get("user_id"));
			}
		}
		logged=templist.contains(userid);
		return logged;
	}

%>

<%
	String groupid="";
	groupid=(String)request.getAttribute("GROUPID");
	if(groupid==null)
	groupid=(String)request.getAttribute("CLUBID");
	if(groupid==null)
	groupid=request.getParameter("GROUPID");
	boolean includefiles=false;
	String unitid=request.getParameter("UNITID");
	String clubname="";
	HashMap groupinfo=null;
	String clubtype=null;
	String clubapprovaltype=null;
	if(groupid !=null){
			groupinfo=new HashMap();
			groupinfo.put("GROUPID",groupid);
			groupinfo.put("groupid",groupid);
			
			if(unitid!=null){
				groupinfo.put("UNITID",unitid);
				groupinfo.put("unitid",unitid);
			}
			groupinfo.put("GROUPTYPE","Club");
			groupinfo.put("grouptype","Club");
			groupinfo.put("PS","clubmanage");
			session.setAttribute("groupinfo",groupinfo);
			
			HashMap hubinfohash=com.eventbee.hub.hubDB.getHubInfo(groupid,null);
			if(hubinfohash!=null)
			{
				clubtype=(String)hubinfohash.get("clubtype");
				clubname=(String)hubinfohash.get("clubname");
				clubapprovaltype=(String)hubinfohash.get("club.memberapproval.type");
				request.setAttribute("HUBINFOHASH",hubinfohash);
				Authenticate authData=AuthUtil.getAuthData(pageContext);
				if(authData !=null){
					String userid=authData.getUserID();
					String mgr_id=GenUtil.getHMvalue(hubinfohash,"mgr_id","0");
					boolean ismgrloggedin=isManagerLoggedIn((List)hubinfohash.get("ModeratorList"),userid);
					
					if(ismgrloggedin)includefiles=true;
				}
			}
		}
		
	String link1="Community Manage";
        request.setAttribute("tasktitle",link1+ " > "+clubname  );
	request.setAttribute("mtype","My Console");
	request.setAttribute("stype","Community");
	request.setAttribute("layout", "DEFAULT");

%>

<%@ include file="/templates/beeletspagetop.jsp" %>

<%

		
		
	if(!includefiles){			
	
	
	%>
	<jsp:forward page="<%=PageUtil.appendLinkWithGroup("/mytasks/showhubmessage.jsp",groupinfo ) %>" />
	<% }


	com.eventbee.web.presentation.beans.BeeletItem item;       
   
      
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("Statistics");
	item.setResource("/club/statistics.jsp");
	leftItems.add(item);
	
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("Information");
	item.setResource("/club/logic/ClubInfoBeelet.jsp?page=manage");
	leftItems.add(item);
	
   
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("Forum");
	item.setResource("/discussionforums/logic/MgrForumBeelet.jsp");
	leftItems.add(item);
	
	 
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("forumstreamer");
	item.setResource("/forumstreamer/forumstreamer.jsp");
	leftItems.add(item);
	
  if("Paid".equals(clubapprovaltype)){
	
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("IntegrationLinks");
	item.setResource("/club/integrationlinks.jsp");
	leftItems.add(item);
	
	
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("memberships");
	item.setResource("/club/ClubMembershipBeelet.jsp?page=manage");
	leftItems.add(item);
	

	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("Members");
	item.setResource("/club/ClubMemberManageBeelet.jsp");
	rightItems.add(item);
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
		item.setBeeletId("Reports");
		item.setResource("/listreport/communityreports.jsp");
		rightItems.add(item);
	
item= new com.eventbee.web.presentation.beans.BeeletItem();
		item.setBeeletId("Discounts");
		item.setResource("/clubdiscounts/clubdiscounts.jsp");
		rightItems.add(item);
	
	
	
	
	}
	else{
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("Members");
	item.setResource("/club/memmanage.jsp");
	rightItems.add(item);
	}
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("Noticeboard");
	item.setResource("/noticeboard/mgrnotices.jsp?from=hubs");
	rightItems.add(item);
	item= new com.eventbee.web.presentation.beans.BeeletItem();
		item.setBeeletId("Configure");
		item.setResource("/hub/logic/ConfigureHubFeatures.jsp");
	rightItems.add(item);
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("Events");
	item.setResource("/createevent/logic/clubevent.jsp");
	//rightItems.add(item);
	
	
	
	
	
	
	
	
%>
      		
<%@ include file="/templates/beeletspagebottom.jsp" %>

