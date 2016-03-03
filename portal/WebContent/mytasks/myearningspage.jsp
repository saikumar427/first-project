<%

request.setAttribute("mtype","Network Ticket Selling");
request.setAttribute("stype","My Earnings");

request.setAttribute("layout", "EE");

%>

<%@ include file="/templates/beeletspagetop.jsp" %>

<%

	com.eventbee.web.presentation.beans.BeeletItem item;       
   
    item= new com.eventbee.web.presentation.beans.BeeletItem();
    
    	item.setBeeletId("PartnerContentBeelet");
    	item.setResource("/customconfig/logic/CustomContentBeelet.jsp?portletid=EVENTBEE_PARTNER_NETWORK&forgroup=13579");
    	leftItems.add(item);
    	
    	
    	
    	item= new com.eventbee.web.presentation.beans.BeeletItem();
    	item.setBeeletId("Network Event Lisiting");
    	item.setResource("/ntspartner/nelearningsbeelet.jsp");
    	leftItems.add(item);
    	
    	item= new com.eventbee.web.presentation.beans.BeeletItem();
    	item.setBeeletId("Network Event Advertising");
    	item.setResource("/ntspartner/advearningsbeelet.jsp");
    	leftItems.add(item);
    	
    	item= new com.eventbee.web.presentation.beans.BeeletItem();
    	item.setBeeletId("MyEarnings");
    	item.setResource("/ntspartner/earningsummarybeelet.jsp");
    	rightItems.add(item);
    	
    	
    	
    	%>
	      		
<%@ include file="/templates/beeletspagebottom.jsp" %>
	