var fbprofilelist=new Object();
var fbresponsedata=new Object();
var fbfriendsprofilelist=new Object();
var fbfriendsresponsedata=new Object();
var fbuserresponsedata=new Object();
var fbgenderlist = new Object();
var ebee_eid="";
var fbeid="";
var fbshowgenderlink="N";
var fballhtmldata='';
var fbboxtype="";
var num_of_entries=5;
var htmldata="";
function showFBAttendeeList(eid,fbeid){
   ebee_eid=eid;
   document.getElementById('fbattendeelist').innerHTML="<center><img src='http://static.ak.fbcdn.net/rsrc.php/v1/z9/r/jKEcVPZFk-2.gif' alt='Loading...' id='fb-loading'/></center>";
	hideotherdivs();
	new Ajax.Request('/socialnetworking/fbattend.jsp?timestamp='+(new Date()).getTime(), {
	  method: 'get',
	  parameters:{eventid:eid,fbeid:fbeid,showgenderlink:fbshowgenderlink},
	  onSuccess: FBAttendeesListResponse,
	  onFailure:  failureJsonResponse
  });
  
}

function FBAttendeesListResponse(response){
	var data=response.responseText;
	fbresponsedata=eval( '('+data+')' ) ;
	//var xmldata=fbresponsedata["xmldata"];
	//var xmlobject=jQuery.xml2json(xmldata);
	//var profilelist=fbresponsedata["data"];
	fbprofilelist=eval('('+fbresponsedata["data"]+')');
   
	//var profilelist=xmlobject.user;
		//fbprofilelist=xmlobject.user;
		fbeid=fbresponsedata["fbeid"];
		fbshowgenderlink=fbresponsedata["event.FBRSVPList.gendercount.show"];
		if(fbprofilelist!=undefined){
		 fillfbattendeelist("all");
	}
	else{
		if(document.getElementById('fbattend').innerHTML=="")
		document.getElementById('fbattend').innerHTML=" <div id='Searchresult'  style='display:none;margin-left:3px' ></div>";
		document.getElementById('Searchresult').innerHTML="<div class='small' style='margin-left:2px; padding-top:5px;'>Unable to retrieve Facebook Attendee List.</div>";
		document.getElementById('Searchresult').style.display='block';
		document.getElementById('fbattendeelist').innerHTML="";
		}
		
	FB.getLoginStatus(function(response) {
		if (response.authResponse) {
		//	fqlQuery('friendsdetails');
		}
		else{
		}
	});
}

function showFBFriendsAttendeeList(eid){
    document.getElementById('fbattendeelist').innerHTML="<center><img src='http://static.ak.fbcdn.net/rsrc.php/v1/z9/r/jKEcVPZFk-2.gif' alt='Loading...' id='fb-loading'/></center>";
	hideotherdivs();
	fqlQuery("friends");
}
/*
function FBFriendsAttendeesListResponse(response){
	var data=response.responseText;
	fbfriendsresponsedata=eval( '('+data+')' ) ;
	var profilelist=fbfriendsresponsedata["data"];
		fbfriendsprofilelist=fbfriendsresponsedata["data"];
	if(profilelist!=undefined){
		 fillfbattendeelist("friends");
	}
	else{
		var fbeventlink="http://www.facebook.com/event.php?eid="+fbresponsedata["fbeid"];
		var alink="<a href="+fbeventlink+" target='_blank'><div class='small'>"+fbprofilelist.length+" going on Facebook</div></a>";
		var fcount="";
		var listdisplink="<table width='95%' border='0' cellpadding='0' cellspacing='0'><tr><td align='left'><a href='javascript:getfblist(\"all\")'><span class='small bold' id='click_all'>All ("+fbprofilelist.length+")</span></a><span class='small'>&nbsp;|&nbsp;</span><a href='javascript:getfblist(\"friends\")'><span class='small' id='click_friends' style='font-weight:bold;'>Friends"+fcount+"</span></a></td><td align='right'>"+alink+"</td></tr></table>";			
		document.getElementById('fbattendeelist').innerHTML=listdisplink;
		document.getElementById('Searchresult').innerHTML="<div class='small' style='margin-left:2px; padding-top:5px;'>None of your friends going!</div>";
		document.getElementById('Searchresult').style.display='block';
		//document.getElementById('fbeventurl').style.display='block';
		document.getElementById('Pagination').style.display='none';
		
	}
	fqlQuery();
}
*/
function getjsonFormat(){
	var jsonFormat="{";
	jsonFormat=jsonFormat+'userid:\''+fbuserresponsedata.uid+'\'';
	jsonFormat=jsonFormat+',access_token:\''+fbuserresponsedata.access_token+'\'';
	jsonFormat=jsonFormat+',fbeid:\''+fbeid+'\'';
	jsonFormat=jsonFormat+"}";
	return jsonFormat;
}	

