<%
request.setAttribute("layout", "NARROWWIDE");
%>

<%@ include file="/templates/beeletspagetop.jsp" %>

<%  String GROUPID=request.getParameter("GROUPID");
	String signupurl="/authentication/newsignup.jsp?PS=clubview&GROUPID="+GROUPID;	


	com.eventbee.web.presentation.beans.BeeletItem item;
	 
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("Login");
	item.setResource("/authentication/checklogin.jsp?PS=clubview&GROUPID="+GROUPID);
	leftItems.add(item);      

    	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("PassiveMemberLogin");
	item.setResource("/authentication/passivememberlogin.jsp?PS=clubview&GROUPID="+GROUPID);
	leftItems.add(item);
	
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("Signup");
	item.setResource(signupurl);
	rightItems.add(item);
	
	
		
	%>
	      		
	<%@ include file="/templates/beeletspagebottom.jsp" %>
	

	