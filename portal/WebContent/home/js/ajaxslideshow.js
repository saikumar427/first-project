//var allphotos;
var allcaptions=new Array(1);
var allphotos=new Array(1);
var allphotosnames=new Array(1);

//var allphotosnames;
var showfor = 5000;
var cTimer = null;
var currentphoto=0;
var sourceURL = "";
var playing=0;
var playWithSpeed=5000;



var speeds=new Array("20000","10000","8000","5000","3000","1500","1");

function changeText(){
	var html1='<a HREF="#"  ONCLICK="replayLoad();return false"><img src="/home/images/play_ro.gif"/></a><br/>'
	html1+='<a HREF="#"  ONCLICK="replayLoad();return false">Play</a>';
	if(playing<1&&currentphoto<allphotos.length-1){
		html1='<a HREF="#"  ONCLICK="stopDisplay();return false"><img src="/home/images/pause_ro.gif"/></a><br/>'
		html1+='<a HREF="#" ONCLICK="stopDisplay();return false">Pause</a>'
	}
document.getElementById('change').innerHTML=html1;
}

function showNext(){
	var html1='<a HREF="#"  ONCLICK="loadNextPhoto();return false"><img src="/home/images/next_ro.gif"/></a><br/>'
	html1+='<a HREF="#"  ONCLICK="loadNextPhoto();return false">Next</a>';
	document.getElementById('next').innerHTML=html1;
}


function showPrevious(){
	var html1='<a HREF="#"  ONCLICK="loadPreviousPhoto();return false"><img src="/home/images/prev_ro.gif"/></a><br/>'
	html1+='<a HREF="#"  ONCLICK="loadPreviousPhoto();return false">Previous</a>';
	document.getElementById('previous').innerHTML=html1;
}


function changeCaption(){
//alert("change caption---->"+currentphoto);
	var position=currentphoto
	
	if(position<0) position=0
	
	var html1=allcaptions[position];
	document.getElementById('cpt').innerHTML=html1;
	
	document.getElementById('phtname').innerHTML=allphotosnames[position];
	
}




function setSpd(speed,speedpos) {
//alert("set spd method---");
playWithSpeed=speed;
	for(var i=0;i<7;i++){
	tmpObj = eval('document.sp' + i);
		if(speedpos==i){
			tmpObj.src="/home/images/on.gif";
		}else{
			tmpObj.src="/home/images/off.gif";
		}
	}
}


function showPhotos() {
	clearTimeout(cTimer)
	if (sourceURL!="") {
		document.images.slideShow.src = sourceURL
	}

}

function displayImageFrom() {
	sourceURL = this.src
	if (cTimer==null) showPhotos()
}
function replayLoad() {
	document.getElementById('previous').innerHTML='';
	showNext();
	playing=10;
	if (currentphoto>=allphotos.length) currentphoto=-1
	else
	currentphoto-=1
	showfor=100;
	doLoad()
	playWithSpeed=5000;
}

function doLoad() {
//	alert(allphotos.length);
	if(playing>0||currentphoto+1>=allphotos.length){
		playing=0;
		changeText();
		
	}

	if(currentphoto==0){
	  	
		document.getElementById('previous').innerHTML='';
	}else if(currentphoto-1==0){
		showPrevious()
	}
	if(currentphoto>=allphotos.length-1){
	
		document.getElementById('next').innerHTML='';
	}else if(currentphoto+1==allphotos.length){
	   //	alert("do load method 4");

		showNext()
	}
	clearTimeout(cTimer)
	var img = new Image()
	img.onload = displayImageFrom
	sourceURL = ""
	showfor=playWithSpeed
	//alert(showfor);
	cTimer = setTimeout("cTimer=null;showPhotos()",showfor)
	changeCaption()
	currentphoto++

	img.src = allphotos[currentphoto]


}
function changePosition(position){
if(position>0){
	currentphoto=position-1;
	}
	doLoad();
}
function loadNextPhoto() {
	showPrevious()
	clearTimeout(cTimer)
	cTimer=null
	var img = new Image()
	img.onload = displayImageFrom
	// alert(img.onload);

	changeCaption()
	img.src = allphotos[currentphoto]
}

