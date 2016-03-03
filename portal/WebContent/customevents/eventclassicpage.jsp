<%

try{
	
	VelocityContext vcontext = new VelocityContext();
	
	if(getCustomCssHtmlMap(groupid,request)==null){
		   request.getRequestDispatcher("eventpageloading.jsp").forward(request, response);
		   return ;
	}
	
	String 	customcss=(String)getCustomCssHtmlMap(groupid,request).get("customcss");
	customcss=customcss.replaceAll("\\$resourcesAddress", resourceaddress+"");
	customcss=customcss.replaceAll("url\\(/home", "url\\("+ resourceaddress+"/home");
	customcss=customcss.replaceAll("url\\(/main", "url\\("+ resourceaddress+"/main");
	customcss=customcss.replaceAll("url\\(\"/main", "url\\(\""+ resourceaddress+"/main");
	
	vcontext.put ("customcss",customcss);
	
	
	
	vcontext.put ("resourcesAddress", resourceaddress+"");
		vcontext.put ("eventbeeHeader", getEventHeader(groupid, request));
	vcontext.put ("eventbeeFooter",getEventFooter(groupid, request).replace("##resourceaddress##", resourceaddress) );
    vcontext.put ("eventbeeheader",getEventHeader(groupid, request));  //For backward compatibility
	vcontext.put ("eventbeefooter",getEventFooter(groupid, request).replace("##resourceaddress##", resourceaddress) );    //For backward compatibility
    vcontext.put ("eventName",getEventName(groupid));
	vcontext.put ("startDate",getStartDate(groupid) );
	vcontext.put ("endDate",getEndDate(groupid) );
	vcontext.put ("addCalendarLink",getCalanderLink(groupid).replace("##resourceaddress##", resourceaddress));
	vcontext.put ("fullAddress",getFullAddress(groupid) );
	String GoogleMap=getGoogleMap(groupid);
	if(!"".equals(GoogleMap)){
	vcontext.put ("googleMap",GoogleMap );
	vcontext.put ("GOOGLEMAP",GoogleMap );  //For backward compatibility
	vcontext.put ("mapString",getMapString(groupid) );
	vcontext.put ("mapstring",getMapString(groupid) );  //For backward compatibility
     }
	vcontext.put ("description",getEventDescription(groupid) );
	vcontext.put ("eventPhoto",getEventPhoto(groupid));
	HashMap trackmap=getTrackPartnerMap(groupid,trackshm,trackcode);
	vcontext.put ("trackPartnerMessage",trackmap.get("trackPartnerMessage") );
	vcontext.put ("trackPartnerPhoto",trackmap.get("trackPartnerPhoto") );
	vcontext.put ("contactMgrlink",getContactMgrLink(groupid).replace("##resourceaddress##", resourceaddress));
	vcontext.put ("emailToFriendLink",getEmailFriendLink(groupid) );
	vcontext.put ("notices",getNotices(groupid));
	
    vcontext.put ("eventURL",getEventURL(groupid));
    if("Yes".equalsIgnoreCase(isAttendeeShow(groupid)))
		vcontext.put ("showAttendeeList","Yes");
    if("Yes".equalsIgnoreCase(isAttendeeShow(groupid)) && "Yes".equalsIgnoreCase(isLoadAttendeeByAjax(groupid)))
    	vcontext.put("showAttendeesOnLoad"," <div id='attendeeinfo'></div>");
    vcontext.put ("city",getCity(groupid));
    vcontext.put ("venue",getVenue(groupid));
    vcontext.put ("metaStartDate",getMetaStartDate(groupid));
    vcontext.put ("metaEndDate",getMetaEndDate(groupid));
    vcontext.put("eid",groupid);
    if(isRSVP(groupid)){
    	vcontext.put("isRsvpEvent","Yes");
    	vcontext.put ("rsvpButton",getRsvpButton(groupid) );
    }
    
	else if(isTicketingEvent(groupid))
		vcontext.put("isTicketingEvent","Yes");
    if(isRecurring(groupid)){
    	vcontext.put("recurreningSelect",getRecurringSelect(groupid));
    	vcontext.put("recurringdateslabel",getRecurringDateLabels(groupid));
        if("Yes".equalsIgnoreCase(isAttendeeShow(groupid))){
        	vcontext.put("recurreningAttendeeSelect",getRecurringAttendeeSelect(groupid));
    	}	
    }
    vcontext.put("eventlevelHiddenAttribs",eventlevelHiddenAttribs.toString());
    vcontext.put("scriptTag",scriptTag.toString().replace("##resourceaddress##", resourceaddress).replace("##timestamp##", String.valueOf(d.getTime())));
    vcontext.put("fbShareButton",getFbShareButton(groupid));
    vcontext.put("fbLikeButton",getFbLikeButton(groupid));
    vcontext.put("twitterButton",getFbTwitterButton(groupid));
    if(!"".equals(getFbComment(groupid)))
    	vcontext.put("fbComment",getFbComment(groupid));
    if(!"".equals(getFbSendButton(groupid)))
    	vcontext.put("fbSendButton",getFbSendButton(groupid));
    if(!"".equals(getGooglePlusOne(groupid)))
    	vcontext.put("googlePlusOne",getGooglePlusOne(groupid));
    if(!"".equals(getFBRSVPList(groupid)))
    	vcontext.put("fbRSVPList",getFBRSVPList(groupid));
    if(!"".equals(getFbIBoughtButton(groupid)))
    	vcontext.put("fbIBought",getFbIBoughtButton(groupid));
    if(!"".equals(getSocialPromotions(groupid)))
    	vcontext.put("promotions",getSocialPromotions(groupid));
    
	 VelocityEngine ve= new VelocityEngine();
	 ve.init();
	 String tempalte=(String)getCustomCssHtmlMap(groupid, request).get("templatedata");
	boolean abletopares=ve.evaluate(vcontext,out,"ebeetemplate",  tempalte==null?"":tempalte);
}
catch(Exception exp){
	System.out.println("Exception In eventhandler.jsp eventid: "+groupid+" Error: "+exp.getMessage());
	exp.printStackTrace();
}
%>