var uid="";
function sucessLoad()
{
//("load"+elmId+" "+frmId);
if(document.getElementById('loadvol')){
document.getElementById('loadvol').style.display="none";
}

	
	if(document.getElementById(frmId))
	document.getElementById(frmId).style.display="block";
	if(document.getElementById(elmId))
	document.getElementById(elmId).style.display="block";
	
	var h=document.getElementById(frmId).style.height;
	if(h!=undefined && h==0)
	_EbeeStartResize();
}
function callblockAload(id)
{
	
if(document.getElementById("backgroundPopup11"))
{}
else{
var backgroundPopup=document.createElement("div");
						backgroundPopup.setAttribute('id','backgroundPopup11');
						var cell=document.getElementById("container_"+id);
						cell.appendChild(backgroundPopup);
						backgroundPopup.style.cssText="background-color: #080808;display: none;height: 4000px;left: 0;opacity: 0.5;position: absolute;top: 0;width: 100%;z-index: 1000;";
}

document.getElementById("backgroundPopup11").style.display='block';

if(document.getElementById("loadvol"))
{}
else{
var loadvol=document.createElement("div");
						loadvol.setAttribute('id','loadvol');
						var cell=document.getElementById("container_"+id);
						cell.appendChild(loadvol);						
}

                document.getElementById("loadvol").style.display="block";
			    document.getElementById('loadvol').innerHTML="<center>Processing...<br><img src='http://www.eventbee.com/main/images/loading.gif'></center>";
			    document.getElementById('loadvol').style.cssText="top:70%;left:40%;background:#F5F5F5;float:left;padding: 0px;z-index: 100003;position:absolute;margin-top:-50px;"
			   

}


/*-----------Filling the progress bar and refreshing it------------------*/


function fill_progress_bar(sold_qty,trigger_qty,ticketid){
	var maxprogress = trigger_qty;
	var actualprogress = sold_qty;
	var itv = 0;
	var indicator = document.getElementById(ticketid);
	var new_width=200*Number(actualprogress)/Number(maxprogress);
	var img_width=Number(new_width)-3;
	img_width=img_width+"px";
	new_width=Number(new_width)+"px";
		if(Number(sold_qty)<=Number(trigger_qty)){
			indicator.style.width= new_width;
			document.getElementById("picture_"+ticketid).style.marginLeft = img_width;
			document.getElementById("countcenter_"+ticketid).style.marginLeft = img_width;
		}
	else{
		new_width="200px";
		indicator.style.width= new_width;
		img_width="240px";
		document.getElementById("picture_"+ticketid).style.marginLeft = img_width;
		document.getElementById("countcenter_"+ticketid).style.marginLeft = img_width;
	}
	if(sold_qty==0 || sold_qty==trigger_qty){
		document.getElementById("countcenter_"+ticketid).innerHTML="&nbsp;";
	}
}
function fill_progress_bar_event(sold_qty,trigger_qty,ticketid){
	var maxprogress = trigger_qty;
	var actualprogress = sold_qty;
	var itv = 0;
	var indicator = document.getElementById(ticketid);
	var new_width=135*Number(actualprogress)/Number(maxprogress);
	var img_width=Number(new_width)-1;
	img_width=img_width+"px";
	new_width=Number(new_width)+"px";
		if(Number(sold_qty)<=Number(trigger_qty)){
			indicator.style.width= new_width;
			document.getElementById("picture_"+ticketid).style.marginLeft = img_width;
			document.getElementById("countcenter_"+ticketid).style.marginLeft = img_width;
		}
	else{
		new_width="130px";
		indicator.style.width= new_width;
		img_width="135px";
		document.getElementById("picture_"+ticketid).style.marginLeft = img_width;
		document.getElementById("countcenter_"+ticketid).style.marginLeft = img_width;
	}
	if(sold_qty==0 || sold_qty==trigger_qty){
		document.getElementById("countcenter_"+ticketid).innerHTML="&nbsp;";
	}
}

function reloadpage(){
self.parent.location.reload();
}
/*-------------------end of fill and refresh bar-------------------------*/




