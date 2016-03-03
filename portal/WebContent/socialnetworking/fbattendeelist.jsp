<%@page import="com.eventbee.general.EbeeConstantsF,com.eventbee.general.DbUtil"%>
<%!String serveraddress="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com")+"/";
%>
<% 
String eid=request.getParameter("eid");
String fbeid=request.getParameter("fbeid");
String showgender=request.getParameter("showgender");
String boxtype=request.getParameter("boxtype");
String source=request.getParameter("source");
String sec=request.getParameter("sec");
String venueid=request.getParameter("venueid");
String domain=request.getParameter("domain");
String fbuid=request.getParameter("fbuid");
String record_id=request.getParameter("record_id");

if(sec==null){sec="";}
if(venueid==null){venueid="";}
if(domain==null){domain="";}
if(fbuid==null){fbuid="";}
if(source==null)
	source="ebee";
String name=source+".fbconnect.appid";
String fbappid=DbUtil.getVal("select value from config where config_id='0' and name=?",new String[]{name});	


%>
<html>
<head>
<style>
.small {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
	font-weight: lighter;
	color: #666666;
	margin: 0;
	overflow: hidden;
	white-space: nowrap;
}
a{
	text-decoration: none;
}

div .fbattend .small{
font-size:9px;
}
div table span .small{
font-size:12px;
}

</style>
<link rel='stylesheet' type='text/css' href='/home/css/pagination.css' />
<script type='text/javascript' language='JavaScript' src='/home/js/jQuery.js'></script>
<script type='text/javascript' language='JavaScript' src='/home/js/prototype.js'></script>
<script type='text/javascript' language='JavaScript' src='/home/js/ajax.js'>function ajaxdummy(){ }</script>
<script type='text/javascript' language='JavaScript' src='/home/js/fbevent/fbrsvpeventlist.js'></script>
<script type='text/javascript' language='JavaScript' src='/home/js/fbevent/jquery.pagination.js'></script>

</head>
<body>
 <div id='fb-root'></div>
<div id="fbattendeelist" style="padding:0px;margin:0px;"></div>
<div id="fbattend" style="padding:0px;margin:0px;"></div>
<script>

window.fbAsyncInit = function() {
//alert("sjkdhkjfhks");

FB.init({appId: '<%=fbappid%>' ,status: true, cookie: true, xfbml: true});
	/* All the events registered */
	FB.Event.subscribe('auth.login', function(response) {
		// do something with response
		login();
	});
	FB.Event.subscribe('auth.logout', function(response) {
		// do something with response
		logout();
	});

	FB.getLoginStatus(function(response) {
		if (response.authResponse) {
			login();
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
if('<%=fbeid%>'!=null){
fbeid='<%=fbeid%>';
}
if("<%=showgender%>"=='yes')
	fbshowgenderlink='Y';
else
	fbshowgenderlink='N';

 fbboxtype="<%=boxtype%>";
 showFBAttendeeList('<%=eid%>',fbeid);
 
 var serveraddress='<%=serveraddress%>';
 var source='<%=source%>';
 var domain='<%=domain%>';
 var venueid='<%=venueid%>';
 var sec='<%=sec%>';
 var fbuid='<%=fbuid%>';
 var eid='<%=eid%>';
 var record_id='<%=record_id%>';
 var sec='<%=sec%>';

 </script>
</body>
</html>
