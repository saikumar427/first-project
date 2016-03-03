<%@page import="java.util.Vector"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.eventbee.general.GenUtil"%>
<%@page import="com.eventbee.general.EbeeConstantsF"%>
<%@page import="com.eventbee.cachemanage.CacheManager"%>
<%@ page import="com.themes.ThemeController" %>

<%!
	  
static String serveraddress="http://"+EbeeConstantsF.get("serveraddress","")+"/";

public boolean isvalidEvent(String groupid){
	Map meta=getEventMetaData(groupid);
	//System.out.println("meta:::"+meta);
	if(meta.containsKey("status"))
		return true;
	return false;
	
}
public Map getEventMetaData(String groupid){
	Map meta=CacheManager.getData(groupid, "eventmeta");
	//System.out.println("getmeta:::"+meta);
	return meta;	
}

public  HashMap getEventInfoMap(String groupid){
	Map eventinfoMap=CacheManager.getData(groupid, "eventinfo");	
	return (HashMap)eventinfoMap;
}
public  HashMap getGlobalStaticMap(){
	Map globalstaticMap=CacheManager.getData("0", "globalstatic");	
	return (HashMap)globalstaticMap;
}


public  String getUserId(String groupid){
	return (String)((HashMap)getEventMetaData(groupid)).get("userid_group");	
}

public  String getEventStatus(String groupid){
	return GenUtil.getHMvalue(getEventMetaData(groupid),"status","ACTIVE");
}

public String getEventCancelBy(String groupid){
	return GenUtil.getHMvalue(getEventMetaData(groupid),"canceledby","");
}


public  String getEventName(String groupid){
	return (String)getEventInfoMap(groupid).get("eventname");
}

public  String getStartDate(String groupid){
	return (String)getEventInfoMap(groupid).get("evt_start_date")+", "+(String)getEventInfoMap(groupid).get("starttime");
}

public  String getEndDate(String groupid){
	return (String)getEventInfoMap(groupid).get("evt_end_date")+", "+(String)getEventInfoMap(groupid).get("endtime");
}

public  String getEventDescription(String groupid){
	String description="";
	if("text".equalsIgnoreCase(GenUtil.getHMvalue(getEventInfoMap(groupid),"descriptiontype","")))
		description = GenUtil.textToHtml(GenUtil.getHMvalue(getEventInfoMap(groupid),"description",""),true);
	else
		description = GenUtil.getHMvalue(getEventInfoMap(groupid),"description","");
	
	if("<br>".equals(description))
		description="";
	
	return description;
}

public  String getLocation(String groupid){
	String location=(String)getEventInfoMap(groupid).get("city");
	location=java.net.URLEncoder.encode(location);
	return location;
}

public  String getEventPhoto(String groupid){	
	String photourl=(String)getEventConfigMap(groupid).get("event.eventphotoURL");
	if(photourl!=null&&!"".equals(photourl)){
		return "<img src='"+photourl+"'>";
	}else{
		photourl=(String)getEventInfoMap(groupid).get("photourl");
		
		if(photourl!=null&&!"".equals(photourl)){
			return "<img src='"+EbeeConstantsF.get("big.photo.image.webpath","")+"/"+photourl+"' />";
		}
		return "";		
	}
	
}


public  HashMap getEventConfigMap(String groupid){	
	return (HashMap)getEventInfoMap(groupid).get("configmap");
}

public  String getPassword(String groupid){
	
	return (String)((HashMap)getEventMetaData(groupid)).get("event_password");
	
}

public  String getEventCustomUrl(String groupid){
	
	 return (String)((HashMap)getEventInfoMap(groupid)).get("eventcustomurl");
	
}

public  Vector getNotices(String groupid){

	return   (Vector)((HashMap)getEventInfoMap(groupid)).get("event_notices");
	
}


public  HashMap getCustomHeaderFooter(String groupid){
	HashMap hm=getEventInfoMap(groupid);
	//System.out.println(" event header :::"+hm.get("event_header_footer"));;
	return (HashMap)(hm.get("event_header_footer"));
		
}

