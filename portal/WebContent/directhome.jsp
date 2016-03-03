<%
  String sddress="http://images.eventbee.com";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head profile="http://gmpg.org/xfn/11">
<meta name="verify-v1" content="/2obWcBcvVqISVfmAFOvfTgJIfdxFfmMOe+TE8pbDJg=" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<META Http-Equiv="Cache-Control" Content="no-cache">
<META Http-Equiv="Pragma" Content="no-cache">
<META Http-Equiv="Expires" Content="0">

<title>Online Registration - Event Ticketing, Venue Seating with Eventbee</title>

<meta name="Description" content="Easy to use online Event Management solution that includes Online Registration, Event Ticketing, Event Promotion and Membership Management" />

<meta name="Keywords" content="events, sell tickets, online registration, event ticketing, social ticketing, event promotion, paypal payments, google check out, facebook events, ning events, party tickets, sports tickets, venue seating"/>

<link rel="canonical" href="http://www.eventbee.com" />
<link rel="icon" href="<%=sddress%>/main/images/favicon.ico" type="image/x-icon" />
<link rel="shortcut icon" href="<%=sddress%>/main/images/favicon.ico" type="image/x-icon" />

<link rel="stylesheet" type="text/css" href="<%=sddress%>/main/css/newhomepage.css" />
<link rel="stylesheet" type="text/css" href="<%=sddress%>/main/build/fonts/fonts-min.css" />
<link rel="stylesheet" type="text/css" href="<%=sddress%>/main/build/button/assets/skins/sam/button.css" />
<link rel="stylesheet" type="text/css" href="<%=sddress%>/main/build/container/assets/skins/sam/container.css" />

<script type="text/javascript" src="<%=sddress%>/main/build/yahoo-dom-event/yahoo-dom-event.js"></script>
<script type="text/javascript" src="<%=sddress%>/main/build/connection/connection-min.js"></script>
<script type="text/javascript" src="<%=sddress%>/main/build/dragdrop/dragdrop-min.js"></script>
<script type="text/javascript" src="<%=sddress%>/main/build/container/container-min.js"></script>

<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js"></script>
<script type="text/javascript" src="<%=sddress%>/home/js/customfonts/cufon-yui.js"></script>
<script src="<%=sddress%>/home/js/customfonts/Myriad_Pro_400.font.js" type="text/javascript"></script>
<script type="text/javascript">
Cufon.replace('.roundedboxheader h2,.featuredeventsheader h2,.newfeaturesheader h2,.hanging_panel_content,.logo h1');</script>


<link rel="stylesheet" type="text/css" href="<%=sddress%>/main/css/yuioverrides.css" />

<script type="text/javascript" src="<%=sddress%>/main/js/common/nifty.js"></script>
<script type="text/javascript" src="<%=sddress%>/main/js/common/common.js"></script>
<script type="text/javascript" src="<%=sddress%>/main/js/homepagenifty.js"></script>
<script type="text/javascript" src="<%=sddress%>/main/js/prototype.js"></script>
<script language="javascript" src="<%=sddress%>/main/js/popup.js">
function popupdummy(){}
</script>
<script type="text/javascript">
window.onload=function(){
if(!NiftyCheck())
return;
Rounded("div#hangingpanel1", "#e5e5e5");
Rounded("div#hangingpanel2", "#e5e5e5");
Rounded("div#hangingpanel3", "#e5e5e5");
}
</script>
<script type="text/javascript">
var openpopupclick=false;
function openPopUp(url,width,height,classname){
openpopupclick=true;
var dynatimestamp = new Date().getTime();
url=url+"?dyntimestamp="+dynatimestamp;
if($(classname)){
 }
else{
var cell=$('header');
var div=document.createElement("div");
div.setAttribute('id',classname);
div.className=classname;
cell.appendChild(div);
}
var layout="<a href='javascript:closepopuplayout();'><img src='<%=sddress%>/home/images/close.png' class='imgclose' alt='popup close' /></a><iframe width='"+width+"' height='"+height+"' src='"+url+"' id='"+dynatimestamp+"' frameborder='0' allowfullscreen />";
document.getElementById(classname).innerHTML=layout;
document.getElementById(classname).style.display='block';
if(classname=='layoutwidget'){
document.getElementById(classname).style.top='10%';
document.getElementById(classname).style.left='26%';
}else if(classname=='layoutwidget2'){
document.getElementById(classname).style.top='10%';
document.getElementById(classname).style.left='40%';
}
if(document.getElementById("backgroundPopup"))
document.getElementById("backgroundPopup").style.display='block';



}

