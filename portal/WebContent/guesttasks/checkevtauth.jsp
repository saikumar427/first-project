<%@ page import="com.eventbee.authentication.*,com.eventbee.general.*"%>

<%
String evtdetlink="<a href='/guesttasks/addevent.jsp?GROUPID="+request.getParameter("GROUPID")+"'>Event Details</a>";
request.setAttribute("tasktitle","Add Event > "+evtdetlink+" > Login");

Authenticate authData=AuthUtil.getAuthData(pageContext);
%>


<%@ include file="/templates/beeletspagetop.jsp" %>

<%
    String signupurl="/eventlistauth/newsignup.jsp";
    String error=request.getParameter("showerr");	
    if("y".equals(error))
	signupurl="/eventlistauth/newsignup.jsp?showerr=y";

	com.eventbee.web.presentation.beans.BeeletItem item;
	
       	if(authData ==null){

		item= new com.eventbee.web.presentation.beans.BeeletItem();
		item.setBeeletId("Signup");
		item.setResource(signupurl);
		leftItems.add(item);
		
		item= new com.eventbee.web.presentation.beans.BeeletItem();
		item.setBeeletId("Login");
		item.setResource("/eventlistauth/checklogin.jsp");
		rightItems.add(item);      
	}

	 
%>

<%@ include file="/templates/beeletspagebottom.jsp" %>
	

