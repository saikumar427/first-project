<%@ page import="java.io.*, java.util.*,java.util.regex.*,java.sql.*" %>
<%@ page import="org.apache.oro.text.regex.*" %>
<%@ page import="com.themes.*" %>
<%@ page import="com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="org.apache.velocity.*,org.apache.velocity.app.Velocity,org.apache.velocity.context.*,org.apache.velocity.exception.*,org.apache.velocity.app.*" %>

<%!
String CLASS_NAME="customevents/previewAttendeeThemeProcessor.jsp";	
%>

<%
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"Entered","",null);

	String userunitid="13579";
	String userfirstname="";
	String userlastname="";
	String userfullname="";

String rollercontext=(application.getInitParameter("rollercontext")!=null)?application.getInitParameter("rollercontext"):"/roller";
Authenticate authData=AuthUtil.getAuthData(pageContext);

String templatedata="";
String customcss="";
String userid="-1";
String themeuserid="-1";

String themetype=(request.getParameter("themetype")!=null)?request.getParameter("themetype"):"";
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"themetype==="+themetype,"",null);

String deftheme=(request.getParameter("deftheme")!=null)?request.getParameter("deftheme"):"";
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"deftheme==="+deftheme,"",null);

String currenttheme=request.getParameter("currenttheme");
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"currenttheme==="+currenttheme,"",null);

String modulename=(request.getParameter("modulename")!=null)?request.getParameter("modulename"):"lifestyle";
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"modulename==="+modulename,"",null);

String contentname="Lifestyle Content";

String username="none";
	if(authData !=null){
		username=authData.getLoginName();
		userid=authData.getUserID();
		if(deftheme.equals(currenttheme) ){
			themeuserid=authData.getUserID();
		}
		
	}
request.setAttribute("username",username);
String fullusername=(request.getAttribute("fullusername")!=null)?(String)request.getAttribute("fullusername"):"";


String purpose=(String)request.getAttribute("purpose");

if(purpose==null){
purpose=request.getParameter("type");
}
request.setAttribute("purpose",purpose);
request.setAttribute("userid",userid);
%>

<jsp:include page='/lifestyle/tnav.jsp' />
<jsp:include page='attendeecontent.jsp' />


<%

	if(authData !=null){
		userunitid=authData.getUnitID();
		userfirstname=(authData.getFirstName()!=null)?authData.getFirstName().trim():"";
		userlastname=(authData.getLastName()!=null)?authData.getLastName().trim():"";
		userfullname=(userfirstname+userlastname).trim();
	}
	
	request.setAttribute("USERUNITID",userunitid);
	request.setAttribute("USERFIRSTNAME",userfirstname);
	request.setAttribute("USERLASTNAME",userlastname);
	request.setAttribute("USERFULLNAME",userfullname);

if(request.getParameter("forchange") !=null){	
	
	if(authData !=null){
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, CLASS_NAME, "logged in user preview", "currentthem="+currenttheme+"**type="+request.getParameter("type"), null);
	
		fullusername=(authData.getFirstName().trim()+" "+authData.getLastName().trim() ).trim();
		username=authData.getLoginName() ;
		request.setAttribute("fullusername", fullusername);
		request.setAttribute("username",authData.getLoginName() );
		purpose=request.getParameter("type");
		if(deftheme.equals(currenttheme) ){
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, CLASS_NAME, "logged in user with his current theme again", "currentthem="+currenttheme+"**type="+request.getParameter("type"), null);
			userid=authData.getUserID();			
		}
		
		
	}

}//end of for change ie login user preview




String previewlifestylecont="<table align='center' width='100%'><tr height='400'><td align='center'>"+contentname+"</td></tr> </table>";


String EVENTID=request.getParameter("GROUPID");
if(EVENTID==null||"".equals(EVENTID))
EVENTID=request.getParameter("eventid");
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, "lifestyle/previewthemeprocessornew.jsp", "userid="+userid+" purpose="+purpose+" deftheme=  "+deftheme , "**type="+request.getParameter("type"), null);

	
String [] themedata=ThemeController.getSelectedThemeData(themeuserid,purpose,deftheme,modulename,EVENTID,themetype);
customcss=themedata[0];
templatedata=themedata[1];
customcss=customcss.replaceAll("/roller",rollercontext);
customcss=customcss.replaceAll("\\$customappctx",rollercontext); 
   
        
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
			context.put ("eventbeeheader",request.getAttribute("BASIC_EVENT_HEADER") );
			context.put ("basicDesihubFooter",request.getAttribute("BASICEVENTFOOTER") );

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
			/*context.put ("pollName",request.getAttribute("POLLNAME") );
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
			context.put ("contactMgrlink",request.getAttribute("CONTACTMGRLINK") );
			context.put ("partnerstreamer",request.getAttribute("PARTNERSTREAMER"));
			context.put ("agentcommission",request.getAttribute("COMMISSION"));
			context.put ("networklink",request.getAttribute("NETWORKLINK"));
			context.put ("Bloglink",request.getAttribute("BLOGLINK"));
			context.put ("photoslink",request.getAttribute("PHOTOSLINK"));
			context.put ("communitylink",request.getAttribute("COMMUNITYLINK"));
			context.put ("eventslink",request.getAttribute("EVENTSLINK"));
			
			

		//render the content here
	  	VelocityEngine ve= new VelocityEngine(); ve.init();boolean abletopares=ve.evaluate(context,out,"ebeetemplate", templatedata );




	    }catch(Exception exp){
	    	out.println(exp.getMessage());

	    }
	
%>