public  String getEventHeader(String groupid, HttpServletRequest request){
	String preview=request.getParameter("preview");
	if("eventdetails".equalsIgnoreCase(preview)){
		return request.getParameter("headerhtml");
	}else{HashMap hm=getEventInfoMap(groupid);
		HashMap h=(HashMap)hm.get("event_header_footer");
		//System.out.println("********footer*****"+ h);
		return h.get("header")==null?"":h.get("header")+"";
	}
	
	
}

public  String getEventFooter(String groupid, HttpServletRequest request){
	String preview=request.getParameter("preview");
	if("eventdetails".equalsIgnoreCase(preview)){
		return request.getParameter("footerhtml");
	}else{
		HashMap hm=getEventInfoMap(groupid);
		HashMap h=(HashMap)hm.get("event_header_footer");		
		return h.get("footer")==null?(String)getGlobalStaticMap().get("general_footer"):h.get("footer")+"";
			
	}
}



public String getGoogleMap(String groupid){	
	String GOOGLEMAP="";
	if("Yes".equals(getEventConfigMap(groupid).get("eventpage.map.show"))){		
		String lon=GenUtil.getHMvalue(getEventInfoMap(groupid),"longitude",null);
		String lat=GenUtil.getHMvalue(getEventInfoMap(groupid),"latitude",null);		
		if((lon!=null&&(!"".equals(lon.trim())))&&(lat!=null&&(!"".equals(lat.trim())))){			
		  GOOGLEMAP=((String)getGlobalStaticMap().get("googlemap")).replace("##lat##",lat).replace("##lon##",lon);
		}
	}	
	return GOOGLEMAP;	
}


public String [] getFullAddress(String groupid){
	
	return (String [])((HashMap)getEventInfoMap(groupid)).get("event_fullAddress");
}


public String getMapString(String groupid){
	
	String mapstring=(String)getGlobalStaticMap().get("mapstring");	
	return mapstring.replace("##mstr##",(String)getEventInfoMap(groupid).get("event_mapString"));

}

public String getEventLink(String groupid){
	return "<a href="+serveraddress+"event?eid="+groupid+" >"+"Visit Main Event Page"+"</a>";
}

public String getHostedBy(String groupid){
	
	return  (String)((HashMap)getEventInfoMap(groupid)).get("event_hostedBy");
}



public String getContactMgrLink(String groupid){
	String subject=(String)getEventInfoMap(groupid).get("eventname");	
	String cnt_mgr=(String)getGlobalStaticMap().get("contact_mgr");
	return cnt_mgr.replace("##subject##",subject).replace("##groupid##", groupid).replace("##hostedby##", getHostedBy(groupid));
	 
}


public String getEmailFriendLink(String groupid){
	String subject=(String)getEventInfoMap(groupid).get("eventname");	
	String email_to_frnd=(String)getGlobalStaticMap().get("email_to_frnd");
	return email_to_frnd.replace("##subject##",subject).replace("##groupid##", groupid);
	 
}


public String getEventURL(String groupid){	
	String eventcustomurl=(String)getEventCustomUrl(groupid);
	String listurl=serveraddress+"event?eid="+groupid;
	if(eventcustomurl==null)
	 eventcustomurl=listurl;
	String eventurl=(String)getGlobalStaticMap().get("eventcustomurl");
	//System.out.println("eventurl::::"+eventurl);
   return eventurl.replace("##eventcustomurl##",eventcustomurl);

}

public String getCity(String groupid){
	return (String)getEventInfoMap(groupid).get("city");
}

public String getVenue(String groupid){
	return (String)getEventInfoMap(groupid).get("venue");
}

public String metaStartDate(String groupid){
	String desc_start_date=getStartDate(groupid);
	try{
		String[] st_temp=desc_start_date.split(",");
		String[] st_dd_format  =st_temp[1].split(" ");
		return st_dd_format[2]+" "+st_dd_format[1]+""+st_temp[2]+","+st_temp[3];
		
		}catch(Exception e){
	}
	return "";
}



public String getMetaStartDate(String groupid){

	return (String)getEventInfoMap(groupid).get("event_metaStartDate");
}

