<%@ page import="java.io.*, java.util.*,java.util.regex.*,java.sql.*" %>
<%@ page import="com.eventbee.authentication.*,com.themes.*" %>
<%@ page import="org.apache.oro.text.regex.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="org.apache.velocity .*,org.apache.velocity.app.Velocity,org.apache.velocity.context.*,org.apache.velocity.exception.*,org.apache.velocity.app.*" %>
<%@ include file="/mythemes/mythemesdb.jsp" %>
<%@ include file="../getresourcespath.jsp" %>
<script src="<%=resourceaddress%>/home/js/jQtouch/jquery.1.3.2.min.js" type="text/javascript" charset="utf-8"></script>
<%!
String CLASS_NAME="customevents/eventspageThemepro.jsp";
static String serveraddress="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com")+"/";

void processString(StringBuffer sb,String searchFor, String replaceWith){
			while(sb.indexOf(searchFor) !=-1){
				sb.replace(sb.indexOf(searchFor),sb.indexOf(searchFor)+searchFor.length(), replaceWith);
			}
	}
%>
<%
String uname=request.getParameter("name");

String userid=DbUtil.getVal("select user_id from authentication where lower(login_name)=lower(?)",new String[]{uname});
String platform=(String)session.getAttribute("platform");
String ningvid=request.getParameter("ningviwer");
String ningoid=request.getParameter("ningowner");


%>

<jsp:include page='eventspagecontent.jsp' />
<jsp:include page='/lifestyle/tnav.jsp' />

<%
String rollercontext=(application.getInitParameter("rollercontext")!=null)?application.getInitParameter("rollercontext"):"/roller";
String templatedata="";
String customcss="";
String google_traffic_monitor=(String)request.getAttribute("GOOGLE_TRAFIC_MONITOR");
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"userid====="+userid,"",null);
//EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"themetype====="+themetype,"",null);


String [] themeNameandType={};
if("ning".equals(platform)){

themeNameandType=getMyPublicPageThemeCodeAndType("eventspage_ning",userid,"basic");

}
else{
themeNameandType=getMyPublicPageThemeCodeAndType("eventspage",userid,"basic");
System.out.println("themeNameandType: "+themeNameandType[0]);
}
String themetype=themeNameandType[0];
String deftheme=themeNameandType[1];
String preview=request.getParameter("preview");
String pretheme=request.getParameter("pretheme");
if(preview==null) preview="";
if(pretheme==null) pretheme="";
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"deftheme====="+deftheme,"",null);
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"themetype====="+themetype,"",null);

String [] themedata={};

