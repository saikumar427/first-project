
<%@page import="com.eventbee.general.DBManager"%>
<%@ page language="java" contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="org.apache.velocity.app.VelocityEngine"%>
<%@page import="org.apache.velocity.VelocityContext"%>
<%@page import="com.eventregister.RegistrationDBHelper"%>
<%@page import="com.eventbee.general.DbUtil"%>
<%@page import="com.eventbee.general.DateUtil"%>
<%@page import="com.eventregister.BatchEventHitTrack"%>
<%@page import="com.eventbee.general.EventbeeBatchMemActions"%>
<%@page import="com.eventregister.BatchUpdateTrackurls"%>
<%@page import="com.eventpageloader.EventPageContent"%>
<%@page import="com.eventbee.general.EbeeCachingManager"%>
<%@page import="com.eventbee.regcaheloader.EventMetaLoader"%>
<%@page import="com.eventbee.regcaheloader.EventInfoLoader"%>
<%@page import="com.eventbee.regcaheloader.GlobalStaticCacheLoader"%>
<%@page import="com.eventbee.regcaheloader.LayoutManageLoader"%>
<%@page import="com.eventbee.cachemanage.CacheLoader"%>
<%@ page import="com.eventbee.cachemanage.CacheManager"%>
<%@ page import="org.eventbee.sitemap.util.Presentation" %>
<%@ include file ='../getresourcespath.jsp' %> 
<%@ include file="/customevents/accessevent.jsp" %>

<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONException"%>
<%@page import="java.awt.Color"%>
<%@page import="com.eventbee.layout.EventPageRenderer"%>
<%@page import="com.eventbee.layout.DBHelper"%>

<style>
<!-- for new layout render -->
table tr td{
 font-size:14px;
 }
 
 img:not(#seatcell table tbody tr td img){ 
	height: auto; 
	max-width: 100%; 
} 
#profile input, #profile select{ 
	margin-bottom: 10px; 
} 
#rsvpprofile input, #rsvpprofile select{
	margin-bottom: 10px;
}
<!-- for new layout renderend -->
pre{
border:0px !important;
background-color:transparent !important;
overflow:initial !important;
}
.checkmark_kick {

    background-color: black;
    height: 3px;
    left: -12px;
    position: absolute;
    top: 0.9px;
    width: 5px;

}
 
.checkmark_stem {

    background-color: black;
    height: 10px;
    left: -9px;
    position: absolute;
    top: -7px;
    width: 3px;

}
 .checkmark {
     position: relative; 

    display: inline-block;

   -ms-transform: rotate(45deg); /* IE 9 */
    -webkit-transform: rotate(45deg); /* Safari */
    transform: rotate(45deg);
}
.unassign{/*seating event*/
	width: auto !important;
}
</style>
<%
// Intialization
java.util.Date d=new java.util.Date();
String groupid=Presentation.GetRequestParam(request,  new String []{"eid","eventid", "id","GROUPID","groupid","gid"});
String participantid=Presentation.GetRequestParam(request,  new String []{"pid","partnerid", "participantid","participant"});
String platform=request.getParameter("platform");
String report=request.getParameter("report");
String trackcode=request.getParameter("track");

String manage=request.getParameter("manage");
String register=request.getParameter("register");
String discountcode=request.getParameter("code");
if(discountcode==null)	discountcode="";
String purpose=request.getParameter("purpose");
String ticketurlcode=request.getParameter("tc");
String context=request.getParameter("context");
String display_ntscode=request.getParameter("nts");
String preview=request.getParameter("preview_pwd");
String waitlistId=request.getParameter("wid");
String prev = request.getParameter("preview");
prev=prev==null?"final":prev;
if(waitlistId==null)waitlistId="";
if(preview==null)preview="";
if(context==null) context="EB";
HashMap trackshm=null;


//Laoding blocked Events into Memeory
HashMap blockedEventsMap=(HashMap)EbeeCachingManager.get("blockedEvents");
if(blockedEventsMap==null){
	blockedEventsMap=new HashMap();
	EbeeCachingManager.put("blockedEvents",blockedEventsMap);
}

