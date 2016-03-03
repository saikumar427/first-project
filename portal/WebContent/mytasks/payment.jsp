<%@ page import="com.eventbee.general.*" %>

<%



request.setAttribute("ShowFbProfile","N");
String clubid=request.getParameter("GROUPID");
	String custompurpose=DbUtil.getVal("select 'yes' from layout_config where refid=? and idtype=? ",new String [] {clubid,"COMMUNITY_HUBID"});
	String clubname=DbUtil.getVal("select clubname from clubinfo where clubid=?",new String [] {clubid});
String clubnamelink="<a href='/hub/clubview.jsp?GROUPID="+clubid+"'/>"+GenUtil.TruncateData(clubname,35)+"</a>";
	
	

String securelink="<a href='javascript:popupwindow(\"/home/links/sslsecure.html\",\"Help\",\"600\",\"400\")'> <img src='/home/images/mastercard.gif'  border='0'/><img src='/home/images/visa.gif'  border='0'/><img src='/home/images/amex.gif'  border='0'/><img src='/home/images/sslsecure.gif'  border='0'/></a>";
HashMap partnerevtmap=(HashMap)session.getAttribute("NETWORK_EVENTLIST_ATTRIBS");
String listingpurpose="";
if(partnerevtmap!=null){
	listingpurpose=(String)partnerevtmap.get("listingpurpose");
	if((String)partnerevtmap.get("listingpartnerid")!=null){
		request.setAttribute("CustomLNF_Type","Community");
		request.setAttribute("CustomLNF_ID",(String)partnerevtmap.get("listingpartnerid"));
	}
}

if("eventlist".equals(request.getParameter("evttype"))){
	String evtlink="<a href='/mytasks/addevent.jsp?GROUPID="+request.getParameter("GROUPID")+"'>Event Details</a>";
	String listlink="<a href='/mytasks/evtlisttype.jsp?GROUPID="+request.getParameter("GROUPID")+"'>Listing Options</a>";
	
	
	 if("upgrade".equals(request.getParameter("listingpurpose"))){
	 String evtlistlink="<a href='/mytasks/newlisttype.jsp?GROUPID="+request.getParameter("GROUPID")+"'>Upgrade Event Listing</a>";
		request.setAttribute("tasktitle","Upgrade Event Listing > "+evtlistlink+" > Payment "+securelink);
		request.setAttribute("mtype","My Console");
			request.setAttribute("stype","Events");
          }
	
	else if("NETWORK_EVENT_LISTING".equals(listingpurpose)){
		String websitetitle=DbUtil.getVal("select title from group_partner where partnerid=? and status='Active'",new String[]{(String)partnerevtmap.get("listingpartnerid")});
		if(websitetitle==null||"".equals(websitetitle)) websitetitle="Network Event Listing";
		else if(websitetitle!=null)
			websitetitle=websitetitle+" Network Event Listing";
		String evtinfolink="<a href='/guesttasks/addevent.jsp?GROUPID="+request.getParameter("GROUPID")+"&partnerid="+(String)partnerevtmap.get("listingpartnerid")+"'>Event Information</a>";
		request.setAttribute("tasktitle",websitetitle+"  > "+evtinfolink+" > Payment "+securelink);
	}
	
	
	
	
	
	
	else{
		request.setAttribute("tasktitle","Add Event > "+evtlink+" > "+listlink+" > Payment "+securelink);
		request.setAttribute("mtype","My Console");
		request.setAttribute("stype","Events");
	}
}
else if("upgrade".equals(request.getParameter("type"))){
	request.setAttribute("tasktitle","Upgrade > Payment "+securelink);
	request.setAttribute("mtype","My Settings");
}




else if("netadv".equals(request.getParameter("evttype"))){
    String evtname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String [] {request.getParameter("GROUPID")});
    
    String eventnamelink="<a href='/mytasks/eventmanage.jsp?GROUPID="+request.getParameter("GROUPID")+"'>"+evtname+"</a>";
    String evtlink="<a href='/mytasks/advertisingtaskpage.jsp?GROUPID="+request.getParameter("GROUPID")+"'>Network Advertising </a>";
	
	request.setAttribute("tasktitle","Event Manage > "+eventnamelink+ " > "+evtlink+" > Payment "+securelink);
	
}


else if(custompurpose!=null){
		request.setAttribute("CustomLNF_Type","HubPage");
		request.setAttribute("CustomLNF_ID",clubid);
		request.setAttribute("tasktitle","Membership Details");
		if(clubname!=null)
		request.setAttribute("taskheader",clubnamelink);
}




%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/ccprocessing/payment.jsp";
	%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	

	