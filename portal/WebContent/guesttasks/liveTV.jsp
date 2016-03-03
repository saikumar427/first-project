

<%
request.setAttribute("tabtype","more");
%>

<%@ include file="/templates/beeletspagetop.jsp" %>

<%
  com.eventbee.web.presentation.beans.BeeletItem item;       
   
    	item= new com.eventbee.web.presentation.beans.BeeletItem();
       	item.setBeeletId("LiveTVleftOne");
    	item.setResource("/customconfig/logic/CustomContentBeelet.jsp?portletid=LIVETV_LEFT_ONE&forgroup=13579");
    	leftItems.add(item);
    	
    	item= new com.eventbee.web.presentation.beans.BeeletItem();
    	item.setBeeletId("LiveTVleftTwo");
    	item.setResource("/customconfig/logic/CustomContentBeelet.jsp?portletid=LIVETV_LEFT_TWO&forgroup=13579");
    	leftItems.add(item);
    	
    	item= new com.eventbee.web.presentation.beans.BeeletItem();
    	item.setBeeletId("LiveTVrightOne");
    	item.setResource("/customconfig/logic/CustomContentBeelet.jsp?portletid=LIVETV_RIGHT_ONE&forgroup=13579");
    	rightItems.add(item);
    	
    	item= new com.eventbee.web.presentation.beans.BeeletItem();
    	item.setBeeletId("LiveTVrightTwo");
    	item.setResource("/customconfig/logic/CustomContentBeelet.jsp?portletid=LIVETV_RIGHT_TWO&forgroup=13579");
    	rightItems.add(item);
    	
    

%>
<%@ include file="/templates/beeletspagebottom.jsp" %>
