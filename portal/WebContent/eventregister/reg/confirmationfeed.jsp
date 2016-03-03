<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbeepartner.partnernetwork.PartnerLinks" %>
<%@ page import="org.eventbee.sitemap.util.Presentation" %>
<%@ page import="com.eventbee.event.EventDB" %>
<%@ page import="java.util.Vector,java.util.HashMap" %>

<%!
public String getConfirmationEventinfo(String groupid){
	HashMap eventinfoMap=EventDB.getMgrEvtDetails(groupid);
	String startdate=(String)eventinfoMap.get("eventstartdate")+", "+(String)eventinfoMap.get("starttime");
	String enddate=(String)eventinfoMap.get("eventenddate")+", "+(String)eventinfoMap.get("endtime");
	String address=GenUtil.getCSVData(new String[]{(String)eventinfoMap.get("city"),(String)eventinfoMap.get("state"), (String)eventinfoMap.get("country")});
	StringBuffer evtinfo=new StringBuffer("<br><b>When:</b> ");
	evtinfo.append(startdate);
	evtinfo.append(" to ");
	evtinfo.append(enddate);
	evtinfo.append("<br><b>Where:</b> ");
	evtinfo.append(address);
	return evtinfo.toString();
}
%>
<%
String eventid=Presentation.GetRequestParam(request,  new String []{"eid","eventid", "id","groupid","gid"});
String linkpath="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com")+"/home/links";
String isntsenabled=DbUtil.getVal("select enablenetworkticketing from group_agent_settings where groupid=? ",new String [] {eventid});
String commission=DbUtil.getVal("select max(networkcommission) from price where evt_id=?",new String[]{eventid});	
commission="$"+commission;

String event_name=DbUtil.getVal("select eventname from eventinfo where eventid=?", new String [] {eventid});
	String username=DbUtil.getVal("select getMemberPref(mgr_id||'','pref:myurl','') as username from eventinfo where eventid=?", new String [] {eventid});
	String uid=request.getParameter("uid");
	
	String ebeeid=DbUtil.getVal("select ebeeid from ebee_fb_link where fbid=?",new String[]{uid});
	String pid=DbUtil.getVal("select partnerid from group_partner where userid=?",new String[]{ebeeid});

	String pattserver=ShortUrlPattern.get(username); 
	String eventurl=pattserver+"/event?eid="+eventid+"&pid="+pid+"&fid=1";
	PartnerLinks pl=new PartnerLinks();
	String config_id="0";
		String fbconnapi=(String)session.getAttribute("FBCONNECTAPIKEY");
		
		if(fbconnapi==null){
			fbconnapi=DbUtil.getVal("select value from config where name='ebee.fbconnect.api' and config_id=?",new String[]{"0"});
			session.setAttribute("FBCONNECTAPIKEY", fbconnapi);
		}
	String eventinfo= getConfirmationEventinfo(eventid);
	String bundleid="111355616645";
	String eventbeeurl="http://www.eventbee.com";
	String configid="select config_id from eventinfo where eventid=?";
	String confid=DbUtil.getVal(configid, new String[]{eventid});
	String imageurl=DbUtil.getVal("select value  from config where name='eventpage.logo.url' and config_id=?",new String[]{confid});
	if(imageurl==null) imageurl="";	
	GenUtil.getEncodedXML(imageurl);
%>
<style>

.FB_ImgLogoContainer{position:relative;width:50px;height:45px;display:block;float:left;}
 img.FB_ImgLogo{height:15px;width:15px;bottom:0;right:0;position:absolute;margin:0;}

</style>

<table class='portaltable' cellpadding="0" cellspacing="0" width="100%">

<tr>
<td  class="evenbase">
<span id="fbusername"></span>
</td>
</tr>
<tr>
<td align="center" class="evenbase">
<span  class='FB_ImgLogoContainer' id="fbprofile_pic"></span>			
</td>
</tr>
<tr>
<td  class='evenbase'><%if("Yes".equals(isntsenabled)){%>
		  Let your Facebook friends know that you are attending this event by clicking the button below. Moreover, get paid upto <%=commission%> on each ticket purchase made by your Facebook friends! Powered by Eventbee Network Ticket Selling [<a href="javascript:popupwindow('<%=linkpath%>/networkticketselling.html','Tags','600','400')">?</a>].
		  <%}else{%>
		  Let your Facebook friends know that you are attending this event by clicking the button below.
		  <%}%>
</td>
</tr>

<tr>
<td  class='evenbase' align="center">
<input type="button" value="Publish to Facebook" onclick="Confirmationpagefeed('<%=imageurl%>','<%=event_name%>','<%=eventinfo%>','<%=eventurl%>','<%=bundleid%>','<%=eventbeeurl%>');">
<img src="http://wiki.developers.facebook.com/images/b/bf/Connect_white_small_short.gif"/>
</td>
</tr>
</table>
