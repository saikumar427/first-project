<%@page import="com.eventbee.general.DateUtil"%>
<%@page import="java.util.Random"%>
<%@page import="com.eventbee.general.DBManager"%>
<%@page import="com.eventbee.general.StatusObj"%>
<%@page import="com.eventbee.general.DbUtil"%>
<%@page import="org.apache.velocity.app.VelocityEngine"%>
<%@page import="org.apache.velocity.VelocityContext"%>
<%@page import="java.awt.Color"%>
<%@page import="org.eventbee.sitemap.util.Presentation"%>
<%@page import="com.eventbee.layout.BuyerAttDBHelper"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.eventbee.general.GenerateOTP" %>
<%@ include file='/globalprops.jsp' %>
<input type="hidden" id="refreshed" value="no">
<script>
onload=function(){
	var e=document.getElementById("refreshed");
	if(e.value=="no")e.value="yes";
	else{e.value="no";location.reload();}
};
</script>
<%
String profilekey=request.getParameter("pkey");
if(profilekey==null || "".equals(profilekey)){
	System.out.println("buyerlandingpage.jsp with no profilekey");
	response.sendRedirect("/guesttasks/invalidpage.jsp");
	return;
}
String eventid="",eventName="",currentLevel="",email="",tid="",otp="",name="",isExpired="",accessMode="OTP",eventstatus="",paymentstatus="",FBLoginRegEmail="",FBUserId="",FBAppId="",powerType="",i18nActLang="";

String checkExpiresQry="select otp,CASE WHEN COALESCE(expires_at, DATE '0001-01-01') < (select now()) THEN 'Y' ELSE 'N' END as isexpired from buyer_att_page_visits where status='Pending' and profilekey=?";
//String selBuyerInfoQry="select eventid,email,transactionid,fname||' '||lname as buyername from buyer_base_info where profilekey=?";
String selBuyerInfoQry="select a.eventid,a.email,a.transactionid,a.fname||' '||a.lname as buyername,b.paymentstatus,c.status,c.eventname,c.current_level from buyer_base_info a, "+
						"event_reg_transactions b, eventinfo c where a.profilekey=? and b.tid=a.transactionid and a.eventid=c.eventid";
String insertQuery="insert into buyer_att_page_visits(eventid,tid,profilekey,access_time,access_mode,email,page_type,status,expires_at) values(CAST(? AS BIGINT),?,?,to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'),?,?,'buyer','Pending',to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS')+ interval '10 minutes');";

//String isExpired=DbUtil.getVal(checkExpiresQry,new String[]{profilekey});

DBManager dbmanager=new DBManager();
StatusObj stobj=dbmanager.executeSelectQuery(checkExpiresQry,new String[]{profilekey});
if(stobj.getStatus()){
	otp=dbmanager.getValue(0,"otp","");
	isExpired=dbmanager.getValue(0,"isexpired","");
}
if(otp==null) otp="";
if(isExpired==null) isExpired="";
dbmanager=new DBManager();
stobj=dbmanager.executeSelectQuery(selBuyerInfoQry,new String[]{profilekey});
if(stobj.getStatus()){
	tid=dbmanager.getValue(0,"transactionid","");
	eventid=dbmanager.getValue(0,"eventid","");
	eventName=dbmanager.getValue(0,"eventname","");
	email=dbmanager.getValue(0,"email","");
	name=dbmanager.getValue(0,"buyername","");
	eventstatus=dbmanager.getValue(0,"status","");
	paymentstatus=dbmanager.getValue(0,"paymentstatus","");
	currentLevel=dbmanager.getValue(0,"current_level","");
}else{
	response.sendRedirect("/guesttasks/invalidpage.jsp");
	return;
}

/* if("90".equals(currentLevel) || "150".equals(currentLevel)) powerType="RSVP";
else powerType="Ticketing";

String buyerPageLevel=DbUtil.getVal("SELECT level from feature_upgrade_dates where feature='BuyerPage' and powertype=? order by created_at desc limit 1",new String[]{powerType});
if(buyerPageLevel==null) buyerPageLevel=""; */
/*if("400".equals(currentLevel) || "150".equals(currentLevel)){
}else{
	response.sendRedirect("/guesttasks/invalidpage.jsp");
	return;	
}*/
	
