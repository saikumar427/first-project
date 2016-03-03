
<%@page import="com.eventbee.general.DBManager"%>
<%@ page language="java" contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="org.apache.velocity.app.VelocityEngine"%>
<%@page import="org.apache.velocity.VelocityContext"%>

<%@page import="com.eventbee.general.DbUtil"%>
<%@page import="com.eventbee.general.DateUtil"%>

<%@page import="com.eventpageloader.EventPageContent"%>
<%@page import="com.eventbee.general.EbeeCachingManager"%>

<%@page import="com.eventbee.regcaheloader.EventInfoLoader"%>

<%@page import="com.eventbee.regcaheloader.BuyerAttLayoutManageLoader"%>
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
<%@page import="com.eventbee.layout.BuyerAttDBHelper"%>

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
</style>
<%
// Intialization
java.util.Date d=new java.util.Date();
String groupid=request.getParameter("eid");
String tid=request.getParameter("tid");
String token=request.getParameter("token");
String prev = request.getParameter("preview");
groupid=groupid==null?"":groupid.trim();
tid=tid==null?"":tid.trim();
token=token==null?"":token.trim();
prev=prev==null?"final":prev;
boolean isValid=true;
if(!"draft".equals(prev) && ("".equals(tid) || "".equals(token) || "".equals(groupid))) isValid=false;
if("draft".equals(prev) && "".equals(groupid)) isValid=false;
if(isValid && !"draft".equals(prev)) isValid=BuyerAttDBHelper.isValidToken(token, tid, groupid);
if(!isValid){
	response.sendRedirect("/guesttasks/invalidpage.jsp");
	return;
}

	// Intailzing the cahemanager
	try{
	int eventid=Integer.parseInt(groupid);		
	///Intializing  the GlobalStaic and  Eventinfo Map Loader

	if(!CacheManager.getInstanceMap().containsKey("eventinfo")){
		CacheLoader eventinf=new EventInfoLoader();
		eventinf.setRefreshInterval(3*60*1000);
		eventinf.setMaxIdleTime(3*60*1000);
		CacheManager.getInstanceMap().put("eventinfo",eventinf);		
	}
	   if(CacheManager.getData(groupid, "eventinfo")==null || CacheManager.getInitStatus(groupid+"_eventinfo")){
		   request.getRequestDispatcher("eventpageloading.jsp").forward(request, response);
		   return;
	   }
	   
	}catch(Exception e){
		System.out.println("error while cahe preoceeing "+" :: "+groupid+" :: "+e.getMessage());
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
	 scriptTag.append("<script src='/main/bootstrap/js/jquery-1.11.2.min.js'></script>");
	 scriptTag.append("<script src='/main/bootstrap/js/bootstrap.min.js'></script>");
	 scriptTag.append("<script src='/home/js/i18n/"+i18nLang+"/regprops.js?id=2'></script>");
	 scriptTag.append("<script src='/home/js/handlebars.js?id=1'></script>");
	 scriptTag.append("<script src='/home/js/bootstrap/alpaca.min.js'></script>");
	 scriptTag.append("<script src='/home/js/buyer_att_edit_profile.js?id=1'></script>");
	 scriptTag.append("<link type='text/css' href='/home/css/bootstrap/alpaca.min.css' rel='stylesheet'/>");
	 scriptTag.append("<script src='/home/js/Tokenizer.js'></script>");
%>
<%@ include file="/customevents/buyerlayoutpage.jsp" %>