var currentEid='';
var isBannerOpened=false;
function closeBannerWindow(id)
{var serveraddress="";
if(document.getElementById('serveraddress'))
var serveraddress=document.getElementById('serveraddress').value;
var urlre=serveraddress+'/volume/widget/holdDeleteAtClose.jsp?uid='+uid;
if(document.getElementById('deletehold_div_'+id)){			    
					var html="<iframe  id='delete_h_"+id+"' name='delete_h'  src='"+urlre+"' style='display:none;'  height='0' width='0' onload='sucessLoad()'scrolling='no' ></iframe>";					
					if(document.getElementById('delete_h_'+id))
				{document.getElementById('delete_h_'+id).onload=closeBannerWindowNex(id);	
				 document.getElementById('delete_h_'+id).src=urlre;
				}
					else
					{document.getElementById('deletehold_div_'+id).innerHTML=html;
                     document.getElementById('delete_h_'+id).onload=closeBannerWindowNex(id);
					}					
}
else
closeBannerWindowNex(id);
}
function closeBannerWindowNex(id){

isBannerOpened=false;
if(document.getElementById('backgroundPopup11')){
document.getElementById('backgroundPopup11').style.display="none";}
if(document.getElementById('loadvol')){
document.getElementById('loadvol').style.display="none";}

if(document.getElementById('tcktwidget_'+id)){
 	       document.getElementById('tcktwidget_'+id).style.display="none";
	       if( document.getElementById('_EbeeIFrame_'+id))
		 {  document.getElementById('_EbeeIFrame_'+id).style.display='none';
	     // var parent=document.getElementById('tcktwidget_'+id);
		 // var child= document.getElementById('_EbeeIFrame_'+id);
		 // parent.removeChild(child);
		  }
		   document.getElementById('_EbeeIFrame_'+id).style.height='1px';
	      // document.getElementById('_EbeeIFrame_'+id).src='';
			reloadscriptframe()
}





}

function reloadscriptframe()
{
document.getElementById('_widgetIFrame'+ticketid).src=document.getElementById('_widgetIFrame'+ticketid).src;

}

var ticketid="";
var elmId="";
var frmId="";
var pagein="";
function bannerOpener(elmid, frmid, eid,tktid)
{ elmId=elmid;
   frmId=frmid;
  //alert(frmId+""+elmId+" "+eid+" "+tktid);
 if(document.getElementById(elmId))
 {document.getElementById(elmId).style.display="none";
  }
	if(document.getElementById(frmId))
	document.getElementById(frmId).style.display="none";
	
	if(document.getElementById("pagein_"+tktid))
  {   pagein=document.getElementById("pagein_"+tktid).value;
  }

	callblockAload(tktid);
	var serveraddress=document.getElementById('serveraddress').value;
	ticketid=tktid;
	var nts="";
	var track="";
	var wcode="";
	if(document.getElementById('nts_'+tktid))
	 nts=document.getElementById('nts_'+tktid).value;
	if(document.getElementById('track_'+tktid))
     track=document.getElementById('track_'+tktid).value;
	if(document.getElementById('wcode_'+tktid))
     wcode=document.getElementById('wcode_'+tktid).value;
	if(document.getElementById(elmId))
	if(isBannerOpened) return;
	 	
		var uid=uniqid();
		var src=serveraddress+"/volume/reg_widget/registration.jsp?customtheme=no&viewType=iframe;resizeIFrame=true&context=VBEE&eid="+eid+"&vb=true&ticketid="+tktid+"&track="+track+"&nts="+nts+"&wcode="+wcode+"&uid="+uid+"&pagein="+pagein;
		var clse="<div  style='float:right;color:white;padding:0px; margin-right:-18px; margin-top:-16px;'><a href='javascript:closeBannerWindow("+tktid+");'><img src='"+serveraddress+"/home/images/images/close.png'></a></div><br/>";
		var html=clse+"<iframe  id='"+frmId+"' name='"+frmId+"'  src='"+src+"' style='display:none;'  height='0' width='650' onload='sucessLoad()'scrolling='no' ></iframe>";
	if(!document.getElementById(frmId))	
	document.getElementById(elmId).innerHTML=html;
	else
	document.getElementById(frmId).src=src;
	currentEid=eid;
	document.getElementById(elmId).style.className="";
	document.getElementById(elmId).style.cssText="top:4%;left:20%;width:650px;float:left;padding: 0px;z-index: 100003;position:absolute;margin:0px;cursor:move;";
	
	scrollTo(0,0);
	jQuery( "#"+elmId).draggable();
	
	isBannerOpened=true;
	//document.getElementById(elmId).innerHTML=html;
	//document.getElementById(frmId).onload=sucessLoad(elmId,frmId);

}
function salestrtinfo(){
window.location.reload();
}

 function uniqid()
 {
 var newDate = new Date;
 uid="UID_"+newDate.getTime();
  return uid;
 }
 var expanMap=new Object();
 function toggleDescriptionvol(ticketID){
  var serveraddress=document.getElementById('serveraddress').value;
 if(expanMap[ticketID]==undefined)
 expanMap[ticketID]="expand"; 
 if(expanMap[ticketID]=="expand")
 {
    document.getElementById('imgShowHide_'+ticketID).src=serveraddress+"/home/images/collapse.gif";
	document.getElementById('evtinfo_'+ticketID).style.display = 'block';
	expanMap[ticketID]="collapse";
}  else if(expanMap[ticketID]=="collapse")
	{	 document.getElementById('imgShowHide_'+ticketID).src=serveraddress+ "/home/images/expand.gif";
		document.getElementById('evtinfo_'+ticketID).style.display = 'none';
	expanMap[ticketID]="expand";
	}		

}
 



