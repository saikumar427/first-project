<%@ page import="com.eventbee.general.DbUtil" %>
<%@ page import="com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.general.*" %>



<%	

  String groupid=request.getParameter("GROUPID");
	
	
String custompurpose=DbUtil.getVal("select 'yes' from layout_config where refid=? and idtype=? ",new String [] {groupid,"COMMUNITY_HUBID"});
if(custompurpose!=null){			 
		request.setAttribute("CustomLNF_Type","HubPage");
		request.setAttribute("CustomLNF_ID",groupid);
		
	}	

%>




<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/club/unsubscribe.jsp";
	footerpage="/main/communityfootermain.jsp";
	
%>
	    
	    
<%@ include file="/templates/taskpagebottom.jsp" %>
	