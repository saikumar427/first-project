<%@page import="java.util.HashMap"%>
<%@include file="getresourcespath.jsp" %>
<%@include file="common.jsp" %>
<%@include file="/columbia/props.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head profile="http://gmpg.org/xfn/11">
<meta name="verify-v1" content="/2obWcBcvVqISVfmAFOvfTgJIfdxFfmMOe+TE8pbDJg=" />
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<META Http-Equiv="Cache-Control" Content="no-cache">
<META Http-Equiv="Pragma" Content="no-cache">
<META Http-Equiv="Expires" Content="0">
<title><%=getPropValue("title",lang) %></title>
<meta name="Description" content="<%=getPropValue("description" ,lang) %>" />
<meta name="Keywords" content="<%=getPropValue("keywords" ,lang) %>"/>
<link rel="canonical" href="http://www.eventbee.com" />
<link type="text/css" rel="stylesheet" href="/main/css/select2.css" />
<link rel="icon" href="<%=resourceaddress%>/main/images/favicon.ico" type="image/x-icon" />
<link rel="shortcut icon" href="<%=resourceaddress%>/main/images/favicon.ico" type="image/x-icon" />
 <%-- <link rel="shortcut icon" href="<%=resourceaddress%>/main/help/how-it-works.jsp /> --%>
   <link rel="stylesheet" href="/main/slider/style.css" />
<link type="text/css" rel="stylesheet" href="/main/bootstrap/css/bootstrap.css" />
<%-- <link type="text/css" rel="stylesheet" href="<%=resourceaddress%>/main/css/bootstrap/style-min.css" /> --%>
<link type="text/css" rel="stylesheet" href="/main/font-awesome-4.0.3/css/font-awesome.min.css" />
<link rel="stylesheet" href="/columbia/css/freshslider.min.css">
<link rel="stylesheet" href="/main/slider/dist/powerange.css" />
<link type="text/css" rel="stylesheet" href="/columbia/css/custom.css" />
<script src="<%=resourceaddress%>/main/js/jquery-1.11.2.min.js"></script>
<script src="<%=resourceaddress%>/main/js/jquery.inview.min.js"></script>
<script src="<%=resourceaddress%>/main/js/freshslider.min.js"></script>
<script src="<%=resourceaddress%>/main/slider/dist/powerange.js"></script>
<script src="<%=resourceaddress%>/main/user/login?lang=<%=lang%>"></script>
<style>
			.unranged-value,.unranged-value1{
            display: inline-block;
			}
	
.fixed{
  top:0;
 position:fixed;
  display:none;
  border:none;
  z-index:999999999;
  background-color:#EEEEEE;
}

.section_header{
	font-size: 42px;
	font-weight:500;
	text-align: center;
	color: #999999;
}

.footer, .footer h2, .footer h3, .copy {
    color: #b0b0b0;
    font-weight: 500;
}
.modal-body {
    position: relative;
    padding: 20px;
}

.modal-header {
    padding: 15px !important;
    border-bottom: 1px solid #e5e5e5 !important;
    min-height: 16.42857143px !important;
}
.main_header_orange{
	font-size: 42px;
	font-weight:800;
	text-align: center;
	color: white;
}

.caption_header_blue{
	font-size:32px;
	#font-weight: normal;
	text-align: center;
	color: #428BCA;
}
.select-active{
	background:#ddd !important;
	color:#000 !important;
}
.select-active:hover{
	background:#ddd !important;
	color:#000 !important;
}
.caption_header_blue_faq{
	font-size: 32px;
	#font-weight: normal;
	#text-align: center;
	color:#428BCA;
}


.medium_desc_grey{
	color: #999999;
    font-size: 20px;
    text-align: center;
}

.normal_desc_grey{
	 color: #333333;
    font-size: 14px;
    text-align:center;
}

.normal_desc_grey_ans{
	 color: #333333;
    font-size: 14px;
}

.award{
	margin-top:120px !important;
	margin-bottom:120px !important;
}
.dropdown{
	background-color: white;
    border: 1px solid white;
    border-radius: 11px 11px 11px 11px;
    height: 182px;
    margin: 26px;
    width: 212px;
}

.subevent{
	border: 1px solid #F3F6FA;
	background-color: #F3F6FA;
    border-radius: 27px 27px 27px 27px;
    cursor: pointer;
    height: 45px;
    margin: 7px;
    padding: 5px;
    width: 250px;
    color:#ffffff;
}

.textbox{
    margin: 10px;
    padding-left: 30px;    
}

.input-field{
	background-color: #FFFFFF;
    border: medium none #FFFFFF;
    height: 30px;
    width: 50px;
}



.avgtooltip{
	background-color: #F27A28;
    bottom: 18px;
    box-shadow: 0 0 1px 1px #DDDDDD;
    color: #FFFFFF;
    left: 218px;
    padding: 17px 0 5px;
    position: absolute;
    text-align: center;
    width: 50px;
    font-size:14px;
}


.range-max{
	font-size:20px;
}

.range-min{
	font-size:20px;
}

li{
	list-type:desc;
}
#rootDiv a:hover {
   text-decoration: underline !important;
}
#lowerlinks a:hover {
   text-decoration: underline !important;
}


</style>
<style>

.footertabheader{
       color: #B0B0B0;
       font-family: 'Open Sans', sans-serif;
}
.footerlinks a, .footertab a{
         color: #ccc;
         font-size: 12px;
         line-height: 200%;
}
.top-gap{
	margin-top:7px;
}
.fa-facebook {
    background: transparent none repeat scroll 0 0;
    border: 0 none;
    color: #ccc;
    padding: 0;
}
.fa-twitter {
    background: transparent none repeat scroll 0 0;
    border: 0 none;
    color: #ccc;
    padding: 0;
</style>
	<style>
	.white {
    color: white;
}
.btn-lg {
    font-size: 38px;
    line-height: 1.33;
    border-radius: 6px;
}
.box > .icon {
    text-align: center;
    position: relative;
}
.box > .icon > .image {
    position: relative;
    z-index: 2;
    margin: auto;
    width: 88px;
    height: 88px;
    border: 7px solid white;
    line-height: 88px;
    border-radius: 50%;
    background: #63B76C;
    vertical-align: middle;
}
.box > .icon:hover > .image {
    border: 4px solid #428bd3;
}
.box > .icon > .image > i {
    font-size: 40px !important;
    color: #fff !important;
}
.box > .icon:hover > .image > i {
    color: white !important;
}
.box > .icon > .info {
    margin-top: -24px;
    background: rgba(0, 0, 0, 0.04);
    border: 1px solid #e0e0e0;
    padding: 15px 0 10px 0;
}
.box > .icon > .info > h3.title {
    color: #428bd3;
	font-size:32px;
    font-weight: 500;
}
.box > .icon > .info > p {
	color: #666;
	line-height: 1.5em;
	margin: 20px;
}
.box > .icon:hover > .info > h3.title, .box > .icon:hover > .info > p, .box > .icon:hover > .info > .more > a {
    color: #428bd3;
}
.box > .icon > .info > .more a {
    color: #222;
    line-height: 12px;
    text-transform: uppercase;
    text-decoration: none;
}
.box > .icon:hover > .info > .more > a {
    color: #000;
    padding: 6px 8px;
    border-bottom: 4px solid black;
}
.box .space {
    height: 30px;
}
.shape {
    border-style: solid;
    border-width: 0 80px 60px 0;
    float: right;
    height: 0px;
    width: 0px;
    -ms-transform: rotate(360deg); /* IE 9 */
    -o-transform: rotate(360deg); /* Opera 10.5 */
    -webkit-transform: rotate(360deg); /* Safari and Chrome */
    transform: rotate(360deg);
}
.listing {
    background: #fff;
    border: 1px solid #ddd;
    box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
    margin: 15px 0;
    overflow: hidden;
}
.listing:hover {
    -webkit-transform: scale(1.1);
    -moz-transform: scale(1.1);
    -ms-transform: scale(1.1);
    -o-transform: scale(1.1);
    transform: rotate scale(1.1);
    -webkit-transition: all 0.4s ease-in-out;
    -moz-transition: all 0.4s ease-in-out;
    -o-transition: all 0.4s ease-in-out;
    transition: all 0.4s ease-in-out;
}
.shape {
    border-color: rgba(255,255,255,0) #d9534f rgba(255,255,255,0) rgba(255,255,255,0);
}
.listing-radius {
    border-radius: 7px;
}
.listing-danger {
    border-color: #d9534f;
}
.listing-danger .shape {
    border-color: transparent #d9533f transparent transparent;
}
.listing-success {
    border-color: #5cb85c;
}
.listing-success .shape {
    border-color: transparent #5cb75c transparent transparent;
}
.listing-default {
    border-color: #999999;
}
.listing-default .shape {
    border-color: transparent #999999 transparent transparent;
}
.listing-primary {
    border-color: #428bca;
}
.listing-primary .shape {
    border-color: transparent #318bca transparent transparent;
}
.listing-info {
    border-color: #5bc0de;
}
.listing-info .shape {
    border-color: transparent #5bc0de transparent transparent;
}
.listing-warning {
    border-color: #f0ad4e;
}
.listing-warning .shape {
    border-color: transparent #f0ad4e transparent transparent;
}
.shape-text {
    color: #fff;
    font-size: 12px;
    font-weight: bold;
    position: relative;
    right: -34px;
    top: 2px;
    white-space: nowrap;
    -ms-transform: rotate(30deg); /* IE 9 */
    -o-transform: rotate(360deg); /* Opera 10.5 */
    -webkit-transform: rotate(30deg); /* Safari and Chrome */
    transform: rotate(30deg);
}
.listing-content {
    padding: 0 20px 10px;
}
.details {
    min-height: 355px;
    display: inline-block;
}
.blogicon {
    font-size: 217px;
    color:#5CB85C;
}
.height {
    min-height: 200px;
}
.icon {
    font-size: 47px;
    color: #5CB85C;
	cursor:pointer;
}
.iconbig {
    font-size: 77px;
    color: #5CB85C;
}
.table > tbody > tr > .emptyrow {
    border-top: none;
}
.table > thead > tr > .emptyrow {
    border-bottom: none;
}
.table > tbody > tr > .highrow {
    border-top: 3px solid;
}
.panel:hover {
	background-color: none;
}   
.clearfix {
	clear: both;
}
.rowcolor {
	background-color: #CCCCCC;
}
.blogicon {
    font-size: 217px;
    color:#5CB85C;
}

.ratetext {
    font-size: 37px;
    text-decoration: underline;
    padding-bottom: 10px;
}

.votes {
    font-size: 47px;
    padding-right: 20px;
    color:#197BB5;
}
a.list-group-item {
    height: auto;
    min-height: 250px;
}

a.list-group-item:hover, a.list-group-item:focus {
    border-left:10px solid #5CB85C;
    border-right:10px solid #5CB85C;
}
a.list-group-item:hover, a.list-group-item:focus {
    background-color:#edf5fc !important;
}

a.list-group-item {
    border-left:10px solid transparent;
    border-right:10px solid transparent;
}
#create{
	cursor:pointer;
}
#promote{
	cursor:pointer;
}
#manage{
	cursor:pointer;
}

