
<%
if(request.getAttribute("CUSTOM_HEADER")!=null){
%>
<%=(String)request.getAttribute("CUSTOM_HEADER")%>
<%
}else{%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="icon" href="/main/images/favicon.ico" type="image/x-icon">
<link rel="shortcut icon" href="/main/images/favicon.ico" type="image/x-icon">
<link rel="stylesheet" type="text/css" href="/main/css/style.css" />
<link rel="stylesheet" type="text/css" href="/main/css/common.css" />
<link rel="stylesheet" type="text/css" href="/main/css/taskpage.css" />
<link rel="stylesheet" type="text/css" href="/home/css/niftyCorners.css" />
<script type="text/javascript" src="http://eventbee.com/home/js/customfonts/cufon-yui.js"></script>
<!-- <script src="http://eventbee.com/home/js/customfonts/Droid_Sans_Mono_400.font.js" type="text/javascript"></script>
 <script>Cufon.replace('.headerfont');</script> -->
<script src="http://eventbee.com/home/js/customfonts/Myriad_Pro_400.font.js" type="text/javascript"></script>
<script>Cufon.replace('.roundedboxheader,.rectboxheader,.logo h1');</script>

<script language="javascript" src="/home/js/popup.js">
 	function popupdummy(){}
</script>
<style>
.background {
background-image:none;
}
</style>
</head>
<div id="header_top">

<!-- Start Top Header -->
 <table width="989px" cellpadding="0" cellspacing="0" align="center">
  <tr>
  <td align="right">
  <span class="header_top_content" style="padding-right: 15px;"><a style="background-image: url(/main/images/home/email.png);background-repeat: no-repeat;padding-left: 20px;height:20px;display:inline-block;" href="#"  onClick="openPopUp('/main/user/supportemail.jsp','350','330','layoutwidget2')">Contact </a> </span>
   <span class="header_top_content" style="padding-right: 15px;"><a style="background-image: url(/main/images/home/faq.png);background-repeat: no-repeat;padding-left: 20px;height:20px;display:inline-block;" href="/main/faq">FAQ </a> </span>
  <span class="header_top_content"><a style="background-image: url(/main/images/home/tickets.png);background-repeat: no-repeat;padding-left: 20px;display:inline-block;height:20px;" href="#" onClick="openPopUp('/main/user/mytickets.jsp','550','430','layoutwidget')">Tickets </a></span>
  </td>
  </tr>
  </table>
<!-- End Top Header
<!-- new header  -->
<div id="header">
<!-------------------------Begin of Header----------------------------->
 <div class="background">
    <div class="inner">
    <table width="100%" cellspacing="0" cellpadding="0" align="center"><tr><td align="left">
    <div class="logo"><a href="/main/" ><img src="http://www.eventbee.com/home/images/logo_big.jpg" style="border-style: none">
    <br/><h1><b>Sell More Tickets With Less Effort!</b></h1></a>
    </div>
    </td>
    <td align="right" valign="bottom">
   
      
    <table align="right"><tr><td valign="bottom">
         <span class="header_links">   <a href="/main/" STYLE="text-decoration: none">
	  Home</span>
	  <!-- <span class="headerfont"> | </span>
	  <a href="/main/user/login" STYLE="text-decoration: none">
	  <b><span class="headerfont">Login</span></b>
	  </a> -->
	  <!-- <span class="headerfont"> | </span>
	  <a href="http://help.eventbee.com"  target="_blank" STYLE="text-decoration: none">
	  <b><span class="headerfont">Help</span></b>
	  </a> -->

          </td></tr></table>
	   <!-- </a><span class="headerfont"> | </span>
	   	   <a href="javascript:popupwindow('http://www.eventbee.com/home/links/livechat.html','Tags','600','400')" STYLE="text-decoration: none">
	   	  <b><span >Chat</span></b> 
	   </a> -->
	   

   
    </td></tr></table>
    </div>
 </div><!--end background-->

<!-- new header -->

</div>

<%}%>