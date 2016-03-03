<%@ page import="java.io.*, java.util.*,java.util.regex.*,java.sql.*" %>
<%@ page import="com.eventbee.authentication.*" %>
<%@ page import="org.apache.oro.text.regex.*" %>
<%@ page import="com.themes.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="org.apache.velocity .*,org.apache.velocity.app.Velocity,org.apache.velocity.context.*,org.apache.velocity.exception.*,org.apache.velocity.app.*" %>
<%!
String CLASS_NAME="customevents/attendeethemeprocessor.jsp";
%>

<%@ include file='attendeecontent.jsp' %> 

<jsp:include page='/lifestyle/tnav.jsp' />

<%
String authid="";
Authenticate authData=AuthUtil.getAuthData(pageContext);
	if (authData!=null){
		authid=authData.getUserID();
	}
	//if(authid==null)
	
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"authid======="+authid,"",null);
			
String templatedata="";
String templatecss="";
String themetype=null;
String deftheme=null;
String [] themedata=null;
String thememodule=null;
String themeexist="yes";
String customcss="";

String google_traffic_monitor=(String)request.getAttribute("GOOGLE_TRAFIC_MONITOR");

String rollercontext=(application.getInitParameter("rollercontext")!=null)?application.getInitParameter("rollercontext"):"/roller";
String EVENTID=request.getParameter("GROUPID");
if(EVENTID==null||"".equals(EVENTID))
	EVENTID=request.getParameter("eventid");
authid=DbUtil.getVal( "select mgr_id from eventinfo where eventid=?" ,new String[]{EVENTID} );	
String [] themeNameandType=ThemeController.getThemeCodeAndType("attendeepage%",groupid,"basic");
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
//String [] themeNameandType=ThemeController.getThemeCodeAndType("attendeepage",EVENTID,"basic");
//themetype=themeNameandType[0];
//deftheme=themeNameandType[1];
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"EVENTID======="+EVENTID,"",null);
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"themetype======="+themetype,"",null);
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"deftheme======="+deftheme,"",null);
if("FB".equals(request.getParameter("context"))){
			if("DEFAULT".equals(themetype)){
				deftheme=DbUtil.getVal("select fbtheme  from facebook_ebee_themes where ebeetheme=?", new String []{deftheme});
				if(deftheme==null)
					deftheme="basic";
				themedata=ThemeController.getSelectedThemeData(authid,thememodule,deftheme,"attendeepage_fb",EVENTID,themetype);
				

			}else{
				themedata=ThemeController.getDefaultThemeData("basic","attendeepage_fb");
			}
		}		
		else{
		themedata=ThemeController.getSelectedThemeData(authid,"attendeepage",deftheme,"attendeepage",EVENTID,themetype);
		}
