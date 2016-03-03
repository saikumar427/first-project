<%@ page import="java.util.*,com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.customconfig.*,com.eventbee.hub.*,java.lang.*" %>
<jsp:include page='validclub.jsp' />
<%@ include file="/discussionforums/logic/forummethods.jsp" %>
<%!
        HashMap URLMAP=null;
	public void jspInit(){
		URLMAP=new HashMap();
		URLMAP.put("clubinfo","/club/logic/ClubInfo.jsp");
		URLMAP.put("upcomingclubevents","/club/logic/clubupcomingevents.jsp");
		URLMAP.put("sponsors","/eventdetails/eventsponsorship.jsp");
		URLMAP.put("discussionforummember","/discussionforums/logic/forumTopicsinfo.jsp");
		URLMAP.put("contentbeelet2","/customconfig/logic/CustomContentBeelet.jsp?portletid=HUB_GUEST_PAGE&customborder=portalback");
		URLMAP.put("contentbeelet","/customconfig/logic/CustomContentBeelet.jsp?portletid=GUEST_CLUB_PAGE&customborder=portalback");
		URLMAP.put("ViewStatus","/hub/logic/hubmemberstatusbeelet.jsp");
		URLMAP.put("contentbeelet4","/customconfig/logic/CustomContentBeelet.jsp?portletid=HUB_MEM_PAGE&customborder=portalback");
		URLMAP.put("contentbeelet5","/customconfig/logic/CustomContentBeelet.jsp?portletid=HUB_MEM_PAGE1&customborder=portalback");
		URLMAP.put("Members","/hub/logic/MembersBeelet.jsp");
		URLMAP.put("clubmembership","/clubdetails/ClubMembershipsBeelet.jsp");
		URLMAP.put("noticeboardmember","/noticeboard/groupnotices.jsp");
		URLMAP.put("polls1","/polls/logic/PollViewBeelet.jsp?location=GUEST_CLUB_PAGE");
		URLMAP.put("memclassifieds","/classifieds/classifiedBeelet.jsp?purpose=classified");
		URLMAP.put("Statistics","/club/statistics.jsp");
	}
%>
<%

