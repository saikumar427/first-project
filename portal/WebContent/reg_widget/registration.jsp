<%@page import="java.awt.Color"%>
<%@page import="com.eventbee.regcaheloader.LayoutManageLoader"%>
<%@page import="com.eventbee.cachemanage.CacheLoader"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.eventbee.cachemanage.CacheManager"%>
<%@ page import="com.eventbee.general.DbUtil,com.eventbee.general.EbeeConstantsF,com.eventbee.general.GenUtil,com.eventbee.general.EbeeCachingManager" %>
<%@ page import="com.eventregister.TicketsDB,java.util.HashMap,com.eventbee.general.EventbeeLogger" %>
<%@ page import="com.eventbee.general.StatusObj,com.eventbee.general.DBManager, com.eventpageloader.*,com.eventregister.RegistrationDBHelper,java.net.URI,java.net.URISyntaxException"%>
<%@include file="../getresourcespath.jsp" %>
<%@ page import="com.eventbee.layout.DBHelper" %>
<%!

public static String getDomainNameUrl(String url)  {
                    String domain ="";
				  try{
				  URI uri = new URI(url);
                   domain = uri.getHost();
                   System.out.println("the sehema is::"+uri.getScheme()+"://"+domain);
				   domain=uri.getScheme()+"://"+domain;
                   return   domain;
				  }catch(Exception e){}
				   return domain;
				  }
%>

<%
String csscontent=null,recurdateslabel="";

String fb=request.getParameter("fb");
if(fb==null)fb="false";
System.out.println("fb::"+fb);
String eid=request.getParameter("eid");
String trackcode=request.getParameter("track");
String display_ntscode=request.getParameter("nts");
String disc=request.getParameter("code");
String tc=request.getParameter("tc");
String customtheme=request.getParameter("customtheme");
String reqref=request.getParameter("referal");
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com")+"/";
String Referer=request.getHeader("Referer");
EventbeeLogger.log("com.eventbee.widgetref",EventbeeLogger.INFO,"REGISTRATION.JSP", "widgetReferer::"+eid+" by ::"+Referer,"", null);


HashMap eventinfoMap=null;
HashMap blockedEventsMap=(HashMap)EbeeCachingManager.get("blockedEvents");
if(blockedEventsMap==null){
	blockedEventsMap=new HashMap();
	EbeeCachingManager.put("blockedEvents",blockedEventsMap);
}
if(eid==null || "".equals(eid)){
	System.out.println("Event Page(widget) with no eventid: ");
	response.sendRedirect("/guesttasks/invalidpage.jsp");
	return;
}else {
	if(blockedEventsMap.get(eid)!=null){
		String cancelby=(String)blockedEventsMap.get(eid+"_cancelby");
		if(cancelby==null)cancelby="";	
		if("hightraffic".equals(cancelby)){}
		else{
			System.out.println("Event Page(widget) with blocked eventid: "+eid);
			response.sendRedirect("/guesttasks/invalidpage.jsp");
			return;
		}
	}	
	try{
	int eventid=Integer.parseInt(eid);
	eventinfoMap=EventPageContent.getEventDetailsFromDb(eid);
	if(eventinfoMap==null || eventinfoMap.size()<1 ){
		String userid=DbUtil.getVal("select userid from user_groupevents where event_groupid =?" ,new String[]{eid});
		if(userid==null){
		System.out.println("Event Page(widget) with wrong eventid: "+eid);	
		response.sendRedirect("/guesttasks/invalidpage.jsp");
		return;
		}else{
			session.setAttribute("eventgroupid",eid);
			request.setAttribute("userid",userid);
			response.sendRedirect("/customevents/groupThemeProcessor.jsp?groupid="+eid);
			return;
		}
	}
	}catch(Exception e){
		System.out.println("Event Page(widget) with wrong eventid: "+eid);	
		response.sendRedirect("/guesttasks/invalidpage.jsp");
		return;
	}
	}
	request.setAttribute("eventinfohm",eventinfoMap);
	String eventstatus=EventPageContent.getEventInfoForKey("status",request,"ACTIVE");
		String cancelby=EventPageContent.getEventInfoForKey("cancel_by",request,"");
	if("CANCEL".equals(eventstatus)){
		blockedEventsMap.put(eid,"Y");
		blockedEventsMap.put(eid+"_cancelby",cancelby);
		if("hightraffic".equals(cancelby)){}
		else{
		System.out.println("Event Page(widget) with cancelled eventid: "+eid);	
		response.sendRedirect("/guesttasks/invalidpage.jsp");
		return;
		}
	}
