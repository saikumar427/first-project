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
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"clubmanage.jsp","Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);

	boolean includefiles=false;
	
	String border="beelettable";
	String gap="5";
	String alignment="center";
	//String layoutWidths="WNN";
	String layoutWidths="EE";
	String[] col_str=new String[]{"","",""};
	col_str[0]="Statistics,Information,Forum,forumstreamer,IntegrationLinks,memberships";
	col_str[1]="Members,Noticeboard,upgrade,Configure,Fundraising";
	//col_str[1]="Noticeboard,Forum,Fundraising,Classifieds,Events";
	//col_str[2]="upgrade,Configure";
	String groupid="";
	groupid=(String)request.getAttribute("GROUPID");
	if(groupid==null)
	groupid=request.getParameter("GROUPID");
	
	String unitid=request.getParameter("UNITID");
	
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
			clubapprovaltype=(String)hubinfohash.get("club.memberapproval.type");
			request.setAttribute("HUBINFOHASH",hubinfohash);
			Authenticate authData=AuthUtil.getAuthData(pageContext);//(Authenticate)session.getAttribute("authData");
			if(authData !=null){
				String userid=authData.getUserID();
				String mgr_id=GenUtil.getHMvalue(hubinfohash,"mgr_id","0");
				boolean ismgrloggedin=isManagerLoggedIn((List)hubinfohash.get("ModeratorList"),userid);
				if(ismgrloggedin)includefiles=true;
			}
		}
	}
	
	
	
if(!includefiles){

		


%>
<jsp:forward page="<%=PageUtil.appendLinkWithGroup("/hub/showmessage.jsp",groupinfo ) %>" />
<% }


	HashMap datahash=new HashMap();
		String BACK_PAGE_URL=request.getContextPath()+"/mytasks/clubmanage.jsp?GROUPID="+groupid;
		datahash.put("BACK_PAGE","Back to Manage");
		datahash.put("redirecturl",BACK_PAGE_URL);
		session.setAttribute("REDIRECT_HASH",datahash);
		
	
	
	List al=new ArrayList();
	for(int i=0;i<col_str.length;i++){
		if(col_str[i]!=null && !("".equals(col_str[i].trim()))){
			al.add(GenUtil.strToArrayStr(col_str[i],","));
		}			
	}
	String[] widths=PageUtil.getWidth(layoutWidths);
	HashMap colmap=new HashMap();
	for(int i=0;i<al.size();i++)
		colmap.put("col"+(i+1),(String[])al.get(i));
	for(int i=0;i<widths.length;i++)
		colmap.put("col"+(i+1)+"width",widths[i]);
	//HashMap urlmapping= PageUtil.getURLMapping("clubmanage");
	HashMap urlmapping= new HashMap();
/*
	if("basic".equals(clubtype))
	{
	urlmapping.put("upgrade","/hub/upgradeclub.jsp");
	//urlmapping.put("Configure","/hub/logic/ConfigureHub.jsp");

	}
	else
*/
	urlmapping.put("Configure","/hub/logic/ConfigureHubFeatures.jsp");
	urlmapping.put("Statistics","/club/statistics.jsp");
	urlmapping.put("Information","/club/logic/ClubInfoBeelet.jsp?page=manage");
	urlmapping.put("forumstreamer","/forumstreamer/forumstreamer.jsp");
	
	if("Paid".equals(clubapprovaltype)){
	urlmapping.put("memberships","/club/ClubMembershipBeelet.jsp?page=manage");
	urlmapping.put("Members","/club/ClubMemberManageBeelet.jsp");
	urlmapping.put("IntegrationLinks","/club/integrationlinks.jsp");

	}
	else{                                                                              
	urlmapping.put("Members","/club/memmanage.jsp");
	}
	urlmapping.put("Noticeboard","/noticeboard/mgrnotices.jsp");
	urlmapping.put("Forum","/discussionforums/logic/MgrForumBeelet.jsp");
	//urlmapping.put("Fundraising","/fundraising/fundraising.jsp");
	urlmapping.put("Classifieds","/classifieds/logic/newmgrClassifiedBeelet.jsp?purpose=classified");
	urlmapping.put("Events","/createevent/logic/clubevent.jsp");
	//request.setAttribute("tabtype","club");
	request.setAttribute("subtabtype","Communities");
%>
<%@ include file="/stylesheets/portalpage.jsp" %>



