
<%
if(request.getAttribute("CUSTOM_HEADER")!=null){
%>
<%=(String)request.getAttribute("CUSTOM_HEADER")%>
<%
}else{%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" type="text/css" href="/home/index.css" />
<link rel="stylesheet" type="text/css" href="/home/homepage.css" />
<link rel="stylesheet" type="text/css" href="/home/css/niftyCorners.css" />
<script language="javascript" src="/home/js/popup.js">
 	function popupdummy(){}
</script>
</head>

<!-- new header  -->
<div id="header">
<!-------------------------Begin of Header----------------------------->
 <div class="background">
    <div class="inner">
    <div class="logo"><a href="/main/" ><img src="http://www.eventbee.com/home/images/logo_big.jpg" style="border-style: none">
    <br/><img src="http://www.eventbee.com/home/images/caption.jpg" style="border-style: none"></a>
    </div>
    <div id="topnav">
	   <span>
	   <a href="/main/" STYLE="text-decoration: none">
	   	  <b><span class="headerfont">Home</span></b>
	   	  </a>|
	      	  <a href="http://help.eventbee.com"  target="_blank" STYLE="text-decoration: none">
	   	  <b><span class="headerfont">Help</span></b>
	   	  </a> |
	   	  <a href="javascript:popupwindow('http://www.eventbee.com/home/links/livechat.html','Tags','600','400')" STYLE="text-decoration: none">
	   	  <b><span class="headerfont">Chat</span></b>
	   </a>
	   </span>

    </div><!-- end top-nav -->
    </div>
 </div><!--end background-->
<div id="bar"></div>
<!-- new header -->

</div>

<%}%>