function closepopuplayout(){
openpopupclick=false;
	if(document.getElementById("backgroundPopup")){
		document.getElementById("backgroundPopup").style.display='none';
	}
	if($('layoutwidget2')){
		$('layoutwidget2').style.display='none';
		$('layoutwidget2').innerHTML='';
	}
    if($('layoutwidget')){
		$('layoutwidget').style.display='none';
		$('layoutwidget').innerHTML='';
	}
}
</script>
<script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-27223160-1']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

</script>
<style>
.playbutton
{
	position:absolute;
	top:0;
	left:0; 
	width:485px;
	height:267px; 
}
.signuplinkinfirstimage
{
	position:absolute;
	top:140px;
	right:125px; 
	width:200px;
	height:50px;   
}
#mainbanner {
margin-top:-20px;
}

#slider1prev{
    position: absolute;
    top:120px;
    left: -88px;
}
#slider1next{
    position: absolute;
    top:120px;
    right:-88px;
}
#sliderprevimg,#slidernextimg{
opacity:0.3;
width:80px;
}
</style>
		
</head>
<body class="yui-skin-sam">

<!-- Start Main Site -->

<!-- Start Header -->
<div id='backgroundPopup'></div>

<div id="header_top">
<div style="position:relative;width:989px;margin:0 auto;">
<!--<div style="position: absolute; top: -1px;z-index:9999;left:230px;margin:0px;padding:0px;">
<a href="/main/eventbee-10-year-anniversary-promotion"><img src="/main/images/home/medallion.png" alt="Eventbee 10 year Anniversary Promotion" border="0" /></a>
</div>-->
</div>
<!-- Start Top Header -->
 <table width="989px" cellpadding="0" cellspacing="0" align="center">
  <tr>
  <td align="right">
  <span class="header_top_content" style="padding-right: 10px;"><a style="background-image: url(http://www.volumebee.com/images/favicon.ico);background-repeat: no-repeat;padding-left: 19px;height:28px;display:inline-block;" href="http://volumebee.com">Volumebee </a> </span>
  <span class="header_top_content" style="padding-right: 10px;"><a style="background-image: url(<%=sddress%>/main/images/icon_small_twitter.png);background-repeat: no-repeat;padding-left: 19px;height:28px;display:inline-block;" href="http://twitter.com/eventbee">Twitter </a> </span>
  <span class="header_top_content" style="padding-right: 30px;"><a style="background-image: url(<%=sddress%>/main/images/icon_small_facebook.png);background-repeat: no-repeat;padding-left: 19px;display:inline-block;height:28px;" href="http://facebook.com/eventbeeinc">Facebook </a></span>
  <span class="header_top_content" style="padding-right: 15px;"><a style="background-image: url(<%=sddress%>/main/images/home/email.png);background-repeat: no-repeat;padding-left: 20px;height:20px;display:inline-block;" href="#"  onClick="openPopUp('/main/user/supportemail.jsp','350','330','layoutwidget2')">Contact </a> </span>
   <span class="header_top_content" style="padding-right: 15px;"><a style="background-image: url(<%=sddress%>/main/images/home/faq.png);background-repeat: no-repeat;padding-left: 20px;height:20px;display:inline-block;" href="/main/faq">FAQ </a> </span>
  <span class="header_top_content"><a style="background-image: url(<%=sddress%>/main/images/home/tickets.png);background-repeat: no-repeat;padding-left: 20px;display:inline-block;height:20px;" href="#" onClick="openPopUp('/main/user/mytickets.jsp','550','430','layoutwidget')">Tickets </a></span>
  </td>
  </tr>
  </table>
<!-- End Top Header -->
</div>
<div id="header">



<table width="989px" align="center" valign="top" cellspacing="0" cellpadding="0"><tr>
<td align="left">
<!-- Start Logo -->
<div class="logo"><a href="/" >
<img src="<%=sddress%>/home/images/logo_big.jpg" style="border-style: none" alt="Eventbee" />
<br/><h1><b>Sell More Tickets With Less Effort!</b></h1></a>
</div>
<!-- End Logo -->
</td>
<td align="right" valign="bottom">

<span class="header_links">
<a href="/main/pricing"> <!-- <img src="images/home/pricing-grey.png" border="0" alt="$1 Flat Fee Pricing" /> --> $1 Flat Fee Pricing</a>

<a href="/main/features"><!-- <img src="images/home/features-grey.png" border="0" alt="Hundreds Of Features" /> -->  Hundreds Of Features</a>
</span>
 <span>
 <% 