//check for basic validation on groupid
if(groupid==null || "".equals(groupid)){
	System.out.println("Event Page with no eventid: ");
	response.sendRedirect("/guesttasks/invalidpage.jsp");
	return;
}


// chack the groupid in blocked events	
 if(blockedEventsMap.get(groupid)!=null){
	System.out.println("Event Page with blocked eventid: -1"+groupid);
	String cancelby=(String)blockedEventsMap.get(groupid+"_cancelby");
	if(cancelby==null)cancelby="";
	 if("hightraffic".equals(cancelby)){}
		 else{
		 response.sendRedirect("/guesttasks/invalidpage.jsp");
		return;
		 }
}
 
 try{
		int eventid=Integer.parseInt(groupid);	
		if(!CacheManager.getInstanceMap().containsKey("eventmeta")){
			CacheLoader eventmetaloader=new EventMetaLoader();
			eventmetaloader.setRefreshInterval(3*60*1000);
			eventmetaloader.setMaxIdleTime(3*60*1000);
			CacheManager.getInstanceMap().put("eventmeta",eventmetaloader);		
		}
		
		//CacheManager.getData(groupid, "eventmeta");
		if(CacheManager.getData(groupid, "eventmeta")==null || CacheManager.getInitStatus(groupid+"_eventmeta")){
			request.getRequestDispatcher("eventpageloading.jsp").forward(request, response);
			return;
		}
	}catch(Exception e){System.out.println(" Invalid eventid ");
	response.sendRedirect("/guesttasks/invalidpage.jsp");
	return;
	}


 
// Group events related
if(!isvalidEvent(groupid)){
	String userid=getUserId(groupid);
	if(userid==null){
		response.sendRedirect("/guesttasks/invalidpage.jsp");
	return;
	}else{			
		response.sendRedirect("/customevents/groupThemeProcessor.jsp?groupid="+groupid);
		return;
	}
}
	
	
	
