var _purpose;
var _eventname;
var _eventinfo;
var _regurl;
var _bundleid;
var _eventid;
var _onsuccessurl;
var _eventurl;
var _mgrname;
var _eventbeeurl;
var _imageurl;
function ShowFBProfile(){
//alert("showfbprofile");
	//FB.Connect.showPermissionDialog('create_event');
	uid=FB.Facebook.apiClient.get_session().uid;
	user=new Array(1);
	  user[0]=uid;
	  FB.Facebook.apiClient.users_getInfo(user,['name', 'pic_small'], function(user_details, ex){
	  var picurl=user_details[0]['pic_small'];
	  if(picurl.length==0){
	  	  picurl='http://static.ak.fbcdn.net/pics/q_silhouette.gif';
	  }
	  if(document.getElementById("fbprofile_pic"))
	  document.getElementById("fbprofile_pic").innerHTML="<img  src='"+picurl+"' alt='user photo' width='50' height='45'vspace='0'/><img src='http://static.ak.fbcdn.net/images/icons/favicon.gif'  class='FB_ImgLogo' border='0' />";
	  if(document.getElementById("fbuid"))
	  	document.getElementById("fbuid").value=uid;
	  	if(document.getElementById("fbusername"))
          document.getElementById("fbusername").innerHTML=user_details[0]['name'];
       //document.getElementById("fbusername").innerHTML=FB.Facebook.apiClient.get_session().session_key;
	  advAJAX.get( {
			url : "/portal/fbauth/isAlreadyLinkedFBuser.jsp?fbuid="+uid,
			onSuccess : function(obj) {
			var data=obj.responseText;	
			if(data.indexOf("ALREADY_LINKED")>-1){	
			if(document.getElementById("connectlinkmsg"))
    				document.getElementById("connectlinkmsg").style.display='none';
			}
			else{
				if(document.getElementById("connectlinkmsg"))
				document.getElementById("connectlinkmsg").style.display='block';
				}
			},
			onError : function(obj) { }
		});	  
    });
}


function processPostLogin(){
//alert("postlogin");
	uid=FB.Facebook.apiClient.get_session().uid;
	sessionkey=FB.Facebook.apiClient.get_session().session_key;
	var fname;
	var lname;
	user=new Array(1);
		  user[0]=uid;
		  FB.Facebook.apiClient.users_getInfo(user,['name', 'first_name', 'last_name'], function(user_details, ex){
		 fname=user_details[0]['first_name'];
	         lname=user_details[0]['last_name'];
	                     
	        var form = document.createElement("form");
                form.setAttribute("method", "post");
                form.setAttribute("action", "/portal/fbauth/getbeeidofFBuser.jsp");

		var hiddenFieldFid = document.createElement("input");              
		hiddenFieldFid.setAttribute("name", "fbuid");
		hiddenFieldFid.setAttribute("value", uid);
		form.appendChild(hiddenFieldFid);

		var hiddenFieldfname = document.createElement("input");              
		hiddenFieldfname.setAttribute("name", "fname");
		hiddenFieldfname.setAttribute("value", fname);
		form.appendChild(hiddenFieldfname);


		var hiddenFieldlname = document.createElement("input");              
		hiddenFieldlname.setAttribute("name", "lname");
		hiddenFieldlname.setAttribute("value", lname);
		form.appendChild(hiddenFieldlname);

	       // document.body.appendChild(form); 
		advAJAX.submit(form,{		
				onSuccess : function(obj) {},
					onError : function(obj) { }
		});
		
		ShowFBProfile();		
		if(_purpose=="INVITE") ShowInviteFBFriendForm();
		else if(_purpose=="FEED") ShowpublishFBFeedForm();
		else if(_purpose=="PUBLISH_EVENT") handlepublisheventpagedisplay(_eventid);
		else if(_purpose=="EDIT_EVENT") editpublisheventpagedisplay(_eventid);
		//else if(_purpose=="ConfirmationFEED") ShowConfirmationFeed();
		else if(_purpose=="ConfirmationFEED") ShowConfirmationFeedtaskpage(_eventid, uid);
		//else if(_purpose=="FBFEED")  ShowpublishFBFeed();
		else{
			window.setTimeout("gotoonsuccesspage()",3000);
		
		}
		});
}
function testprocessPostLogin() {
  alert("postlogin");
  uid=FB.Facebook.apiClient.get_session().uid;
  sessionkey=FB.Facebook.apiClient.get_session().session_key;
  ShowConfirmationFeedtaskpage(_eventid, uid);
}

