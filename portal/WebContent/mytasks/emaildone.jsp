<%@ page import="com.eventbee.general.*" %>
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
try{
	clubid=""+Integer.parseInt(clubid);
}
catch(Exception e){
	clubid="-1";
}
String clubname="";
String authid=null;
String mgr_id=null;
HashMap hm=null;
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
Authenticate authData=AuthUtil.getAuthData(pageContext);
	if (authData!=null){
	 authid=authData.getUserID();
	 //role=authData.getRoleName();
	 
	 if(authid.equals(mgr_id))
	 {

request.setAttribute("tasktitle","Community Manage > "+clubmanagelink+" > Invite Friends");
request.setAttribute("mtype","My Console");
request.setAttribute("stype","Community");
}
else
{
request.setAttribute("tasktitle", clubnamelink+" > Invite Friends");
}
}

%>
<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/club/emaildone.jsp";
%>
	      		
<%@ include file="/templates/taskpagebottom.jsp" %>
		