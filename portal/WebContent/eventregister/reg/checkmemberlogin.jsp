<%@ page import="com.eventbee.event.*"%>
<%
EventRegisterBean jBean=(EventRegisterBean)session.getAttribute("regEventBean");
if("Success".equals(jBean.getCommunityLoginStatus())){
out.println("<status>loggedin</status>");
}
else{

out.println("<status>nologin</status>");

}
%>


