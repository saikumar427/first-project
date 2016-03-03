var attendeelabel='<label class="rsvpbutton" style="width:50px"><input value="Join" type="button" name="attending" id="attending" class="inputbutton" style="width:50px"></label>';
var name1="";
var email1="";
var gender1="";
var responses="";

function checkfbloginstatus(fbeid){


FB.getLoginStatus(function(resp) {
	
	FB.api('/me', function(response) {
		if(response.error){
			getloginpopup(fbeid);
		}
		else{
         
			rsvptoevent(fbeid,resp.authResponse);
		}
	});
});
}




function getloginpopup(fbeid){

	 FB.login(function(response){
	
	
        if(response.authResponse && response.scope!=null){
			rsvptoevent(fbeid,response.authResponse);
			
		}
		fbuid=response.authResponse.userID;
		   
			}, {scope:'rsvp_event,email,publish_stream'});	
}

function rsvptoevent(fbeid,session){
jQuery.ajax({
   type: "POST",
   url: "/socialnetworking/rsvptofb.jsp",
   data: "fbeid="+fbeid+"&access_token="+session["accessToken"]+"&responsetype="+responsetype+"",
   success: function(msg){
   var respdata=eval('('+msg+')');
   if(respdata.data==undefined){
		getloginpopup(fbeid);
		return ;
		}
		else{
		loadpostcontent(fbeid,responsetype);
		
		}
   }
 });
}


function fqlQuery(fbeid,fbueid){
fbuid=fbueid;
	 var query= FB.Data.query('select rsvp_status from event_member where eid in('+fbeid+')  AND uid='+fbueid+' AND rsvp_status="attending"');
	 query.wait(function(rsvpstat) {
		resp=rsvpstat[0];
		
		if(resp==undefined){
			loaddefaultcontent(fbeid);
		}
		else{
			loadpostcontent(fbeid,resp["rsvp_status"]);
			
		}
	 });
}


function loaddefaultcontent(fbeid){
var content=attendeelabel;//+"&nbsp;"+maybelabel+"&nbsp;"+declinedlabel;
jQuery("#fb-buttons").html(content);
jQuery(".inputbutton").click(function(){
responsetype=jQuery(this).attr("id");
checkfbloginstatus(fbeid);

});
}

function loadpostcontent(fbeid,posttype){
var content="You";
if(posttype=="attending"){
	content+="'re <span>going</span>";
	//reload();


	insertdb();
	}

else{
	loaddefaultcontent(fbeid);
	return;
}

jQuery("#fb-buttons").html(content);
jQuery(".inputbutton").click(function(){
responsetype=jQuery(this).attr("id");
checkfbloginstatus(fbeid);

});
}

function insertdb()
{

	FB.api('/me', function(response1) {
                        
				        fbuid=response1.id;
	                    name1=response1.name;	
						email1=response1.email;
						gender1=response1.gender;
						
						$.ajax({
									url:"/socialnetworking/fbtrck.jsp?domain="+domain+"&fbeid="+fbeid+"&fbuid="+fbuid+"&venueid="+venueid+"&eid="+eid+"&record_id="+record_id+"&name="+name1+"&email="+email1+"&gender="+gender1+"&date="+ new Date().getTime(),
									success:function(t){
											
																	}
									});
									
			});
}