function gotoonsuccesspage(){
	window.location.href=_onsuccessurl;
}
function publishFBFeed(imageurl,eventname, eventinfo, regurl,bundleid,eventbeeurl){
	_purpose="FEED";
	_eventname=eventname;
	_eventinfo=eventinfo;
	_regurl=regurl;
	_bundleid=bundleid;
	_eventbeeurl=eventbeeurl;
	_imageurl=imageurl;
	FB.Connect.requireSession(); 
	FB.Facebook.get_sessionState().waitUntilReady(function(){
	processPostLogin();
	});
	return false;
}
function Confirmationpagefeed(imageurl,eventname, eventinfo, regurl,bundleid, eventbeeurl){

	_eventname=eventname;
	_eventinfo=eventinfo;
	_regurl=regurl;
	_bundleid=bundleid;
	_eventbeeurl=eventbeeurl;
	_imageurl=imageurl;
	ShowConfirmationFeed();
	
}
function Confirmationpagefbfeed(eventid){
alert("postlogin");
_purpose="ConfirmationFEED";
	_eventid=eventid;
	FB.Connect.requireSession(); 
	FB.Facebook.get_sessionState().waitUntilReady(function(){
	testprocessPostLogin();
	});
	return false;
}
function publishFeed(evtname,mgrname,bundleid,eventurl,eventbeeurl){
	_purpose="FBFEED";	
	_bundleid=bundleid;
	_eventname=evtname;
	_mgrname=mgrname;
	_eventurl=eventurl;
	_eventbeeurl=eventbeeurl;
	ShowpublishFBFeed();
	
}

function PopulateSubcategories() {
   	var category_subtypes = new Array("");
   	var category_subtypevalues = new Array("");
	category_subtypes[0] = new Array("");
	category_subtypevalues[0] = new Array("");
	category_subtypes[1] = new Array("Birthday Party","Cocktail Party","Club Party","Concert",
				"Fraternity/Sorority Party","Business Meeting","Barbecue","Card Night","Dinner Party",
				"Holiday Party","Night of Mayhem","Movie/TV Night","Drinking Games",
				"Bar Night","LAN Party","Study Group","Mixer","Slumber Party","Erotic Party","Benefit",
				"Goodbye Party","House Party","Reunion");
	category_subtypevalues[1] = new Array("1","2","3","4",
				"5","6","7","8",
				"9","10","11","12",
				"13","14","15","16","17","18",
			"19","20","21","22","23");
	category_subtypes[2] = new Array("Fundraiser","Protest","Rally");
			
	category_subtypevalues[2] = new Array("24","25","26");
	
	category_subtypes[3] = new Array("Class","Lecture","Office Hours","Workshop");
	category_subtypevalues[3] = new Array("27","28","29","30");
	
	category_subtypes[4] = new Array("Club/Group Meeting","Convention",
				"Dorm/House Meeting","Informational Meeting");
	category_subtypevalues[4] = new Array("31","32","33",
				"Dorm/House Meeting","Informational Meeting");
	category_subtypes[5] = new Array("Concert","Audition","Exhibit","Jam Session",
				"Listening Party","Opening","Performance","Preview","Recital","Rehearsal");
	category_subtypes[6] = new Array("Pep Rally","Pick-Up","Sporting Event","Sports Practice","Tournament");
	category_subtypes[7] = new Array("Camping Trip","Daytrip","Group Trip","Roadtrip");
	category_subtypes[8] = new Array("Carnival","Ceremony","Festival","Flea Market","Retail");
   	var SelObj=document.getElementById("category");
	var sub_categoryElem=document.getElementById("subcategory");
	for(var i=sub_categoryElem.length-1;i>=0;i--){
		sub_categoryElem.remove(i);
	}
	var oOption=document.createElement("option");
	var innTxt=document.createTextNode(" -- Select Sub Category -- ");
	oOption.setAttribute('value','');
	oOption.appendChild(innTxt);
	sub_categoryElem.appendChild(oOption);
	if(SelObj.selectedIndex<1 || SelObj.selectedIndex>=category_subtypes.length)
		return;
	var subcategorylist=category_subtypes[SelObj.selectedIndex];
	var subcategoryvaluelist=category_subtypevalues[SelObj.selectedIndex];
	if(subcategorylist){
		for(var i=0;i<subcategorylist.length;i++){
			oOption=document.createElement("OPTION");
			var txt = document.createTextNode(subcategorylist[i]);
			oOption.setAttribute('value',subcategorylist[i]);
			oOption.appendChild(txt);
			sub_categoryElem.appendChild(oOption);
		}
	}  	
   }

