<%@ page import="java.util.*,com.eventbee.general.*" %>
<%@ page import="java.util.*,com.eventregister.TicketsDB" %>
<%@ page import="com.eventbee.cachemanage.CacheManager" %>

<%!
final String themeQuery="select themetype,themecode from user_roller_themes where refid=? and module=?";
HashMap getThemeCodeAndType(String refid){
HashMap hm=new HashMap();
DBManager db=new DBManager();
StatusObj sb=db.executeSelectQuery(themeQuery,new String[]{refid,"event"});
if(sb.getStatus())
{
hm.put("themetype",db.getValue(0,"themetype",""));
hm.put("themecode",db.getValue(0,"themecode",""));
}
return hm;
}
%>

<%

String csscontent=null;
String themetype=null;
String themecode=null;
String eid=request.getParameter("eid");
String trackcode=request.getParameter("track");
String customtheme=request.getParameter("customtheme");
String regtype=request.getParameter("registrationtype");
String eventname="",eventwhere="",eventwhen="";
DBManager db=new DBManager();
StatusObj sb=db.executeSelectQuery("select to_char(start_date+cast(cast(to_timestamp(COALESCE(starttime,'00'),'HH24:MI:SS') as text) as time ),'DD Mon YYYY, HH12:MI AM') ||' to '|| to_char(end_date+cast(cast(to_timestamp(COALESCE(endtime,'00'),'HH24:MI:SS') as text) as time ),'DD Mon YYYY, HH12:MI AM')  as when,eventname, CASE WHEN venue!='' THEN venue ||',' ELSE '' END ||  CASE WHEN address1!='' THEN address1 ||' ' ELSE '' END || CASE WHEN address2 !='' THEN address2 ||', ' ELSE '' END || CASE WHEN city!='' THEN city ||'.' ELSE '.' END as where  from eventinfo where eventid=CAST(? AS BIGINT)",new String[]{eid});
if(sb.getStatus()){
	eventname=db.getValue(0,"eventname","");
	eventwhere=db.getValue(0,"where","");
	eventwhen=db.getValue(0,"when","");
}
HashMap themeDetails=getThemeCodeAndType(eid);
if(themeDetails!=null){
themetype=(String)themeDetails.get("themetype");
themecode=(String)themeDetails.get("themecode");
}
String domain=request.getParameter("context");
if("no".equals(customtheme) && "CUSTOM".equals(themetype)){
	csscontent=DbUtil.getVal("select cssurl  from ebee_roller_def_themes where module =? and themecode=?",new String[]{"event","basic"});
}
else{
	if("DEFAULT".equals(themetype))
		csscontent=DbUtil.getVal("select cssurl  from ebee_roller_def_themes where module =? and themecode=?",new String[]{"event",themecode});
	else if("CUSTOM".equals(themetype))
		csscontent=DbUtil.getVal("select cssurl  from user_custom_roller_themes where refid=?",new String[]{eid});
	else{
		csscontent=DbUtil.getVal("select cssurl  from user_customized_themes where themeid=? and module='event'",new String[]{themecode});
	}
}
String template="";
java.util.Date d=new java.util.Date();

