<%
request.setAttribute("layout", "CUSTOM");
request.setAttribute("CUSTOM_LEFT_WIDTH", "510");
request.setAttribute("CUSTOM_RIGHT_WIDTH", "310");

%>


<%@ page import="com.eventbee.photos.*"%>
<%@ include file="/templates/beeletspagetop.jsp" %>

<%--jsp:include page='validphotolog.jsp' --%>
<%
PhotosDB photodb=new PhotosDB();
String photo_id=request.getParameter("photo_id");
        HashMap hm=new HashMap();
	hm=photodb.getPhotoInfo(photo_id);
 	request.setAttribute("photodetailshm",hm);
	com.eventbee.web.presentation.beans.BeeletItem item;       
   
        
   
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("photo");
	item.setResource("/photogallery/displayphoto.jsp");
	leftItems.add(item);
	
	
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
		item.setBeeletId("postcomment");
		item.setResource("/photogallery/postcomment.jsp");
		leftItems.add(item);
		
	
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("comments");
        item.setResource("/photogallery/photoComments.jsp");
	leftItems.add(item);
	
       item= new com.eventbee.web.presentation.beans.BeeletItem();
   	item.setBeeletId("postedby");
   	item.setResource("/photogallery/photopostedby.jsp");
	rightItems.add(item);
	

	
	
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
		item.setBeeletId("gcontentbeelet");
		item.setResource("/customconfig/logic/CustomContentBeelet.jsp?portletid=G_AD_PHOTOLOG_DETAILS&forgroup=13579&customborder=portalback");
		rightItems.add(item);
	



	
%>
      		
<%@ include file="/templates/beeletspagebottom.jsp" %>

