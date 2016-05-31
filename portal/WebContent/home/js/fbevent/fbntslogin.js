function FBLoginDetails(){
	FB.login(function(response){
	FB.api('/me', function(response) {
	
		if(response.error){
			alreadyclicked=false;
			skiplogin();
			
		}
		else{
			alreadyclicked=false;
			if(response.email==undefined)
				response.email='';
			fblogindata=response;
			skiplogin();
		}       
	});
	}, {scope:'publish_stream,email'});
}	   

function populatefblogindata(data){
		//fbpopupwait();
	if(data.id==undefined){
		fillfblogindefaultcontent();
		return;
	}
	var msg="<p>"+props.fb_nts_login_track+"</p>";
	var htmldata="<img src='/home/images/images/close.png' id='fbloginpopup' class='imgclose'>";
	htmldata+=msg+"<center><span id='loginas'>"+props.fb_nts_login_as+"</span>"+
		"<br><a href='"+data.link+"' style='text-decoration:none;' target='_blank'>"+
		"<img src='https://graph.facebook.com/"+data.id+"/picture' border='0'><br><span>"+data.name+"</span></a>"+
		"&nbsp;&nbsp;<span style='float:left;color:blue;' id='notyou'>"+props.fb_nts_login_not_u+"</span></center><br>";
	
	htmldata+="<center><img src='/main/images/fb-connect.png' class='fbcommentbutton' border='0'><br><span ><a id='skipstep'>"+props.fb_nts_login_skip+"</a></span></center>";
	document.getElementById("attendeeloginpopup").innerHTML=htmldata;
	jQuery("#skipstep").click(function(){
		skiplogin();
	}).attr("style","cursor:pointer;color:blue;");

	jQuery("#fbloginpopup").attr("style"," margin-top: -36px;cursor:pointer;color:blue;").click(function(){
		skiplogin();
	});
	jQuery('#notyou').click(function(){
		FB.logout(function(response){
			fillfblogindefaultcontent();
		});
	}).attr("style","cursor:pointer;color:blue;");
	jQuery(".fbcommentbutton").click(function(){
		fblogindata=data;
		skiplogin();
	}).attr("style","cursor:pointer;");
	
	if($('registrationsource') && $('registrationsource').value=='iPad'){
	jQuery("#fbloginpopup").attr("style"," margin-top: -15px;margin-right: -15px;cursor:pointer;color:white;");
	jQuery("#skipstep").attr("style","cursor:pointer;color:white;");
	jQuery("#loginas").attr("style","color:white");
	jQuery("#attendeeloginpopup a,#notyou").attr("style","color:white;text-decoration:none;cursor:pointer;");
	
}
}
	var alreadyclicked=false;
function fillfblogindefaultcontent(){
		//fbpopupwait();
var msg="<p>"+props.fb_nts_login_track+"</p>";
var htmldata="<img src='/home/images/images/close.png' id='fbloginpopup' class='imgclose'>"+msg+"<center><img src='/main/images/login-button.png' class='fbloginbutton' border='0'><br><a id='skipstep'>"+props.fb_nts_login_skip+"</a></center>";

document.getElementById("attendeeloginpopup").innerHTML=htmldata;

jQuery("#skipstep").click(function(){
	skiplogin();
}).attr("style","cursor:pointer;color:blue;");

jQuery("#fbloginpopup").attr("style"," margin-top: -36px;cursor:pointer;color:blue;").click(function(){
	skiplogin();
});
if($('registrationsource') && $('registrationsource').value=='iPad'){
	jQuery("#fbloginpopup").attr("style"," margin-top: -15px;margin-right: -15px;cursor:pointer;color:white;");
	jQuery("#skipstep").attr("style","cursor:pointer;color:white;");
}
jQuery('.fbloginbutton').attr('style','cursor:pointer').click(function(){
	if(!alreadyclicked){
		FBLoginDetails();
		alreadyclicked=true;
	}
});
}

function skiplogin(){
	if(!alreadyclicked){
		if(document.getElementById('backgroundPopup'))
			document.getElementById("backgroundPopup").style.display='none';
		if($('forntspopup')){
			jQuery('#forntspopup').remove();
		}
		document.getElementById('attendeeloginpopup').style.display="none";
		submitTickets();
	}
}
var t=0;
function fbpopupwait(){
	t++;
	if(document.getElementById('attendeeloginpopup').style.display!="none" && !alreadyclicked){
			if(t==30){
			t=0;
				skiplogin();
			}
	}else{
	t=0;
	return;}
	setTimeout('fbpopupwait()',1000);
}
var ts=0;
function fbcreditspopupwait(){
	ts++;
	if(document.getElementById('ebeecreditpopup').style.display!="none" && creditbuttonclick==0){
			if(ts==30){
			ts=0;
				closeebeecreditspopup();
			}
	}else{
	ts=0;
	return;}
	setTimeout('fbcreditspopupwait()',1000);
}

	   