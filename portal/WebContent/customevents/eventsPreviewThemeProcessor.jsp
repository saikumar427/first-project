<%@ page import="java.io.*, java.util.*,java.util.regex.*,java.sql.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.context.ContextConstants" %>
<%@ page import="org.apache.oro.text.regex.*" %>
<%@ page import="java.util.*,com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="org.apache.velocity.*,org.apache.velocity.app.Velocity,org.apache.velocity.context.*,org.apache.velocity.exception.*,org.apache.velocity.app.*" %>

<%!
void processString(StringBuffer sb,String searchFor, String replaceWith){
			while(sb.indexOf(searchFor) !=-1){
				sb.replace(sb.indexOf(searchFor),sb.indexOf(searchFor)+searchFor.length(), replaceWith);
			}
	}
	
	
	String CUSTOMQUERY="select themename,themeid as themecode from user_customized_themes where userid=?";
%>

<%
String THEMEDATAQUERY="select getThemeDataNew(?,?,'css',?,?,?) as css, getThemeDataNew(?,?,'themecontent',?,?,?) as themecontent";


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

String themetype=(request.getParameter("themetype")!=null)?request.getParameter("themetype"):"";

String deftheme=(request.getParameter("deftheme")!=null)?request.getParameter("deftheme"):"";
String currenttheme=request.getParameter("currenttheme");
String modulename=(request.getParameter("modulename")!=null)?request.getParameter("modulename"):"lifestyle";
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
String uname="";
if(purpose==null){
purpose=request.getParameter("type");

}
request.setAttribute("purpose",purpose);
request.setAttribute("userid",userid);
%>

<jsp:include page='/lifestyle/tnav.jsp' />
<jsp:include page='eventspagecontent.jsp' />


<%

	if(authData !=null){
		userunitid=authData.getUnitID();
		userfirstname=(authData.getFirstName()!=null)?authData.getFirstName().trim():"";
		userlastname=(authData.getLastName()!=null)?authData.getLastName().trim():"";
		userfullname=(userfirstname+userlastname).trim();
		//usrInfo.getLoginName()
	}
	
	request.setAttribute("USERUNITID",userunitid);
	request.setAttribute("USERFIRSTNAME",userfirstname);
	request.setAttribute("USERLASTNAME",userlastname);
	request.setAttribute("USERFULLNAME",userfullname);

//http://192.168.0.50:8080/portal/customevents/eventsPreviewThemeProcessor.jsp?modulename=eventspage&currenttheme=basic&type=eventspage&forchange=y&deftheme=basic&userid=13034&themetype=DEFAULT

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
		
			userid=authData.getUserID();
	
			
		}
		
		
	}

}//end of for change ie login user preview




String previewlifestylecont="<table align='center' width='100%'><tr height='400'><td align='center'>"+contentname+"</td></tr> </table>";


String EVENTID=request.getParameter("userid");
if(EVENTID==null||"".equals(EVENTID))
EVENTID=request.getParameter("userid");
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, "lifestyle/eventspreviewthemeprocessornew.jsp", "userid="+userid+" purpose="+purpose+" deftheme=  "+deftheme , "**type="+request.getParameter("type"), null);

String [] values=new String[]{themeuserid,purpose,deftheme,modulename,EVENTID,themeuserid,purpose,deftheme,modulename,EVENTID };
	DBManager dbmanager=new DBManager();

	if(!"DEFAULT".equals(themetype))
	{
	THEMEDATAQUERY="select cssurl as css,content as themecontent from user_customized_themes where themeid=?";
	values=new String [] {deftheme};
	}
	
	StatusObj statobj=dbmanager.executeSelectQuery(THEMEDATAQUERY ,values);
               

	if(statobj !=null && statobj.getStatus()){
		templatedata=dbmanager.getValue(0,"themecontent","");
		customcss=dbmanager.getValue(0,"css","");
		customcss=customcss.replaceAll("/roller",rollercontext);
		customcss=customcss.replaceAll("\\$customappctx",rollercontext);  
		
		

	}
	
	
	
        
        
        
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

			context.put ("showAdsGoogle",request.getAttribute("GEOOGLEADS") );
			context.put ("contentBeeletTitle",request.getAttribute("CONENTBEELETTITLE") );
			
			
			context.put ("headerLinks",request.getAttribute("DESINAVLINKS") );
			context.put ("loginLinks",request.getAttribute("DESISIGNUPLINKS") );
			
			
			context.put ("headerLinks",request.getAttribute("DESINAVLINKS") );
			context.put ("loginLinks",request.getAttribute("DESISIGNUPLINKS") );
			context.put ("lifestyleLinks",request.getAttribute("LIFESTYLENAVLINKS") );
			//context.put ("eventDesiAd",request.getAttribute("ADCONENTBEELET") );

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
			//links
			
			context.put ("networklink",request.getAttribute("NETWORKLINK"));
			context.put ("Bloglink",request.getAttribute("BLOGLINK"));
			context.put ("photoslink",request.getAttribute("PHOTOSLINK"));
			
			
			
						
			
		//render he contetn here
	  	VelocityEngine ve= new VelocityEngine(); ve.init();boolean abletopares=ve.evaluate(context,out,"ebeetemplate", templatedata );

	    }catch(Exception exp){
	    	out.println(exp.getMessage());
	    
	    }
	
%>