.blogicon2{
	font-size:128px;
}
.blogicon3{
	font-size:60px;
}
	.btn-lg {
		font-size: 38px;
		line-height: 1.33;
		border-radius: 6px;
	}
	.box > .icon {
		text-align: center;
		position: relative;
	}
	.box > .icon > .image {
		position: relative;
		z-index: 2;
		margin: auto;
		width: 88px;
		height: 88px;
		border: 7px solid white;
		line-height: 88px;
		border-radius: 50%;
		background: #63B76C;
		vertical-align: middle;
	}
	.box .space {
		height: 30px;
	}
	.listing-content {
		padding: 0 20px 10px;
	}
	.blogicon {
		font-size: 217px;
		color:#5CB85C;
	}
	#eventSites > li > a:hover{
	color:#113766 !important;
	}
	
	#custom1 > input{
		position:relative;
		top:0px;
		line-height: 24px;
	}
	
	#eventSites > li {
    line-height: 50px;
    color:#f0c680;
}

#eventSites > li:hover {
background-color:none;
    line-height: 50px;
    cursor:pointer;
}



	#eventSites > li > a{
	color:#f0c680;
	}
	.active-site{
background-color:#f0c680;
color:#113766 !important;
}
	.icon {
		font-size: 47px;
		color: #5CB85C;
	}
	.iconbig {
		font-size: 77px;
		color: #5CB85C;
	}  
	 .caption_header_blue{
		font-size:32px;
		color: #428BCA;
	}
	p{
		line-height:24px;
	}
	.pricing_desc_grey{
color: #999999;
font-size: 20px;
}

	
	</style>

</head>
<s:set name="I18N_CODE" value="I18N_CODE"></s:set>
<s:set name="I18N_CODE_PATH" value="I18N_CODE_PATH"></s:set>
<script src="<%=resourceaddress%>/main/js/i18n/<%=lang%>/footerjson.js"></script> 


<body id="mainBody"class="body_img">
		<section>
			<div class="navbar navbar-default">
				<div class="container col-lg-12 header">
					
					<div class="navbar-header" style="height:80px">
						<a href="#" class="navbar-brand" >
						<img class="img-responsive" id="logo-img" src="/columbia/images/logo1.png" alt="Eventbee" style="margin-left:20px;margin-bottom:10px;"/></a>
						<button class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse" style="margin-top:20px;">
							<span class="icon-bar"></span>
							<span class="icon-bar"></span>
							<span class="icon-bar"></span>
						</button>
					</div>
					 <div class="navbar-collapse collapse">
						<button class="btn btn-primary sign-up1">Sign Up</button>
						<ul class="nav navbar-nav navbar-right main-menu before-nav" style="margin:10px 20px;">
					   <li  style="line-height:25px !important;margin-top:10px !important; display:none;">
								   <a href="javascript:;" id="i18nLangToggle" style="z-index:9999 !important"><img class="img-responsive" src="/columbia/images/colombia-flag.gif" alt="colombia" style="height:15px;float:left;vertical-align: middle;margin-top:6px;margin-right:5px;"/><%=getPropValue("colombia",lang) %></a>
								   <a href="javascript:;" id="i18nLangToggle" ><span style="margin-right:3px"><i class="fa fa-globe" style="color:#fff"></i></span><i class="fa fa-sort-down" style="font-size:14px !important;position: relative;top: -4px;"></i></a> 
								    <div id="i18nLang" style="z-index:0 !important;display:none;width:330px;position: absolute;top: 16px; right: 2px;  background-color: white;   padding: 20px 30px 20px 20px;   border: 1px solid #EEE;">
									      <div> 
									       <div style="float:left;padding-right:20px;border-right: 1px solid #EEE;">
									         <span class="sub-text"><%=getPropValue("country" ,lang) %></span>
									         <ul style="padding:0px" id="countries" class="sm-font">
									          
									         </ul>				       
									       </div>
									        <div style="float:left;padding-left:20px">
									         <span class="sub-text"><%=getPropValue("languages" ,lang) %></span>
										         <ul style="padding:0px;font-size:12px" class="sm-font" id="languages">
										           
										         </ul>					        
									        </div>   
									        <div style="clear:both"></div>
									      </div>     
					      		 </div>		
								</li>	 		
						  <li style="display:block">	
				  	
				  </li>
				
							<li><a  id="open" href="#" class="how-it-work" style="margin-top:10px;"><%=getPropValue("how-it-works" ,lang) %></a></li>
							<li><a href="/main/faq<%= getSlashLinkPath(lang) %>" style="margin-top:10px;"> <%=getPropValue("faq" ,lang) %></a></li>
							<li id="contact"><a href="javascript:;" style="margin-top:10px;"><%=getPropValue("contact" ,lang) %></a></li>
							<li id="getTickets"><a href="javascript:;" style="margin-top:10px;"><%=getPropValue("get_my_tkts" ,lang) %></a></li>
							  
							<li>
								<a href="/main/user/login<%=getQuestionMarkLink(lang)%>" class="before-login">
									<button class="btn sign-in addRemove"><%=getPropValue("log_in" ,lang) %></button>
								</a>
							</li> 
					        <li>
								<a href="/main/user/login<%=getQuestionMarkLink(lang)%>" class="after-login" style="display:none;margin-top:10px;"><%=getPropValue("log_in" ,lang) %></a>
							</li> 
						</ul>
					</div> 
					
					
					
				</div>
			</div>
			<div class="container text-center award">
				<div class="award-winning"><h1 style="font-size:42px !important;"><%=getPropValue("award_win" ,lang) %></h1></div>
				<div class="trusted"><%=getPropValue("trust_by",lang) %></div>
				<div> 
					<a href="/main/user/signup<%=getQuestionMarkLink(lang)%>" > 
						<button class="btn sign-up"> <%=getPropValue("sign_up" ,lang) %>  </button>
					</a>
				</div>
			</div>
			
			<div class="how-it-work_cont col-lg-12" id="howitworks" style="background-color:#2d62a0;padding:0px;padding-left:50px;margin:0px;padding-top:5px;height:498px;overflow-y:auto;">
				<div>
					<a id="close" style="color:#fff;float:right;cursor:pointer;top:5px;right:10px;font-size:15px;position:absolute;" >X</a>
				</div><br/>
				<div class="col-lg-12" style="padding-top:5px;">
					<div class="col-lg-12" id="navigation" style="padding:0px;padding-left:50px;margin:0px;padding-top:5px;">
						<div class="col-lg-4 arrow_link  active" id="first" onclick="changeDiv('create');"  style="margin:0px;cursor:pointer;"><a  style="color:#fff;"><img class="img-responsive" src="/columbia/images/createrevised95.png" style="margin-left:30px;display:inline;"/><span class="cont-space" style="display:inline;"><%=getPropValue("create" ,lang)%></span></a>
						</div>
						
						<div class="col-lg-4 arrow_link" onclick="changeDiv('manage');"  id="second" style="margin:0px;cursor:pointer;"><a style="color:#fff;"><img class="img-responsive"  src="/columbia/images/geariconrevised95.png" style="display:inline;margin-left:30px; "/><span style="display:inline;" class="cont-space"><%=getPropValue("promote" ,lang)%></span></a>
						</div>
					
					
				
						<div onclick="changeDiv('promote');" class="col-lg-4 arrow_link" id="third" style="margin:0px;cursor:pointer;">
							<a  style="color:#fff;"><img class="img-responsive"  src="/columbia/images/promoterevised95.png" style="margin-left:30px;display:inline;"/><span style="display:inline;" class="cont-space"><%=getPropValue("manage" ,lang)%></span></a>
						</div>
						<div style="clear:both;"></div>
						</div>
					<div class="col-lg-12" style="padding:0px;padding-left:50px;margin:0px;padding-top:5px;display:block;" id="firstDiv" >
						<div id="createContentMain" class="" style=" margin-bottom: 0 !important;">
				<div class="col-md-11" style="padding-left:0px !important;padding-right:0px !important;">
					<div class="panel panel-default " id="createContent" style="margin-bottom: 0px !important;border:none !important;box-shadow:none !important;">
						<div class="panel-body" style="background-color:#f1f5f7 !important;padding-top:50px !important;padding-bottom:50px !important;" >
							<div class="col-md-3 col-md-offset-1" align="left"  style="padding-bottom: 10px; padding-top: 10px;">
								<div align="center"> <img src="/main/bootstrap/images/ticketsgreytransparent.png" alt="Ticekts" width="150px" height="134px"> </div>
							</div>
							<div class="col-md-7  col-md-offset-1" style="color:#999999 !important;" align="left">
								<h4 class="list-group-item-heading caption_header_blue" style=" margin-left: 0px !important;color: #428bca;font-size: 32px;"><%=getPropValue("set_up_your_event_page", lang) %>