function fillfbattendeelist(showtype){
   if(document.getElementById('fbattend').innerHTML=="")
		document.getElementById('fbattend').innerHTML=" <div id='Searchresult'  style='display:none;margin-left:-1px;padding:0px;' ></div>  <div id='Pagination' style='display:none;margin-left:-1px;padding:0px;'></div><div id='fbeventurl' style='display:none;margin-left:-1px;padding:0px;' ></div>";
		
    var profilelist=new Object();
	if(showtype=="all"){
		profilelist=fbprofilelist;
		if(fbgenderlist.fballlistmale!=undefined)
			fbgenderlist.fballlistmale=undefined;
		if(fbgenderlist.fballlistfemale!=undefined)
			fbgenderlist.fballlistfemale=undefined;
	}
	else if(showtype == "friends"){
		profilelist=fbfriendsprofilelist;
		if(fbgenderlist.fbfriendslistmale!=undefined)
			fbgenderlist.fbfriendslistmale=undefined;
		if(fbgenderlist.fbfriendslistfemale!=undefined)
			fbgenderlist.fbfriendslistfemale=undefined;
	}
	else if(showtype!="all" && showtype!="friends"){
		profilelist=fbgenderlist[showtype];
		
	}
	

/*	if(profilelist!=undefined && profilelist.length>0){
var fbarraylist=new Array();
	var fbuidlist = new Object();
	
		for(var i=0;i<profilelist.length;i++){
			var pobj=profilelist[i];
			
			if(fbuidlist["fbuid"+pobj.uid]==undefined){
			fbuidlist["fbuid"+pobj.uid]=pobj.uid;
			fbarraylist.push(pobj);
			}
			}
			profilelist=fbarraylist;
	}*/
	
	htmldata="<div id='fbattendlist' style='display:none;'>";
	var pagecount=0;
	var pcount=0;
	if(profilelist!=undefined && profilelist.length>0){
		for(i=0;i<profilelist.length;i++){
			var pobj=profilelist[i];
			if(showtype=="all" || showtype=="friends"){
				if(fbgenderlist["fb"+showtype+"list"+pobj.sex]==undefined){
					var fbarray=new Array();
					fbarray.push(pobj);
					fbgenderlist["fb"+showtype+"list"+pobj.sex]=fbarray;
				}
				else{
					var fbarray=new Array();
					fbarray=fbgenderlist["fb"+showtype+"list"+pobj.sex];
					fbarray.push(pobj);
					fbgenderlist["fb"+showtype+"list"+pobj.sex]=fbarray;
				}
				
			}
			var name=pobj.name;
			var link="http://www.facebook.com/profile.php?id="+pobj.uid;
			var pic_link="<img src='https://graph.facebook.com/"+pobj.uid+"/picture' border='0' alt=''/>";
			if(pagecount==0){
				htmldata=htmldata+"<div class='fbattend'><table></tbody>";
			}
			pagecount++;
			if(pcount==0){
				htmldata=htmldata+"<tr>";
			}
			pcount++;
			htmldata=htmldata+"<td><a target='_blank' href='"+link+"'>"+pic_link+"<div style='width:  50px;text-align: center; cursor:pointer;' class='small'>"+name.split(" ")[0]+"</div></a></td>";
			if(fbboxtype=="2rows"){
				num_of_entries=15;
				if(pcount==11){
					pcount=0;
					htmldata=htmldata+"</tr>";
				}	
				
				if(pagecount==22){
					pagecount=0;
					htmldata=htmldata+"</tbody></table></div>";
				}
			}
			else{
				if(pcount==5){
					pcount=0;
					htmldata=htmldata+"</tr>";
				}	
				
				if(pagecount==15){
					pagecount=0;
					htmldata=htmldata+"</tbody></table></div>";
				}
			}
		}
	}
	else{
		setunavaillablemessage(showtype);
	}
	htmldata=	htmldata+"</div>";	
   var listdisplink=fblistdisplay();
	if(showtype=='all')
		fballhtmldata=htmldata;
		
	var plength=fbprofilelist.length;
		if(plength==1000){
			plength="1000+";
		}
		var fbeventlink="http://www.facebook.com/event.php?eid="+fbresponsedata["fbeid"];
		if(plength==undefined)plength=0;
		var alink="<a href="+fbeventlink+" target='_blank'><span class='small' style='display:block;font-size:12px;'>"+plength+" going on Facebook</span></a>";
		var rsvpbutton="";
		if(fbboxtype=="2rows"){
			rsvpbutton="<span><iframe  id='fb-rsvp-"+fbresponsedata["fbeid"]+"' name='fb-rsvp-"+fbresponsedata["fbeid"]+"'  src='"+""+"/fbrsvp?fbeid="+fbresponsedata["fbeid"]+"&source="+source+"&sec="+sec+"&domain="+domain+"&venueid="+venueid+"&fbuid="+fbuid+"&eid="+eid+"&record_id="+record_id+"&viewType=iframe;resizeIFrame=true&context=web'  frameborder='0' height='35px' width='400px' scrolling='no' allowtransparency='true'></iframe></span>";
		   }
		
		/*
	if(fbboxtype=="2rows"){
	document.getElementById('fbattendeelist').innerHTML="<table width='100%'><tr><td>"+listdisplink+"</td><td><span style='float:right;'>"+alink+"<span></td></tr></table>"+htmldata+"";	
	}
	else{
		document.getElementById('fbattendeelist').innerHTML=listdisplink+""+htmldata+"";	
	}
	*/
	
	document.getElementById('fbattendeelist').innerHTML="<table width='100%'><tr><td>"+listdisplink+"</td><td valign='top'><span style='float:right;'><span>"+rsvpbutton+"</td></tr></table>"+htmldata+"";	
		document.getElementById('fbeventurl').innerHTML="<br style='clear:both'><span style='float:left;'>"+alink+"</span>";
	if(profilelist!=undefined && profilelist.length>0)
		initPagination();
	else
		controlpagination();
	if(fbboxtype=="2rows"){
		document.getElementById('Searchresult').style.height="135px";
		document.getElementById('Searchresult').style.width="595px";
	}
    document.getElementById('Searchresult').style.display='block';
	document.getElementById('Pagination').style.display='block';
	document.getElementById('fbeventurl').style.display='block';
	getallclickfunctionality();
	if(showtype=="all"){
		jQuery('#click_all').attr('style','font-weight:bold;cursor:pointer;font-size:12px');		
		jQuery('#click_friends').attr('style','font-weight:lighter;cursor:pointer;font-size:12px');
	}
	else if(showtype == "friends"){
		jQuery('#click_friends').attr('style','font-weight:bold;cursor:pointer;font-size:12px');		
		jQuery('#click_all').attr('style','font-weight:lighter;cursor:pointer;font-size:12px');	
	}
	else if (showtype =='fballlistmale'){changetextstyle("fb-male-attend");}
	else if (showtype =='fballlistfemale'){changetextstyle("fb-female-attend");}
	else if (showtype =='fbfriendslistfemale'){changetextstyle("fb-female-friends");}
	else if (showtype =='fbfriendslistmale'){changetextstyle("fb-male-friends");}
}

