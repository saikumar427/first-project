
/*facebook share popup begins*/
var fbtype='';
var twitter;
var tweeting=false;
var eventURL="";
twttr.anywhere(function (T) {
		twitter=T;
		T.bind("authComplete", function (e, user) {
			twtUser=user;
			if(!tweeting)
			getTwitterNTScode(user,eventid);
		});
 });
function getconfirmationfbsharepopup(){
	if(!$('fb-root')){
		var divroot=document.createElement("div");
		divroot.setAttribute('id','fb-root');
		var cell=$('registration');
		cell.appendChild(divroot);
	}
	ebeepopup.setContent("<div id='fbshareblock'></div>");
	ebeepopup.show();
	var fbappid='';
	if(ntsdata["fbappid"]!=undefined)
		fbappid=ntsdata["fbappid"];
	jQuery('#fbshareblock').load('/volume/socialnetworking/fbpopupshare.jsp?eid='+eventid+'&ntsenable='+ntsdata["nts_enable"]+'&fbappid='+fbappid+'',function(response,status){
		$('fbshareblock').style.display='block';
		jQuery('#share-on-facebook').attr("style","cursor:pointer;");
					if($("fbshareblock"))

		jQuery('#share-on-facebook').click(function(){
			ebeepopup.hide();
			fbtype='fbshare';
			fbcommon();
			return false;
		});
	});
}


function closesharepopup(){
	if(document.getElementById("backgroundPopup"))
		document.getElementById("backgroundPopup").style.display='none';
	if(document.getElementById("fbshareblock"))
		document.getElementById("fbshareblock").style.display='none';
}

function getNTScode(response,eid){
var fbid=response.id;
	new Ajax.Request('/volume/embedded_reg/getntscode.jsp?timestamp='+(new Date()).getTime(),{
	method: 'get',
	parameters:{eid:eid,fbuserid:fbid,fname:response["first_name"],lname:response["last_name"],email:response["email"],network:'facebook'},
	onSuccess: getNTScoderesponse
	});
}

function getNTScoderesponse(response){
	var data=response.responseText;
	var responsedata=eval('(' + data + ')');
	ntscode=responsedata.ntscode;
	display_ntscode=responsedata["display_ntscode"];
	if(fbtype!='fbattendee'){
		if(fbtype=='conffbshare')
			fbfeed();
		else	
			streamPublish('Eventbee', 'eventbee.com', 'hrefTitle', 'http://eventbee.com', "Share eventbee.com");
		}
	updateRegistrationNTSCode(ntscode);
}

function updateRegistrationNTSCode(ntscode){
	new Ajax.Request('/volume/embedded_reg/updatentsaction.jsp?timestamp='+(new Date()).getTime(),{
		method:'post',
		parameters:{ntscode:ntscode,eid:eventid,tid:tranid}
	});
}


function storepostinfo(postid,eid){
	var uid=postid.split("_")[0];
	new Ajax.Request('/volume/socialnetworking/fbboughtdetails.jsp?timestamp='+(new Date()).getTime(), {
	  method: 'get',
	  parameters:{eid:eid,fbpostid:postid,fbuid:uid,posttype:"Share"},
	  onSuccess: postresponse
	 // onFailure:  failureJsonResponse
  });
 }
 
 function loginwithtoken(fbuid){
	var url='/attendee/authtoken?fbuid='+fbuid;
    var ajax= new Ajax.Request(url, { method:'get',
	onSuccess: function(t){
	  	window.location.href="/attendee/mypurchases/home?aid="+t.responseText; 
	},
	onFailure: function(){
			}
  				});
            
            }
 
 function postresponse(response){
 }
 var checkfblogin=function(func){
  	FB.getLoginStatus(function(response) {
        if (response.authResponse) {
			func();
                    }else{
          				fblogin(func);          	
                    }
                }, {scope:'publish_stream,email'});
 }
 var fblogin=function(func){
  	FB.login(function(response) {
  		if (response.authResponse) {
    			func();
  		}
	}, {scope:'publish_stream,email'});
 }
 function fbcommon(){
 FB.login(function(response1){
 FB.api('/me', function(response) {
					if(response.id!=undefined){
					ntsdata["fbuid"]=response.id;
					ntsdata["fbuname"]=response.name;
						// if(display_ntscode=='')
						// {
						 getNTScode(response,eventid);
						 if(fbtype=='fbattendee')
					     loginwithtoken(response.id);
					// }else{
					// if(fbtype=='fbattendee'){
						// loginwithtoken(response.id);
						// }
						// else{
						// if(fbtype=='conffbshare')
							// fbfeed();
						// else
						// streamPublish('Eventbee', 'eventbee.com', 'hrefTitle', 'http://eventbee.com', "Share eventbee.com");
						// }
					// }
					}
                });
				});
 }