function ShowpublishFBFeedForm() {
message_prompt = "What do you want to tell to your friends...";
var message = {value: "Check this event, you might even get Facebook friend discount!"};
	if(_imageurl==""){
		 template_data={"imagehref":"", "eventname":_eventname,"eventlink":_regurl, "eventinfo":_eventinfo, "eventbeelink":_eventbeeurl, "registerlink":_regurl};
		}else{
	        template_data={"images":[{"src":_imageurl, "href":_regurl}],"imagehref":"", "eventname":_eventname,"eventlink":_regurl, "eventinfo":_eventinfo, "eventbeelink":_eventbeeurl, "registerlink":_regurl};
	        }
	//FB.Connect.showFeedDialog(_bundleid, template_data);
	 FB.Connect.showFeedDialog(_bundleid, template_data, null, '', null, null, null, message_prompt, message);
        //var imgicon=""; 
	
//template_data={"eventname":_eventname,"eventlink":_regurl, "eventinfo":_eventinfo};
	//FB.Connect.showFeedDialog(_bundleid, template_data);
	
}
function ShowConfirmationFeed() {
message_prompt = "What do you want to tell to your friends...";
var message = {value: "Check this event, you might even get Facebook friend discount!"};
	if(_imageurl==""){
	 template_data={"imagehref":"", "eventname":_eventname,"eventlink":_regurl, "eventinfo":_eventinfo, "eventbeelink":_eventbeeurl, "registerlink":_regurl};
	}else{
        template_data={"images":[{"src":_imageurl, "href":_regurl}],"imagehref":"", "eventname":_eventname,"eventlink":_regurl, "eventinfo":_eventinfo, "eventbeelink":_eventbeeurl, "registerlink":_regurl};
        }
        FB.Connect.showFeedDialog(_bundleid, template_data, null, '', null, null, null, message_prompt, message);
	//FB.Connect.showFeedDialog(_bundleid, template_data);
}
function ShowConfirmationFeedtaskpage(eventid, uid){
//window.location.href="/guesttasks/confirmationfeed.jsp?eid="+eventid+"&uid="+uid;
	document.getElementById('confirmationfeed').innerHTML="";
		advAJAX.get( {
			
		url : '/eventregister/reg/confirmationfeed.jsp?eid='+eventid+'&uid='+uid,
		onSuccess : function(obj) {
		var data=obj.responseText;
		data=testtrim(data);
		ShowFBProfile();
		document.getElementById('confirmationfeed').innerHTML=obj.responseText;
		},
		onError : function(obj) { alert("Error: " + obj.status); }
	});

}
function ShowpublishFBFeed() {	      
	template_data={"eventname":_eventname,  "eventlink":_eventurl, "eventbeeurl":_eventbeeurl};
	FB.Connect.showFeedDialog(_bundleid, template_data);
	reload();
}
function reload(){ 
       window.setTimeout("window.location.reload(true)",9000);
       }
function hide(){
if(parent.ajaxwin!=null){
 parent.ajaxwin.hide();
 }
}
function initiatepublishtofb(eventid){
	_purpose="PUBLISH_EVENT";
	_eventid=eventid;
	FB.Connect.requireSession(); 
	FB.Facebook.get_sessionState().waitUntilReady(function(){
	alert
	processPostLogin();
	});
	
} 
function fbeventpage(eventid,sessionkey,uid,apikey){	
	_eventid=eventid;
	fbpublishevent(_eventid,sessionkey,uid,apikey);	
} 
function publishfbevent(eventid,uid,sessionkey,apikey){
	ajaxwin=dhtmlwindow.open("ajaxbox", "ajax", "/facebook/fbeventpage/revieweventtofb.jsp?GROUPID="+eventid+"&fbuid="+uid+"&sessionkey="+sessionkey+"&apikey="+apikey, "Publish Your Event On Facebook", "width=650px, height=500px, left=50px, top=400px, resize=0,scrolling=1")
}

function editandpublishtofb(eventid){
_purpose="EDIT_EVENT";
_eventid=eventid;
FB.Connect.requireSession();
FB.Facebook.get_sessionState().waitUntilReady(function(){
processPostLogin();
});
}

