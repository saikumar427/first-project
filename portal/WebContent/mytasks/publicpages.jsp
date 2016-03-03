<%


request.setAttribute("mtype","My Public Pages");
request.setAttribute("layout", "EE");

%>
<%@ include file="/templates/beeletspagetop.jsp" %>
<%


com.eventbee.web.presentation.beans.BeeletItem item;
	 
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("publicpagecontent");
	item.setResource("/customconfig/logic/CustomContentBeelet.jsp?portletid=MY_PUBLIC_PAGES&forgroup=13579");
	leftItems.add(item);    
	
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("EventsPage");
	item.setResource("/publicpages/Events.jsp");
	leftItems.add(item);
	
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("Networkpage");
	item.setResource("/publicpages/Networkpage.jsp");
	leftItems.add(item);
	
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("community");
	item.setResource("/publicpages/community.jsp");
	rightItems.add(item);
	
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("PhotoPage");
	item.setResource("/publicpages/photopage.jsp");
	rightItems.add(item);
	
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("Blogpage");
	item.setResource("/publicpages/blogpage.jsp");
	//rightItems.add(item);
	
	
	
	
%>


<%@ include file="/templates/beeletspagebottom.jsp" %>