</h4><br>
									<ul style="padding-left: 20px !important;">
										<li style="color:#999999;"><span class="pricing_desc_grey"><%=getPropValue("create_single_or_multiple_ticket_types", lang) %></span></li>
										<li style="color:#999999;"><span class="pricing_desc_grey"><%=getPropValue("make_it_one_time_or_recurring", lang) %></span></li>
										<li style="color:#999999;"><span class="pricing_desc_grey"><%=getPropValue("allow_general_admission_or_reserved_seationg", lang) %></span></li>												
										<li style="color:#999999;"><span class="pricing_desc_grey"><%=getPropValue("establishes_genreral_reserved_seating", lang) %>
										</span></li>												
									</ul>
						</div>
					</div>
					<div class="panel panel-default" id="promoteContent" style="margin-bottom: 0px !important;border:none !important;box-shadow:none !important;">
						<div class="panel-body" style="background:#fff;padding-top:50px !important;padding-bottom:50px !important;">
							<div class="col-md-3 col-md-offset-1" style="color:#999999 !important;" align="left">
								<div align="center"> <img src="/main/bootstrap/images/brushgreytransparent.png" alt="Brush" width="150px" height="155px"> </div>
							</div>
							<div class="col-md-7  col-md-offset-1" align="left" style="">								
								<h4 class="list-group-item-heading  caption_header_blue" style=" margin-left: 0px !important;color: #428bca;font-size: 32px;"><%=getPropValue("customize_your_event", lang) %>