public String getMetaEndDate(String groupid){
	
return (String)getEventInfoMap(groupid).get("event_metaEndDate");
} 

public boolean isRecurring(String groupid){
	return ("Y".equalsIgnoreCase(GenUtil.getHMvalue(getEventConfigMap(groupid),"event.recurring","N")));
}

public boolean isRSVP(String groupid){
	return ("Yes".equalsIgnoreCase(GenUtil.getHMvalue(getEventConfigMap(groupid),"event.rsvp.enabled","no")));
}

public boolean isTicketingEvent(String groupid){
	return ("Yes".equalsIgnoreCase(GenUtil.getHMvalue(getEventConfigMap(groupid),"event.poweredbyEB","no")));
}



public String getRecurringSelect(String groupid){
			
	return (String)getEventInfoMap(groupid).get("recurringselect"); 
}

public String isAttendeeShow(String groupid){
	return GenUtil.getHMvalue(getEventConfigMap(groupid),"eventpage.attendee.show","");
}

public String isLoadAttendeeByAjax(String groupid){
	return GenUtil.getHMvalue(getEventConfigMap(groupid),"loadattendee.byajax","");
}

public String getRecurringDateLabels(String groupid){
	
	//System.out.println("label::"+getEventInfoMap(groupid).get("recurringdateslabel"));
	HashMap hm=(HashMap)getEventInfoMap(groupid).get("recurringdateslabel");
	String s=(String)hm.get("RecurringDatesLabel");
    //System.out.println("label::"+s);
	return s; 
}
public String getRecurringAttendeeSelect(String groupid){
	
	return (String)getEventInfoMap(groupid).get("recurreningsttendeeselect"); 
	
}

public HashMap getTrackPartnerMap(String groupid, HashMap trackmap, String trackcode){
	HashMap hm=new HashMap();
	String trackPartnerMessage="";
	String trackPartnerPhoto="";
	
	String status=GenUtil.getHMvalue(trackmap,"status","");
	if(trackcode!=null&&!"Suspended".equals(status)){
		trackPartnerMessage=GenUtil.getHMvalue(trackmap,"message","");
		trackPartnerPhoto=GenUtil.getHMvalue(trackmap,"photo","");
	}
	if(trackPartnerMessage==null||"".equals(trackPartnerMessage))
		trackPartnerMessage=GenUtil.getHMvalue(getEventConfigMap(groupid),"eventpage.logo.message","");
	if(trackPartnerPhoto==null||"".equals(trackPartnerPhoto))
		trackPartnerPhoto=GenUtil.getHMvalue(getEventConfigMap(groupid),"eventpage.logo.url","");
	if(trackPartnerPhoto!=null&&!"".equals(trackPartnerPhoto)){
		trackPartnerPhoto="<img src='"+trackPartnerPhoto+"' width='200'/>";
	}
	hm.put("trackPartnerMessage",trackPartnerMessage);
	hm.put("trackPartnerPhoto",trackPartnerPhoto);
	return hm;
}


public String getRsvpButton(String groupid){
		
		return ((String)getGlobalStaticMap().get("rsvpbutton")).replace("##groupid##", groupid);
}

public String getFbShareButton(String groupid){
	if("Y".equals((String)getEventConfigMap(groupid).get("event.fbshare.show"))){
		
		return ((String)getGlobalStaticMap().get("fbshare")).replace("##groupid##", groupid);
	}
	else return "";
				
}

public String getFbLikeButton(String groupid){
	if(!"N".equals((String)getEventConfigMap(groupid).get("event.fblike.show"))){
       
       	return ((String)getGlobalStaticMap().get("fbLikeButton")).replace("##groupid##", groupid);
    }else return "";
}

public String getFbTwitterButton(String groupid){
	if(!"N".equals((String)getEventConfigMap(groupid).get("event.twitter.show"))){
		
		return ((String)getGlobalStaticMap().get("twitter")).replace("##groupid##", groupid).replace("##eventname##", getEventName(groupid));
	}else return "";
}

