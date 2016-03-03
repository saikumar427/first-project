<%@ page import="com.eventbee.general.formatting.CurrencyFormat,com.eventbee.event.*,com.eventbee.event.ticketinfo.*,java.text.*,java.net.*" %>
<%@ page import="com.eventbee.editevent.*"%>
<%@ include file="/listreport/attributesresponses.jsp" %>
<%!
static String serveraddress="http://"+EbeeConstantsF.get("serveraddress","")+"/";
static void SetEventInfoToRequest(HttpServletRequest request,HttpSession session){
	String eventgroupid=request.getParameter("eventgroupid");
	if(eventgroupid==null)
	eventgroupid=(String)session.getAttribute("eventgroupid");
	if(eventgroupid!=null)
	session.setAttribute("eventgroupid",eventgroupid);
	String groupid=Presentation.GetRequestParam(request, new String []{"eid","eventid", "id","GROUPID"});
	String participantid=Presentation.GetRequestParam(request,  new String []{"pid","partnerid", "participantid","participant"});
	String friendid=request.getParameter("friendid");
	HashMap evtinfo=(HashMap)request.getAttribute("eventinfohm");
	HashMap confighm=(HashMap)request.getAttribute("confighm");
	request.setAttribute("EVENT_INFORMATION",evtinfo);
	request.setAttribute("EVENT_CONFIG_INFORMATION",confighm);
	HashMap user=(HashMap)request.getAttribute("userhm");
	String eventname="";
	String startdate="";
	String enddate="";
	String description="";
	String trackcode="";
	String trckcode="";
	String trackPartnerMessage=null;
	String trackPartnerPhoto="";
	String imgname="",caption=null;
	String status=EventPageContent.getTrackInfoForKey("status",request,"");
	if(evtinfo!=null){
	eventname=(String)evtinfo.get("eventname");
	session.setAttribute("evtname_"+groupid,eventname);
	startdate=(String)evtinfo.get("evt_start_date")+", "+(String)evtinfo.get("starttime");
	enddate=(String)evtinfo.get("evt_end_date")+", "+(String)evtinfo.get("endtime");
	String desctype=GenUtil.getHMvalue(evtinfo,"descriptiontype","");
	if("text".equalsIgnoreCase(desctype))
	description=GenUtil.textToHtml(GenUtil.getHMvalue(evtinfo,"description",""),true);
	else
	description=GenUtil.getHMvalue(evtinfo,"description","");
	
	String groupname="";
	String groupUrl="";
	if(eventgroupid!=null){
		groupname=DbUtil.getVal("select group_title from user_groupevents where event_groupid=? ",new String[]{eventgroupid});
		String participant=(participantid!=null)?participantid="&participantid="+participantid+"":"";
		String friendids=(friendid!=null)?friendid="&friendid="+friendid+"":"";
		groupUrl=serveraddress+"event?eid="+eventgroupid+participant+friendids;
	}

	request.setAttribute("EVENTNAME",eventname);
	request.setAttribute("STARDATE",startdate);
	request.setAttribute("ENDDATE",enddate);
	if("<br>".equals(description))
	description="";
	request.setAttribute("DESCRIPTION",description);
	
	if(!"".equals(groupUrl)){
	request.setAttribute("GROUPURL",groupUrl);
	request.setAttribute("GROUPNAME",groupname);
	}
	String photourl=EventPageContent.getConfigValue("event.eventphotoURL",request,"");
	if(photourl!=null&&!"".equals(photourl)){
	imgname="<img src='"+photourl+"'>";

	}
 else{
	photourl=EventPageContent.getEventInfoForKey("photourl",request,"");
	
	if(photourl!=null&&!"".equals(photourl)){
	String GET_EVENT_PHOTO="select caption from"
	   +" member_photos  where uploadurl=?";
	caption=DbUtil.getVal(GET_EVENT_PHOTO,new String[]{photourl});
	imgname="<img src='"+EbeeConstantsF.get("big.photo.image.webpath","")+"/"+photourl+"' />";
	}
			
	}
	trckcode=(String)session.getAttribute("trckcode");	
	trackcode=(String)session.getAttribute((String)evtinfo.get("eventid")+"_"+trckcode);
	if(trackcode!=null&&!"Suspended".equals(status)){
		trackPartnerMessage=EventPageContent.getTrackInfoForKey("message",request,"");
		trackPartnerPhoto=EventPageContent.getTrackInfoForKey("photo",request,"");
	}
	if(trackPartnerMessage==null||"".equals(trackPartnerMessage))
	trackPartnerMessage=EventPageContent.getConfigValue("eventpage.logo.message",request,"");
	}
	if(trackPartnerPhoto==null||"".equals(trackPartnerPhoto))
	trackPartnerPhoto=EventPageContent.getConfigValue("eventpage.logo.url",request,"");
	if(trackPartnerPhoto!=null&&!"".equals(trackPartnerPhoto)){
	trackPartnerPhoto="<img src='"+trackPartnerPhoto+"' width='200'/>";
	}
	request.setAttribute("EVENTPHOTO",imgname);
	request.setAttribute("EVENTPHOTOCAPTION",caption);

	request.setAttribute("TRACKPHOTO",trackPartnerPhoto);
	request.setAttribute("TRACKMESSAGE",trackPartnerMessage);
	request.setAttribute("GROUPID",groupid);
	Vector notices=EventsContent.getAllNotices(groupid);
	request.setAttribute("NOTICES",notices);

}


