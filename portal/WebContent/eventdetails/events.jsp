<%
String evttype=request.getParameter("evttype");
if(evttype==null||"".equals(evttype))
	evttype="event";
request.setAttribute("tabtype",evttype);

%>

<%@ include file="/templates/beeletspagetop.jsp" %>

<%

	com.eventbee.web.presentation.beans.BeeletItem item;       
   
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("eventscategories");
	item.setResource("/eventdetails/eventscategories.jsp");
	leftItems.add(item);
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("premiumevents");
	item.setResource("/eventdetails/premiumevents.jsp");
	leftItems.add(item);
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("contentbeelet1");
	item.setResource("/customconfig/logic/CustomContentBeelet.jsp?portletid=AD1_"+evttype.toUpperCase()+"_MAIN&forgroup=13579&customborder=portalback");
	leftItems.add(item);
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("contentbeelet1D");
	item.setResource("/customconfig/logic/CustomContentBeelet.jsp?guestpage=y&portletid=EBEE_GUEST_EVENTS_C1D&forgroup=13579&customborder=portalback");
	leftItems.add(item);
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("contentbeelet1E");
	item.setResource("/customconfig/logic/CustomContentBeelet.jsp?guestpage=y&portletid=EBEE_GUEST_EVENTS_C1E&forgroup=13579&customborder=portalback");
	leftItems.add(item);
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("listevent");
	item.setResource("/eventdetails/listevent.jsp");
	rightItems.add(item);
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("contentbeelet");
	item.setResource("/customconfig/logic/CustomContentBeelet.jsp?portletid=AD_"+evttype.toUpperCase()+"_MAIN&forgroup=13579&customborder=portalback");
	rightItems.add(item);
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("gcontentbeelet");
	item.setResource("/customconfig/logic/CustomContentBeelet.jsp?portletid=G_AD_"+evttype.toUpperCase()+"_MAIN&forgroup=13579&customborder=portalback");
	rightItems.add(item);
	
	
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("ContentBeelet2D");
	item.setResource("/customconfig/logic/CustomContentBeelet.jsp?guestpage=y&portletid=EBEE_GUEST_EVENTS_C2D&forgroup=13579&customborder=portalback");
	rightItems.add(item);
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("ContentBeelet2E");
	item.setResource("/customconfig/logic/CustomContentBeelet.jsp?guestpage=y&portletid=EBEE_GUEST_EVENTS_C2E&forgroup=13579&customborder=portalback");

	rightItems.add(item);
	
%>
      		
<%@ include file="/templates/beeletspagebottom.jsp" %>

