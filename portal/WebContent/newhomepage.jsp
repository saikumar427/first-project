<%@include file="getresourcespath.jsp" %>
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
<link type="text/css" rel="stylesheet" href="<%=resourceaddress%>/main/css/bootstrap/style-min.css" />
<link type="text/css" rel="stylesheet" href="/main/font-awesome-4.0.3/css/font-awesome.min.css" />
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
<script src="<%=resourceaddress%>/main/js/bootstrap.min.js"></script>
<script src="<%=resourceaddress%>/main/js/jquery.inview.min.js"></script>
<script>
function searcheventname(){
var str=document.getElementById('searchcontent').value;
str=str.replace(/^\s+|\s+$/g,'');
if(str.length<=3){
document.getElementById('searchevtbtn').setAttribute('disabled','disabled');
return;
}else{
document.getElementById('searchevtbtn').removeAttribute('disabled');
document.getElementById('searchcontent').value=str;
document.searchevent.submit();
}
}
</script>
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
<li><a href="/main/pricing">Pricing</a></li>
<li><a href="/main/event-creation">Features</a></li>
<li><a href="/main/faq">FAQ</a></li>
<li><a href="javascript:;" id="contact">Contact</a></li></ul>
<ul class="nav navbar-nav navbar-right">
<li><a href="javascript:;" id="getTickets">Get My Tickets</a></li>
<li id="sinbtn"><a href="/main/user/login">Login</a></li>  
<li id="supbtn"><a href="/main/user/signup"><button class="btn btn-primary">Sign Up</button></a></li> </ul>
</div></div></div><br><br>
<div class="row-fluid">
<a href="/main/user/signup">  <img src="<%=resourceaddress%>/main/images/award.jpg" width="100%" alt="SBIEC Award Winning Event Ticketing Platform" border="0"> </a></div>
<div class="container" style="background-color:#F3F6FA;width:100%;padding:60px 0 80px 0px;">
<div class="container" id="fevents">
<div class="row">
<div class="col-md-6">
<h1><span class="text-muted">Featured Events</span></h1></div>
<div class="col-md-6"><br>
<form name="searchevent" id="searchform" action="/main/search" method="post" class="searchform">
<div class="input-group">
<input type="text" class="form-control" name="searchcontent" id="searchcontent" placeholder="Enter event name or venue...">
<span class="input-group-btn">
<button class="btn btn-primary" type="button" id="searchevtbtn" onclick="searcheventname();">Search</button>
</span></div>
</form></div></div>
<h2 style="margin-top:0"><small>Check out current events using Eventbee!</small></h2><hr>
<div id="featuredevents"></div></div></div>
<div class="row-fluid" id="pricingimg">
<a href="/main/user/signup"><img src="<%=resourceaddress%>/main/images/pricing.jpg" width="100%" alt="No percentage fee, one simple flat rate fee" border="0"></a></div>
<div class="container" style="background-color:#F3F6FA;width:100%;padding:60px 0px 90px 0px;">
<div class="container" id="socialpromotions"><div class="row">
<div class="col-md-12">
<h1><span class="text-muted">Social Promotions</span></h1>
<h2 style="margin-top:0"><small>Increase ticket sales with our patented* attendee social promotions technology!</small></h2><hr>




