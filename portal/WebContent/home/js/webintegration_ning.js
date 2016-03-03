var webintegrationwindowleft=30;
var linkswindowleft = 300;
var invitefriendswindowleft=30;
var signuppartnerwindowleft=200;
var getsignupscreenwindowleft=200;
var commissionsettingswindowleft=30;
var makeRequestwindowleft=200;
var getloginscreenwindowleft=200;
var ourInterval;
var ajaxwin;

function testtrim(str)
{	var temp='';
	temp=new String(str);
	temp=temp.replace(/[^a-zA-Z 0-9]+/g,'');
	return temp;
}


function weblinks(url)
{
  document.location.href=url;
}

function hide(){
 ajaxwin.hide();

}

function webintegration(partnerid,groupid)
{ 
    ajaxwin=undefined;
	ajaxwin=dhtmlwindow.open("ajaxbox", "ajax", "http://www.eventbee.com/portal/webintegration/Webintegration.jsp?platform=ning&groupid="+groupid+"&partnerid="+partnerid, " My Network Ticket Selling > Website Integration > Text & Button Links", "width=550px, height=500px, left="+webintegrationwindowleft+"px, top=50px,resize=0,scrolling=1") 		
}

function invitefriends(partnerid,groupid)
{  	
ajaxwin=undefined;
ajaxwin=dhtmlwindow.open("ajaxbox", "ajax", "http://www.eventbee.com/portal/webintegration/Friends.jsp?platform=ning&groupid="+groupid+"&partnerid="+partnerid, "My Network Ticket Selling > Invite Friends", "width=550px, height=500px, left="+invitefriendswindowleft+"px, top=50px,resize=0,scrolling=1") 		
}

function commissionsettings(partnerid,groupid)
{  ajaxwin=undefined;

ajaxwin=dhtmlwindow.open("ajaxbox", "ajax", "http://www.eventbee.com/portal/webintegration/SetYourCommsion.jsp?groupid="+groupid+"&partnerid="+partnerid, "My Network Ticket Selling > Commission Settings", "width=550px, height=500px, left="+commissionsettingswindowleft+"px, top=50px,resize=0,scrolling=1") 
}
function makeRequest(url)
{
	ajaxwin=dhtmlwindow.open("ajaxbox", "ajax", url, "My Network Ticket Selling > Commission Settings", "width=650px, height=500px, left="+makeRequestwindowleft+"px, top=100px,resize=0,scrolling=1")
}
function getloginscreen(url)
{
	ajaxwin=dhtmlwindow.open("ajaxbox", "ajax", url, "Eventbee Login", "width=650px, height=500px, left="+getloginscreenwindowleft+"px, top=800px,resize=0,scrolling=1") 	
}



function getmailonsubmit(groupid){
    advAJAX.submit(document.getElementById("mails"), {
    onSuccess : function(obj) {
    var data=obj.responseText;
    data=testtrim(data);    
    if(data.indexOf("success")>-1){	
    weblinks('http://www.eventbee.com/portal/webintegration/links.jsp?platform=ning&success=yes&groupid='+groupid);
    }else 
	weblinks('http://www.eventbee.com/portal/webintegration/links.jsp?platform=ning&error=yes&groupid='+groupid);		
    },
    onError : function(obj) { alert("Error: " + obj.status); }
});
}
function change()
{
	 var i;
	 i= document.getElementById("upassword").value;
	 if(i<0||i>100){
		 document.getElementById('errordisp').innerHTML='<font color="red">Invalid earning %. Please enter valid %.</font>';
		 document.loginform.friends.value=0;
	}else{
		 document.getElementById('errordisp').innerHTML='';
		 var j=100-i;
		 document.loginform.friends.value=j;
	 }
	 
		 
}
function changeother()
{
    var i;
	i= document.getElementById("Mypercentage").value;
	if(i<0||i>100){
		document.getElementById('errordisp').innerHTML='<font color="red">Invalid earning %. Please enter valid %.</font>';
		 document.loginform.others.value=0;
		 
	 }else{
		 document.getElementById('errordisp').innerHTML='';
		 
		 var j=100-i;
		 document.loginform.others.value=j;
	 }
    
}
function submitcommission(groupid,partnerid){	
	var i;
	i= document.getElementById("Mypercentage").value;
	if(i<0||i>100){
		document.getElementById('errordisp').innerHTML='<font color="red">Invalid earning %. Please enter valid %.</font>';
		return;
	}
	i= document.getElementById("upassword").value;
	if(i<0||i>100){
		document.getElementById('errordisp').innerHTML='<font color="red">Invalid earning %. Please enter valid %.</font>';
		return;
	}
	advAJAX.submit(document.getElementById("commissionupdate"), {
	onSuccess : function(obj) {
	var data=obj.responseText;
	if(data.indexOf("Success")>-1){
	weblinks('http://www.eventbee.com/portal/webintegration/links.jsp?platform=ning&changed=y&groupid='+groupid+"&partnerid="+partnerid);
	}else{
		document.getElementById('errordisp').innerHTML='<font color="red">Invalid earning %. Please enter valid %.</font>';
	}	
	},
    onError : function(obj) { alert("Error: " + obj.status); 
    }
});
}
function checkAll(field)
{
for (i = 0; i < field.length; i++)
	field[i].checked = true ;
}
function uncheckAll(field)
{
for (i = 0; i < field.length; i++)
	field[i].checked = false ;
}