if("ning".equals(platform)){
	
 themedata=getPublicPageSelectedThemeData(userid,"eventspage_ning",deftheme,"eventspage_ning",themetype);
}
else if(preview.equals("show")){

deftheme=pretheme;
themetype="DEFAULT";

themedata=getPublicPageDefaultThemeData(userid,"eventspage",deftheme);
} else
themedata=getPublicPageSelectedThemeData(userid,"eventspage",deftheme,"eventspage",themetype);
customcss=themedata[0];
templatedata=themedata[1];
try{
customcss=customcss.replaceAll("url\\(http://eventbee.com/home", "url\\("+resourceaddress+"/home");
customcss=customcss.replaceAll("url\\(http://www.eventbee.com/home", "url\\("+resourceaddress+"/home");
customcss=customcss.replaceAll("url\\(/home", "url\\("+resourceaddress+"/home");
customcss=customcss.replaceAll("url\\(/main", "url\\("+resourceaddress+"/main");
customcss=customcss.replaceAll("url\\(\"/main", "url\\(\""+resourceaddress+"/main");
}catch(Exception e){
	System.out.println("Exception ocuured in eventspageThemepro.jsp while replacing resourcesaddress: for userid ::"+userid+" :: "+e.getMessage());
}
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
			context.put ("userfirstname",request.getAttribute("FIRSTNAME") );
			context.put ("userlastname",request.getAttribute("USERLASTNAME"));
			context.put ("profilename",request.getAttribute("USERPROFILENAME") );


			context.put ("customappctx",rollercontext);

			context.put ("customcss",customcss  );


                        context.put ("featuresofunit",request.getAttribute("FEATURESOFUNIT") );
			//context.put ("basicDesihubHeader",request.getAttribute("BASIC_EVENT_HEADER") );
			context.put ("eventbeeheader",request.getAttribute("BASIC_EVENT_HEADER") );
			context.put ("eventbeeFooter",request.getAttribute("BASICEVENTFOOTER") );

			context.put ("showAdsGoogle",request.getAttribute("GEOOGLEADS") );
			context.put ("contentBeeletTitle",request.getAttribute("CONENTBEELETTITLE") );
			
			
			context.put ("headerLinks",request.getAttribute("DESINAVLINKS") );
			context.put ("loginLinks",request.getAttribute("DESISIGNUPLINKS") );
			
			context.put ("eventsPage",request.getAttribute("EVENTSPAGE") );
			
			context.put ("headerLinks",request.getAttribute("DESINAVLINKS") );
			context.put ("loginLinks",request.getAttribute("DESISIGNUPLINKS") );
			context.put ("lifestyleLinks",request.getAttribute("LIFESTYLENAVLINKS") );
			//context.put ("eventDesiAd",request.getAttribute("ADCONENTBEELET") );

			context.put ("footerLinks",request.getAttribute("FOOTERLIST") );
			context.put ("poweredby",request.getAttribute("FOOTERPOWERDIMAGE") );
			context.put ("copyright",request.getAttribute("COPYRIGHT") );

                        context.put ("calender",request.getAttribute("CALENDER") );
			context.put ("selectedDate",request.getAttribute("SELECTEDDATE") );
			
			 context.put ("pageOwner",request.getAttribute("VENUEOWNER") );
			
			context.put ("desifooter",request.getAttribute("FOOTER") );
			context.put ("footer",request.getAttribute("FOOTER") );
			context.put ("GOOGLEMAP",request.getAttribute("GOOGLEMAP") );
       			context.put ("mapstring",request.getAttribute("mapstring") );
			
			context.put ("profileinfo",request.getAttribute("PROFILEINFO") );
			context.put ("eventsPhoto",request.getAttribute("EVENTSPHOTO") );
			context.put ("eventsphoto",request.getAttribute("EVENTSPHOTO") );
			context.put ("newEvents",request.getAttribute("UPCOMINGEVENTS") );
			context.put ("newevents",request.getAttribute("UPCOMINGEVENTSOLD") );
			context.put ("oldEvents",request.getAttribute("OLDEVENTS"));
			context.put ("oldevents",request.getAttribute("OLDEVENTSOLD"));
			context.put ("uname",request.getAttribute("USERNAME"));
			context.put ("emailfriendLink",request.getAttribute("EMAILTOFRIENDLINK"));
			context.put ("networklink",request.getAttribute("NETWORKLINK"));
			context.put ("Bloglink",request.getAttribute("BLOGLINK"));
			context.put ("photoslink",request.getAttribute("PHOTOSLINK"));
			context.put ("communitylink",request.getAttribute("COMMUNITYLINK"));
			context.put ("partnerstreamer",request.getAttribute("PARTNERSTREAMER"));
			
			context.put ("venueEvents",request.getAttribute("VENUEEVENTS"));
			context.put ("description",request.getAttribute("DESCRIPTION") );
			String fbshare="",fblike="",twitter="";
			String shareusername=uname;
			String 	src="/portal/socialnetworking/fblike.jsp?username="+shareusername+"";
			fblike="<iframe src="+src+" frameborder='0' width='70px' height='75px' scrolling='no'></iframe>";
			context.put("fbLikeButton",fblike);
			src="/portal/socialnetworking/twitter.jsp?username="+shareusername+"";
			twitter="<iframe src="+src+" frameborder='0' width='70px' height='75px' scrolling='no'></iframe>";
			System.out.println("server address:"+serveraddress);
			twitter="<a href='http://twitter.com/share' class='twitter-share-button' data-url='"+serveraddress+"view/"+uname+"' data-text='Check out "+request.getAttribute("USERNAME")+"' data-count='vertical' data-via='eventbee' rel='external'>Tweet</a><script type='text/javascript' src='http://platform.twitter.com/widgets.js'></script>";
		context.put("twitterButton",twitter);
			String googleplusone="<iframe src='/portal/socialnetworking/googleplus1.jsp?username="+shareusername+"' frameborder='0' width='70px' height='75px' scrolling='no' style='margin-left:-10px'></iframe>";
			context.put("googlePlusOne",googleplusone);
		//render he contetn here
		VelocityEngine ve= new VelocityEngine(); ve.init();boolean abletopares=ve.evaluate(context,out,"ebeetemplate", templatedata );
	  	//boolean abletopares=Velocity.evaluate(context,out,"ebeetemplate", templatedata );

	    }catch(Exception exp){
	    	out.println(exp.getMessage());
	    
	    }
	
%>
<script>
		$(".show_hide").click(function(){
					//alert($(this).attr("src"));
					var imgid=this.id
					$("#desc_"+imgid).slideToggle(
						function(){
							var a=document.getElementById(this.id).style.display;
							if(a=="none")
								$("#"+imgid).attr("src","/home/images/expand.gif")
							else
								$("#"+imgid).attr("src","/home/images/collapse.gif")
						}
					);
		});
	</script>