<%@page import="com.eventbee.cachemanage.CacheManager"%>
<%@page import="com.eventbee.general.EbeeConstantsF"%>
<%@page import="com.paypal.sdk.console.commands.GetRequestTemplate"%>
<%@page import="java.util.*,org.json.*"%>

<%! 

public void prepareEventPageScript(){
	 String serveraddress="http://"+EbeeConstantsF.get("serveraddress","")+"/";
	StringBuffer general_script=new StringBuffer();	
	StringBuffer reg_script=new StringBuffer();	
	StringBuffer rsvpreg_script=new StringBuffer();	
	StringBuffer seatingreg_script=new StringBuffer();	

	general_script.append("<link rel='stylesheet' type='text/css' href='/main/build/container/assets/container.css' />");
	general_script.append("<script type='text/javascript' language='JavaScript' src='##resourceaddress##/main/build/yahoo-dom-event/yahoo-dom-event.js'></script>");
	general_script.append("<script type='text/javascript' language='JavaScript' src='##resourceaddress##/main/build/container/container-min.js'></script>");
	general_script.append("<script type='text/javascript' language='JavaScript' src='##resourceaddress##/home/js/seating/jquery-ui-1.8.10.custom.min.js'></script>");
	general_script.append("<script type='text/javascript' language='JavaScript' src='##resourceaddress##/home/js/tktWedget.js?timestamp=##timestamp##'></script>");
	//general_script.append("<script type='text/javascript' language='JavaScript' src='##resourceaddress##/home/js/prototype.js'></script>");
	general_script.append("<script src='//ajax.googleapis.com/ajax/libs/prototype/1.7.2.0/prototype.js'></script>");
	general_script.append("<script type='text/javascript' language='JavaScript' src='##resourceaddress##/home/js/ajax.js'>function ajaxdummy(){ }</script>");
	general_script.append("<script type='text/javascript' language='JavaScript' src='##resourceaddress##/main/js/registration/registration.js?timestamp=##timestamp##'></script>");
	general_script.append("<link rel='stylesheet' type='text/css' href='/home/css/seating.css' />");

	general_script.append("<script type='text/javascript' language='JavaScript' src='##resourceaddress##/home/js/controls/buildcontrol.js'></script>");
	general_script.append("<script type='text/javascript' language='JavaScript' src='##resourceaddress##/home/js/controls/ctrlData.js'></script>");
	general_script.append("<script type='text/javascript' language='JavaScript' src='##resourceaddress##/home/js/controls/checkboxWidget.js'></script>");
	general_script.append("<script type='text/javascript' language='JavaScript' src='##resourceaddress##/home/js/controls/selectWidget.js'></script>");
	general_script.append("<script type='text/javascript' language='JavaScript' src='##resourceaddress##/home/js/controls/radioWidget.js'></script>");
	general_script.append("<script type='text/javascript' language='JavaScript' src='##resourceaddress##/home/js/controls/textboxWidget.js'></script>");
	general_script.append("<script type='text/javascript' language='JavaScript' src='##resourceaddress##/home/js/controls/textareaWidget.js'></script>");
	general_script.append("<script type='text/javascript' language='JavaScript' src='##resourceaddress##/home/js/popuphandler.js' defer></script>");
	general_script.append("<script type='text/javascript' language='JavaScript' src='##resourceaddress##/home/js/effects.js' defer></script>");
	general_script.append("<script type='text/javascript' language='JavaScript' src='##resourceaddress##/home/js/eventlinks.js' defer></script>");
	general_script.append("<script type='text/javascript' language='JavaScript' src='##resourceaddress##/home/js/Tokenizer.js' defer></script>");
	general_script.append("<script type='text/javascript' language='JavaScript' src='##resourceaddress##/home/js/advajax.js'>function dummy() { }</script>");
	general_script.append("<script type='text/javascript' language='JavaScript' src='##resourceaddress##/home/js/popup.js' defer></script>");
	general_script.append("<script type='text/javascript' language='JavaScript' src='##resourceaddress##/home/js/ebeepopup.js' ></script><link rel='stylesheet' type='text/css' href='/home/css/popupcss.css' />");
	general_script.append("</script>"+"<script type='text/javascript' language='JavaScript' src='##resourceaddress##/main/js/registration/common/hold_js.js?timestamp=##timestamp##' defer></script>");
	general_script.append("<script type='text/javascript' language='JavaScript' src='##resourceaddress##/main/js/registration/common/seating/getseatingsection_common.js?timestamp=##timestamp##'></script>");
	general_script.append("<script type='text/javascript' language='JavaScript' src='##resourceaddress##/home/js/fbevent/fbntslogin.js' defer></script>");
	general_script.append("<script type='text/javascript' language='JavaScript' src='##resourceaddress##/home/js/fbevent/shareonfacebook.js?timestamp=##timestamp##' defer></script>");
	general_script.append("<script>(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)})");
    general_script.append("(window,document,'script','//www.google-analytics.com/analytics.js','ga');ga('create', 'UA-60215903-1', 'auto');ga('send', 'pageview');</script>");
    general_script.append("<script src='##resourceaddress##/main/js/registration/registration/priority_reg.js?timestamp=##timestamp##''></script>");

	reg_script.append("<script type='text/javascript' language='JavaScript' src='##resourceaddress##/main/js/registration/registration/tickets_registration.js?timestamp=##timestamp##'></script>");
	//reg_script.append("<script type='text/javascript' language='JavaScript' src='##resourceaddress##/main/js/registration/common/tickets_common.js?timestamp=##timestamp##'></script>");
	reg_script.append("<script>var scriptNotLoad=false;setTimeout(function(){if (typeof getTicketsJson == 'undefined' || typeof getTicketsJson === 'undefined') { scriptNotLoad=true; if(document.getElementById('registration'))  document.getElementById('registration').innerHTML='<center><h3>Network error! Please refresh the page to get tickets.</center></h3>';var eid=location.search.split('eid=')[1] ? location.search.split('eid=')[1] : '';var script = document.createElement('script');script.type  = 'text/javascript';script.src= '##resourceaddress##/main/ticketloadfails.jsp?eid='+eid;document.body.appendChild(script);}}, 30 * 1000);setInterval(function(){if(document.getElementById('registration') && (typeof getTicketsJson == 'undefined' || typeof getTicketsJson === 'undefined') && !scriptNotLoad)document.getElementById('registration').innerHTML='<center>Loading...</center>';},5*1000)</script>");
	
	reg_script.append("<script type='text/javascript' language='JavaScript' src='##resourceaddress##/main/js/registration/common/profile_common.js?timestamp=##timestamp##' defer></script>");
	reg_script.append("<script type='text/javascript' language='JavaScript' src='##resourceaddress##/main/js/registration/registration/profile_registration.js?timestamp=##timestamp##' defer></script>");
	reg_script.append("<script type='text/javascript' language='JavaScript' src='##resourceaddress##/main/js/registration/common/payments_common.js?timestamp=##timestamp##' defer></script>");
	reg_script.append("<script type='text/javascript' language='JavaScript' src='##resourceaddress##/main/js/registration/registration/payments_registration.js?timestamp=##timestamp##' defer></script>");
	reg_script.append("<script type='text/javascript' language='JavaScript' src='##resourceaddress##/main/js/registration/common/confirmation_common.js?timestamp=##timestamp##' defer></script>");
	reg_script.append("<script type='text/javascript' language='JavaScript' src='##resourceaddress##/main/js/registration/registration/confirmation_registration.js?timestamp=##timestamp##' defer></script>");
	//reg_script.append("<script type='text/javascript' language='JavaScript' src='##resourceaddress##/main/js/registration/registration/regcontrollerprofile.js?timestamp=##timestamp##'></script>");
	reg_script.append("<script> var ebeepopup=new ebeepopupwindow('ebeecustpopup','ebeepopup');ebeepopup.init();window.onload=initfbcheck;</script>");

	seatingreg_script.append("<script type='text/javascript' language='JavaScript' src='##resourceaddress##/main/js/registration/registration/seating/getseatingsection_registration.js?timestamp=##timestamp##'></script>");
	seatingreg_script.append("<script type='text/javascript' language='JavaScript' src='##resourceaddress##/main/js/registration/common/seating/generateseating_common.js?timestamp=##timestamp##'></script>");
    seatingreg_script.append("<script type='text/javascript' language='JavaScript' src='##resourceaddress##/main/js/registration/registration/seating/generateseating_registration_v3.js?timestamp=##timestamp##'></script>");
	seatingreg_script.append("<script type='text/javascript' language='JavaScript' src='##resourceaddress##/main/js/registration/common/seating/seatingtimer_common.js?timestamp=##timestamp##'></script>");
	seatingreg_script.append("<script type='text/javascript' language='JavaScript' src='##resourceaddress##/main/js/registration/registration/seating/seatingtimer_registration.js?timestamp=##timestamp##'></script>");


	rsvpreg_script.append("<script type='text/javascript' language='JavaScript' src='##resourceaddress##/home/js/rsvpreg.js?timestamp=##timestamp##'></script>");
	
		
	StringBuffer footer=new StringBuffer();



	footer.append("<div  id='footer' >");
	footer.append("<table align='center' cellpadding='5'>");
	footer.append("<tr>");
	footer.append("<td align='left' valign='middle'>");

	footer.append("<a style='margin-right:15px' href='"+serveraddress+"'><img src='##resourceaddress##/home/images/poweredby.jpg' border='0'/></a></td>");
	footer.append("<td>&nbsp;&nbsp;</td>");
	footer.append("<td align='left' valign='middle'>");
	footer.append("<span class='small'>Powered"
        		+" by Eventbee - Your Online Registration, Membership Management and Event <br/>Promotion"
				+" solution. For more information, "
				+"send an email to support at eventbee.com</span>");
	footer.append("</td></tr>");
	footer.append("</table>");
	footer.append("</div>");
	
	StringBuffer contact_mgr=new StringBuffer();
	
	contact_mgr.append("<a  href=javascript:Show('contactmgr')>Hosted by ##hostedby##</a>");
	contact_mgr.append(" <div id='contactmgr' style='display: none; margin: 10 5 10 5;'> ");
	contact_mgr.append(" <form name='AttendeeForm'  id='AttendeeForm' action='/portal/emailprocess/emailtoevtmgr.jsp?UNITID=13579&id=##groupid##&purpose=CONTACT_EVENT_MANAGER'  method='post' >" );
	contact_mgr.append(" Your Email* :<br> ");
	contact_mgr.append(" <input type='text' name='from_email' value=''  style='width: 200px;'><br><br>");
	contact_mgr.append(" Your Name* :  <br>");
	contact_mgr.append(" <input type='text' name='from_name' value=''  style='width: 200px;'><br><br> ");
	contact_mgr.append(" Subject :<br> ");
	contact_mgr.append(" <input type='text' name='subject' value='Re: ##subject##' style='width: 200px;'><br><br> ");
	contact_mgr.append(" Message :<br> " );
	contact_mgr.append(" <textarea name='note' style='width: 210px; height: 75px;'></textarea><br><br> ");
	contact_mgr.append(" <p align='center'> ");
	contact_mgr.append(" <div id='captchamsgmgr' style='display: none; color:red' >Enter Correct Code</div> ");
	contact_mgr.append("Enter the code as shown below:<div style='padding:5px;' valign='top' width='100%'><input type='text'   name='captchamgr'  value=''   valign='top'/>");
	contact_mgr.append("  <img  id='captchaidmgr'  alt='Captcha'  /></div><br><br>");
	contact_mgr.append("<input type='hidden' name='formnamemgr' value='AttendeeForm'/>");
	contact_mgr.append(" <input type='button' name='sendmgr' value='Send'  onClick=' return checkAttendeeForm()' /> ");
	contact_mgr.append(" <input type='button' value='Cancel' onclick=javascript:Cancel('contactmgr'); />");
	contact_mgr.append(" </p>");
	contact_mgr.append(" </form> </div>");
	contact_mgr.append(" <div id='urmessage'></div>");
	
	
	//for classic eventpage 	
	StringBuffer email_to_frnd = new StringBuffer();
	String listurl=serveraddress+"event?eid=##groupid##";
	String subject="##subject##";
	String msg="Hi,\n\n"+"I thought you might be interested in - "+subject+"\n"+"Here is the listing URL: "+listurl+"\n\n"+"Thanks";
	email_to_frnd.append("<a  href=javascript:Show('Invitation')>Email this to a friend</a>");
	email_to_frnd.append(" <div id='Invitation' style='display: none; margin: 10 5 10 5;'> ");
	email_to_frnd.append(" <form name='invitationForm'  id='invitationForm' action='/portal/emailprocess/emailsend.jsp?UNITID=13579&id=##groupid##&purpose=INVITE_FRIEND_TO_EVENT'  method='post' >");
	email_to_frnd.append("<input type='hidden' name='url' value='"+listurl+"' />");
	email_to_frnd.append(" To* :<br> ");
	email_to_frnd.append(" <textarea id='toheader' name='toemails' style='width: 210px; height: 70px;'></textarea><br>(separate emails with commas) ");
	email_to_frnd.append(" <br><br> ");
	email_to_frnd.append(" Your Email* :<br> ");
	email_to_frnd.append(" <input type='text' name='fromemail' value=''  style='width: 200px;'><br><br>");
	email_to_frnd.append(" Your Name* :  <br>");
	email_to_frnd.append(" <input type='text' name='fromname' value=''  style='width: 200px;'><br><br> ");
	email_to_frnd.append(" Subject :<br> ");
	email_to_frnd.append(" <input type='text' name='subject' value='Fw: "+subject+"' style='width: 200px;'><br><br> ");
	email_to_frnd.append(" Message :<br> ");
	email_to_frnd.append(" <textarea name='personalmessage' style='width: 210px; height: 75px;'>"+msg+"</textarea><br><br> ");
	email_to_frnd.append(" <p align='center'> ");
	email_to_frnd.append(" <div id='captchamsg' style='display: none; color:red' >Enter Correct Code</div> ");
	email_to_frnd.append("Enter the code as shown below:<div style='padding:5px;' valign='top' width='100%'><input type='text'   name='captcha'  value=''   valign='top'/>");
	email_to_frnd.append("  <img  id='captchaid'  alt='Captcha'  /></div><br><br>");
	email_to_frnd.append("<input type='hidden' name='formname' value='invitationForm'/>");
	email_to_frnd.append(" <input type='button' name='sendmsg' value='Send'  onClick=' return checkInvitationForm()' /> ");
	email_to_frnd.append(" <input type='button' value='Cancel' onclick=javascript:Cancel('Invitation'); />");
	email_to_frnd.append(" </p>");
	email_to_frnd.append(" </form> </div>");
	email_to_frnd.append(" <div id='message'></div>");
	
	StringBuffer eventurl = new StringBuffer();
	eventurl.append("<a href=javascript:Show('eventurl') >Event URL</a>");
	eventurl.append("<div id='eventurl' style='display: none; align='right' width='200 'margin: 10 5 10 5;>");
	eventurl.append("<textarea  cols='27' rows='2' onClick='this.select()'>##eventcustomurl##</textarea></div>");
	
    HashMap <String,Object> static_content=new HashMap<String,Object>();
   
	
    static_content.put("fbshare","<iframe src="+serveraddress+"portal/socialnetworking/fbshare.jsp?eid=##groupid## id='fbshare' name='fbshare' frameborder='0' width='74px' height='75px' scrolling='no'></iframe>");

  //for classic eventpage 
    static_content.put("fbLikeButton","<fb:like href="+serveraddress+"event?eid=##groupid## send='false' layout='box_count' width='60' show_faces='true'></fb:like>");
	
  //for classic eventpage 
	static_content.put("twitter","<a href='//twitter.com/share' class='twitter-share-button' data-lang='en' data-url='"+serveraddress+"view/event/##groupid##' data-text='Check out ##eventname##' data-count='vertical' data-via='eventbee' rel='external'>Tweet</a><script type='text/javascript' src='//platform.twitter.com/widgets.js'></script>");
   
   //for classic eventpage 
   static_content.put("fbcomment","<fb:comments href='"+serveraddress+"event?eid=##groupid##' num_posts='10' width='100%' via='www.eventbee.com'></fb:comments>");
   
   //for classic eventpage 	
    static_content.put("fbsend","<fb:send href='"+serveraddress+"event?eid=##groupid##' font='arial'></fb:send>");
  
   //for classic eventpage 
    static_content.put("googleplusone","<iframe id='googleplusone' name='googleplusone' src='"+serveraddress+"portal/socialnetworking/googleplus1.jsp?eid=##groupid##' frameborder='0' width='70px' height='75px' scrolling='no' style='margin-left:-10px'></iframe>");

  //for classic eventpage 
    static_content.put("fblist","<iframe src="+serveraddress+"portal/socialnetworking/fbattendeelist.jsp?eid=##groupid## height='295px'  width='100%' frameborder='0' scrolling='no' style='margin:0px;'></iframe>");

    static_content.put("fbibought","<iframe src="+serveraddress+"portal/socialnetworking/facebookbought.jsp?eid=##groupid## height='250px'  width='290px' frameborder='0' scrolling='no' style='margin:0px;'></iframe>");
     
  //for classic eventpage 
    static_content.put("promos","<iframe src="+serveraddress+"/main/home/fbeventpromotions.jsp?eid=##groupid## height='250px'  width='290px' frameborder='0' scrolling='no' style='margin:0px; max-width:100%'></iframe>");

    static_content.put("rsvpbutton","<form action='/portal/guesttasks/memberlogin.jsp' method='post'><input type='hidden' name='GROUPID' value='##groupid##' /><input type='submit' name='submit' value='RSVP'/></form>");


   static_content.put("mapstring","<a href=\"//maps.google.com/maps?q=##mstr##\"> Map and driving directions</a>");
 
   //for classic eventpage  
   static_content.put("googlemap","<iframe src='"+serveraddress+"portal/customevents/googlemap_js.jsp?lon=##lon##&lat=##lat##'  frameborder='0' height='260' width='100%' marginheight='0' marginwidth='0' name='googlemap' style='max-width:100%' scrolling='no'></iframe>");
 
   //for classic eventpage 
    static_content.put("whos_attendee","<script type='text/javascript' src='##resourceaddress##/home/js/whosattending.js'></script>");
    
    
	static_content.put("eventcustomurl",eventurl.toString());	
	static_content.put("email_to_frnd",email_to_frnd.toString());	
	static_content.put("contact_mgr",contact_mgr.toString());	
	static_content.put("general_footer",footer.toString());
	static_content.put("general_script",general_script.toString());
	static_content.put("reg_script",reg_script.toString());
	static_content.put("rsvpreg_script",rsvpreg_script.toString());
	static_content.put("seatingreg_script",seatingreg_script.toString());

	CacheManager.updateData("0_globalstatic", static_content, false); 
	System.out.println("Static map intialization:::Sucessfully");  
	
}

%>

<%
prepareEventPageScript();
%>