//HashMap themeDetails=getThemeCodeAndType(eid);

String notavail=null,unassign=null;
/* if(themeDetails!=null && themeDetails.size()>0){
themetype=(String)themeDetails.get("themetype");
themecode=(String)themeDetails.get("themecode");
} */

String domain=request.getParameter("context");
/* if("no".equals(customtheme) && ("CUSTOM".equals(themetype) || "PERSONAL".equals(themetype))){
     if("true".equals(fb))themecode="ebee-basic-grey";
	csscontent=DbUtil.getVal("select cssurl  from ebee_roller_def_themes where module =? and themecode=?",new String[]{"event","basic"});
}
else{
	if("DEFAULT".equals(themetype)||"true".equals(fb))
	{     if("true".equals(fb))themecode="ebee-basic-grey";
	csscontent=DbUtil.getVal("select cssurl  from ebee_roller_def_themes where module =? and themecode=?",new String[]{"event",themecode});
	}	
	else if("CUSTOM".equals(themetype))
		csscontent=DbUtil.getVal("select cssurl  from user_custom_roller_themes where refid=?",new String[]{eid});
	else{
		csscontent=DbUtil.getVal("select cssurl  from user_customized_themes where themeid=? and module='event'",new String[]{themecode});
	}
} */


if(!CacheManager.getInstanceMap().containsKey("layoutmanage")){
	CacheLoader layoutManage=new LayoutManageLoader();
	layoutManage.setRefreshInterval(3*60*1000);
	layoutManage.setMaxIdleTime(3*60*1000);
	CacheManager.getInstanceMap().put("layoutmanage",layoutManage);		
}

if(CacheManager.getData(eid, "layoutmanage")==null || CacheManager.getInitStatus(eid+"_layoutmanage")){
	request.getRequestDispatcher("eventpageloading.jsp").forward(request, response);
	return ;
}

String jsonData="";
Map layoutManageMap=new HashMap();

layoutManageMap=CacheManager.getData(eid, "layoutmanage");
jsonData = (String)layoutManageMap.get("layout");

//System.out.println("all content::"+jsonData);
JSONObject layout = new JSONObject(jsonData);


JSONObject global_style = layout.getJSONObject("global_style");

String bodyBackgroundImage = global_style.getString("bodyBackgroundImage");
String bodyBackgroundColor = global_style.getString("bodyBackgroundColor");
String bodyBackgroundPosition = global_style.getString("backgroundPosition");
 
String coverPhoto = global_style.getString("coverPhoto");
String titleColor = global_style.getString("title");
String backgroundRgba = global_style.getString("contentBackground");
String logoURL="",logoMsg="";
if(global_style.has("logourl"))
	logoURL=global_style.getString("logourl");
if(global_style.has("logomsg"))
	logoMsg=global_style.getString("logomsg");
String backgroundHex = backgroundRgba.split("rgba")[1];
backgroundHex = backgroundHex.substring(1, backgroundHex.length()-1);
int r = Integer.parseInt(backgroundHex.split(",")[0]);
int g = Integer.parseInt(backgroundHex.split(",")[1]);
int b = Integer.parseInt(backgroundHex.split(",")[2]);
Color color = new Color(r,g,b);
backgroundHex = "#"+Integer.toHexString(color.getRGB()).substring(2);
String backgroundOpacity = backgroundRgba.split(",")[3];
backgroundOpacity = backgroundOpacity.substring(0, backgroundOpacity.length()-1);
String details = global_style.getString("details");
String header = global_style.getString("header");
String headerText = global_style.getString("headerText");
String border = global_style.getString("border");
String content = global_style.getString("content");
String contentText = global_style.getString("contentText");

