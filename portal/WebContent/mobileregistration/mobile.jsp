<%@ page import="com.eventbee.general.GenUtil,com.eventbee.general.DbUtil,com.eventbee.general.EbeeCachingManager" %>
<%@ page import="com.eventregister.TicketsDB,java.util.HashMap, com.eventpageloader.*,com.eventregister.RegistrationDBHelper"%>
<%
String eid=request.getParameter("eid");
String showtype=request.getParameter("showtype");
String username=request.getParameter("username");
String useragent=request.getHeader("User-Agent");
String display_ntscode=request.getParameter("nts");
String notavail=null,unassign=null,notavailmsg=null,unassignmsg=null;
HashMap eventinfoMap=null;
HashMap blockedEventsMap=(HashMap)EbeeCachingManager.get("blockedEvents");
if(blockedEventsMap==null){
	blockedEventsMap=new HashMap();
	EbeeCachingManager.put("blockedEvents",blockedEventsMap);
}
if(useragent.indexOf("Safari")==-1 && useragent.indexOf("iPad")==-1){
	//response.sendRedirect("/event?eid="+eid);
	//return;
}
if(eid==null || "".equals(eid)){
	System.out.println("Event Page(iPad) with no eventid: ");
	response.sendRedirect("/guesttasks/invalidpage.jsp");
	return;
}else {
	if(blockedEventsMap.get(eid)!=null){
	System.out.println("Event Page(widget) with blocked eventid: "+eid);
	response.sendRedirect("/guesttasks/invalidpage.jsp");
	return;
	}
	try{
	int eventid=Integer.parseInt(eid);
	eventinfoMap=EventPageContent.getEventDetailsFromDb(eid);
	if(eventinfoMap==null || eventinfoMap.size()<1 ){
		System.out.println("Event Page(iPad) with wrong eventid: "+eid);	
		response.sendRedirect("/guesttasks/invalidpage.jsp");
		return;
	}
	}catch(Exception e){
		System.out.println("Event Page(iPad) with wrong eventid: "+eid);	
		response.sendRedirect("/guesttasks/invalidpage.jsp");
		return;
	}
	}
	request.setAttribute("eventinfohm",eventinfoMap);
	String eventstatus=EventPageContent.getEventInfoForKey("status",request,"ACTIVE");
	if("CANCEL".equals(eventstatus)){
		System.out.println("Event Page(widget) with cancelled eventid: "+eid);	
		response.sendRedirect("/guesttasks/invalidpage.jsp");
		return;
	}
