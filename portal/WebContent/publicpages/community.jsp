<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.authentication.*" %>

<%
	String serveraddress=(String)session.getAttribute("HTTP_SERVER_ADDRESS");
	String userid="",username="";
	Authenticate authData=AuthUtil.getAuthData(pageContext);
	if(authData !=null){
	userid=authData.getUserID();
	username=authData.getLoginName();
	
	}
	String url=ShortUrlPattern.get(username)+"/community";
	
	String query="select clubid from clubinfo where lower(clublogo)=lower(?) and created_by='AUTOHUB'";
	String groupid = DbUtil.getVal(query,new String [] {username+"community"});
	
%>
	<div class='memberbeelet-header'>My Community Page </div>
	<table cellpadding="5" cellspacing="0" align="center" width="100%">
	<tr ><td  class='evenbase' valign='center'>URL:</td><td class='evenbase'>
	<textarea rows='2' cols='33' onClick='this.select()'><%=url%></textarea></td></tr>
	<tr><td  class='evenbase'  colspan='2'><a href='javascript:popupwindow("<%=url%>","<%="Community"%>","850","500");'>Preview</a></td></tr>
	<tr><td  class='evenbase'  colspan='2'><br/><b>Look And Feel</b></td></tr>
	<tr><td  class='evenbase'  colspan='2'><br/>Current Theme: <a href="/mytasks/gethubtheme.jsp?type=Community&GROUPID=<%=groupid%>&PS=PUBLICPAGES">View/Change</a></td></tr>
	<tr><td  class='evenbase'  colspan='2'><br/><a href='/mytasks/enterlnfinfo.jsp?type=COMMUNITY_HUBID&GROUPID=<%=groupid%>&PS=PUBLICPAGES'>Header/Footer Setting</a></td></tr>
	</table>
