<%@ page import="com.eventbee.general.*" %>

<%
if("events".equals(request.getParameter("from")))
{ 
	request.setAttribute("stype","Events");
	String groupid=request.getParameter("GROUPID");
	String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{groupid});
	if(eventname==null)
		eventname="";
	String link="<a href='/mytasks/eventmanage.jsp?GROUPID="+groupid+"'>"+eventname+"</a>";
	request.setAttribute("tasktitle","Event Manage > "+link+" > Post Notice");
}
else
{

	request.setAttribute("stype","Community");
	String clubid=request.getParameter("GROUPID");
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
	String mycommunitieslink="<a href='/mytasks/myhubs.jsp'/>My Communities</a>";
	String clubmanagelink="<a href='/mytasks/clubmanage.jsp?type=Community&GROUPID="+clubid+"'/>"+clubname+"</a>";
	request.setAttribute("tasktitle","Community Manage > "+clubmanagelink+" > Post Notice");


}
request.setAttribute("mtype","My Console");

%>
<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/noticeboard/enternoticeinfo.jsp";
%>
	    
	    
<%@ include file="/templates/taskpagebottom.jsp" %>
	