String headerTextFont="Verdana";
String headerTextSize="16";
String contentTextSize = "14";
String contentTextFont = "Verdana";

if(global_style.has("headerTextFont"))
	headerTextFont = global_style.getString("headerTextFont");
if(global_style.has("headerTextSize"))
	headerTextSize = global_style.getString("headerTextSize");
if(global_style.has("contentTextSize"))
	contentTextSize = global_style.getString("contentTextSize");
if(global_style.has("contentTextFont"))
	contentTextFont = global_style.getString("contentTextFont");

JSONObject radius = new JSONObject(global_style.getString("radius"));
String topLeft = radius.getString("topLeft");
String topRight = radius.getString("topRight");
String bottomLeft = radius.getString("bottomLeft");
String bottomRight = radius.getString("bottomRight");







TicketsDB ticketInfo=new TicketsDB();
HashMap configMap=ticketInfo.getConfigValuesFromDb(eid);
boolean isrecurringevent=("Y".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.recurring","N")));
boolean registrationAllowed=("Yes".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.poweredbyEB","no")));
boolean isrsvpd=("Yes".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.rsvp.enabled","no")));
String isseatingevent=GenUtil.getHMvalue(configMap,"event.seating.enabled","NO");
String venueid=GenUtil.getHMvalue(configMap,"event.seating.venueid","0");
String fbsharepopup=GenUtil.getHMvalue(configMap,"event.confirmationpage.fbsharepopup.show","Y");
String isPriority=GenUtil.getHMvalue(configMap,"event.priority.enabled","N");

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
}
if(display_ntscode==null)
	display_ntscode="";	

	if(!"".equals(display_ntscode)){
	
       String nts=DbUtil.getVal("select nts_code from ebee_nts_partner where nts_code=?",new String[]{display_ntscode});
    	System.out.println("#visit with nts code#:"+display_ntscode+"*nts*"+nts+"eventid: "+eid);
		
		 if(!"".equals(nts)&& nts!=null)
		{     
		        if(session.getAttribute(eid+"ntsclick"+display_ntscode)==null)
				{  	   RegistrationDBHelper regdbhelper=new RegistrationDBHelper();
					   referral_ntscode= regdbhelper.ValidateNTSCode(eid,display_ntscode);
					   System.out.println("*ntsclick count*:"+display_ntscode);
					   session.setAttribute(eid+"ntsclick"+display_ntscode,display_ntscode);
				}
	        referral_ntscode=nts;
	    }

if(referral_ntscode==null )
	referral_ntscode="";
}




String fbappid=DbUtil.getVal("select value from config where config_id='0' and name='ebee.fbconnect.appid'",null);

if(trackcode!=null){
	HashMap trackshm=EventPageContent.getTrackURLContet(eid,trackcode);
	if(trackshm.size()>0){
	session.setAttribute("trckcode",trackcode);
	request.setAttribute("Trackshm",trackshm);

	String status=EventPageContent.getTrackInfoForKey("status",request,"");
if(!"Suspended".equals(status)){
boolean trackURLsession=(session.getAttribute(eid+"_"+trackcode)==null);
	if(trackURLsession){
	session.setAttribute(eid+"_"+trackcode,trackcode);
	//DbUtil.executeUpdateQuery("update trackURLs set count=to_number(nvl(count,null,0),'9999999999')+1 where trackingcode=? and eventid=?",new String[]{trackcode,eid});
	DbUtil.executeUpdateQuery("update trackurls set count=cast(coalesce(cast(count as numeric),0) as numeric)+1 where trackingcode=? and eventid=?",new String[]{trackcode,eid});
	}
}
else{
trackcode=null;
}
}
else{
trackcode=null;
}
}
if(isrecurringevent){
/* if(!"".equals(eid) && eid!=null){
	recurdateslabel=DbUtil.getVal("select attrib_value from custom_event_display_attribs where  module='RegFlowWordings' and attrib_name='event.reg.recurringdates.label' and eventid=CAST(? as BIGINT)", new String[]{eid});
	if(recurdateslabel==null || "".equals(recurdateslabel)){
		String lang=DBHelper.getLanguageFromDB(eid);
		recurdateslabel=DbUtil.getVal("select attrib_value from default_event_display_attribs where  module='RegFlowWordings' and attribname='event.reg.recurringdates.label' and lang=?",new String[]{lang});
	}
} */
String lang="en_US";
if(!"".equals(eid) && eid !=null) lang=DBHelper.getLanguageFromDB(eid);
HashMap<String,String> disAttribsForKeys=new HashMap<String,String>();
recurdateslabel=DisplayAttribsDB.getAttribValuesForKeys(eid, "RegFlowWordings", lang, new String [] {"event.reg.recurringdates.label"}).get("event.reg.recurringdates.label");
System.out.println("in recurring loop");
}
if("".equals(recurdateslabel))recurdateslabel="Select a date and time to attend";
%>


<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src='/home/js/i18n/<%= DBHelper.getLanguageFromDB(eid)%>/regprops.js'></script>
<link rel='stylesheet' type='text/css' href='/home/css/seating.css' />
<link rel='stylesheet' type='text/css' href='/home/css/popupcss.css' />
<style>
<%-- <%

	try{
		csscontent=csscontent.replaceAll("\\$resourcesAddress", resourceaddress);
		csscontent=csscontent.replaceAll("url\\(/home", "url\\("+resourceaddress+"/home");
		csscontent=csscontent.replaceAll("url\\(/main", "url\\("+resourceaddress+"/main");
		csscontent=csscontent.replaceAll("url\\(\"/main", "url\\(\""+resourceaddress+"/main");
	}catch(Exception e){
		System.out.println("Exception occured while replacing csscontent in widget for event ::"+eid+" :: "+e.getMessage());
	}
%> --%>
<%-- <%=csscontent%> --%>

body{
background:<%=content%> !important;
margin: 0 0 0 0;
#font-family:Avenir Next;
border: 1px solid <%=border%>;
}

table{
	color:<%=contentText%>;
	font-family:<%=contentTextFont%>;
	font-size:<%=contentTextSize%>px;
}


#container {
/*width:700px;*/
width:100%;
color:black;
margin:0 auto;
border-top:0;
padding:0;
text-align:left;
}

#container{
border-bottom:none !important; 
}

