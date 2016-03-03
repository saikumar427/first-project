<%@ page import="org.eventbee.sitemap.util.Presentation" %>
<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.customconfig.*" %>

<%!
		HashMap[] getMemberTabs(String unitid, String userid){
				 String[] ebeeCategoryCodes=EventbeeStrings.getMemberMenuCategoryCodes();
				 String[] ebeeCategoryValues=EventbeeStrings.getMemberMenuCategoryValues();
				 String[] ebeeCategoryURLS=EventbeeStrings.getMemberMenuURLS(userid,unitid);
				 HashMap[] tabs=new HashMap[ebeeCategoryValues.length];
				 List Mem_tabs=null;
				 Mem_tabs=new MemberFeatures(unitid).getFeaturesAsList();
				 for(int i=0;i<ebeeCategoryCodes.length;i++) {
				  if(Mem_tabs.contains(ebeeCategoryValues[i])){
				   HashMap tabhm=new HashMap();
				   tabhm.put("taburl",ebeeCategoryURLS[i]);
				   tabhm.put("tabname",ebeeCategoryCodes[i]);
				   tabs[i]=tabhm;
				  }
				 }
				 return tabs;
		}


		public String getTabURL(String url, String punitid){
			String returl="";

			if(url !=null){
				url=url.trim();
				if(punitid !=null){
					returl=url;
				}else{
					if( !url.startsWith("http")){
						String serveraddress="http://"+EbeeConstantsF.get("serveraddress","www.beeport.com");
						returl=serveraddress+url;
					}
				}

			}

			return returl;

		}

%>


<%
	String SESSION_TRACKID="";
	Cookie[] myCookies = request.getCookies( );
if(myCookies!=null){
	for (int i=0; i<myCookies.length; i++) {
		Cookie c = myCookies[i];
		if (c.getName( ).equals("SESSION_TRACKID")) {
		SESSION_TRACKID=c.getValue();
		}
	}//end for mycockies
}
    EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"toplnf.jsp, "+((request.getRequestURL()!=null)?request.getRequestURL().toString():""),"Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+",time: "+(new java.util.Date()).toString(),null);
    EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"toplnf.jsp","SESSION_TRACKID: "+SESSION_TRACKID,"time: "+(new java.util.Date()).toString(),null);



String context_app="/portal";

%>


<jsp:include page='/auth/proxydetector.jsp' />

<jsp:include page='/stylesheets/CoreRequestMap.jsp' />


<%
String HEADER=null;
	/*Presentation presentation=new Presentation(pageContext);

	request.setAttribute("PRESENTATION",presentation);
	


	if(AuthUtil.getAuthData(pageContext) != null){
		HEADER=presentation.lnf.getPostLoginHeader();
	}
	if( HEADER==null ||"".equals(HEADER.trim() ) ){
		HEADER=presentation.lnf.getHeader();
	}
	if( HEADER==null){
		HEADER="";
	}else
	HEADER=HEADER.trim();

	HashMap LOOKNFEELMAP=presentation.lnf.getLooknFeel();
     */
	String tabExists="Yes";
	String navPos="side";
	String navigator="";//presentation.lnf.getNavigation();
    /*    if(!"No".equalsIgnoreCase(tabExists)){
		if(navigator==null || "".equals(navigator.trim())){
	 		if(navPos==null || "".equals(navPos.trim()))
	 			navPos="side";
		}else{
			navPos="top";
		}
	 }else{
	 	navPos="";
	 }*/
	 HashMap LOOKNFEELMAP=new HashMap();
	HashMap REQMAP=(HashMap)request.getAttribute("REQMAP");
	session.setAttribute("entryunitid",(String)REQMAP.get("UNITID"));
	String serveraddress_https1="https://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");
%>
<html>
<head>
 <link rel="stylesheet" type="text/css" href="/home/index.css" />
<%if("yes".equals(request.getAttribute("metayes"))){%>
<META NAME="Description" CONTENT="Desihub is the first Indian community portal built
on the foundation of giving back! Desihub allows you to create local special
interest Hubs, make new Friends through existing Friends, Find and participate in
local Events and Activities, Classifieds, Weblogs, Jobs, Volunteering and much
more!">
<META NAME="Keywords" CONTENT="India, Indian community, Indian Classifieds, Indian
Events, Social Networking, Desihub, Desi, Desi Events, Weblogs, Indian weblogs,
India travel, Movies, Indian non-profits, Desi networking">

<META name="robots" content="index, follow">
<!--<META HTTP-EQUIV="expires" CONTENT="-1">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">-->
<%}%>
<META Http-Equiv="Cache-Control" Content="no-cache">
<META Http-Equiv="Pragma" Content="no-cache">
<META Http-Equiv="Expires" Content="0">
<title>Eventbee<%--=presentation.genTitle() --%></title>
<%--
	presentation.includeScripts();
	presentation.includeStyles();
--%>
<script language="javascript" src="<%=(request.isSecure())?EbeeConstantsF.get("js.webpath","http://www.beeport.com/home/js").replaceAll("http","https"):EbeeConstantsF.get("js.webpath","http://www.beeport.com/home/js")%>/popup.js">
 function dummy11(){}