function loadPreviousPhoto() {

	showNext()
	clearTimeout(cTimer)
	cTimer=null
	var img = new Image()
	img.onload = displayImageFrom
	currentphoto-=2
	if (currentphoto<0) currentphoto=0
	changeCaption()
	img.src = allphotos[currentphoto]
}
function stopDisplay(){

	playing=1;
	changeText()
	changeCaption()
	clearTimeout(cTimer)
}


function setSpeed() {
	var k=0;
	for(var i=0;i<speeds.length;i++)
	{
		if(playWithSpeed==speeds[i]&&i<speeds.length-1)
		{
			playWithSpeed=speeds[i+1];
			k=1;
			break;

		}
	}
	if(k==0)playWithSpeed=5000;
}








var http_request = false;
var divid;
   function makeSlideShowRequest(url, id) {
   divid=id;
   document.getElementById('slideshowbutton').style.display='none';
   
      http_request = false;
      if (window.XMLHttpRequest) { // Mozilla, Safari,...
         http_request = new XMLHttpRequest();
         if (http_request.overrideMimeType) {
            http_request.overrideMimeType('text/xml');
         }
      } else if (window.ActiveXObject) { // IE
         try {
            http_request = new ActiveXObject("Msxml2.XMLHTTP");
            
            } catch (e) {
            try {
               http_request = new ActiveXObject("Microsoft.XMLHTTP");
               } catch (e) {}
         }
      }
      if (!http_request) {
         alert('Cannot create XMLHTTP instance');
         return false;
      }
      http_request.onreadystatechange = alertContents;
      http_request.open('GET', url , true);
      http_request.send(null);
   }
   
   
   
   
   
   function alertContents() {
      if (http_request.readyState == 4) {
         if (http_request.status == 200) {
            var xmldoc = http_request.responseXML;
            if (window.ActiveXObject){
            	xmldoc.load(http_request.responseStream);
               }  
            var photos = xmldoc.getElementsByTagName('photo');
					
            var cnt=0;
            currentphoto=0;
            allcaptions=new Array(photos.length);
            allphotos=new Array(photos.length);
			allphotosnames=new Array(photos.length);
            //alert(allcaptions.length);
            for (var iNode = 0; iNode < photos.length; iNode++) {
            	var photo=photos.item(iNode);
            	var names = photo.getElementsByTagName('name');
            	//alert("names.lenth--->"+names.length);
            	
            	for (var x = 0; x < names.length; x++) {
            		var name=names.item(x).childNodes.item(0);
            		allphotosnames[cnt]=name.data;
            		//alert(allphotosnames[x]);
            		//alert(x);
            		
               	}
               	//cnt=0;
               	var urls = photo.getElementsByTagName('url');
            	for (var x = 0; x < urls.length; x++) {
            		var url=urls.item(x).childNodes.item(0);
            		allphotos[cnt]=url.data;
               	}
               	//cnt=0;
               	var captions = photo.getElementsByTagName('photocaption');
               
            	for (var x = 0; x < captions.length; x++) {
            		var photocaption=captions.item(x).childNodes.item(0);
            		if(photocaption)
            			allcaptions[cnt]=photocaption.data;
            		else
            			allcaptions[cnt]='';
            		
               	}
               	cnt++;
            }
			
			
				
		var photo="<center><IMG NAME=slideShow SRC= "+allphotos[currentphoto] + " ONLOAD='doLoad()'/></center>";
		var photocaption="<div id='cpt' valign='top' align='center' height='500'>"+allcaptions[currentphoto]+"</div>";
		var photoname="<div id='phtname' valign='top' align='center' height='500'>"+allphotosnames[currentphoto]+"</div>";


        var slideshowarrow="Close SlideShow<a href='#' onclick='collapse()' ><img src='/home/images/pointervertical.gif'></a>";
								
		var previousimg="<span id='previous' ><a href='#'  onClick='loadPreviousPhoto();return false'>"
		+"<img src='/home/images/prev_ro.gif'/></a><br/>"
		+"<a href='#' onClick='loadPreviousPhoto();return false' >Previous</a></span>";

		var nextimg="<span id='next' ><a href='#'  onClick='loadNextPhoto();return false'>"
		+"<img src='/home/images/next_ro.gif'/></a><br/>"
		+"<a href='#' onClick='loadNextPhoto();return false' >Next</a></span>";

		var startStopImg="<span id='change' ><a href='#'  onClick='stopDisplay();return false'>"
		+"<img src='/home/images/pause_ro.gif'/></a><br/>"
		+"<a href='#' onClick='stopDisplay();return false' >Pause</a></span>";
		
		var speedbar="<span id='speed' valign='top' height='500'><nobr>"
		+"<a href=javascript:setSpd(20000,'0'); ><img src='/home/images/off.gif' name=sp0 border=0 hspace=1 width=3 height=20></a>&nbsp;"
		+"<a href=javascript:setSpd(10000,'1'); ><img src='/home/images/off.gif' name=sp1 border=0 hspace=1 width=3 height=20></a>&nbsp;"
		+"<a href=javascript:setSpd(8000,'2'); ><img src='/home/images/off.gif' name=sp2 border=0 hspace=1 width=3 height=20></a>&nbsp;"
		+"<a href=javascript:setSpd(5000,'3'); ><img src='/home/images/off.gif' name=sp3 border=0 hspace=1 width=3 height=20></a>&nbsp;"
		+"<a href=javascript:setSpd(3000,'4'); ><img src='/home/images/off.gif' name=sp4 border=0 hspace=1 width=3 height=20></a>&nbsp;"
		+"<a href=javascript:setSpd(1500,'5'); ><img src='/home/images/off.gif' name=sp5 border=0 hspace=1 width=3 height=20></a>&nbsp;"
		+"<a href=javascript:setSpd(1,'6'); ><img src='/home/images/off.gif' name=sp6 border=0 hspace=1 width=3 height=20></a>&nbsp;"
		+"<center><a href='#' onclick='setSpeed();return false'>Speed</a></center></a></nobr></span>";

var htmlcontent="<table>"
+"<tr>"
+"<td width='1%'>"+previousimg+"</td>"
+"<td width='1%'>"+nextimg+"</td>"
+"<td width='1%'>"+startStopImg+"</td>"
+"<td width='3%'>"+speedbar+"</td>"
+"<td >"+slideshowarrow+"</td>"
+"</tr>"
+"</table>"
+"<table >"
+"<tr>"
+"<td>"
+photoname
+"</td>"
+"</tr>"
+"<tr>"
+"<td>"
+photo
+"</td>"
+"</tr>"
+"<tr>"
+"<td>"
+photocaption
+"</td></tr>"
+"</table>";	
				
					document.getElementById(divid).innerHTML=htmlcontent;
					} else {
            alert('There was a problem with the request.');
         }
      }
}


