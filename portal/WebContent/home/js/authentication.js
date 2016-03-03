var linkswindowleft = 300;
var signuppartnerwindowleft=200;
var getsignupscreenwindowleft=200;
var makeRequestwindowleft=200;
var getloginscreenwindowleft=200;
var ourInterval;
var ajaxwin;
var onsuccessURL;



function getsignupscreen(url)
{
	ajaxwin=dhtmlwindow.open("ajaxbox", "ajax", url, "Eventbee Sign Up", "width=650px, height=500px, left="+getsignupscreenwindowleft+"px, top=50px,resize=0,scrolling=1") 	
}

function getEventbeeLinkscreen(url)
{
	ajaxwin=dhtmlwindow.open("ajaxbox", "ajax", url, "Link Account", "width=400px, height=300px, left=300px, top=50px,resize=0,scrolling=1") 	
}


function closeAjaxWindow(){       
         if(ajaxwin)
	ajaxwin.hide('subcontent');
}


function signuponsubmit(onsuccessURL){	

    advAJAX.submit(document.getElementById("newsignup"), {			
    onSuccess : function(obj) {
	var data=obj.responseText;
	
    if(data.indexOf("success")>-1){	
	window.location.href=onsuccessURL;
	}
	else 
	getsignupscreen('/portal/fbauth/signup.jsp?showerr=y&onsuccessURL='+onsuccessURL);		
	},
    onError : function(obj) { alert("Error: " + obj.status); }
});
}
function setOnSuccessURL(pURL){
	onsuccessURL=pURL;
}
function validateLoginData(pURL){	
   onsuccessURL=pURL;
   //alert(pURL);
    advAJAX.submit(document.getElementById("login"), {			
    onSuccess : function(obj) {
	var data=obj.responseText;
	  
    if(data.indexOf("authenticated")>-1){	
	window.location.href=onsuccessURL;
	}
	else 
		document.getElementById('loginerror').innerHTML='<font color="red">Invalid login details</font>';
		//alert("Invalid login details");		
	},
    onError : function(obj) { alert("Error: " + obj.status); }
});
}

function linkaccounts(){	
    advAJAX.submit(document.getElementById("login"), {			
    onSuccess : function(obj) {
	var data=obj.responseText;
	
	
    if(data.indexOf("AUTHENTICATED")>-1){	
    window.location.reload(true);
	
	}
	else 
	{
		document.getElementById('loginerror').innerHTML='<font color="red">Invalid Eventbee Login Details</font>';
		//alert("Invalid Eventbee Login Details");
	
	}		
	},
    onError : function(obj) { alert("Error: " + obj.status); }
});

}
