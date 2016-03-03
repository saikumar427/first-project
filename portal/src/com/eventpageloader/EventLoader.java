package com.eventpageloader;
import java.util.*;
import java.io.*;
import org.eventbee.sitemap.util.Presentation;
import com.eventbee.general.*;

import javax.servlet.http.*;
import org.apache.velocity .*;

import org.apache.velocity.app.* ;
import com.eventbee.streamer.*;
import com.themes.*;


public class EventLoader{


public static void ProcessVelocity(HttpServletRequest request,HttpSession session,HttpServletResponse httpservletresponse,HashMap attribsMap){



 // HttpSession session = request.getSession();

	String groupid=Presentation.GetRequestParam(request, new String []{"eid","eventid", "id","GROUPID"});
	String userid=EventPageContent.getEventInfoForKey("mgr_id",request,"");
	PrintWriter out=null;
	try{
	 out=httpservletresponse.getWriter();
 }
 catch(Exception e)
 {


 }
	String platform=(String)session.getAttribute("platform");

	session.removeAttribute("Custom_"+groupid);
	session.removeAttribute(groupid+"_OldTranId");
	session.removeAttribute("discountcode_"+groupid);
	session.removeAttribute(groupid+"community_login");
	session.removeAttribute("CouponContent_"+groupid);
	session.removeAttribute("MemCouponContent_"+groupid);
	session.removeAttribute("discountcode");

	//EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"Entered","",null);
	String templatedata="";
	String templatecss="";
	String themetype=null;
	String deftheme=null;
	String [] themedata=null;
	String thememodule=null;
	String themeexist="yes";
	String customcss="";
	String modul="";
	String google_traffic_monitor=(String)request.getAttribute("GOOGLE_TRAFIC_MONITOR");
	String fbcontext=(String)session.getAttribute("context");

	if("FB".equals(fbcontext)){
	modul="event_fb";
	}else{
    modul="event%";
	}
	String [] themeNameandType=ThemeController.getThemeCodeAndType(modul,groupid,"basic");
	themetype=themeNameandType[0];
	deftheme=themeNameandType[1];
	thememodule=themeNameandType[3];
	if(thememodule==null)
	thememodule="event";
	String partnerid=(String)session.getAttribute("Streamer_Partner");
	if(partnerid==null)
	 partnerid=EbeeConstantsF.get("networkadv.partner","3809");
	boolean isnewsession=(session.getAttribute(groupid+"_partner_streamer_event")==null);

	if(isnewsession)
	{
	session.setAttribute(groupid+"_partner_streamer_event","yes");
	PartnerTracking pt=new PartnerTracking();
	pt.setGroupId(groupid);
	pt.setInsertionType("clicks");
	pt.setPartnerId(partnerid);
	pt.start();
	}
	//EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"deftheme====="+deftheme,"",null);
	//EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"themetype====="+themetype,"",null);


			if("FB".equals(fbcontext)){
				if("DEFAULT".equals(themetype)){
					deftheme=DbUtil.getVal("select fbtheme  from facebook_ebee_themes where ebeetheme=?", new String []{deftheme});
					if(deftheme==null)
						deftheme="basic";
					themedata=ThemeController.getSelectedThemeData(userid,thememodule,deftheme,"event_fb",groupid,themetype);
				}else{
					themedata=ThemeController.getDefaultThemeData("basic","event_fb");
				}
			}
			else{
			if("ning".equals(platform)){
			deftheme="basic";
			themedata=ThemeController.getSelectedThemeData(userid,"event_ning",deftheme,"event_ning",groupid,themetype);

			}else
			themedata=ThemeController.getSelectedThemeData(userid,thememodule,deftheme,"event",groupid,themetype);
			}
			customcss=themedata[0];
			templatedata=themedata[1];
			if(request.getParameter("preview")!=null && "show".equals(request.getParameter("preview"))){
				HashMap previewMap=ThemeController.getPreviewCSSAndHTML(groupid);
				if(previewMap.size()>0){
					customcss=(String)previewMap.get("CSS");
					templatedata=(String)previewMap.get("HTML");
					}
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
				    // System.out.println("css::"+css+" bodyin::"+bodyin);
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
					 // System.out.println("  templatedata=tepl;"+  bodyin +"  "+bodyout);
				   }
				   
			}
			
			
			