function getallclickfunctionality(){
	jQuery('#click_all').click(function(){
		getfblist("all");
		
	});
	jQuery('#click_friends').click(function(){
		getfblist("friends");
	});
	if(fbshowgenderlink=='Y'){
		jQuery('#fb-male-attend, #fb-female-attend, #fb-male-friends, #fb-female-friends,#click_all,#click_friends').attr('style','font-weight:lighter;cursor:pointer;font-size:12px');
		jQuery('#fb-male-attend').click(function(){
		fillfbattendeelist("fballlistmale"); 
		changetextstyle("fb-male-attend");
		});	
		jQuery('#fb-female-attend').click(function(){
		fillfbattendeelist("fballlistfemale");
		changetextstyle("fb-female-attend");
		});	
		jQuery('#fb-male-friends').click(function(){
		getfbfriendsgenderattendeelist("fb-male-friends");
		changetextstyle("fb-male-friends");
		});	
		jQuery('#fb-female-friends').click(function(){
		getfbfriendsgenderattendeelist("fb-female-friends");
		changetextstyle("fb-female-friends");
		});	
	}
}

function fblistdisplay(){
	
	var fcount="";
	try{
		if(fbfriendsprofilelist.length>0){
			fcount=" ("+fbfriendsprofilelist.length+")";
		}
	}catch(err){}	
var fblistdisplay="<table width='auto' border='0px' cellpadding='0px' cellspacing='0px'><tbody><tr><td align='left'><span class='small' id='click_all'>All ("+fbprofilelist.length+")</span><span class='small'>&nbsp;|&nbsp;</span><span class='small' id='click_friends'>Friends"+fcount+"</span></td></tr></tbody></table>";
if(fbshowgenderlink=='Y'){
	//var fbmale="<span id='fb-male-attend' class='small'>M-0</span>",fbfemale="<span id='fb-female-attend' class='small'>&nbsp;F-0</span>",fbfriendmale="<span id='fb-male-friends' class='small'>M-0</span>",fbfriendfemale="<span id='fb-female-friends' class='small'>&nbsp;F-0</span>";
var fbmale="<span id='fb-male-attend' class='small'>M-0</span>",fbfemale="<span id='fb-female-attend' class='small'>&nbsp;F-0</span>",fbfriendmale="",fbfriendfemale="";
	if(fbgenderlist.fballlistmale!=undefined)
		fbmale="<span id='fb-male-attend' class='small'>M-"+fbgenderlist.fballlistmale.length+"</span>";

	if(fbgenderlist.fballlistfemale!=undefined)
		fbfemale="<span id='fb-female-attend' class='small'>&nbsp;F-"+fbgenderlist.fballlistfemale.length+"</span>";

if(fbgenderlist.fbfriendslistmale!=undefined && fbgenderlist.fbfriendslistfemale!=undefined){
		fbfriendmale="<span id='fb-male-friends' class='small'>(M-"+fbgenderlist.fbfriendslistmale.length+"</span>, ";

	//if(fbgenderlist.fbfriendslistfemale!=undefined)
		fbfriendfemale="<span id='fb-female-friends' class='small' >&nbsp;F-"+fbgenderlist.fbfriendslistfemale.length+")</span>";

		}else if(fbgenderlist.fbfriendslistmale!=undefined && fbgenderlist.fbfriendslistfemale==undefined){
			fbfriendmale="<span id='fb-male-friends' class='small'>(M-"+fbgenderlist.fbfriendslistmale.length+"</span>) ";
		}
		else if(fbgenderlist.fbfriendslistmale==undefined && fbgenderlist.fbfriendslistfemale!=undefined){
			fbfriendfemale="<span id='fb-female-friends' class='small' >(F-"+fbgenderlist.fbfriendslistfemale.length+")</span>";
		}
	fblistdisplay="<table width='70%' border='0px' cellpadding='0px' cellspacing='0px'><tbody><tr><td align='left'><span class='small' id='click_all'>All </span><span class='small'>(</span>"+fbmale+"<span class='small'>,</span>"+fbfemale+"<span class='small'>)&nbsp;|&nbsp;</span><span class='small' id='click_friends'>Friends </span>"+fbfriendmale+"<span class='small'></span>"+fbfriendfemale+"</td></tr></tbody></table>";
}

return fblistdisplay;
}