i18nActLang=DbUtil.getVal("select value from config where name='event.i18n.actual.lang' and config_id=(select config_id from eventinfo where eventid=CAST(? AS BIGINT))",new String[]{eventid});
if(i18nActLang==null || "".equals(i18nActLang)) i18nActLang="en-us";
if(("ACTIVE".equals(eventstatus) || "CLOSED".equals(eventstatus)) && ("Completed".equals(paymentstatus) || "Need Approval".equals(paymentstatus))){
	FBAppId=DbUtil.getVal("select value from config where name='ebee.fbconnect.appid' and config_id=CAST(? AS INTEGER)",new String[]{"0"});
	String getFBLoginRegEmailQry="select b.email,b.external_userid from event_reg_transactions a, ebee_nts_partner b where a.buyer_ntscode=b.nts_code and a.buyer_ntscode is not null and a.buyer_ntscode<>'' and a.buyer_ntscode<>'null' and a.tid=?";
	dbmanager=new DBManager();
	stobj=dbmanager.executeSelectQuery(getFBLoginRegEmailQry,new String[]{tid});
	if(stobj.getStatus()){
		FBLoginRegEmail=dbmanager.getValue(0,"email","");
		FBUserId=dbmanager.getValue(0,"external_userid","");
	}
	if(FBLoginRegEmail==null) FBLoginRegEmail="";
	if(FBUserId==null) FBUserId="";
	//String eventName=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{eventid});
	if("Y".equals(isExpired)) 
		DbUtil.executeUpdateQuery("update buyer_att_page_visits set status='Expired' where status='Pending' and profilekey=?", new String[]{profilekey});
	if(!"N".equals(isExpired)){//if no record or expired='Y'
		DbUtil.executeUpdateQuery(insertQuery, new String[] {eventid,tid,profilekey,DateUtil.getCurrDBFormatDate(),accessMode,email,DateUtil.getCurrDBFormatDate()});
	}
}
String jsonData=BuyerAttDBHelper.getLayout(eventid,"","final","buyer");
JSONObject layout = new JSONObject(jsonData);
String headerTheme = layout.getString("header_theme");
JSONObject global_style = layout.getJSONObject("global_style");

String bodyBackgroundImage = global_style.getString("bodyBackgroundImage");
String bodyBackgroundColor = global_style.getString("bodyBackgroundColor");
String bodyBackgroundPosition = global_style.getString("backgroundPosition");
 
String coverPhoto = global_style.getString("coverPhoto");
String titleShowHide = "Y";
if(global_style.has("titleShow"))
	titleShowHide = global_style.getString("titleShow");
String titleColor = global_style.getString("title");
String backgroundRgba = global_style.getString("contentBackground");
String logoURL="",logoMsg="";
if(global_style.has("logourl"))
	logoURL=global_style.getString("logourl");
if(global_style.has("logomsg"))
	logoMsg=global_style.getString("logomsg");
String backgroundHex = backgroundRgba.split("rgba")[1];
backgroundHex = backgroundHex.substring(1, backgroundHex.length()-1);
int r = Integer.parseInt(backgroundHex.split(",")[0]);
int g = Integer.parseInt(backgroundHex.split(",")[1]);
int b = Integer.parseInt(backgroundHex.split(",")[2]);
Color color = new Color(r,g,b);
backgroundHex = "#"+Integer.toHexString(color.getRGB()).substring(2);
String backgroundOpacity = backgroundRgba.split(",")[3];
backgroundOpacity = backgroundOpacity.substring(0, backgroundOpacity.length()-1);
String details = global_style.getString("details");
String header = global_style.getString("header");
String headerText = global_style.getString("headerText");
String border = global_style.getString("border");
String content = global_style.getString("content");
String contentText = global_style.getString("contentText");

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

JSONObject radius = new JSONObject(global_style.getString("radius"));
String topLeft = radius.getString("topLeft");
String topRight = radius.getString("topRight");
String bottomLeft = radius.getString("bottomLeft");
String bottomRight = radius.getString("bottomRight");

%>
 <!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<title><%=eventName%></title>
