<%@ page import="com.eventbee.general.DbUtil" %>
<%@ page import="com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.general.*" %>

<%
String clubid=request.getParameter("GROUPID");
String forumid=request.getParameter("forumid");
String clubname=DbUtil.getVal("select clubname from clubinfo where clubid=?",new String [] {clubid});
String groupid=request.getParameter("GROUPID");

String clubnamelink="<a href='/hub/clubview.jsp?GROUPID="+clubid+"'/>"+clubname+"</a>";
String custompurpose=DbUtil.getVal("select 'yes' from layout_config where refid=? and idtype=? ",new String [] {clubid,"COMMUNITY_HUBID"});
String forumname=DbUtil.getVal("select forumname from forum where forumid=? and groupid=?",new String []{forumid,clubid});
String  congigcluburl=DbUtil.getVal("select value from community_config_settings where key='Club_Site_Url' and clubid=? ",new String [] {clubid});
if(congigcluburl!=null)
 clubnamelink="<a href='"+congigcluburl+"'/>"+clubname+"</a>";  

if(custompurpose!=null){			 
	request.setAttribute("CustomLNF_Type","HubPage");
	request.setAttribute("CustomLNF_ID",clubid);
	request.setAttribute("tasktitle",clubnamelink+" > Payment");
	
}

%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/clubmembersignup/custompayment.jsp";
	footerpage="/main/communityfootermain.jsp";
%>
	      		
<%@ include file="/templates/taskpagebottom.jsp" %>
	

	
		