if(session.getAttribute("SESSION_USER")==null){
%>
<a href="/main/user/signup" style="text-decoration:none;" onmouseout="javascript:this.className='signuporloginbutton';" onmouseover="javascript:this.className='signuporloginbuttonhover';" class="signuporloginbutton">
Sign Up
</a>
<a href="/main/user/login" style="text-decoration:none;" onmouseout="javascript:this.className='signuporloginbutton';" onmouseover="javascript:this.className='signuporloginbuttonhover';" class="signuporloginbutton">
Login
</a>
<%
}else{
%>
<a href="/main/myevents/home" STYLE="text-decoration: none" onmouseout="javascript:this.className='signuporloginbutton';" onmouseover="javascript:this.className='signuporloginbuttonhover';" class="signuporloginbutton">
My Home</a>
<a href="/main/user/logout" STYLE="text-decoration: none" onmouseout="javascript:this.className='signuporloginbutton';" onmouseover="javascript:this.className='signuporloginbuttonhover';" class="signuporloginbutton">
Logout</a>
<%
}
%>
 </span>
</td>

</tr></table>

</div>
<!-- End Header -->
<div id="container">
<!-- Start Banner -->
<div style="width:989px;margin: 0 auto;position:relative;">
<span id="slider1prev"><a href="#" style="cursor: pointer;border:none;" onmouseover="shoWPrevNext('prev');" onmouseout="hidePrevNext('prev');"><img src="<%=sddress%>/main/images/home/arrow-left75.png"  id="sliderprevimg" onclick="tempmove('prev');"/></a></span>
<span id="slider1next"><a href="#" style="cursor: pointer;border:none;" onmouseover="shoWPrevNext('next');" onmouseout="hidePrevNext('next');"><img src="<%=sddress%>/main/images/home/arrow-right75.png" id="slidernextimg" onclick="tempmove('next');"/></a></span>
<table  border="0" width="100%" cellspacing="0" cellpadding="0" align="center">
<tr>
<td align="center">
<table border="0" cellspacing="0" cellpadding="0" width="100%" align="center">
<tr>
	<td align="center">
		<div id="flash">

			<map name="planetmap">
            <area alt="Sign Up" coords="0,0,980,363" href="/main/user/signup" shape="rect" />
			
	     <!-- <area alt="Video" coords="291,141,408,169" href="javascript:openPopUp('http://www.youtube.com/embed/EI1_xDgGvb0','550','430','layoutwidget')" shape="rect" />

			<area alt="Tickets" coords="291,170,408,196" href="/main/features" shape="rect" /> -->


			</map>
            
			
			<script type="text/javascript">
			jQuery("#video").attr("style","cursor:pointer;");
			jQuery("#video").click(function(){
				openPopUp('http://www.youtube.com/embed/EI1_xDgGvb0','550','430','layoutwidget')
			});
			
			jQuery("#features").attr("style","cursor:pointer;");
			jQuery("#features").click(function(){
				window.location.href="/main/features";
			});
			</script>

			<script type="text/javascript">
			     <!--
				//preload images
				
				var image1=new Image()
				image1.src="<%=sddress%>/main/images/home/banner_award.jpg"
				image1.alt="SBIEC Award Winning Event Ticketing Platform"
				
				
					var image2=new Image()
				image2.src="<%=sddress%>/main/images/home/banner_pricing.jpg"
				image2.alt="No percentage fee, one simple flat rate fee"
				
				
				var image3=new Image()
			     image3.src="<%=sddress%>/main/images/home/banner_funds.jpg";
			     image3.alt="Credit card processing in over 130 currencies";
				
				var image4=new Image()
				image4.src="<%=sddress%>/main/images/home/banner_fbapp.jpg"
				image4.alt="Eventbee Ticketing Application for Facebook"
				
				
				/* var image2=new Image()
				image2.src="/main/images/home/banner_ipadboxoffice.gif"
				image2.alt="Venue Ticketing - Eventbee iPad Box Office"
				
				var image3=new Image()
				image3.src="/main/images/home/banner_eb5launch.gif"
				image3.alt="Eventbee 5 - Venue Seating, iPhone Attendee Check-In" */
				
				
				
				var image5=new Image()
				image5.src="<%=sddress%>/main/images/home/banner_features.jpg"
				image5.alt="Eventbee Features - Customization, Widgets"
				
				/* var image4=new Image()
				image4.src="/main/images/home/banner_social.jpg"
				image4.alt="Event Promotion - Facebook, Twitter" */
				
				var image6=new Image()
				image6.src="<%=sddress%>/main/images/home/banner_nts.jpg"
				image6.alt="Eventbee Network Ticket Selling"
				
				/*var image6=new Image()
				image6.src="/main/images/home/banner_established.jpg"
				image6.alt="Tickets Sold In Million$"
				*/
                             -->
				
			</script>
			
			<iframe width="0" height="0" frameborder="0" allowfullscreen="" id="youtubeiframe" src="" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>
				<div  id="mainbanner"><img src="<%=sddress%>/main/images/home/banner_award.jpg"  alt="SBIEC Award Winning Event Ticketing Platform" name="slide" border="0" width="989px" usemap="#planetmap" onmouseover="javascript:stopslide();" onmouseout="javascript:startslide();" />
				<span class="playbutton" id="playbutton" style="display:none"></span><span id="signuplinkinfirstimage" class="signuplinkinfirstimage"  style="display:none" onclick="location.href='/main/user/signup'"  ></span>
				</div>
				
				<script>
			 
			jQuery("#mainbanner").attr("style","cursor:pointer");
			jQuery("#mainbanner").click(function(){
				showDetails();
			});
			  </script>
			<script type="text/javascript">
				<!--
				var step=1
				var whichimage=1
				var mouseoverimage=0;
				var slideshow=true;
				var videostarted = false;
				function imgmouseover(index){
					mouseoverimage=index;
				}
				function imgmouseout(){
					mouseoverimage=0;
					highlight();
				}
				function startslide()
				{   
					if(videostarted == false)
					{
						slideshow = true; 
					}
				} 
				function stopslide()
				{ 
					slideshow=false;
				}
				function highlight()
				{
					for(i=1;i<=6;i++)
				{
					if(i==mouseoverimage) continue;
					elm=document.getElementById('s'+i);
					if(elm)
					{
						elm.className="tdstyle";
					}

				}
				elm=document.getElementById('s'+whichimage);
				if(elm)
					{
						elm.className="tdstyle1";
					}
				}
				
				function showDetails() {
				 if(whichimage==1 && !openpopupclick)
				 {
					//window.location.href='http://eventbee.wordpress.com/2011/11/03/introducing-eventbee-network-ticket-selling/';
				}
				 else{
				 //window.location.href='#';
				 }
				}
				
			    
				function slideit(){
				setTimeout("slideit()",7500);
				if(!slideshow) return;
				if(videostarted) return;
				if (!document.images) return;
				
				/********** Added on Jan 9th ********************/
				
				if(step == 1)
				{ 
					/* document.getElementById('signuplinkinfirstimage').style.display="block";   
					document.getElementById('flash').style.position="relative";   
					if(document.getElementById('youtubeiframe').src == location.href)
					{
						document.getElementById("playbutton").style.display = "block";
					}
					jQuery("#playbutton").click(function () 
					{ 
						document.getElementById("playbutton").style.display = "none";
						document.getElementById('youtubeiframe').src="http://player.vimeo.com/video/37996261?title=0&byline=0&portrait=0&autoplay=1";
						document.getElementById('youtubeiframe').style.height="269px";
						document.getElementById('youtubeiframe').style.width="480px";
						document.getElementById('youtubeiframe').style.position="absolute";
						document.getElementById('youtubeiframe').style.top="27px";
						document.getElementById('youtubeiframe').style.right="0px";  
						
						var imgPosX = jQuery("#flash").width() - jQuery("#youtubeiframe").width();    
						jQuery("#youtubeiframe").css({"left": "11px"}); 
						videostarted = true;
					}); */
						
				}
				else
				{   
					document.getElementById('signuplinkinfirstimage').style.display="none";
					document.getElementById('flash').style.position="";  
					document.getElementById("playbutton").style.display = "none"; 
					document.getElementById('youtubeiframe').src="";
					document.getElementById('youtubeiframe').style.height="";
					document.getElementById('youtubeiframe').style.width="";
					document.getElementById('youtubeiframe').style.position="";
					document.getElementById('youtubeiframe').style.top="";
					document.getElementById('youtubeiframe').style.right="";  
					jQuery("#youtubeiframe").css({"left":"0"}); 
				}
				
				/***********************************************************/
								
				document.images.slide.src=eval("image"+step+".src")
				document.images.slide.alt=eval("image"+step+".alt")
				whichimage=step
				highlight();
				if (step<6)
				step++
				else
				step=1;


				}
				slideit()
				function slidelink(index){
				videostarted = false;
				slideshow = true; 
				whichimage=index;
				/********** Added on Jan 9th ********************/
				if(index == 1)
				{ 
						/* document.getElementById('signuplinkinfirstimage').style.display="block";
						document.getElementById('flash').style.position="relative";  
						document.getElementById("playbutton").style.display = "block";
						document.getElementById("playbutton").style.top = "0";
						document.getElementById("playbutton").style.left = "0"; 
						jQuery("#playbutton").click(function () 
						{  
							document.getElementById("playbutton").style.display = "none";
							//document.getElementById('youtubeiframe').src="http://www.youtube.com/embed/ya7GSOA3WuU?autoplay=1&loop=1";
							document.getElementById('youtubeiframe').src="http://player.vimeo.com/video/37996261?title=0&byline=0&portrait=0&autoplay=1";
							document.getElementById('youtubeiframe').style.height="269px";
							document.getElementById('youtubeiframe').style.width="480px";
							document.getElementById('youtubeiframe').style.position="absolute";
							document.getElementById('youtubeiframe').style.top="27px";
							document.getElementById('youtubeiframe').style.right="0px";  
							
							var imgPosX = jQuery("#flash").width() - jQuery("#youtubeiframe").width();    
							jQuery("#youtubeiframe").css({"left": "11px"}); 
							videostarted = true;
						});  */
					
				}
				else
				{    
					document.getElementById('signuplinkinfirstimage').style.display="none";
					document.getElementById('flash').style.position="";  
					document.getElementById("playbutton").style.display = "none"; 
					document.getElementById('youtubeiframe').src="";
					document.getElementById('youtubeiframe').style.height="";
					document.getElementById('youtubeiframe').style.width="";
					document.getElementById('youtubeiframe').style.position="";
					document.getElementById('youtubeiframe').style.top="";
					document.getElementById('youtubeiframe').style.right="";  
					jQuery("#youtubeiframe").css({"left":"0"}); 
				}
				/********** Added on Jan 9th ********************/
				step=index;
				
				document.images.slide.src=eval("image"+step+".src")
				document.images.slide.alt=eval("image"+step+".alt")
				highlight();
			}
			 function getLatestEvent(){
				new Ajax.Request('/main/home/getlatestevent.jsp?timestamp='+(new Date()).getTime(), {
				method: 'post',
				onSuccess:geteventdetails

				});
				var reg_timeout=setTimeout('getLatestEvent()',60000);
			}
			function geteventdetails(response){
				var data=response.responseText;
				var responsejson=eval('('+data+')');
				if($('windowlink')){
					$('windowlink').innerHTML=responsejson.label+" <a href="+responsejson.link+">"+responsejson.name+"</a>";

				}

			} 
			
			function getFBPromotions(){
				new Ajax.Request('/main/home/fbeventpromotions.jsp?timestamp='+(new Date()).getTime(), {
				method: 'post',
				onSuccess:showFBPromotions

				});
				
			}
			
			function showFBPromotions(response){
				
				if($('rectbox')){
					$('rectbox').innerHTML=response.responseText;

				}

			} 
			
			

		//-->
		
		function shoWPrevNext(purpose){
			if(purpose=='next'){
			 jQuery('#sliderprevimg').fadeTo(1000, 0.3);
			 jQuery('#slidernextimg').fadeTo(1000, 1.0); 
			}else{
				jQuery('#sliderprevimg').fadeTo(1000,1.0);
				jQuery('#slidernextimg').fadeTo(1000,0.3); 
			}
		}
		
		function hidePrevNext(purpose){
				jQuery('#sliderprevimg').fadeTo(1000,0.3);
			 	jQuery('#slidernextimg').fadeTo(1000,0.3);
			}
		
		function tempmove(direction){
			if(direction=='prev')
				--step;
				else
				++step;
              if(step<1)step=6;
			  if(step>6)step=1;
              slidelink(step);	
		}
		
			</script>
			
		</div>
	</td>