</h4><br>
								<ul style="padding-left: 20px !important;">
										<li style="color:#999999;"><span class="pricing_desc_grey"><%=getPropValue("setup_dynamic_registration", lang) %></span></li>
										<li style="color:#999999;"><span class="pricing_desc_grey"><%=getPropValue("design_branded_look_and_feel", lang) %></span></li>												
										<li style="color:#999999;"><span class="pricing_desc_grey"><%=getPropValue("customize_your_confirmation_email", lang) %></span></li>												
									</ul>
								
							</div>
						</div>
					</div>
					<div class="panel panel-default" id="manageContent" style=" margin-bottom: 0 !important;border:none !important;box-shadow:none !important;">
						<div class="panel-body" style="background-color:#f1f5f7 !important;padding-top:50px !important;padding-bottom:50px !important;">
							<div class="col-md-3 col-md-offset-1" align="left"  style=" padding-bottom: 10px; padding-top: 34px;padding-left:0px !important;">
								<div align="center"> <img src="/main/bootstrap/images/creditcardgreytransparent.png" alt="Credit Card" width="150px" height="90px"> </div>
							</div>
							<div class="col-md-7  col-md-offset-1" style="color:#999999 !important;" align="left" >
								<h4 class="list-group-item-heading  caption_header_blue" style=" margin-left: 0px !important;color: #428bca;font-size: 32px;"><%=getPropValue("flexible_credit_card_processing", lang) %></h4><br>
							<ul style="padding-left: 20px !important;">
										<li style="color:#999999;"><span class="pricing_desc_grey"><%=getPropValue("choose_paypal_stripe_braintree_auth_net_eventbee", lang) %></span></li>
										<li style="color:#999999;"><span class="pricing_desc_grey"><%=getPropValue("immediate_access_to funds_with_pay_pal_stripe_brain_net", lang) %></span></li>								
										<li style="color:#999999;"><span class="pricing_desc_grey"><%=getPropValue("for_seamless_credit_card_processing_choose_event", lang) %></span></li>												
									</ul>
								
							</div>
						</div>
					</div>				
				</div>
				<div style="clear:left;"></div>
			</div>
			</div>
			
					</div>
						<div style="clear:both;"></div><div class="col-lg-12" style="padding:0px;padding-left:50px;margin:0px;padding-top:5px;display:none;" id="secondDiv" >
		<div class="container" style="width:100%;padding-left:0px !important;padding-right:0px !important;">	
			<div id="promoteContentMain" class="">
				<div class="col-md-11" style="padding-left:0px !important;padding-right:0px !important;">
					<div class="panel panel-default" id="promoteContent" style="margin-bottom: 0px !important;border:none !important;box-shadow:none !important;">
						<div class="panel-body" style="background-color:#f1f5f7 !important;padding-top:50px !important;padding-bottom:50px !important;" >
							<div class="col-md-3 col-md-offset-1"  style="" align="left">
								<div align="center" > <img src="/main/bootstrap/images/linksgreytransparent.png" alt="Links" width="150px" height="150px"> </div>
							</div>
							<div class="col-md-7  col-md-offset-1" style="color:#999999 !important;" align="left">
								<h4 class="list-group-item-heading caption_header_blue" style=" margin-left: 0px !important;color: #428bca;font-size: 32px;"><%=getPropValue("publicize_your_even_page", lang) %></h4><br>
								<ul style="padding-left: 20px !important;">
										<li style="color:#999999;"><span class="pricing_desc_grey"><%=getPropValue("place_the_event_link_on_your_website_and_your_mails", lang) %></span></li>
										<li style="color:#999999;"><span class="pricing_desc_grey"><%=getPropValue("dispaly_our_event_ticket_widget_on_your_website", lang) %></span></li>												
										<li style="color:#999999;"><span class="pricing_desc_grey"><%=getPropValue("add_the_event_link_your_print_media", lang) %></span></li>												
									
							</ul>
							</div>
						</div>
					</div>
					<div class="panel panel-default" id="promoteContent" style="margin-bottom: 0px !important;border:none !important;box-shadow:none !important;">
						<div class="panel-body" style="background:#fff;padding-top:50px !important;padding-bottom:50px !important;">
							<div class="col-md-3 col-md-offset-1"  style="color:#999999 !important;padding-bottom: 10px; padding-top: 14px;" align="left">
								<div align="center"> <img src="/main/bootstrap/images/socialsharinggreytransparent.png" alt="Social Sharing" width="150px" height="132px"> </div>
							</div>
							<div class="col-md-7  col-md-offset-1" align="left" style="">								
								<h4 class="list-group-item-heading  caption_header_blue" style=" margin-left: 0px !important;color: #428bca;font-size: 32px;"><%=getPropValue("social_media_sharing", lang) %></h4><br>
								<ul style="padding-left: 20px !important;">
										<li style="color:#999999;"><span class="pricing_desc_grey"><%=getPropValue("enable_t_g_s", lang) %>
 </span></li>
										<li style="color:#999999;" ><span class="pricing_desc_grey"><%=getPropValue("allow_facebook_commenting_your_event_page", lang) %></span></li>											
										<li style="color:#999999;"><span class="pricing_desc_grey"><%=getPropValue("reward_attendees_for_social_sharing", lang) %></span></li>												
									</ul>
								
							</div>
						</div>
					</div>
					
					<div class="panel panel-default" id="manageContent" style=" margin-bottom: 0 !important;border:none !important;box-shadow:none !important;">
						<div class="panel-body" style="background-color:#f1f5f7 !important;padding-top:50px !important;padding-bottom:50px !important;">
							<div class="col-md-3 col-md-offset-1" align="left"  style="padding-bottom: 10px; padding-top: 10px;padding-left:0px !important;">
								<div align="center"> <img src="/main/bootstrap/images/facebookticketgreytransparent.png" alt="Facebook Ticket" width="150px" height="123px"> </div>
							</div>
							<div class="col-md-7  col-md-offset-1" style="color:#999999 !important;" align="left" >
								<h4 class="list-group-item-heading  caption_header_blue" style=" margin-left: 0px !important;color: #428bca;font-size: 32px;"><%=getPropValue("facebook_fan_page_ticketing", lang) %></h4><br>
								<ul style="padding-left: 20px !important;">
										<li style="color:#999999;"><span class="pricing_desc_grey"><%=getPropValue("dispaly_buy_tickets_tab_your_fan_page", lang) %></span></li>
										<li style="color:#999999;"><span class="pricing_desc_grey"><%=getPropValue("allow_fan_buy_ticket_through_facebook", lang) %></span></li>												
										<li style="color:#999999;"><span class="pricing_desc_grey"><%=getPropValue("Customize_which_events_to_display_on_your_fan_page", lang) %></span></li>												
								
								</ul>
							</div>
						</div>
					</div>				
				</div>
				<div style="clear:left;"></div>
			</div>
			</div>
			
			
					</div>
				<div style="clear:both;"></div>
					<div class="col-lg-12" style="padding:0px;padding-left:50px;margin:0px;padding-top:5px;display:none;" id="thirdDiv" >
		<div class="container" style="width:100%;padding-left:0px !important;padding-right:0px !important;">	
			<div id="manageContentMain" class="">
				<div class="col-md-11" style="padding-left:0px !important;padding-right:0px !important;">
					<div class="panel panel-default" id="manageContent" style=" margin-bottom: 0 !important;border:none !important;box-shadow:none !important;">
						<div class="panel-body" style="background-color:#f1f5f7 !important;padding-top:50px !important;padding-bottom:50px !important;">
							<div class="col-md-3 col-md-offset-1" align="left"  style="padding-bottom: 10px; padding-top: 10px;padding-left:0px !important;">
								<div align="center"> <img src="/main/bootstrap/images/24hoursgrey.png" alt="24 Hours" width="150px" height="146px"/> </div>
							</div>
							<div class="col-md-7  col-md-offset-1" style="color:#999999 !important;padding-top: 4px;" align="left" >
								<h4 class="list-group-item-heading  caption_header_blue" style=" margin-left: 0px !important;color: #428bca;font-size: 32px;"><%=getPropValue("Streamline_Event_Management", lang) %></h4><br>
									<ul style="padding-left: 20px !important;">
										<li style="color:#999999;"><span class="pricing_desc_grey"><%=getPropValue("Add_sub_managers_to_your_event_and_delegate_tasks", lang) %></span></li>
										<li style="color:#999999;"><span class="pricing_desc_grey"><%=getPropValue("Email_attendees_with_one_click_to_give_event_updates", lang) %></span></li>												
										<li style="color:#999999;"><span class="pricing_desc_grey"><%=getPropValue("Access_your_account_24/7_to_make_any_changes", lang) %></span></li>												
									</ul>
								
							</div>
						</div>
					</div>
					<div class="panel panel-default" id="promoteContent" style="margin-bottom: 0px !important;border:none !important;box-shadow:none !important;">
						<div class="panel-body" style="background:#fff;padding-top:50px !important;padding-bottom:50px !important;">
							<div class="col-md-3 col-md-offset-1"  style="color:#999999 !important;padding-bottom: 10px; padding-top: 10px;" align="left">
								<div align="center"> <img src="/main/bootstrap/images/reportsgrey.png" alt="Reports" width="150px" height="202px"/> </div>				
							</div>
							<div class="col-md-7  col-md-offset-1" align="left" style="padding-top: 38px;">
								<h4 class="list-group-item-heading  caption_header_blue" style=" margin-left: 0px !important;color: #428bca;font-size: 32px;"><%=getPropValue("Extensive_Reporting", lang) %></h4><br>
								<ul style="padding-left: 20px !important;">
										<li style="color:#999999;"><span class="pricing_desc_grey"><%=getPropValue("Gather_Attendee_data", lang) %></span></li>
										<li style="color:#999999;"><span class="pricing_desc_grey"><%=getPropValue("Generate_sales_reports", lang) %></span></li>												
										<li style="color:#999999;"><span class="pricing_desc_grey"><%=getPropValue("Export_reports_to_Excel_or_PDFs", lang) %></span></li>												
									</ul>
								
							</div>
						</div>
					</div>
					<div class="panel panel-default" id="createContent" style="margin-bottom: 0px !important;border:none !important;box-shadow:none !important;">
						<div class="panel-body" style="background-color:#f1f5f7 !important;padding-top:50px !important;padding-bottom:50px !important;" >
							<div class="col-md-3 col-md-offset-1" align="left"  style="padding-bottom: 10px; padding-top: 10px;">
								<div align="center"> <img src="/main/bootstrap/images/qrcodegrey.png" alt="QR Code" width="150px" height="150px"/> </div>
							</div>
							<div class="col-md-7  col-md-offset-1" style="color:#999999 !important; padding-top: 8px;" align="left">
								<h4 class="list-group-item-heading caption_header_blue" style=" margin-left: 0px !important;color: #428bca;font-size: 32px;"><%=getPropValue("At_The_Door", lang) %></h4><br>
								<ul style="padding-left: 20px !important;">
										<li style="color:#999999;"><span class="pricing_desc_grey"><%=getPropValue("Use_Eventbee_mobile_app_to_check_in_attendees", lang) %></span></li>
										<li style="color:#999999;"><span class="pricing_desc_grey"><%=getPropValue("Scan_QR_code_or_barcode_for_faster_check_in", lang) %></span></li>												
										<li style="color:#999999;"><span class="pricing_desc_grey"><%=getPropValue("Sell_tickets_and_process_credit_cards_with_Eventbee_Manager_app", lang) %></span></li>												
									</ul>
							
							</div>
						</div>
					</div>								
				</div>
				<div style="clear:left;"></div>
			</div>	
			</div>
			
					</div>
				
				</div>
			</div>
			<div class="flat-fee-pricing_cont col-lg-12" id="flatfeepricing" style="height:498px;overflow-y:auto;">
				<div class="col-lg-12" >
					<a id="close1" onclick="closeFlat();" style="color:#fff;cursor:pointer;top:5px;right:10px;font-size:15px;position:absolute;" >X</a>
				</div><br/>
				
				
				
				
				<div class="col-lg-12" style="padding:20px;">
					<div class="col-lg-9">
						<div class="col-lg-11" style="padding-right:0px">
							<div class="col-lg-10" style="background-color:#7e96c4;min-height:98px;padding:35px;">
								<div class="col-lg-1" >
									<div class="main_header_orange">$1</div>
								</div>
								<div class="col-lg-2" style="font-size:20px;font-weight:normal;color:#fff;padding:15px;">
									/<%=getPropValue("ticket", lang) %>
								</div>
								<div class="col-lg-7" style="font-size:35px;font-weight:normal;color:#fff;padding:2px;text-align:center;">
									<%=getPropValue("basic", lang) %>
								</div>			
							</div>
							<div class="col-lg-2" id="view-savings" style="background-color:5976af;font-size:19px;font-weight:normal;color:#fff;text-align:center;padding:38px;color:#fff;cursor:pointer;" >
								<a id="changeText" style="color:#fff;cursor:pointer;"><%=getPropValue("view_savings", lang) %></a>
							</div>							
						</div>
						<div class="col-lg-12" id="view-savings-cont" style="margin:25px 0px;padding:0px;">
							<div class="col-lg-4" id="pro-cont" style="margin-right:12px;">
								<div class="col-lg-12 pro-main" style="background-color:#1d3971;color:#fff;text-align:center;">
									<div style="margin:67px 40px 5px 40px;">
										<div class="caption_header_blue" style="color:#fff;">Pro</div>
									</div>
									<div style="font-size:30px;color:#fff;margin-bottom:65px;">
										<div class="main_header_orange">$1.50</div></sup><sub><font style="font-size:15px;text-align:top;">/<%=getPropValue("ticket", lang) %></font></sub>
									</div>
								</div>
								<div class="col-lg-12 pro-hover" style="background-color:#1d3971;color:#fff;text-align:center;padding:0px;display:none;">
									<div class="col-lg-12" style="padding:0px;">
										<span  class="col-lg-6" style="font-size:30px;color:#fff;text-align:left;font-weight:normal;">
											Pro
										</span>
										<span class="col-lg-6" style="font-size:30px;color:#fff;text-align:right;font-weight:normal;">
											<font style="font-size:25px;">$</font> <font style="font-size:35px;">1</font><sup><font style="font-size:15px;text-align:top;">50</font></sup>
										</span>
										<div class="col-lg-12" style="text-align:left;padding:20px;">
											<%=getPropValue("Extra_customization_to_give", lang) %><br/> <%=getPropValue("you_an_edge_in_making_your", lang) %><br/> <%=getPropValue("event_unique1", lang) %>
										</div>
										<div class="col-lg-12" style="margin:0px auto;float:none;padding:0px;text-align:center;" >
											<a class="btn learn_more1" herf="#"><%=getPropValue("learn_more", lang) %></a>
										</div>
									</div>
								</div>
							</div>
							<div class="col-lg-4" id="advanced-cont" style="margin-right:12px;">
								<div class="col-lg-12 advanced-main" style="background-color:#1d3971;color:#fff;text-align:center;">
									<div style="margin:27px 40px 5px 40px;">
										<div class="caption_header_blue" style="color:#fff;"><%=getPropValue("advanced", lang) %></div>
										<div class="normal_desc_grey" style="color:#fff;" style="line-height:0.55">Con reserva de asientos</div>
									</div>
									<div style="margin-bottom:65px;">
										<div class="main_header_orange">$2</div><sub><font style="font-size:15px;text-align:top;">/<%=getPropValue("ticket", lang) %></font></sub>
									</div>
								</div>
								<div class="col-lg-12 advanced-hover" style="background-color:#1d3971;color:#fff;text-align:center;padding:0px;display:none;">
									<div class="col-lg-12" style="padding:0px;">
										<span  class="col-lg-6" style="font-size:30px;color:#fff;text-align:left;font-weight:normal;">
											<%=getPropValue("advanced", lang) %>
										</span>
										<span class="col-lg-6" style="font-size:30px;color:#fff;text-align:right;font-weight:normal;">
											<font style="font-size:25px;">$</font> <font style="font-size:35px;">2</font>
										</span>
										<div class="col-lg-12" style="text-align:left;padding:20px;">
											<%=getPropValue("Extra_customization_to_give", lang) %><br/> <%=getPropValue("you_an_edge_in_making_your", lang) %><br/> <%=getPropValue("event_unique1", lang) %>
										</div>
										<div class="col-lg-12" style="margin:0px auto;float:none;padding:0px;text-align:center;" >
											<a class="btn learn_more1" herf="#"><%=getPropValue("learn_more", lang) %></a>
										</div>
									</div>
								</div>
							</div>
							<div class="col-lg-4" id="business-cont">
								<div class="col-lg-12 business-main" style="background-color:#1d3971;color:#fff;text-align:center;">
									<div style="font-size:30px;color:#fff;margin:80px 40px 5px 40px;">
										<%=getPropValue("Business", lang) %>
									</div>
									<div style="font-size:30px;color:#fff;margin-bottom:65px;">
										<font style="font-size:25px;">$</font> <font style="font-size:35px;">4</font><sub><font style="font-size:15px;text-align:top;">/<%=getPropValue("ticket", lang) %></font></sub>
									</div>
								</div>
								<div class="col-lg-12 business-hover" style="background-color:#1d3971;color:#fff;text-align:center;padding:0px;display:none;">
									<div class="col-lg-12" style="padding:0px;">
										<span  class="col-lg-6" style="font-size:30px;color:#fff;text-align:left;font-weight:normal;">
											<%=getPropValue("Business", lang) %>
										</span>
										<span class="col-lg-6" style="font-size:30px;color:#fff;text-align:right;font-weight:normal;">
											<font style="font-size:25px;">$</font> <font style="font-size:35px;">4</font>
										</span>
										<div class="col-lg-12" style="text-align:left;padding:20px;">
											<%=getPropValue("Extra_customization_to_give", lang) %><br/> <%=getPropValue("you_an_edge_in_making_your", lang) %><br/> <%=getPropValue("event_unique1", lang) %>
										</div>
										<div class="col-lg-12" style="margin:0px auto;float:none;padding:0px;text-align:center;" >
											<a class="btn learn_more1" herf="#"><%=getPropValue("learn_more", lang) %></a>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="col-lg-12" id="view-savings-cont1" style="margin:25px 0px;padding:0px;display:none;color:#fff;">
								<div class="col-lg-12 calcuator" id="calcuator-main" style="padding-right:0px;">
									
									<div class="col-lg-4 calc-a">
										<ul id="eventSites">
											<li id="eventbrite1" class="active-site">Eventbrite</li>
											<li id="ticketleap1">Ticketleap</li>
											<li id="ticketmaster1">Ticketmaster</li>
											<li id="custom1">Custom<input type="text" size="2" id="pf" class="input-field" autofocus></input>%+$<input type="text" size="2" id="ff"class="input-field" autofocus></input></li>
										</ul>
									</div>
									
									<div class="col-lg-8 calc-b">
										<div class="col-lg-11 calc-b-a">
											<div class="col-lg-12" style="padding:6px;">
												<a id="close3"  style="color:#000;cursor:pointer;top:5px;right:10px;font-size:15px;position:absolute;" >X</a>
											</div><br/>
											<div class="col-lg-12" id="ticketmaster_new" style="text-align:center;padding:1px;">
												
												<div class="col-lg-12 ticket-cont">
													<div class="col-lg-12">
														<div class="col-lg-3" align="center" style="color:#113764;padding:0px !important;margin:8px 0px !important;"><%=getPropValue("Ticket_price" ,lang) %></div>
														<div class="col-lg-9"  align="center">
															<div class="unranged-value" style="width: 350px; margin: 8px;text-align:center;"></div>
														</div>
														
													</div>
												</div>
												
												<div class="col-lg-12 ticket-cont">
													<div class="col-lg-12">
														<div class="col-lg-3" align="center" style="color:#113764;padding:0px !important;margin:8px 0px !important;"><%=getPropValue("Ticket_Quantity" ,lang) %></div>
														<div class="col-lg-9"  align="center">
															<div class="unranged-value1" style="width: 350px; margin: 8px;text-align:center;"></div>
														</div>
														
													</div>
												</div>
												
											</div>
										</div>
										<div class="col-lg-11" style="text-align:center;background-color:#de961e;padding:14px;">
											<font style="font-size:30px;color:#fff;">$</font>
											<font style="font-size:55px;color:#fff !important;" id="savedamount"> 0</font>
											<font style="font-size:20px;color:#fff;"><%=getPropValue("saved" ,lang) %></font>
										</div>
									</div>
									<input type="hidden" id="slider_range" class="flat-slider" />
								</div>	
							</div>
							</div>
			<div class="col-lg-3" style="margin:0;text-align:center;">
						<div class="col-lg-12" style="color:#fff;font-size:35px;font-weight:normal;" >
							<%=getPropValue("Use_it_for_free" ,lang) %>
						</div>
						<div class="col-lg-12" style="color:#fff;font-size:15px;font-weight:normal;text-align:left;" >
							<ul style="margin-top:30px;">
								<li style="margin-bottom:30px;"><%=getPropValue("Eventbee_is_free_to_use" ,lang) %></br><%=getPropValue("when_your_ticket_are_free" ,lang) %><br/><%=getPropValue("Use_all_of_our_exclusive" ,lang) %><br/><%=getPropValue("features_at_no_cost" ,lang) %></li>
								<li><%=getPropValue("We'll_bundle_the_free_into" ,lang) %></br><%=getPropValue("your_ticketare_price_so_you_can" ,lang) %><br/><%=getPropValue("focus_on_the_important_stuff" ,lang) %><br/></li>
							</ul>
							<a href="/main/user/signup<%=getQuestionMarkLink(lang)%>" > 
							<div class="col-lg-12" ><button class="btn sign-up2"><%=getPropValue("sign_up" ,lang) %></button></div></a>
						</div>
					</div>
					<div class="col-lg-12" id="creditcardclose">
						<div class="col-lg-12" id="creidt-card" style="color:#fff;font-size:25px;cursor:pointer;">
							<a class="creidt-card-text">+<%=getPropValue("credit_card_processing" ,lang) %> <i class="glyphicon glyphicon-menu-right" id="cursor123" style="font-size:20px;"></i></a>
						</div>
						
							<div class="col-lg-12" id="creidt-card-cont" style="display:none;">
							<div class="col-lg-8" style="background-color:#de961e;text-align:center;font-size:18px;color:#4a4a4a;padding:20px;">
								<%=getPropValue("Immediate_access_to_your_funds" ,lang) %> <font style="font-weight:bold;">~2.9%+30&#8373;</font>
								<div class="col-lg-12" style="margin:10px;">
									<img src="/columbia/images/pay-img.jpg"/>
								</div>
							</div>
							<div class="col-lg-4" style="background-color:#f0c680;">
								<div class="col-lg-12" style="text-align:center;font-size:18px;color:#2c489e;padding:20px;">
									<%=getPropValue("Optinal_processing_at" ,lang) %> <font style="font-weight:bold;">4.95%+50&#8373;</font>
									<img src="/columbia/images/logo1.png">
								</div>
							</div>
						</div>

					</div>
				</div>
			</div>
		
		
	</section>
	 <%--  <div class="col-lg-12 pre-menu text-center">
			<ul id="myMenu" class="pre-menu-list text-center">
				<li><div class="pre-menu-list1"><a  id="open" href="#" class="how-it-work"><%=getPropValue("how-it-works" ,lang) %></a></div></li>
				<li><div class="pre-menu-list1"><a  id="open1" href="#" class="flat-fee-pricing"><%=getPropValue("flat-fee-pricing" ,lang) %>  </a></div></li> 
			</ul>
		</div> --%>
