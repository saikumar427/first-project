<%


request.setAttribute("mtype","My Console");
request.setAttribute("stype","Community");
//request.setAttribute("subtabtype","Communities");
request.setAttribute("layout", "EE");

%>

<%@ include file="/templates/beeletspagetop.jsp" %>

<%

	com.eventbee.web.presentation.beans.BeeletItem item;
	 
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("PartnerContentBeelet");
	item.setResource("/customconfig/logic/CustomContentBeelet.jsp?portletid=COMMUNITY_PAGE&forgroup=13579");
	leftItems.add(item);      

    
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("defhub");
	item.setResource("/club/defaulthub.jsp");
	leftItems.add(item);
	item= new com.eventbee.web.presentation.beans.BeeletItem();
		item.setBeeletId("moderator");
		item.setResource("/club/moderatorhubs.jsp");
	leftItems.add(item);
	
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("member");
	item.setResource("/club/memberhubs.jsp");
	rightItems.add(item);
	%>
	      		
	<%@ include file="/templates/beeletspagebottom.jsp" %>
	

	
	
	
	
	
	
	
	