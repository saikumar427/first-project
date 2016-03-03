<%@ page import="java.io.*,java.util.*,com.eventbee.general.*,com.eventregister.*,com.customquestions.*,com.customquestions.beans.*" %>
<%@ page import="org.apache.velocity .*,org.apache.velocity.app.Velocity,org.apache.velocity.context.*,org.apache.velocity.exception.*,org.apache.velocity.app.*" %>
<%@ page import="org.json.*,com.event.dbhelpers.*"%>
<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ include file="profilepagedisplay.jsp" %>
<%@ page import="com.eventbee.cachemanage.CacheManager"%>
<%
String  SSLProtocol=EbeeConstantsF.get("SSLProtocol","https");
String sslserveraddress=SSLProtocol+"://"+EbeeConstantsF.get("sslserveraddress","www.eventbee.com");
RegistrationTiketingManager regTktMgr=new RegistrationTiketingManager();
ProfilePageDisplay profilePageDisplay=new ProfilePageDisplay();
ProfilePageVm profilepage=new ProfilePageVm();
TicketsDB tktdb=new TicketsDB();
String tid=request.getParameter("tid");
String eid=request.getParameter("eid");
//HashMap configMap=tktdb.getConfigValuesFromDb(eid);
//HashMap profilePageLabels=DisplayAttribsDB.getAttribValues(eid,"RegFlowWordings");
HashMap profilePageLabels=null;
HashMap configMap=null;
try{
	Map ticketSettingsMap=CacheManager.getData(eid, "ticketsettings");
	configMap=(HashMap)ticketSettingsMap.get("configmap");
	profilePageLabels=(HashMap)ticketSettingsMap.get("RegFlowWordingsMap");
}catch(Exception e){
	System.out.println("Exception in ProfilePageDisplay getProfilesJson eventid: "+eid+" ERROR: "+e.getMessage());
}
String copyfrombuyer=GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.copybuyerinfo.label","Copy from Buyer Info");
HashMap attribMap=profilepage.getProfilePageVmObjects(tid,eid,copyfrombuyer);
VelocityContext context = new VelocityContext();
String promotionscetion=null;

profilepage.fillVelocityContextForProfilePage(eid,context,profilePageLabels);
//************************************************************
String backButtonLabel=GenUtil.getHMvalue(profilePageLabels,"event.reg.backbutton.label","Back To Tickets");
String continueLabel=GenUtil.getHMvalue(profilePageLabels,"event.reg.profilepage.continue.label","Continue");
//****************************************************************
if("Yes".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"show.ebee.promotions","No")))
{
promotionscetion="<span class='toggle'><input type='checkbox'  id='enablepromotion' name='enablepromotion' value=''  /> </span>"+GenUtil.getHMvalue(profilePageLabels,"promotion.section.message","I would like to receive promotions and discounts from Eventbee and its partners") ;
}

String type=null;
String  backbutton="<a href='javascript:;'  onClick=getTicketsPage(); >"+backButtonLabel+"</a>";
String continuebtn="<div class='buyticketssubmit' style='float:right' ><input type='button' id='profilesubmitbtn'  name='continue'    value='"+continueLabel+"' onClick=validateProfiles('"+tid+"'); class='buyticketsbutton' onmouseover='javascript:this.className=\"buyticketsbuttonhover\"' ; onmouseout='javascript:this.className=\"buyticketsbutton\"';>";


if("mobile".equals(request.getParameter("regtype"))){
	//backbutton="<a href='#registration' class=' slide whiteButtonlink' onClick=getTicketsPage(); >"+backButtonLabel+"</a>";
	backbutton="";
	continuebtn="<center><li style='list-style: none;'><a href='#mregister' class='slide'><input type='button' class='buybutton' id='profilesubmitbtn'  name='continue'    value='"+continueLabel+"' onClick=validateProfiles('"+tid+"'); /></a></li></center>";
	
}

String profileForm="<form action='/embedded_reg/profileformaction.jsp'  name='ebee_profile_frm'  id='ebee_profile_frm'  method='post' /><input type='hidden' name='eid' value='"+eid+"' /><input type='hidden' name='attribsetid' value='"+attribMap.get("arribsetid")+"' />";
String profileFormClose="</form>";
//String template=regTktMgr.getVelocityTemplate(eid,"profile_page");
String template=(String)profilePageDisplay.getBaseProfileMap(eid).get("profilepagetemplate");
context.put("profileObject",attribMap);
context.put("backLink",backbutton);
context.put("profileForm",profileForm);
context.put("continue",continuebtn);
context.put("profileFormClose",profileFormClose);

if(promotionscetion!=null)
context.put("promotionSection",promotionscetion);
VelocityEngine ve= new VelocityEngine(); 
try{
ve.init();
boolean abletopares=ve.evaluate(context,out,"ebeetemplate", template);
}
catch(Exception exp){
out.println("---"+exp.getMessage());
}  


%>