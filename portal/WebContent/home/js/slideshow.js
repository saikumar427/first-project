var allphotos;
var allcaptions;
var allphotosnames;
var showfor = 5000;
var cTimer = null;
var currentphoto;
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
	var position=currentphoto
	if(position<0) position=0
	var html1=allcaptions[position];
	document.getElementById('cpt').innerHTML=html1;
	document.getElementById('phtname').innerHTML=allphotosnames[position];
}




function setSpd(speed,speedpos) {
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
	if(playing>0||currentphoto+1>=allphotos.length){
		playing=0;
		changeText()
	}
	if(currentphoto==0){
		document.getElementById('previous').innerHTML='';
	}else if(currentphoto-1==0){
		showPrevious()
	}
	if(currentphoto>=allphotos.length-1){
		document.getElementById('next').innerHTML='';
	}else if(currentphoto+1==allphotos.length){
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

function loadNextPhoto() {
	showPrevious()
	clearTimeout(cTimer)
	cTimer=null
	var img = new Image()
	img.onload = displayImageFrom
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


