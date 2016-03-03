<%@ page import="com.eventbee.general.*" %>

<%

HashMap partnerevtmap=(HashMap)session.getAttribute("PARTNER_EVENT_LISTING_ATTRIBS");
String listingpurpose="";
if(partnerevtmap!=null){
	listingpurpose=(String)partnerevtmap.get("listingpurpose");
	if((String)partnerevtmap.get("listingpartnerid")!=null){
		request.setAttribute("CustomLNF_Type","Community");
		request.setAttribute("CustomLNF_ID",(String)partnerevtmap.get("listingpartnerid"));
		String websitetitle=DbUtil.getVal("select title from group_partner where partnerid=? and status='Active'",new String[]{(String)partnerevtmap.get("listingpartnerid")});
		if(websitetitle==null||"".equals(websitetitle)) websitetitle="";
		else if(websitetitle!=null)
			websitetitle=websitetitle+" > ";
		String networkevtlink="<a href='/guesttasks/checkauthnetworkevtlist.jsp?partnerid="+(String)partnerevtmap.get("listingpartnerid")+"'>Network Event Listing</a>";
		request.setAttribute("tasktitle",websitetitle+networkevtlink+" > Event Information");
	
	}
}else{
request.setAttribute("mtype","My Console");
request.setAttribute("stype","Events");
request.setAttribute("tasktitle","Add Event > Event Details");

}

%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/createevent/addevent.jsp";
	%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	

	
		

	
	