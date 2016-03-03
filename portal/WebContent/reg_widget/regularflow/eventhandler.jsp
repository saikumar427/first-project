<%@ page import="java.util.*,com.eventpageloader.*" %>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.eventregister.*" %>
<%@ page import="org.eventbee.sitemap.util.Presentation,com.eventbee.event.EventsContent" %>
<%@ page import="com.eventbee.authentication.*,java.net.urlEncode.*"%>
<%@ include file ='/customevents/eventpageloader.jsp' %>
<%
String groupid=Presentation.GetRequestParam(request,  new String []{"eid","eventid", "id","GROUPID","groupid","gid"});
String participantid=Presentation.GetRequestParam(request,  new String []{"pid","partnerid", "participantid","participant"});
String platform=request.getParameter("platform");
String report=request.getParameter("report");
String trackcode=null;
trackcode=request.getParameter("track");
String manage=request.getParameter("manage");
String register=request.getParameter("register");
String discountcode=request.getParameter("code");
if(discountcode==null)
	discountcode="";
String purpose=request.getParameter("purpose");
String ticketurlcode=request.getParameter("tc");
String context=request.getParameter("context");
/*
String useragent=request.getHeader("User-Agent");
if(useragent.indexOf("Safari")>-1 && useragent.indexOf("iPad")>-1){
	response.sendRedirect("/mobile?eid="+groupid);
	return;
}
*/
if(context==null)
context="EB";
session.setAttribute("context",context);
if("ning".equals(platform))
	session.setAttribute("platform","ning");
session.removeAttribute("trckcode");

