
<%
java.util.Date d=new java.util.Date();
HashMap configMap=(HashMap)request.getAttribute("confighm");
boolean isrecurringevent=("Y".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.recurring","N")));
boolean registrationAllowed=("Yes".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.poweredbyEB","no")));
boolean isrsvpd=("Yes".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.rsvp.enabled","no")));
String isseatingevent=GenUtil.getHMvalue(configMap,"event.seating.enabled","NO");
String venueid=GenUtil.getHMvalue(configMap,"event.seating.venueid","0");
String fbsharepopup=GenUtil.getHMvalue(configMap,"event.confirmationpage.fbsharepopup.show","Y");

String scriptTag="";
if("YES".equals(isseatingevent)){ 
scriptTag+="<link rel='stylesheet' type='text/css' href='/home/js/YUI/build/container/assets/container.css' />"+
"<script type='text/javascript' language='JavaScript' src='/home/js/YUI/build/yahoo-dom-event/yahoo-dom-event.js'></script>"+
"<script type='text/javascript' language='JavaScript' src='/home/js/YUI/build/container/container-min.js'></script>"+
"<script type='text/javascript' language='JavaScript' src='/home/js/seating/jquery-ui-1.8.10.custom.min.js'></script>";
}
scriptTag+="<script type='text/javascript' language='JavaScript' src='/home/js/jQuery.js'></script>"+
"<script type='text/javascript' language='JavaScript' src='/home/js/tktWedget.js?timestamp="+d.getTime()+"'></script>"+
"<script type='text/javascript' language='JavaScript' src='/home/js/prototype.js'></script>"+
"<script type='text/javascript' language='JavaScript' src='/home/js/ajax.js'>function ajaxdummy(){ }</script>"+
"<script type='text/javascript' language='JavaScript' src='/main/js/registration/registration.js?timestamp="+d.getTime()+"'></script>"+"<link rel='stylesheet' type='text/css' href='/home/css/seating.css' />";
if(isrsvpd){
scriptTag+="<script type='text/javascript' language='JavaScript' src='/home/js/rsvpreg.js?timestamp="+d.getTime()+"'></script>";
}else{
	scriptTag+="<script type='text/javascript' language='JavaScript' src='/main/js/registration/registration/tickets_registration.js?timestamp="+d.getTime()+"'></script>"+
	"<script type='text/javascript' language='JavaScript' src='/main/js/registration/common/tickets_common.js?timestamp="+d.getTime()+"'></script>"+
	"<script type='text/javascript' language='JavaScript' src='/main/js/registration/common/profile_common.js?timestamp="+d.getTime()+"'></script>"+
	"<script type='text/javascript' language='JavaScript' src='/main/js/registration/registration/profile_registration.js?timestamp="+d.getTime()+"'></script>"+
	"<script type='text/javascript' language='JavaScript' src='/main/js/registration/common/payments_common.js?timestamp="+d.getTime()+"'></script>"+
	"<script type='text/javascript' language='JavaScript' src='/main/js/registration/registration/payments_registration.js?timestamp="+d.getTime()+"'></script>"+
	"<script type='text/javascript' language='JavaScript' src='/main/js/registration/common/confirmation_common.js?timestamp="+d.getTime()+"'></script>"+
	"<script type='text/javascript' language='JavaScript' src='/main/js/registration/registration/confirmation_registration.js?timestamp="+d.getTime()+"'></script>";
	if("YES".equals(isseatingevent)){ 
		scriptTag+="<script type='text/javascript' language='JavaScript' src='/main/js/registration/common/seating/getseatingsection_common.js?timestamp="+d.getTime()+"'></script>"+
			"<script type='text/javascript' language='JavaScript' src='/main/js/registration/registration/seating/getseatingsection_registration.js?timestamp="+d.getTime()+"'></script>"+
		"<script type='text/javascript' language='JavaScript' src='/main/js/registration/common/seating/generateseating_common.js?timestamp="+d.getTime()+"'></script>"+
		"<script type='text/javascript' language='JavaScript' src='/main/js/registration/registration/seating/generateseating_registration.js?timestamp="+d.getTime()+"'></script>"+
		"<script type='text/javascript' language='JavaScript' src='/main/js/registration/common/seating/seatingtimer_common.js?timestamp="+d.getTime()+"'></script>"+
		"<script type='text/javascript' language='JavaScript' src='/main/js/registration/registration/seating/seatingtimer_registration.js?timestamp="+d.getTime()+"'></script>";
		}
}

scriptTag+="<script type='text/javascript' language='JavaScript' src='/home/js/controls/buildcontrol.js'></script>"+
"<script type='text/javascript' language='JavaScript' src='/home/js/controls/ctrlData.js'></script>"+
"<script type='text/javascript' language='JavaScript' src='/home/js/controls/checkboxWidget.js'></script>"+
"<script type='text/javascript' language='JavaScript' src='/home/js/controls/selectWidget.js'></script>"+
"<script type='text/javascript' language='JavaScript' src='/home/js/controls/radioWidget.js'></script>"+
"<script type='text/javascript' language='JavaScript' src='/home/js/controls/textboxWidget.js'></script>"+
"<script type='text/javascript' language='JavaScript' src='/home/js/controls/textareaWidget.js'></script>"+
"<script type='text/javascript' language='JavaScript' src='/home/js/popuphandler.js'></script>"+
"<script type='text/javascript' language='JavaScript' src='/home/js/effects.js'></script>";

if("Y".equals(fbsharepopup)){
scriptTag+="<script type='text/javascript' language='JavaScript' src='/home/js/fbevent/shareonfacebook.js'></script>";
}

String eventlevelHiddenAttribs="<input type='hidden' name='trackcode' id='trackcode' value='"+trackcode+"'/>";
eventlevelHiddenAttribs+="<input type='hidden' name='discountcode' id='discountcode' value='"+discountcode+"'/><input type='hidden' name='ticketurlcode' id='ticketurlcode' value='"+ticketurlcode+"'/><input type='hidden' name='context' id='context' value='"+context+"'/>";
eventlevelHiddenAttribs+="<input type='hidden' name='venueid' id='venueid' value='"+venueid+"'/><input type='hidden' name='isseatingevent' value='"+isseatingevent+"' id='isseatingevent'/><input type='hidden' name='fbsharepopup' id='fbsharepopup' value='"+fbsharepopup+"'>";
if("ning".equals(context))
eventlevelHiddenAttribs+="<input type='hidden' name='oid' id='oid' value='"+request.getParameter("oid")+"'/><input type='hidden' name='domain' id='domain' value='"+request.getParameter("domain")+"'/><input type='hidden' name='registrationsource' id='registrationsource' value='regular'>";

%>