public String getFbComment(String groupid){
	if(!"N".equals((String)getEventConfigMap(groupid).get("event.fbcomment.show"))){
	
		return ((String)getGlobalStaticMap().get("fbcomment")).replace("##groupid##", groupid);
	}else return "";
}

public String getFbSendButton(String groupid){
	if(!"N".equals((String)getEventConfigMap(groupid).get("event.fbsend.show"))){
		
		return ((String)getGlobalStaticMap().get("fbsend")).replace("##groupid##", groupid);
	}else return "";
}

public String getGooglePlusOne(String groupid){
	if(!"N".equals((String)getEventConfigMap(groupid).get("event.googleplusone.show"))){
		
		return ((String)getGlobalStaticMap().get("googleplusone")).replace("##groupid##", groupid);
	}else return "";
}

public String getFBRSVPList(String groupid){
	if("Y".equals((String)getEventConfigMap(groupid).get("event.FBRSVPList.show")) && !"".equals((String)getEventConfigMap(groupid).get("event.FBRSVPList.eventid"))){
		
		return ((String)getGlobalStaticMap().get("fblist")).replace("##groupid##", groupid);
	}else return "";

}

public String getFbIBoughtButton(String groupid){
	if(!"N".equals((String)getEventConfigMap(groupid).get("event.fbiboughtbutton.show"))){
		
		return ((String)getGlobalStaticMap().get("fbibought")).replace("##groupid##", groupid);
	}else return "";
}

public String getSocialPromotions(String groupid){
	if("Y".equals((String)getEventConfigMap(groupid).get("event.socialmediapromotions.show"))){
	
		return ((String)getGlobalStaticMap().get("promos")).replace("##groupid##", groupid);
	}else return "";
}

public String getRSVPScript(){

	return (String)getGlobalStaticMap().get("rsvpreg_script");
}
public String getRegularScript(){
	
	return (String)getGlobalStaticMap().get("reg_script");
	
}
public String getEventGenralScript(){
	
	return (String)getGlobalStaticMap().get("general_script");
	
}

public String getSeatingScript(String groupid,String venueid){		
	
	return (String)getEventInfoMap(groupid).get("seatingcontent");
}
public String getNTSGenScript(String groupid){	
	return (String)getEventInfoMap(groupid).get("ntsGenContent");
}

public  String getCalanderLink(String groupid){	
	 return (String)getEventInfoMap(groupid).get("calanderLink");
		
}


public HashMap getCustomCssHtmlMap(String groupid, HttpServletRequest request){
	
	if(request.getParameter("preview")!=null && "show".equals(request.getParameter("preview"))){
		HashMap hm = new HashMap();
		String customcss="";String templatedata="";
		HashMap previewMap=ThemeController.getPreviewCSSAndHTML(groupid);
		if(previewMap.size()>0){
			customcss=(String)previewMap.get("CSS");
			templatedata=(String)previewMap.get("HTML");
			}
		
		if(request.getParameter("preview_pwd")!=null && "no".equals(request.getParameter("preview_pwd"))){
			
	   if( customcss!=null)
	   {  String css="";
		   int bodyin=customcss.indexOf("body");
	      if((bodyin)>-1)
	     {   String tempcss=customcss.substring(bodyin);
	         css= tempcss.substring(tempcss.indexOf("{"), tempcss.indexOf("}"));
	         css=".main-container"+css+"}";
	     }
	     customcss=css+customcss+"body{background:none;}";	
	     }	
	  if(templatedata!=null) 
	   {  String tepl="";
	      int bodyin=templatedata.indexOf("<body>");
	      int bodyout=templatedata.indexOf("</body>");
		  if(bodyin>-1)
	     {
			  templatedata=templatedata.substring(0, bodyin+6)+"<div id =	\"main-container\"	class=	\"main-container\"	 style=\"width:1100px\">"+
		   templatedata.substring(bodyin+6,bodyout)+"</div>"+templatedata.substring(bodyout);
	     }
	   }
			   
	}
	
		hm.put("customcss",customcss);
		hm.put("templatedata",templatedata);
		return hm;
	}
else
 return (HashMap)(getEventInfoMap(groupid).get("customCssMap"));

	
}
%>