<%-- 	<section>
	<!-- <hr style="margin: 0px; background-color: #606060; height: 4px; border-top: 1px solid #282828;" /> -->		
			<div class="col-lg-12 col-sm-12" style="padding:0% 0% 0% 4%;text-align:center; background-color:#d8d8d8;">
				<div class="col-lg-4 col-md-4 col-sm-4 immediate_access">
					<div align="center" style="margin-top:3px;"><img id="cardImg" class="center mag2" src="/columbia/images/immediate_access.png" style="margin:0 auto;"/> <br/><%=getPropValue("immediate_acc_fuds" ,lang) %>
						<div class="col-lg-12 col-md-12 col-sm-12" id="learn_button" style="padding:0px">
							<div class="col-lg-6 col-sm-6 col-md-6" style="margin:0px auto;float:none;padding:0px;" >
								<a class="btn learn_more"> <%=getPropValue("learn_more" ,lang) %></a>
							</div>
						</div>
					</div>
				</div>
				
				<div class="col-lg-4 col-md-4 col-sm-4 facebook">
					<div align="center"><img id="facebookImg" class=" center mag3" src="/columbia/images/facebook.png" style="margin:0 auto;"/> <br/><%=getPropValue("sell_tick_dir_thr_fb" ,lang) %>
						<div class="col-lg-12 col-md-12 col-sm-12" id="learn_button1" style="padding:0px">
							<div class="col-lg-6 col-sm-6 col-md-6" style="margin:0px auto;float:none;padding:0px" >
								<a class="btn learn_more" herf="#"> <%=getPropValue("learn_more" ,lang) %></a>
							</div>
						</div>
					</div>
				</div>
				<div class="col-lg-4 col-md-4 col-sm-4 gift">
					<div align="center"><img id="giftImg" class="center mag3" src="/columbia/images/gift.png" style="margin:0 auto;"/> <br/><%=getPropValue("free_kindle_fire_something" ,lang) %>
						<div class="col-lg-12 col-md-12 col-sm-12" id="learn_button2" style="padding:0px">
							<div class="col-lg-6 col-sm-6 col-md-6" style="margin:0px auto;float:none;padding:0px">
								<a class="btn learn_more" herf="#"> <%=getPropValue("learn_more" ,lang) %></a>
							</div>
						</div>
					</div>
				</div>
				
			</div>
	
		<hr style="margin: 0px; background-color: #606060; height: 4px; border-top: 1px solid #282828;" />		
		
	</section> --%>	
	
	 <div style="clear:both"></div> 
