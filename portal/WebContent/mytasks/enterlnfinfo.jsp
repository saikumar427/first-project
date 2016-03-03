<%@ page import="com.eventbee.general.*" %>
<%@ include file="/main/eventmgmtauth.jsp" %>

<%

	String clubid=request.getParameter("GROUPID");
	
	try{
		clubid=""+Integer.parseInt(clubid);
	}
	catch(Exception e){
		clubid="-1";
	}
	String clubname="";
	if("COMMUNITY_HUBID".equals(request.getParameter("type")))
	{
		if(!"-1".equals(clubid))
			clubname=DbUtil.getVal("select clubname from clubinfo where clubid=?",new String[]{clubid});
		if(clubname==null)
			clubname="Community";
		
		String clubmanagelink="<a href='/mytasks/clubmanage.jsp?type=Community&GROUPID="+clubid+"'/>"+clubname+"</a>";
		request.setAttribute("tasktitle","Community Manage > "+clubmanagelink);
		
	}else if("eventdetails".equals(request.getParameter("type"))){
		String groupid=request.getParameter("GROUPID");
		if(!EventMgmtAuth.authenticateManageRequest(groupid, pageContext,"LOOK_AND_FEEL_VIEW")){	
				%>
				<jsp:forward page="/guesttasks/errormessage.jsp" />
				<%
		}
		String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{groupid});
		if(eventname==null)
		eventname=" ";
		String link="<a href='/mytasks/eventmanage.jsp?GROUPID="+groupid+"'>"+eventname+"</a>";
		request.setAttribute("tasktitle","Event Manage > "+link+" > Event Page Settings");
	}
	else
	request.setAttribute("tasktitle","MY Community Page > Configure Look and Feel");

if("PUBLICPAGES".equals(request.getParameter("PS")))
request.setAttribute("mtype","My Public Pages");
else if("EVENTDET".equals(request.getParameter("PS"))){
request.setAttribute("mtype","My Console");
request.setAttribute("stype","Events");
}
else{
request.setAttribute("mtype","My Console");
request.setAttribute("stype","Community");
request.setAttribute("tasksubtitle","Configure Look and Feel");
}
%>
<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/configurelnf/enterlnfinfo.jsp";
%>
	    
	    
<%@ include file="/templates/taskpagebottom.jsp" %>
	