function validateeventinformation(){	
var evtname=document.getElementById("eventname").value;
var eventurl=document.getElementById("eventurl").value;
var mgrname=document.getElementById("username").value;
var bundleid=document.getElementById("bundleid").value;
var eventbeeurl=document.getElementById("eventbeeurl").value;

    advAJAX.submit(document.getElementById("eventinformation"), {			
    onSuccess : function(obj) {
	var data=obj.responseText;	
    var startindex= data.indexOf("published:");    
    var endindex= data.indexOf("</status>");
   
    if(startindex>-1){   
    fbeid=data.substring(startindex+11,endindex);  
    eventurl='http://www.facebook.com/event.php?eid='+fbeid;
  
    parent.ajaxwin.hide();

        publishFeed(evtname,mgrname,bundleid,eventurl,eventbeeurl);
      
	}
	else {
	document.getElementById("error").innerHTML="<font color='red'>Event could not be posted to facebook, as the following error is reported:<br>"+data+"</font>";
	}
		
	},
    onError : function(obj) { alert("Error: " + obj.status); }
});
}
function publishtofacebook(eventid,uid){
	ajaxwin=dhtmlwindow.open("ajaxbox", "ajax", "/portal/fbauth/revieweventtofb.jsp?GROUPID="+eventid+"&fbuid="+uid, "Publish Your Event On Facebook", "width=650px, height=500px, left="+makeRequestwindowleft+"px, top=20px,resize=0,scrolling=1")
}
function validatefbeventinformation(){	
var evtname=document.getElementById("eventname").value;
var eventurl=document.getElementById("eventurl").value;
var mgrname=document.getElementById("username").value;
var bundleid=document.getElementById("bundleid").value;
var eventbeeurl=document.getElementById("eventbeeurl").value;

    advAJAX.submit(document.getElementById("eventinformation"), {			
    onSuccess : function(obj) {
	var data=obj.responseText;	
    var startindex= data.indexOf("published:");    
    var endindex= data.indexOf("</status>");
   
    if(startindex>-1){   
    fbeid=data.substring(startindex+11,endindex);  
    eventurl='http://www.facebook.com/event.php?eid='+fbeid;
  	 window.location.reload(true);
   
	}
	else {
	document.getElementById("error").innerHTML="<font color='red'>Event could not be posted to facebook, as the following error is reported:<br>"+data+"</font>";
	}
		
	},
    onError : function(obj) { alert("Error: " + obj.status); }
});
}
  
function editfacebookevent(eventid,uid){
ajaxwin=dhtmlwindow.open("ajaxbox", "ajax", "/portal/fbauth/reviewandeditfbevent.jsp?GROUPID="+eventid+"&fbuid="+uid, "Publish Your Event On Facebook", "width=650px, height=500px, top=20px,resize=0,scrolling=1")
}

function handlepublisheventpagedisplay(eventid){
	if(FB.Facebook.apiClient!=null & FB.Facebook.apiClient.get_session()!=null){
		
		uid=FB.Facebook.apiClient.get_session().uid;
		
		sessionkey=FB.Facebook.apiClient.get_session().session_key;
		var form = document.createElement("form");
		form.setAttribute("method", "post");
		form.setAttribute("action", "/portal/fbauth/haspermission.jsp");

		var hiddenFieldFid = document.createElement("input");              
		hiddenFieldFid.setAttribute("name", "fbuid");
		hiddenFieldFid.setAttribute("value", uid);
		form.appendChild(hiddenFieldFid);

		var hiddenFieldsessionkey = document.createElement("input");              
		hiddenFieldsessionkey.setAttribute("name", "sessionkey");
		hiddenFieldsessionkey.setAttribute("value", sessionkey);
		form.appendChild(hiddenFieldsessionkey);

		advAJAX.submit(form,{		
		onSuccess : function(obj) {
		var data=obj.responseText;	
		if(data.indexOf("ALREADY_GRANTED")>-1){	
			publishtofacebook(eventid,uid);
		}
		else{
		FB.Connect.showPermissionDialog('create_event');
			
		}

		},
			onError : function(obj) { }
		});		
		
		
	}
}
function fbpublishevent(eventid,sessionkey,uid,apikey){
		
		//uid=FB.Facebook.apiClient.get_session().uid;
		//sessionkey=FB.Facebook.apiClient.get_session().session_key;
		var form = document.createElement("form");
		form.setAttribute("method", "post");
		form.setAttribute("action", "/facebook/fbeventpage/haspermission.jsp");

		var hiddenFieldFid = document.createElement("input");              
		hiddenFieldFid.setAttribute("name", "fbuid");
		hiddenFieldFid.setAttribute("value", uid);
		form.appendChild(hiddenFieldFid);

		var hiddenFieldsessionkey = document.createElement("input");              
		hiddenFieldsessionkey.setAttribute("name", "sessionkey");
		hiddenFieldsessionkey.setAttribute("value", sessionkey);
		form.appendChild(hiddenFieldsessionkey);
		
		var hiddenFieldapikey = document.createElement("input");              
		hiddenFieldapikey.setAttribute("name", "apikey");
		hiddenFieldapikey.setAttribute("value", apikey);
		form.appendChild(hiddenFieldapikey);
		

		advAJAX.submit(form,{		
		onSuccess : function(obj) {
		var data=obj.responseText;	
		if(data.indexOf("ALREADY_GRANTED")>-1){	
			publishfbevent(eventid,uid,sessionkey,apikey);
		}
		else{
		//FB.Connect.showPermissionDialog('create_event');
window.open("http://www.facebook.com/authorize.php?api_key="+apikey+"&v=1.0&ext_perm=create_event", "Permission");

		}

		},
			onError : function(obj) { }
		});		
		
		
	
}