</tr>
</table>
</td>
</tr>
<tr>
<td>
<table border="0" cellspacing="0" cellpadding="0" width="100%" align="center">
<tr>
	<td align="center">
<div class="divstyle" style="width:989px;">
	<table width="989px" border="0" align="center">
		<tr>
			 <td width="82%" align="left">
			 <span id='windowlink'></span>
			 <script>getLatestEvent()</script>  
			</td> 
			<td align="right">
				<table width="100%" cellspacing="5" cellpadding="5">
					<tr>
						<td class="tdstyle" id="s1" width="5%" height="10px" onmouseover="javascript:imgmouseover(1);this.className='tdstyle1'" onmouseout="javascript:imgmouseout();" onclick="javascript:slidelink(1)"></td>
						<td class="tdstyle" id="s2" width="5%" height="10px" onmouseover="javascript:imgmouseover(2);this.className='tdstyle1'" onmouseout="javascript:imgmouseout();" onclick="javascript:slidelink(2)"></td>
						<td class="tdstyle" id="s3" width="5%" height="10px" onmouseover="javascript:imgmouseover(3);this.className='tdstyle1'" onmouseout="javascript:imgmouseout();" onclick="javascript:slidelink(3)"></td>
						<td class="tdstyle" id="s4" width="5%" height="10px" onmouseover="javascript:imgmouseover(4);this.className='tdstyle1'" onmouseout="javascript:imgmouseout();" onclick="javascript:slidelink(4)"></td>
						 <td class="tdstyle" id="s5" width="5%" height="10px" onmouseover="javascript:imgmouseover(5);this.className='tdstyle1'" onmouseout="javascript:imgmouseout();" onclick="javascript:slidelink(5)"></td>
						 <td class="tdstyle" id="s6" width="5%" height="10px" onmouseover="javascript:imgmouseover(6);this.className='tdstyle1'" onmouseout="javascript:imgmouseout();" onclick="javascript:slidelink(6)"></td> 
					</tr>
				</table>
			</td>
		</tr>
	</table>
       </div>
    </td>
