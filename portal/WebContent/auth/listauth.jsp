<%@ page import="java.util.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>
<jsp:include page="/stylesheets/CoreRequestMap.jsp" />
<% 

Authenticate authData=AuthUtil.getAuthData(pageContext);//(Authenticate)session.getAttribute(ContextConstants.AUTH_DATA_OBJ);

String purpose=request.getParameter("purpose");
String groupid=request.getParameter("groupid");
String message="";
String clubname="";
String customloginscreen=DbUtil.getVal("select value  from community_config_settings where clubid=? and key='LOGIN_PAGE_SHOW_EVENTBEE_SIGNUP'", new String [] {request.getParameter("GROUPID")});
String id=request.getParameter("id");
String url="";
	if("joinhub".equals(purpose)){
	    url="/guesttasks/hubjoin.jsp?GROUPID="+request.getParameter("GROUPID");
		message="desimembership.needed.message";
		clubname=DbUtil.getVal("select clubname from clubinfo where clubid=?",new String[]{request.getParameter("GROUPID")});
	}else if("memberrenewal".equals(purpose)){
		groupid=request.getParameter("GROUPID");
		url="/portal/guesttasks/renewMembership.jsp?GROUPID="+groupid;
	}

if ((url!="")&& (authData!=null)){
	response.sendRedirect(url);
	return;
}
HashMap hm=new HashMap();
hm.put("redirecturl",url);
session.setAttribute("BACK_PAGE",purpose);
session.setAttribute("REDIRECT_HASH",hm);
request.setAttribute("BACK_PAGE",purpose);
if("N".equals(customloginscreen)){
	

if("yes".equals(id)){
	    %>
      	<jsp:forward page='/guesttasks/custompersonalInfo.jsp' >
		<jsp:param name='isnew' value='yes' />
		<jsp:param name='entryunitid' value='13579' />
		<jsp:param name='UNITID' value='13579' />
		<jsp:param name='clubname' value='<%=clubname%>' />
		</jsp:forward>
<%}
else{
	%>
	<jsp:forward page='/guesttasks/customhublogin.jsp' >
		<jsp:param name='isnew' value='yes' />
		<jsp:param name='clubname' value='<%=clubname%>' />
		<jsp:param name='msgto' value='<%=request.getParameter("msgto")%>' />		
		</jsp:forward>
		
<%}
}else{
response.sendRedirect("/main/user/login");
}
%>