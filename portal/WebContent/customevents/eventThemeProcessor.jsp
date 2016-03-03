<%@ page import="java.io.*, java.util.*,java.util.regex.*,java.sql.*" %>
<%@ page import="org.apache.oro.text.regex.*" %>
<%@ page import="com.themes.*" %>
<%@ page import="com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="org.apache.velocity .*,org.apache.velocity.app.Velocity,org.apache.velocity.context.*,org.apache.velocity.exception.*,org.apache.velocity.app.*" %>
<%@ page import="com.eventbee.streamer.*"%>

<%!
String CLASS_NAME="customevents/eventThemeProcessor.jsp";



%>

<%--@ include file='eventscontent.jsp' --%>
<jsp:include page='/lifestyle/tnav.jsp' />

<%
String userid=request.getParameter("userid");
String groupid=request.getParameter("groupid");

session.removeAttribute(groupid+"_OldTranId");
			
String platform=(String)session.getAttribute("platform");
if(session.getAttribute("Custom_"+groupid)!=null){
session.removeAttribute("Custom_"+groupid);
}
	
session.removeAttribute("discountcode_"+groupid);	
	
if(session.getAttribute(groupid+"community_login")!=null){

session.removeAttribute(groupid+"community_login");

}
if(session.getAttribute("CouponContent_"+groupid)!=null){
session.removeAttribute("CouponContent_"+groupid);
}
   
if(session.getAttribute("MemCouponContent_"+groupid)!=null){
session.removeAttribute("MemCouponContent_"+groupid);
}
session.removeAttribute("discountcode");

EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"Entered","",null);


String THEMEDATAQUERY="select getThemeDataNew(CAST (? AS INTEGER),?,'css',?,?,?) as css, getThemeDataNew(CAST (? AS INTEGER),?,'themecontent',?,?,?) as themecontent";
String rollercontext=(application.getInitParameter("rollercontext")!=null)?application.getInitParameter("rollercontext"):"/roller";
String templatedata="";
String templatecss="";
String themetype=null;
String deftheme=null;
String [] themedata=null;
String thememodule=null;
String themeexist="yes";
String customcss="";
String google_traffic_monitor=(String)request.getAttribute("GOOGLE_TRAFIC_MONITOR");
String [] themeNameandType=ThemeController.getThemeCodeAndType("event%",groupid,"basic");
	themetype=themeNameandType[0];
	deftheme=themeNameandType[1];
	thememodule=themeNameandType[3];
	if(thememodule==null)
	 	thememodule="event"; 
	 	
	 	
	 	if("DEFAULT".equals(themetype)&&"event".equals(thememodule)){
			 themeexist=DbUtil.getVal("select 'yes' from ebee_roller_def_themes where themecode=? and module=?",new String[]{deftheme,"event"});
		        if(!"yes".equals(themeexist))
		        deftheme="basic";
        }


String partnerid=(String)session.getAttribute("Streamer_Partner");
if(partnerid==null)
 partnerid=EbeeConstantsF.get("networkadv.partner","3809");

boolean isnewsession=(session.getAttribute(groupid+"_partner_streamer_event")==null);