<link href="/main/bootstrap/css/bootstrap.css" rel="stylesheet" />
<link href="/main/bootstrap/font-awesome-4.3.0/css/font-awesome.css"  rel="stylesheet"/>
<style>
table {
    border-collapse: separate !important;
    border-spacing: 2px !important;
}
body {
	margin: 0 0 0 0;
	font-family: Tahoma, Geneva, sans-serif;
	background-position: top;
	background-color: <%=bodyBackgroundColor%>;
	<%if(!"".equals(bodyBackgroundImage)){%>
	background-image: url('<%=bodyBackgroundImage%>');
	<%}%>
	<%
	if("cover".equals(bodyBackgroundPosition)) {
		out.println("background-size:100% auto;");
		out.print("\tbackground-repeat:no-repeat;");
	} else
		out.print("background-repeat:"+bodyBackgroundPosition+";");%>
}

.container {
	box-shadow:-60px 0px 100px -90px #000000, 60px 0px 100px -90px #000000;
	background-color: <%=backgroundRgba%> !important;
	min-height:795px;
}
.header {
	  margin-bottom: 15px;
} 
h2{
	text-transform: capitalize;
}
.widget {
	margin:5px 2px  20px;
	position:relative;
	border:1px solid <%=border%>;
	width: 100%;
}
.widget h2{
    font-family:<%=headerTextFont%>;
	margin:0;
	font-size:<%=headerTextSize%>px;
	background-color:<%=header%>;
	color:<%=headerText%>;
	border-bottom:1px solid <%=border%>;
	padding:10px;
	-webkit-border-top-left-radius: <%=topLeft%>;
	-webkit-border-top-right-radius: <%=topRight%>;
	-moz-border-radius-topleft: <%=topLeft%>;
	-moz-border-radius-topright: <%=topRight%>;
	border-top-left-radius: <%=topLeft%>;
	border-top-right-radius: <%=topRight%>;
}
.widget-content{
  margin:50px 50px 50px 50px;
  
    #min-height:250px;
	background-color:<%=content%>;
	color:<%=contentText%>;
	font-family:<%=contentTextFont%>;
	font-size:<%=contentTextSize%>px;
	line-height:20px;
	padding:15px;
	position: static;
	#overflow: hidden;
}
.container{
	min-height:666px !important;
	padding-bottom:0px !important;
	margin-bottom:0px !important;
}
.small {
font-family: Verdana, Arial, Helvetica, sans-serif;
font-size: 10px;
font-weight: lighter;
color:<%=contentTextFont%>;
overflow: hidden;
}
.small_s{
	font-family: Verdana, Arial, Helvetica, sans-serif;
    font-size: 10px;
    font-weight: lighter;
    color: #666666;
}

hr {
	border: 0;
    height: 1px;
    background-image: -webkit-linear-gradient(left, rgba(0,0,0,0), <%=border%>, rgba(0,0,0,0)); 
    background-image:    -moz-linear-gradient(left, rgba(0,0,0,0), <%=border%>, rgba(0,0,0,0)); 
    background-image:     -ms-linear-gradient(left, rgba(0,0,0,0), <%=border%>, rgba(0,0,0,0)); 
    background-image:      -o-linear-gradient(left, rgba(0,0,0,0), <%=border%>, rgba(0,0,0,0)); 
}

#subForm{
	background-color:#fff;
}

</style>
</head>
<body > 

<div id="fb-root"></div>
<script type="text/javascript">
var fbLoginRegEmail='<%=FBLoginRegEmail %>';
var fbUserId='<%=FBUserId %>';

function login(){
	FB.api('/me', function(response) {
		var fbuserid = response.id;
        var s="<div class='row'><div class='col-sm-12' align='center'><span><img src='https://graph.facebook.com/"+response.id+"/picture' border='0' alt=''></span><span style='vertical-align:top'><font style='padding:5px;' >Logged in as <b>"+response.name + "</b></font></span></div></div>";
			s+="<br><div class='row'><div class='col-sm-12' align='center'><button class='btn btn-primary' id='conitnue'>Continue</button>&nbsp;&nbsp;<button class='btn btn-primary' id='nybtn'>Not you?</button></div></div>";
		document.getElementById('fbcontent').innerHTML=s;
		$('#conitnue').click(function(){
			if(fbuserid==fbUserId)
				validateLoginForm('FB',fbuserid);
			else{                                    
				notification("fbstmsg","<%=getPropValue("byer.lgt.fb.lgin.reged.fb.acct",eventid)%>", "danger");
			}
		});
		$('#nybtn').click(function(){fblogout();});
	});
}

