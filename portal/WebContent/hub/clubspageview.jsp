<%@ page import="java.io.*, java.util.*,java.util.regex.*,java.sql.*" %>
<%@ page import="com.eventbee.authentication.*,com.themes.*" %>
<%@ page import="org.apache.oro.text.regex.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="org.apache.velocity .*,org.apache.velocity.app.Velocity,org.apache.velocity.context.*,org.apache.velocity.exception.*,org.apache.velocity.app.*" %>
<%@ include file="/mythemes/mythemesdb.jsp" %>

<%!
String CLASS_NAME="hub/clubspageview.jsp";

%>

<%@ include file='/club/clubtheme/hubcontent1.jsp' %>
<jsp:include page='/lifestyle/tnav.jsp' />

<%
String THEMEDATAQUERY="select getThemeDataNew(?,?,'css',?,?,?) as css, getThemeDataNew(?,?,'themecontent',?,?,?) as themecontent";
String rollercontext=(application.getInitParameter("rollercontext")!=null)?application.getInitParameter("rollercontext"):"/roller";
String templatedata="";
String customcss="";
String google_traffic_monitor=(String)request.getAttribute("GOOGLE_TRAFIC_MONITOR");
String [] themeNameandType=getMyPublicPageThemeCodeAndType("hubspage",authid,"basic");
String themetype=themeNameandType[0];
String deftheme=themeNameandType[1];
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"deftheme====="+deftheme,"",null);
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"themetype====="+themetype,"",null);

		
		String [] themedata=getPublicPageSelectedThemeData(authid,"hubspage",deftheme,"hubspage",themetype);
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

				context.put("customappctx",rollercontext);
				context.put("customcss",customcss  );
				context.put("featuresofunit",request.getAttribute("FEATURESOFUNIT") );
				context.put("basicDesihubHeader",request.getAttribute("BASICHUBHEADER") );
				context.put("basicDesihubFooter",request.getAttribute("BASICHUBFOOTER") );
				 
                
				
                                context.put ("uname",request.getAttribute("COMMUNITYNAME"));
				context.put ("profileinfo",request.getAttribute("PROFILEINFO") );
			        context.put ("hubslisted",request.getAttribute("HUBSCREATED") );

				
				//context.put ("partnerstreamer",request.getAttribute("PARTNERSTREAMER"));
			       context.put ("networklink",request.getAttribute("NETWORKLINK"));
			       context.put ("Bloglink",request.getAttribute("BLOGLINK"));
			       context.put ("photoslink",request.getAttribute("PHOTOSLINK"));


		  	VelocityEngine ve= new VelocityEngine(); ve.init();boolean abletopares=ve.evaluate(context,out,"ebeetemplate", templatedata );
		    }
		catch(Exception exp){
	    	out.println(exp.getMessage());
	    	    }
		  
%>
