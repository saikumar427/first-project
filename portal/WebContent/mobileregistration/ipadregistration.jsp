<%@ page import="com.eventbee.general.GenUtil" %>
<%@ page import="com.eventregister.TicketsDB,java.util.HashMap"%>
<%String eid=request.getParameter("eid");
String showtype=request.getParameter("showtype");
String username=request.getParameter("username");
String trackcode=request.getParameter("track");
String domain="web";
if(username==null)
username="";
//username="hemanth";
String useragent=request.getHeader("User-Agent");
if(useragent.indexOf("Safari")==-1 && useragent.indexOf("iPad")==-1){
	//response.sendRedirect("/event?eid="+eid);
	//return;
}
TicketsDB ticketInfo=new TicketsDB();
HashMap configMap=ticketInfo.getConfigValuesFromDb(eid);
boolean isrecurringevent=("Y".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.recurring","N")));
boolean registrationAllowed=("Yes".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.poweredbyEB","no")));
boolean isrsvpd=("Yes".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.rsvp.enabled","no")));
String isseatingevent=GenUtil.getHMvalue(configMap,"event.seating.enabled","NO");
String venueid=GenUtil.getHMvalue(configMap,"event.seating.venueid","0");

%>
<html>
<head>
<link rel='stylesheet' type='text/css' href='http://www.eventbee.com/home/css/popupcss.css' />
<link rel="stylesheet" type="text/css" media="screen" href="/home/css/jQtouch/jqtouch.css"/>
<link rel="stylesheet" type="text/css" media="screen" href="/home/css/jQtouch/themes/jqt/theme.css"/>
<link rel='stylesheet' type='text/css' href='/home/css/jQtouch/jqtseating.css' />
<%if("YES".equals(isseatingevent)){ %>
<link rel='stylesheet' type='text/css' href='/home/js/YUI//build/container/assets/container.css' />
<script type='text/javascript' language='JavaScript' src='/home/js/YUI/build/yahoo-dom-event/yahoo-dom-event.js'></script>
<script type='text/javascript' language='JavaScript' src='/home/js/YUI/build/container/container-min.js'></script>

<script type='text/javascript' language='JavaScript' src='/home/js/seating/jquery-ui-1.8.10.custom.min.js'></script>
<%}%>
<script type='text/javascript' language='JavaScript' src='/home/js/jQuery.js'></script>
<script src='/home/js/jQtouch/jqtouch.js' type='application/x-javascript' charset='utf-8'></script>
<script type='text/javascript' language='JavaScript' src='/home/js/tktWedget.js'></script>
<!--<script src='/home/js/widget/iframehelper.js' type='text/javascript'></script>-->
<script type='text/javascript' language='JavaScript' src='/home/js/prototype.js'></script>
<script type='text/javascript' language='JavaScript' src='/home/js/ajax.js'>function ajaxdummy(){ }</script>
<script type='text/javascript' language='JavaScript' src='/main/js/registration/registration.js'></script>
<%if(isrsvpd){%>
<script type='text/javascript' language='JavaScript' src='/home/js/mobilersvpreg.js'></script>
<%}else{%>
<script type='text/javascript' language='JavaScript' src='/main/js/registration/ipad/tickets_ipad.js'></script>
<script type='text/javascript' language='JavaScript' src='/main/js/registration/common/tickets_common.js'></script>
<%if("YES".equals(isseatingevent)){ %>
<script type='text/javascript' language='JavaScript' src='/main/js/registration/ipad/seating/getseatingsection_ipad.js'></script>
<script type='text/javascript' language='JavaScript' src='/main/js/registration/common/seating/getseatingsection_common.js'></script>
<script type='text/javascript' language='JavaScript' src='/main/js/registration/ipad/seating/generateseating_ipad.js'></script>
<script type='text/javascript' language='JavaScript' src='/main/js/registration/common/seating/generateseating_common.js'></script>
<script type='text/javascript' language='JavaScript' src='/main/js/registration/ipad/seating/seatingtimer_ipad.js'></script>
<script type='text/javascript' language='JavaScript' src='/main/js/registration/common/seating/seatingtimer_common.js'></script>
<%}%>
<%}%>    
 
</head>

<body>
<ul id="leftList"  style="margin:0px; padding:10px;">

<table   id="container"><tr><td>
<input type='hidden' name='context' id='context' value='<%=domain%>'>
<input type='hidden' name='trackcode' id='trackcode' value='<%=trackcode%>'>
<input type='hidden' name='venueid' id='venueid' value='<%=venueid%>'>
<input type='hidden' name='isseatingevent' id='isseatingevent' value='<%=isseatingevent%>'>
<input type='hidden' name='username' id='username' value='<%=username%>'>
<input type='hidden' name='registrationsource' id='registrationsource' value='iPad'>
<div id="box">
</div>

</td></tr></table>
<!--
#if ($recurreningSelect)
<table width="100%" class="tableborder"><tr><td height="10px;"></td></tr><tr style="padding:10px;"><td><span style="padding:10px;">Select a date and time to attend: $recurreningSelect</span></td></tr><tr><td height="10px;"></td></tr></table>
#end
-->
</ul>

<%if(isrsvpd){%>
	 <script>getRsvpOptionsBlock("<%=eid%>")</script>
<%}else{%>
<%if(isrecurringevent){%>
<table width="100%" class="tableborder"><tr><td height="10px;"></td></tr><tr style="padding:10px;"><td><span style="padding:10px;">Select a date and time to attend: <%=ticketInfo.getRecurringEventDates(eid,"tickets")%></span></td></tr><tr><td height="10px;"></td></tr></table>
<%}%>

<script>getTicketsJson("<%=eid%>");</script>
<%}%>
<%if(!isrsvpd){%>
<script type='text/javascript' language='JavaScript' src='/main/js/registration/ipad/profile_ipad.js'></script>
<script type='text/javascript' language='JavaScript' src='/main/js/registration/common/profile_common.js'></script>
<script type='text/javascript' language='JavaScript' src='/main/js/registration/ipad/payments_ipad.js'></script>
<script type='text/javascript' language='JavaScript' src='/main/js/registration/common/payments_common.js'></script>
<script type='text/javascript' language='JavaScript' src='/main/js/registration/ipad/confirmation_ipad.js'></script>
<script type='text/javascript' language='JavaScript' src='/main/js/registration/common/confirmation_common.js'></script>
<%}%>
<script type='text/javascript' language='JavaScript' src='/home/js/controls/buildcontrol.js'></script>
<script type='text/javascript' language='JavaScript' src='/home/js/controls/ctrlData.js'></script>
<script type='text/javascript' language='JavaScript' src='/home/js/controls/checkboxWidget.js'></script>
<script type='text/javascript' language='JavaScript' src='/home/js/controls/selectWidget.js'></script>
<script type='text/javascript' language='JavaScript' src='/home/js/controls/radioWidget.js'></script>
<script type='text/javascript' language='JavaScript' src='/home/js/controls/textboxWidget.js'></script>
<script type='text/javascript' language='JavaScript' src='/home/js/controls/textareaWidget.js'></script>
<script type='text/javascript' language='JavaScript' src='/home/js/popuphandler.js'></script>
<script type='text/javascript' language='JavaScript' src='/home/js/effects.js'></script>

</body>
</html>