window.fbAsyncInit = function() {
	FB.init({ 
    appId:<%=FBAppId%>, cookie:true, status:true, xfbml:true 
    });
    
    /* FB.getLoginStatus(function(response) {
		if (response.authResponse) 
        	login();
	},{scope:'email'}); */
};
/* (function() {
	var e = document.createElement('script');
    e.type = 'text/javascript';
    e.src = document.location.protocol +'//connect.facebook.net/en_US/all.js';
    e.async = true;
    alert('yes');
    document.getElementById('fb-root').appendChild(e);
}()); */

(function(d, s, id) {
	  var js, fjs = d.getElementsByTagName(s)[0];
	  if (d.getElementById(id)) return;
	  js = d.createElement(s); js.id = id;
	  js.src = "//connect.facebook.net/en_US/all.js#xfbml=1";
	  fjs.parentNode.insertBefore(js, fjs);
	}(document, 'script', 'facebook-jssdk'));

var fblogin=function(){
	FB.login(function(response) {
  		if (response.authResponse) {
    		//if (response.scope) {
    			FB.api('/me', function(response1) {
    				var fbuserid=response.authResponse.userID;
    				if(fbuserid==fbUserId)
    					validateLoginForm('FB',fbuserid);
    				else{ 
    					//login();
    					notification("fbstmsg","<%=getPropValue("byer.lgt.fb.lgin.reged.fb.acct",eventid)%>", "danger");
    				}
				});
			//} 
		} 
	}, {scope:'email'});
	
};

function fblogout(){
	FB.logout(function(response) {
		window.location.reload();
	});
}


</script>


