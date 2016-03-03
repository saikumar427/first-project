<%@ page import="java.io.*, java.util.*,java.util.regex.*,java.sql.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.context.ContextConstants" %>
<%@ page import="org.apache.oro.text.regex.*" %>
<%@ page import="com.themes.*" %>
<%@ page import="java.util.*,com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="org.apache.velocity .*,org.apache.velocity.app.Velocity,org.apache.velocity.context.*,org.apache.velocity.exception.*,org.apache.velocity.app.*" %>
<%@ page import="com.eventbee.eventpartner.*" %>
<%@ include file="/mythemes/mythemesdb.jsp" %>

<%


	String userunitid="13579";
	String userfirstname="";
	String userlastname="";
	String userfullname="";
        String rollercontext=(application.getInitParameter("rollercontext")!=null)?application.getInitParameter("rollercontext"):"/roller";
	Authenticate authData=AuthUtil.getAuthData(pageContext);
        String templatedata="";
	String templatecss="";
        String userid="-1";
	String themeuserid="-1";
        String customcss="";
        String deftheme=(request.getParameter("deftheme")!=null)?request.getParameter("deftheme"):"";
	String currenttheme=request.getParameter("currenttheme");
	String modulename=(request.getParameter("modulename")!=null)?request.getParameter("modulename"):"network";
	String contentname="Lifestyle Content";
	String themetype=(request.getParameter("themetype")!=null)?request.getParameter("themetype"):"";
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

<jsp:include page='tnav.jsp' />
<jsp:include page='tcontent.jsp' />

<%

	if(authData !=null){
	userunitid=authData.getUnitID();
	userfirstname=(authData.getFirstName()!=null)?authData.getFirstName().trim():"";
	userlastname=(authData.getLastName()!=null)?authData.getLastName().trim():"";
	userfullname=(userfirstname+" "+userlastname).trim();

	}

	request.setAttribute("USERUNITID",userunitid);
	request.setAttribute("USERFIRSTNAME",userfirstname);
	request.setAttribute("USERLASTNAME",userlastname);
	request.setAttribute("USERFULLNAME",userfullname);
        if(request.getParameter("forchange") !=null){
        if(authData !=null){
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, "lifestyle/previewthemeprocessornew.jsp", "logged in user preview", "currentthem="+currenttheme+"**type="+request.getParameter("type"), null);

	fullusername=(authData.getFirstName().trim()+" "+authData.getLastName().trim() ).trim();
	username=authData.getLoginName() ;
	request.setAttribute("fullusername", fullusername);
	request.setAttribute("username",authData.getLoginName() );
	purpose=(String)request.getParameter("type");
	if(deftheme.equals(currenttheme) ){
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, "lifestyle/previewthemeprocessornew.jsp", "logged in user with his current theme again", "currentthem="+currenttheme+"**type="+request.getParameter("type"), null);
		String serveraddress="http://"+EbeeConstantsF.get("serveraddress","")+"/";
		userid=authData.getUserID();
		String partnerid=DbUtil.getVal("select partnerid from group_partner where userid=? and status='Active'",new String[]{userid});	
		Map attribmap=PartnerDB.getStreamingAttributes(userid,partnerid);
		%>

		<%@ include file="/customevents/userstreamer.jsp" %>
		<%request.setAttribute("PARTNERSTREAMER",partnerstreamer);
	}
		
		
	}

}//end of for change ie login user preview

EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, "lifestyle/previewthemeprocessornew.jsp", "userid="+userid+" purpose="+purpose+" deftheme=  "+deftheme , "**type="+request.getParameter("type"), null);
	
	String [] themedata=getPublicPageSelectedThemeData(themeuserid,purpose,deftheme,modulename,themetype);
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
			
			
			Map themeprefmap=PreferencesDB.getUserPref(userid,"themepage.snapshot.title");
			String pagetitle=  ((request.getAttribute("USERFIRSTNAME")!=null)?(String)request.getAttribute("USERFIRSTNAME"):"")        + "'s Network Page";
			String title1=request.getAttribute("USERFULLNAME")+"'s Lifestyle";
			if("yes".equals(request.getParameter("signup"))){
			pagetitle="My Snapshot";
			title1="My Lifestyle";
			}
			pagetitle=GenUtil.getHMvalue( themeprefmap , "themepage.snapshot.title",pagetitle);
			
			context.put ("lifestyletitle",title1);
			context.put ("pageTitle",pagetitle);
			
			context.put ("invitationhandler","" );
			context.put ("userfullname",request.getAttribute("USERFULLNAME") );
			context.put ("userName",request.getAttribute("USERFULLNAME") );
			context.put ("userunitid",request.getAttribute("USERUNITID") );
			context.put ("userfirstname",request.getAttribute("USERFIRSTNAME") );
			context.put ("userlastname",request.getAttribute("USERLASTNAME"));
			context.put ("firstName",request.getAttribute("USERFIRSTNAME") );
			context.put ("lastName",request.getAttribute("USERLASTNAME"));
		        context.put ("eventbeeheader",request.getAttribute("BASIC_EVENT_HEADER") );
			context.put ("basicDesihubFooter",request.getAttribute("BASICEVENTFOOTER") );
			context.put ("eventslink",request.getAttribute("EVENTSLINK"));
			context.put ("Bloglink",request.getAttribute("BLOGLINK"));
			context.put ("photoslink",request.getAttribute("PHOTOSLINK"));
			context.put ("communitylink",request.getAttribute("COMMUNITYLINK"));
		        context.put ("profilename",request.getAttribute("USERPROFILENAME") );
			context.put ("showAdsGoogle",request.getAttribute("GEOOGLEADS") );
			context.put ("customappctx",rollercontext);
			context.put ("customcss",customcss  );
			context.put ("publicProfileLink",ShortUrlPattern.get((String)request.getAttribute("USERPROFILENAME"))+"/network"  );
			context.put ("featuresofunit",request.getAttribute("FEATURESOFUNIT") );
			context.put ("lifestylephoto",request.getAttribute("LIFESTYLEPHOTO") );
			if("yes".equals(request.getParameter("signup")))
			context.put ("profilecontent","");
			else
			context.put ("profilecontent",request.getAttribute("PROFILECONTENT") );
			
			context.put ("classifieds",request.getAttribute("CLASSIFIEDLIST"));
			
			
			context.put ("listedevents",request.getAttribute("EVENTSLISTED") );
			context.put ("registeredevents",request.getAttribute("EVENTSREGISTERED") );
			context.put ("rsvpevents",request.getAttribute("RSVPDEVENTS") );
			
			
			context.put ("moderatedhubs",request.getAttribute("MODERATEDHUBS") );
			context.put ("memberinhubs",request.getAttribute("MEMBERHUBS") );
			context.put ("weblogs",request.getAttribute("WEBLOGLIST") );
			
			context.put ("pitch",request.getAttribute("PITCH") );
			
			context.put ("guestbooksignuplink",(request.getAttribute("GUESTBOOKSIGNUPLINK")!=null)?request.getAttribute("GUESTBOOKSIGNUPLINK"):"");
			context.put ("guestbookentries",request.getAttribute("GUESTBOOKLIST") );
			context.put ("friends",request.getAttribute("FRIENDSLIST") );
			
			context.put ("headerLinks",request.getAttribute("NAVLINKS") );
			context.put ("loginLinks",request.getAttribute("SIGNUPLINKS") );
			context.put ("lifestyleLinks",request.getAttribute("LIFESTYLENAVLINKS") );
			context.put ("footerLinks",request.getAttribute("FOOTERLIST") );
		        context.put ("poweredby",request.getAttribute("FOOTERPOWERDIMAGE") );
			context.put ("copyright",request.getAttribute("COPYRIGHT") );
			context.put ("desifooter",request.getAttribute("FOOTER") );
			context.put ("footer",request.getAttribute("FOOTER") );
			context.put ("partnerstreamer",request.getAttribute("PARTNERSTREAMER"));
			
				//render he contetn here
			 VelocityEngine ve= new VelocityEngine(); ve.init();boolean abletopares=ve.evaluate(context,out,"ebeetemplate", templatedata );




		    }catch(Exception exp){
			out.println(exp.getMessage());

		    }
	
%>