<!-- full width container footer -->
<div class="container" style="background-color: #474747; width: 100%;">
<!-- <hr style="margin: 0; background-color: #606060; height: 1px; border-top: 1px solid #282828;"> -->
<style>
   .select2-container .select2-choice > .select2-chosen { text-align: center;
    padding-left: 25px;}
    </style>
    <%if(lang.equals("es-co")){%>
      <style>
   .select2-chosen{
   	 background-image: url("<%=resourceaddress%>/main/images/flags/flag_colombia.png");
   	 background-repeat:no-repeat;
   	 background-size:25px 27px;
   	 background-position:center left;
   }
    </style>
   <%} %>
    <%if(lang.equals("es-mx")){%>
    <style>
   .select2-chosen{
   	 background-image: url("<%=resourceaddress%>/main/images/flags/flag_mexico.png");
   	 background-repeat:no-repeat;
   	 background-size:25px 27px;
   	 background-position:center left;
   }
    </style>
   <%} %>
    
     <%if(lang.equals("en-us")){%>
    <style>
   .select2-chosen{
   	 background-image: url("<%=resourceaddress%>/main/images/flags/flag_united_states.png");
   	 background-repeat:no-repeat;
   	 background-size:25px 27px;
   	 background-position:center left;
   }
    </style>
   <%} %>
	<div class="container footer">
	     
		<div class="row" style="margin: 0 auto; padding-bottom: 0px;">
				<div class="col-md-4">&nbsp;</div>
				<div class="col-md-4">&nbsp;</div>
				<div class="col-md-9 col-sm-9 " style="margin: 0 auto; padding-bottom: 10px;">
				<div class="col-md-4">
			<%-- <a>
		 <select name="" style="width:200px;height:36px !important;line-height:35px !important;margin-top:10px !important;padding: 0px !important;" id="states" onchange="languageClick(value)"> 
		   	<option value="es-co" <%if(lang.equals("es-co")){%>selected='selected' class="select-active"<%} %>>Colombia - Spanish</option>
		   	<option value="es-mx" <%if(lang.equals("es-mx")){%>selected='selected' class="select-active"<%} %>>Mexico - Spanish</option>     
		    <option value="en-us" <%if(lang.equals("en-us")){%>selected='selected' class="select-active"<%} %>>United States - English</option>             
		</select>      
			</a>  --%>
			</div>
		</div>
		<!-- <div class="row" style="margin: 0 auto; padding-bottom: 10px;">
			<div class="row" id="rootDiv">
			</div>
		</div> -->
		<div class="col-md-9 col-sm-9 " style="margin: 0 auto; padding-bottom: 10px;">
		<div class="row" id="rootDiv">
			</div>
		</div>
		<div class="col-md-3 col-sm-3" style="margin-top:16px;">
		<a>
		 <select name="" style="width:200px;height:36px !important;line-height:35px !important;margin-top:10px !important;padding: 0px !important;" id="states" onchange="languageClick(value)"> 
		   	<option value="es-co" <%if(lang.equals("es-co")){%>selected='selected' class="select-active"<%} %>>Colombia - Spanish</option>
		   	<option value="es-mx" <%if(lang.equals("es-mx")){%>selected='selected' class="select-active"<%} %>>Mexico - Spanish</option>     
		    <option value="en-us" <%if(lang.equals("en-us")){%>selected='selected' class="select-active"<%} %>>United States - English</option>             
		</select>      
			</a> 
		</div>
		
		
	</div>
</div>
<hr style="margin: 0; background-color: #606060; height: 1px; border-top: 1px solid #282828;">

<div class="container" style="background-color: #474747; width: 100%;">
	<div class="container footer">
		<div class="row" style="margin: 0 auto; padding-top: 15px;">
			<div class="row">
				<center>
					<span style="font-size: 12px; color: #ccc"><%=getPropValue("copyright_eventbee_all_right_reserved" ,lang) %> </span>
				</center>
				<span class="footerlinks" style="font-size: 0.7em" id="lowerlinks">
					<center>
						 <a href="/main/privacystatement<%=getSlashLinkPath(lang)%>">
						<%=getPropValue("privacy_statement" ,lang) %></a> 
						<span style="color: #ccc"> |</span>   
						<a
							href="/main/termsofservice<%=getSlashLinkPath(lang)%>"><%=getPropValue("term_of_services" ,lang) %></a>
				
					</center>
				</span>
				<center>
					<span style="font-size: 12px; color: #ccc"><%=getPropValue("with_backing_magr_world_records_sales_promotion" ,lang) %></span>
				</center>
			</div>
			<br />
		</div>
	</div>
</div>
	<script>
$(document).ready(function(){
	fillHTML();
	
	$('.fscaret').css({"left":"47px","margin-left":"-15px","z-index": "1"});
}); 

$('#eventSites').on('click', 'li', function(){
    $('#eventSites li').removeClass('active-site');
    $(this).addClass('active-site');
    
});
</script>
            <div class="container copy">
			<div class="row">
			<div class="col-md-12">
			<!-- Modal -->
			<div class="modal" id="myModal" tabindex="-1" role="dialog" aria-hidden="true">
			<div class="modal-dialog">
			<div class="modal-content">
			<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
			<h4 class="modal-title"></h4>
			</div>
			<div class="modal-body">
			<iframe id="popup" src="" width="100%"  style="height:430px" frameborder="0"></iframe>
			</div></div></div></div></div>
			</div>
			</div>
	
		<script src="<%=resourceaddress%>/main/js/bootstrap.min.js"></script>
		
		<script src="/main/js/select2.js"></script>
	 <script>
        $(document).ready(function() {
            $("#states").select2();   
        });
    </script>
		
	<script type="text/javascript">
	
		$(".immediate_access").mouseenter(function(){
			
			$('#cardImg').attr("src","/columbia/images/immediate_access_hover.png");		
			$('#learn_button').css("display","block");		 	
		});
		$(".immediate_access").mouseleave(function(){
			$('#cardImg').attr("src","/columbia/images/immediate_access.png");
			$('#learn_button').css("display","none");	
		});
		$(".facebook").mouseenter(function(){
			$('#facebookImg').attr("src","/columbia/images/facebook_hover.png");		
			$('#learn_button1').css("display","block");		 	
		});
		$(".facebook").mouseleave(function(){
			$('#facebookImg').attr("src","/columbia/images/facebook.png");
			$('#learn_button1').css("display","none");	
		});
		$(".gift").mouseenter(function(){
			$('#giftImg').attr("src","/columbia/images/gift_hover.png");		
			$('#learn_button2').css("display","block");		 	
		});
		$(".gift").mouseleave(function(){
			$('#giftImg').attr("src","/columbia/images/gift.png");
			$('#learn_button2').css("display","none");	
		});
		$("#pro-cont").mouseenter(function(){
			$('.pro-hover').show();
		 	$('.pro-main').hide();	
		});
		$("#pro-cont").mouseleave(function(){
			$('.pro-main').show();	
			$('.pro-hover').hide();
		});
		$("#advanced-cont").mouseenter(function(){
			$('.advanced-hover').show();
		 	$('.advanced-main').hide();	
		});
		$("#advanced-cont").mouseleave(function(){
			$('.advanced-main').show();	
			$('.advanced-hover').hide();
		});
		$("#business-cont").mouseenter(function(){
			$('.business-hover').show();
		 	$('.business-main').hide();	
		});
		$("#business-cont").mouseleave(function(){
			$('.business-main').show();	
			$('.business-hover').hide();
		});

		$(document).ready(function()
		{
			$('#myMenu').on('click','a',function()
			{
				$('.subcontent:visible').fadeOut(0);
				$('.subcontent[id='+$(this).attr('data-id')+']').fadeIn();
			});
		});
		$('#open').click(function() {
			
			$('#first').addClass('active');
			$('#second').removeClass('active');
			$('#third').removeClass('active');
			changeDiv('create');
			$('#flatfeepricing').slideUp(1000);
			$('#open1').removeClass('active1');
			$('#open').addClass('active');
			$('#howitworks').css('bottom',$('.navbar').height()-6);
			$('#howitworks').animate({
				height: 'toggle'
				}, 1000, function() {
			});
		});
		$('#close').click(function() {
			
			$('#open').removeClass('active');
			$('#howitworks').animate({
				height: 'toggle'
				}, 1000, function() {
				
			});
		});


		function closeFlat(){
			$('#open1').removeClass('active1');
			$('#flatfeepricing').animate({
				height: 'toggle'
				}, 1000, function() {
			});
		}

		$(window).scroll(function() {
			if ($(document).scrollTop() > 200) {
				$('#open').removeClass('active');
				$('#howitworks').slideUp(1000);
			} 
		});

		$('#open1').click(function() {
			
		$('#cursor123').addClass("glyphicon-menu-right").removeClass("glyphicon-menu-down");
		$('#creidt-card-cont').slideUp();
	 $('#view-savings-cont').slideDown();
			$('#view-savings').text('<%=getPropValue("view_savings", lang)%>');  
	    $('#view-savings-cont1').slideUp();
			$('#howitworks').slideUp(1000);
			$('#open').removeClass('active');
			$('#open1').addClass('active1');
			$('#flatfeepricing').css('bottom',$('.navbar').height()-7);
			$('#flatfeepricing').animate({
				height: 'toggle'
				}, 1000, function() {
				
			});
		});
		
		$(window).scroll(function() {
			if ($(document).scrollTop() > 200) {
				$('#open1').removeClass('active1');
				$('#flatfeepricing').slideUp(1000);
			} 
		});	

		
		$(document).ready(function(){
			$('#navigation .arrow_link').click(function(event){
				$('.active').removeClass('active');
				$(this).addClass('active');
				event.preventDefault();
			});
		});
            $(document).ready(function() {
			$('#creidt-card').click(function() {
				$('.creidt-card-text').css( 'cursor', 'pointer' );
				$(this).find('i').toggleClass('glyphicon-menu-right').toggleClass('glyphicon-menu-down');
			});
		});


		$(document).ready(function() {
			$('#creidt-card').click(function() {
                $('#creidt-card-cont').slideToggle(1000);
				$('#flatfeepricing').animate({scrollTop:420}, 1000);
                              
			});
		});

		
		$(document).ready(function() {
			$('#close3').click(function() {
				$('#close3').css( 'cursor', 'pointer' );
                $('#view-savings-cont').slideToggle(1000);
				$('#view-savings').text( $('#view-savings').text() == '<%=getPropValue("hide_savings", lang)%>' ? '<%=getPropValue("view_savings", lang)%>' : '<%=getPropValue("hide_savings", lang)%>');
                $('#view-savings-cont1').slideToggle(1000);
			});
		});
	</script>

