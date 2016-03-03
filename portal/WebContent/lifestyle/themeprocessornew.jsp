<%@ page import="java.io.*, java.util.*,java.util.regex.*,java.sql.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.authentication.*,com.themes.*" %>
<%@ page import="com.eventbee.context.ContextConstants" %>
<%@ page import="org.apache.oro.text.regex.*" %>
<%@ page import="java.util.*,com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="org.apache.velocity .*,org.apache.velocity.app.Velocity,org.apache.velocity.context.*,org.apache.velocity.exception.*,org.apache.velocity.app.*" %>
<%@ page import="com.eventbee.eventpartner.*" %>

<%@ include file="/mythemes/mythemesdb.jsp" %>
<%!
String THEMEDATAQUERY="select getThemeDataNewOne(?,?,'css',?) as css, getThemeDataNewOne(?,?,'themecontent',?) as themecontent";

void processString(StringBuffer sb,String searchFor, String replaceWith){
			while(sb.indexOf(searchFor) !=-1){
				sb.replace(sb.indexOf(searchFor),sb.indexOf(searchFor)+searchFor.length(), replaceWith);
			}
	}
%>

<%      
if(1==1){
	response.sendRedirect("/home.jsp");
	return;
	}
 String CLASS_NAME="lifestyle/themeprocessornew.jsp";
	StringBuffer invitaionbuffer=new StringBuffer();
	String id1=request.getParameter("userid");
	String uname=null;
	String invid=request.getParameter("invid");
	if(id1==null) id1="";
	id1=id1.trim();
	if(!("000000".equals(id1)|| "".equals(id1)|| "0".equals(id1))){ 
		uname= (String)request.getAttribute("fullusername");   //DbUtil.getVal("select getMemberName(?)",new String[]{id1});
		if(uname==null) uname="";
		
	  
	
		if(invid!=null){
		try{
		
			String decodedinvid=EncodeNum.decodeNum( invid );
			if(decodedinvid !=null && !"".equals(decodedinvid) ){
				String query="update invitation_track set clickeddt=now() where invid=?";
				StatusObj sbj=DbUtil.executeUpdateQuery(query,new String [] {decodedinvid});
				
				invitaionbuffer.append("<table width='100%'  >" );
				invitaionbuffer.append("<form action='/portal/nuser/invaccepted.jsp' method='post'>");
				invitaionbuffer.append("<input type='hidden' name='invid' value='"+decodedinvid+"'/>");
				invitaionbuffer.append("<input type='hidden' name='userid' value='"+id1+"' />");
				//invitaionbuffer.append("<input type='hidden' name='UNITID' value='13579'/> ");
			
						invitaionbuffer.append("<tr>");
						    invitaionbuffer.append("<td  valign='middle' align='center'>"+uname+" invited you to join "+EbeeConstantsF.get("application.name","Eventbee")+"<br/>");
							   invitaionbuffer.append("<input type='submit' name='Submit' value='Accept Invitation and Sign Up'>");
						      invitaionbuffer.append("</td>");
						  invitaionbuffer.append("</tr>");
				invitaionbuffer.append("</form>");
				invitaionbuffer.append("</table>");
				request.setAttribute("INVITATIONHANDLER",invitaionbuffer.toString());
			}
		
		}catch(Exception exp){
		
		}
		}
	
	}
	
	
	%>



<%@ include file='tcontent.jsp' %>
<jsp:include page='tnav.jsp' />


<%

String rollercontext=(application.getInitParameter("rollercontext")!=null)?application.getInitParameter("rollercontext"):"/roller";
String templatedata="";
String templatecss="";

String modulename="network";
String purpose= (String)request.getAttribute("purpose"); //"network" ; from tcontent
if("Photos".equals(purpose)){
	modulename="photo";
}
//String userfirstname=null;
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","")+"/";
userfirstname=DbUtil.getVal("select first_name from user_profile where user_id=?",new String[]{userid});	
String partnerid=DbUtil.getVal("select partnerid from group_partner where userid=? and status='Active'",new String[]{userid});	
Map attribmap=PartnerDB.getStreamingAttributes(userid,partnerid);
%>
			