public  static void EventPagelinks(HttpServletRequest request,HttpSession session,Authenticate authData,HashMap attribsMap){
	SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyyMMdd'T'HHmm'00'");
	SimpleDateFormat DATE_FORMATT = new SimpleDateFormat("HHmm");
	String eventid=(String)request.getAttribute("GROUPID");
	String location="";
	String eventname="";
	String description="";
	String sdate="";
	String edate="";
	String durationstr="";
	String desctype="";
	String textdesc="";
	desctype=EventPageContent.getEventInfoForKey("descriptiontype",request,"");
	if("text".equals(desctype))
	textdesc=EventPageContent.getEventInfoForKey("description",request,"");
	if(textdesc!=null)
		textdesc=textdesc;
		else
		textdesc="";
	String sd=EventPageContent.getEventInfoForKey("/startDay",request,"");
	String ed=EventPageContent.getEventInfoForKey("/endDay",request,"");
	String sm=EventPageContent.getEventInfoForKey("/startMonth",request,"");
	String em=EventPageContent.getEventInfoForKey("/endMonth",request,"");
	String eh=EventPageContent.getEventInfoForKey("/endHour",request,"");
	String sh=EventPageContent.getEventInfoForKey("/startHour",request,"");
	String ey=EventPageContent.getEventInfoForKey("/endYear",request,"");
	String sy=EventPageContent.getEventInfoForKey("/startYear",request,"");
	String emin=EventPageContent.getEventInfoForKey("/endMinute",request,"");
	String smin=EventPageContent.getEventInfoForKey("/startMinute",request,"");
	location=EventPageContent.getEventInfoForKey("city",request,"");
	location=java.net.URLEncoder.encode(location);
	eventname=EventPageContent.getEventInfoForKey("eventname",request,"");
	eventname=java.net.URLEncoder.encode(eventname);
	description=EventPageContent.getEventInfoForKey("description",request,"");
	Calendar calendar = new GregorianCalendar(Integer.parseInt(sy),
						Integer.parseInt(sm)-1,
						Integer.parseInt(sd),
						Integer.parseInt(sh),
						Integer.parseInt(smin));

	Calendar calendar1 = new GregorianCalendar(Integer.parseInt(ey),
						Integer.parseInt(em)-1,
						Integer.parseInt(ed),
						Integer.parseInt(eh),
						Integer.parseInt(emin));
	sdate=DATE_FORMAT.format(calendar.getTime());
	edate=DATE_FORMAT.format(calendar1.getTime());
	long differenceInMillis = calendar1.getTimeInMillis() - calendar.getTimeInMillis();
	long differenceInDays = differenceInMillis /(24*60*60*1000);
	long diffHours = differenceInMillis/(60*60*1000);
	long diffMins = differenceInMillis/(60*1000);
	diffMins=diffMins-diffHours*60;
	String hoursstr=""+diffHours;
	if(hoursstr.length()==1)hoursstr="0"+hoursstr;
	String minsstr=""+diffMins;
	if(minsstr.length()==1) minsstr="0"+minsstr;
	if(hoursstr.length()>2) hoursstr="99";
	durationstr=hoursstr+minsstr;
	String action1="",fromuserid="",appname="",role="",unitid="",email="",name="";
	if(authData!=null){
		 role=authData.getRoleName();
		 unitid=authData.getUnitID();
		 fromuserid=authData.getUserID();
		  email= authData.getEmail();
	 }
	 else{
		String entryid=(String)session.getAttribute("entryunitid");
		if(entryid!=null){
			if(!(entryid.equals(unitid))){
				}
		}
		else{
			session.setAttribute("entryunitid",unitid);
		}
	}
	String discountcode=request.getParameter("code");
	HashMap evtinfo=(HashMap)request.getAttribute("EVENT_INFORMATION");
	HashMap confighm=(HashMap)request.getAttribute("EVENT_CONFIG_INFORMATION");
	String groupid=(String)request.getAttribute("GROUPID");
	String particpant=request.getParameter("participant");
	String particpantid=Presentation.GetRequestParam(request,  new String []{"pid","partnerid", "participantid","participant"});
	String friendid=Presentation.GetRequestParam(request,  new String []{"fid","friendid"});
	String registerlink="";
	String rsvplink="";
	String rsvpbutton="";
	//String attendeelink=null;
	String registerform="";
	String creditcardlogos="";
	String registrationlink="";
	String oid=request.getParameter("oid");
	String platform=request.getParameter("platform");
        String domain=request.getParameter("domain");
         if("ning".equals(platform))
        registrationlink="/ningregister/register.jsp?eid="+groupid+"&oid="+oid+"&domain="+domain;
        else
        registrationlink="/event/register;jsessionid="+session.getId()+"?eid="+groupid+"&isnew=yes"+(particpantid!=null?"&participant="+particpantid:"")+(friendid!=null?"&friendid="+friendid:"")+(discountcode!=null?"&code="+discountcode:"");
	String subject=EventPageContent.getEventInfoForKey("eventname",request,"");
	String mgrid=EventPageContent.getEventInfoForKey("mgr_id",request,"");
	String company=EventPageContent.getEventInfoForKey("company",request,"");
	String hostedby=EventPageContent.getConfigValue("event.hostname",request,"");
	if(hostedby==null||"".equals(hostedby)){
	if(company!=null&&!"".equals(company))
	hostedby=company;
	else
	hostedby=EventPageContent.getEventInfoForKey("first_name",request,"")+" "+EventPageContent.getEventInfoForKey("last_name",request,"");
	}
	
	String listurl=serveraddress+"event?eid="+groupid;
	String msg="Hi,\n\n"+"I thought you might be interested in - "+subject+"\n"+"Here is the listing URL: "+listurl+"\n\n"+"Thanks";
	String contactMgrLink="<a  href=javascript:Show('contactmgr')>Hosted by "+hostedby+"</a>";
	contactMgrLink+=" <div id='contactmgr' style='display: none; margin: 10 5 10 5;'> " ;
	contactMgrLink+=" <form name='AttendeeForm'  id='AttendeeForm' action='/portal/emailprocess/emailtoevtmgr.jsp?UNITID=13579&id="+groupid+"&purpose=CONTACT_EVENT_MANAGER'  method='post' >" ;
	contactMgrLink+=" Your Email ID* :<br> " ;
	contactMgrLink+=" <input type='text' name='from_email' value=''  style='width: 200px;'><br><br>" ;
	contactMgrLink+=" Your Name* :  <br>" ;
	contactMgrLink+=" <input type='text' name='from_name' value=''  style='width: 200px;'><br><br> " ;
	contactMgrLink+=" Subject :<br> " ;
	contactMgrLink+=" <input type='text' name='subject' value='Re: "+subject+"' style='width: 200px;'><br><br> " ;
	contactMgrLink+=" Message :<br> " ;
	contactMgrLink+=" <textarea name='note' style='width: 210px; height: 75px;'></textarea><br><br> " ;
	contactMgrLink+=" <p align='center'> " ;
	contactMgrLink+=" <div id='captchamsgmgr' style='display: none; color:red' >Enter Correct Code</div> " ;
	contactMgrLink+="Enter the code as shown below:<div style='padding:5px;' valign='top' width='100%'><input type='text'   name='captchamgr'  value=''   valign='top'/>";
	contactMgrLink+="  <img  id='captchaidmgr'  alt='Captcha'  /></div><br><br>";
	contactMgrLink+="<input type='hidden' name='formnamemgr' value='AttendeeForm'/>";
	contactMgrLink+=" <input type='button' name='sendmgr' value='Send'  onClick=' return checkAttendeeForm()' /> " ;
	contactMgrLink+=" <input type='button' value='Cancel' onclick=javascript:Cancel('contactmgr'); />" ;
	contactMgrLink+=" </p>" ;
	contactMgrLink+=" </form> </div>";
	contactMgrLink+=" <div id='urmessage'></div>";
	String emailfriendLink="<a  href=javascript:Show('Invitation')>Email this to a friend</a>";
	emailfriendLink+=" <div id='Invitation' style='display: none; margin: 10 5 10 5;'> " ;
	emailfriendLink+=" <form name='invitationForm'  id='invitationForm' action='/portal/emailprocess/emailsend.jsp?UNITID=13579&id="+groupid+"&purpose=INVITE_FRIEND_TO_EVENT'  method='post' >" ;
	emailfriendLink+="<input type='hidden' name='url' value='"+listurl+"' />";
	emailfriendLink+=" To* :<br> ";
	emailfriendLink+=" <textarea id='toheader' name='toemails' style='width: 210px; height: 70px;'></textarea><br>(separate emails with commas) " ;
	emailfriendLink+=" <br><br> " ;
	emailfriendLink+=" Your Email ID* :<br> " ;
	emailfriendLink+=" <input type='text' name='fromemail' value='"+email+"'  style='width: 200px;'><br><br>" ;
	emailfriendLink+=" Your Name* :  <br>" ;
	emailfriendLink+=" <input type='text' name='fromname' value='"+name+"'  style='width: 200px;'><br><br> " ;
	emailfriendLink+=" Subject :<br> " ;
	emailfriendLink+=" <input type='text' name='subject' value='Fw: "+subject+"' style='width: 200px;'><br><br> " ;
	emailfriendLink+=" Message :<br> " ;
	emailfriendLink+=" <textarea name='personalmessage' style='width: 210px; height: 75px;'>"+msg+"</textarea><br><br> " ;
	emailfriendLink+=" <p align='center'> " ;
	emailfriendLink+=" <div id='captchamsg' style='display: none; color:red' >Enter Correct Code</div> " ;
	emailfriendLink+="Enter the code as shown below:<div style='padding:5px;' valign='top' width='100%'><input type='text'   name='captcha'  value=''   valign='top'/>";
	emailfriendLink+="  <img  id='captchaid'  alt='Captcha'  /></div><br><br>";
	emailfriendLink+="<input type='hidden' name='formname' value='invitationForm'/>";
	emailfriendLink+=" <input type='button' name='sendmsg' value='Send'  onClick=' return checkInvitationForm()' /> " ;
	emailfriendLink+=" <input type='button' value='Cancel' onclick=javascript:Cancel('Invitation'); />" ;
	emailfriendLink+=" </p>" ;
	emailfriendLink+=" </form> </div>";
	emailfriendLink+=" <div id='message'></div>";
	String  addCalendarLink="<a  href=javascript:Show('calendarlinks')>Add to my calendar</a>";
	addCalendarLink+=" <div id='calendarlinks' style='display: none; margin: 10 5 10 5;'> " ;
	addCalendarLink+=" <a href=javascript:popupwindow('"+EbeeConstantsF.get("vcal.webpath","/jboss32/server/default/deploy/home.war/vcal")+"/vcal_event_"+groupid+".ics','VCal','400','400') ><img src='"+request.getAttribute("resourcesAddress")+""+"/home/images/ical.png' alt='iCal'  border='0' /> iCal</a>";
	addCalendarLink+=" <br> " ;
	addCalendarLink+=" <a href='http://www.google.com/calendar/event?action=TEMPLATE&text="+eventname+"&dates="+sdate+"/"+edate+"&sprop=website:http://www.eventbee.com&details="+textdesc+"&location="+location+"&trp=true' target='_blank'><img src='"+request.getAttribute("resourcesAddress")+""+"/home/images/google.png' alt='Google'  border='0' /> Google</a>";
	addCalendarLink+=" <br> " ;
	addCalendarLink+=" <a href='http://calendar.yahoo.com/?v=60&DUR="+durationstr+"&TITLE="+eventname+"&ST="+sdate+"&ET="+edate+"&in_loc="+location+"&DESC="+textdesc+"' target='_blank'><img src='"+request.getAttribute("resourcesAddress")+""+"/home/images/yahoo.png' alt='Yahoo'  border='0' /> Yahoo!</a>";
	addCalendarLink+=" </div>";
	boolean registrationAllowed=("Yes".equalsIgnoreCase(GenUtil.getHMvalue(confighm,"event.poweredbyEB","no")));
	boolean isrsvpd=("Yes".equalsIgnoreCase(GenUtil.getHMvalue(confighm,"event.rsvp.enabled","no")));
	if(registrationAllowed){
	if("ning".equals(platform))
	registerform+="<form name='register' action='/ningregister/register.jsp?eid="+groupid+"' method='post' />";
	else
	registerform+="<form name='register' action='/event/register;jsessionid="+session.getId()+"?eid="+groupid+"' method='post' />";
	registerform+="<input type='hidden' name='GROUPID' value='"+groupid+"' />";
	registerform+="<input type='hidden' name='eventid' value='"+groupid+"' />";
	if("FB".equals(request.getParameter("context"))){
	registerform+="<input type='hidden' name='context' value='FB' />";
	}
	 if("ning".equals(platform)){
	registerform+="<input type='hidden' name='oid' value='"+oid+"'/>";
	registerform+="<input type='hidden' name='domain' value='"+domain+"'/>";
	 }
        registerform+="<input type='hidden' name='participant' value='"+particpantid+"'/>";
	registerform+="<input type='hidden' name='friendid' value='"+friendid+"'/>";
	if(discountcode!=null){
	registerform+="<input type='hidden' name='code' value='"+discountcode+"'/>";
	}
	if(!"".equals(request.getParameter("track"))&&request.getParameter("track")!=null)
	registerform+="<input type='hidden' name='track' value='"+request.getParameter("track")+"'/>";

	registerform+="<input type='hidden' name='newreq' value='yes'/>";
	registerform+="<input type='submit' name='submit' value='"+GenUtil.getHMvalue(confighm,"event.cnr","Register")+"'/>";
	registerform+="</form>";
	}
	if(registrationAllowed){
	registerlink+="<a href='"+registrationlink+"'>"+GenUtil.getHMvalue(confighm,"event.cnr","Register")+"</a>";
	creditcardlogos+="<a href='"+registrationlink+"'><img src='"+request.getAttribute("resourcesAddress")+""+"/home/images/eventbeecc.gif'  border='0'/></a>";
	//attendeelink="<a href='/guesttasks/viewattendeelist.jsp?GROUPID="+groupid+"'>Registered Attendee List</a>";
	}
	else{
	String rsvpevent=GenUtil.getHMvalue(confighm, "event.rsvp.enabled",null);
	isrsvpd=(rsvpevent!=null&&!"".equals(rsvpevent));
	if(isrsvpd){
	rsvplink="<a href='/portal/guesttasks/memberlogin.jsp?GROUPID="+groupid+"'/>RSVP</a>";
	rsvpbutton="<form action='/portal/guesttasks/memberlogin.jsp' method='post'>";
	rsvpbutton+="<input type='hidden' name='GROUPID' value='"+groupid+"' />";
	if("FB".equals(request.getParameter("context"))){
	rsvpbutton+="<input type='hidden' name='context' value='FB' />";
	}
	rsvpbutton+="<input type='submit' name='submit' value='RSVP'/>";
	rsvpbutton+="</form>";
	}
	//attendeelink="<a href='/sms/viewrsvpattendeelist.jsp?GROUPID="+groupid+"'>RSVP Attendee List</a>";
        }
	String evturl=DbUtil.getVal("select url from event_custom_urls where eventid=?",new String[]{groupid});
	if(evturl==null)
	evturl=listurl;
	String EventURL="<a href=javascript:Show('eventurl') >Event URL</a>";
	EventURL+="<div id='eventurl' style='display: none; align='right' width='200 'margin: 10 5 10 5;>";
	EventURL+="<textarea  cols='27' rows='2' onClick='this.select()'>"+evturl+"</textarea></div>";
	Vector attendeelist=new Vector();
	Map attendeelistmap=null;
	HashMap countmap=new HashMap();
	String attendeebyajax=EventPageContent.getConfigValue("loadattendee.byajax",request,"");
        String  showAttendeeList=null;
	if(("Yes".equalsIgnoreCase(GenUtil.getHMvalue(confighm,"eventpage.attendee.show","no")))){
	showAttendeeList="Yes";
	}
	attribsMap.put("showAttendeeList",showAttendeeList);
	if(isrsvpd)
		attribsMap.put("isRsvpEvent","Yes");
	else if(registrationAllowed)
		attribsMap.put("isTicketingEvent","Yes");
	attribsMap.put("hostedBy",hostedby);
	attribsMap.put("city",(String)evtinfo.get("city"));
	attribsMap.put("venue",(String)evtinfo.get("venue"));
	attribsMap.put("address1",(String)evtinfo.get("address1"));
	attribsMap.put("address2",(String)evtinfo.get("address2"));
	attribsMap.put("state",(String)evtinfo.get("state"));
	attribsMap.put("country",(String)evtinfo.get("country"));
	String desc_start_date=(String)request.getAttribute("STARDATE");
	String desc_end_date=(String)request.getAttribute("ENDDATE");
	try{
		String[] st_temp=desc_start_date.split(",");
		String[] st_dd_format  =st_temp[1].split(" ");
		attribsMap.put("metaStartDate",st_dd_format[2]+" "+st_dd_format[1]+""+st_temp[2]+","+st_temp[3]);
		String[] end_temp=desc_end_date.split(",");
		String[] end_dd_format  =end_temp[1].split(" ");
		attribsMap.put("metaEndDate",end_dd_format[2]+" "+end_dd_format[1]+""+end_temp[2]+","+end_temp[3]);
		}catch(Exception e){
	}
	request.setAttribute("RSVPLINK",rsvplink);
	request.setAttribute("RSVPBUTTON",rsvpbutton);
	request.setAttribute("REGISTRSATIONALLOWED",registrationAllowed+"");
	request.setAttribute("RSVPALLOWED",isrsvpd+"");
	request.setAttribute("EMAILTOFRIENDLINK",emailfriendLink);
	request.setAttribute("ADDCALENDARLINK",addCalendarLink);
	request.setAttribute("REGISTRATIONLINK",registerlink);
	request.setAttribute("REGISTRATIONFORM",registerform);
	request.setAttribute("CONTACTMGRLINK",contactMgrLink);
	request.setAttribute("CREDITCARDLOGOS",creditcardlogos);
	request.setAttribute("EVENTURL",EventURL);
}

