<%@include file="getresourcespath.jsp" %>
<%@include file="common.jsp" %>

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
<title>Online Registration - Event Ticketing, Venue Seating with Eventbee</title>
<meta name="Description" content="Easy to use online Event Management solution that includes Online Registration, Event Ticketing, Event Promotion and Membership Management" />
<meta name="Keywords" content="events, sell tickets, online registration, event ticketing, social ticketing, event promotion, paypal payments, google check out, facebook events, ning events, party tickets, sports tickets, venue seating"/>
<link rel="canonical" href="http://www.eventbee.com" />
<link rel="icon" href="<%=resourceaddress%>/main/images/favicon.ico" type="image/x-icon" />
<link rel="shortcut icon" href="<%=resourceaddress%>/main/images/favicon.ico" type="image/x-icon" />
<link type="text/css" rel="stylesheet" href="/main/css/bootstrap/bootstrap.min.css" />
<link type="text/css" rel="stylesheet" href="/main/css/select2.css" />
<link type="text/css" rel="stylesheet" href="<%=resourceaddress%>/main/css/bootstrap/style-min.css" />
<link type="text/css" rel="stylesheet" href="/main/font-awesome-4.0.3/css/font-awesome.min.css" />
<script src="<%=resourceaddress%>/main/js/jquery-1.11.2.min.js"></script>
<script src="<%=resourceaddress%>/main/js/jquery.inview.min.js"></script>
<script src="<%=resourceaddress%>/main/user/login?lang=<%=lang%>"></script>


<script>
/*function searcheventname(){
var str=document.getElementById('searchcontent').value;*/
/* str=str.replace(/^\s+|\s+$/g,'');
if(str.length<=3){
document.getElementById('searchevtbtn').setAttribute('disabled','disabled');
return;
}else{
document.getElementById('searchevtbtn').removeAttribute('disabled'); */
/*document.getElementById('searchcontent').value=str;
document.searchevent.submit();
localStorage.setItem("result_label", str);
//}
}*/

</script>

<style>
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
	color: #999999;
}


