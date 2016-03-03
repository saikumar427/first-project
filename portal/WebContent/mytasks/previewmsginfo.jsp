<%@ page import="com.eventbee.general.DbUtil" %>
<%@ page import="com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.general.*" %>
<%!
String query="select clubname,mgr_id  from clubinfo where clubid=?";
	HashMap gethubdet(String clubid){

		DBManager dbmanager=new DBManager();
		HashMap hm=new HashMap();
		StatusObj stobj=dbmanager.executeSelectQuery(query,new String[]{clubid});
		if(stobj.getStatus()){
			hm.put("clubname",dbmanager.getValue(0,"clubname",""));
			hm.put("mgr_id",dbmanager.getValue(0,"mgr_id",""));
		}
		return hm;
	}
	

%>




<%
String clubid=request.getParameter("GROUPID");
HashMap fourmHash=(HashMap) session.getAttribute("fmsghash");
if(clubid==null)
clubid=GenUtil.getHMvalue(fourmHash,"GROUPID");
String forumid=request.getParameter("forumid");
if(forumid==null)
forumid=GenUtil.getHMvalue(fourmHash,"forumid");
String forumname=DbUtil.getVal("select forumname from forum where forumid=? and groupid=?",new String []{forumid,clubid});

HashMap hm=null;
String authid=null;
try{
	clubid=""+Integer.parseInt(clubid);
}
catch(Exception e){
	clubid="-1";
}
String clubname="";
String mgr_id="";
if(!"-1".equals(clubid))
 hm=gethubdet(clubid);

	if(hm!=null){
		mgr_id=GenUtil.getHMvalue(hm,"mgr_id","",true);
		
		clubname=GenUtil.getHMvalue(hm,"clubname","",true);
	}
if(clubname==null)
clubname="Community";
String clubmanagelink="<a href='/mytasks/clubmanage.jsp?type=Community&GROUPID="+clubid+"'/>"+GenUtil.TruncateData(clubname,35)+"</a>";
String clubnamelink="<a href='/hub/clubview.jsp?GROUPID="+clubid+"'/>"+GenUtil.TruncateData(clubname,35)+"</a>";
String forumlink="<a href='/guesttasks/showForumTopics.jsp?forumid="+forumid+"&GROUPID="+clubid+"'/>"+GenUtil.TruncateData(forumname,35)+"</a>";
String custompurpose=DbUtil.getVal("select 'yes' from layout_config where refid=? and idtype=? ",new String [] {clubid,"COMMUNITY_HUBID"});
Authenticate authData=AuthUtil.getAuthData(pageContext);
if(custompurpose!=null){			 
		request.setAttribute("CustomLNF_Type","HubPage");
		request.setAttribute("CustomLNF_ID",clubid);
		request.setAttribute("tasktitle",forumname);
		if(clubname!=null)
		request.setAttribute("taskheader",clubnamelink);
}else{
	if (authData!=null){
		authid=authData.getUserID();

		if(authid.equals(mgr_id)){
			request.setAttribute("tasktitle","Community Manage > "+clubmanagelink+" > " +forumlink+" >  Preview");
			request.setAttribute("mtype","My Console");
			request.setAttribute("stype","Community");
		}
		else{
			request.setAttribute("tasktitle",clubnamelink+" > "+forumlink+" >  Preview");
		}
	}
}
%>


<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/discussionforums/logic/previewmsginfo.jsp";
	%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	

	
		

	
	