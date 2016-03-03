<%@ page language="java" contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,com.eventpageloader.*" %>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.eventregister.*" %>
<%@ page import="org.eventbee.sitemap.util.Presentation,com.eventbee.event.EventsContent" %>
<%@ page import="com.eventbee.authentication.*,java.net.urlEncode.*"%>
<%@ include file ='/customevents/eventpageloader.jsp' %>
<%@ include file="../getresourcespath.jsp" %>
<%

String groupid=Presentation.GetRequestParam(request,  new String []{"eid","eventid", "id","GROUPID","groupid","gid"});
String participantid=Presentation.GetRequestParam(request,  new String []{"pid","partnerid", "participantid","participant"});
String platform=request.getParameter("platform");
String report=request.getParameter("report");
String trackcode=request.getParameter("track");
System.out.println("trackcode:::::"+trackcode);
String manage=request.getParameter("manage");
String register=request.getParameter("register");
String discountcode=request.getParameter("code");
if(discountcode==null)	discountcode="";
String purpose=request.getParameter("purpose");
String ticketurlcode=request.getParameter("tc");
String context=request.getParameter("context");
String display_ntscode=request.getParameter("nts");
String preview=request.getParameter("preview_pwd");
if(preview==null)preview="";

HashMap eventinfoMap=null;
HashMap blockedEventsMap=(HashMap)EbeeCachingManager.get("blockedEvents");
if(blockedEventsMap==null){
	blockedEventsMap=new HashMap();
	EbeeCachingManager.put("blockedEvents",blockedEventsMap);
}
if(groupid==null || "".equals(groupid)){
	System.out.println("Event Page with no eventid: ");
	response.sendRedirect("/guesttasks/invalidpage.jsp");
	return;
}else {
	
	
	if(blockedEventsMap.get(groupid)!=null){

	System.out.println("Event Page with blocked eventid: "+groupid);
	response.sendRedirect("/guesttasks/invalidpage.jsp");
	return;
	}

	try{
	int eventid=Integer.parseInt(groupid);
	eventinfoMap=EventPageContent.getEventDetailsFromDb(groupid);
	
	
	if(eventinfoMap==null || eventinfoMap.size()<1 ){
		String userid=DbUtil.getVal("select userid from user_groupevents where event_groupid =?" ,new String[]{groupid});
		if(userid==null){
		System.out.println("Event Page with wrong eventid: "+groupid);	
		response.sendRedirect("/guesttasks/invalidpage.jsp");
		return;
		}else{
			session.setAttribute("eventgroupid",groupid);
			request.setAttribute("userid",userid);
			response.sendRedirect("/customevents/groupThemeProcessor.jsp?groupid="+groupid);
			return;
		}
	}
	}catch(Exception e){
		System.out.println("Event Page with wrong eventid: "+groupid);	
		response.sendRedirect("/guesttasks/invalidpage.jsp");
		return;
	}
	}

	request.setAttribute("eventinfohm",eventinfoMap);
	String eventstatus=EventPageContent.getEventInfoForKey("status",request,"ACTIVE");
	if("CANCEL".equals(eventstatus)){
	blockedEventsMap.put(groupid,"Y");
	EbeeCachingManager.put("blockedEvents",blockedEventsMap);
	//String ipaddress=request.getLocalAddr();
	//DbUtil.executeUpdateQuery("insert into cancel_events_hits (eventid,ipaddress,hit_at) values (?,?,now())",new String[]{groupid,ipaddress});
	
		System.out.println("Event Page with cancelled eventid: "+groupid);	
		response.sendRedirect("/guesttasks/invalidpage.jsp");
		return;
	}
	String exturl=EventPageContent.getConfigValue("event.regexternal.url",request,"");
	if(exturl!=null&& !"".equals(exturl)){
		response.sendRedirect(exturl);
		return;
	}

if(context==null) context="EB";
session.setAttribute("context",context);
if("ning".equals(platform))	session.setAttribute("platform","ning");
session.removeAttribute("trckcode");



