var attendeelabel='<label class="rsvpbutton" style="width:91px"><input value="I\'m Attending" type="button" name="attending" id="attending" class="inputbutton" style="width:91px"></label>';
var maybelabel="<label class='rsvpbutton'><input value='Maybe' type='button' name='maybe' id='maybe' class='inputbutton'></label>";
var declinedlabel="<label class='rsvpbutton'><input value='No' type='button' name='declined' id='declined' class='inputbutton'></label>";
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
	}, {scope:'rsvp_event'});	
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


function fqlQuery(fbeid,fbuid){
	 var query= FB.Data.query('select rsvp_status from event_member where eid ='+fbeid+'  AND uid='+fbuid+'');
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
var content=attendeelabel+"&nbsp;"+maybelabel+"&nbsp;"+declinedlabel;
jQuery("#fb-buttons").html(content);
jQuery(".inputbutton").click(function(){
responsetype=jQuery(this).attr("id");
checkfbloginstatus(fbeid);
});
}

function loadpostcontent(fbeid,posttype){
var content="You";
if(posttype=="attending"){
	content+="&nbsp;are <span>Attending</span>.&nbsp;Change to&nbsp;"+maybelabel+"&nbsp;"+declinedlabel;
}
else if(posttype=="unsure" || posttype=="maybe"){
content+="&nbsp;<span>Might Attend</span>.&nbsp;Change to&nbsp;"+attendeelabel+"&nbsp;"+declinedlabel;
}
else if(posttype="declined"){
	content+="&nbsp;are <span>Not Attending</span>.&nbsp;Change to&nbsp;"+attendeelabel+"&nbsp;"+maybelabel;
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