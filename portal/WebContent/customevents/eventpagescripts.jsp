<%@page import="java.util.*,org.json.*"%>
<%
java.util.Date d=new java.util.Date();
HashMap configMap=(HashMap)request.getAttribute("confighm");
boolean isrecurringevent=("Y".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.recurring","N")));
boolean registrationAllowed=("Yes".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.poweredbyEB","no")));
boolean isrsvpd=("Yes".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.rsvp.enabled","no")));
String isseatingevent=GenUtil.getHMvalue(configMap,"event.seating.enabled","NO");
String venueid=GenUtil.getHMvalue(configMap,"event.seating.venueid","0");
String fbsharepopup=GenUtil.getHMvalue(configMap,"event.confirmationpage.fbsharepopup.show","Y");
String fbappid=DbUtil.getVal("select value from config where config_id='0' and name='ebee.fbconnect.appid'",null);
String notavail=null,unassign=null,notavailmsg=null,unassignmsg=null;
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com")+"/";
String event_photo_src=GenUtil.getHMvalue(configMap,"event.eventphotoURL",GenUtil.getHMvalue(configMap,"eventpage.logo.url","http://www.eventbee.com/home/images/logo_thumbnail.jpg"));
String og_image_metatag="<meta property='og:image' content='"+event_photo_src+"'/>";
%>

<%
//String s="<div id='fb-root'></div><script>var servadd='"+serveraddress+"';var  fbavailable=false;window.fbAsyncInit=function(){fbavailable=true;FB.init({appId:'"+fbappid+"',cookie:true,status:true,xfbml:true});};(function(){var e=document.createElement('script');e.type='text/javascript';e.src=document.location.protocol+'//connect.facebook.net/en_US/all.js';e.async=true;document.getElementById('fb-root').appendChild(e);}(document));</script>";
String s="<div id='fb-root'></div><script>var servadd='"+serveraddress+"';var  fbavailable=false;window.fbAsyncInit=function(){fbavailable=true;FB.init({appId:'"+fbappid+"',status:true,cookie:true,xfbml:true})};(function(a){var b,c='facebook-jssdk';if(a.getElementById(c)){return}b=a.createElement('script');b.id=c;b.async=true;b.src='//connect.facebook.net/en_US/all.js';a.getElementsByTagName('head')[0].appendChild(b)})(document)</script>";
//String s="window.fbAsyncInit=function(){FB.init({appId:'"+fbappid+"',status:true,cookie:true,xfbml:true})};(function(a){var b,c='facebook-jssdk';if(a.getElementById(c)){return}b=a.createElement('script');b.id=c;b.async=true;b.src='//connect.facebook.net/en_US/all.js';a.getElementsByTagName('head')[0].appendChild(b)})(document)";
String scriptTag=og_image_metatag+"<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/home/js/jQuery.js'></script>";
//if("YES".equals(isseatingevent)){ 
scriptTag+="<link rel='stylesheet' type='text/css' href='/main/build/container/assets/container.css' />"+
"<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/main/build/yahoo-dom-event/yahoo-dom-event.js'></script>"+
"<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/main/build/container/container-min.js'></script>"+
"<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/home/js/seating/jquery-ui-1.8.10.custom.min.js'></script>";
//}
scriptTag+=""+
"<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/home/js/tktWedget.js?timestamp="+d.getTime()+"'></script>"+
"<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/home/js/prototype.js'></script>"+
"<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/home/js/ajax.js'>function ajaxdummy(){ }</script>"+
"<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/main/js/registration/registration.js?timestamp="+d.getTime()+"'></script>"+"<link rel='stylesheet' type='text/css' href='/home/css/seating.css' />";
if(isrsvpd){
scriptTag+="<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/home/js/rsvpreg.js?timestamp="+d.getTime()+"'></script>";
}else{
	scriptTag+="<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/main/js/registration/registration/tickets_registration.js?timestamp="+d.getTime()+"'></script>"+
	"<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/main/js/registration/common/tickets_common.js?timestamp="+d.getTime()+"'></script>"+
	"<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/main/js/registration/common/profile_common.js?timestamp="+d.getTime()+"'></script>"+
	"<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/main/js/registration/registration/profile_registration.js?timestamp="+d.getTime()+"'></script>"+
	"<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/main/js/registration/common/payments_common.js?timestamp="+d.getTime()+"'></script>"+
	"<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/main/js/registration/registration/payments_registration.js?timestamp="+d.getTime()+"'></script>"+
	"<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/main/js/registration/common/confirmation_common.js?timestamp="+d.getTime()+"'></script>"+
	"<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/main/js/registration/registration/confirmation_registration.js?timestamp="+d.getTime()+"'></script>";
	if("YES".equals(isseatingevent)){ 
	String venuecss=DbUtil.getVal("select layout_css from venue_sections where venue_id=to_number(?,'9999999999999')",new String[]{venueid});
	notavail=DbUtil.getVal("select image from venue_seating_images where venue_id=CAST(? AS BIGINT) and context='notavailable'",new String[]{venueid});	
	notavailmsg=DbUtil.getVal("select message from venue_seating_images where venue_id=CAST(? AS BIGINT) and context='notavailable'",new String[]{venueid});	
	unassign=DbUtil.getVal("select image from venue_seating_images where venue_id=CAST(? AS BIGINT) and context='unassign'",new String[]{venueid});		
	unassignmsg=DbUtil.getVal("select message from venue_seating_images where venue_id=CAST(? AS BIGINT) and context='unassign'",new String[]{venueid});		
		scriptTag+="<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/main/js/registration/registration/seating/getseatingsection_registration.js?timestamp="+d.getTime()+"'></script>"+
		"<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/main/js/registration/common/seating/generateseating_common.js?timestamp="+d.getTime()+"'></script>"+
		"<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/main/js/registration/registration/seating/generateseating_registration_v3.js?timestamp="+d.getTime()+"'></script>"+
		"<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/main/js/registration/common/seating/seatingtimer_common.js?timestamp="+d.getTime()+"'></script>"+
		"<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/main/js/registration/registration/seating/seatingtimer_registration.js?timestamp="+d.getTime()+"'></script>";
		if(venuecss!=null && !"".equals(venuecss)){
			scriptTag+="<style type='text/css'>"+venuecss+"</style>";
		}
		}
}

scriptTag+="<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/home/js/controls/buildcontrol.js'></script>"+
"<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/home/js/controls/ctrlData.js'></script>"+
"<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/home/js/controls/checkboxWidget.js'></script>"+
"<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/home/js/controls/selectWidget.js'></script>"+
"<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/home/js/controls/radioWidget.js'></script>"+
"<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/home/js/controls/textboxWidget.js'></script>"+
"<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/home/js/controls/textareaWidget.js'></script>"+
"<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/home/js/popuphandler.js'></script>"+
"<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/home/js/effects.js'></script>"+
"<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/home/js/eventlinks.js'></script>"
+"<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/home/js/Tokenizer.js'></script>"+
"<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/home/js/advajax.js'>function dummy() { }</script>"
+"<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/home/js/popup.js'></script>"
+"<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/home/js/ebeepopup.js'></script><link rel='stylesheet' type='text/css' href='/home/css/popupcss.css' />"
+"<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/home/js/popuphandler.js'></script>"+"<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/main/js/registration/common/hold_js.js?timestamp="+d.getTime()+"'></script>"
+"<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/main/js/registration/common/seating/getseatingsection_common.js?timestamp="+d.getTime()+"'></script>";
scriptTag+="<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/home/js/fbevent/fbntslogin.js'></script>";
scriptTag+="<script type='text/javascript' language='JavaScript' src='"+resourceaddress+"/home/js/fbevent/shareonfacebook.js?timestamp="+d.getTime()+"'></script>";

String referral_ntscode="";
String nts_enable=EventPageContent.getEventInfoForKey("nts_enable",request,"N");
String nts_commission=EventPageContent.getEventInfoForKey("nts_commission",request,"0");
if("".equals(nts_enable) || "N".equals(nts_enable)){
	nts_enable="N";
	nts_commission="0";
	//display_ntscode="";
}
try{
if(Double.parseDouble(nts_commission)<0){
	nts_commission="0";
}
}catch(Exception e){
	nts_commission="0";
	System.out.println("exection is:"+e.getMessage());
}
if(display_ntscode==null)
	display_ntscode="";	

	if(!"".equals(display_ntscode)){
	
       String nts=DbUtil.getVal("select nts_code from ebee_nts_partner where nts_code=?",new String[]{display_ntscode});
		
		 if(!"".equals(nts)&& nts!=null)
		{     
		        if(session.getAttribute(groupid+"ntsclick"+display_ntscode)==null)
				{  	   RegistrationDBHelper regdbhelper=new RegistrationDBHelper();
					   referral_ntscode= regdbhelper.ValidateNTSCode(groupid,display_ntscode);
					   session.setAttribute(groupid+"ntsclick"+display_ntscode,display_ntscode);
				}
	        referral_ntscode=nts;
	    }

if(referral_ntscode==null )
	referral_ntscode="";
}

String ntsvariable="<input type='hidden' name='nts_enable' id='nts_enable' value='"+nts_enable+"'><input type='hidden' name='nts_commission' id='nts_commission' value='"+nts_commission+"'>";
ntsvariable+="<input type='hidden' id='login-popup' name='login-popup' value='"+GenUtil.getHMvalue(configMap,"event.reg.loginpopup.show","Y")+"'>";
ntsvariable+="<input type='hidden' name='referral_ntscode' id='referral_ntscode' value='"+referral_ntscode+"'>";
ntsvariable+="<input type='hidden' name='fbappid' id='fbappid' value='"+fbappid+"'>";
if(notavail!=null) ntsvariable+="<input type='hidden' name='notavailimage' id='notavailimage' value='"+notavail+"'>";
if(notavailmsg!=null) ntsvariable+="<input type='hidden' name='notavailmsg' id='notavailmsg' value='"+notavailmsg+"'>";
if(unassign!=null) ntsvariable+="<input type='hidden' name='unassign' id='unassign' value='"+unassign+"'>";
if(unassignmsg!=null) ntsvariable+="<input type='hidden' name='unassignmsg' id='unassignmsg' value='"+unassignmsg+"'>";
String eventlevelHiddenAttribs=s+"<input type='hidden' name='trackcode' id='trackcode' value='"+trackcode+"'/>";
eventlevelHiddenAttribs+="<input type='hidden' name='discountcode' id='discountcode' value='"+discountcode+"'/><input type='hidden' name='ticketurlcode' id='ticketurlcode' value='"+ticketurlcode+"'/><input type='hidden' name='context' id='context' value='"+context+"'/>";
eventlevelHiddenAttribs+="<input type='hidden' name='venueid' id='venueid' value='"+venueid+"'/><input type='hidden' name='isseatingevent' value='"+isseatingevent+"' id='isseatingevent'/><input type='hidden' name='fbsharepopup' id='fbsharepopup' value='"+fbsharepopup+"'><input type='hidden' name='eventstatus' id='eventstatus' value='"+eventstatus+"'>"+ntsvariable+"<input type='hidden' name='registrationsource' id='registrationsource' value='regular'>";
if("ning".equals(context))
eventlevelHiddenAttribs+="<input type='hidden' name='oid' id='oid' value='"+request.getParameter("oid")+"'/><input type='hidden' name='domain' id='domain' value='"+request.getParameter("domain")+"'/>";

%>
<script>
 
var ebeepopup=new ebeepopupwindow("ebeecustpopup","ebeepopup");
ebeepopup.init();
window.onload=initfbcheck;
</script>