<%@include file="home/getfbpromotions.jsp" %>
<!--
<iframe src="home/getfbpromotions.jsp"width="1200" height="430" frameborder="0" style="border: 0px;overflow: hidden;" ></iframe>
<div id="fbpromotions"></div>-->
<br/>
<span style="font-size:0.8em">* Patent number 8712859</span></div>
</div></div></div>
<div class="row-fluid" id="fundsimg">
<a href="/main/user/signup"><img src="<%=resourceaddress%>/main/images/funds.jpg" width="100%" border="0" alt="Credit card processing in over 130 currencies"/></a></div>
<div class="container" style="background-color:#F3F6FA;width:100%;padding:60px 0px 80px 0px;">
<div class="container">
<div class="row">
<div class="col-md-12">
<h1><span class="text-muted">Facebook Ticketing App</span></h1>
<h2 style="margin-top:0"><small>Sell tickets directly from your Facebook fan page!</small></h2><hr><br>
<div class="col-md-2"></div>
<div class="col-md-4" id="fbappimg">
<img src="<%=resourceaddress%>/main/images/fbapp.png" width="100%" alt="Eventbee Ticketing Application for Facebook"></div>
<div class="col-md-4"><br><br><br><br>
<a href="http://apps.facebook.com/eventbeeticketing" class="btn btn-lg btn-primary" target="_blank">Install Facebook Ticketing App</a>
</div></div></div></div></div>
<div class="container" style="background-color:#A4A4A4;width: 100%;">
<div class="container"><br>
<div class="row">
<div class="col-sm-6 col-md-3">
<img width="100%" src="<%=resourceaddress%>/main/images/home/thewashingtonpost.png" alt="Eventbee On Washington Post"><br><br>
<p><a href="http://www.washingtonpost.com/wp-dyn/content/article/2008/07/09/AR2008070900032.html" target="_blank" style="color:#000000">  "EventBee, introduces a flat $1 fee for all tickets sold. The move may well prove to disrupt this space - most competitors traditionally charge a small percentage of the ticket price rather than a flat fee." �</a></p></div>
<div class="col-sm-6 col-md-3">
<img width="100%" src="<%=resourceaddress%>/main/images/home/techcrunch.png" alt="Eventbee On Techcrunch"><br><br>
<p><a href="http://techcrunch.com/2007/08/24/eventbee-adsense-for-events-has-busy-plans/" target="-blank" style="color:#000000">"Their online event promotion tools include a nifty service called Event Network Listing that can only be described as AdSense for events." �</a></p></div>
<div class="col-sm-6 col-md-3">
<img width="100%" src="<%=resourceaddress%>/main/images/home/insidefacebook.png" alt="Eventbee On Inside Facebook"><br><br>
<p><a href="http://www.insidefacebook.com/2009/01/22/eventbee-integrates-with-facebook-connect-and-introduces-social-ticket-selling/" target="_blank" style="color:#000000" >"Eventbee is perfect solution for your social media event marketing needs." �</a></p></div>
<div class="col-sm-6 col-md-3">
<img width="100%" src="<%=resourceaddress%>/main/images/home/mashable.png" alt="Eventbee On Mashable"><br><br>
<p><a href="http://mashable.com/2009/07/21/facebook-connect-new/" target="_blank" style="color:#000000">"10 Impressive New Implementations of Facebook Connect - "Eventbee solves Facebook ticket sales problem using Facebook Connect in a very clever way." �</a></p>
</div></div></div></div>
<!-- full width container footer -->
<div class="container" style="background-color:#474747;width: 100%;">
<div class="container footer">
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
<span class="footertab"><a href="/main/event-creation">Creation - Event Ticketing Types, Donations, Registration Form</a></span><br/>
<span class="footertab"><a href="/main/event-customization">Customization - Themes, Look & Feel, Venue Seating</a></span><br/>
<span class="footertab"><a href="/main/event-integration">Integration - Event Page Links, Buttons, Widgets</a></span><br/>
<span class="footertab"><a href="/main/event-promotion">Promotion - Facebook, Twitter, Email Invites</a></span><br/>
<span class="footertab"><a href="/main/event-manage">Manage - iPhone Check-In, Scan, Reports</a></span>
<span class="footertabheader"><h4><strong>More Solutions</strong></h4></span>
<span class="footertab"><a href="http://www.volumebee.com">Volumebee - Get one to many with Volumebee!</a></span> <br/>
<span class="footertab"><a style="text-decoration:none">Eventbee Attendee Check-In App</a></span><br>
<a href="https://itunes.apple.com/us/app/eventbee-real-time-attendee/id403069848?mt=8">   <img src="<%=resourceaddress%>/main/images/home/iphone.png" width="150" alt="Eventbee Attendee Check-In App"/></a></div>
<div class="col-md-3">
<span class="footertabheader"><h4><strong>How To</strong></h4></span>
<span class="footertab"><strong><a href="/main/free-event-registration">Free Online Event Registration</a></strong></span><br/>
<span class="footertab"><strong><a href="/main/free-event-rsvp">Free Online Event Ticketing & RSVP</a></strong></span><br/>
<span class="footertab"><strong><a href="/main/sell-tickets-online">Sell Tickets Online</a></strong></span><br/>
<span class="footertab"><strong><a href="/main/custom-registration-form">Custom Online Registration Form</a></strong></span><br/>
<span class="footertab"><strong><a href="/main/private-ticketing">Private Ticketing</a></strong></span><br>
<span class="footertab"><strong><a href="/main/social-event-promotion">Social Event Promotion</a></strong></span><br>
<span class="footertab"><strong><a href="/main/venue-seating">Venue Seating</a></strong></span><br>
<span class="footertab"><strong><a href="http://nye.eventbee.com/city/san-francisco-nye">New Years Eve Party Tickets</a></strong></span>
<span class="footertabheader"><h4><strong>Programs</strong></h4></span>
<span class="footertab"><a href="/main/good">25% non-profit discount program</a></span><br/>
<span class="footertab"><a href="/main/referral-program">15% customer referral program</a></span><br/>
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
</div></div></div></div></div>
<hr style="margin:0;background-color:#606060;height: 1px; border-top:1px solid #282828;">
<div class="container" style="background-color:#474747;width: 100%;">
<div class="container footer" >
<div class="row" style="margin: 0 auto;padding-top:15px;">
<div class="row"><center>
<span style="font-size:12px;color:#ccc">
Copyright 2003-2014. Eventbee Inc. All Rights Reserved.
</span></center>
<span class="footerlinks" style="font-size:0.7em"><center>
<a href="/main/privacystatement"> Privacy Statement</a> | <a href="/main/termsofservice">Terms Of Service</a>
</center></span>
<center>
<span style="font-size:12px;color:#ccc">Trusted by 30,000+ Event Managers all over the world for their Online Registration, Event Ticketing and Event Promotion needs!</span></center>
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