String trackcode=request.getParameter("track");
String domain="web";
if(username==null)
username="";
TicketsDB ticketInfo=new TicketsDB();
HashMap configMap=ticketInfo.getConfigValuesFromDb(eid);
boolean isrecurringevent=("Y".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.recurring","N")));
boolean registrationAllowed=("Yes".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.poweredbyEB","no")));
boolean isrsvpd=("Yes".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.rsvp.enabled","no")));
String isseatingevent=GenUtil.getHMvalue(configMap,"event.seating.enabled","NO");
String venueid=GenUtil.getHMvalue(configMap,"event.seating.venueid","0");


String referral_ntscode="";
String nts_enable=EventPageContent.getEventInfoForKey("nts_enable",request,"N");

String nts_commission=EventPageContent.getEventInfoForKey("nts_commission",request,"0");
if("".equals(nts_enable) || "N".equals(nts_enable)){
	nts_enable="N";
	nts_commission="0";
	display_ntscode="";
}
try{
if(Double.parseDouble(nts_commission)<0){
	nts_commission="0";
}
}catch(Exception e){
	nts_commission="0";
}
if(display_ntscode==null)
	display_ntscode="";	

if("Y".equals(nts_enable) && !"".equals(display_ntscode)){
RegistrationDBHelper regdbhelper=new RegistrationDBHelper();
referral_ntscode= regdbhelper.ValidateNTSCode(eid,display_ntscode);
if(referral_ntscode==null )
	referral_ntscode="";
}
String fbappid=DbUtil.getVal("select value from config where config_id='0' and name='ebee.fbconnect.appid'",null);
String twtappid=DbUtil.getVal("select value from config where config_id='0' and name='ebee.twitterconnect.appid'",null);
%>
<html>
<head>
<%if(!"indirect".equals("showtype")){%>
<style type="text/css" media="screen">@import "/home/css/jQtouch/jqtouch.min.css"; 
#eventdate{
	width:310px;
}
#mobile{
min-height:100%;
padding:10px;
}</style>
<style type="text/css" media="screen">@import "/home/css/jQtouch/themes/jqt/theme.min.css";</style>
<script type='text/javascript' language='JavaScript' src='/home/js/jQuery.js'></script>
<script src="/home/js/jQtouch/jqtouch.js" type="application/x-javascript" charset="utf-8"></script>
<script src="/home/js/jQtouch/jquery.1.3.2.min.js" type="text/javascript" charset="utf-8"></script>
<%}%>
<script type="text/javascript" charset="utf-8">
	var prev_div = "";
	var curr_div = "";
	var jQT = new $.jQTouch({
	slideSelector: 'body > * > ul li a, .forceSlide,.slide',
		icon: 'jqtouch.png',
		addGlossToIcon: false,
		startupScreen: 'jqt_startup.png',
		statusBar: 'black'
	});
</script>
<link rel='stylesheet' type='text/css' href='/home/css/popupcss.css' />
<link rel="stylesheet" type="text/css" media="screen" href="/home/css/jQtouch/jqtouch.css"/>
<link rel="stylesheet" type="text/css" media="screen" href="/home/css/jQtouch/themes/jqt/theme.css"/>
<link rel='stylesheet' type='text/css' href='/home/css/jQtouch/jqtseating.css' />
<script src='/home/js/jQtouch/jqtouch.js' type='application/x-javascript' charset='utf-8'></script>
<script type='text/javascript' language='JavaScript' src='/home/js/tktWedget.js'></script>
<script type='text/javascript' language='JavaScript' src='/home/js/prototype.js'></script>
<script type='text/javascript' language='JavaScript' src='/home/js/ajax.js'>function ajaxdummy(){ }</script>
<script type='text/javascript' language='JavaScript' src='/main/js/registration/registration.js'></script>
<%if(isrsvpd){%>
<script type='text/javascript' language='JavaScript' src='/home/js/mobilersvpreg.js'></script>
<%}else{%>

<script type='text/javascript' language='JavaScript' src='/main/js/registration/ipad/tickets_ipad.js'></script>
<script type='text/javascript' language='JavaScript' src='/main/js/registration/common/tickets_common.js'></script>
<%if("YES".equals(isseatingevent)){ 
String venuecss=DbUtil.getVal("select layout_css from venue_sections where venue_id=to_number(?,'9999999999999')",new String[]{venueid});
	notavail=DbUtil.getVal("select image from venue_seating_images where venue_id=CAST(? AS BIGINT) and context='notavailable'",new String[]{venueid});	
	notavailmsg=DbUtil.getVal("select message from venue_seating_images where venue_id=CAST(? AS BIGINT) and context='notavailable'",new String[]{venueid});	
	unassign=DbUtil.getVal("select image from venue_seating_images where venue_id=CAST(? AS BIGINT) and context='unassign'",new String[]{venueid});		
	unassignmsg=DbUtil.getVal("select message from venue_seating_images where venue_id=CAST(? AS BIGINT) and context='unassign'",new String[]{venueid});		

%>
<script type='text/javascript' language='JavaScript' src='/main/js/registration/ipad/seating/getseatingsection_ipad.js'></script>
<script type='text/javascript' language='JavaScript' src='/main/js/registration/ipad/seating/generateseating_ipad.js'></script>
<script type='text/javascript' language='JavaScript' src='/main/js/registration/common/seating/generateseating_common.js'></script>
<script type='text/javascript' language='JavaScript' src='/main/js/registration/ipad/seating/seatingtimer_ipad.js'></script>
<script type='text/javascript' language='JavaScript' src='/main/js/registration/common/seating/seatingtimer_common.js'></script>
<%
if(venuecss!=null && !"".equals(venuecss)){%>
			<style type='text/css'><%=venuecss%></style>
<%}}%>
<%}%>
<script type='text/javascript' language='JavaScript' src='/main/js/registration/ipad/hold_ipad.js'></script>    
<script type='text/javascript' language='JavaScript' src='/main/js/registration/common/seating/getseatingsection_common.js'></script>
 <script src='http://platform.twitter.com/anywhere.js?id=<%=twtappid%>&v=1.2' type='text/javascript'></script>
</head>
<body>
<div id="backgroundPopup" ></div>
<ul id="leftList"  style="margin:0px; padding:10px;">
<table   id="container"><tr><td>
<%if(notavail!=null) {%><input type='hidden' name='notavailimage' id='notavailimage' value='<%=notavail%>'><%}%>
<%if(notavailmsg!=null){%><input type='hidden' name='notavailmsg' id='notavailmsg' value='<%=notavailmsg%>'><%}%>
<%if(unassign!=null){%><input type='hidden' name='unassign' id='unassign' value='<%=unassign%>'><%}%>
<%if(unassignmsg!=null){%><input type='hidden' name='unassignmsg' id='unassignmsg' value='<%=unassignmsg%>'><%}%>
<input type='hidden' name='context' id='context' value='<%=domain%>'>
<input type='hidden' name='trackcode' id='trackcode' value='<%=trackcode%>'>
<input type='hidden' name='venueid' id='venueid' value='<%=venueid%>'>
<input type='hidden' name='isseatingevent' id='isseatingevent' value='<%=isseatingevent%>'>
<input type='hidden' name='username' id='username' value='<%=username%>'>
<input type='hidden' name='registrationsource' id='registrationsource' value='iPad'>
<input type='hidden' name='eventstatus' id='eventstatus' value='<%=eventstatus%>'>
<!--nts related hidden variables start-->
<input type='hidden' name='nts_enable' id='nts_enable' value='<%=nts_enable%>'>
<input type='hidden' name='nts_commission' id='nts_commission' value='<%=nts_commission%>'>
<input type='hidden' id='login-popup' name='login-popup' value='<%=GenUtil.getHMvalue(configMap,"event.reg.loginpopup.show","Y")%>'>
<input type='hidden' name='referral_ntscode' id='referral_ntscode' value='<%=referral_ntscode%>'>
<input type='hidden' name='fbappid' id='fbappid' value='<%=fbappid%>'>
<div id="fb-root"></div>
<script>
var  fbavailable=false;
window.fbAsyncInit = function() {
		fbavailable=true;
         FB.init({ 
            appId:'<%=fbappid%>', cookie:true, 
            status:true, xfbml:true 
         });
		 };
         (function() {
                var e = document.createElement('script');
                e.type = 'text/javascript';
                e.src = document.location.protocol +
                    '//connect.facebook.net/en_US/all.js';
                e.async = true;
                document.getElementById('fb-root').appendChild(e);
            }());
			</script>
<!--nts related hidden variables ends-->
<div id="box">
</div>
</td></tr></table>
</ul>
<%if(isrsvpd){%>
	<div id="rsvpreg" style="padding:20px;"></div>
	<div id="rsvpprofilecontent" style="padding:20px;"></div>
	 <script>getRsvpOptionsBlock("<%=eid%>")</script>
<%}else{%>
<%if(isrecurringevent){
String recurringselect=ticketInfo.getRecurringEventDates(eid,"tickets");
	if(recurringselect==null)
		recurringselect="<select onchange=getTicketsJson('"+eid+"'); id='eventdate' name='eventdate'></select>";
%>
<div id="mobile" class="current">
<table width="100%" class="tableborder"><tr><td height="10px;"></td></tr><tr style="padding:10px;"><td><span style="padding:10px;">Select a date and time to attend: <%=recurringselect%></span></td></tr><tr><td height="10px;"></td></tr></table></div>
<%}%>
<div id="registration" style="padding:20px;" class="slide in"></div>
<div id="profile" style="padding:20px;"></div>
<div id="paymentsection" style="padding:20px;"></div>
<div id="imageLoad" style="padding:20px;"></div>
<script>getTicketsJson("<%=eid%>");</script>
<div id="layoutpopup" class='ticketwidget layoutfloat ' style="padding:20px;"></div>
<div id="divpopup" class='ticketwidget layoutfloat ' style="padding:20px;"></div>
<div id="timerdiv" style="padding-left:2px;"></div>
<div id="ticket_timer"  class='ticket_timer' style="padding-left:2px; min-height:25px; display:none;"></div>
<div id="ticketunavailablepopup_div" class="ticketunavailablepopup_div layoutfloat" style="padding-left:2px; min-height:25px"></div>
<div id="ticketpoup_div" class="ticketwidget layoutfloat" style="padding-left:2px; min-height:25px"></div>

<script type='text/javascript' language='JavaScript' src='/main/js/registration/ipad/profile_ipad.js'></script>
<script type='text/javascript' language='JavaScript' src='/main/js/registration/common/profile_common.js'></script>
<script type='text/javascript' language='JavaScript' src='/main/js/registration/ipad/payments_ipad.js'></script>
<script type='text/javascript' language='JavaScript' src='/main/js/registration/common/payments_common.js'></script>
<script type='text/javascript' language='JavaScript' src='/main/js/registration/ipad/confirmation_ipad.js'></script>
<script type='text/javascript' language='JavaScript' src='/main/js/registration/common/confirmation_common.js'></script>
<%}%>

<script>
			$( function() {	
				$('#mobile').bind('pageAnimationEnd', function(e, info){
					var eid = <%=eid%>;
					
				});	
				$('#animations').bind('pageAnimationEnd', function(e, info){
					$('#animations a').click(function(e) {
						e.preventDefault();
						jQT.liveTap(e);				        
					});
				});
				$('#registration').bind('pageAnimationEnd', function(e, info){
					$('#registration a').click(function(e) {
						e.preventDefault();
						jQT.liveTap(e);				        
					});
				});
				$('#profile').bind('pageAnimationEnd', function(e, info){
					$('#profile a').click(function(e) {
						e.preventDefault();
						jQT.liveTap(e);				        
					});
				});
				$('#divpopup').bind('pageAnimationEnd', function(e, info){
					$('#divpopup input').click(function(e) {
						e.preventDefault();
						jQT.liveTap(e);				        
					});
				});
			});
	</script>
<script type='text/javascript' language='JavaScript' src='/home/js/controls/buildcontrol.js'></script>
<script type='text/javascript' language='JavaScript' src='/home/js/controls/ctrlData.js'></script>
<script type='text/javascript' language='JavaScript' src='/home/js/controls/checkboxWidget.js'></script>
<script type='text/javascript' language='JavaScript' src='/home/js/controls/selectWidget.js'></script>
<script type='text/javascript' language='JavaScript' src='/home/js/controls/radioWidget.js'></script>
<script type='text/javascript' language='JavaScript' src='/home/js/controls/textboxWidget.js'></script>
<script type='text/javascript' language='JavaScript' src='/home/js/controls/textareaWidget.js'></script>
<script type='text/javascript' language='JavaScript' src='/home/js/popuphandler.js'></script>
<script type='text/javascript' language='JavaScript' src='/home/js/effects.js'></script>
<script type='text/javascript' language='JavaScript' src='/home/js/fbevent/fbntslogin.js'></script>


</body>
</html>