function changetextstyle(id){
	jQuery('#fb-male-attend, #fb-female-attend, #fb-male-friends, #fb-female-friends, #click_all,#click_friends').attr('style','font-weight:lighter;cursor:pointer;font-size:12px');	
	if (id == 'click_all'){
		jQuery("#click_all").attr('style','font-weight:bold;cursor:pointer; font-size:12px');
	}
	else if (id == 'click_friends'){
		jQuery("#click_friends").attr('style','font-weight:bold;cursor:pointer; font-size:12px');
	}
	else if(id=='fb-male-attend' || id=='fb-female-attend'){
		jQuery("#click_all, #"+id).attr('style','font-weight:bold;cursor:pointer; font-size:12px');
	}
	else if(id=='fb-male-friends' || id=='fb-female-friends'){
		jQuery("#click_friends, #"+id).attr('style','font-weight:bold;cursor:pointer; font-size:12px');
	}
	
}


function setunavaillablemessage(showtype){
	if(showtype=="friends"){
		document.getElementById('Searchresult').innerHTML="<div class='small' style='margin-left:2px; padding-top:5px;'>None of your friends going!</div>";
		changetextstyle("click_friends");
	}
	else if(showtype=="fballlistmale"){
		document.getElementById('Searchresult').innerHTML="<div class='small' style='margin-left:2px; padding-top:5px;'>There are no Male attendees!</div>";
		changetextstyle("fb-male-attend");
	}
	else if(showtype=="fballlistfemale"){
		document.getElementById('Searchresult').innerHTML="<div class='small' style='margin-left:2px; padding-top:5px;'>There are no Female attendees!</div>";
		changetextstyle("fb-female-attend");
	}
	else if(showtype=="fbfriendslistmale"){
		document.getElementById('Searchresult').innerHTML="<div class='small' style='margin-left:2px; padding-top:5px;'>None of your Male friends going!</div>";
		changetextstyle("fb-male-friends");
	}
	else if(showtype=="fbfriendslistfemale"){
		document.getElementById('Searchresult').innerHTML="<div class='small' style='margin-left:2px; padding-top:5px;'>None of your Female friends going!</div>";
		changetextstyle("fb-female-friends");
	}
}

