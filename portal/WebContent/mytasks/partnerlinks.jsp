<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.eventbee.authentication.*" %>
<%!
public HashMap getManualEventsPartnerStatus(String userid){
String Query=" select status,eventid from manual_nts_events where partnerid=(select partnerid from group_partner where userid=?)";
HashMap statusmap=new HashMap();
DBManager dbmanager=new DBManager();
StatusObj stobj=dbmanager.executeSelectQuery(Query,new String[]{userid});

if(stobj.getStatus())
{
	for(int k=0;k<stobj.getCount();k++)
	{			
	statusmap.put(dbmanager.getValue(k,"eventid",""),dbmanager.getValue(k,"status",""));
	}
}
return statusmap;
}
%>
<%
String userid="";
Authenticate authData=AuthUtil.getAuthData(pageContext);
if(authData !=null){
	userid=authData.getUserID();
}
String evtid=request.getParameter("groupid");

HashMap eventstatusmap=getManualEventsPartnerStatus(userid);
	String agentstatus=(String)GenUtil.getHMvalue(eventstatusmap,evtid,"");
			
	if ("".equalsIgnoreCase(agentstatus)){
	String apprvstatus=DbUtil.getVal("select nts_approvaltype from group_agent_settings where groupid=?",new String[]{evtid});

	if("Auto".equals(apprvstatus))
		agentstatus="Approved";		
	else
		agentstatus="Need Approval";
}
	
	

String evtname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{request.getParameter("groupid")});
String listurl="/mytasks/networkticketsellingpage.jsp";
String evtlink="<a href='"+listurl+"'>My Network Ticket Selling</a>";
String groupid=request.getParameter("groupid");

request.setAttribute("mtype","Network Ticket Selling");
//request.setAttribute("layout", "EE");
String pageToInclude="";

if("Need Approval".equals(agentstatus)){         
		pageToInclude="/eventbeeticket/getntsapproval.jsp";
		request.setAttribute("tasktitle",""+evtlink+" > "+evtname+" > Get Approval");
	 }
	 else if("Pending".equals(agentstatus)){
	 
	pageToInclude="/eventbeeticket/ntspending.jsp";
	request.setAttribute("tasktitle",""+evtlink+" > "+evtname+" > Pending Request");
	
	}
	else if("Suspended".equals(agentstatus)){
		 
	pageToInclude="/eventbeeticket/ntsnotapproved.jsp";
	request.setAttribute("tasktitle",""+evtlink+" > "+evtname+" > Not Authorized");
		
	}
	else{
		pageToInclude="/webintegration/links.jsp";
		request.setAttribute("tasktitle",""+evtlink+" > "+evtname+" > Manage");
	}
	
%>
<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage=pageToInclude;
%>
	      		
<%@ include file="/templates/taskpagebottom.jsp" %>