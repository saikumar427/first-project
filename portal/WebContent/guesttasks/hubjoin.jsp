<%@ page import="com.eventbee.general.DbUtil" %>
<%@ page import="com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.general.*" %>
<%
String clubid=request.getParameter("GROUPID");
String custompurpose=DbUtil.getVal("select 'yes' from layout_config where refid=? and idtype=? ",new String [] {clubid,"COMMUNITY_HUBID"});
String clubname=DbUtil.getVal("select clubname from clubinfo where clubid=?",new String[]{clubid});
String clubnamelink="<a href='/hub/clubview.jsp?GROUPID="+clubid+"'/>"+clubname+"</a>";

if(custompurpose!=null){			 
	request.setAttribute("CustomLNF_Type","HubPage");
	request.setAttribute("CustomLNF_ID",clubid);
	request.setAttribute("tasktitle","Join Community");
	if(clubname!=null)
	request.setAttribute("taskheader",clubnamelink);
}
%>


<%
//request.setAttribute("mtype","My Console");

%>
<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/hub/join.jsp";
%>
	    
	    
<%@ include file="/templates/taskpagebottom.jsp" %>
	