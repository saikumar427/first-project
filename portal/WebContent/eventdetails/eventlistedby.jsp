<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.eventbee.event.EventDB" %>
<%
String groupid=null;
String rolename=null;
String mgrid=null;
String tempunitid=null;
HashMap contentData=(HashMap)session.getAttribute("groupinfo");
if(contentData!=null){
	groupid=(String)contentData.get("groupid");
	DBManager rolemanager=new DBManager();
	StatusObj rolestatobj=rolemanager.executeSelectQuery("select mgr_id,role,unitid from eventinfo where eventid="+groupid,null);
	if(rolestatobj !=null){
		rolename=rolemanager.getValue(0,"role","");
		mgrid=rolemanager.getValue(0,"mgr_id","");
		tempunitid=rolemanager.getValue(0,"unitid","");
	}
}		
if("Member".equalsIgnoreCase(rolename)){
	String linkname=DbUtil.getVal("select first_name||' '||last_name from user_profile where user_id=?",new String[]{mgrid});
	String linkurl="/portal/editprofiles/networkuserprofile.jsp?userid="+mgrid;
	%>      
	
	
	<div class='memberbeelet-header'>Listed By</div>
	<table class="portaltable" align="center" width="100%" cellspacing="0" cellpadding="0">
	<tr><td align='center'>
	<a href='<%=linkurl%>'><%=linkname%></a>
	</td></tr>					
	</table>
	<%
	
}
%>




    


