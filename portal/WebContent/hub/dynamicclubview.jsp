<%@ page import="java.util.*,com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.customconfig.*" %>
<%

/*

create table beelet_profile(
purpose varchar,
beelet varchar,
url varchar

);




insert into beelet_profile(purpose,beelet,url) values('clubview','clubinfo','/club/logic/ClubInfoBeelet.jsp');
insert into beelet_profile(purpose,beelet,url) values('clubview','contentbeelet2','/customconfig/logic/CustomContentBeelet.jsp?portletid=GUEST_CLUB_PAGE');
insert into beelet_profile(purpose,beelet,url) values('clubview','polls1','/polls/logic/PollViewBeelet.jsp?location=GUEST_CLUB_PAGE');
insert into beelet_profile(purpose,beelet,url) values('clubview','clubmembership','/hub/logic/MembersBeelet.jsp');
insert into beelet_profile(purpose,beelet,url) values('clubview','clubhomemenu','/hub/logic/hubmemberstatusbeelet.jsp');
insert into beelet_profile(purpose,beelet,url) values('clubview','discussionforummember','/discussionforums/logic/forumTopicsinfo.jsp');
insert into beelet_profile(purpose,beelet,url) values('clubview','memclassifieds','/classifieds/logic/classifiedBeelet.jsp?purpose=classified');
*/
	String border="Yes";
	String gap="Yes";
	String alignment="center";
	String groupid=request.getParameter("GROUPID");
	String unitid=request.getParameter("UNITID");
	if(groupid !=null){
		HashMap groupinfo=new HashMap();
		groupinfo.put("GROUPID",groupid);
		groupinfo.put("groupid",groupid);
		
		if(unitid!=null){
			groupinfo.put("UNITID","13579");
			groupinfo.put("unitid","13579");
		}
		groupinfo.put("GROUPTYPE","Club");
		groupinfo.put("grouptype","Club");
		groupinfo.put("PS","clubview");
		session.setAttribute("groupinfo",groupinfo);
		String authid=null;
		Authenticate authData=AuthUtil.getAuthData(pageContext);//(Authenticate)session.getAttribute(ContextConstants.AUTH_DATA_OBJ);
		if(authData!=null)authid=authData.getUserID();
		String sessid=(String)session.getId();
		if(session.getAttribute("club_visited_"+groupid) ==null){
			HitDB.insertHit(new String[]{"clubview.jsp","Zone",sessid,groupid,authid});
			session.setAttribute("club_visited_"+groupid,groupid) ;
		}
		
		
		
		
	}
	
	MemberLayout ML=new MemberLayout(new String[]{null,groupid,null},"GUEST_PAGE");
	Map layoutMap=ML.getBeelets();
	String layoutWidths=ML.getLayout();
	String[] col_str=(String[]) layoutMap.get("assignedcols");
	border=(layoutMap.get("custombeelets.border")==null)?"Yes":GenUtil.getHMvalue((HashMap)layoutMap,"custombeelets.border");
	gap=(layoutMap.get("custombeelets.gap")==null)?"Yes":GenUtil.getHMvalue((HashMap)layoutMap,"custombeelets.gap");
	alignment=(layoutMap.get("custombeelets.alignment")==null)?"center":GenUtil.getHMvalue((HashMap)layoutMap,"custombeelets.alignment");   
	gap="Yes".equals(gap)?"5":"0";
	border="Yes".equals(border)?"beelettable":"";
	//out.println(gap+" border="+border+" alignment :"+alignment+"layoutWidths "+layoutWidths);
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
	HashMap urlmapping= PageUtil.getURLMapping("clubview");
	
	
	
	
	
	
	
%>
<%@ include file="/stylesheets/portalpage.jsp" %>