String scriptTag="<link rel='stylesheet' type='text/css' href='http://www.eventbee.com/home/css/popupcss.css' />"
+"<link rel='stylesheet' type='text/css' href='/home/css/seating.css' />"
+"<link rel='stylesheet' type='text/css' href='/home/js/YUI//build/container/assets/container.css' />"
+"<script type='text/javascript' language='JavaScript' src='/home/js/YUI/build/yahoo-dom-event/yahoo-dom-event.js'></script>"
+"<script type='text/javascript' language='JavaScript' src='/home/js/YUI/build/animation/animation-min.js'></script>"
+"<script type='text/javascript' language='JavaScript' src='/home/js/YUI/build/container/container-min.js'></script>"
+"<script type='text/javascript' language='JavaScript' src='/home/js/jQuery.js'></script>"
+"<script type='text/javascript' language='JavaScript' src='/home/js/advajax.js'>function dummy() { }</script>"
+"<script type='text/javascript' language='JavaScript' src='/home/js/Tokenizer.js'></script>"
+"<script type='text/javascript' language='JavaScript' src='/home/js/popup.js'></script>"
+"<script type='text/javascript' language='JavaScript' src='/home/js/popuphandler.js'></script>"
+"<script type='text/javascript' language='JavaScript' src='/home/js/eventlinks.js'></script>"
+"<script type='text/javascript' language='JavaScript' src='/home/js/tktWedget.js'></script>"
+"<script type='text/javascript' language='JavaScript' src='/home/js/controls/ctrlData.js'></script>"
+"<script type='text/javascript' language='JavaScript' src='/home/js/controls/checkboxWidget.js'></script>"
+"<script type='text/javascript' language='JavaScript' src='/home/js/controls/selectWidget.js'></script>"
+"<script type='text/javascript' language='JavaScript' src='/home/js/controls/radioWidget.js'></script>"
+"<script type='text/javascript' language='JavaScript' src='/home/js/controls/textboxWidget.js'></script>"
+"<script type='text/javascript' language='JavaScript' src='/home/js/controls/buildcontrol.js'></script>"
+"<script type='text/javascript' language='JavaScript' src='/home/js/controls/textareaWidget.js'></script>"
+"<script src='/home/js/widget/iFrameserverside.js' type='text/javascript'></script>"
+"<script src='/home/js/widget/iframehelper.js' type='text/javascript'></script>"
+"<script type='text/javascript' language='JavaScript' src='/home/js/popup.js'></script>"               
+"<script type='text/javascript' language='JavaScript' src='/home/js/prototype.js'></script>"
+"<script type='text/javascript' language='JavaScript' src='/home/js/controls/textareaWidget.js'></script>"
+"<script type='text/javascript' language='javascript' src='/home/js/effects.js'></script>"
+"<script type='text/javascript' src='/home/js/seating/generateseating.js?timestamp="+d.getTime()+"'></script>"
+"<script language='javascript' src='/home/js/webintegration.js'>function dummy(){}</script>"
+"<script type='text/javascript' language='JavaScript' src='/home/js/ajax.js'>function ajaxdummy(){ }</script>"
+"<script language='JavaScript' type='text/javascript' src='/home/js/fbconnect.js' >function dummyfbconnect()"
+" { }</script>"
+"<script type='text/javascript' language='JavaScript' src='/home/js/registration.js?timestamp="+d.getTime()+"'></script>"
+"<script type='text/javascript' language='JavaScript' src='/home/js/rsvpreg.js?timestamp="+d.getTime()+"'></script>"
+"<script type='text/javascript' language='JavaScript' src='/home/js/fbevent/shareonfacebook.js?timestamp="+d.getTime()+"'></script>";


HashMap configMap=(HashMap)CacheManager.getData(eid, "ticketsettings").get("configmap");
if("mobile".equals(regtype)){
csscontent="<link rel='stylesheet' type='text/css' href='http://www.eventbee.com/home/css/popupcss.css' />";
template=DbUtil.getVal("select content from default_reg_flow_templates where purpose=? and lang=?",new String[]{"phoneWidgetPage",GenUtil.getHMvalue(configMap,"event.i18n.lang","en_US")});
scriptTag=scriptTag+"<script type='text/javascript' src='/home/js/seating/generateseatingmobile.js?timestamp="+d.getTime()+"'></script>"+"<script type='text/javascript' language='JavaScript' src='/home/js/mobileregistration.js?timestamp="+d.getTime()+"'></script>"
+"<script src='/home/js/jQtouch/jqt.autotitles.js' type='application/x-javascript' charset='utf-8'></script><script src='/home/js/jQtouch/jqt.floaty.js' type='application/x-javascript' charset='utf-8'></script>";
}
else{
template=DbUtil.getVal("select content from default_reg_flow_templates where purpose=? and lang=?",new String[]{"widgetPage",GenUtil.getHMvalue(configMap,"event.i18n.lang","en_US")});
scriptTag=scriptTag+"<script type='text/javascript' src='/home/js/seating/generateseating.js?timestamp="+d.getTime()+"'></script>"+"<script type='text/javascript' language='JavaScript' src='/home/js/registration.js?timestamp="+d.getTime()+"'></script>";
}
String eventlevelvariable="<input type='hidden'  name='context'  id='context'  value='"+domain+"' /><input type='hidden' value='"+trackcode+"' id='trackcode' name='trackcode'><input type='hidden' value='"+regtype+"' id='registrationtype' name='registrationtype'>";
eventlevelvariable=eventlevelvariable+"<div style='display:none' id='eventname'>"+eventname+"</div><div id='fb-description' style='display:none;'>When: "+eventwhen+".&nbsp;Where: "+eventwhere+"</div>";
TicketsDB ticketInfo=new TicketsDB();
//HashMap configMap=ticketInfo.getConfigValuesFromDb(eid);

boolean isrecurringevent=("Y".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.recurring","N")));
boolean registrationAllowed=("Yes".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.poweredbyEB","no")));
boolean isrsvpd=("Yes".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.rsvp.enabled","no")));

%>