</tr>
</table>
</td>

</tr>
</table>
<script>
slidelink(1);
</script>

<!-- End Banner -->

<!-- Start promoted events -->
<div id="rectbox" style="margin-top:0px;">


</div>
<script>
getFBPromotions();
</script>

<br/>
<!-- End promoted events -->

<!-- Start  Featured Events & Testimonials  Rectbox content -->
<div id="rectbox" style="margin-top:0px;">

<table width="100%" cellspacing="10" cellpadding="10"><tr>
<!-- Start Left td -->
<td valign="top">

<!-- Start Featured Events -->
<div id="featuredeventsbox">
<div id="eventcontent" class="leftboxcontent"> 
<table width="100%" class="content2d" valign="top" cellpadding="0" height="200">
<tr><td valign="top" class="featuredeventsheader">
<table width="100%" cellpadding="5" cellspacing="0" align="left">
<tr><td align="left">
<form name="searchevent" action="/main/search" method="post" class="searchform">
<button class="icon-search" onclick="searchcontent2();" type="button"></button>
<label>
		<span class="visuallyhidden">Enter Event Name or Venue</span>
		<input type="text" placeholder="Enter event name or venue!" value="" name="searchcontent" id="searchcontent" size="100">
	</label>

</form>
<!--<hr class="hrline" align="left"/>
--></td></tr></table>
 </td></tr>