function editpublisheventpagedisplay(eventid){
	if(FB.Facebook.apiClient!=null & FB.Facebook.apiClient.get_session()!=null){
		
		uid=FB.Facebook.apiClient.get_session().uid;
		
		sessionkey=FB.Facebook.apiClient.get_session().session_key;
		var form = document.createElement("form");
		form.setAttribute("method", "post");
		form.setAttribute("action", "/portal/fbauth/haspermission.jsp");

		var hiddenFieldFid = document.createElement("input");              
		hiddenFieldFid.setAttribute("name", "fbuid");
		hiddenFieldFid.setAttribute("value", uid);
		form.appendChild(hiddenFieldFid);

		var hiddenFieldsessionkey = document.createElement("input");              
		hiddenFieldsessionkey.setAttribute("name", "sessionkey");
		hiddenFieldsessionkey.setAttribute("value", sessionkey);
		form.appendChild(hiddenFieldsessionkey);

		advAJAX.submit(form,{		
		onSuccess : function(obj) {
		var data=obj.responseText;	
		if(data.indexOf("ALREADY_GRANTED")>-1){	
			editfacebookevent(eventid,uid);
		}
		else{
		FB.Connect.showPermissionDialog('create_event');
			
		}

		},
			onError : function(obj) { }
		});		
		
		
	}
}
function granteventcreatepermission(){
	if(FB.Facebook.apiClient!=null & FB.Facebook.apiClient.get_session()!=null){
		FB.Connect.showPermissionDialog('create_event');
		document.getElementById("setpermission").innerHTML="After granting permission, <a href='#' onclick='window.location.reload(true);'>click here</a> to publish event to facebook";
	}else{
		alert("Please complete step 1");
	}
}

function inviteFBFriends(eventname, regurl){
	_purpose="INVITE";
	_eventname=eventname;
	_regurl=regurl;
	FB.Connect.requireSession(); 
	FB.Facebook.get_sessionState().waitUntilReady(function(){
	processPostLogin();
	});
	
} 


function ShowInviteFBFriendForm(){
	FB.IFrameUtil.CanvasUtilServer.run(true);
	var dynadiv=document.createElement("div");
	dynadiv.setAttribute("iframeHeight","560px");
	dynadiv.setAttribute("iframeWidth","630px");
	dynadiv.setAttribute("fbml","<fb:fbml>"+"<fb:request-form style=\"width:630px; height:560px;\" action=\""+document.location.href+"\"\tmethod=\"POST\" invite=\"false\" type=\"Event Invitation\" "+"content=\"I thought you might be interested in '<a href="+_regurl+">"+_eventname+"</a>' event. As you are in my friends list, you might get friend discount. Please <a href="+_regurl+">click</a> here to see the discount. <fb:req-choice url='"+_regurl+"' label='Confirm' />\">"+"<fb:multi-friend-selector\tshowborder=\"false\" actiontext=\"Invite Friends to Event\" rows=\"5\" bypass=\"cancel\"\tshowborder=\"false\" />"+"</fb:request-form>"+"</fb:fbml>");
	var popupdlg=new FB.UI.PopupDialog("Invite Friends",dynadiv,false,false);
	popupdlg.setContentWidth(630);
	popupdlg.setContentHeight(560);
	popupdlg.set_placement(FB.UI.PopupPlacement.center);
	popupdlg.show();
	FB_RequireFeatures(["XFBML"],function(){
		var content=new FB.XFBML.ServerFbml(dynadiv);
		FB.XFBML.Host.addElement(content);
	});
}
function popupFacebookLogin(sURL){
	_purpose="ONSUCCESSACTION";
	_onsuccessurl=sURL;
	FB.Connect.requireSession();
	FB.Facebook.get_sessionState().waitUntilReady(function(){
	processPostLogin();
});
return false;
}


