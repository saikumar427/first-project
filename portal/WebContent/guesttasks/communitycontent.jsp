<%@ include file="/templates/beeletspagetop.jsp" %>
<%
request.setAttribute("layout", "DEFAULT");
%>
<%

	com.eventbee.web.presentation.beans.BeeletItem item;
	 
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("ContentBeelet1");
	item.setResource("/customconfig/logic/CustomContentBeelet.jsp?portletid=EBEE_LOGIN_C1&forgroup=13579&customborder=portalback");
	leftItems.add(item);      

    item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("ContentBeelet1b");
	item.setResource("/customconfig/logic/CustomContentBeelet.jsp?portletid=EBEE_LOGIN_C1B&forgroup=13579&customborder=portalback");
	leftItems.add(item);
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("ContentBeelet1c");
	item.setResource("/customconfig/logic/CustomContentBeelet.jsp?portletid=EBEE_LOGIN_C1C&forgroup=13579&customborder=portalback");
	leftItems.add(item);
	
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("Login");
	item.setResource("/hub/login.jsp");
	rightItems.add(item);
	%>
	      		
	<%@ include file="/templates/beeletspagebottom.jsp" %>
	

	