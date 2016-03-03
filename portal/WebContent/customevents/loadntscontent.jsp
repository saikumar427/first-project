<%@page import="java.util.HashMap"%>
<%@page import="com.eventbee.general.EbeeConstantsF"%>
<%@page import="com.eventbee.cachemanage.CacheManager"%>


<%
	String serveraddress="http://"+EbeeConstantsF.get("serveraddress","")+"/";
    String groupid=request.getParameter("groupid");
	StringBuffer hidden_attrib_mapcontent=new StringBuffer();
	String og_image_metatag="<meta property='og:image' content='"+request.getParameter("event_photo_src")+"'/>";	
	hidden_attrib_mapcontent.append("<div id='fb-root'></div><script>var servadd='"+serveraddress+"';var  fbavailable=false;window.fbAsyncInit=function(){fbavailable=true;FB.init({appId:'"+request.getParameter("fbappid")+"',status:true,cookie:true,xfbml:true})};(function(a){var b,c='facebook-jssdk';if(a.getElementById(c)){return}b=a.createElement('script');b.id=c;b.async=true;b.src='//connect.facebook.net/en_US/all.js';a.getElementsByTagName('head')[0].appendChild(b)})(document)</script>");
	hidden_attrib_mapcontent.append(og_image_metatag+"<script type='text/javascript' language='JavaScript' src='##resourceaddress##/home/js/jQuery.js'></script>");
	hidden_attrib_mapcontent.append("<input type='hidden' name='registrationsource' id='registrationsource' value='regular'><input type='hidden' name='venueid' id='venueid' value='"+request.getParameter("venueid")+"'/><input type='hidden' name='isseatingevent' value='"+request.getParameter("isseatingevent")+"' id='isseatingevent'/><input type='hidden' name='fbsharepopup' id='fbsharepopup' value='"+request.getParameter("fbsharepopup")+"'>");
	hidden_attrib_mapcontent.append("<input type='hidden' name='nts_enable' id='nts_enable' value='"+request.getParameter("nts_enable")+"'><input type='hidden' name='nts_commission' id='nts_commission' value='"+request.getParameter("nts_commission")+"'>");
	hidden_attrib_mapcontent.append("<input type='hidden' id='login-popup' name='login-popup' value='"+request.getParameter("fbloginpopup")+"'>");
	hidden_attrib_mapcontent.append("<input type='hidden' name='fbappid' id='fbappid' value='"+request.getParameter("fbappid")+"'>");
	hidden_attrib_mapcontent.append("<input type='hidden' name='eventstatus' id='eventstatus' value='"+request.getParameter("eventstatus")+"'>");
    //out.println(hidden_attrib_mapcontent.toString());    
    HashMap ntsconetnt=new HashMap();
    ntsconetnt.put("ntsGenContent",hidden_attrib_mapcontent.toString());
	CacheManager.updateData(groupid+"_eventinfo", ntsconetnt, false); 
	System.out.println("Loading the ntscontent sucessfully...");
%>