.ebeepopup{
	left:10%;
}
.ticket_timer {
right:300px;
}
/* body
{
background:none;
} */
.hrline{
	border: 0;
    height: 1px;
    background-image: -webkit-linear-gradient(left, rgba(0,0,0,0), <%=border%>, rgba(0,0,0,0)); 
    background-image:    -moz-linear-gradient(left, rgba(0,0,0,0), <%=border%>, rgba(0,0,0,0)); 
    background-image:     -ms-linear-gradient(left, rgba(0,0,0,0), <%=border%>, rgba(0,0,0,0)); 
    background-image:      -o-linear-gradient(left, rgba(0,0,0,0), <%=border%>, rgba(0,0,0,0));
}

.rsvp-submit-btn{	
	color: #fff;
    background-color: #337ab7;
    border-color: #2e6da4;
	display: inline-block;
    padding: 5px 10px;
    margin-bottom: 0;
    font-size: 12px;
    font-weight: 400;
    line-height: 1.5;
    text-align: center;
    white-space: nowrap;
    vertical-align: middle;
	touch-action: manipulation;
    cursor: pointer;
    border: 1px solid transparent;
    border-radius: 3px;
}
.rsvp-submit-btn:hover{
	background-color: #3c60AA;
}
</style>
<%if("YES".equals(isseatingevent)){ 
notavail=DbUtil.getVal("select image from venue_seating_images where venue_id=CAST(? AS BIGINT) and context='notavailable'",new String[]{venueid});	
unassign=DbUtil.getVal("select image from venue_seating_images where venue_id=CAST(? AS BIGINT) and context='unassign'",new String[]{venueid});		
%>
<link rel='stylesheet' type='text/css' href='/main/build/container/assets/container.css' />
<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/main/build/yahoo-dom-event/yahoo-dom-event.js'></script>
<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/main/build/container/container-min.js'></script>
<%
String venuecss=DbUtil.getVal("select layout_css from venue_sections where venue_id=to_number(?,'9999999999999')",new String[]{venueid});
if(venuecss!=null && !"".equals(venuecss)){%>
			<style type='text/css'><%=venuecss%></style>
<%}}%>
<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/home/js/jQuery.js'></script>
<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/home/js/seating/jquery-ui-1.8.10.custom.min.js'></script>
<script>
var refere='<%=Referer%>';
</script>
<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/home/js/tktWedget.js'></script>
<script src='<%=resourceaddress%>/home/js/widget/iframehelper.js' type='text/javascript'></script>
<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/home/js/prototype.js'></script>
<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/home/js/ajax.js' defer>function ajaxdummy(){ }</script>
<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/main/js/registration/registration.js'></script>
<%if("Y".equals(isPriority))%>
<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/main/js/registration/registration/priority_reg.js'></script>
<%if(isrsvpd){%>
<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/home/js/rsvpreg.js'></script>
<%}else{%>
	<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/main/js/registration/registration/tickets_registration.js'></script>
	<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/main/js/registration/common/tickets_common.js'></script>
	<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/main/js/registration/common/seating/getseatingsection_common.js'></script>
	<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/main/js/registration/common/hold_js.js' defer></script>
	<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/home/js/Tokenizer.js' defer></script>
	<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/home/js/advajax.js' defer>function dummy() { }</script>
	<%if("YES".equals(isseatingevent)){%>
	<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/main/js/registration/common/seating/getseatingsection_common.js'></script>
	<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/main/js/registration/registration/seating/getseatingsection_registration.js'></script>
	<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/main/js/registration/common/seating/generateseating_common.js'></script>
	<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/main/js/registration/registration/seating/generateseating_registration_v3.js'></script>
	<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/main/js/registration/common/seating/seatingtimer_common.js'></script>
	<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/main/js/registration/registration/seating/seatingtimer_registration.js'></script>
	<%}
}%>	
<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/home/js/ebeepopup.js'></script>
</head>
<body >
<div id='backgroundPopup' ></div>
<ul id="leftList"  style="margin:0px; padding:0px;" width="600px;">
<script defer>
var servadd='<%=serveraddress%>';
var ebeepopup=new ebeepopupwindow("ebeecustpopup","ebeepopup");
jQuery(document).ready(function() { ebeepopup.init();});
iframeQuantity = 50;
oldHeight = 0;
scrollIframe = false;
oldScrollIframe = false;
//document.body.style["overflow-x"]= "hidden";
document.body.style["overflow-y"] = "auto";
document.body.style="word-wrap: break-word;overflow-x:hidden;overflow-y:auto;";
</script>



