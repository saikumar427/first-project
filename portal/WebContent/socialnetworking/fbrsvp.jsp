<%@page import="com.eventbee.general.DbUtil"%>
<%String fbeid=request.getParameter("fbeid");
String source=request.getParameter("source");
String sec=request.getParameter("sec");
String fbuid=request.getParameter("fbuid");
String venueid=request.getParameter("venueid");
String domain=request.getParameter("domain");
String record_id=request.getParameter("record_id");
String eid=request.getParameter("eid");

//System.out.println("venueid23423"+venueid+domain+sec);
if(sec==null){sec="";}
if(source==null)
	source="ebee";
String name=source+".fbconnect.appid";
String fbappid=DbUtil.getVal("select value from config where config_id='0' and name=?",new String[]{name});	
%>
<html><head>
<style>
.rsvpbutton{
-webkit-box-shadow: rgba(0, 0, 0, 0.0976563) 0px 1px 0px 0px;
background-attachment: scroll;
background-clip: border-box;
background-color: #5B74A8;
background-image: url(http://static.ak.fbcdn.net/rsrc.php/v1/yn/r/zHNGLEeoCs0.png);
background-origin: padding-box;
background-position: 0px -294px;
background-repeat: no-repeat;
border-bottom-color: #1A356E;
border-bottom-style: solid;
border-bottom-width: 1px;
border-left-color: #29447E;
border-left-style: solid;
border-left-width: 1px;
border-right-color: #29447E;
border-right-style: solid;
border-right-width: 1px;
border-top-color: #29447E;
border-top-style: solid;
border-top-width: 1px;
color: #666;
cursor: pointer;
direction: ltr;
display: inline-block;
font-family: 'lucida grande', tahoma, verdana, arial, sans-serif;
font-size: 13px;
font-weight: bold;
height: 19px;
line-height: normal;
margin-bottom: 0px;
margin-left: 0px;
margin-right: 0px;
margin-top: 0px;
padding-bottom: 2px;
padding-left: 6px;
padding-right: 6px;
padding-top: 2px;
text-align: center;
text-decoration: none;
unicode-bidi: normal;
vertical-align: top;
white-space: nowrap;
width: 60px;
Styles
:active	:hover
:focus	:visited
}
.inputbutton{
	-webkit-appearance: none;
-webkit-box-align: center;
-webkit-box-shadow: none;
-webkit-rtl-ordering: logical;
-webkit-user-select: text;
background-attachment: scroll;
background-clip: border-box;
background-color: transparent;
background-image: none;
background-origin: padding-box;
background-position: 0% 0%;
background-repeat: repeat;
border-bottom-color: white;
border-bottom-style: none;
border-bottom-width: 0px;
border-left-color: white;
border-left-style: none;
border-left-width: 0px;
border-right-color: white;
border-right-style: none;
border-right-width: 0px;
border-top-color: white;
border-top-style: none;
border-top-width: 0px;
box-sizing: border-box;
color: white;
cursor: pointer;
direction: ltr;
display: inline-block;
font-family: 'Lucida Grande', Tahoma, Verdana, Arial, sans-serif;
font-size: 13px;
font-style: normal;
font-variant: normal;
font-weight: bold;
height: 19px;
letter-spacing: normal;
line-height: normal;
margin-bottom: 0px;
margin-left: 0px;
margin-right: 0px;
margin-top: 0px;
outline-color: white;
outline-style: none;
outline-width: 0px;
padding-bottom: 2px;
padding-left: 0px;
padding-right: 0px;
padding-top: 1px;
text-align: center;
text-decoration: none;
text-indent: 0px;
text-shadow: none;
text-transform: none;
unicode-bidi: normal;
vertical-align: baseline;
white-space: nowrap;
width: 60px;
word-spacing: 0px;
Styles
:active	:hover
:focus	:visited
}
#fb-buttons{
font-size:9px;
color: #666666;
font-family: Verdana, Arial, Helvetica, sans-serif;
padding-top:3px;
}
#fb-buttons span{
font-weight:bold;
}
#fb-buttons label{
padding-top:0px;
}
</style>
<script type='text/javascript' language='JavaScript' src='/home/js/jQuery.js'></script>
<script type='text/javascript' language='JavaScript' src='/home/js/fbevent/fbrsvpeventlist.js'></script>
<script>
var domain='<%=domain%>';
var fbeid='<%=fbeid%>';
var fbuid='<%=fbuid%>';
 var record_id='<%=record_id%>';
  var venueid='<%=venueid%>';
   var eid='<%=eid%>';