if("register".equals(register)){
	response.sendRedirect("/event/register?eid="+groupid);
	return;
}
if("upgrade".equals(purpose)){
response.sendRedirect("/guesttasks/upgraderegistration.jsp?groupid="+groupid);
return;
}
if(session.getAttribute("EVENT_PASSWORD_AUTH_DONE_"+groupid)==null){
	String password=DbUtil.getVal("select password from view_security where eventid=?",new String[]{groupid});
	if(password!=null){
		if(session.getAttribute("EVENT_PASSWORD_AUTH_DONE_"+groupid)==null){
			response.sendRedirect("/guesttasks/eventpassword.jsp?"+request.getQueryString());
		return;
		}
	}
}
if(trackcode!=null){
	HashMap trackshm=EventPageContent.getTrackURLContet(groupid,trackcode);
	if(trackshm.size()>0){
	session.setAttribute("trckcode",trackcode);
	request.setAttribute("Trackshm",trackshm);

	String status=EventPageContent.getTrackInfoForKey("status",request,"");
	if("report".equals(report)){
		response.sendRedirect("/guesttasks/trackingpassword.jsp?trackpwd=yes&eid="+groupid+"&trackcode="+trackcode);
	}
	if("manage".equals(manage)){
		response.sendRedirect("/guesttasks/trackingpassword.jsp?eid="+groupid+"&trackcode="+trackcode);
	}
if(!"Suspended".equals(status)){
boolean trackURLsession=(session.getAttribute(groupid+"_"+trackcode)==null);
	if(trackURLsession){
	session.setAttribute(groupid+"_"+trackcode,trackcode);
	DbUtil.executeUpdateQuery("update trackURLs set count=to_number(count,'9999999999')+1 where trackingcode=? and eventid=?",new String[]{trackcode,groupid});
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


String configid=null;
request.setAttribute("eventinfohm",EventPageContent.getEventDetailsFromDb(groupid));

configid=EventPageContent.getEventInfoForKey("config_id",request,"");
HashMap ConfigmapHM=EventPageContent.getConfigValuesFromDb(configid);
request.setAttribute("confighm",ConfigmapHM);
if(groupid!=null){
	String exturl=EventPageContent.getConfigValue("event.regexternal.url",request,"");
	if(exturl!=null&& !"".equals(exturl)){
		response.sendRedirect(exturl);
	}
}

String userid=EventPageContent.getEventInfoForKey("mgr_id",request,null);
boolean isgroupevent=false;
if(userid==null){
	userid=DbUtil.getVal("select userid from user_groupevents where   event_groupid=?",new String[]{groupid});
       if(userid!=null)
         isgroupevent=true;
}
if(trackcode==null&&StaticEventPageManager.isExists(groupid+".jsp")){
String pagename="/static/"+groupid+".jsp";
%>
<jsp:forward page="<%=pagename%>" /> 	
<%
}

boolean displayevent=false;
if(userid!=null ){
displayevent=true;			
if(displayevent&&participantid!=null){
String validPartner=DbUtil.getVal("select 'yes' from group_partner where partnerid=? and status='Active' ",new String[]{participantid});
displayevent=("yes".equals(validPartner) );			
}			 
}
//String rsvpcheck=DbUtil.getVal("select value from config where name='event.rsvp.enabled' and config_id in (select config_id from eventinfo where eventid=?)",new String[] {groupid});
String eventstatus=DbUtil.getVal("select status from eventinfo where eventid=?",new String[]{groupid});
if(!displayevent || "CANCEL".equals(eventstatus)){
%>
<jsp:forward page='eventnotavailable.jsp' /> 	
<%
}else{	
	boolean eventpagesession=(session.getAttribute("eventpagehit_"+groupid)==null);
	if(eventpagesession){
	session.setAttribute("eventpagehit_"+groupid,"eventpagehit_"+groupid);
	String sessid=(String)session.getId();
	HitDB.insertHit(new String[]{"eventhandler.jsp","Event Page",sessid,groupid,null});
	StatusObj updateStatusObj=DbUtil.executeUpdateQuery("update hits_summary set visit_count=visit_count+1 where id=? and resource ='Event Page'",new String[]{groupid});
	if(updateStatusObj.getCount()==0){
		DbUtil.executeUpdateQuery("insert into hits_summary(visit_count, id, resource) values(1, ?,'Event Page')",new String[]{groupid});
	}
	
	}

if(isgroupevent){
session.setAttribute("eventgroupid",groupid);
request.setAttribute("userid",userid);
%>
<jsp:include page='/customevents/groupThemeProcessor.jsp' />		
<%}
else{

SetEventInfoToRequest(request,session);
String mgrid=EventPageContent.getEventInfoForKey("mgr_id",request,"");

String streamershow=EventPageContent.getConfigValue("eventpage.streamer.show",request,"");
if("Yes".equals(streamershow))
{
%>
<jsp:include page='userstreamer_n.jsp' >
<jsp:param name='mgrid' value='<%=mgrid%>' />
</jsp:include>
<%
request.setAttribute("PARTNERSTREAMERSHOW",streamershow);
}
HashMap attribsMap=new HashMap();
setAgentDetails(request,session,platform);
Authenticate authData=AuthUtil.getAuthData(pageContext);
EventPagelinks(request,session,authData,attribsMap);
setGoogleMapForEventPage(request,session);
%>
<%@ include file ='eventpagescripts.jsp' %>
<%@ include file ='/customevents/ningstyles.jsp' %>
<%@ include file='/customevents/recurring.jsp' %>

<%

attribsMap.put("eid",groupid);
if(discountcode!=null&&!"".equals(discountcode)){
attribsMap.put("fromDiscountCodeUrls","yes");
}
String eventpageviews=DbUtil.getVal("select visit_count from hits_summary where id=? and resource='Event Page'",new String[]{groupid});
attribsMap.put("eventPageViews",eventpageviews);
String isattendeeshow=EventPageContent.getConfigValue("eventpage.attendee.show",request,"");
String loadattendeebyajax=EventPageContent.getConfigValue("loadattendee.byajax",request,"");
if(("Yes".equalsIgnoreCase(isattendeeshow)) && ("Yes".equalsIgnoreCase(loadattendeebyajax))){
String showAttendeesLink=" <div id='attendeeinfo'></div>";
attribsMap.put("showAttendeesOnLoad",showAttendeesLink);

}
if("Yes".equalsIgnoreCase(isattendeeshow))
	scriptTag+="<script type='text/javascript' src='/home/js/whosattending.js'></script>";
if(isrecurringevent){
	TicketsDBZ tktdb=new TicketsDBZ();
	attribsMap.put("recurreningSelect",tktdb.getRecurringEventDates(groupid,"tickets"));
	if("Yes".equalsIgnoreCase(isattendeeshow))
		attribsMap.put("recurreningAttendeeSelect",tktdb.getRecurringEventDates(groupid,"attendeelist"));
}
attribsMap.put("ticketurlcode",ticketurlcode);
attribsMap.put("eid",groupid);
attribsMap.put("eventlevelHiddenAttribs",eventlevelHiddenAttribs);
attribsMap.put("ningStyle",style);
attribsMap.put("scriptTag",scriptTag);


String fbshare="",fblike="",twitter="";
//String fbconnapi=DbUtil.getVal("select value  from config where config_id=? and name='ebee.fbconnect.api'",new String[]{"1"});
if(!"N".equals(ConfigmapHM.get("event.fbshare.show"))){
	String src=serveraddress+"portal/socialnetworking/fbshare.jsp?eid="+groupid+"";
	fbshare="<iframe src="+src+" frameborder='0' width='74px' height='75px' scrolling='no'></iframe>";
	attribsMap.put("fbShareButton",fbshare);
}
else{
attribsMap.put("fbShareButton","");
}
if(!"N".equals(ConfigmapHM.get("event.fblike.show"))){
	String src=serveraddress+"portal/socialnetworking/fblike.jsp?eid="+groupid+"";
	fblike="<iframe src="+src+" frameborder='0' width='70px' height='75px' scrolling='no'></iframe>";
	attribsMap.put("fbLikeButton",fblike);
}
else{
attribsMap.put("fbLikeButton","");
}
if(!"N".equals(ConfigmapHM.get("event.twitter.show"))){
	String src=serveraddress+"portal/socialnetworking/twitter.jsp?eid="+groupid+"";
	twitter="<iframe src="+src+" frameborder='0' width='70px' height='75px' scrolling='no'></iframe>";
	attribsMap.put("twitterButton",twitter);
}
else{
attribsMap.put("twitterButton","");
}
if(!"N".equals(ConfigmapHM.get("event.fbcomment.show"))){
	String fbcommentlink =serveraddress+"event?eid="+groupid+"";
	
	String fbcomment="<div id='fb-root'></div><script src='http://connect.facebook.net/en_US/all.js#appId=578ea8f7fdc0ab02b19d74c53d21a0c4&xfbml=1'></script>"
	+"<fb:comments href='"+fbcommentlink+"' num_posts='10' width='500' via='www.eventbee.com'></fb:comments>";
	
	attribsMap.put("fbComment",fbcomment);
}

if(!"N".equals(ConfigmapHM.get("event.fbsend.show"))){
	String fbsendlink =serveraddress+"event?eid="+groupid+"";
	//fbsendlink="http://www.eticketr.com/event?eid=798989222";
	String fbsend="<div id='fb-root'></div><script src='http://connect.facebook.net/en_US/all.js'></script><fb:send href='"+fbsendlink+"' font='arial'></fb:send>";
	attribsMap.put("fbSendButton",fbsend);
}
if(!"N".equals(ConfigmapHM.get("event.googleplusone.show"))){
	String googleplusone="<iframe src='"+serveraddress+"portal/socialnetworking/googleplus1.jsp?eid="+groupid+"' frameborder='0' width='70px' height='75px' scrolling='no' style='margin-left:-10px'></iframe>";
	attribsMap.put("googlePlusOne",googleplusone);
}


if("Y".equals(ConfigmapHM.get("event.FBRSVPList.show")) && !"".equals(ConfigmapHM.get("event.FBRSVPList.eventid"))){
String src=serveraddress+"portal/socialnetworking/fbattendeelist.jsp?eid="+groupid+"";

String fblist="<iframe src="+src+" height='295px'  width='290px' frameborder='0' scrolling='no' style='margin:0px;'></iframe>";
attribsMap.put("fbRSVPList",fblist);
}

if(!"N".equals(ConfigmapHM.get("event.fbiboughtbutton.show"))){
	String src=serveraddress+"portal/socialnetworking/facebookbought.jsp?eid="+groupid+"";

String fbibought="<iframe src="+src+" height='250px'  width='290px' frameborder='0' scrolling='no' style='margin:0px;'></iframe>";
attribsMap.put("fbIBought",fbibought);

}

%>
<jsp:include page='/main/eventfooter.jsp' />
<%
SetCustomHeader(request);
EventLoader.ProcessVelocity(request,session,response,attribsMap);
}}%>


			
