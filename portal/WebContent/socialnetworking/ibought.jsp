<html>
<head>
</head>
<body
<div id="fb-root"></div>
<script>

window.fbAsyncInit = function() {
	//FB.init({appId: '201409456567228',  , status: true, cookie: true, xfbml: true});
//227788873904118 ---localhost
//48654146645  eventbee
FB.init({appId: '48654146645' ,status: true, cookie: true, xfbml: true});
	/* All the events registered */
	
};
(function() {
	var e = document.createElement('script');
	e.type = 'text/javascript';
	e.src = document.location.protocol +
		'//connect.facebook.net/en_US/all.js';
	e.async = true;
	document.getElementById('fb-root').appendChild(e);
}());
            function graphStreamPublish(){
			FB.login(function(response){
				//for(key in response)
				//alert(response[key]+"--"+key);
				FB.api('/me', function(response) {
					
						//alert(response[key]+"--"+key);
                
				
                var my_msg="Hi, this is just a test for Stream Publish of fb api.";
				alert(my_msg);
                var URL="http://www.eventbee.com";
                var title="invitation";
                var desc="this is just a test for stream publish";
                var pic_URL="http://eventbee.com/home/images/logo_big.jpg";
                FB.api('/me/feed', 'post', { message:my_msg,link:URL,name:title,description:desc,picture:pic_URL }, function(response) {
                    if (!response || response.error) {
                        alert('Error occured:'+response.error.message);
						
                    } else {
                        alert('Post ID: ' + response.id);
                    }
                });
				});
				});
            }
 
</script>
<!--
<form action="https://graph.facebook.com/836178163/feed?access_token=227788873904118|2.AQDadaC_ytwdmOv-.3600.1307520000.0-836178163|rWDrKsjNbaDB60Sw9DfE4uI5BjA" method="post">
<input type="hidden" name="message" id="message" value="hi to ebee">
<input type="hidden" name="link" id="link" value="http://www.eventbee.com">
<input type="submit" value="submit">
</form>-->

<a href="#" onclick="graphStreamPublish(); return false;">Publish Stream Using Graph API</a>
</body>
</html>