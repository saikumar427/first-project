<%@ page import="com.eventbee.event.*"%>
<%@ page import="com.eventbee.authentication.*"%>
<%@ page import="com.eventbee.survey.*"%>
<%@ page import="com.eventbee.general.formatting.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="java.util.*"%>
<%
EventRegisterBean jBean= (EventRegisterBean)session.getAttribute("regEventBean");
String command=request.getParameter("submit");
if(jBean!=null){
	if("none".equals(request.getParameter("/selectedLogin"))){
		response.sendRedirect("/guesttasks/personalInfo.jsp?GROUPID="+jBean.getEventId());
	}else{
		session.setAttribute("regerrors",null);
		jBean.setSelectedLogin("");
		jBean.getEbeeLoginData().setLoginName(request.getParameter("/ebeeLoginData/loginName"));
		jBean.getEbeeLoginData().setPassword(request.getParameter("/ebeeLoginData/password"));
		StatusObj sobj=jBean.validateEbeeLogin();
		
	if(!sobj.getStatus()){
		response.sendRedirect("/guesttasks/personalInfo.jsp?GROUPID="+jBean.getEventId());
	}else{
		session.setAttribute("regerrors",sobj.getData());
		response.sendRedirect("/guesttasks/eventbeelogin.jsp?GROUPID="+jBean.getEventId());
	}
}
}else{
	response.sendRedirect("/guesttasks/regerror.jsp?GROUPID="+jBean.getEventId());
}
%>
