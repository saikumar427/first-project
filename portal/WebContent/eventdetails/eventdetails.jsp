<%@ page import="java.util.*,com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.customconfig.*,com.eventbee.event.BeeletController,com.eventbee.editevent.*,com.eventbee.event.*" %>
<% com.eventbee.campaign.CampaignDB.insertCampaignClickThrough(request.getParameter("eid"),request.getParameter("GROUPID"),"ED");%>
<%
String groupid=request.getParameter("GROUPID");
try{Integer.parseInt(groupid);}
catch(Exception e){
	response.sendRedirect("/guesttasks/invalidpage.jsp");
	return;
}
String uname="";
String reqtype=request.getParameter("type");

String preview=request.getParameter("preview");
String headerhtml=request.getParameter("headerhtml");
String footerhtml=request.getParameter("footerhtml");
String context=request.getParameter("context");


boolean nouser=false;
if(!("000000".equals(groupid)|| "".equals(groupid)|| "0".equals(groupid))){
		uname=DbUtil.getVal("select getMemberPref(mgr_id||'','pref:myurl', '') as scrname from eventinfo where eventid=CAST(? AS INTEGER) ",new String[]{groupid});

		if(!"".equals(uname.trim() ) ){
			String redirectlink=ShortUrlPattern.get(uname)+"/event?eventid="+groupid;
			if(preview!=null)
				redirectlink+="&preview="+preview+"&headerhtml="+headerhtml+"&footerhtml="+footerhtml;
			if("attendeepage".equals(reqtype))
				redirectlink="/portal/customevents/attendeehandler.jsp?GROUPID="+groupid+"&context="+context;
			response.sendRedirect(redirectlink);
			return;
		}else
		nouser=true;

}
if(nouser){
%>
	<%@ include file="/main/tabsheader.jsp" %>
	

	<table border='0' cellpadding='0' cellspacing='0' width='100%'>
		<tr><td height='10'></td></tr>
		<tr><td align='center'>Information regarding this event is currently not available</td></tr>
		<tr><td height='10'></td></tr>
		<tr><td align='center'><input align='center' type='button' name='back' value='Back' onclick='javascript:history.back()'/></td></tr>
	</table>


	<%@ include file="/main/footer.jsp" %>

<%
	}
%>
