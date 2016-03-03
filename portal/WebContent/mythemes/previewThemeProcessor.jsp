<%@ page import="java.io.*, java.util.*,java.util.regex.*,java.sql.*" %>
<%@ page import="com.eventbee.authentication.*" %>
<%@ page import="org.apache.oro.text.regex.*" %>
<%@ page import="com.themes.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="org.apache.velocity.*,org.apache.velocity.app.Velocity,org.apache.velocity.context.*,org.apache.velocity.exception.*,org.apache.velocity.app.*" %>
<%@ include file="/mythemes/mythemesdb.jsp" %>

<%!
String CLASS_NAME="/mythemes/previewThemeProcessor.jsp";

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
String deftheme=(request.getParameter("deftheme")!=null)?request.getParameter("deftheme"):"";
String currenttheme=request.getParameter("currenttheme");
String modulename=(request.getParameter("modulename")!=null)?request.getParameter("modulename"):"eventspage";
String username="none";
	if(authData !=null){
		username=authData.getLoginName();
		userid=authData.getUserID();
		if(deftheme.equals(currenttheme) ){
			themeuserid=authData.getUserID();
		}
		userunitid=authData.getUnitID();
		userfirstname=(authData.getFirstName()!=null)?authData.getFirstName().trim():"";
		userlastname=(authData.getLastName()!=null)?authData.getLastName().trim():"";
		userfullname=(userfirstname+userlastname).trim();
		
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
<jsp:include page='/customevents/eventspagecontent.jsp' />


<%
	request.setAttribute("USERUNITID",userunitid);
	request.setAttribute("USERFIRSTNAME",userfirstname);
	request.setAttribute("USERLASTNAME",userlastname);
	request.setAttribute("USERFULLNAME",userfullname);


EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, CLASS_NAME, "themeuserid="+themeuserid+" purpose="+purpose+" deftheme=  "+deftheme+" modulename=  "+modulename , "**type="+request.getParameter("type"), null);
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"themetype="+themetype,"",null);

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
			context.put ("userfullname",request.getAttribute("USERFULLNAME") );
			context.put ("userName",request.getAttribute("USERFULLNAME") );
			context.put ("userunitid",request.getAttribute("USERUNITID") );
			context.put ("userfirstname",request.getAttribute("FIRSTNAME") );
			context.put ("userlastname",request.getAttribute("USERLASTNAME"));
			context.put ("profilename",request.getAttribute("USERPROFILENAME") );
			context.put ("customappctx",rollercontext);
			context.put ("customcss",customcss  );
			context.put ("featuresofunit",request.getAttribute("FEATURESOFUNIT") );
			context.put ("basicDesihubHeader",request.getAttribute("BASICEVENTHEADER") );
			//context.put ("basicDesihubFooter",request.getAttribute("BASICEVENTFOOTER") );
			context.put ("eventbeeheader",request.getAttribute("BASIC_EVENT_HEADER") );
			context.put ("basicDesihubFooter",request.getAttribute("BASICEVENTFOOTER") );

			context.put ("showAdsGoogle",request.getAttribute("GEOOGLEADS") );
			context.put ("contentBeeletTitle",request.getAttribute("CONENTBEELETTITLE") );			
			context.put ("headerLinks",request.getAttribute("DESINAVLINKS") );
			context.put ("loginLinks",request.getAttribute("DESISIGNUPLINKS") );
			context.put ("headerLinks",request.getAttribute("DESINAVLINKS") );
			context.put ("loginLinks",request.getAttribute("DESISIGNUPLINKS") );
			context.put ("lifestyleLinks",request.getAttribute("LIFESTYLENAVLINKS") );
			context.put ("footerLinks",request.getAttribute("FOOTERLIST") );
			context.put ("poweredby",request.getAttribute("FOOTERPOWERDIMAGE") );
			context.put ("copyright",request.getAttribute("COPYRIGHT") );                  
			context.put ("desifooter",request.getAttribute("FOOTER") );
			context.put ("footer",request.getAttribute("FOOTER") );
			context.put ("GOOGLEMAP",request.getAttribute("GOOGLEMAP") );
       			context.put ("mapstring",request.getAttribute("mapstring") );			
			context.put ("profileinfo",request.getAttribute("PROFILEINFO") );
			context.put ("eventsphoto",request.getAttribute("EVENTSPHOTO") );
			context.put ("newevents",request.getAttribute("UPCOMINGEVENTS") );
			context.put ("oldevents",request.getAttribute("OLDEVENTS"));
			context.put ("uname",request.getAttribute("USERNAME"));			
			context.put ("networklink",request.getAttribute("NETWORKLINK"));
			context.put ("Bloglink",request.getAttribute("BLOGLINK"));
			context.put ("photoslink",request.getAttribute("PHOTOSLINK"));
			context.put ("communitylink",request.getAttribute("COMMUNITYLINK"));
			context.put ("partnerstreamer",request.getAttribute("PARTNERSTREAMER"));
			


		//render the content here
	  	VelocityEngine ve= new VelocityEngine(); ve.init();boolean abletopares=ve.evaluate(context,out,"ebeetemplate", templatedata );




	    }catch(Exception exp){
	    	out.println(exp.getMessage());

	    }
	
%>