<%@ include file="/customevents/userstreamer.jsp" %>
<%request.setAttribute("PARTNERSTREAMER",partnerstreamer);
String customcss="";
String google_traffic_monitor=(String)request.getAttribute("GOOGLE_TRAFIC_MONITOR");
	

	/*DBManager dbmanager=new DBManager();
	StatusObj statobj=dbmanager.executeSelectQuery( THEMEDATAQUERY,new String[]{userid,purpose, modulename,userid,purpose, modulename });
		if(statobj !=null && statobj.getStatus()){
		templatedata=dbmanager.getValue(0,"themecontent","");
		customcss=dbmanager.getValue(0,"css","");
		customcss=customcss.replaceAll("/roller",rollercontext);
		customcss=customcss.replaceAll("\\$customappctx",rollercontext);
		
	}
	*/
	
	String [] themeNameandType=getMyPublicPageThemeCodeAndType("network",userid,"basic");
	String themetype=themeNameandType[0];
	String deftheme=themeNameandType[1];
	
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"deftheme====="+deftheme,"",null);
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"themetype====="+themetype,"",null);
	
	String [] themedata=getPublicPageSelectedThemeData(userid,"network",deftheme,"network",themetype);
	
	customcss=themedata[0];
	templatedata=themedata[1];

	
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
		
		//context.put ("invitaionhandler",request.getAttribute("INVITATIONHANDLER") );
		Map themeprefmap=PreferencesDB.getUserPref(userid,"themepage.snapshot.title");
		
		String pagetitle=  ((request.getAttribute("USERFIRSTNAME")!=null)?(String)request.getAttribute("USERFIRSTNAME"):"")        + "'s Network Page";
		pagetitle=GenUtil.getHMvalue( themeprefmap , "themepage.snapshot.title",pagetitle);
		String title1=request.getAttribute("USERFULLNAME")+"'s Lifestyle";
		context.put ("pageTitle",pagetitle);
		
		context.put ("lifestyletitle",title1);
		
		context.put ("invitationhandler",request.getAttribute("INVITATIONHANDLER") );
		context.put ("userfullname",request.getAttribute("USERFULLNAME") );

		context.put ("userName",request.getAttribute("USERFULLNAME") );
		
		
		
		context.put ("userunitid",request.getAttribute("USERUNITID") );
		context.put ("userfirstname",request.getAttribute("USERFIRSTNAME") );
		context.put ("userlastname",request.getAttribute("USERLASTNAME"));
		
		context.put ("firstName",request.getAttribute("USERFIRSTNAME") );
		context.put ("lastName",request.getAttribute("USERLASTNAME"));
		
		context.put ("eventbeeheader",request.getAttribute("BASIC_EVENT_HEADER") );
		context.put ("eventbeeFooter",request.getAttribute("BASICEVENTFOOTER") );
	        context.put ("profilename",request.getAttribute("USERPROFILENAME") );
		
		
		context.put ("customappctx",rollercontext);
		
		context.put ("customcss",customcss  );
		
		
		context.put ("publicProfileLink",ShortUrlPattern.get((String)request.getAttribute("USERPROFILENAME"))+"/network"  );
		context.put ("eventslink",request.getAttribute("EVENTSLINK"));
		context.put ("Bloglink",request.getAttribute("BLOGLINK"));
		context.put ("photoslink",request.getAttribute("PHOTOSLINK"));
		context.put ("communitylink",request.getAttribute("COMMUNITYLINK"));
		
		
		
            context.put ("featuresofunit",request.getAttribute("FEATURESOFUNIT") );
	    context.put ("lifestylephoto",request.getAttribute("LIFESTYLEPHOTO") );
	    
	    context.put ("profilecontent",request.getAttribute("PROFILECONTENT") );
	    
	   	    
	    
	    context.put ("listedevents",request.getAttribute("EVENTSLISTED") );
	    context.put ("registeredevents",request.getAttribute("EVENTSREGISTERED") );
	    context.put ("rsvpevents",request.getAttribute("RSVPDEVENTS") );
	    
	    
	    context.put ("moderatedhubs",request.getAttribute("MODERATEDHUBS") );
	    
	    context.put ("memberinhubs",request.getAttribute("MEMBERHUBS") );
	      context.put ("weblogs",request.getAttribute("WEBLOGLIST") );

	      context.put ("pitch",request.getAttribute("PITCH") );

	      context.put ("guestbooksignuplink",(request.getAttribute("GUESTBOOKSIGNUPLINK")!=null)?request.getAttribute("GUESTBOOKSIGNUPLINK"):"");
	       context.put ("showAdsGoogle",request.getAttribute("GEOOGLEADS") );
	      context.put ("guestbookentries",request.getAttribute("GUESTBOOKLIST") );
	      context.put ("friends",request.getAttribute("FRIENDSLIST") );
		
		context.put ("partnerstreamer",request.getAttribute("PARTNERSTREAMER"));
		context.put ("headerLinks",request.getAttribute("NAVLINKS") );
		context.put ("loginLinks",request.getAttribute("SIGNUPLINKS") );
		context.put ("lifestyleLinks",request.getAttribute("LIFESTYLENAVLINKS") );
		
		 context.put ("footerLinks",request.getAttribute("FOOTERLIST") );
	  	 context.put ("poweredby",request.getAttribute("FOOTERPOWERDIMAGE"));

	     	 context.put ("copyright",request.getAttribute("COPYRIGHT") );


		context.put ("desifooter",request.getAttribute("FOOTER") );
		context.put ("footer",request.getAttribute("FOOTER") );
	  	VelocityEngine ve= new VelocityEngine(); ve.init();boolean abletopares=ve.evaluate(context,out,"ebeetemplate", templatedata );
	    }catch(Exception exp){
	    	out.println(exp.getMessage());
	    
	    }
	    
		

%>