// Check Event Status 	
	String eventstatus=getEventStatus(groupid);
	if("CANCEL".equals(eventstatus)){
		String cancelBy=getEventCancelBy(groupid);
	 blockedEventsMap.put(groupid,"Y");
	 blockedEventsMap.put(groupid+"_cancelby",cancelBy);
	 EbeeCachingManager.put("blockedEvents",blockedEventsMap);
	 if("hightraffic".equals(cancelBy)){}
	 else{
	 response.sendRedirect("/guesttasks/invalidpage.jsp");
	 return;
	 }
	}
	

	// Track Code related
	if(trackcode!=null)
	{	trackshm=EventPageContent.getTrackURLContet(groupid,trackcode);
		if(trackshm.size()>0){
		String status=GenUtil.getHMvalue(trackshm,"status","");	
		if("manage".equals(manage) || "report".equals(report)){
			response.sendRedirect("/main/TrackUrlManage?eid="+groupid+"&trackcode="+trackcode);
			return;
		}	
	  if(!"Suspended".equals(status)){
	   boolean trackURLsession=(session.getAttribute(groupid+"_"+trackcode)==null);
		if(trackURLsession){
		session.setAttribute(groupid+"_"+trackcode,trackcode);
		//DbUtil.executeUpdateQuery("update trackurls set count=cast(coalesce(cast(count as numeric),0) as numeric)+1 where trackingcode=? and eventid=?",new String[]{trackcode,groupid});
		BatchUpdateTrackurls.setUpdateTrackUrlBatch(groupid,trackcode);
		EventbeeBatchMemActions.ebeeBatchCache.put("com.eventregister.BatchUpdateTrackurls"+EventbeeBatchMemActions.maxCountKey,"100");
		EventbeeBatchMemActions.ebeeBatchCache.put("com.eventregister.BatchUpdateTrackurls"+EventbeeBatchMemActions.maxtimeKey,"5");
		EventbeeBatchMemActions.checkCountAction("com.eventregister.BatchUpdateTrackurls");
		EventbeeBatchMemActions.checkTimeOutAction("com.eventregister.BatchUpdateTrackurls");
		} }
	  else  trackcode=null;
	   }
	  else	   trackcode=null;
  }

   //Event Page Password Related
   if(session.getAttribute("EVENT_PASSWORD_AUTH_DONE_"+groupid)==null && !"no".equals(preview) && "final".equals(prev)){
	String password=getPassword(groupid);
	if(password!=null){
		if(session.getAttribute("EVENT_PASSWORD_AUTH_DONE_"+groupid)==null){
			response.sendRedirect("/guesttasks/eventpassword.jsp?"+request.getQueryString());
		return;
	}}}



	// EventPage Hit count Related
	boolean eventpagesession=(session.getAttribute("eventpagehit_"+groupid)==null && request.getParameter("preview_pwd")==null && "final".equals(prev));
	if(eventpagesession){
	session.setAttribute("eventpagehit_"+groupid,"eventpagehit_"+groupid);
	String sessid=(String)session.getId();
	BatchEventHitTrack.setHitBatchBatch(new String[]{"eventhandler.jsp","Event Page",sessid,DateUtil.getCurrDBFormatDate(),groupid,null});
	EventbeeBatchMemActions.ebeeBatchCache.put("com.eventregister.BatchEventHitTrack"+EventbeeBatchMemActions.maxCountKey,"100");
	EventbeeBatchMemActions.ebeeBatchCache.put("com.eventregister.BatchEventHitTrack"+EventbeeBatchMemActions.maxtimeKey,"5");
	EventbeeBatchMemActions.checkCountAction("com.eventregister.BatchEventHitTrack");
	EventbeeBatchMemActions.checkTimeOutAction("com.eventregister.BatchEventHitTrack");
	}

	
	// Intailzing the cahemanager
	try{
	int eventid=Integer.parseInt(groupid);		
	///Intializing  the GlobalStaic and  Eventinfo Map Loader
	if(!CacheManager.getInstanceMap().containsKey("globalstatic")){
		CacheLoader glstatic=new GlobalStaticCacheLoader();
		//http://localhost/customevents/lobalstaticloader.jsp
		glstatic.setRefreshInterval(1*60*60*1000);
		glstatic.setMaxIdleTime(1*60*60*1000);
		CacheManager.getInstanceMap().put("globalstatic",glstatic);		
	}
	
	if(CacheManager.getData("0", "globalstatic")==null || CacheManager.getInitStatus("0_globalstatic")){
		request.getRequestDispatcher("eventpageloading.jsp").forward(request, response);
		   return;
	}
	if(!CacheManager.getInstanceMap().containsKey("eventinfo")){
		CacheLoader eventinf=new EventInfoLoader();
		eventinf.setRefreshInterval(3*60*1000);
		eventinf.setMaxIdleTime(3*60*1000);
		CacheManager.getInstanceMap().put("eventinfo",eventinf);		
	}
	   if(CacheManager.getData(groupid, "eventinfo")==null || CacheManager.getInitStatus(groupid+"_eventinfo")){
		   request.getRequestDispatcher("eventpageloading.jsp").forward(request, response);
		   return ;
	   }
	   
	}catch(Exception e){
		System.out.println("error while cahe preoceeing "+" :: "+groupid+" :: "+e.getMessage());
		//e.printStackTrace();
		response.sendRedirect("/guesttasks/invalidpage.jsp");
		return;
	}
	 	