			try{
				VelocityContext context = new VelocityContext();
				try{
				customcss=customcss.replaceAll("\\$resourcesAddress", request.getAttribute("resourcesAddress")+"");
				customcss=customcss.replaceAll("url\\(/home", "url\\("+ request.getAttribute("resourcesAddress")+""+"/home");
				customcss=customcss.replaceAll("url\\(/main", "url\\("+ request.getAttribute("resourcesAddress")+""+"/main");
				customcss=customcss.replaceAll("url\\(\"/main", "url\\(\""+ request.getAttribute("resourcesAddress")+""+"/main");
				}catch(Exception e){
					System.out.println("Exception occured while replacing customcss for event ::"+groupid+" :: "+e.getMessage());
				}
				context.put ("customcss",customcss  );
				context.put ("resourcesAddress", request.getAttribute("resourcesAddress")+"");
	      		context.put ("eventbeeHeader",request.getAttribute("BASIC_EVENT_HEADER") );
				context.put ("eventbeeFooter",request.getAttribute("BASICEVENTFOOTER") );
	            context.put ("eventbeeheader",request.getAttribute("BASIC_EVENT_HEADER") );  //For backward compatibility
				context.put ("eventbeefooter",request.getAttribute("BASICEVENTFOOTER") );    //For backward compatibility
	            context.put ("eventName",request.getAttribute("EVENTNAME") );
				context.put ("creditcardLogos",request.getAttribute("CREDITCARDLOGOS") );
				context.put ("requiredTickets",request.getAttribute("REQUIREDTICKETS") );
				if("yes".equals(request.getAttribute("ONLYOPTTICKETS"))){
				context.put ("onlyOptionalTickets",request.getAttribute("ONLYOPTTICKETS") );
				context.put ("onlyoptinal",request.getAttribute("ONLYOPTTICKETS") );
				}
			    context.put ("optionalTickets",request.getAttribute("OPTIONALTICKETS") );
				context.put ("registerButton",request.getAttribute("REGISTRATIONFORM") );
				context.put ("startDate",request.getAttribute("STARDATE") );
				context.put ("endDate",request.getAttribute("ENDDATE") );
				context.put ("addCalendarLink",request.getAttribute("ADDCALENDARLINK") );
				context.put ("fullAddress",request.getAttribute("FULLADDRESS") );
				if(request.getAttribute("GOOGLEMAP")!=null){
				context.put ("googleMap",request.getAttribute("GOOGLEMAP") );
				context.put ("GOOGLEMAP",request.getAttribute("GOOGLEMAP") );  //For backward compatibility
				context.put ("mapString",request.getAttribute("mapstring") );
				context.put ("mapstring",request.getAttribute("mapstring") );  //For backward compatibility
	             }
				context.put ("description",request.getAttribute("DESCRIPTION") );
				context.put ("eventPhoto",request.getAttribute("EVENTPHOTO")==null?"":request.getAttribute("EVENTPHOTO"));
				context.put ("trackPartnerMessage",request.getAttribute("TRACKMESSAGE") );
				context.put ("trackPartnerPhoto",request.getAttribute("TRACKPHOTO") );
				context.put ("networkTktEnabled",request.getAttribute("NETWORKTICKETENABLE"));
				context.put("networkSellingMsg",request.getAttribute("NETWORKSELLINGBLOCK"));
				if("true".equals((String)request.getAttribute("RSVPALLOWED"))){
				context.put ("rsvpButton",request.getAttribute("RSVPBUTTON") );
				}
				context.put ("currencyFormat",request.getAttribute("CURRENCYFORMAT") );
				context.put ("eventListedBy",request.getAttribute("EVENTLISTEDBY") );
				context.put ("eventlink",request.getAttribute("EVENTLINK") );   //For backward compatibility
				context.put ("eventLink",request.getAttribute("EVENTLINK") );
				context.put ("contactMgrlink",request.getAttribute("CONTACTMGRLINK") );
				context.put ("mgrEventsLink",request.getAttribute("MGREVENTSLINK") );
				context.put ("emailToFriendLink",request.getAttribute("EMAILTOFRIENDLINK") );
				context.put ("viewAttendeeList",request.getAttribute("ATTENDEELIST") );
				context.put ("notices",request.getAttribute("NOTICES") );
				context.put ("partnerStreamer",request.getAttribute("PARTNERSTREAMER"));
				context.put ("partnerStreamerShow",request.getAttribute("PARTNERSTREAMERSHOW"));
				context.put ("partnerstreamer",request.getAttribute("PARTNERSTREAMER"));          //For backward compatibility
				context.put ("partnerstreamershow",request.getAttribute("PARTNERSTREAMERSHOW"));   //For backward compatibility
				context.put ("groupUrl",request.getAttribute("GROUPURL"));          //For backward compatibility
				context.put ("groupName",request.getAttribute("GROUPNAME"));   //For backward compatibility
	            context.put ("eventURL",request.getAttribute("EVENTURL"));
	           System.out.println("context:::"+context);
	            if(attribsMap!=null){
					Set attribmapKeys=attribsMap.keySet();
					Iterator attribIterator=attribmapKeys.iterator();
					 while(attribIterator.hasNext()){
					    String mapKey=(String)attribIterator.next();
					    context.put(mapKey,attribsMap.get(mapKey));
					  }
		            }
		  	 VelocityEngine ve= new VelocityEngine();
		  	 ve.init();
		  	boolean abletopares=ve.evaluate(context,out,"ebeetemplate", templatedata );
		    }
		    catch(Exception exp){
		    	System.out.println(exp.getMessage());
		    }







}









}