public static void setGoogleMapForEventPage(HttpServletRequest request,HttpSession session){

	HashMap evtinfo=(HashMap)request.getAttribute("EVENT_INFORMATION");
	HashMap confighm=(HashMap)request.getAttribute("EVENT_CONFIG_INFORMATION");
	String GOOGLEMAP="";
	String mapstring="";
	String venue="";
	String [] address_arr=null;
	List addressList=new ArrayList();
	String groupid=Presentation.GetRequestParam(request,  new String []{"eid","eventid", "id","GROUPID","groupid","gid"});
	if(evtinfo!=null&&confighm!=null){
	String gmstring="";
	String mstr="";
	String city=(String)evtinfo.get("city");
	String state=(String)evtinfo.get("state");
	String country=(String)evtinfo.get("country");
	String gmappref=EventPageContent.getConfigValue("eventpage.map.show",request,"");
	venue=EventPageContent.getEventInfoForKey("venue",request,"");
	if("Yes".equals(gmappref)){
		String lon=GenUtil.getHMvalue(evtinfo,"longitude",null);
		String lat=GenUtil.getHMvalue(evtinfo,"latitude",null);
	
		if((lon!=null&&(!"".equals(lon.trim())))&&(lat!=null&&(!"".equals(lat.trim())))){
		  GOOGLEMAP="<iframe src='"+serveraddress+"portal/customevents/googlemap_js.jsp?lon="+lon+"&lat="+lat+"'  frameborder='0' height='260' width='260' marginheight='0' marginwidth='0' name='googlemap' scrolling='no'    ></iframe>";
		}
	}
	String address2=GenUtil.getHMvalue(evtinfo,"address2",null);
	String address1=GenUtil.getHMvalue(evtinfo,"address1",null);
	String address=GenUtil.getCSVData(new String[]{city,state,country});
	if(venue!=null&&(venue.trim()).length()>0)
	addressList.add(venue);
	if(address1!=null&&(address1.trim()).length()>0)
	addressList.add(address1);
	if(address2!=null&&(address2.trim()).length()>0)
	addressList.add(address2);
	if(address!=null&&(address.trim()).length()>0)
	addressList.add(address);
	if(!GOOGLEMAP.equals("")){
	if(address2.equals("")){
	mstr=address1+"+"+city+"+"+state+"+"+country;
	}
	else{
	mstr=address1+"+"+address2+"+"+city+"+"+state+"+"+country;
	}
	mstr=URLEncoder.encode(mstr);
	gmstring="http://maps.google.com/maps?q="+mstr;
	mapstring="<a href="+gmstring+"> Map and driving directions</a>";
	session.setAttribute("mapstring",mapstring);
	request.setAttribute("GOOGLEMAP",GOOGLEMAP);//googlemap
	request.setAttribute("mapstring",mapstring);//whole googlemap
	}
	address_arr=(String [])addressList.toArray(new String [0]);
	
	request.setAttribute("FULLADDRESS",address_arr);
	
	}
	
	

}
public static void setAgentDetails(HttpServletRequest request,HttpSession session,String platform){
		String groupid=Presentation.GetRequestParam(request, new String []{"eid","eventid", "id","GROUPID"});
		String participantid=Presentation.GetRequestParam(request,  new String []{"pid","partnerid", "participantid","participant"});
		String event_link=null;
		String isf2fenabled=DbUtil.getVal("select enablenetworkticketing from group_agent_settings where groupid=? ",new String [] {groupid});
		String commission="";
		if (participantid!=null)
		event_link="<a href="+serveraddress+"event?eid="+groupid+" >"+"Visit Main Event Page"+"</a>";
		request.setAttribute("EVENTLINK",event_link);
		if("Yes".equalsIgnoreCase(isf2fenabled)){
		commission=DbUtil.getVal("select max(networkcommission) from price where evt_id=?",new String[]{groupid});
		commission="$"+commission;
		request.setAttribute("NETWORKTICKETENABLE","yes");
		if(commission!=null)
		request.setAttribute("COMMISSION",commission);
		}
		String networkticketmsg="";
		networkticketmsg+="<table width='100%' id='ntsbox' ><tr><td colspan='2'> Publish this event on your Facebook Profile, Website or Blog, and get paid up to "+commission+" per each ticket"
		+" sale. Powered by Eventbee Network Ticket Selling.</td></tr>";
		if("ning".equals(platform)){
		networkticketmsg=networkticketmsg+" <tr><td width='50%'>»  Add Eventbee Partner Network Application</td></tr></table>";
		}
		else	{
		networkticketmsg=networkticketmsg +" <tr><td width='50%'>»  <a href='"+serveraddress+"participate.jsp?eid="+groupid+"' >"+EbeeConstantsF.get("eventpage.networkselling.participation.link","Participate")+"</a> </td>";
		networkticketmsg=networkticketmsg+" <td width='50%'>»   <a href='http://www.eventbee.com/portal/helplinks/partnernetwork.jsp' target='_blank'>Learn More</a></td></tr></table>";
		}
		request.setAttribute("NETWORKSELLINGBLOCK",networkticketmsg);
	
	}


public static void SetCustomHeader(HttpServletRequest request)
{
	String header="";
	String footer=null;
	String groupid=(String)request.getAttribute("GROUPID");
	DBManager dbmanager=new DBManager();
	StatusObj statobj=dbmanager.executeSelectQuery("select * from configure_looknfeel where refid=? and idtype=? ",new String []{groupid,"eventdetails"});
	if(statobj.getStatus()){
	header=dbmanager.getValue(0,"headerhtml",null);
	footer=dbmanager.getValue(0,"footerhtml",null);
	if("Default".equals(header))header="";
	}
	String preview=request.getParameter("preview");
	if("eventdetails".equalsIgnoreCase(preview))
	{
	request.setAttribute("BASIC_EVENT_HEADER",request.getParameter("headerhtml"));
	request.setAttribute("BASICEVENTFOOTER",request.getParameter("footerhtml"));
	}else{
	if(header!=null )
	request.setAttribute("BASIC_EVENT_HEADER",header);
	if(footer!=null && !"".equals(footer) && !"Default".equals(footer))
	request.setAttribute("BASICEVENTFOOTER",footer);
	}
 }



%>