<tr><td id='featuredevents'>

</td></tr>

<tr>
<td  align='right' colspan="2" valign="bottom">
&raquo;&nbsp;<a href="/main/myevents/createevent"><font color="#fea045"> List Your Event</font></a>&nbsp;&nbsp;&nbsp;
</td></tr>
</table>
</div>
</div>
<script>
function getFeaturedEvents(){
				new Ajax.Request('/main/home/getevents.jsp?type=event&timestamp='+(new Date()).getTime(), {
				method: 'post',
				onSuccess:showFeaturedEvents

				});
				
			}
			
			function showFeaturedEvents(response){
				
				if($('featuredevents')){
					$('featuredevents').innerHTML=response.responseText;

				}

			} 
getFeaturedEvents();
</script>
<!-- End Featured Events -->

</td>
<!-- End Left td -->

<!-- Start Right td -->
<td valign="middle" align="center" width="280" align="right">

<!-- Start Customer Testimonials -->
<div id="hangingpanel1" class="roundedbox" align="center">
<div class="niftyboxcontent" class="content2d">
<table width="100%"  valign="top" cellpadding="0" cellspacing="0" height="150">
<tr><td id="testimonials">
 <link rel="stylesheet" type="text/css" href="<%=sddress%>/main/build/fonts/fonts.css">
<link type="text/css" rel="stylesheet" href="<%=sddress%>/main/build/carousel/assets/skins/sam/carousel.css">

