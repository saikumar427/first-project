<%
request.setAttribute("mtype","Network Ticket Selling");
request.setAttribute("stype","My Network Event Listing");
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
    	item.setBeeletId("partnerstreamer");
    	item.setResource("/ntspartner/nelparticipationbeelet.jsp");
    	rightItems.add(item);
    	
    	item= new com.eventbee.web.presentation.beans.BeeletItem();
    	item.setBeeletId("NetworkListing");
    	item.setResource("/ntspartner/nelpricingbeelet.jsp");
    	leftItems.add(item);
    	
    	;
    	
    	
    	
    	%>
	      		
<%@ include file="/templates/beeletspagebottom.jsp" %>
	