</script>

<%if(!"sec".equals(sec)){%>
<script type='text/javascript' language='JavaScript' src='/home/js/fbevent/fbrsvp.js'></script>
</head><body>
<div id='fb-root'></div>
<script>
//alert("notsec");
window.fbAsyncInit = function() {
//	alert("ihdrkjgtlkj");
FB.init({appId: '<%=fbappid%>' ,status: true, cookie: true, xfbml: true});

FB.getLoginStatus(function(response) {
//alert("fbuid"+response.session.uid);
	if (response.authResponse) {
	
		fqlQuery('<%=fbeid%>',response.authResponse.userID);
	}
	
	else{
		loaddefaultcontent('<%=fbeid%>');
	      }
		  
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
</script>
<!--
<label class='rsvpbutton'><a href="http://www.facebook.com/event.php?eid=<%=fbeid%>" target='_blank'><input value='RSVP' type='button' name='rsvpbutton' id='rsvpbutton' class='inputbutton'></a></label>
-->
<div id='fb-response'></div>
<div id='fb-buttons'>
<!--<label class='rsvpbutton' style='width:91px'><input value="I'm Attending" type='button' name='attending' id='attending' class='inputbutton' style='width:91px'></label>&nbsp;
<label class='rsvpbutton'><input value='Maybe' type='button' name='maybe' id='maybe' class='inputbutton'></label>&nbsp;
<label class='rsvpbutton'><input value='No' type='button' name='declined' id='declined' class='inputbutton'></label>
-->
</div>
<script>
var responsetype="";
jQuery(".inputbutton").click(function(){
responsetype=jQuery(this).attr("id");
checkfbloginstatus('<%=fbeid%>');
});
</script>                                                                                                              
<%}else{%>
<script type='text/javascript' language='JavaScript' src='/home/js/fbevent/fbsvpvenue.js'></script>
</head><body>
<div id='fb-root'>

</div>

<script>
var responses;
//alert("sec");
window.fbAsyncInit = function() {
	//alert("default1"+'<%=fbappid%>');
FB.init({appId: '<%=fbappid%>' ,status: true, cookie: true, xfbml: true});

FB.getLoginStatus(function(response) {

						
	if (response.authResponse) {

					
			fqlQuery('<%=fbeid%>',response.authResponse.userID);
				
	}
	
	else{
		loaddefaultcontent('<%=fbeid%>');
	      }
		
});	
};
(function() {
//alert("t4r");
	var e = document.createElement('script');
	e.type = 'text/javascript';
	e.src = document.location.protocol +
		'//connect.facebook.net/en_US/all.js';
	e.async = true;
	document.getElementById('fb-root').appendChild(e);
}());
</script>
<!--
<label class='rsvpbutton'><a href="http://www.facebook.com/event.php?eid=<%=fbeid%>" target='_blank'><input value='RSVP' type='button' name='rsvpbutton' id='rsvpbutton' class='inputbutton'></a></label>
-->
<div id='fb-response'></div>
<div id='fb-buttons'>
<!--<label class='rsvpbutton' style='width:91px'><input value="I'm Attending" type='button' name='attending' id='attending' class='inputbutton' style='width:91px'></label>&nbsp;-->

</div>
<script>
var responsetype="";
jQuery(".inputbutton").click(function(){
responsetype=jQuery(this).attr("id");
checkfbloginstatus('<%=fbeid%>');

});
</script>



<%}%>

</body>
</html>