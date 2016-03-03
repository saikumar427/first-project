<%@ page import="com.eventbee.general.*"%>

<%
String clubid=request.getParameter("GROUPID");
String custompurpose=DbUtil.getVal("select 'yes' from layout_config where refid=? and idtype=? ",new String [] {clubid,"COMMUNITY_HUBID"});
String clubname=DbUtil.getVal("select clubname from clubinfo where clubid=?",new String [] {clubid});
String clubnamelink="<a href='/hub/clubview.jsp?GROUPID="+clubid+"'/>"+GenUtil.TruncateData(clubname,35)+"</a>";
if(custompurpose!=null){
		request.setAttribute("CustomLNF_Type","HubPage");
		request.setAttribute("CustomLNF_ID",clubid);
		request.setAttribute("tasktitle","Membership Details");
		if(clubname!=null)
		request.setAttribute("taskheader",clubnamelink);
}
else{
	request.setAttribute("mtype","My Console");
	request.setAttribute("stype","Community");
}
%>
<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/hub/hubmemberdue.jsp";
	footerpage="/main/communityfootermain.jsp";
	%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	

	
		