function showphotolist(photourl){
document.getElementById('photolist').innerHTML='Loading....';
advAJAX.get( {
	url : photourl,
    onSuccess : function(obj) {
    //alert(obj.responseText);
    document.getElementById('photolist').innerHTML='';
    document.getElementById('smallslidephotos').innerHTML='';
    document.getElementById('ajaxslideshow').innerHTML='';
    document.getElementById('photolist').innerHTML=obj.responseText;
    },
    
	onError : function(obj) { alert("Error: " + obj.status); }
});
}



function insertphotocomments(){
advAJAX.submit(document.getElementById("photocomments"), {
    onSuccess : function(obj) {
	var data=obj.responseText;
	document.getElementById('commentblock').style.display='none';
	document.getElementById('photocommts').innerHTML=data;
	
	},
	
	
    onError : function(obj) { alert("Error: " + obj.status); }
});

return false;
}


function testtrim(str)
{
var temp='';
temp=new String(str);
temp=temp.replace(/[^a-zA-Z 0-9]+/g,'');

//alert("in the testtrim------->"+temp);
return temp;



}


function loginforcommets(){
advAJAX.submit(document.getElementById("photologin"), {
    onSuccess : function(obj) {
    
    
	var data=obj.responseText;
	data=testtrim(data);
	//alert(data.length);
	//alert(data);
	if(data=='failure')
	{
	document.getElementById('loginerrormsg').style.color='red';
	document.getElementById('loginerrormsg').innerHTML='Invalid Login';
	}else{
	document.getElementById('loginblock').style.color='red';
	document.getElementById('loginblock').innerHTML='Successfully Logged in.Click on Post a Commment button';
	//document.getElementById('logsucess').innerHTML='Successfully Logged in.Click on Post a Commment button';
	
	
	
	}
	
	
	},
	
	
    onError : function(obj) { alert("Error: " + obj.status); }
});

return false;
}