<div id="rootDiv">
<% if(global_style.has("fullWidth") && "Y".equalsIgnoreCase((String)global_style.get("fullWidth")) ){%>
  <div><!-- container -->
<% }else{%>
  <div class="container"  id="containerSeating"><!-- container -->
<%}%>
	 <div class="header">
	
		<%headerTheme=headerTheme
				.replace("$$eventTitle$$", "Y".equals(titleShowHide) ? eventName : "")
				.replace("$$coverPhotoURL$$", coverPhoto==null || "".equals(coverPhoto) ? "":coverPhoto)
			    .replace("$$logoUrl$$",logoURL==null || "".equals(logoURL) ? "":"<img src='"+logoURL+"' style='width:150px !important;height:150px !important'/>")
				.replace("$$logoMsg$$",logoMsg==null || "".equals(logoMsg) ? "":"<span class='small'>"+logoMsg+"</span>")
				.replace("$$titleColor$$", titleColor);
		
				VelocityContext layoutContext = new VelocityContext();
				if(coverPhoto!=null && !"".equals(coverPhoto))
				   layoutContext.put("coverPhotoURL",coverPhoto);
				if(logoURL!=null && !"".equals(logoURL))
					   layoutContext.put("logoUrl",logoURL);
				if(logoMsg!=null && !"".equals(logoMsg))
					   layoutContext.put("logoMsg",logoMsg);		
				VelocityEngine layoutEngine= new VelocityEngine();
				layoutEngine.init();
				layoutEngine.evaluate(layoutContext,out,"ebeelayouttemplate",  headerTheme==null?"":headerTheme); 	
		%> 
	</div>
	<div style="clear:both;"></div>
	<div class="widgets">
		<div class="col-sm-12 col-md-12 col-xs-12" id='single_widgetsSeating'>
		<div class="">
		<%if(("ACTIVE".equals(eventstatus) || "CLOSED".equals(eventstatus)) && ("Completed".equals(paymentstatus) || "Need Approval".equals(paymentstatus))){%>
			<div class="widget-content" id="requestOtp" style="padding:85px 15px;border-radius:5px;">
				
				<div align="center"  id="fbstmsg"></div>
				<div style="clear:both"></div>
				<div align="center" style="line-height:30px;" ><%=getPropValue("byer.to.vst.byr.page",eventid)%></div>
				<div id="sendotp" class="col-md-12 col-sm-12 col-xs-12 text-center" style="margin-top:15px;margin-bottom:15px;">
					<button id="send" class='btn btn-primary saveButton sendButton'><%=getPropValue("byer.eml.byr.access.tkn",eventid)%></button>
				</div>
				<%if(!"".equals(FBLoginRegEmail)){%>
				<%-- <div align="center" style="line-height:30px;" ><%=getPropValue("byer.u.hv.regd.wth.fb.acc",eventid)%> (<span style="color:blue;"><%=FBLoginRegEmail %></span>)</div> --%>
				<div align="center"><%=getPropValue("byer.or.lbl",eventid)%></div>
				<div id="fbcontent" class="col-md-12 col-sm-12 col-xs-12 text-center" style="margin-top:15px;" style="margin-top:15px;">
	        		<a id="btn-fblogin" class="btn btn-primary"><i class="fa fa-facebook"></i>&nbsp;<%=getPropValue("byer.lgn.wth.fb",eventid)%></a>
	        	</div>
	        	<%}%>
				<div style="clear:both"></div>
			</div>
			<div class="widget-content" id="enterOtp" style='display:none;padding:85px 15px;border-radius:5px;'>
				<div align="center" class="col-md-12 col-sm-12 col-xs-12 text-center" id="stmsg"></div>
				<div style="clear:both"></div>
				     <form action="/customevents/BuyerLoginFormAction.jsp" name="buyer_otp_frm" id="buyer_otp_frm" method="post" onsubmit="validateOTPForm();return false;">
						<div align="center" style="line-height:30px;margin-bottom:8px;"><%=getPropValue("byer.access.tkn.snt.mail",eventid)%></div>
							<div class="col-md-12 col-xs-12 col-sm-12" align="center" style="line-height:30px;">
							<div id="errormsg" class="alert alert-danger col-md-4 col-sm-4 col-xs-6 col-md-offset-4 form-group" style="display:none;padding:0px;margin-bottom:20px;text-align:left;padding-left:10px;"></div>		
							<div class="col-md-4 col-sm-4 col-xs-6 col-md-offset-4 form-group">
							<input type="text" name="title"  class="form-control" placeholder="<%=getPropValue("byer.access.tkn",eventid)%>" id="otptext" size="30" />
								</div>
							</div>
							<div class="col-md-12 col-sm-12 col-xs-12 text-center">
							<!-- <input type="button" name="resend" class='btn btn-primary saveButton' value="Resend" id="resendbtn" onClick="resendOTP();"> -->
							<button id="resendbtn" type="button" class='btn btn-primary saveButton sendButton'><%=getPropValue("byer.resend.btn",eventid)%></button>
							<!-- <input type="button" name="continue" class='btn btn-primary saveButton' value="Continue" id="continue" onClick="validateOTPForm();"> -->
							<button id="continue" type="button" class='btn btn-primary saveButton sendButton'><%=getPropValue("byer.continue.btn",eventid)%></button>
							</div>
					</form>
				<div style="clear:both"></div>
			</div>
			
			<%}else{ %>
				<div class="widget-content" style='padding-top:135px;border-radius:5px;'>
					<div align="center" style="line-height:30px;" ><%=getPropValue("byer.ur.pg.crntly.unavble",eventid)%></div>
				</div>
			<%}%>
			</div>
	</div>
	<!-- Footer start -->
	<%
		String domain="http://www.eventbee.com";
		if("es-co".equals(i18nActLang)) domain="http://www.eventbee.co";
		else if("es-mx".equals(i18nActLang))domain="http://www.eventbee.mx";
	%>
	<div style="clear:both;"></div>
	<div>
		<table align="center" cellpadding="5" style="margin-top: 48px;">
		    <tbody>
		        <tr>
		            <td align="left" valign="middle">
		                <a style="margin-right:15px" href="<%=domain%>"><img src="/home/images/<%=i18nActLang %>/poweredby.jpg" border="0">
		                </a>
		            </td>
		            <td>&nbsp;&nbsp;</td>
		            <td align="left" valign="middle"><span class="small_s"><%=getPropValue("evh.footer.lnk",eventid)%>&nbsp;<a href="<%=domain%>"><%=domain%></a></span>
		            </td>
		        </tr>
		    </tbody>
		</table>
	</div> 
	<!-- Footer end -->
