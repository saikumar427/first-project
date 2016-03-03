<%@ page import="com.eventbee.general.*"%>

<%
String clubid=request.getParameter("GROUPID");
String custompurpose=DbUtil.getVal("select 'yes' from layout_config where refid=? and idtype=? ",new String [] {clubid,"COMMUNITY_HUBID"});
String clubname=DbUtil.getVal("select clubname from clubinfo where clubid=?",new String[]{clubid});
String clubnamelink="<a href='/hub/clubview.jsp?GROUPID="+clubid+"'/>"+GenUtil.TruncateData(clubname,35)+"</a>";
if(custompurpose!=null){
		request.setAttribute("CustomLNF_Type","HubPage");
		request.setAttribute("CustomLNF_ID",clubid);
		if(clubname!=null)
			request.setAttribute("taskheader",clubnamelink);
}

request.setAttribute("tasktitle","Login Help");

%>
<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/loginproblems/loginsuccess.jsp";
%>
	      		
<%@ include file="/templates/taskpagebottom.jsp" %>
	

	