// Scriptps preparation
	 HashMap<String,String> configmp=getEventConfigMap(groupid);
	 StringBuffer scriptTag=new StringBuffer();
	 String i18nLang="en_US";
	 try{
		 i18nLang=DBHelper.getLanguageFromDB(groupid);
	 }catch(Exception e){
		 i18nLang="en_US";
		 System.out.println("Exception While getting i18n lang for eventid: "+groupid+" ERROR: "+e.getMessage());
	 }
	 scriptTag.append("<script src='/customevents/customconditionalrule.jsp?eid="+groupid+"'></script>");
	 scriptTag.append("<script src='/home/js/i18n/"+i18nLang+"/regprops.js?id=3'></script>");
	 try{ 
	//general script order should be like this
	scriptTag.append(getNTSGenScript(groupid));
	scriptTag.append(getEventGenralScript());
	//rsvp
	if(("Yes".equalsIgnoreCase(GenUtil.getHMvalue(configmp,"event.rsvp.enabled","no"))))
		scriptTag.append(getRSVPScript());
	//regularsc
	else{	
		scriptTag.append(getRegularScript());	
	    if("YES".equals(GenUtil.getHMvalue(configmp,"event.seating.enabled","NO")))
	    {//seating related
	    	scriptTag.append(getSeatingScript(groupid,GenUtil.getHMvalue(configmp,"venuid","")));   			
	    	scriptTag.append((String) getGlobalStaticMap().get("seatingreg_script"));
	    }
	  }		
	
	   
	  }catch(Exception e){
	  System.out.println("Exception While Processing The Static Map"+e.getMessage());
	  e.printStackTrace();
	}

	 

   // Nts ,track,discount hidden values preparation
	String referral_ntscode="";
	display_ntscode=display_ntscode==null?"":display_ntscode;
	if(!"".equals(display_ntscode)){	
	String nts=DbUtil.getVal("select nts_code from ebee_nts_partner where nts_code=?",new String[]{display_ntscode});		
	if(nts!=null && !"".equals(nts) )
		{ 
		   if(session.getAttribute(groupid+"ntsclick"+display_ntscode)==null)
				{ RegistrationDBHelper regdbhelper=new RegistrationDBHelper();
				  referral_ntscode= regdbhelper.ValidateNTSCode(groupid,display_ntscode);
				  session.setAttribute(groupid+"ntsclick"+display_ntscode,display_ntscode);
				}
		       referral_ntscode=nts;
		   }
		 referral_ntscode=referral_ntscode==null?"":referral_ntscode;
	}	
	StringBuffer eventlevelHiddenAttribs=new StringBuffer();
	eventlevelHiddenAttribs.append("<input type='hidden' name='trackcode' id='trackcode' value='"+trackcode+"'/>");
	eventlevelHiddenAttribs.append("<input type='hidden' name='discountcode' id='discountcode' value='"+discountcode+"'/>");
	eventlevelHiddenAttribs.append("<input type='hidden' name='ticketurlcode' id='ticketurlcode' value='"+ticketurlcode+"'/>");
	eventlevelHiddenAttribs.append("<input type='hidden' name='context' id='context' value='"+context+"'/>");
	eventlevelHiddenAttribs.append("<input type='hidden' name='referral_ntscode' id='referral_ntscode' value='"+referral_ntscode+"'>");
	eventlevelHiddenAttribs.append("<input type='hidden' name='waitlistId' id='waitlistId' value='"+waitlistId+"'>");

	if("ning".equals(context))
	eventlevelHiddenAttribs.append("<input type='hidden' name='oid' id='oid' value='"+request.getParameter("oid")+"'/><input type='hidden' name='domain' id='domain' value='"+request.getParameter("domain")+"'/>");



	// Event Page genaration
%>
<%
if(!getEventInfoMap(groupid).containsKey("isLayout") && !"draft".equals(prev)){
	String isLayout=DbUtil.getVal("select 'Y'  from event_layout where eventid=?::bigint and stage='final'",new String[]{groupid});
	Map isLayoutMap=new HashMap();
	isLayoutMap.put("isLayout",isLayout==null?"N":isLayout);
	CacheManager.updateData(groupid+"_eventinfo", isLayoutMap, false);
}
String isLayout=(String)getEventInfoMap(groupid).get("isLayout");
if("draft".equals(prev))
	isLayout="Y";
if("Y".equals(isLayout)){
%>
<%@ include file="/customevents/eventlayoutpage.jsp" %>
<%
}else{
	try{
		//for classic event page
	     //whos attendeeing
	    if("Yes".equalsIgnoreCase(isAttendeeShow(groupid)))
		 scriptTag.append((String) getGlobalStaticMap().get("whos_attendee"));		
	}catch(Exception e){
		System.out.println("Exception occured for attendee show in classic::"+groupid);
	}	
%>
<%@ include file="/customevents/eventclassicpage.jsp" %>
<%
}

%>