<script>
  (function(i,s,o,g,r,a,m)
		  {i['GoogleAnalyticsObject']=r;i[r]=i[r]||function()
  {
  (i[r].q=i[r].q||[]).push(arguments);
  },i[r].l=1*new Date();
  a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];
  a.async=1;
  a.src=g;
  m.parentNode.insertBefore(a,m);
  })
  (window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-60215903-1', 'auto');
  ga('send', 'pageview');

</script>
		
		
		<script>
				
				$("#logo-img").click(function(){
					if($(".award").is(":visible") == false){
							$('.award').slideDown(fadeTime);
							
							$(".subcontent:visible").fadeOut(0);
							$('#myMenu').find('li a').removeClass("active");
							
							$('#footer-menu').addClass('footer-menu').removeClass("footer-menu-after");	
							$('#mainBody').addClass('body_img').removeClass("body_img_remove");
							$("#logo-img").attr('src','/columbia/images/logo.png');
							$('#myMenu').removeClass('pre-menu-list-change').addClass('pre-menu-list');
							$('.main-menu').addClass('before-nav').removeClass("after-nav");
							
							$('.header').css("background-color","transparent");
							$('.sign-up1').css("display","none");									
							$('.navbar').css("margin-bottom","0px");
							$('.pre-menu').css("margin-top","46px");
							$('.pre-menu').css("margin-bottom","96px");
							$('.pre-menu').css("background-color","rgba(255,255,255,0.4");
					}
	         	});
				
			
		</script>
		<script type="text/javascript">
			$(document).ready(function(){

				$('#myMenu').on('click','a',function(){					
					getSectionContent($(this).attr('data-id'));
				});

				
				$(document).on('click','#contact',function() {
						$('.modal-title').html('<%=getPropValue("contact_ebee" ,lang) %>');
						$('#myModal').on('show.bs.modal', function () {
	
						$('iframe#popup').attr("src",'/main/user/homepagesupportemail.jsp');
						$('iframe#popup').css("height","440px"); 
						});
						
						$('#myModal').modal('show');
					});
				
				
				  $(document).on('click','#getTickets',function() {
						$('.modal-title').html('<%=getPropValue("get_my_tkts" ,lang) %>');
						$('#myModal').on('show.bs.modal', function () {	
							$('iframe#popup').attr("src",'/main/user/homepagemytickets.jsp?hp_lang=<%=lang%>');
							$('iframe#popup').css("height","435px");
						});
						$('#myModal').modal('show');
					});
				
					$('#myModal').modal({
						backdrop: 'static',
						keyboard: false,
						show:false
					});
					
					$(document).on('hide.bs.modal','#myModal', function () {
						$('iframe#popup').attr("src",'');
						$('#myModal .modal-body').html('<iframe id="popup" src="" width="100%" style="height:440px" frameborder="0"></iframe>');
					});		
					
					function showButtons(response){
						 if(response.indexOf('false')>-1){
						    $('.before-login').attr('href','/main/user/login<%=getQuestionMarkLink(lang)%>');
							$('.before-login').find('button').text('<%=getPropValue("log_in" ,lang) %>');
							 
						    $('.after-login').attr('href','/main/user/login<%=getQuestionMarkLink(lang)%>');
						    $('.after-login').text('<%=getPropValue("log_in" ,lang) %>');
						    
							$('.sign-up1').attr('href','/main/user/signup<%=getQuestionMarkLink(lang)%>');
							$('.sign-up1').text('<%=getPropValue("sign_up" ,lang) %>');
							
						   }else{
							   $('.before-login').attr('href','/main/myevents/home');
							   $('.before-login').find('button').text('<%=getPropValue("my_account" ,lang) %>');
							   
							    $('.after-login').attr('href','/main/myevents/home');
							    $('.after-login').text('<%=getPropValue("my_account" ,lang) %>');
							    
								$('.sign-up1').attr('href','/main/user/logout');
								$('.sign-up1').text('<%=getPropValue("log_out" ,lang) %>');
						   }
						}
					
						$.ajax({
						url: "/main/getUserToken.jsp",
						}).done(showButtons);

				
			});
			
		function getSectionContent(sectionID)
		{
			$('calcuator-main').hide();
			domain1='eventbrite1';
			$('#eventSites li').removeClass('active-site');
		    $('#eventbrite1').addClass('active-site');
			
			
		if(	domain1=='eventbrite1')
			{ 
			$('.calc-b-a').css('pointer-events','visible');
			s0.setValue(100);
	      	s1.setValue(1000);
			}
	      	if(domain1=='ticketleap1')
	    	{
	    	$('.calc-b-a').css('pointer-events','visible');
	    	s0.setValue(100);
	      	s1.setValue(1000);
	    	}
	    	if(domain1=='custom1')
	    		{
	    		
	       	$('.calc-b-a').css('pointer-events','visible');
	    	fixedfee=document.getElementById("ff").value;                  
	    	pf=document.getElementById("pf").value;
	    	
	        s0.setValue(100);
	    		s1.setValue(1000);	
	    	}
	    	
			
			if(sectionID=="how-it-works")
				
				
				
				showHowItWorksContent();
				
			
			else if(sectionID=="flat-fee-pricing")
				{
				
				showFlatFeePricingContent();
				}
			
			else if(sectionID=="immediate-access")
				showImmediateAccessContent();
			
		}		

		
		var pricingLoaded=false;
		var howitWorksLoaded=false;
		var fadeTime=1000;
		function showHowItWorksContent()
		{	
			
			changeDiv('create');
			$(".subcontent:visible").fadeOut(fadeTime);
			$(".subcontent[id='how-it-works']").fadeIn(fadeTime);
			if(!howitWorksLoaded)
			{
				$(".subcontent[id='how-it-works']").html("<div class='text-center'><img src='/main/images/ajax-loader.gif' style='margin-top: 45px;  margin-bottom: 500px;   width: 25px;'/></div>");
				getAjaxContent("/main/help/"+resourceRequestURL+"/how-it-works.jsp",$(".subcontent[id='how-it-works']"),"");
				howitWorksLoaded=true;
			}
		}	

		function showFlatFeePricingContent()
		{
			$(".subcontent[id='how-it-works']").fadeOut(fadeTime);
			$(".subcontent[id='flat-fee-pricing']").fadeIn(fadeTime);
			if(!pricingLoaded)
			{
				$(".subcontent[id='flat-fee-pricing']").html("<div class='text-center'><img src='/main/images/ajax-loader.gif' style='margin-top: 45px;  margin-bottom: 500px;   width: 25px;'/></div>");
				getAjaxContent("/main/help/"+resourceRequestURL+"/pricing.jsp",$(".subcontent[id='flat-fee-pricing']"),"");	
				pricingLoaded=true;
			}
			else
				goToByScroll($("#how-it-works").offset().top-200);
			
		}


		function showImmediateAccessContent()
		{
			$(".subcontent[id='how-it-works']").fadeOut(fadeTime);
			$(".subcontent[id='flat-fee-pricing']").fadeIn(fadeTime);
			if(!pricingLoaded)
			{
				$(".subcontent[id='flat-fee-pricing']").html("<div class='text-center'><img src='/main/images/ajax-loader.gif' style='margin-top: 45px;  margin-bottom: 500px;   width: 25px;'/></div>");
				getAjaxContent("/main/help/"+resourceRequestURL+"/pricing.jsp",$(".subcontent[id='flat-fee-pricing']"),"payments");	
				pricingLoaded=true;
			}
			else				
				goToByScroll($("#payments").offset().top);
		}


		function getAjaxContent(url,element,scrollDiv)
		{
			$.ajax({
				url: url,
				}).done(function(content)
				{
					element.html(content);
					if(scrollDiv && scrollDiv!="")
					{
						goToByScroll($("#"+scrollDiv).offset().top-300);
					}
				});
		}

		function goToByScroll(scrollTO)
		{
		    $('html,body').animate({scrollTop: scrollTO},'slow');
		}

		function resizePriceIframe()
		{
		  	 var obj=document.getElementById('priceIframe');
			 obj.style.height = obj.contentWindow.document.body.offsetHeight + 'px';
		 }



		function fillHTML(){
			
			var html="<br/>";
			for(var i=0;i<i18nFooter.sections.length;i++)
				{
				
				
				var eachSection=i18nFooter.sections[i];
				html+='<div class="col-md-'+eachSection.grids+'">';
			
				for(var j=0;j<eachSection.subsections.length;j++)
					{
					var eachSubSection=eachSection.subsections[j];
					html+='<span class="footertabheader">'+ 
								'<h4>'+
										'<strong>'+eachSubSection.title+'</strong>'+
								'</h4>'+
							'</span>';
					for(var k=0;k<eachSubSection.sublinks.length;k++){
						var eachSubLink=eachSubSection.sublinks[k];
						if(eachSubLink.type=="text"){
						
							
							 if(eachSubLink.strong)
			  	                  html+=' <strong>';
							  if(eachSubLink.i18n_include==false)
								  html+='<span class="footertab"><a href="'+eachSubLink.href+'"';
							else	
								html+='<span class="footertab"><a href="'+eachSubLink.href+'<%= getSlashLinkPath(lang) %>"';  
							   	
							     if(eachSubLink.target)
				  	                  html+=' target="'+eachSubLink.target+'"';
						    	   html+='>';
							   	if(eachSubLink.limg)
				  	                  html+=eachSubLink.limg;
							   	html+=eachSubLink.label+'</a></span>';
							   	
							    if(eachSubLink.strong)
				  	                  html+=' </strong>';
							   	
							    html+='<br/>';
							   
				  	                
						}
					    else if(eachSubLink.type=="img")
						{
					    	html+='<a href="'+eachSubLink.href+'"'; 
							    	if(eachSubLink.target)
				  	                  html+=' target="'+eachSubLink.target+'"';
						    	  html+='>'+
					    				'<img src="'+eachSubLink.src+'"';
						    					if(eachSubLink.width)
						    	                  html+=' width="'+eachSubLink.width+'"';
						    					if(eachSubLink.class_name)
							    	                  html+=' class="'+eachSubLink.class_name+'"';
					    	            html+='/>'+
					    		        '</a> <br/>';
					    }
					}
						
				}	
				
				html+='</div>';
				document.getElementById("rootDiv").innerHTML=html;
			
			}
			
		}

		 
		</script>

<script>
(function() {
  var _fbq = window._fbq || (window._fbq = []);
  if (!_fbq.loaded) {
    var fbds = document.createElement('script');
    fbds.async = true;
    fbds.src = '//connect.facebook.net/en_US/fbds.js';
    var s = document.getElementsByTagName('script')[0];
    s.parentNode.insertBefore(fbds, s);
    _fbq.loaded = true;
  }
})();
 window._fbq = window._fbq || [];
window._fbq.push(['track', '6019644693365', {'value':'0.00','currency':'USD'}]);

</script>
<script>
function changeDiv(id)
{//$('navigation').removeClass('active-site');
$("#create").addClass('active-site');
	if(id=="create")
	{		
		$('#firstDiv').slideDown(500);
		$('#secondDiv').hide();
		$('#thirdDiv').hide();
	}
	else if(id=="promote")
	{
		$('#thirdDiv').slideDown(500);
		$('#firstDiv').hide();		
		$('#secondDiv').hide();
	}
	else if(id=="manage")
	{		
		$('#secondDiv').slideDown(500);
		$('#firstDiv').hide();
		$('#thirdDiv').hide();		
	}
}
</script>

        <script>
   			(function($) {
	   			$.fn.fixMe = function() {
	      return this.each(function() {
	         var $this = $(this),
	          $t_fixed;
	         function init() {
	            $this.wrap('<div />');
	            $t_fixed = $this.clone();
	           $t_fixed.find("tbody").remove().end().addClass("fixed").insertBefore($this);
	            $('.fixed').css('top',$('.navbar-fixed-top').height()+'px');
	           
	            resizeFixed();
	         }

	         function resizeFixed() {
	        	 $t_fixed.find("th").each(function(index) {
		               $(this).css("width",$this.find("th").eq(index).outerWidth()+"px");
		            });
	         }

	         function scrollFixed() {
		            var offset = $(this).scrollTop(),
		            tableOffsetTop = $this.offset().top,
		            tableOffsetBottom = tableOffsetTop + $this.height() - $this.find("thead").height();
		           if(offset+$('.navbar-fixed-top').height() <tableOffsetTop || offset > tableOffsetBottom-$('.navbar-fixed-top').height()){
		            	
		               $t_fixed.hide();
		            }
		            else  if(offset+$('.navbar-fixed-top').height() >= tableOffsetTop && offset <= tableOffsetBottom){
		            	
		            	$t_fixed.show();
		            	
		         }
		         }

	         
	         $(window).resize(resizeFixed);
	         $(window).scroll(scrollFixed);
	         init();
	      });
	   };
	})(jQuery);


      		  function getRoundedValue(value){
	  			var temp = parseFloat(value+"").toFixed(2);
				var parts = temp.toString().split(".");
				parts[0] = parts[0].toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
				if(parseInt(parts[1])==0)
					return parts[0];
				else
				return parts.join(".");  
 				 }


  var ticketPrice=0;
  var ticketQuantity=0;

  var domain1='eventbrite1';
  var fixedfee,pf;
  var initVert3,initVert4;
  var vert1;
  var elem1;

 
  
  var s0 = $(".unranged-value").freshslider({
	    step: 1,
	    value:100,
	    
	    onchange:function(val) {
		  
	    	ticketPrice=val;
	    	fixedfeeandpf();
	    	saveamount(ticketPrice,ticketQuantity);
	    }
	});

	
	
	var s1 = $(".unranged-value1").freshslider({
		step: 1,
		value:1000,
		
		max: 10000,
		onchange:function(val1){
			
			ticketQuantity=val1;
		
			fixedfeeandpf();
			saveamount(ticketPrice,ticketQuantity);
			}
	});


	function  fixedfeeandpf()
	{
		if(domain1=='eventbrite1')
	    {
			fixedfee='2.5';
  	  		pf='0.99';
    	}
		else if(domain1=='ticketleap1')
	    {
			fixedfee='1';
      	  	pf='2';
		}
	}


	function updatePricingDiv()
	{
     if(domain1=='custom1'){
    	 pf=$('#pf').val();
    	 ff=$('#ff').val();
         }
      var amount=(ticketQuantity*ticketPrice*(pf/100))+(ticketQuantity*fixedfee);
      $('#savedamount').html(amount);
	}


		 $('#eventbrite1').click(function(){
			 domain1='eventbrite1';
			 $('#ticketmaster_new').css('pointer-events','visible');
			   	$('.calc-b-a').css('pointer-events','visible');
				s0.setValue(100);
	          	s1.setValue(1000);
                fixedfee='2.5';
          	  	pf='0.99';
          	  	
          	 
             });

			 $('#ticketleap1').click(function(){
			   	domain1='ticketleap1';
			    $('#ticketmaster_new').css('pointer-events','visible');
			   	$('.calc-b-a').css('pointer-events','visible');
          	  	s0.setValue(100);
          	  	s1.setValue(1000);
	            fixedfee='1';
	       	 	pf='2';
	          });

		 	$('#ticketmaster1').click(function(){
			    domain1='ticketmaster1';
			    $('#ticketmaster_new').css('pointer-events','none');
			 
			    
	        	s0.setValue(0);
	          	s1.setValue(0);
         	 	document.getElementById('savedamount').innerHTML='<font>ZILLION</font>'; 
            });

		 	$('#custom1').click(function(){
			   	domain1='custom1';
			    $('#ticketmaster_new').css('pointer-events','visible');
			   	$('.calc-b-a').css('pointer-events','visible');
            	fixedfee=document.getElementById("ff").value;                  
				pf=document.getElementById("pf").value;
				
			    s0.setValue(100);
 				s1.setValue(1000);	
                  

 			 	});

		 function saveamount(avg, num) {
			 
		     var tktprice = avg;
		     var tktcnt = num;
		     var savedamt;
		     var eventbeeamt;
		     var amount = (tktcnt * tktprice * (pf / 100)) + (tktcnt * fixedfee);
		    
		     if (tktprice == 0) 
			 {
		         eventbeeamt = 0;
		         if (domain1 == 'eventbrite1' || domain1 == 'ticketleap1') 
		            amount = 0;
			 }
			      else
		         	eventbeeamt = tktcnt * 1;


		     if (fixedfee == '' && pf == '') 
		         savedamt = 0.00;
		      else 
		         savedamt = amount - eventbeeamt;
		     
		     document.getElementById('savedamount').innerHTML = '<font>' + addCommas(savedamt.toFixed(0)) + '</font>';
		 }
		 function f()
		 {$('#close3').prop(s0.setValue(10));
			 }

		 function addCommas(nStr)
		   {
			  
		       nStr += '';
		       x = nStr.split('.');
		       x1 = x[0];
		       x2 = x.length > 1 ? '.' + x[1] : '';
		       var rgx = /(\d+)(\d{3})/;
		       while (rgx.test(x1)) {
		           x1 = x1.replace(rgx, '$1' + ',' + '$2');
		       }
		       return x1 + x2;
		   }
				 
	 		$('#pf , #ff').keypress(function(evt){  
       	     if(isNumberKey(evt))
           	 {						
           	  	  setTimeout(function()
   	            {            		  
           		  fixedfee=document.getElementById("pf").value;
                  pf=document.getElementById("ff").value;            	
                  
           		  saveamount(ticketPrice,ticketQuantity);},10);
       	     }
       	     return isNumberKey(evt);
          });
         

          function isNumberKey(evt)
         {
             
       	  var charCode = (evt.which) ? evt.which : evt.keyCode;
             if (charCode != 46 && charCode>31  && (charCode<48 || charCode>57))
                return false;

            return true;

          
             }



$(document).ready(function() {
	
	$('#view-savings').click(function() {
		
		domain1='eventbrite1';

				$('#eventSites li').removeClass('active-site');
			    $('#eventbrite1').addClass('active-site');
		
		
	 if(	domain1=='eventbrite1')
		{ 
					$('.calc-b-a').css('pointer-events','visible');
					s0.setValue(100);
			      	s1.setValue(1000);
		}
	 if(domain1=='ticketleap1')
	{
			$('.calc-b-a').css('pointer-events','visible');
			s0.setValue(100);
		  	s1.setValue(1000);
	}
	if(domain1=='custom1')
	{
		
		   	 $('.calc-b-a').css('pointer-events','visible');
			fixedfee=document.getElementById("ff").value;                  
			pf=document.getElementById("pf").value;
				
	        s0.setValue(100);
			s1.setValue(1000);	
	}
	

		$('#view-savings').css( 'cursor', 'pointer' );
        $('#view-savings-cont').slideToggle(1000);
		$(this).text( $(this).text() == '<%=getPropValue("hide_savings", lang)%>' ? '<%=getPropValue("view_savings", lang)%>' : '<%=getPropValue("hide_savings", lang)%>');
        $('#view-savings-cont1').slideToggle(1000);
	});
});     
		  
</script>
<noscript><img height="1" width="1" alt="" style="display:none" src="https://www.facebook.com/tr?ev=6019644693365&amp;cd[value]=0.00&amp;cd[currency]=USD&amp;noscript=1" /></noscript>
	</body>	
</html>