<script src="<%=sddress%>/main/build/utilities/utilities.js"></script>
<script src="<%=sddress%>/main/js/YUI/carousel-min.js"></script>
<link rel="stylesheet" type="text/css" href="<%=sddress%>/main/css/YUI/yui.css">
<link rel="stylesheet" type="text/css" href="<%=sddress%>/main/css/YUI/yuioverwrite.css">
<div id="testimonialcontainer">
<ol id="carousel">
<li class="item"><iframe width="290" height="280" frameborder="0" allowfullscreen="" src="http://www.youtube.com/embed/EI1_xDgGvb0"></iframe></li>
<li class="item">
<img width="290" height="280" border="0" src="<%=sddress%>/main/images/home/customers.jpg"/></li>
<li class="item"><img width="290" height="280" border="0" src="<%=sddress%>/main/images/home/1.jpg"/></li>
<li class="item"><img width="290" height="280" border="0" src="<%=sddress%>/main/images/home/2.jpg"/></li>
<li class="item"><img width="290" height="280" border="0" src="<%=sddress%>/main/images/home/3.jpg"/></li>
<li class="item"><img width="290" height="280" border="0" src="<%=sddress%>/main/images/home/4.jpg"/></li>
<li class="item"><img width="290" height="280" border="0" src="<%=sddress%>/main/images/home/5.jpg"/></li>
<li class="item"><img width="290" height="280" border="0" src="<%=sddress%>/main/images/home/6.jpg"/></li>
<li class="item"><img width="290" height="280" border="0" src="<%=sddress%>/main/images/home/7.jpg"/></li>
<li class="item"><img width="290" height="280" border="0" src="<%=sddress%>/main/images/home/8.jpg"/></li>
<li class="item"><img width="290" height="280" border="0" src="<%=sddress%>/main/images/home/9.jpg"/></li>
<li class="item"><img width="290" height="280" border="0" src="<%=sddress%>/main/images/home/10.jpg"/></li>
<li class="item"><img width="290" height="280" border="0" src="<%=sddress%>/main/images/home/11.jpg"/></li>

</ol>
</div>
<script>
    (function () {
        var carousel;

        YAHOO.util.Event.onDOMReady(function (ev) {
            var carousel    = new YAHOO.widget.Carousel("testimonialcontainer", {
                        animation: { speed: 0.5 },
                        isVertical:false,
                        numVisible:1,
                        selectOnScroll:false

                });

            carousel.CONFIG.MAX_PAGER_BUTTONS=13;
            carousel.render(); // get ready for rendering the widget
            carousel.show();   // display the widget
            carousel.startAutoPlay();
        });
    })();
</script>

</td></tr>
</table>
</div>
</div>
<script>
function getTestiMonials(){
				new Ajax.Request('/main/home/testimonials.jsp?type=event&timestamp='+(new Date()).getTime(), {
				method: 'post',
				onSuccess:showTestiMonials

				});
				
			}
			
			function showTestiMonials(response){
				
				if($('testimonials')){
					$('testimonials').innerHTML=response.responseText;
					

				}

			} 
//getTestiMonials();
</script>
<!-- End Customer Testimonials -->
</td>
<!-- End Right td -->
</tr></table>

</div>
<!-- End Featured Events & Testimonials Rectbox content -->

<!-- Start New Features & Twitter Rectbox content -->
<div id="rectbox">
<table width="100%" cellpadding="10px" cellspacing="10px"><tr>
<td valign="top">

<!-- Start New Features -->
<div>
<table align="left" valign="top" width="100%" cellpadding="0" cellspacing="5">
<tr><td>

<table align="left" valign="top" width="100%" cellpadding="0" cellspacing="0">
<tr>
<td valign="top" width="229px" align="center"><span class="newfeaturesheader"><h2>Credit Card Processing </h2>
<hr class="hrline"/></span>
</td>

<td width="10"></td>

<td valign="top" width="229px" align="center"><span class="newfeaturesheader"><h2>SBIEC Excellence Award</h2>
<hr class="hrline"/></span>
</td>

<td width="10"></td>

<td valign="top" width="229px" align="center"><span class="newfeaturesheader"><h2>Giveback</h2>
<hr class="hrline"/></span>
</td>

<td width="10"></td>

<td valign="top" width="229px" align="center"><span class="newfeaturesheader"><h2>Facebook Ticketing App</h2>
<hr class="hrline"/></span>
</td>

</tr>
</table>
</td></tr>
<!-- 
<tr><td width="100%"><hr class="hrline" /></td></tr>
-->     
<tr><td>

<table align="left" valign="top" width="100%" cellpadding="0" cellspacing="0">
<tr>
<td valign="top" width="229px" align="center">
<a href="http://blog.eventbee.com/2013/07/17/eventbee-announces-support-for-authorize-net-stripe-and-braintree-payments/"><img src="<%=sddress%>/main/images/home/payment-methods.jpg" border="0" alt="Credit Card Processing"><br/>Immediate Access To Your Ticket Sale Proceeds</a>

</td>