function getfbfriendsgenderattendeelist(id){
	 FB.login(function(response){
        if(response.authResponse){
			fqlQuery(id);
		}
		else{
				document.getElementById('Searchresult').innerHTML="<div class='small' style='margin-left:2px; padding-top:5px;'>You need to <span id='fb-login'>Login</span> to see your friends!</div>";
				jQuery("#fb-login").attr("style","font-weight:bold;cursor:pointer;");
				jQuery("#fb-login").click(function(){getfbfriendsgenderattendeelist(id)});
				changetextstyle(id);
				controlpagination();
					
			//changetextstyle(lastshowtype);
		}
	});	
}

function pageselectCallback(page_index, jq){
	var new_content = jQuery('#fbattendlist div.fbattend:eq('+page_index+')').clone();
	jQuery('#Searchresult').empty().append(new_content);
	return false;
}

function initPagination() {
	var num_entries = jQuery('#fbattendlist div.fbattend').length;
		jQuery("#Pagination").pagination(num_entries, {
			callback: pageselectCallback,
			items_per_page:1 // Show only one item per page
		});
	
 }
  
 function controlpagination(){
	var num_entries = jQuery('#fbattendlist div.fbattend').length;
		jQuery("#Pagination").pagination(1, {
			items_per_page:1 // Show only one item per page
		});
 }
  
  function getfblist(listtype){
	if(listtype=="all"){
		$('Searchresult').innerHTML="";
		$('Pagination').innerHTML="";
		showFBAttendeeList(ebee_eid,fbeid);	
		}
	else if (listtype=="friends"){
		getfblogindetails();
		
	}
}