//String [] themedata=ThemeController.getSelectedThemeData(authid,"attendeepage",deftheme,"attendeepage",EVENTID,themetype);
customcss=themedata[0];
templatedata=themedata[1];
customcss=customcss.replaceAll("/roller",rollercontext);
customcss=customcss.replaceAll("\\$customappctx",rollercontext);
	templatedata=templatedata.replaceAll("</head>",google_traffic_monitor+"</head>");
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
			context.put ("userfullname",request.getAttribute("USERFULLNAME") );
			context.put ("userName",request.getAttribute("USERFULLNAME") );
			context.put ("userunitid",request.getAttribute("USERUNITID") );
			context.put ("userfirstname",request.getAttribute("USERFIRSTNAME") );
			context.put ("userlastname",request.getAttribute("USERLASTNAME"));
			context.put ("profilename",request.getAttribute("USERPROFILENAME") );


			context.put ("customappctx",rollercontext);

			context.put ("customcss",customcss  );

       		context.put ("featuresofunit",request.getAttribute("FEATURESOFUNIT") );
			//context.put ("basicDesihubHeader",request.getAttribute("BASICEVENTHEADER") );
			 context.put ("eventbeefooter",request.getAttribute("BASICEVENTFOOTER") );
                        context.put ("eventbeeheader",request.getAttribute("BASIC_EVENT_HEADER") );
			
			context.put ("eventName",request.getAttribute("EVENTNAME") );
			context.put ("registerButton",request.getAttribute("REGISTRATIONFORM") );
			context.put ("startDate",request.getAttribute("STARDATE") );
			context.put ("endDate",request.getAttribute("ENDDATE") );
			context.put ("location",request.getAttribute("LOCATION") );
			context.put ("managerEmail",request.getAttribute("MANAGEREMAIL") );
			context.put ("description",request.getAttribute("DESCRIPTION") );
			context.put ("moreInformation",request.getAttribute("MOREINFORMATION") );
			context.put ("managerEmail",request.getAttribute("MANAGEREMAIL") );
			context.put ("description",request.getAttribute("DESCRIPTION") );
			context.put ("ticketHeader",request.getAttribute("TICKETHEADER") );
			context.put ("requiredTickets",request.getAttribute("REQUIREDTICKETS") );
			context.put ("optionalTickets",request.getAttribute("OPTIONALTICKETS") );
			context.put ("contentBeelet",request.getAttribute("CONENTBEELET") );
			//context.put ("eventDesiAd",request.getAttribute("ADCONENTBEELET") );
			//context.put ("showAdsGoogle",request.getAttribute("GEOOGLEADS") );
			context.put ("contentBeeletTitle",request.getAttribute("CONENTBEELETTITLE") );
			context.put ("notices",request.getAttribute("NOTICES") );  
			 context.put ("eventURL",request.getAttribute("EVENTURL"));
			
			
			if("true".equals((String)request.getAttribute("REGISTRSATIONALLOWED")))
			context.put ("registerLink",request.getAttribute("REGISTRATIONLINK") );
			if("true".equals((String)request.getAttribute("RSVPALLOWED"))){
			context.put ("rsvpLink",request.getAttribute("RSVPLINK") );
			context.put ("rsvpCount",request.getAttribute("RSVPCOUNT") );
			context.put ("rsvpLimit",request.getAttribute("RSVPLIMIT") );
			context.put ("rsvpButton",request.getAttribute("RSVPBUTTON") );
			}
			context.put ("eventListedDate",request.getAttribute("EVENTLISTEDON") );
			context.put ("eventListedBy",request.getAttribute("EVENTLISTEDBY") );
			context.put ("headerLinks",request.getAttribute("DESINAVLINKS") );
			context.put ("loginLinks",request.getAttribute("DESISIGNUPLINKS") );
			/*
			context.put ("pollName",request.getAttribute("POLLNAME") );
			context.put ("pollDescription",request.getAttribute("POLLDESCRIPTION") );
			context.put ("pollQuestion",request.getAttribute("POLLQUESTION") );
			context.put ("pollChoices",request.getAttribute("POLLCHOICES") );
			context.put ("startPollForm",request.getAttribute("STARTPOLLFORM") );
			context.put ("endPollForm",request.getAttribute("ENDPOLLFORM") );
			context.put ("pollResults",request.getAttribute("POLLRESULTS") );
			context.put ("pollSubmit",request.getAttribute("POLLSUBMITFORM") );
                        */
			context.put ("emailToFriendButton",request.getAttribute("EMAILTOFRIENDBUTTON") );
			context.put ("eventPrintableVersionButton",request.getAttribute("EVENTPRINTABLEVERSIONBUTTON") );
			context.put ("addCalendarButton",request.getAttribute("ADDCALENDARBUTTON") );

			context.put ("emailToFriendLink",request.getAttribute("EMAILTOFRIENDLINK") );
			context.put ("eventPrintableVersionLink",request.getAttribute("EVENTPRINTABLEVERSIONLINK") );
			context.put ("addCalendarLink",request.getAttribute("ADDCALENDARLINK") );


			context.put ("ticketPrintableVersionButton",request.getAttribute("TICKETPRINTABLEVERSIONBUTTON") );
			context.put ("ticketPrintableVersionLink",request.getAttribute("TICKETPRINTABLEVERSIONLINK") );
			context.put ("trackPartnerMessage",request.getAttribute("TRACKMESSAGE") );
			context.put ("trackPartnerPhoto",request.getAttribute("TRACKPHOTO") );
			
			context.put ("eventPhoto",request.getAttribute("EVENTPHOTO") );
			context.put ("eventPhotoCaption",request.getAttribute("EVENTPHOTOCAPTION") );
			context.put ("fullAddress",request.getAttribute("FULLADDRESS") );
			context.put ("attendeeList",request.getAttribute("VIEWATTENDEELIST") );
			context.put ("headerLinks",request.getAttribute("NAVLINKS") );
			context.put ("loginLinks",request.getAttribute("SIGNUPLINKS") );
			context.put ("lifestyleLinks",request.getAttribute("LIFESTYLENAVLINKS") );


			context.put ("footerLinks",request.getAttribute("FOOTERLIST") );
			context.put ("poweredby",request.getAttribute("FOOTERPOWERDIMAGE") );
			context.put ("copyright",request.getAttribute("COPYRIGHT") );
                        if("Yes".equals(request.getAttribute("SHOWATTENDEE")))    
			context.put ("viewAttendeeList",request.getAttribute("ATTENDEELIST") );

			context.put ("desifooter",request.getAttribute("FOOTER") );
			context.put ("footer",request.getAttribute("FOOTER") );
			context.put ("GOOGLEMAP",request.getAttribute("GOOGLEMAP") );
			context.put ("mapstring",request.getAttribute("mapstring") );
			
			context.put ("particpantName",request.getAttribute("PARTICPANTNAME") );
			context.put ("particpantTitle",request.getAttribute("PARTICPANTTITLE") );
       			context.put ("particpantMessage",request.getAttribute("PARTICPANTMESSAGE") );
			context.put ("particpantPhoto",request.getAttribute("PARTICPANTPHOTO") );
			context.put ("header",request.getAttribute("HEADERMSG") );
			context.put ("selectFreindsOfEvents",request.getAttribute("FRIENDSTOEVENT") );
			context.put ("f2fTagLine",request.getAttribute("F2FTAGLINE") );
			context.put ("f2fImage",request.getAttribute("F2FIMAGE") );
			context.put ("topSellers",request.getAttribute("EVENTTOPSELLERS") );
			context.put ("creditcardLogos",request.getAttribute("CREDITCARDLOGOS") );
			context.put ("mgrEventsLink",request.getAttribute("MGREVENTSLINK") );
			context.put ("networklink",request.getAttribute("NETWORKLINK"));
			context.put ("Bloglink",request.getAttribute("BLOGLINK"));
			context.put ("photoslink",request.getAttribute("PHOTOSLINK"));
			context.put ("communitylink",request.getAttribute("COMMUNITYLINK"));
			context.put ("eventslink",request.getAttribute("EVENTSLINK"));
			context.put ("contactMgrlink",request.getAttribute("CONTACTMGRLINK") );
			context.put ("partnerstreamer",request.getAttribute("PARTNERSTREAMER"));
			context.put ("contactMgrlink",request.getAttribute("CONTACTMGRLINK") );
			context.put ("agentcommission",request.getAttribute("COMMISSION"));
			
		//render the content here
	  	VelocityEngine ve= new VelocityEngine(); ve.init();boolean abletopares=ve.evaluate(context,out,"ebeetemplate", templatedata );


	    }catch(Exception exp){
	   	 EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, CLASS_NAME, "Exception at velocity", exp.getMessage(), exp ) ;
	    }
	
%>