if(isnewsession)
{
session.setAttribute(groupid+"_partner_streamer_event","yes");
PartnerTracking pt=new PartnerTracking();
pt.setGroupId(groupid);
pt.setInsertionType("clicks");
pt.setPartnerId(partnerid);
pt.start();
}
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"deftheme====="+deftheme,"",null);
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"themetype====="+themetype,"",null);
		
		if("FB".equals(request.getParameter("context"))){
			if("DEFAULT".equals(themetype)){
				deftheme=DbUtil.getVal("select fbtheme  from facebook_ebee_themes where ebeetheme=?", new String []{deftheme});
				if(deftheme==null)
					deftheme="basic";
				themedata=ThemeController.getSelectedThemeData(userid,thememodule,deftheme,"event_fb",groupid,themetype);
			}else{
				themedata=ThemeController.getDefaultThemeData("basic","event_fb");
			}
			}
			
			
			
			else{
				themedata=ThemeController.getSelectedThemeData(userid,thememodule,deftheme,"event",groupid,themetype);
		}
		
		if("ning".equals(platform))
		themedata=ThemeController.getSelectedThemeData(userid,"event_ning",deftheme,"event_ning",groupid,themetype);
		
		
		customcss=themedata[0];
		templatedata=themedata[1];
		
		String oid=(String)session.getAttribute("ningoid");
		if(session.getAttribute("ning_style_"+oid)!=null)
		customcss=customcss+(String)session.getAttribute("ning_style_"+oid);
		
		
		customcss=customcss.replaceAll("/roller",rollercontext);
		customcss=customcss.replaceAll("\\$customappctx",rollercontext);
		
		
		

	//templatedata=templatedata.replaceAll("</head>",google_traffic_monitor+"</head>");
			templatedata="#macro( showAds $cont )"
			+"#if( $cont.equals(\"google\")  )"	
			+request.getAttribute("GEOOGLEADS")
			+" "
			+"#end"
			+"#if( $cont.equals(\"desihub\")  )"	
			+request.getAttribute("ADCONENTBEELET")
			+" "
			+"#end"
			+"#if( $cont.equals(\"yahoo\")  )"	
			+request.getAttribute("YAHOOADS")
			+" "
			+"#end"
			
			+"#end"
			+templatedata;


		try{
			VelocityContext context = new VelocityContext();
			
			
			System.out.println("velocity context sarting in event Theme Processor");
			
			context.put ("customcss",customcss  );	
			
			context.put ("eventbeeHeader",request.getAttribute("BASIC_EVENT_HEADER") );
			context.put ("eventbeeFooter",request.getAttribute("BASICEVENTFOOTER") );
                        context.put ("eventbeeheader",request.getAttribute("BASIC_EVENT_HEADER") );  //For backward compatibility
			context.put ("eventbeefooter",request.getAttribute("BASICEVENTFOOTER") );    //For backward compatibility
                        
			context.put ("eventName",request.getAttribute("EVENTNAME") );
			
			
			context.put ("creditcardLogos",request.getAttribute("CREDITCARDLOGOS") );
			context.put ("requiredTickets",request.getAttribute("REQUIREDTICKETS") );
			if("yes".equals(request.getAttribute("ONLYOPTTICKETS"))){
			context.put ("onlyOptionalTickets",request.getAttribute("ONLYOPTTICKETS") );
			context.put ("onlyoptinal",request.getAttribute("ONLYOPTTICKETS") );
			}
		        context.put ("optionalTickets",request.getAttribute("OPTIONALTICKETS") );
			context.put ("registerButton",request.getAttribute("REGISTRATIONFORM") );
			
			
			context.put ("startDate",request.getAttribute("STARDATE") );
			context.put ("endDate",request.getAttribute("ENDDATE") );
			context.put ("addCalendarLink",request.getAttribute("ADDCALENDARLINK") );
			
			context.put ("fullAddress",request.getAttribute("FULLADDRESS") );
			if(request.getAttribute("GOOGLEMAP")!=null){
			context.put ("googleMap",request.getAttribute("GOOGLEMAP") );
			context.put ("GOOGLEMAP",request.getAttribute("GOOGLEMAP") );  //For backward compatibility

			context.put ("mapString",request.getAttribute("mapstring") );
			context.put ("mapstring",request.getAttribute("mapstring") );  //For backward compatibility

                          }
			context.put ("description",request.getAttribute("DESCRIPTION") );
			context.put ("eventPhoto",request.getAttribute("EVENTPHOTO") );
			
			context.put ("trackPartnerMessage",request.getAttribute("TRACKMESSAGE") );
			context.put ("trackPartnerPhoto",request.getAttribute("TRACKPHOTO") );
			
			
			context.put ("networkTktEnabled",request.getAttribute("NETWORKTICKETENABLE"));
			context.put("networkSellingMsg",request.getAttribute("NETWORKSELLINGBLOCK"));
			 			
							
			if("true".equals((String)request.getAttribute("RSVPALLOWED"))){
			//context.put ("rsvpLink",request.getAttribute("RSVPLINK") );
			//context.put ("rsvpCount",request.getAttribute("RSVPCOUNT") );
			//context.put ("rsvpLimit",request.getAttribute("RSVPLIMIT") );
			context.put ("rsvpButton",request.getAttribute("RSVPBUTTON") );
			
			}
			
			context.put ("currencyFormat",request.getAttribute("CURRENCYFORMAT") );
			
			context.put ("eventListedBy",request.getAttribute("EVENTLISTEDBY") );
			context.put ("eventlink",request.getAttribute("EVENTLINK") );   //For backward compatibility
		        context.put ("eventLink",request.getAttribute("EVENTLINK") );	
		        context.put ("contactMgrlink",request.getAttribute("CONTACTMGRLINK") );
			context.put ("mgrEventsLink",request.getAttribute("MGREVENTSLINK") );
			context.put ("emailToFriendLink",request.getAttribute("EMAILTOFRIENDLINK") );
			//context.put ("eventPrintableVersionLink",request.getAttribute("EVENTPRINTABLEVERSIONLINK") ); 
			
			context.put ("viewAttendeeList",request.getAttribute("ATTENDEELIST") );
			context.put ("notices",request.getAttribute("NOTICES") );
			
			context.put ("partnerStreamer",request.getAttribute("PARTNERSTREAMER"));
			context.put ("partnerStreamerShow",request.getAttribute("PARTNERSTREAMERSHOW"));  
			context.put ("partnerstreamer",request.getAttribute("PARTNERSTREAMER"));          //For backward compatibility
			context.put ("partnerstreamershow",request.getAttribute("PARTNERSTREAMERSHOW"));   //For backward compatibility

			context.put ("groupUrl",request.getAttribute("GROUPURL"));          //For backward compatibility
			context.put ("groupName",request.getAttribute("GROUPNAME"));   //For backward compatibility
                        context.put ("eventURL",request.getAttribute("EVENTURL"));
			
			
	
	   //Unused tags  start
                   
                   
                   context.put ("userfullname",request.getAttribute("USERFULLNAME") );
		   context.put ("userName",request.getAttribute("USERFULLNAME") );
		   context.put ("userunitid",request.getAttribute("USERUNITID") );
		   context.put ("userfirstname",request.getAttribute("USERFIRSTNAME") );
		   context.put ("userlastname",request.getAttribute("USERLASTNAME"));
		   context.put ("profilename",request.getAttribute("USERPROFILENAME") );
		   context.put ("customappctx",rollercontext);
		   
		   
		   context.put ("featuresofunit",request.getAttribute("FEATURESOFUNIT") );
		   //context.put ("basicDesihubHeader",request.getAttribute("BASICEVENTHEA
		   context.put ("location",request.getAttribute("LOCATION") );
                   context.put ("managerEmail",request.getAttribute("MANAGEREMAIL") );
                   //context.put ("managerEmail",request.getAttribute("MANAGEREMAIL") );
                   context.put ("ticketHeader",request.getAttribute("TICKETHEADER") );
                   context.put ("moreInformation",request.getAttribute("MOREINFORMATION") );
                   context.put ("contentBeeletTitle",request.getAttribute("CONENTBEELETTITLE") );
                   
                   if("true".equals((String)request.getAttribute("REGISTRSATIONALLOWED")))
		   context.put ("registerLink",request.getAttribute("REGISTRATIONLINK") );
                   
                  context.put ("contentBeelet",request.getAttribute("CONENTBEELET") );
		  //context.put ("showAdsGoogle",request.getAttribute("GEOOGLEADS") ); 
                  context.put ("eventListedDate",request.getAttribute("EVENTLISTEDON") ); 
                  context.put ("headerLinks",request.getAttribute("DESINAVLINKS") ); 
                   
                  context.put ("loginLinks",request.getAttribute("DESISIGNUPLINKS") );
		  context.put ("pollName",request.getAttribute("POLLNAME") );
		  context.put ("pollDescription",request.getAttribute("POLLDESCRIPTION") );
		  context.put ("pollQuestion",request.getAttribute("POLLQUESTION") );
		  context.put ("pollChoices",request.getAttribute("POLLCHOICES") );
		  context.put ("startPollForm",request.getAttribute("STARTPOLLFORM") );
		  context.put ("endPollForm",request.getAttribute("ENDPOLLFORM") );
		  context.put ("pollResults",request.getAttribute("POLLRESULTS") );
		  context.put ("pollSubmit",request.getAttribute("POLLSUBMITFORM") ); 
                  context.put ("emailToFriendButton",request.getAttribute("EMAILTOFRIENDBUTTON") );
		  context.put ("eventPrintableVersionButton",request.getAttribute("EVENTPRINTABLEVERSIONBUTTON") );
                  
		  
                  //request.setAttribute("ADDBLOGLINK",addBlogLink);
		  context.put ("addBlogLink",request.getAttribute("ADDBLOGLINK") ); 
                  context.put ("ticketPrintableVersionButton",request.getAttribute("TICKETPRINTABLEVERSIONBUTTON") );
		  context.put ("ticketPrintableVersionLink",request.getAttribute("TICKETPRINTABLEVERSIONLINK") );
                  context.put ("eventPhotoCaption",request.getAttribute("EVENTPHOTOCAPTION") );
                  //context.put ("description",request.getAttribute("DESCRIPTION") );
                  context.put ("attendeeList",request.getAttribute("VIEWATTENDEELIST") );
		  //context.put ("headerLinks",request.getAttribute("DESINAVLINKS") );
		  context.put ("loginLinks",request.getAttribute("DESISIGNUPLINKS") );
                  
                  context.put ("lifestyleLinks",request.getAttribute("LIFESTYLENAVLINKS") );
		  //context.put ("eventDesiAd",request.getAttribute("ADCONENTBEELET") );
                  //context.put ("footerLinks",request.getAttribute("FOOTERLIST") );
                  //context.put ("poweredby",request.getAttribute("FOOTERPOWERDIMAGE") );
		  //context.put ("copyright",request.getAttribute("COPYRIGHT") );
		  
		  //context.put ("desifooter",request.getAttribute("FOOTER") );
                  //context.put ("footer",request.getAttribute("FOOTER") );
                  
                  context.put ("particpantName",request.getAttribute("PARTICPANTNAME") );
		  context.put ("particpantTitle",request.getAttribute("PARTICPANTTITLE") );
		  context.put ("particpantMessage",request.getAttribute("PARTICPANTMESSAGE") );
		  context.put ("particpantPhoto",request.getAttribute("PARTICPANTPHOTO") );
			
                  context.put ("selectFreindsOfEvents",request.getAttribute("FRIENDSTOEVENT") );
		  context.put ("f2fTagLine",request.getAttribute("F2FTAGLINE") );
		  context.put ("f2fImage",request.getAttribute("F2FIMAGE") );
		  context.put ("goalReachGraph",request.getAttribute("GOALREACHGRAPH") );

		  context.put ("display",request.getAttribute("DISPLAY") );
		  
		  context.put ("topSellers",request.getAttribute("EVENTTOPSELLERS") );
                  context.put ("sponsormessagebutton",request.getAttribute("SPONSORBUTTONMSG") );
		  //context.put ("sponsorheadermsg",request.getAttribute("SPONSORHEADERMSG") );
		
		  context.put ("sponsormessage",request.getAttribute("SPONSORMESSAGE") );
		  context.put ("attendephotourl",request.getAttribute("ATTENDEPHOTOURL") );
		  context.put ("sponsorrequestname",request.getAttribute("SPONSORREQUESTNAME") );
                  context.put ("requestforsponsor",request.getAttribute("REQUESTFORSPONSOR") );
                  context.put ("sponsormeform",request.getAttribute("SPONSORMEFORM"));
                  
                  
		  context.put ("main_event_link",request.getAttribute("MAINEVENTLINK"));
		  context.put ("networklink",request.getAttribute("NETWORKLINK"));
		  context.put ("Bloglink",request.getAttribute("BLOGLINK"));
		  context.put ("photoslink",request.getAttribute("PHOTOSLINK"));
		  context.put ("communitylink",request.getAttribute("COMMUNITYLINK"));
		  context.put ("eventslink",request.getAttribute("EVENTSLINK"));
		  context.put ("displayed",request.getAttribute("DISPLAYED") );
		  context.put ("agentInfo",request.getAttribute("AGENTINFO") );

                  context.put ("header",request.getAttribute("HEADERMSG") );
                  context.put ("sponsorheadermsg",request.getAttribute("SPONSORHEADERMSG") );
             
                  context.put ("agentcommission",request.getAttribute("COMMISSION"));
                  context.put("networksellingblock",request.getAttribute("NETWORKSELLINGBLOCK")); 
        
                   
                   
        //Unused tags  End
                
		//render the content here
	  	VelocityEngine ve= new VelocityEngine(); 
	  	System.out.println("before velocity Engine intialized");
			
	  	ve.init();boolean abletopares=ve.evaluate(context,out,"ebeetemplate", templatedata );

               	System.out.println("After velocity Engine intialized");
	       			
	  
	    }
	    catch(Exception exp){
	    	out.println(exp.getMessage());
	    
	    }
	
%>