function hideotherdivs(){
	if($('Searchresult')){
		$('Searchresult').hide();
	}
	if($('Pagination')){
		$('Pagination').hide();
	}
	if($('fbeventurl')){
		$('fbeventurl').hide();
	}
	
}

function getfblogindetails(){
        FB.login(function(response){
         if(response.authResponse){
                      fbuserresponsedata=response.authResponse;
					  showFBFriendsAttendeeList(ebee_eid);
					  
				}
               else{
					document.getElementById('Searchresult').innerHTML="<div class='small' style='margin-left:2px; padding-top:5px;'>You need to <span id='fb-login'>Login</span> to see your friends!</div>";
				jQuery("#fb-login").attr("style","font-weight:bold;cursor:pointer;");
				jQuery("#fb-login").click(function(){getfblogindetails()});
				changetextstyle("click_friends");
					controlpagination();
					
					  } 
       
       })
}
 
function failureJsonResponse(){
alert("Sorry this request cannot be processed at this time");
}

function getfriendslinkdisplay(){
	fillfriendslistforid("onlyassing");
	var listdisplink=fblistdisplay();
	var rsvpbutton="";
	
		if(fbboxtype=="2rows"){
			rsvpbutton="<span><iframe  id='fb-rsvp-"+fbresponsedata["fbeid"]+"' name='fb-rsvp-"+fbresponsedata["fbeid"]+"'  src='"+""+"/fbrsvp?fbeid="+fbresponsedata["fbeid"]+"&source="+source+"&sec="+sec+"&domain="+domain+"&venueid="+venueid+"&fbuid="+fbuid+"&eid="+eid+"&record_id="+record_id+"&viewType=iframe;resizeIFrame=true&context=web'  frameborder='0' height='35px' width='400px' scrolling='no' allowtransparency='true'></iframe></span>";
		}
	//document.getElementById('fbattendeelist').innerHTML=listdisplink+""+fballhtmldata+"";	
	document.getElementById('fbattendeelist').innerHTML="<table width='100%'><tr><td>"+listdisplink+"</td><td valign='top'><span style='float:right;'><span>"+rsvpbutton+"</td></tr></table>"+htmldata+"";	
	changetextstyle("click_all");
	getallclickfunctionality();
}

 function fqlQuery(attendeeid){
                    var complfrienddata="";
					FB.login(function(response){
						FB.api('/me', function(response) {
						
				var query= FB.Data.query('SELECT uid, name, sex FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1={0}) and uid IN (SELECT uid FROM event_member WHERE eid in('+fbeid+') and rsvp_status="attending") order by name',response.id);
						//var query= FB.Data.query('SELECT uid, name, sex FROM user WHERE uid IN (SELECT uid FROM event_member WHERE eid={0} and rsvp_status="attending") order by name',fbeid);
						 query.wait(function(rows) {
								fbfriendsprofilelist=rows;
								//if(fbfriendsprofilelist.length>0){
									if(attendeeid=="friends")
										fillfbattendeelist(attendeeid);
									else if(attendeeid=='friendsdetails'){
										getfriendslinkdisplay();
									}
									else
									{
										fillfriendslistforid(attendeeid);
									}
							//}
								//else{
								//	alert("dsfds");
								//}

						 });
					});
				});
            }
 
