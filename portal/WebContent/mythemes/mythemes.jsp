<%

	request.setAttribute("subtabtype","MyThemes");
	request.setAttribute("layout", "EE");

%>

<%@ include file="/templates/beeletspagetop.jsp" %>

<%

	com.eventbee.web.presentation.beans.BeeletItem item;       
   
      
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("eventstheme");
	item.setResource("/customevents/mythemes.jsp?module=eventspage");
	leftItems.add(item);
	
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("networktheme");
	item.setResource("/mythemes/networkTheme.jsp?module=network");
	leftItems.add(item);
	
   
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("photostheme");
	item.setResource("/mythemes/photosTheme.jsp?module=photo");
	leftItems.add(item);
	
	 /*
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("blogtheme");
	item.setResource("/mythemes/blogsTheme.jsp?uname=");
	leftItems.add(item);*/
	
  
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("communitiestheme");
	item.setResource("/hub/mythemes.jsp?module=hubspage");
	leftItems.add(item);
	
	
	

	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("myeventsdetails");
	item.setResource("/mythemes/eventsDetails.jsp?module=event");
	rightItems.add(item);
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("hubdetails");
	item.setResource("/mythemes/communitytheme.jsp?module=hubpage");
	rightItems.add(item);
	
	
	
	
%>
      		
<%@ include file="/templates/beeletspagebottom.jsp" %>