<script>
function closediv(){
$('#myModal').modal('hide');
}
$(function(){
var raddress='<%=resourceaddress%>';
var j=0;
$('#searchcontent').keyup(function(){
var sc=$('#searchcontent').val();
sc=sc.replace(/^(?:\s)*/g,'').replace(/(?:\s)*$/g,'');
if(sc.length<=3)
$('#searchevtbtn').attr('disabled','disabled');
else
$('#searchevtbtn').removeAttr('disabled');			
});

$( "#searchform" ).submit(function(){
	var sc=$('#searchcontent').val();
	sc=sc.replace(/^(?:\s)*/g,'').replace(/(?:\s)*$/g,'');
	if(sc.length<=3){
	$('#searchevtbtn').attr('disabled','disabled');
	return false;
	}else{
	$('#searchevtbtn').removeAttr('disabled');
	return true;
	}	
});

$('#fevents').bind('inview', function (event, visible) {
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
var pdata="<div class=\"row\">";
for(var k=0;k<json.fpromotions.length;k++){
     if(k%2==0)pdata=pdata+"<div class=\"col-md-6 col-sm-6\">";
	 pdata=pdata+"<div class=\"media\"><a class=\"pull-left\" href="+json.fpromotions[k].purl+" target=\"_blank\"><img class=\"media-object\" src="+json.fpromotions[k].pimg+" alt=\""+json.fpromotions[k].n+"\" title="+json.fpromotions[k].n+"/></a><div class=\"media-body\"><a href="+json.fpromotions[k].purl+" target=\"_blank\"><a href="+json.fpromotions[k].purl+" target=\"_blank\">"+json.fpromotions[k].n+"</a>  promoted <a href=\"/event?eid="+json.fpromotions[k].eid+"\" target=\"_blank\">"+json.fpromotions[k].en+"</a> on "+json.fpromotions[k].dy+"&nbsp;"+json.fpromotions[k].src+"</div></div>";
     if(k%2==0) pdata=pdata+"<br>";
	 else pdata=pdata+"<br><br></div>";
}
pdata=pdata+"</div>";
if($('#featuredevents'))
$('#featuredevents').html(data);
$('#fevents').unbind();
if($('#fbpromotions'))
$('#fbpromotions').html(pdata);
} 
$('#contact').click(function() {
$('.modal-title').html('Contact Eventbee');
$('#myModal').on('show.bs.modal', function () {
$('iframe#popup').attr("src",'/main/user/homepagesupportemail.jsp');
$('iframe#popup').css("height","440px"); 
});
$('#myModal').modal('show');
});
$('#getTickets').click(function() {
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
$('#myModal').on('hide.bs.modal', function () {
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
});
</script></body>
</html>