</script>






</head>
<jsp:include page='/stylesheets/ebeeip.jsp' />

<body topmargin="0" leftmargin="0" rightmargin="0" marginheight="0" marginwidth="0">


<style type="text/css">
.tasktitle {
 border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px;
 }
 .portaltitle { background-color: #d8ec79; font-family: verdana; font-size: 14px; color: #234600; padding-top: 1px; padding-right: 5px; padding-bottom: 1px; padding-left: 5px;; border-color: 234600 black; border-style: solid; border-top-width: 1px; border-right-width: 0px; border-bottom-width: 1px; border-left-width: 0px}
.beelettable { background-color: #eeeee8;  color: #000000; ; border: 0px #AAAAAA none}  
.inputlabel { padding-left: 5px; padding-right: 5px; padding-top: 2px; padding-bottom:2px}
.inputvalue { padding-left: 5px; padding-right: 5px; padding-top: 2px; padding-bottom:2px}
.subheader{ font-family: Verdana; font-size: 15px; font-weight: bold; padding-left: 5px; padding-right: 5px; padding-top: 2px; padding-bottom:2px}


</style>



<table border="0" width1="100%" width='800' cellspacing="0" cellpadding="0" class="portalback" align='center' >
	<tr><td align="center" valign='top' >
	<%if((request.getAttribute("customlookid")!=null)&&(!"".equals(HEADER))){%>
				<%=HEADER%>
				<%@include file="hubheader.jsp" %>
		<%}else{%>
			<jsp:include page='/stylesheets/ebeeheader.jsp' />
		<%}%>

	</td></tr>
	
	<tr>
	<td colspan='4' background='yellow' >
		<jsp:include page='/stylesheets/DesiTabSetter.jsp' />
		<jsp:include page="/stylesheets/ebeenavhorizontal.jsp" />
	</td>
	</tr>
	<%if(  (request.getAttribute("dispalysubmenu") !=null) ||  (request.getAttribute("displaydesiborderfull") !=null) ){%>
	<tr><td height='10' colspan='4'></td></tr>
	<%}%>
	<tr><td align="center" valign="top" >
	
	
	<%
							 	boolean displaysubmenu=false;
System.out.println("subtabtype: "+request.getAttribute("subtabtype"));
System.out.println("dispalysubmenu: "+request.getAttribute("dispalysubmenu"));




							 	if(request.getAttribute("dispalysubmenu") !=null  ){
								
									displaysubmenu=true;
									String submenulink="";
									if("Snapshot".equalsIgnoreCase( (String)request.getAttribute("dispalysubmenu") )  ){
										submenulink="/lifestyle/lifestylesubmenu.jsp";
									}    
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"toplnf.jsp",null,"dispalysubmenu value is--"+request.getAttribute("dispalysubmenu"),null);
String submenu=(String)request.getAttribute("dispalysubmenu");

									if("Events".equalsIgnoreCase((String)request.getParameter("type"))  ){
									
										submenulink="/myevents/eventsubmenu.jsp";
									}
									if("Events".equalsIgnoreCase((String)request.getAttribute("dispalysubmenu"))  ){
									
										submenulink="/myevents/eventsubmenu.jsp";
									}
									
									if("My Settings".equalsIgnoreCase( (String)request.getAttribute("dispalysubmenu") )  ){
										submenulink="/preferences/mysettingssubmenu.jsp";
									}
								           
									if("My EmailCampaigns".equalsIgnoreCase( (String)request.getAttribute("dispalysubmenu") )  ){
									    submenulink="/listmgmt/campaignsubmenu.jsp";
									}
									if(displaysubmenu){
								
							 %>
<%EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"toplnf.jsp",null,"submenulink value is--"+submenulink,null);%>							 
							 <table cellspacing='0' cellpadding='0' width='100%'>
							 <tr><td align='left'>
							 	<jsp:include page='<%=submenulink %>' />
							</td></tr>	
								<%
								}//end if displaysubmenu
								%>
							 
							 <%
							 	}										
								 // end of dispalysubmenu !=null
							 %>

				<%
				
				if(request.getAttribute("dispalysubmenu") !=null  ){
				
				
				if("My Pages".equals(request.getAttribute("subtabtype"))&&"photos".equals(request.getAttribute("submenu"))){
				%>
				<tr><td  align='left'>
							<jsp:include page='/photogallery/photomenu.jsp' />
				</td></tr>
				<%}else if("mynetwork".equals(request.getAttribute("submenu"))){%>
				<tr><td  align='left'>
							<jsp:include page='/lifestyle/lifestylesubmenu.jsp' />

							</td></tr>
							<%}else if("mylifestyle".equals(request.getAttribute("submenu"))){%>
				<tr><td  align='left'>
							<jsp:include page='/lifestyle/lifestylesubmenu.jsp' />

							</td></tr>
							
   			    <%}else if("addmembers".equals(request.getAttribute("submenu"))){%>
				<tr><td  align='left'>
							<jsp:include page='/listmgmt/addmemssubmenu.jsp' />

			    </td></tr>
				
				<%}else if("members".equals(request.getAttribute("submenu"))){%>
				<tr><td  align='left'>
				<div id='updatemembers'>
							<jsp:include page='/listmgmt/membersubmenu.jsp' />
				</div>
			    </td></tr>
			    <%}else if("My Events".equals(request.getAttribute("submenu"))){%>
				<tr><td  align='left'>
							<jsp:include page='/myevents/manageEventsSubMenu.jsp' />
				
			    </td></tr>
			    
				
				<%}
				else if("Events".equals(request.getAttribute("dispalysubmenu"))){%>
				<tr><td  align='left'><jsp:include page='/club/managehubsSubMenu.jsp' />
			       </td></tr>
			       				<%}
				
				
				
				
				
				
				else if("mylifestyle".equals(request.getAttribute("subtabtype"))){%>
                                   <tr><td height='20' class='tabhighlightcolor'></td></tr>
				<%}else if("Events".equals(request.getAttribute("dispalysubmenu"))){%>
					<tr><td height='20' class='tabhighlightcolor'></td></tr>
				<%}else if("My Settings".equals(request.getAttribute("dispalysubmenu"))){%>
					<tr><td height='20' class='tabhighlightcolor'></td></tr>
				<%}else if("My EmailCampaigns".equals(request.getAttribute("dispalysubmenu"))){%>
					<tr><td height='20' class='tabhighlightcolor'></td></tr>
				<%}%>
				<tr><td align='center' class='desiborder'></td></tr>
							
								
				<%}
				else{
				
				if(request.getAttribute("displaydesiborderfull") !=null && 
					request.getAttribute("dispalysubmenu") ==null){
				%>
				
					<tr><td align='center' class='desibordernontabcontent'>
				<%
				}}
				%>
				
				
				
							
				
	
		<table border="0" width="100%" cellpadding="0" cellspacing="0" valign="top" class="portalback">
			<tr bgcolor='<%=(LOOKNFEELMAP.get("portalbackground")!=null)?(String)LOOKNFEELMAP.get("portalbackground"):"#FFFFFF"%>' >
			 	<td valign="top" align="left" height1="500" >
					
					</td>
				<td  valign="top"  align="center">
				<%
				String TASK_ALLIGNMENT="left";
				if(AuthUtil.getAuthData(pageContext) == null||("13578".equals(request.getParameter("UNITID"))))
				TASK_ALLIGNMENT="center";
				
				%>
					<table valign="top" align="<%=TASK_ALLIGNMENT%>"  bgcolor='<%=(LOOKNFEELMAP.get("portalbackground")!=null)?(String)LOOKNFEELMAP.get("portalbackground"):"#FFFFFF"%>' height='400' cellpadding='0' cellspacing='0'>
					<tr><td height="10"></td></tr>
					<tr>
						<td colspan='3' align="left" width="100%">
						<% if(request.getAttribute("topcontent") !=null){ %>
						<jsp:include page="<%=(String)request.getAttribute("topcontent") %>" />
						<%}%>
						</td>
					</tr>
					<tr>
						<td  valign="top" align='left' width='<%=(request.getAttribute("tasktitle") !=null)?"700":"1000"%>' >
								
						<table  class="maintable" width='100%'  cellspacing="0" cellpadding="0">							 
							 <% if(request.getAttribute("NavlinkNames") !=null){
							 String[] NavlinkNames=(String[])request.getAttribute("NavlinkNames");
							 String[] NavlinkURLs=(String[])request.getAttribute("NavlinkURLs");
							 %>
							 <tr><td align="right" colspan='2'>
							 <%for(int urlindex=0;urlindex<NavlinkNames.length;urlindex++){
							 String sepstr=(urlindex+1==NavlinkNames.length)?"":" | ";
							 %>
							 <a href='<%=PageUtil.appendLinkWithGroup(NavlinkURLs[urlindex],(HashMap)request.getAttribute("REQMAP"))%>'><%=NavlinkNames[urlindex]%></a><%=sepstr%>
							 <%}%>
							 </td></tr>

							<% }%>
							 <tr>
							 
							 	<% String tmp_subtitle="";
								%>
							 	<td <%=  (request.getAttribute("tasktitle")!=null)?"class='desiborderfull'":""  %>     >
								
								 <% if(request.getAttribute("tasktitle") !=null){ %>
								 	<div  style='float:left'>
									 <%=request.getAttribute("tasktitle") %>
									 </div>
									 <% }%>
									
									 <% if(request.getAttribute("tasksubtitle") !=null)
								 tmp_subtitle=((String)request.getAttribute("tasksubtitle")).trim();
								  if("".equals(tmp_subtitle))
									tmp_subtitle=" ";
								  %>
								  <% if(request.getAttribute("tasktitle") !=null){%>
								   <div style='float:right'><%=tmp_subtitle%></div>
								   <%}%>
								</td>
							 	
							 </tr>
							 
							 <tr>
							 <td colspan='2' align='center'>





