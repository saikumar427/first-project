<%@ page import="java.util.*,com.eventbee.general.*,com.eventbee.authentication.*" %>

<%
String ningowner=request.getParameter("oid");
String ningviwer=request.getParameter("vid");
String ebeeid=DbUtil.getVal("select ebeeid from ebee_ning_link where nid=?",new String[]{ningowner});
String username=DbUtil.getVal("select login_name from authentication where user_id=?",new String[]{ebeeid});
request.setAttribute("username",username);
HashMap hm=(new  AuthDB()).getUserPreferenceInfo(username);

String userid=(String)hm.get("user_id");

HashMap hm1=(new AuthDB()).getUserInfoByUserID(userid);

String fullusername=DbUtil.getVal( "select getMemberName(?) as fullusername" ,new String[]{userid} );

request.setAttribute("userid",userid);
request.setAttribute("userhm",hm1    );
request.setAttribute("fullusername",fullusername);


String url="";
url="/customevents/eventspage.jsp?name="+username;
%>

<div STYLE="width:200px;   overflow: auto;">
<jsp:forward page="/customevents/eventspage.jsp" > 
<jsp:param name="platform" value="ning" />
<jsp:param name="ningviwer" value="<%=ningviwer%>" />

<jsp:param name="name" value="<%=username%>" />
</jsp:forward> 


</div>