/********************************************************Twitter Start***********************************************************/
var twtUser;
function getTwitterNTScode(user,eid){
	new Ajax.Request('/volume/embedded_reg/getntscode.jsp?timestamp='+(new Date()).getTime(),{
	method: 'get',
	parameters:{eid:eid,fbuserid:user.id,fname:user.data("name"),lname:'',email:'',network:'twitter'},
	onSuccess: getTwitterNTScoderesponse
	});
}
function getTwitterNTScoderesponse(response){
	var data=response.responseText;
	var responsedata=eval('(' + data + ')');
	ntscode=responsedata.ntscode;
	display_ntscode=responsedata["display_ntscode"];
	var tweeturl=getEventUrl(display_ntscode);
	getShortUrl(tweeturl);
	}

function publishToTwitter(tweeturl){
       ebeepopup.setContent("<img src='/main/images/tweet.png' height='27'><div id='tbox'></div>");
       ebeepopup.popupelement.style.left="3%";
	   ebeepopup.setDraggable(true);
	   ebeepopup.show();
       //var linkurl=getEventUrl();
       tweeting=true;
       twttr.anywhere(function (T) {
               T("#tbox").tweetBox({
                       label:"Tweet about this event",
                       defaultContent: "I just registered for "+caption+", "+tweeturl+" via @"+capmsg,
                       onTweet:function(a,b){
                               ebeepopup.hide();
                               promoteTweet(T.currentUser);
                       }
               });
       });
}
 
function promoteTweet(user){
	if(display_ntscode!=''){
		ntsdata["fbuname"]=user.data("name");
		ntsdata["fbuid"]=user.id;
		insertPromotion(eventid,'twitter');
	}
}
/********************************************************Twitter End****************************************************************/
function getShortUrl(url)
{
var surl="";
var returl=url;
surl='/volume/utworks/shortUrl.jsp';
new Ajax.Request(surl,{
method:'get',
parameters:{longUrl:url},
onSuccess:function(t)
{var jsonurlData=t.responseText;
   var urlData=eval('(' + jsonurlData + ')');
    if(urlData.status_code=='200')
   { returl=urlData.data.url;
     setOver(returl);
   }   
    else
   {returl=url;   
   setOver(returl);
   }
},
onFailure:function(){returl=url;setOver(returl)}
});

   
}
function setOver(returl)
{
//document.getElementById('res').innerHTML="<a href="+returl+" target='_blank'>"+returl+"</a>";
publishToTwitter(returl);
}
 function insertPromotion(eid,network){
	new Ajax.Request('/volume/socialnetworking/insertpromotion.jsp?timestamp='+(new Date()).getTime(), {
	  method: 'get',
	  parameters:{eid:eid,name:ntsdata["fbuname"],fbuid:ntsdata["fbuid"],nts_code:display_ntscode,network:network},
	  onSuccess: promosuccess
	 // onFailure:  failureJsonResponse
  })
 }
 function promosuccess(){
	//alert("inserted");
 }
 function showSharingOptions(){

	jQuery('#shareblock').load('/volume/socialnetworking/socialshare.jsp?eid='+eventid+'&tid='+tranid+'&pagein='+pagein,function(response,status){
		jQuery('#fbconfshare').click(function(){
			fbtype='conffbshare';
			fbcommon();
			return false;
		}).attr("style","cursor:pointer;");
		jQuery('#conftweet').click(function(){
			//if(display_ntscode!='') publishToTwitter();
			//else 
//	tweeting=false;
			if(twtUser!=undefined) getTwitterNTScode(twtUser,eventid)
			else twitter.signIn();
		}).attr("style","cursor:pointer;");
	});
 }
 
 
 
 