function fillfriendslistforid(id){
		var friend_gender_type="";
		if(id=="fb-male-friends"){
			friend_gender_type="fbfriendslistmale";
		}
		else if (id=='fb-female-friends'){
			friend_gender_type="fbfriendslistfemale";
		}
		else{
			friend_gender_type='onlyassign';
		}
		if(fbgenderlist.fbfriendslistmale!=undefined)
			fbgenderlist.fbfriendslistmale=undefined;
		if(fbgenderlist.fbfriendslistfemale!=undefined)
			fbgenderlist.fbfriendslistfemale=undefined;
		
			if(fbfriendsprofilelist.length>0){
				for(i=0;i<fbfriendsprofilelist.length;i++){
				var pobj=fbfriendsprofilelist[i];
				    
					if(fbgenderlist["fbfriendslist"+pobj.sex]==undefined){
						var fbarray=new Array();
						fbarray.push(pobj);
						fbgenderlist["fbfriendslist"+pobj.sex]=fbarray;
					}
					else{
						var fbarray=new Array();
						fbarray=fbgenderlist["fbfriendslist"+pobj.sex];
						fbarray.push(pobj);
						fbgenderlist["fbfriendslist"+pobj.sex]=fbarray;
					}
					
				}
				if(friend_gender_type!='onlyassign'){
					fillfbattendeelist(friend_gender_type);
				}
			}
			else{
			
				if(friend_gender_type!='onlyassign'){	
					fillfbattendeelist(friend_gender_type);
				}	
			}
		
	}

	function login(){
	FB.api('/me', function(response) {
		//document.getElementById('login').style.display = "block";
		//document.getElementById('login').innerHTML ="<font style='background-color:#3b5998;padding:5px;' color='#FFFFFF'><b>"+response.name + "</b> successfully logged in!</font>";
	});
}
function logout(){
	//document.getElementById('login').style.display = "none";
}



function detals(){
var attendeeJson='';
var access_token='';
// var  div         = document.getElementById('session'),
  showSession = function(response) {
  access_token=response.authResponse['access_token'];
  };
  
FB.getLoginStatus(function(response) {
  showSession(response);
  FB.Event.subscribe('auth.sessionChange', showSession);
});
}
 
            //stream publish method
            function streamPublish(name, description, hrefTitle, hrefLink, userPrompt){
                FB.ui(
                {
                    method: 'stream.publish',
                    message: 'hi, this is just for fb api testing',
                    attachment: {
                        name: 'invitation',
                        caption: 'easy learning',
                        description: 'this is just for testing of stream publish on facebook',
                        href: 'http://www.eventbee.com'
                    },
                    action_links: [
                        { text: 'invitation', href: 'http://www.eventbee.com' }
                    ],
                    user_prompt_message: 'come as well'
                },
                function(response) {
 
                });
 
            }
            function showStream(){
                FB.api('/me', function(response) {
                    //console.log(response.id);
                    streamPublish(response.name, 'eventbee.com', 'hrefTitle', 'http://eventbee.com', "Share eventbee.com");
                });
            }
 
            function share(){
                var share = {
                    method: 'stream.share',
                    u: 'http://www.eventbee.com/'
                };
 
                FB.ui(share, function(response) { console.log(response); });
            }
			
            function graphStreamPublish(){
                var my_msg="Hi, this is just a test for Stream Publish of fb api.";
                var URL="http://localhost/";
                var title="invitation";
                var desc="this is just a test for stream publish";
                var pic_URL="http://eventbee.com/home/images/logo_big.jpg";
                FB.api('/me/feed', 'post', { message:my_msg,link:URL,name:title,description:desc,picture:pic_URL }, function(response) {
                    if (!response || response.error) {
                        alert('Error occured');
                    } else {
                        alert('Post ID: ' + response.id);
                    }
                });
            }
 
           
            function setStatus(){
                status1 = document.getElementById('status').value;
                FB.api(
                  {
                    method: 'status.set',
                    status: status1
                  },
                  function(response) {
                    if (response == 0){
                        alert('Your facebook status not updated. Give Status Update Permission.');
                    }
                    else{
                        alert('Your facebook status updated');
                    }
                  }
                );
            }

      

