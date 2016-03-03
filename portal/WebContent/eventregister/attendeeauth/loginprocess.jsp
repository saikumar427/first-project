<%@ page import="com.eventbee.event.*"%>
<%@ page import="com.eventbee.authentication.*"%>
<%@ page import="com.eventbee.survey.*"%>
<%@ page import="com.eventbee.general.formatting.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="java.util.*"%>
<%  
  	     
EventRegisterBean jBean= (EventRegisterBean)session.getAttribute("regEventBean");

if(jBean!=null){
	
	session.setAttribute("regerrors",null);
	jBean.setSelectedLogin("");
	jBean.getEbeeLoginData().setLoginName(request.getParameter("uname"));
	jBean.getEbeeLoginData().setPassword(request.getParameter("upassword"));
	StatusObj sobj=jBean.validateEbeeLogin(session);

	if(!sobj.getStatus()){
		out.print("Success");
	}else{
		session.setAttribute("regerrors",sobj.getData());
		out.print("Failure");
	}
}

%>