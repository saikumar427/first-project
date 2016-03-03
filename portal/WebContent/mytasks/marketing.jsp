<%

request.setAttribute("mtype","My Email Marketing");
request.setAttribute("layout", "CUSTOM");
//request.setAttribute("CUSTOM_LEFT_WIDTH", "425");
//request.setAttribute("CUSTOM_RIGHT_WIDTH", "405");
request.setAttribute("layout", "EE");

%>

<%@ include file="/templates/beeletspagetop.jsp" %>

<%

com.eventbee.web.presentation.beans.BeeletItem item;       


item= new com.eventbee.web.presentation.beans.BeeletItem();
item.setBeeletId("MarketingContentBeelet1");
item.setResource("/customconfig/logic/CustomContentBeelet.jsp?portletid=emailmarketinghelpcustom-1-all&forgroup=13579");
leftItems.add(item);


item= new com.eventbee.web.presentation.beans.BeeletItem();
item.setBeeletId("emailmarketing");
item.setResource("/emailmarketing/EmailCampaigns.jsp");
leftItems.add(item);

item= new com.eventbee.web.presentation.beans.BeeletItem();
item.setBeeletId("mailinglist");
item.setResource("/emailmarketing/MailLists.jsp");
leftItems.add(item);


item= new com.eventbee.web.presentation.beans.BeeletItem();
item.setBeeletId("buyquota");
item.setResource("/emailcamp/buyquotabeelet.jsp");
rightItems.add(item);


item= new com.eventbee.web.presentation.beans.BeeletItem();
item.setBeeletId("campaign");
item.setResource("/emailmarketing/CampaignDesigns.jsp");
rightItems.add(item);

	
	
	
	
	
	
	
	


	
%>
      		
<%@ include file="/templates/beeletspagebottom.jsp" %>

