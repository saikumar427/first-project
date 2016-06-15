<%@page import="com.eventbee.layout.DBHelper"%>
<%@page import="com.eventregister.CRegistrationDBHelper"%>
<%@page import="com.eventbee.general.GenUtil"%>
<%@page import="com.eventregister.CTicketsDB"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.util.Map"%>
<%@page import="com.eventbee.regcaheloader.LayoutManageLoader"%>
<%@page import="com.eventbee.cachemanage.CacheLoader"%>
<%@page import="com.eventbee.cachemanage.CacheManager"%>
<%@page import="com.eventpageloader.EventPageContent"%>
<%@page import="com.eventbee.general.DbUtil"%>
<%@page import="com.eventbee.general.EbeeCachingManager"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.eventbee.general.EventbeeLogger"%>
<%@page import="com.eventbee.general.EbeeConstantsF"%>
<%@include file="../getresourcespath.jsp" %>
<% 
	String csscontent=null,recurdateslabel="";
	String fb=request.getParameter("fb");
	if(fb==null)fb="false";
	System.out.println("fb::"+fb);
	
	String eid=request.getParameter("eid");
	String trackcode=request.getParameter("track");
	String display_ntscode=request.getParameter("nts");
	String disc=request.getParameter("code");
	String tc=request.getParameter("tc");
	String customtheme=request.getParameter("customtheme");
	String reqref=request.getParameter("referal");
	String serveraddress="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com")+"/";
	String Referer=request.getHeader("Referer");
	
	EventbeeLogger.log("com.eventbee.widgetref",EventbeeLogger.INFO,"REGISTRATIONWIDGET.JSP", "widgetReferer::"+eid+" by ::"+Referer,"", null);
	HashMap eventinfoMap=null;
	HashMap blockedEventsMap=(HashMap)EbeeCachingManager.get("blockedEvents");
	if(blockedEventsMap==null){
		blockedEventsMap=new HashMap();
		EbeeCachingManager.put("blockedEvents",blockedEventsMap);
	}
	if(eid==null || "".equals(eid)){
		System.out.println("Event Page(widget) with no eventid: ");
		response.sendRedirect("/guesttasks/invalidpage.jsp");
		return;
	}else{
		if(blockedEventsMap.get(eid)!=null){
			String cancelby=(String)blockedEventsMap.get(eid+"_cancelby");
			if(cancelby==null)cancelby="";	
			if("hightraffic".equals(cancelby)){}
			else{
				System.out.println("Event Page(widget) with blocked eventid: "+eid);
				response.sendRedirect("/guesttasks/invalidpage.jsp");
				return;
			}
		}
		
		try{
			int eventid=Integer.parseInt(eid);
			eventinfoMap=EventPageContent.getEventDetailsFromDb(eid);
			if(eventinfoMap==null || eventinfoMap.size()<1 ){
				String userid=DbUtil.getVal("select userid from user_groupevents where event_groupid =?" ,new String[]{eid});
				if(userid==null){
				System.out.println("Event Page(widget) with wrong eventid: "+eid);	
				response.sendRedirect("/guesttasks/invalidpage.jsp");
				return;
				}else{
					session.setAttribute("eventgroupid",eid);
					request.setAttribute("userid",userid);
					response.sendRedirect("/customevents/groupThemeProcessor.jsp?groupid="+eid);
					return;
				}
			}
		}catch(Exception e){
			System.out.println("Event Page(widget) with wrong eventid: "+eid);	
			response.sendRedirect("/guesttasks/invalidpage.jsp");
			return;
		}
	}
	
	request.setAttribute("eventinfohm",eventinfoMap);
	String eventstatus=EventPageContent.getEventInfoForKey("status",request,"ACTIVE");
	String cancelby=EventPageContent.getEventInfoForKey("cancel_by",request,"");
	if("CANCEL".equals(eventstatus)){
		blockedEventsMap.put(eid,"Y");
		blockedEventsMap.put(eid+"_cancelby",cancelby);
		if("hightraffic".equals(cancelby)){}
		else{
			System.out.println("Event Page(widget) with cancelled eventid: "+eid);	
			response.sendRedirect("/guesttasks/invalidpage.jsp");
			return;
		}
	}
	String notavail=null,unassign=null;
	String domain=request.getParameter("context");
	if(!CacheManager.getInstanceMap().containsKey("layoutmanage")){
		CacheLoader layoutManage=new LayoutManageLoader();
		layoutManage.setRefreshInterval(3*60*1000);
		layoutManage.setMaxIdleTime(3*60*1000);
		CacheManager.getInstanceMap().put("layoutmanage",layoutManage);		
	}
	if(CacheManager.getData(eid, "layoutmanage")==null || CacheManager.getInitStatus(eid+"_layoutmanage")){
		request.getRequestDispatcher("eventpageloading.jsp").forward(request, response);
		return ;
	}
	
	String jsonData="";
	Map layoutManageMap=new HashMap();
	layoutManageMap=CacheManager.getData(eid, "layoutmanage");
	jsonData = (String)layoutManageMap.get("layout");
	JSONObject layout = new JSONObject(jsonData);

	JSONObject global_style = layout.getJSONObject("global_style");
	//System.out.println(global_style);
	String content = global_style.getString("content");
	String contentText = global_style.getString("contentText");
	String header = global_style.getString("header");
	String border = global_style.getString("border");
	String headerText = global_style.getString("headerText");
	
	String headerTextFont="Verdana";
	String headerTextSize="16";
	String contentTextSize = "14";
	String contentTextFont = "Verdana";

	if(global_style.has("headerTextFont"))
		headerTextFont = global_style.getString("headerTextFont");
	if(global_style.has("headerTextSize"))
		headerTextSize = global_style.getString("headerTextSize");
	if(global_style.has("contentTextSize"))
		contentTextSize = global_style.getString("contentTextSize");
	if(global_style.has("contentTextFont"))
		contentTextFont = global_style.getString("contentTextFont");
	
	
	CTicketsDB ticketInfo=new CTicketsDB();
	HashMap configMap=ticketInfo.getConfigValuesFromDb(eid);
	boolean isrecurringevent=("Y".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.recurring","N")));
	boolean registrationAllowed=("Yes".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.poweredbyEB","no")));
	boolean isrsvpd=("Yes".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.rsvp.enabled","no")));
	String isseatingevent=GenUtil.getHMvalue(configMap,"event.seating.enabled","NO");
	String venueid=GenUtil.getHMvalue(configMap,"event.seating.venueid","0");
	String fbsharepopup=GenUtil.getHMvalue(configMap,"event.confirmationpage.fbsharepopup.show","Y");
	String isPriority=GenUtil.getHMvalue(configMap,"event.priority.enabled","N");
	String referral_ntscode="";
	String nts_enable=EventPageContent.getEventInfoForKey("nts_enable",request,"N");
	String nts_commission=EventPageContent.getEventInfoForKey("nts_commission",request,"0");
	if("".equals(nts_enable) || "N".equals(nts_enable)){
		nts_enable="N";
		nts_commission="0";
		//display_ntscode="";
	}
	try{
		if(Double.parseDouble(nts_commission)<0)
			nts_commission="0";
	}catch(Exception e){
			nts_commission="0";
	}
	if(display_ntscode==null)
		display_ntscode="";	
	if(!"".equals(display_ntscode)){
		String nts=DbUtil.getVal("select nts_code from ebee_nts_partner where nts_code=?",new String[]{display_ntscode});
		System.out.println("#visit with nts code#:"+display_ntscode+"*nts*"+nts+"eventid: "+eid);
		if(!"".equals(nts)&& nts!=null){
			if(session.getAttribute(eid+"ntsclick"+display_ntscode)==null){
				CRegistrationDBHelper regdbhelper=new CRegistrationDBHelper();
				referral_ntscode= regdbhelper.ValidateNTSCode(eid,display_ntscode);
			   	System.out.println("*ntsclick count*:"+display_ntscode);
			   	session.setAttribute(eid+"ntsclick"+display_ntscode,display_ntscode);
			}
			referral_ntscode=nts;
		}
		if(referral_ntscode==null )
			referral_ntscode="";
	}
	String fbappid=DbUtil.getVal("select value from config where config_id='0' and name='ebee.fbconnect.appid'",null);
	if(trackcode!=null){
		HashMap trackshm=EventPageContent.getTrackURLContet(eid,trackcode);
		if(trackshm.size()>0){
			session.setAttribute("trckcode",trackcode);
			request.setAttribute("Trackshm",trackshm);
	
			String status=EventPageContent.getTrackInfoForKey("status",request,"");
			if(!"Suspended".equals(status)){
				boolean trackURLsession=(session.getAttribute(eid+"_"+trackcode)==null);
				if(trackURLsession){
					session.setAttribute(eid+"_"+trackcode,trackcode);
					//DbUtil.executeUpdateQuery("update trackURLs set count=to_number(nvl(count,null,0),'9999999999')+1 where trackingcode=? and eventid=?",new String[]{trackcode,eid});
					DbUtil.executeUpdateQuery("update trackurls set count=cast(coalesce(cast(count as numeric),0) as numeric)+1 where trackingcode=? and eventid=?",new String[]{trackcode,eid});
				}
			}else
				trackcode=null;
		}else
			trackcode=null;
	}
%>

<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src='/home/js/i18n/<%= DBHelper.getLanguageFromDB(eid)%>/regprops.js'></script>
<link href="/main/bootstrap/css/bootstrap.css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css" />
<link rel="stylesheet" type="text/css" href="/angularTicketWidget/customJsCss/style.css" />
<link type="text/css" rel="stylesheet" href="/angularTicketWidget/css/tooltipster.css" />
<link rel="stylesheet" type="text/css" href="/angularTicketWidget/css/jquery-ui.css" />

<script type="text/javascript" src="/angularTicketWidget/js/jquery-1.12.3.min.js"></script>
<script type="text/javascript" src="/angularTicketWidget/customJsCss/iframehelper.js"></script>
<script type="text/javascript" src="/angularTicketWidget/js/angular.min.js"></script>
<script type="text/javascript" src="/angularTicketWidget/js/angular-route.min.js"></script>
<script type="text/javascript" src="/angularTicketWidget/js/angular-animate.min.js"></script>
<script type="text/javascript" src="/angularTicketWidget/js/angular-sanitize.min.js"></script>
<script type="text/javascript" src="/angularTicketWidget/js/bootstrap.min.js"></script>
<script type="text/javascript" src="/angularTicketWidget/js/ui-bootstrap-tpls.js"></script>
<script type="text/javascript" src="/angularTicketWidget/js/dialogs.js"></script>
<script type="text/javascript" src="/angularTicketWidget/js/jquery.tooltipster.js"></script>
<script type="text/javascript" src="/angularTicketWidget/js/jquery-ui.js"></script>
<script type="text/javascript" src="/angularTicketWidget/js/jquery.PrintArea.js"></script>
<input type='hidden' name='trackcode' id='trackcode' value='<%=trackcode%>' />
<input type='hidden' name='registrationsource' id='registrationsource' value='widget' />
<input type='hidden' name='venueid' id='venueid' value='<%=venueid%>' />
<input type='hidden' name='isseatingevent' id='isseatingevent' value='<%=isseatingevent%>' />
<input type='hidden' name='fbsharepopup' id='fbsharepopup' value='<%=fbsharepopup%>' />
<input type='hidden' name='nts_enable' id='nts_enable' value='<%=nts_enable%>' />
<input type='hidden' id='login-popup' name='login-popup' value='<%=GenUtil.getHMvalue(configMap,"event.reg.loginpopup.show","Y")%>' />
<input type='hidden' name='fbappid' id='fbappid' value='<%=fbappid%>' />
<%if(tc!=null && !"".equals(tc)){%>
	<input type='hidden'  id='ticketurlcode' value='<%=tc%>' />
<%}%>
<input type='hidden' name='context' id='context' value='<%=domain%>' />
<input type='hidden' name='nts_commission' id='nts_commission' value='<%=nts_commission%>' />
<input type='hidden' name='referral_ntscode' id='referral_ntscode' value='<%=referral_ntscode%>' />
<%@ include file='styles.jsp' %>
<script>
var eventid=<%=eid%>
var waitlistId = '',trackCode = '',discountcode = '',registrationsource = '',venueid = '',isseatingevent = '',fbsharepopup = '',nts_enable = '';
var login_popup = '',fbappid = '',ticketurlcode = '',context = '',nts_commission = '',referral_ntscode = '',priregtoken = '';var prilistid='';
var fname='',lname='',email='',actiontype='Order Now';
if($('#waitlistId').val())
	waitlistId = $('#waitlistId').val();
if($('#trackcode').val())
	trackCode = $('#trackcode').val();
if($('#discountcode').val())
	discountcode = $('#discountcode').val();
if($('#registrationsource').val())
	registrationsource = $('#registrationsource').val();
if($('#venueid').val())
	venueid = $('#venueid').val();
if($('#isseatingevent').val())
	isseatingevent = $('#isseatingevent').val();
if($('#fbsharepopup').val())
	fbsharepopup = $('#fbsharepopup').val();
if($('#nts_enable').val())
	nts_enable = $('#nts_enable').val();
if($('#login-popup').val())
	login_popup = $('#login-popup').val();
if($('#fbappid').val())
	fbappid = $('#fbappid').val();
if($('#ticketurlcode').val())
	ticketurlcode = $('#ticketurlcode').val();
if($('#context').val())
	context = $('#context').val();
if($('#nts_commission').val())
	nts_commission = $('#nts_commission').val();
if($('#referral_ntscode').val())
	referral_ntscode = $('#referral_ntscode').val();
var eventDetailsList = {
		waitlistId : waitlistId,
		trackCode : trackCode,
		registrationsource : registrationsource,
		venueid : venueid,
		isseatingevent : isseatingevent,
		fbsharepopup : fbsharepopup,
		nts_enable : nts_enable,
		login_popup : login_popup,
		fbappid : fbappid,
		ticketurlcode : ticketurlcode,
		context : context,
		nts_commission : nts_commission,
		referral_ntscode : referral_ntscode,
		priregtoken : priregtoken,
		prilistid : prilistid,
		actiontype : actiontype,
		discountcode : discountcode
	};
</script>
</head>
<body>
	<div ng-app="ticketsapp" id="leftList" class="" ng-cloak>
		<%if(isrsvpd){%>
			<div ng-view></div>
		<%}else{%>
	<div class="row-centered test-arrow margin-right-left" ng-show="menuTitles" >
	<ul>
		<li ng-class="css"><a id="tickets" >
			<i class="fa fa-ticket small-Icon" aria-hidden="true"></i> 
			<span class="small-Title">{{templatedata.ticket_title}}</span> 
		</a></li>
		<li ng-class="css1"><a id="registration" > 
			<i class="fa fa-user small-Icon" aria-hidden="true"></i> 
			<span class="small-Title">{{templatedata.registration_title}}</span> 
		</a></li>
		<li ng-class="css2"><a id="payment" > 
			<i class="fa fa-credit-card-alt small-Icon" aria-hidden="true"></i> 
			<span class="small-Title">{{templatedata.payment_title}}</span> 
		</a></li>
		<li ng-class="css3"><a id="conformation" > 
			<i class="fa fa-check small-Icon" aria-hidden="true"></i> 
			<span class="small-Title">{{templatedata.confirmation_title}}</span> 
		</a></li> 
	</ul>
	</div>
	<ul   style="margin:0px; padding:0px;"> 
		<div class="col-md-12 col-sm-12 ">
			<div class="alert alert-warning row" role="alert" ng-show="showTimeoutBar" style="margin-bottom: 0px; padding: 5px; border-radius: 0px;">
				<div class="col-xs-6">
					<a href="javascript:;" ng-click="back()">
						<i class="fa fa-angle-double-left"></i>&nbsp; {{backLinkWording}}
					</a>
				</div>
				<div class="col-xs-6">
					<span class="pull-right">
						{{templatedata.time_left}}
						 <strong>{{ timeRemaining | timeRemainingFormatter }}</strong>
					</span>
				</div>
			</div>
		</div>
	<br>
		<div ng-view> </div>
	
		<div id="fb-root"></div>
	</ul>
	<div id="generatedIFrames" style="display: none;"></div>
	<script>
	var  fbavailable=false;
	window.fbAsyncInit = function() {
			fbavailable=true;
	         FB.init({ 
	            appId:'<%=fbappid%>', cookie:true, 
	            status:true, xfbml:true 
	         });
			 };
	         (function() {
	                var e = document.createElement('script');
	                e.type = 'text/javascript';
	                e.src = document.location.protocol +
	                    '//connect.facebook.net/en_US/all.js';
	                e.async = true;
	                document.getElementById('fb-root').appendChild(e);
	            }());
	
	
	iframeQuantity = 50;
	oldHeight = 0;
	scrollIframe = false;
	oldScrollIframe = false;
	document.body.style["overflow-y"] = "auto";
	document.body.style="word-wrap: break-word;overflow-x:hidden;overflow-y:auto;";
	
	window.setInterval(generateIFrames,100);
	</script>
	
	<div id="backgroundPopup" style="height: 918px; width: 1349px; display: none;"></div>
	<div id="attendeeloginpopup" class="ticketunavailablepopup_div" style="display:none;"></div>
	
	<div class="modal" ng-show="timeOutBg">
		<div class="modal-dialog modal-sm">
			<div class="modal-content">
				<div class="modal-header modal-no-bottom">
					<button type="button" class="close" ng-click="cancelTimeOut();" id="close-top"><img src="/home/images/images/close.png"></button>
				</div>
				<div class="modal-body">
					<div class="text-center"> Sorry, timed out!</div><br>
					<div class="text-center"><button type="button" class="btn btn-default btn-sm" ng-click="tryAgain();">Try Again</button></div>
				</div>
				<div class="modal-footer" style="text-align: center;border-top: 0px solid #e5e5e5;">
					
				</div>
			</div>
		</div>
	</div>
	<div ng-show="timeOutBg" class="modal-backdrop fade in"></div>
	
	<!-- Modal -->
	<!--<div class="col-md-12">
	   <div class="modal" id="myModal" tabindex="-1" role="dialog" aria-hidden="true" style="display:none">
		  <div class="modal-dialog">
			 <div class="modal-content">
				<div class="modal-header">
				   <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				   <h4 class="modal-title"></h4>
				</div>
				<div class="modal-body">
				   <iframe id="popup" src="" width="100%"  style="height:430px" frameborder="0"></iframe>
				</div>
			 </div>
		  </div>
	   </div>
	</div>-->
	<%}%>
	</div>	
<script type="text/javascript" src="/angularTicketWidget/customJsCss/filters.js"></script>
<script type="text/javascript" src="/angularTicketWidget/customJsCss/services.js"></script>
<script type="text/javascript" src="/angularTicketWidget/customJsCss/controllers.tickets.js"></script>
<script type="text/javascript" src="/angularTicketWidget/customJsCss/controllers.rsvp.js"></script>
<script type="text/javascript" src="/angularTicketWidget/customJsCss/controllers.profile.js"></script>
<script type="text/javascript" src="/angularTicketWidget/customJsCss/controllers.payment.js"></script>
<script type="text/javascript" src="/angularTicketWidget/customJsCss/controllers.confirmation.js"></script>
<script type="text/javascript" src="/angularTicketWidget/customJsCss/app.js"></script>	
<script>
var printtickets = function(){
	$("#forPrint .PrintDelete").hide();
	var mode = 'iframe'; //popup
    var close = mode == "popup";
    var options = { mode : mode, popClose : close};
    $("div#forPrint").printArea( options );
    $("#forPrint .PrintDelete").show();
};
</script>	
</body>
</html>




