<div id='container' class='widgetcontainer'>
<!--<table   id='container' class='widgetcontainer'>-->
<table width="100%"  valign="top" cellpadding="0" cellspacing="0" class='widgetcontainer'>

<tr><td>
<%if(disc!=null && !"".equals(disc)){%>
<input type='hidden' name='couponcode'  value='<%=disc%>'>
<%}%>
<input type='hidden' name='context' id='context' value='<%=domain%>'>
<input type='hidden' name='trackcode' id='trackcode' value='<%=trackcode%>'>
<input type='hidden' name='venueid' id='venueid' value='<%=venueid%>'>
<input type='hidden' name='isseatingevent' id='isseatingevent' value='<%=isseatingevent%>'>
<%if(notavail!=null){ %>
<input type='hidden' name='notavailimage' id='notavailimage' value='<%=notavail%>'>
<%}
if(unassign!=null){%>
<input type='hidden' name='unassign' id='unassign' value='<%=unassign%>'>
<%}%>

<%if(tc!=null && !"".equals(tc)){%>
<input type='hidden'  id='ticketurlcode' value='<%=tc%>'>
<%}%>
<input type='hidden' name='fbsharepopup' id='fbsharepopup' value='<%=fbsharepopup%>'>
<input type='hidden' name='registrationsource' id='registrationsource' value='widget'>
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

