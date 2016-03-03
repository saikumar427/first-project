
<script>
PAGE_LINK="/portal/hub/clubsview.jsp?";
</script>


<%

request.setAttribute("tabtype","club");

%>

<%@ include file="/templates/beeletspagetop.jsp" %>

<%

	com.eventbee.web.presentation.beans.BeeletItem item; 	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("eventscategories");
	item.setResource("/hub/hubcatlist.jsp");
	leftItems.add(item);
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("recenthubposts");
	item.setResource("/hub/recenthubposts.jsp");
	leftItems.add(item);
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("contentbeelet1");
	item.setResource("/customconfig/logic/CustomContentBeelet.jsp?portletid=AD1_HUB_MAIN&forgroup=13579&customborder=portalback");
	leftItems.add(item);
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("contentbeelet1D");
	item.setResource("/customconfig/logic/CustomContentBeelet.jsp?guestpage=y&portletid=EBEE_GUEST_HUB_C1D&forgroup=13579&customborder=portalback");
	leftItems.add(item);
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("contentbeelet1E");
	item.setResource("/customconfig/logic/CustomContentBeelet.jsp?guestpage=y&portletid=EBEE_GUEST_HUB_C1E&forgroup=13579&customborder=portalback");
	leftItems.add(item);
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("listclub");
	item.setResource("/hub/listclub.jsp");
	rightItems.add(item);
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("contentbeelet");
	item.setResource("/customconfig/logic/CustomContentBeelet.jsp?guestpage=y&portletid=AD_HUB_MAIN&forgroup=13579&customborder=portalback");
	rightItems.add(item);
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("gcontentbeelet");
	item.setResource("/customconfig/logic/CustomContentBeelet.jsp?guestpage=y&portletid=G_AD_HUB_MAIN&forgroup=13579&customborder=portalback");
	rightItems.add(item);
	
	
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("ContentBeelet2D");
	item.setResource("/customconfig/logic/CustomContentBeelet.jsp?guestpage=y&portletid=EBEE_GUEST_HUB_C2D&forgroup=13579&customborder=portalback");
	rightItems.add(item);
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("ContentBeelet2E");
	item.setResource("/customconfig/logic/CustomContentBeelet.jsp?guestpage=y&portletid=EBEE_GUEST_HUB_C2E&forgroup=13579&customborder=portalback");

	rightItems.add(item);
	
%>
      		
<%@ include file="/templates/beeletspagebottom.jsp" %>