String border="Yes";
	String gap="Yes";
	String alignment="center";
	String groupid=request.getParameter("GROUPID");
	String unitid=request.getParameter("UNITID");
	String pagelocation="HUB_GUEST_PAGE";
	String clubtype="";
	String clubapprovaltype="";
	HashMap groupinfo=new HashMap();
	if(groupid !=null){		
		groupinfo.put("GROUPID",groupid);
		groupinfo.put("groupid",groupid);

		if(unitid!=null){
			groupinfo.put("UNITID",unitid);
			groupinfo.put("unitid",unitid);
		}
		groupinfo.put("GROUPTYPE","Club");
		groupinfo.put("grouptype","Club");
		groupinfo.put("PS","clubview");
		session.setAttribute("groupinfo",groupinfo);
		String authid=null;
		Authenticate authData=AuthUtil.getAuthData(pageContext);//(Authenticate)session.getAttribute(ContextConstants.AUTH_DATA_OBJ);
		if(authData!=null)
		{
		authid=authData.getUserID();
		String memstatus=HubMaster.getUsersHubStatus(authid,groupid);
		if("HUBMGR".equals(memstatus)||"HUBMEMBER".equals(memstatus))
		pagelocation="HUB_MEM_PAGE";
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"clubview.jsp","authdata not null& pagelocation"+pagelocation,"authid========="+authid,null);

		}
		

		if("y".equals(request.getParameter("p")))
		pagelocation="HUB_GUEST_PAGE";
		String sessid=(String)session.getId();
		if(session.getAttribute("club_visited_"+groupid) ==null){
			HitDB.insertHit(new String[]{"clubview.jsp","Zone",sessid,groupid,authid});
			session.setAttribute("club_visited_"+groupid,groupid) ;
		}
		
		HashMap hubinfohash=com.eventbee.hub.hubDB.getHubInfo(groupid,null);
		if(hubinfohash!=null){
			clubtype=(String)hubinfohash.get("clubtype");
			clubapprovaltype=(String)hubinfohash.get("club.memberapproval.type");
		}
		request.setAttribute("HUBINFOHASH",hubinfohash);
		if("Paid".equals(clubapprovaltype)&&authData==null){
			URLMAP.put("Login","/hub/login.jsp");
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"clubview.jsp","** authdata is null& paid hub **","",null);
		}
		else
			URLMAP.remove("Login");

	}
	String clublogo="none";
	if("13579".equals(EbeeConstantsF.get("defaultunitid","13579")))
	clublogo=DbUtil.getVal("select clublogo from clubinfo where clubid=?",new String [] {groupid});
	else
	if("13578".equals(EbeeConstantsF.get("defaultunitid","13579")))
	clublogo=DbUtil.getVal("select unit_code from org_unit where unit_id=(select unitid from clubinfo where clubid= ?)",new String [] {groupid} );

	StringBuffer sb=new StringBuffer();
	HashMap urlmapping=URLMAP;
	HashMap forums=getForums(groupid,sb,urlmapping,"/discussionforums/logic/newforum.jsp?clublogo="+clublogo+"&");
	
	
	request.setAttribute("ALLFORUMS",forums);
	
	

	HashMap forummap=getForumtopics(groupid);
	
	request.setAttribute("FORUM_MAP",forummap);
	
	MemberLayout ML=new MemberLayout(new String[]{null,groupid,null},pagelocation);
	Map layoutMap=ML.getBeelets();
	String layoutWidths=ML.getLayout();
	String[] col_str=(String[]) layoutMap.get("assignedcols");
	border=(layoutMap.get("custombeelets.border")==null)?"Yes":GenUtil.getHMvalue((HashMap)layoutMap,"custombeelets.border");
	gap=(layoutMap.get("custombeelets.gap")==null)?"Yes":GenUtil.getHMvalue((HashMap)layoutMap,"custombeelets.gap");
	alignment=(layoutMap.get("custombeelets.alignment")==null)?"center":GenUtil.getHMvalue((HashMap)layoutMap,"custombeelets.alignment");
	gap="Yes".equals(gap)?"5":"0";
	border="Yes".equals(border)?"beelettable":"";
	List al=new ArrayList();
	for(int i=0;i<col_str.length;i++){
		if(col_str[i]!=null && !("".equals(col_str[i].trim()))){
			if(i==col_str.length-1){
			col_str[i]=col_str[i]+",gcontentbeelet";
			}
			al.add(GenUtil.strToArrayStr(col_str[i].replaceAll("discussionforummember",sb.toString()),","));

		}
	}

	String[] widths=PageUtil.getWidth(layoutWidths);
	HashMap colmap=new HashMap();
	for(int i=0;i<al.size();i++)
		colmap.put("col"+(i+1),(String[])al.get(i));
	for(int i=0;i<widths.length;i++)
		colmap.put("col"+(i+1)+"width",widths[i]);
 	String count=DbUtil.getVal("select count(*) from layout_config where refid=?",new String [] {request.getParameter("GROUPID")});
	if(Integer.parseInt(count)>0)
	 request.setAttribute("customlookid","hub");
	if(!("premium".equals(clubtype)))
	 urlmapping.put("contentbeelet4","/customconfig/logic/CustomContentBeelet.jsp?portletid=GUEST_CLUB_PAGE&customborder=portalback");
	//urlmapping.put("ad","/adbanner/ad.jsp");
	urlmapping.put("gcontentbeelet","/customconfig/logic/CustomContentBeelet.jsp?portletid=G_AD_HUB_DETAILS&forgroup=13579&customborder=portalback");
	request.setAttribute("tabtype","club");
%>
<%@ include file="/stylesheets/portalpage.jsp" %>