.main_header_orange{
	font-size: 42px;
	font-weight:800;
	text-align: center;
	color: #F27D2F;
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
    width: 315px;
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


</style>

</head>
<!--[if lt IE 9]>
<script src="<%=resourceaddress%>/main/js/html5shiv.js"></script>
<script src="<%=resourceaddress%>/main/js/respond.min.js"></script>
<![endif]-->
<body>
<!-- responsive navbar
===============================-->
<div class="navbar navbar-default navbar-fixed-top" style="background:#f3f6fa">
<div class="container">
<div class="navbar-header">
<button class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
<span class="icon-bar"></span>
<span class="icon-bar"></span>
<span class="icon-bar"></span>
</button><br/>
<a href="/" class="navbar-brand" style="margin-top:-6px;margin-bottom:-16px"><img src="<%=resourceaddress%>/main/images/logo.png" alt="Eventbee" height="50" /></a></div>
<div class="navbar-collapse collapse">
<ul class="nav navbar-nav">
<li><a href="/main/pricing">Pricing and features</a></li>
<li><a href="/main/how-it-works">How it works</a></li>
<!--<li><a href="/main/event-creation">Features</a></li>-->
<li><a href="/main/faq">FAQ</a></li>
<li><a href="javascript:;" id="contact">Contact</a></li></ul>
<ul class="nav navbar-nav navbar-right">
             <li style="display:none">	
				  <div id="i18nLang" style="display:none;width:330px;position: absolute;top: 16px; right: 2px;  background-color: white;   padding: 20px 30px 20px 20px;   border: 1px solid #EEE;">
				     <div> 
				       <div style="float:left;padding-right:20px;border-right: 1px solid #EEE;">
				         <span class="sub-text">Countries</span>
				         <ul style="padding:0px" id="countries" class="sm-font">
				          
				         </ul>				       
				       </div>
				        <div style="float:left;padding-left:20px">
				         <span class="sub-text">Languages</span>
					         <ul style="padding:0px;font-size:12px" class="sm-font" id="languages">
					           
					         </ul>					        
				        </div>   
				        <div style="clear:both"></div>
				      </div>    
			       </div>		
				   <a href="javascript:;" id="i18nLangToggle" ><span style="margin-right:3px"><i class="fa fa-globe" style="color:#5388c4"></i></span><i class="fa fa-sort-down" style="font-size:14px !important;position: relative;top: -4px;"></i></a>
				  </li>
<li><a href="javascript:;" id="getTickets">Get my tickets</a></li>
<li id="sinbtn"><a href="/main/user/login">Login</a></li>  
<li id="supbtn"><a href="/main/user/signup"><button class="btn btn-primary">Sign Up</button></a></li> </ul>
</div></div></div><br><br>
<div class="row-fluid">
<a href="/main/user/signup">  <img src="<%=resourceaddress%>/main/images/award.jpg" width="100%" alt="SBIEC Award Winning Event Ticketing Platform" border="0"> </a></div>


<!-- featured events start -->
<div class="container" style="background-color:#F3F6FA;width:100%;padding:60px 0 10px 0px;">
<div class="container" id="fevents">
<div class="row">
<div class="col-md-6"><h1><span class="text-muted">FEATURED EVENTS</span></h1></div>
<div class="col-md-6"><br>
<form name="searchevent" id="searchform" action="/main/search" method="post" class="searchform">
<div class="input-group">
<input type="text" class="form-control" name="searchcontent" id="searchcontent" placeholder="Enter event name or venue...">
<span class="input-group-btn">
<!-- <button class="btn btn-primary" type="button" id="searchevtbtn" onclick="searcheventname();">Find Events</button> -->
<button class="btn btn-primary" type="submit" id="searchevtbtn" >Find Events</button>
</span></div>
</form></div></div>
<div class="medium_desc_grey" style="text-align:left !important;padding-bottom:50px">Check out current events using Eventbee!</div>
<div id="featuredevents"></div></div></div>
<!-- featured events end -->


<!--<div class="row-fluid" id="pricingimg">
<a href="/main/user/signup"><img src="<%=resourceaddress%>/main/images/pricing.jpg" width="100%" alt="No percentage fee, one simple flat rate fee" border="0"></a></div>-->


<div id="parentDiv">
<!---- save big --->

<div class="row-fluid toggle-header" id="pricingimg">
<a href="javascript:;"><img src="<%=resourceaddress%>/main/images/pricing.jpg" width="100%"  id="" alt="No percentage fee, one simple flat rate fee" border="0" ></a></div>
<div id="slidedownimg" style="height:30px;display:none"><img src="<%=resourceaddress%>/main/images/pricing.jpg" width="100%" style="position: absolute;z-index: -1;"/></div>

<!---- save big --->
<div id="calculator" style="background-color:#fff;position: relative;z-index: -1;height:438px;" >


<%-- <%@include file="/home/temppromo.jsp" %> --%>
<script>

function resizePriceIframe(){
var obj=document.getElementById('priceIframe');
 obj.style.height = obj.contentWindow.document.body.offsetHeight + 'px';
 }
</script>
<iframe width="100%" src="pricinghome.jsp" id='priceIframe' style="border: none;"> </iframe>






</div>
<!-- end of calculator -->
</div><!-- end of parentDiv -->



<!-- facebook ticketing app start -->
<div class="container" style="background-color:#F3F6FA;width:100%;padding:60px 0px 80px 0px;">
<div class="container">
<div class="row">
<div class="col-md-12"><h1><span class="text-muted">FACEBOOK TICKETING APP</span></h1></div>
</div>
<div class="row">
<div class="col-md-12 medium_desc_grey" style="padding-bottom:50px">Sell tickets directly from your Facebook fan page!</div>
</div>
<div class="row">
<div class="col-md-2"></div>
<div class="col-md-4" id="fbappimg">
<img src="<%=resourceaddress%>/main/images/fbapp.png" width="100%" alt="Eventbee Ticketing Application for Facebook">
</div>
<div class="col-md-4"><br><br><br><br>
<a href="http://apps.facebook.com/eventbeeticketing" class="btn btn-lg btn-primary" target="_blank">Install Facebook Ticketing App</a>
</div>
</div>
</div>
</div>

<!-- facebook ticketing app end -->

<div class="row-fluid" id="fundsimg">
<a href="/main/user/signup"><img src="<%=resourceaddress%>/main/images/funds.jpg" width="100%" border="0" alt="Credit card processing in over 130 currencies"/></a></div>

<!-- social promotions start -->
<div class="container" style="background-color:#F3F6FA;width:100%;padding:60px 0px 72px 0px;">
<div class="container" id="socialpromotions">
<div class="row">
<div class="row">
<div class="col-md-12"><h1><span class="text-muted">SOCIAL PROMOTIONS</span></h1></div>
</div>
<div class="row">
<div class="col-md-12 medium_desc_grey" style="padding-bottom:50px">Increase ticket sales with our patented attendee social promotions technology!</div>
</div>
<div class="row">
<%@include file="/home/getfbpromotions.jsp" %>
</div>
<div class="row">
<div class="col-md-12"><span style="font-size:0.8em">* Patent number 8712859</span></div>
</div>
<!--<div class="col-md-12">
<h1><span class="text-muted">SOCIAL SHARING</span></h1>
<h2 style="margin-top:0"><small>Increase ticket sales with our patented attendee social sharing technology!</small></h2>
<br>


<span style="font-size:0.8em"></span></div> -->
</div>
</div>
</div>
<!-- social promotions end -->



<!-- eventbee manager app start -->
<%-- <div class="container" style="background-color:#EEEEEE;width:100%;padding:60px 0 80px 0px;">
<div class="container">
<div class="row">
<div class="col-md-12" style="text-align:center !important;"><h1><span class="text-muted">EVENTBEE MANAGER APP</span></h1></div>
</div>
<br><br>
<div class="row">

<div class="col-md-6" align="center">
<img class="img-responsive" src="<%=resourceaddress%>/main/images/Honey_Comb_button_85blue2.png" width="280px" height="233px"/>

<div style="text-align:left !important">
<br>
	<ul class="col-md-10 col-md-offset-3">
		<li style="color:#999999;"><span style="color:#999999;font-size: 20px;">Easy attendee search</span></li>
		<li style="color:#999999;"><span style="color:#999999;font-size: 20px;">QR code and barcode scanning</span></li>
		<li style="color:#999999;"><span style="color:#999999;font-size: 20px;">Offline check-in</span></li>
	</ul>
</div>
</div>
<div class="col-md-6" align="center">
<img class="img-responsive" src="<%=resourceaddress%>/main/images/Honey_Comb_button_85blue.png" width="280px" height="233px"/>

<div style="text-align:left !important">
<br>
	<ul class="col-md-10 col-md-offset-3">
		<li style="color:#999999;"><span style="color:#999999;font-size: 20px;">Process credit cards</span></li>
		<li style="color:#999999;"><span style="color:#999999;font-size: 20px;">Cash or check payments</span></li>
		<li style="color:#999999;"><span style="color:#999999;font-size: 20px;">Sub-manager support</span></li>
	</ul>
</div>
</div>
</div>

</div><br>
<div class="container">
<div class="row">
	<div class="" align="center">
	<ul style="list-type:none;">
		<li style="display:inline-block !important;">
			<a href="https://play.google.com/store/apps/details?id=com.eventbee.eventbeemanager" style="margin-right:5px" target="_blank">
				<img  width="150" src="/main/images/googleplayicon.png">
			</a>
		</li>
		<li style="display:inline-block !important;">
			<a target="_blank" href="http://www.amazon.com/Eventbee-Manager/dp/B00O8L7V5Y/ref=sr_1_1?s=mobile-apps&amp;ie=UTF8&amp;qid=1412689478&amp;sr=1-1&amp;keywords=eventbee">
				<img width="150" style="margin-right:0px" src="/main/images/amazonappstore.png">
			</a>
		</li>
	</ul>
	</div>   
 </div>
 </div>
</div>
 --%>
<!-- eventbee manager app end -->

<!-- kindle fire section start -->
<div class="container" style="padding: 0; width: 100%; background-image: url('/main/bootstrap/images/EB_bee_pattern_1600x250.jpg');">
			<div class="container" align="center">
			 <a href="/main/eventbee-ticketing-kindle-promotion">
			 				<img class="img-responsive" border="0" align="middle" src="/main/bootstrap/images/kindle_giveaway2.jpg" alt="Kindle Gateway">
			 </a>
			</div>
</div>
<!-- kindle fire section end -->





<div class="container" style="background-color:#A4A4A4;width: 100%;">
<div class="container"><br>
<div class="row">
<div class="col-sm-6 col-md-3">
<img width="100%" src="<%=resourceaddress%>/main/images/home/thewashingtonpost.png" alt="Eventbee On Washington Post"><br><br>
<p><a href="http://www.washingtonpost.com/wp-dyn/content/article/2008/07/09/AR2008070900032.html" target="_blank" style="color:#000000">  "EventBee, introduces a flat $1 fee for all tickets sold. The move may well prove to disrupt this space - most competitors traditionally charge a small percentage of the ticket price rather than a flat fee." &#187;</a></p></div>
<div class="col-sm-6 col-md-3">
<img width="100%" src="<%=resourceaddress%>/main/images/home/techcrunch.png" alt="Eventbee On Techcrunch"><br><br>
<p><a href="http://techcrunch.com/2007/08/24/eventbee-adsense-for-events-has-busy-plans/" target="_blank" style="color:#000000">"Their online event promotion tools include a nifty service called Event Network Listing that can only be described as AdSense for events." &#187;</a></p></div>
<div class="col-sm-6 col-md-3">
<img width="100%" src="<%=resourceaddress%>/main/images/home/insidefacebook.png" alt="Eventbee On Inside Facebook"><br><br>
<p><a href="http://www.insidefacebook.com/2009/01/22/eventbee-integrates-with-facebook-connect-and-introduces-social-ticket-selling/" target="_blank" style="color:#000000" >"Eventbee is perfect solution for your social media event marketing needs." &#187;</a></p></div>
<div class="col-sm-6 col-md-3">
<img width="100%" src="<%=resourceaddress%>/main/images/home/mashable.png" alt="Eventbee On Mashable"><br><br>
<p><a href="http://mashable.com/2009/07/21/facebook-connect-new/" target="_blank" style="color:#000000">"10 Impressive New Implementations of Facebook Connect - "Eventbee solves Facebook ticket sales problem using Facebook Connect in a very clever way." &#187;</a></p>
</div></div></div></div>
<!-- full width container footer -->
<div class="container" style="background-color:#474747;width: 100%;">
<div class="container footer">
<div class="row" style="margin: 0 auto; padding-bottom: 0px;">
     <div class="col-md-2">&nbsp; </div>
		 <div class="col-md-4"> &nbsp;</div>
			  <div class="col-md-3">&nbsp; </div>
				   <div class="col-md-3">
				   <span style="display:none;">
					 <%if(lang.equals("en-us")){%>
					   <a style="position:relative;top:470px;left: 8px;"><select name="" style="width:200px;height:36px !important;line-height:35px !important;margin-top:10px !important;padding: 0px !important;" id="states" onchange="languageClick(value)"> 
		   				<option value="es-co" <%if(lang.equals("es-co")){%>selected='selected' class="select-active"<%} %>>Colombia - Spanish</option>
		   				<option value="es-mx" <%if(lang.equals("es-mx")){%>selected='selected' class="select-active"<%} %>>Mexico - Spanish</option>     
		    			<option value="en-us" <%if(lang.equals("en-us")){%>selected='selected' class="select-active"<%} %>>United States - English</option>             
					 </select>      
				 </a> 
           	<%} %>
           	</span>
       </div>
</div>

<div class="row" style="margin: 0 auto;padding-bottom:10px;">
<div class="row"><br>
<div class="col-md-2">
<span class="footertabheader"><h4><strong>Eventbee</strong></h4></span>
<span class="footertab"><a href="/main/aboutus">About Us</a></span> <br/>
<span class="footertab"><a href="/main/contact">Contact Us</a> </span> <br/>
<span class="footertab"><a href="/main/compare">Compare Us</a> </span> <br/>
<span class="footertab"><a href="/main/faq">FAQ</a></span> 
<h4><strong>Connect</strong></h4>
<p class="footertab">
<a href="https://www.facebook.com/eventbeeinc" target="_blank">
<i style="padding-right:20px" class="fa fa-fw fa-2x fa-facebook"></i> Facebook<br></a>
<a href="https://twitter.com/eventbee" target="_blank">
<i style="padding-right:20px" class="fa fa-fw fa-2x fa-twitter"></i> Twitter<br></a>
<a href="http://blog.eventbee.com/" target="_blank">
<i style="padding-right:20px" class="fa fa-fw fa-2x fa-rss-square"></i> Blog<br></a>
<a href="http://www.youtube.com/user/eventbee/videos" target="_blank">
<i style="padding-right:20px" class="fa fa-fw fa-2x fa-youtube-square"></i> Videos<br></a></p></div>
<div class="col-md-4">
<span class="footertabheader"><h4><strong>Online Registration & Event Ticketing</strong></h4></span>
<span class="footertab"><a href="/main/how-it-works">Event Creation - Event Ticketing Types, Donations, Registration Form, Credit Card Processing, Venue Seating</a></span><br/>
<span class="footertab"><a href="/main/how-it-works">Event Promotion - Event Page Links, Buttons, Widgets, Social Media Sharing, Facebook Ticketing App</a></span><br/>
<span class="footertab"><a href="/main/how-it-works">Event Manage - Sell Tickets, Check In Attendees, Sub Managers, Reports</a></span>
<span class="footertabheader"><h4><strong>Event Credit Card Processing</strong></h4></span>
<span class="footertab"><a href="/main/sell-event-tickets-with-paypal-stripe-braintree-authorize-net">PayPal, Stripe, Braintree, Authorize.net, Eventbee</a></span><br/>
<span class="footertabheader"><h4><strong>At The Door Apps</strong></h4></span>
<span class="footertab"><a href="/main/eventbee-manager-app">Eventbee Manager App for Android</a></span><br>
<a href="https://play.google.com/store/apps/details?id=com.eventbee.eventbeemanager" target="_blank">
<img src="/main/images/googleplayicon.png" width="150"/>
</a>
<br>
<a href="http://www.amazon.com/Eventbee-Manager/dp/B00O8L7V5Y/ref=sr_1_1?s=mobile-apps&ie=UTF8&qid=1412689478&sr=1-1&keywords=eventbee" target="_blank">
<img src="/main/images/amazonappstore.png" width="150" style="margin-top:7px"/>
</a>
<br>
<span class="footertab"><a style="text-decoration:none">Eventbee Attendee Check-In App for iOS</a></span><br>
<a href="https://itunes.apple.com/us/app/eventbee-real-time-attendee/id403069848?mt=8" target="_blank"><img src="<%=resourceaddress%>/main/images/home/iphone.png" width="150" alt="Eventbee Attendee Check-In App"/></a>
</div>
<div class="col-md-3">
<span class="footertabheader"><h4><strong>How To</strong></h4></span>
<span class="footertab"><strong><a href="/main/venue-reserved-seating">Venue Reserved Seating</a></strong></span><br/>
<span class="footertab"><strong><a href="/main/sell-tickets-on-facebook">Sell Tickets On Facebook</a></strong></span><br/>

<span class="footertab"><strong><a href="/main/custom-online-registration-form">Custom Online Registration Form</a></strong></span><br/>
<span class="footertab"><strong><a href="/main/social-media-event-marketing">Social Media Event Marketing</a></strong></span><br/>
<span class="footertab"><strong><a href="/main/attendee-event-management-at-the-door">Attendee & Event Management</a></strong></span><br/>
<span class="footertab"><strong><a href="/main/free-online-event-registration-software">Free Online Registration</a></strong></span><br/>
<span class="footertab"><strong><a href="/main/free-event-ticketing-software">Free Event Ticketing</a></strong></span><br/>

<span class="footertabheader"><h4><strong>Programs</strong></h4></span>
<span class="footertab"><a href="/main/good">25% Nonprofit Discount</a></span><br/>
<span class="footertab"><a href="/main/eventbee-ticketing-kindle-promotion">Free Kindle Fire</a></span><br>
<span class="footertabheader"><h4><strong>More Solutions</strong></h4></span>
<span class="footertab"><a href="http://apps.facebook.com/eventbeeticketing" target="_blank">Facebook Ticketing - Sell Tickets From Facebook Fan Page</a></span><br/>
<span class="footertab"><a href="http://www.volumebee.com" target="_blank">Volumebee - Crowd Selling Platform For Tickets & More</a></span><br/>
</div>
<div class="col-md-3">
<span class="footertabheader"><h4><strong>Use Cases</strong></h4></span>
<span class="footertab"><a href="/main/conference-registration">Conference Registration</a></span><br/>
<span class="footertab"><a href="/main/seminar-class-registration">Seminars & Classes Registration</a></span><br/>
<span class="footertab"><a href="/main/non-profit-ticketing-fundraising">Non Profit Ticketing & Fundraising</a></span><br/>
<span class="footertab"><a href="/main/festivals-fairs-ticketing">Festivals & Fairs Ticketing</a></span><br/>
<span class="footertab"><a href="/main/schools-student-events">Schools & Student Events</a></span><br/>
<span class="footertab"><a href="/main/sports-activity-ticketing">Sports & Activity Ticketing</a></span><br/>
<span class="footertab"><a href="/main/theater-box-office-ticketing">Venue Seating & Box Office</a></span><br/>
<span class="footertab"><a href="/main/clubs-party-ticketing">Clubs & Party Ticketing</a></span><br/>
<span class="footertab"><a href="/main/music-concert-ticketing">Music & Concert Ticketing</a></span><br/>
<span class="footertab"><a href="/main/halloween-party-ticketing">Halloween Party Ticketing</a></span><br/>
<span class="footertab"><a href="/main/new-years-eve-party-ticketing">New Years Eve Party Ticketing</a></span>
<span class="footertabheader"><h4>
									<strong>Case Studies</strong>
								</h4></span> <span class="footertab"><a
								href="/main/eventbee-customer-case-study-bishop-kelly-high-school">Bishop
									Kelly High School</a></span><br /> <span class="footertab"><a
								href="/main/eventbee-customer-case-study-demolay-international">DeMolay
									International</a></span><br />
</div></div></div></div></div>
<hr style="margin:0;background-color:#606060;height: 1px; border-top:1px solid #282828;">
<div class="container" style="background-color:#474747;width: 100%;">
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
<div class="container footer" >
<div class="row" style="margin: 0 auto;padding-top:15px;">
<div class="row"><center>
<span style="font-size:12px;color:#ccc">
Copyright 2003-2016. Eventbee Inc. All Rights Reserved.
</span></center>
<span class="footerlinks" style="font-size:0.7em"><center>
<a href="/main/privacystatement"> Privacy Statement</a> | <a href="/main/termsofservice">Terms Of Service</a>
</center></span>
<center>
<span style="font-size:12px;color:#ccc">Trusted by 40,000+ Event Managers all over the world for their Online Registration, Event Ticketing and Event Promotion needs!</span></center>
</div><br/>
</div></div></div>
<!-- modal dialog
===========================-->	        
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
</div></div>


<script src="<%=resourceaddress%>/main/js/bootstrap.min.js"></script>

<script src="/main/js/select2.js"></script>
<script>
        $(document).ready(function() {
            $("#states").select2();   
        });
</script>
<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-60215903-1', 'auto');
  ga('send', 'pageview');

</script>


<script src="/main/js/select2.js"></script>
	 <script>
        $(document).ready(function() {
            $("#states").select2();   
        });
    </script>
<script>



 var executingModule = "slideup";
function closediv(){
$('#myModal').modal('hide');
}

$(function(){
var raddress='<%=resourceaddress%>';
var j=0;
$(document).on('keyup','#searchcontent',function(){
//$('#searchcontent').keyup(function(){
var sc=$('#searchcontent').val();
sc=sc.replace(/^(?:\s)*/g,'').replace(/(?:\s)*$/g,'');
/* if(sc.length<=3)
$('#searchevtbtn').attr('disabled','disabled');
else
$('#searchevtbtn').removeAttr('disabled');	 */		
});


$( "#searchform" ).submit(function(){
	var sc=$('#searchcontent').val();
	sc=sc.replace(/^(?:\s)*/g,'').replace(/(?:\s)*$/g,'');
	if(sc.length<=2){
		alert('Please Enter atleast 3 characters to search');
	//$('#searchevtbtn').attr('disabled','disabled');
	return false;
	}else{
	//$('#searchevtbtn').removeAttr('disabled');
	return true;
	}	
});


$(document).one('inview','#fevents', function (event, visible) {

if (visible){
++j;
if(j==1){
$.ajax({
url: "/main/home/newgetevents.jsp?type=event&timestamp="+(new Date()).getTime(),
}).done(showFeaturedEvents);
}
}
});

$('#pricingimg').bind('inview', function (event, visible) {
if (visible){
$("#pricingimg a").children('img').attr('src',raddress+'/main/images/pricing.jpg');
$('#pricingimg').unbind();
}});
$('#fundsimg').bind('inview', function (event, visible) {
if (visible){
$("#fundsimg a").children('img').attr('src',raddress+'/main/images/funds.jpg');
$('#fundsimg').unbind();
}});
function showFeaturedEvents(response){
var data="<div class=\"row\">";
var json=eval('('+response+')');
for(var i=0;i<json.fevents.length;i++){
       if(i%2==0)data=data+"<div class=\"col-md-6 col-sm-6\">";
       data=data+"<div class=\"media\"><a class=\"pull-left\" href="+json.fevents[i].link+" target=\"_blank\"><img class=\"media-object\" src="+json.fevents[i].logo+" alt=\""+json.fevents[i].en+"\" width=\"90px\" height=\"90px\"/></a><div class=\"media-body\"><h4 class=\"media-heading\"><a target=\"_blank\" href="+json.fevents[i].link+">"+json.fevents[i].en+"</a></h4><p>"+json.fevents[i].dt+"<br>"+json.fevents[i].adrs+"</p></div></div>";
	   if(i%2==0) data=data+"<br>";
	   else data=data+"<br><br></div>";
}
data=data+"</div>";
if($('#featuredevents'))
$('#featuredevents').html(data);
//$('#fevents').unbind();
try{
$( ".joiner" ).remove();	
run('Right');
}catch(err){
	
}
} 
$(document).on('click','#contact',function() {
$('.modal-title').html('Contact Eventbee');
$('#myModal').on('show.bs.modal', function () {

$('iframe#popup').attr("src",'/main/user/homepagesupportemail.jsp');
$('iframe#popup').css("height","440px"); 
});
$('#myModal').modal('show');
});
$(document).on('click','#getTickets',function() {
$('.modal-title').html('Get My Tickets');
$('#myModal').on('show.bs.modal', function () {

$('iframe#popup').attr("src",'/main/user/homepagemytickets.jsp');
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
    $('#sinbtn').html('<a href="/main/user/login">Login</a>');
	$('#supbtn').html('<a href="/main/user/signup"><button class="btn btn-primary">Sign Up</button></a>');
   }else{
    $('#sinbtn').html('<a href="/main/myevents/home">My Account</a>');
	$('#supbtn').html('<a href="/main/user/logout"><button class="btn btn-primary">Logout</button></a>');
   }
}
$.ajax({
url: "/main/getUserToken.jsp",
}).done(showButtons);


var calculatorHeight=$("#calculator").height();
var height=$("#pricingimg").height();
 $("#calculator").css("display",'none');

 $(document).on('click','#pricingimg',function(){
	if(executingModule=='slidedown')return;	
			 executingModule = "slideup";
			 $("#calculator").css("display",'block');
			 $("#slidedownimg").css("display",'block');
			  $("#calculator").css("position",'relative');
			   $("#pricingimg").css("position",'absolute');
			   
		   	$( "#pricingimg").slideUp(1500, function() {
         	 
			 $("#calculator").css("z-index","1");
			    $("#calculator").css("position",'relative');
			    $("#pricingimg").css("position",'absolute');
				executingModule="";				
				// $("#pricingimg").css("display",'block');
        	});
			
}); 

 $(document).on('click','#slidedownimg',function(){
     
	slidedownFunc();
	 });
	 
	 
	 

});


function slidedownFunc(){
executingModule = "slidedown";
	 $("#calculator").css("z-index","-1");
	 
	$('#pricingimg').slideDown(1500,function(){
			  $("#pricingimg").css("position",'relative');
		        $("#calculator").css("display",'none');
				$("#slidedownimg").css("display",'none');
				executingModule="";
	});
}
      $('#avgticketsprice').height( $('#ticketssold').height());
         $('#currentticket').height($('#ticketssold').height());     
        

</script>
<!-- Facebook Conversion Code for fb-homepage -->
<script>(function() {
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
<noscript><img height="1" width="1" alt="" style="display:none" src="https://www.facebook.com/tr?ev=6019644693365&amp;cd[value]=0.00&amp;cd[currency]=USD&amp;noscript=1" /></noscript>

</body>
</html>