<td width="10"></td>
<script type="text/javascript">
function searchcontent2(){
var str=document.getElementById('searchcontent').value;
str=str.replace(/^\s+|\s+$/g,'');
if(str.length<=2){
alert("Please Enter atleast 3 characters to search");
}else{
document.getElementById('searchcontent').value=str;
document.searchevent.submit();
//window.location.reload();
}
}

function savingsPopUp() {
 openPopUp('/portal/helplinks/mysavings.jsp','550','430','layoutwidget');
 document.getElementById('layoutpopup').style.top='95%';
 document.getElementById('layoutpopup').style.left='26%';
window.scrollTo(450,480);
return false;
}
</script>
<td valign="top" width="229px" align="center">
<a href="http://blog.eventbee.com/2013/09/17/eventbee-receives-prestigioous-california-excellence-award-from-small-business-institute-for-excellence-in-commerce/" return false;"><img src="<%=sddress%>/main/images/home/sbiecaward.png" border="0" alt="SBIEC Excellence Award"><br/>Best Among All Its Competitors In Event Management Software</a>
</td>

<td width="10"></td>

<td valign="top" width="229px" align="center">
<a href="/main/good"><img src="<%=sddress%>/main/images/home/giveback.png"  border="0" alt="Nonprofit & School Events discount"><br/>Service Fee Discount To Non-Profit Events</a>
</td>

<td width="10"></td>

<td valign="top" width="229px" align="center">
<a href="http://blog.eventbee.com/2013/04/23/introducing-eventbee-ticketing-app-for-facebook-fan-page/"><img src="<%=sddress%>/main/images/home/fbappbadge.png" border="0" alt="Facebook Ticketing Application"><br/>Sell Tickets From Your Facebook Fan Page</a>
</td>

</tr></table>
</td></tr></table>
</div>
<!-- End New Featues -->
</td>
</tr>

<tr>
<td cellpadding="0" cellspacing="0" valign="top">

<table cellpadding="0"  cellspacing="0" width="100%" valign="top">
<tr>
<td cellpadding="0" cellspacing="0" valign="top">
<!--
<div id="hangingpanel2" class="roundedbox">
<div class="niftyboxcontent" class="content2d">
<table width="100%" class="content2" cellpadding="0" cellspacing="0">
<tr><td height="5"></td></tr>

 <tr><td align="center" class="newfeaturesheader" width="100%"><h2 style="font-size: 17px">Eventbee Real Time Attendee Check-In App</h2></td></tr>
<tr><td height="5"></td></tr>
<tr><td width="100%" align="center">
  <table align="center"><tr>
  <td><a href="http://itunes.apple.com/us/app/eventbee-real-time-attendee/id403069848?mt=8"><img src="/main/images/home/iphone.png" border="0"></a></td> 
  <td><a href="https://market.android.com/details?id=com.eventbee.mobile"><img src="/main/images/home/android_as.png" border="0"></a></td>
  </tr>
  </table>
</td></tr>

</table>
</div>
</div>
 -->
</td>

</tr></table>

</td>
</tr>

</table>

</div>
<!-- End New Features & Twitter Rectbox content -->
</div>
<!-- End Main Site -->

<!-- Start Press Quotes -->
<div id="pressquotes" align="center" style="margin-top:-9px">

</div>
<script>
function getPressQoutes(){
				new Ajax.Request('/main/home/pressquotes.jsp?timestamp='+(new Date()).getTime(), {
				method: 'post',
				onSuccess:showPressQoutes

				});
				
			}
			
			function showPressQoutes(response){
				
				if($('pressquotes')){
					$('pressquotes').innerHTML=response.responseText;

				}

			} 
getPressQoutes();
</script>
<!-- End Press Quotes -->
</div>
<!-- Start Footer -->
<div  id="footer">



</div>
<script>
function getFooter(){
				new Ajax.Request('/main/layout/footer.jsp?timestamp='+(new Date()).getTime(), {
				method: 'post',
				onSuccess:showFooter

				});
				
			}
			
			function showFooter(response){
				
				if($('footer')){
					$('footer').innerHTML=response.responseText;

				}

			} 
getFooter();
</script>
<!-- End Footer -->

<div id="iframepopupdialog"><div id="hd"></div><div id="bd"></div></div>

<script type="text/javascript">Cufon.now();</script>

<%
if(request.getParameter("intro")!=null){
%>
<script type="text/javascript">openPopUp('http://www.youtube.com/embed/EI1_xDgGvb0','550','430','layoutwidget');</script>
<%
}
%>

</body>
</html>