if(trackcode!=null){
	HashMap trackshm=EventPageContent.getTrackURLContet(groupid,trackcode);
	if(trackshm.size()>0){
	session.setAttribute("trckcode",trackcode);
	request.setAttribute("Trackshm",trackshm);

	String status=EventPageContent.getTrackInfoForKey("status",request,"");
	/*if("report".equals(report)){
		response.sendRedirect("/guesttasks/trackingpassword.jsp?trackpwd=yes&eid="+groupid+"&trackcode="+trackcode);
		return;
	}*/
	if("manage".equals(manage) || "report".equals(report)){
		//response.sendRedirect("/guesttasks/trackingpassword.jsp?eid="+groupid+"&trackcode="+trackcode);
		response.sendRedirect("/main/TrackUrlManage?eid="+groupid+"&trackcode="+trackcode);
		return;
	}
	
	
	
	
if(!"Suspended".equals(status)){
boolean trackURLsession=(session.getAttribute(groupid+"_"+trackcode)==null);
	if(trackURLsession){
	session.setAttribute(groupid+"_"+trackcode,trackcode);
	DbUtil.executeUpdateQuery("update trackurls set count=cast(coalesce(cast(count as numeric),0) as numeric)+1 where trackingcode=? and eventid=?",new String[]{trackcode,groupid});
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
if(session.getAttribute("EVENT_PASSWORD_AUTH_DONE_"+groupid)==null && !"no".equals(preview)){
	String password=DbUtil.getVal("select password from view_security where eventid=?",new String[]{groupid});
	if(password!=null){
		if(session.getAttribute("EVENT_PASSWORD_AUTH_DONE_"+groupid)==null){
			response.sendRedirect("/guesttasks/eventpassword.jsp?"+request.getQueryString());
		return;
		}
	}
}

String configid=EventPageContent.getEventInfoForKey("config_id",request,"0");
HashMap ConfigmapHM=EventPageContent.getConfigValuesFromDb(configid);
request.setAttribute("confighm",ConfigmapHM);
	boolean eventpagesession=(session.getAttribute("eventpagehit_"+groupid)==null && request.getParameter("preview_pwd")==null);
	//System.out.println("eventpagesession: "+eventpagesession);
	if(eventpagesession){
	session.setAttribute("eventpagehit_"+groupid,"eventpagehit_"+groupid);
	String sessid=(String)session.getId();
	


    BatchEventHitTrack.setHitBatchBatch(new String[]{"eventhandler.jsp","Event Page",sessid,DateUtil.getCurrDBFormatDate(),groupid,null});
	EventbeeBatchMemActions.ebeeBatchCache.put("com.eventregister.BatchEventHitTrack"+EventbeeBatchMemActions.maxCountKey,"100");
	EventbeeBatchMemActions.ebeeBatchCache.put("com.eventregister.BatchEventHitTrack"+EventbeeBatchMemActions.maxtimeKey,"5");
	EventbeeBatchMemActions.checkCountAction("com.eventregister.BatchEventHitTrack");
	EventbeeBatchMemActions.checkTimeOutAction("com.eventregister.BatchEventHitTrack");
	
	
	}

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
//setAgentDetails(request,session,platform);
Authenticate authData=AuthUtil.getAuthData(pageContext);
request.setAttribute("resourcesAddress", resourceaddress);
EventPagelinks(request,session,authData,attribsMap);

setGoogleMapForEventPage(request,session);
%>
<%@ include file ='eventpagescripts.jsp' %>
<%@ include file ='/customevents/ningstyles.jsp' %>
<%@ include file='/customevents/recurring.jsp' %>

<%

attribsMap.put("eid",groupid);
if(!"".equals(discountcode)){
attribsMap.put("fromDiscountCodeUrls","yes");
}
String eventpageviews="0";
//eventpageviews=DbUtil.getVal("select visit_count from hits_summary where id=? and resource='Event Page'",new String[]{groupid});
attribsMap.put("eventPageViews",eventpageviews);
String isattendeeshow=EventPageContent.getConfigValue("eventpage.attendee.show",request,"");
String loadattendeebyajax=EventPageContent.getConfigValue("loadattendee.byajax",request,"");
if(("Yes".equalsIgnoreCase(isattendeeshow)) && ("Yes".equalsIgnoreCase(loadattendeebyajax))){
String showAttendeesLink=" <div id='attendeeinfo'></div>";
attribsMap.put("showAttendeesOnLoad",showAttendeesLink);

}
if("Yes".equalsIgnoreCase(isattendeeshow))
	scriptTag+="<script type='text/javascript' src='"+resourceaddress+"/home/js/whosattending.js'></script>";
	
    String ticketheader="";
    TicketsDBZ tktdb=new TicketsDBZ();
	HashMap<String,String> labelsMap=tktdb.getRecurringDatesTicketsHeaderLabels(groupid, isrecurringevent);
	ticketheader=labelsMap.get("TicketsLabel");
    
	attribsMap.put("ticketheader",ticketheader);	
if(isrecurringevent){
	String recurringselect=tktdb.getRecurringEventDates(groupid,"tickets");
	if(recurringselect==null)
		recurringselect="<select onchange=getTicketsJson('"+groupid+"'); id='eventdate' name='eventdate'></select>";
	attribsMap.put("recurreningSelect",recurringselect);
	attribsMap.put("recurringdateslabel",labelsMap.get("RecurringDatesLabel"));
	if("Yes".equalsIgnoreCase(isattendeeshow)){
		recurringselect=tktdb.getRecurringEventDates(groupid,"attendeelist");
		if(recurringselect==null)
			recurringselect="<select onchange=showAttendeesList('"+groupid+"'); id='event_date' name='event_date' style='display: block;'></select>";
		attribsMap.put("recurreningAttendeeSelect",recurringselect);
		
	}	

}
attribsMap.put("ticketurlcode",ticketurlcode);
attribsMap.put("eid",groupid);
attribsMap.put("eventlevelHiddenAttribs",eventlevelHiddenAttribs);
attribsMap.put("ningStyle",style);
attribsMap.put("scriptTag",scriptTag);


String fbshare="",fblike="",twitter="",fbsend="";


if("Y".equals(ConfigmapHM.get("event.fbshare.show"))){
	String src=serveraddress+"portal/socialnetworking/fbshare.jsp?eid="+groupid+"";
	fbshare="<iframe src="+src+" id='fbshare' name='fbshare' frameborder='0' width='74px' height='75px' scrolling='no'></iframe>";
	attribsMap.put("fbShareButton",fbshare);
}
else{
attribsMap.put("fbShareButton","");
}
if(!"N".equals(ConfigmapHM.get("event.fblike.show"))){
	String eventurl=serveraddress+"event?eid="+groupid;
   String encodeurl=URLEncoder.encode(eventurl);
	String exthtml="";//"<div style='display:none'><iframe height='0' width='0' frameborder='no' src='http://developers.facebook.com/tools/debug/og/object?q="+encodeurl+"'></iframe></div>";
	attribsMap.put("fbLikeButton","<fb:like href='"+eventurl+"' send='false' layout='box_count' width='60' show_faces='true'></fb:like>"+exthtml);
}
else{
attribsMap.put("fbLikeButton","");
}
if(!"N".equals(ConfigmapHM.get("event.twitter.show"))){
	String src=serveraddress+"portal/socialnetworking/twitter.jsp?eid="+groupid+"";
	twitter="<iframe src="+src+" id='twitter' name='twitter' frameborder='0' width='70px' height='75px' scrolling='no'></iframe>";
	attribsMap.put("twitterButton",twitter);
}
else{
attribsMap.put("twitterButton","");
}
if(!"N".equals(ConfigmapHM.get("event.fbcomment.show"))){
	String fbcommentlink =serveraddress+"event?eid="+groupid+"";
	String fbcomment="<fb:comments href='"+fbcommentlink+"' num_posts='10' width='500' via='www.eventbee.com'></fb:comments>";
	
	attribsMap.put("fbComment",fbcomment);
}

if(!"N".equals(ConfigmapHM.get("event.fbsend.show"))){
	String fbsendlink =serveraddress+"event?eid="+groupid+"";
	fbsend="<fb:send href='"+fbsendlink+"' font='arial'></fb:send>";
	attribsMap.put("fbSendButton",fbsend);
}
if(!"N".equals(ConfigmapHM.get("event.googleplusone.show"))){
	String googleplusone="<iframe id='googleplusone' name='googleplusone' src='"+serveraddress+"portal/socialnetworking/googleplus1.jsp?eid="+groupid+"' frameborder='0' width='70px' height='75px' scrolling='no' style='margin-left:-10px'></iframe>";
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
if("Y".equals(ConfigmapHM.get("event.socialmediapromotions.show"))){
String promos="<iframe src="+serveraddress+"/main/home/fbeventpromotions.jsp?eid="+groupid+" height='250px'  width='290px' frameborder='0' scrolling='no' style='margin:0px;'></iframe>";
attribsMap.put("promotions",promos);
}

%>
<jsp:include page='/main/eventfooter.jsp' />
<%
SetCustomHeader(request);
EventLoader.ProcessVelocity(request,session,response,attribsMap);

%>


			

