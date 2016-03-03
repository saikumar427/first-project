<%

request.setAttribute("mtype","Network Ticket Selling");
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
	item.setBeeletId("member");
	item.setResource("/eventbeeticket/myf2fpages.jsp");
	leftItems.add(item);


		
    	
       
    	item= new com.eventbee.web.presentation.beans.BeeletItem();
    	item.setBeeletId("partnerstreamer");
    	item.setResource("/eventpartner/partner.jsp");
    	rightItems.add(item);
    	
    	item= new com.eventbee.web.presentation.beans.BeeletItem();
    	item.setBeeletId("NetworkListing");
    	item.setResource("/networkeventlisting/networkeventlisting.jsp");
    	rightItems.add(item);
    	
    	item= new com.eventbee.web.presentation.beans.BeeletItem();
    	item.setBeeletId("MyEarnings");
    	item.setResource("/myearnings/myearnings.jsp");
    	rightItems.add(item);
    	
    	item= new com.eventbee.web.presentation.beans.BeeletItem();
	    	item.setBeeletId("Top Network Ticket Selling Events");
	    	item.setResource("/myearnings/topnetworksellingevents.jsp");
    	rightItems.add(item);
    	
    	
    	
    	%>
	      		
<%@ include file="/templates/beeletspagebottom.jsp" %>
	
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
	