</div>
</div>
</body>
 <script src='/main/bootstrap/js/jquery-1.11.2.min.js'></script>
 <script>
 var isExpired='<%=isExpired%>';
 var otp='<%=otp%>';

 if(isExpired=='N' && otp!=''){
	 $('#requestOtp').hide();
	 $('#resendbtn').hide();
	 $('#enterOtp').show();
 }
	 
 var requestRunning = false;
 
	$('#send').click(function(){
		sendOTP("send");
	}); 
	
	
	$('#resendbtn').click(function(){
		sendOTP("resend");
	});
	$('#continue').click(function(){
		$('#continue').attr('disabled','disabled');
		validateOTPForm();
	});
	
	function sendOTPResponse(msg,type){
		requestRunning = false;
		if(type=='send' && msg.status.lastIndexOf("success")>-1){
			$('#requestOtp').hide();
		    $('#enterOtp').show();
		}else if(type=='resend' && msg.status.lastIndexOf("success")>-1){
			$('#resendbtn').hide();
			notification("stmsg","<%=getPropValue("byer.aces.tkn.sent.success",eventid)%>","success");
		}else{
			alert("<%=getPropValue("byer.there.problm.try.latr",eventid)%>");
		}
	}
	
	function sendOTP(type){
		if(requestRunning) return;
		var profilekey='<%=profilekey%>'; 
        var email='<%=email%>';
        var eid='<%=eventid%>';
        var tid='<%=tid%>';
        var name='<%=name%>';
        var url = '/customevents/buyerotpmail.jsp?eid='+eid+'&tid='+tid+'&profilekey='+profilekey+'&email='+email+'&name='+name+'&type='+type;
        requestRunning = true;
		$.ajax({
			type:'POST',
			url:url,
			success:function(response){
				var res=JSON.parse(response);
				sendOTPResponse(res,type);
			},
			error:function(){
				requestRunning = false;
				alert("<%=getPropValue("byer.there.problm.try.latr",eventid)%>");
			}
		});
	}
	
	/* function resendOTP(){
   	 sendOTP("resend");
    } */
	
	function validateOTPForm(){
		$("#stmsg").hide();
		var enteredOtp="";
		if(document.getElementById('otptext')){
 		   enteredOtp=document.getElementById('otptext').value;
 		   document.getElementById('otptext').value=enteredOtp.trim();
 		}
		validateLoginForm('OTP',enteredOtp.trim());
	}

	function validateLoginForm(accessMode,refkey){
		if(requestRunning) return;
		requestRunning = true;
		var profilekey='<%=profilekey%>'; 
    	var eid='<%=eventid%>';
    	var tid='<%=tid%>';
    	var url = '/customevents/buyerloginformaction.jsp?refkey='+refkey+'&profilekey='+profilekey+'&tid='+tid+'&accessmode='+accessMode+'&eid='+eid;
		$.ajax({
			type:'POST',
			url:url,
			success:function(response){
				requestRunning = false;
				var res=JSON.parse(response);
				if(res.status.lastIndexOf("success")>-1){
					var token=res.token;
					window.location.href='/buyerpage?token='+token+'&eid='+eid+'&tid='+tid;
				}else if(res.error!='undefined'){
					if(accessMode=='FB'){
						notification("fbstmsg",res.error,'danger');
						//login();
					}else{
						if(res.error.lastIndexOf("expired")>-1)
							$('#resendbtn').show();
						notification("stmsg",res.error,'danger');
					}
					$('#continue').removeAttr('disabled');
				}else{
					alert("<%=getPropValue("byer.there.problm.try.latr",eventid)%>");
					$('#continue').removeAttr('disabled');
				}
			},
			error:function(){
				requestRunning = false;
				alert("<%=getPropValue("byer.there.problm.try.latr",eventid)%>");
				$('#continue').removeAttr('disabled');
			}
		});
    }
     
	
	function notification(id,message, type) {//style="display:none;padding:0px;margin-bottom:20px;text-align:left;padding-left:10px;"
	    var html = '<div class="alert alert-' + type + ' alert-dismissable page-alert col-md-6 col-sm-6 col-xs-6 col-md-offset-3 form-group" style="margin-bottom:15px;text-align:left;">';    
	    html += '<button type="button" class="close close-notification"><span aria-hidden="true">x</span></button>';
	    html += message;
	    html += '</div>';    
	    var htmlObject=$.parseHTML(html);
	    $("#"+id).show();
	    $(htmlObject).hide().prependTo('#'+id).slideDown();
	    setTimeout(function(){
	    	$(htmlObject).remove();
	    },5000);
	};

	$(document).on("click",".close-notification",function(){
		var thisElement=this;
		$(this).parent().slideUp(slideTime,function(){$(thisElement).parent().remove();});
	});
	
	 var slideTime = "200";
	
    $('#btn-fblogin').click(function(){fblogin();});
    
</script>
</html>
 