<table width="100%" class="leftboxcontent">
<div id="prioerror"></div>
<%if(isrsvpd){%>
    <tr><td id="rsvpreg"></td></tr>
     <tr><td id="rsvpprofilecontent"></td></tr>
	 <tr><td id="rsvpimageLoad" align="center"></td></tr>
	 <%if("Y".equals(isPriority)){%>
		<script>getPriorityRegistration("<%=eid%>",'RSVP');</script>
	<%}else{%>
	 	<script>getRsvpOptionsBlock("<%=eid%>")</script>
	 <%}%>

<%}else{
if(isrecurringevent){%>
<%@ include file='/customevents/recurring.jsp' %>
<%
//String recurringselect=ticketInfo.getRecurringEventDates(eid,"tickets");
TicketsDBZ tktdb=new TicketsDBZ();
String recurringselect=tktdb.getRecurringEventDates(eid,"tickets");
	if(recurringselect==null)
		recurringselect="<select onchange=getTicketsJson('"+eid+"'); id='eventdate' name='eventdate'></select>";
%>
<tr><td><%=recurdateslabel%>: <%=recurringselect%> </td></tr>
<%}%>
<tr><td id="registration"></td></tr>
<tr><td id="profile"></td></tr>
<tr><td id="paymentsection"></td></tr>
<tr><td id="imageLoad" align="center"></td></tr>
<%if("Y".equals(isPriority)){%>
<script>getPriorityRegistration("<%=eid%>",'Ticketing');</script>
<%}else{%>
<script>getTicketsJson("<%=eid%>");</script>
<%}
}%>



</table></div>

</td></tr></table>
</div>
</ul>
<!--
<script>getJsonFormat();</script>-->
<%if(!isrsvpd){%>
		<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/main/js/registration/common/profile_common.js' ></script>
		<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/main/js/registration/registration/profile_registration.js' ></script>
		<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/main/js/registration/common/payments_common.js' ></script>
		<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/main/js/registration/registration/payments_registration.js' ></script>
		<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/main/js/registration/common/confirmation_common.js' ></script>
		<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/main/js/registration/registration/confirmation_registration.js'></script>
		<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/home/js/controls/buildcontrol.js' defer></script>
		<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/home/js/controls/ctrlData.js' defer ></script>
		<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/home/js/controls/checkboxWidget.js' defer></script>
		<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/home/js/controls/selectWidget.js' defer></script>
		<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/home/js/controls/radioWidget.js' defer></script>
		<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/home/js/controls/textboxWidget.js' defer></script>
		<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/home/js/controls/textareaWidget.js' defer></script>
<%}else{%>
		<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/home/js/controls/buildcontrol.js'></script>
		<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/home/js/controls/ctrlData.js'></script>
		<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/home/js/controls/checkboxWidget.js'></script>
		<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/home/js/controls/selectWidget.js'></script>
		<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/home/js/controls/radioWidget.js'></script>
		<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/home/js/controls/textboxWidget.js'></script>
		<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/home/js/controls/textareaWidget.js'></script>
<%} %>

<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/home/js/popuphandler.js' defer></script>
<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/home/js/effects.js' defer></script>
<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/home/js/fbevent/shareonfacebook.js' defer></script>
<script type='text/javascript' language='JavaScript' src='<%=resourceaddress%>/home/js/fbevent/fbntslogin.js' defer></script>


<div id="generatedIFrames" style="display: none;"></div>
<script>window.setInterval(generateIFrames,100);</script>

<%if(disc!=null && !"".equals(disc)){%>
<script>
var disin;
function callDiscode(){
//console.log("disc"+disin)
if(document.getElementById('couponcode'))
{document.getElementById('couponcode').value='<%=disc%>';
getDiscountAmounts();
window.clearInterval(disin);
}}
disin=window.setInterval(callDiscode,100);
</script>
<%}%>
</body>
</html>
