var discountsjson;
var discountedprices;
var tktsData='';
var profileJsondata='';
var CtrlWidgets=[];
var responsesdata=[];
var etid="";
var loginuserid='';
var evtdate='';
var eventid='';
var ticketsArray=[];
var tranid='';
var paymenttype;
var oid='';
var context='';;
var domain='';;
var ticketurl='';
var discountcode='';
var track='';
var serveradd;
var code;
var headers;
var timestamp;
var bfname='';
var blname='';
var bemail='';
var bphone='';
var paymentmode='';
var promotionenable=true;
var isavailableseat="";
var selectTktMsg='';
var sectionid="";
var max_ticketid=new Object();
var min_ticketid=new Object();
var ticket_ids_seats=[];
var seating_enabled_tkt_wedget='NO';
var allsectionid=[];
var allsectionname=[];
var seatingsectionresponsedata=new Object();
var ticketseatcolor=new Object();
var mins_left = 14;
var s_left = 60;
var mins_remain=14;
var secs_remain=60;
var ticket_groupnames=new Object();
var notavailableticketids=new Array();
var memberseatticketids=new Array();
var seatingticketidresponse="";
var venueid="";
var fbsharepopup="";

function getTicketsJson(eid){
eventid=eid;
if(document.getElementById('eventdate')){
	insertOptionBefore('tickets');
	$('registration').innerHTML='';
	var index=document.getElementById('eventdate').selectedIndex;
	evtdate=document.getElementById('eventdate').options[index].value;
	if(evtdate=='Select Date')
		evtdate='';
	else{
		showTicLoadingImage("Loading...");
		document.getElementById('eventdate').disabled=true;
		}
}
else{
showTicLoadingImage("Loading...");
}
if(document.getElementById('ticketurlcode'))
ticketurl=document.getElementById('ticketurlcode').value;


new Ajax.Request('/embedded_reg/ticketsjson.jsp?timestamp='+(new Date()).getTime(), {
  method: 'get',
  parameters:{eid:eid,ticketurl:ticketurl,evtdate:evtdate},
  onSuccess: ticketJsonResponse,
  onFailure:  failureJsonResponse
  });
 }
 
 function ticketJsonResponse(response){
  var jsonTicketData=response.responseText;
  tktsData=eval('(' + jsonTicketData + ')');
  selectTktMsg=tktsData.selectticketmsg;
  headers=tktsData.headers;
  
   if(tktsData.ticketstatus == 'no'){
	//hideTicLoadingImage();
	
	    document.getElementById('pageheader').style.display='block';
		document.getElementById('pageheader').innerHTML=tktsData.page_header;
		document.getElementById('registration').innerHTML='<center><b>Tickets are currently unavailable</b></center>';
		document.getElementById('ticketrecurring').innerHTML='';
	}
	else{
		
	getHeader(eventid);
	}
 
  }
  
   function getHeader(eventid){

 if(document.getElementById('pageheader')){
 document.getElementById('pageheader').style.display='block';
 
 document.getElementById('pageheader').innerHTML=headers.ticketspage;

  }
   
 if(evtdate==''&&document.getElementById('eventdate')){
 $('registration').innerHTML='';
 }
 else
 {

  getTicketsBlock(eventid);
  }
 }
  /*
 function getHeaders(eid){
 new Ajax.Request('/embedded_reg/getpageheaders.jsp?timestamp='+(new Date()).getTime(), {
 method: 'get',
 parameters:{eid:eid},
 onSuccess: getHeaderesponse,
 onFailure:  failureJsonResponse
 });
 }

 function getHeaderesponse(response){

 headers=eval('(' +response.responseText+ ')');
 if(document.getElementById('pageheader')){
 document.getElementById('pageheader').style.display='block';
 
 document.getElementById('pageheader').innerHTML=headers.ticketspage;

  }
   
 if(evtdate==''&&document.getElementById('eventdate')){
 $('registration').innerHTML='';
 }
 else
 {

  getTicketsBlock(eventid);
  }
 }
  */
  
 function getTicketsBlock(eid){
 if(document.getElementById('eventdate')){
var index=document.getElementById('eventdate').selectedIndex;
evtdate=document.getElementById('eventdate').options[index].text;
 }
 if(evtdate=='Select Date')
 evtdate='';
 if(document.getElementById('trackcode'))
 track=document.getElementById('trackcode').value;
if(document.getElementById('discountcode'))
 discountcode=document.getElementById('discountcode').value;
 if(document.getElementById('ticketurlcode'))
 ticketurl=document.getElementById('ticketurlcode').value;
 if(document.getElementById('context'))
 context=document.getElementById('context').value;
if(document.getElementById('oid'))
oid=document.getElementById('oid').value;
if(document.getElementById('domain'))
 domain=document.getElementById('domain').value;
if(document.getElementById('pageheader')){
document.getElementById('pageheader').style.display='block';
document.getElementById('pageheader').innerHTML=headers.ticketspage;

}
 new Ajax.Request('/embedded_reg/getticketsblockvm.jsp?timestamp='+(new Date()).getTime(), {
 method: 'get',
 parameters:{eid:eid,track:track,evtdate:evtdate,ticketurl:ticketurl,discountcode:discountcode},
 onSuccess: TicketsBlockresponse,
 onFailure:  failureJsonResponse
 });
 }
 
 function TicketsBlockresponse(response){
 //getconfirmationfbsharepopup();
 $('registration').hide(); 
  $('registration').update(response.responseText);
 if($('seatingsection')){
	 seatingticketidlabel();
	 seating_enabled_tkt_wedget='YES';
		if($('orderbutton'))$('orderbutton').disabled=true; 
	 }  
	 else{
		seating_enabled_tkt_wedget='NO';
		Initialize("registration");
	 }
   
 
 hideTicLoadingImage();
 $('registration').show();
if(discountcode!=null&&discountcode!=''&&discountcode!='null')
 getDiscountAmounts();
 
 if($('seatingsection')){
	if($('venueid'))
	venueid=$('venueid').value;
	getseatingsection();

 }
 else{
 if(document.getElementById('eventdate'))
 document.getElementById('eventdate').disabled=false;
 }
 
}

function getseatingsection(){
	$('seatingsection').innerHTML="<span id='seating_image'>Loading Seats...<br><img src='/home/images/ajax-loader.gif'></span>";
	
     new Ajax.Request('/embedded_reg/seating/seatingsection.jsp?timestamp='+(new Date()).getTime(), {
	 method: 'get',
	 
	 parameters:{eid:eventid,evtdate:evtdate,tid:tranid,venueid:venueid},
	 onSuccess: seatingsectionresponse,
	 onFailure:  failureJsonResponse
	 });
}

function seatingsectionresponse(response){

var data=response.responseText;
var responsedata=eval('(' + data + ')');
seatingsectionresponsedata=responsedata;
allsectionid=responsedata.allsectionid;
resetobjectdata();
allsectionname=responsedata.allsectionname;
ticketseatcolor=responsedata.ticketseatcolor;
ticket_groupnames=responsedata.ticketgroups;
var layoutdisplay=responsedata.venuelayout;
var venuelayoutlink="";
if(layoutdisplay=="URL"){
	venuepath="\""+responsedata.venuepath+"\"";
	venuelayoutlink="<a href=#layout onclick='getvenuelayout("+venuepath+")' style='float:right;'>"+responsedata.venuelinklabel+"</a>";
}
if(allsectionid.length==1){
	sectionid=allsectionid[0];
	$('seatingsection').innerHTML=="";
	$('seatingsection').innerHTML="<html><head>"+
	"</head><body><input type='hidden' name='section' id='section' value='"+sectionid+"'><span id='seating_image'>Loading Seats...<br><img src='/home/images/ajax-loader.gif'></span>"+venuelayoutlink+"<div id='seatcell' style='overflow: auto; width: 600px; height: 300px; border: 0px solid rgb(51, 102, 153); padding: 10px;'>"+
	"</div></body></html>";
	getticketseatsdisplay();
	generateSeating(responsedata.allsections[sectionid]);
	
}
else{
	sectionid=allsectionid[0];
	$('seatingsection').innerHTML=="";
	var sectionlistdropdown=generate_Sectiondropdown(allsectionid,allsectionname);
	$('seatingsection').innerHTML="<html><head>"+
	"</head><body><div style='float:left;'>Select Section: "+sectionlistdropdown+"</div> &nbsp;&nbsp;"+venuelayoutlink+"<br><span id='seating_image'>Loading Seats...<br><img src='/home/images/ajax-loader.gif'></span><br><div id='seatcell' style='overflow: auto; width: 600px; height: 300px; border: 0px solid rgb(51, 102, 153); padding: 10px;'>"+
	"</div></body></html>";
	getticketseatsdisplay();
	generateSeating(responsedata.allsections[sectionid]);
}
$('seating_image').hide();
if(document.getElementById('eventdate'))
 document.getElementById('eventdate').disabled=false;
}

function failureJsonResponse(){
clickcount=0;
alert("Sorry this request cannot be processed at this time");
}

function getTotalAmounts(){
document.getElementById('actiontype').value='calculate';
$('regform').request({
parameters:{evtdate:evtdate,context:context,oid:oid,domain:domain,eventid:eventid},
onComplete:TotalAmounts
});
}

function TotalAmounts(response){
var data=response.responseText;
responsejsondata=eval('(' + data + ')');
amountjsondata=responsejsondata.amounts;
document.getElementById('tid').value=amountjsondata.tid;
tranid=amountjsondata.tid;

document.getElementById('totalamount').style.display='block';
var discount=amountjsondata.disamount;
var tax=amountjsondata.tax;
document.getElementById('totaldiv').style.display='block';
document.getElementById('totamount').innerHTML=amountjsondata.totamount;
if(parseFloat(discount)>0){
document.getElementById('discountdiv').style.display='block';
document.getElementById('disamount').style.display='block';
document.getElementById('disamount').innerHTML=amountjsondata.disamount;
document.getElementById('netamountdiv').style.display='block';
document.getElementById('netamount').style.display='block';
document.getElementById('netamount').innerHTML=amountjsondata.netamount;
}
if(parseFloat(tax)>0){
document.getElementById('taxdiv').style.display='block';
if(document.getElementById('taxamount')){
document.getElementById('taxamount').innerHTML=amountjsondata.tax;
}
document.getElementById('gtotaldiv').style.display='block';
document.getElementById('grandtotamount').style.display='block';
if(document.getElementById('grandtotamount')){
document.getElementById('grandtotamount').innerHTML=amountjsondata.grandtotamount;
}
}
}

function getDiscountAmounts(){
code=document.getElementById('couponcode').value;
var eventid=document.getElementById('eid').value;
new Ajax.Request('/embedded_reg/getdiscounts.jsp?timestamp='+(new Date()).getTime(), {
method: 'get',
parameters:{eid:eventid,code:code},
onSuccess: PrcocesDiscountsResponse,
onFailure:  failureJsonResponse
});
}

function PrcocesDiscountsResponse(response){
var data=response.responseText;
var responsejsondata=eval('(' + data + ')');
discountsjson=responsejsondata.discounts;
discountedprices=responsejsondata.discountedprices;
if(document.getElementById('totalamount'))
document.getElementById('totalamount').style.display='none';
fillDiscountBox();
resetPrices();
updatePrices(discountedprices);
}

function fillDiscountBox(){
if(discountsjson && discountsjson.IsCouponsExists && discountsjson.IsCouponsExists=='Y'){
if(discountsjson.discountapplied && discountsjson.discountapplied=='Y'){
if(discountsjson.validdiscount=='Y'){
document.getElementById('discountmsg').innerHTML=discountsjson.discountmsg;
document.getElementById('invaliddiscount').innerHTML='';
}
else
{
code='';
$('invaliddiscount').update(discountsjson.discountmsg);
document.getElementById('discountmsg').innerHTML='';
}
document.getElementById('couponcode').value=discountsjson.discountcode;
}
}
}

function updatePrices(discountedprices){

if(discountedprices){
for(var index=0;index<discountedprices.length;index++){
var ticketid=discountedprices[index].ticketid;
var finalprice=discountedprices[index].final_price;
if(discountedprices[index].isdonation!='Yes'){
if(document.getElementById('qty_'+ticketid))
ticketWidgets[ticketid].SetChargingPrice(discountedprices[index].final_price);
}
if(parseFloat(finalprice)==0){
if(document.getElementById('qty_'+ticketid))
ticketWidgets[ticketid].SetChargingFee(0.00);
}
}
}
}

function resetPrices(){
for(var q=0;q<ticketsArray.length;q++){
tktid=ticketsArray[q];
var actualprice=ticketWidgets[tktid].GetTicketPrice();
var tickettype=ticketWidgets[tktid].GetTicketType();
if(tickettype!='donationType'){
ticketWidgets[tktid].SetChargingPrice(actualprice);
}
}
}

var ticketpageclickcount=0;
function validateTickets(){
	ticketpageclickcount++;
	if(ticketpageclickcount>1){
		return;
		}	
	
	if($('registration'))
		$('registration').hide();
	showTicLoadingImage("Loading...");
	if(document.getElementById("eventdate"))
		document.getElementById("eventdate").disabled=true;
	var qty=0;
	var totalqty=0;
	var noseatqty=0;
	var flag=true;
	var allowsel=false;
	var noseatallowsel=false;
	var min_sel_qty=true;
	var max_sel_qty=true;
	var NOSEAT_tic_id=[];
	NOSEAT_tic_id=ticketsArray;
	/*for tickets with out seats section start*/
	for (var i = 0; i<ticket_ids_seats.length; i++) {
		var arrlen = NOSEAT_tic_id.length;
		for (var j = 0; j<arrlen; j++) {
			if (ticket_ids_seats[i] == NOSEAT_tic_id[j]) {
				NOSEAT_tic_id = NOSEAT_tic_id.slice(0, j).concat(NOSEAT_tic_id.slice(j+1, arrlen));
			}
		}
	}
	
	/*tickets without seats end*/
	
	for(var t=0;t<ticketsArray.length;t++){
		ticketd=ticketsArray[t];
		var ttype=ticketWidgets[ticketd].GetTicketType();
		if(ticketWidgets[ticketd].ticketIsAvailable=='Y'&&ticketWidgets[ticketd].ticketStatusMsg!='NA'){
			if(ttype=='donationType')
				qty=ticketWidgets[ticketd].GetDonationTicketQty();
			else{
				
				if(document.getElementById("qty_"+ticketd).type=='hidden'){
					qty=document.getElementById("qty_"+ticketd).value;
				}
				else{
					var x=document.getElementById("qty_"+ticketd).selectedIndex;
					qty=document.getElementById("qty_"+ticketd).options[x].value;
				}
			}
		}
		if($('seatingsection')){
			for(i=0;i<ticket_ids_seats.length;i++){
				if(ticketd==ticket_ids_seats[i]){
					if(qty == 0){
						//allowsel=false;
					}
					else{ 
					
					if(Number(qty)>0){
					
						if(Number(qty)<min_ticketid[ticketd]){
							totalqty=totalqty+Number(qty)
							//totalqty=0;
							allowsel=false;
							alert("for \""+ticketnameids[ticketd]+"\" the minimum seats quantity is "+min_ticketid[ticketd]+", you selected only "+qty+" seats");
							min_sel_qty=false;
							break;
						}
						else if(Number(qty)>max_ticketid[ticketd]){
							totalqty=totalqty+Number(qty)
							//totalqty=0;
							allowsel=false;
							alert("for \""+ticketnameids[ticketd]+"\" the maximum seats quantity is "+max_ticketid[ticketd]+", you selected "+qty+" seats");
							max_sel_qty=false;
							break;
						}
						else{
							if(min_sel_qty && max_sel_qty){
								totalqty=totalqty+Number(qty);
								allowsel=true;
							}
							else{
								totalqty=0;
								allowsel=false;
							}
						}
					}
					}

				}
				else{
				
					for(j=0;j<NOSEAT_tic_id.length;j++){
						if(ticketd==NOSEAT_tic_id[j]){
							noseatqty=noseatqty+Number(qty);
							noseatallowsel=true;
						}
					}
				}
			}
		}
		else{	
			if(qty>0){
				break;
			}
		}
	}
	if($('seatingsection')){
	
		if(parseFloat(totalqty)==0 && parseFloat(noseatqty)==0){
		
		if(document.getElementById("eventdate"))
			document.getElementById("eventdate").disabled=false;
		hideTicLoadingImage();
		if($('registration'))
			$('registration').show();
		
			var qty1=0;
			for(var t=0;t<ticketsArray.length;t++){
				qty1=qty1+Number($("qty_"+ticketsArray[t]).value);
			}
			if(qty1==0){
				alert(selectTktMsg);
				ticketpageclickcount=0;
				}
		}
		else if(parseFloat(totalqty)==0 && parseFloat(noseatqty)>0){
			DisabledonationAmount();
			if(document.getElementById('eventdate')){
				flag=validateCheckDate();
			}
			if(flag){
				
				checkticketsstatus();
				//checkseatavailibility();
				return;
			}
		}
		else if (!allowsel){
			
		if(document.getElementById("eventdate"))
			document.getElementById("eventdate").disabled=false;
		hideTicLoadingImage();
		if($('registration'))
			$('registration').show();

		}
		else{
			
			DisabledonationAmount();
			if(document.getElementById('eventdate')){
				flag=validateCheckDate();
			}
			if(flag){
				
				checkticketsstatus();
				//checkseatavailibility();
				return;
			}
		}
	}
	else{	
		if(parseFloat(qty)==0){
			if(document.getElementById("eventdate"))
				document.getElementById("eventdate").disabled=false;
			hideTicLoadingImage();
			if($('registration'))
				$('registration').show();
			alert(selectTktMsg);
			ticketpageclickcount=0;
		}
		else{
			DisabledonationAmount();
			if(document.getElementById('eventdate')){
				flag=validateCheckDate();
			}
			if(flag){
				//checkticketsstatus();
				submitTickets();
				return;
			}
		}
	}
}

function DisabledonationAmount(){
for(var t=0;t<ticketsArray.length;t++){
ticketd=ticketsArray[t];
var ttype=ticketWidgets[ticketd].GetTicketType();
if(ticketWidgets[ticketd].ticketStatusMsg=='NA'){
if(ttype=='donationType')
ticketWidgets[ticketd].setDonationTicketQty(0);
}
}
}

function validateCheckDate(){
if(document.getElementById('eventdate')){
if(evtdate==''){
alert("select date");
return false;
}
else
return true;
}
}

function checkticketsstatus(){
var allticketids="";

var jsonFormat="{";
	for(i=0;i<ticketsArray.length;i++){
		if(allticketids!="")
			allticketids=allticketids+"_"+ticketsArray[i];
		else
			allticketids=ticketsArray[i];
		var curid="qty_"+ticketsArray[i];
		var qty=document.getElementById(curid).value;
		if(Number(qty)>0){
			jsonFormat=jsonFormat+'"'+ticketsArray[i]+'":'+qty;
			if(i!=ticketsArray.length-1){
				jsonFormat=jsonFormat+",";
			}
		}
	}
	jsonFormat=jsonFormat+"}";
	new Ajax.Request('/embedded_reg/checkticketsstatus.jsp?timestamp='+(new Date()).getTime(),{
	method: 'get',
	parameters:{eid:eventid,tid:tranid,eventdate:evtdate,selected_tickets:jsonFormat,all_ticket_ids:allticketids},
	onSuccess: ticketsavailable,
	onFailure: seatunavailable
	});

}

function ticketsavailable(response){
var ticdata=response.responseText;
var availablejson=eval('(' + response.responseText + ')');

if(availablejson.responsemap.status=="success"){
	if(seating_enabled_tkt_wedget=='YES')
		checkseatavailibility()
	else
		submitTickets();
}
else{
	var jobj=availablejson.responsemap;
	ticketsunavailable(jobj);
}

}

function ticketsunavailable(jobj){
var message="<ul>";
for(i=0;i<ticketsArray.length;i++){
	var tktid=ticketsArray[i];
	if(jobj["sel_"+tktid]!=undefined){
		var tktobj=	tktsData[tktid];
		var avail_qty=Number(jobj['remaining_'+tktid]);
		if(Number(avail_qty)<0)
			avail_qty=0;
		message=message+"<li>For \""+tktobj['Name']+"\" selected quantity is "+jobj['sel_'+tktid]+" and currently available quantity is "+avail_qty+"</li>";
	}
}
	message=message+"</ul>";
	if($('ticketunavailablepopup_div')){}else{
	var divpopup=document.createElement("div");
	divpopup.setAttribute('id','ticketunavailablepopup_div');
	divpopup.className='ticketunavailablepopup_div';
	var cell=$('container');
	cell.appendChild(divpopup);
	}
	getunavailablepopup(message);
if($('registration')){
	$('registration').show();
}
if($('imageLoad'))
$('imageLoad').hide();
window.scrollTO(0,0);
}

function getunavailablepopup(message){
	message=message+"<br><input type='button' value='OK' onclick='closeunavailablepopup()'><a href=# onclick=closeunavailablepopup()><img src='/home/images/images/close.png' class='divimage'></a>";
	if(document.getElementById("backgroundPopup")){
		document.getElementById("backgroundPopup").style.display='block';
	}
	document.getElementById('ticketunavailablepopup_div').innerHTML=message;
	document.getElementById('ticketunavailablepopup_div').style.display="block";
	document.getElementById('ticketunavailablepopup_div').style.top='50%';
	document.getElementById('ticketunavailablepopup_div').style.left='26%';
	clearallselections();
}

function closeunavailablepopup(){
if(document.getElementById("backgroundPopup")){
		document.getElementById("backgroundPopup").style.display='none';
	}
	document.getElementById('ticketunavailablepopup_div').style.display="none";
}

function checkseatavailibility(){
	var jsonFormat="{";
	var sec_ids="";
	for(i=0;i<allsectionid.length;i++){
		if(sec_ids==""){
			sec_ids=allsectionid[i];
		}
		else{
			sec_ids=sec_ids+"_"+allsectionid[i];
		}
		if(section_sel_seats[allsectionid[i]]!=undefined){
			jsonFormat=jsonFormat+'"'+allsectionid[i]+'":['+section_sel_seats[allsectionid[i]]+']';
				if(i!=allsectionid.length-1){
				jsonFormat=jsonFormat+",";
				}
		}
	}
	
	jsonFormat=jsonFormat+"}";
	new Ajax.Request('/embedded_reg/seating/checkseatstatus.jsp?timestamp='+(new Date()).getTime(),{
	method: 'get',
	parameters:{eid:eventid,tid:tranid,eventdate:evtdate,selected_seats:jsonFormat,all_section_ids:sec_ids},
	onSuccess: seatavailable,
	onFailure: seatunavailable
	});
		
}

function seatavailable(response){
var data=response.responseText;
var availablejson=eval('('+data+')');
if(availablejson.status == "success"){
	isavailableseat="yes";
	submitTickets();
}
else{
	isavailableseat="no";
	for(i=0;i<ticketsArray.length;i++){
		var ticketd=ticketsArray[i];
		if(document.getElementById("qty_"+ticketd).type=='hidden'){
			document.getElementById("qty_"+ticketd).value=0;
			if(document.getElementById("show_"+ticketd))
			document.getElementById("show_"+ticketd).innerHTML=0;
		}
	}
	alert("Few of the seats you are trying to book are currently on hold or already soldout");
	if($('registration')){
		$('registration').show();
	}
	if($('eventdate')){
		$('eventdate').disabled=false;
	}
	if($('seatingsection')){
	hideTicLoadingImage();
		$('seatingsection').innerHTML='';
		getseatingsection();
	}
	
}
}

function seatunavailable(){
alert("error processing try back in some time");
}

function submitTickets(){
if($('pageheader')){ 
var x=jQuery('#pageheader').position();
window.scrollTo("0",""+Number(x.top)+"");
}
var jsonFormat=getJsonFormat();
var seating_enable="NO";
if($('seatingsection')){
seating_enable="YES";
}
document.getElementById('actiontype').value='Order Now';
$('regform').action='/embedded_reg/regformaction.jsp?timestamp='+(new Date()).getTime(),
$('regform').request({
parameters:{evtdate:evtdate,code:code,context:context,sectionid:sectionid,selected_ticket:jsonFormat,seating_enabled:seating_enable},
onComplete:submitTicketrepone
});
}

function submitTicketrepone(response){
var data=response.responseText;
var responsejsondata=eval('(' + data + ')');
var status=responsejsondata.status;
if(status=='success'){
document.getElementById('tid').value=responsejsondata.tid;
tranid==responsejsondata.tid;
if(responsejsondata.paymentmode);
paymentmode=responsejsondata.paymentmode;
getProfileJson(responsejsondata.tid,responsejsondata.eid);
}
else
showErrorMessage();
}

function showErrorMessage(){
hideTicLoadingImage();
document.getElementById('registration').innerHTML="<table class='boxcontent' width='100%'><tr height='100'><td align='center'>Sorry Registration can not be processed now, Please click here to <a href='#' onClick='refreshPage()'>retry.</a></td></tr></table>";
}


function getProfileJson(tid,eid){
tranid=tid;
new Ajax.Request('/embedded_reg/profilejsondata.jsp?timestamp='+(new Date()).getTime(), {
method: 'get',
parameters:{eid:eid,tid:tranid},
onSuccess: ProfileJsonResponse,
onFailure:  failureJsonResponse
});


}

function ProfileJsonResponse(response){
profileJsondata=response.responseText;
getProfileData(tranid,eventid);
}


function getProfileData(tid,eid){
CtrlWidgets=[];
ctrlwidget=[];
new Ajax.Request('/embedded_reg/getprofilesblock.jsp?timestamp='+(new Date()).getTime(), {
method: 'get',
parameters:{eid:eid,tid:tid},
onSuccess: ProfileblockResponse,
onFailure:  failureJsonResponse
});
}

function ProfileblockResponse(response){
var data=response.responseText;
var responsejsondata=eval('(' + profileJsondata + ')');
document.getElementById('registration').style.display='none';
document.getElementById('profile').style.display='block';

if(document.getElementById('paymentsection'))
document.getElementById('paymentsection').style.display='none';
hideTicLoadingImage();
document.getElementById('profile').innerHTML=response.responseText;
if(document.getElementById('pageheader')){
if(headers.profilepage!=''){
document.getElementById('pageheader').style.display='block';
document.getElementById('pageheader').innerHTML='<a name="ticketing"></a>'+headers.profilepage;
}
else{
document.getElementById('pageheader').style.display='none';
}

}
ticketpageclickcount=0;
var profilecount=responsejsondata.profilecount;
var tickets=responsejsondata.tickets;
var questionsobj=responsejsondata.questions;
var profilecount=responsejsondata.profilecount;
var questions='';
var buyerinfo=responsejsondata.buyerquest;
for(var index=0;index<tickets.length;index++){
ticketid=tickets[index];
var count=profilecount[ticketid];
questions=questionsobj[ticketid];

for(var p=1;p<=count;p++){
for(i=0;i<questions.length;i++){
var qid=questions[i];
putWidgetIdeal(ticketid, qid, p);
}
}
}
for(i=0;i<buyerinfo.length;i++){
var qid=buyerinfo[i];
putWidgetIdeal('buyer', qid, '1');
}
if(document.getElementById('enablepromotion')){

document.getElementById('enablepromotion').checked=promotionenable;
if(promotionenable){
document.getElementById('enablepromotion').value="yes";
}

}

if($('seatingsection')){
	getseatingtimer();
}
else{
if(document.getElementById('q_buyer_fname_1'))
document.getElementById('q_buyer_fname_1').focus();

}
updatecurrentaction("profile page");
}

function getTicketsPage(){
if(document.getElementById('enablepromotion')){

promotionenable=document.getElementById('enablepromotion').checked;
if(document.getElementById('enablepromotion').checked){
document.getElementById('enablepromotion').value="yes";
}

else{
document.getElementById('enablepromotion').checked=promotionenable;
document.getElementById('enablepromotion').value='';
}
}
getresponses();
document.getElementById('registration').style.display='block';
hideTicLoadingImage();
if(document.getElementById("eventdate"))
document.getElementById("eventdate").disabled=false;
document.getElementById('profile').style.display='none';
if(document.getElementById('pageheader')){
document.getElementById('pageheader').style.display='block';
document.getElementById('pageheader').innerHTML=headers.ticketspage;
}
if($('seatingsection')){
	if($('paymentsection')){
		$('paymentsection').hide();
		$('paymentsection').innerHTML='';
	}
	if($('ticket_div')){
		$('ticket_div').hide();
	}
	if($('ticket_timer')){
		$('ticket_timer').remove();
		clearTimeout(reg_timeout);
	
	}
	ticketpageclickcount=0;
}

updatecurrentaction("tickets page");
}

function getresponses(){
for (var p=0;p<ctrlwidget.length;p++){
var id=ctrlwidget[p];
responsesdata[id]=CtrlWidgets[id].GetValue();
}
}

function del_seat_temp(){
	
	new Ajax.Request('/embedded_reg/seating/delete_tempseats.jsp?timestamp='+(new Date()).getTime(), {
	method: 'post',
	parameters:{eid:eventid,tid:tranid}
	});
}

//***************************************************
var clickcount=0;
function SubmitForm(tid,type,serveraddress){
updatecurrentaction(type);

if($('paymentsection'))
		$('paymentsection').hide();
showTicLoadingImage("Loading...");

paymenttype=type;
if($('seatingsection')){
hidetimerpopup();
}
if(clickcount>1)
{
return;
}
tid=document.getElementById('tid').value;
tranid=tid;
serveradd=serveraddress;
var eid=document.getElementById("eid").value;
if(paymenttype=='eventbee') {
getEventbeecreditcardScreen(tid,eid);
hideimage_showpaysection();
}
else if(paymenttype=='paypal'){
if(paymentmode=='paypalx')
getPaypalXPaymentsPopUp(tid,eid,paymenttype);
else
getPaypalPaymentsPopUp(tid,eid,paymenttype);
hideimage_showpaysection();
}
else if(paymenttype=='google'){
getGooglePaymentsPopUp(tid,eid,paymenttype);
hideimage_showpaysection();
}
else if(paymenttype=='other'||paymenttype=='nopayment'){
processRegistration(tranid,eventid,paymenttype);
}

}

function hideimage_showpaysection(){

hideTicLoadingImage();
if($('paymentsection'))
$('paymentsection').show();

}

var profilepageclickcount=0;
function validateProfiles(tid){
profilepageclickcount++;

if(profilepageclickcount>1){
return;
}
	if(document.getElementById('enablepromotion')){
		promotionenable=document.getElementById('enablepromotion').checked;
		if(document.getElementById('enablepromotion').checked){
			document.getElementById('enablepromotion').value="yes";
		}
	}
	document.getElementById('profilesubmitbtn').style.display='none';
	var count=0;
	for (var p=0;p<ctrlwidget.length;p++){
		id=ctrlwidget[p];
		if(CtrlWidgets[id].Validate())
		{
			if(id=='buyer_fname_1')
				bfname=CtrlWidgets[id].GetValue();
			else if(id=='buyer_lname_1')
				blname=CtrlWidgets[id].GetValue();
			else if(id=='buyer_email_1'){
				bemail=CtrlWidgets[id].GetValue();
				var emailtest=Validate_email(bemail);
				if(emailtest){
					getemailmessage(true);
				}
				else{
					getemailmessage(false);
					count++;
				}
			}
			else if(id=='buyer_phone_1')
				bphone=CtrlWidgets[id].GetValue();
		}
		else{
			count++;
		}
	}
	if(count==0){
		if($('profile'))
			$('profile').hide();
		showTicLoadingImage("Loading...");
		document.getElementById('profileerr').innerHTML='';
		if($('seatingsection')){
			checkseatsavailibilityatprofilesubmit(tid);
		}
		else{
			submitProfiles(tid);
		}
		//checkticketsstatusprofilelevel(tid);
	}
	else{
	clickcount=0;
	profilepageclickcount=0;
	document.getElementById('profilesubmitbtn').style.display='block';
	if(parseInt(count)>1)
	document.getElementById('profileerr').innerHTML="<font color='red'>There are "+count+" errors</font>";
	else
	document.getElementById('profileerr').innerHTML="<font color='red'>There is  "+count+" error</font>";
	}
}

function checkticketsstatusprofilelevel(tid){
var allticketids="";

var jsonFormat="{";
	for(i=0;i<ticketsArray.length;i++){
		if(allticketids!="")
			allticketids=allticketids+"_"+ticketsArray[i];
		else
			allticketids=ticketsArray[i];
		var curid="qty_"+ticketsArray[i];
		var qty=document.getElementById(curid).value;
		if(Number(qty)>0){
			jsonFormat=jsonFormat+'"'+ticketsArray[i]+'":'+qty;
			if(i!=ticketsArray.length-1){
				jsonFormat=jsonFormat+",";
			}
		}
	}
	jsonFormat=jsonFormat+"}";
	new Ajax.Request('/embedded_reg/checkticketsstatus.jsp?timestamp='+(new Date()).getTime(),{
	method: 'get',
	parameters:{eid:eventid,tid:tid,eventdate:evtdate,selected_tickets:jsonFormat,all_ticket_ids:allticketids},
	onSuccess: ticketsavailableprofileresponse,
	onFailure: seatunavailable
	});

}

function ticketsavailableprofileresponse(response){
var ticdata=response.responseText;
var availablejson=eval('(' + response.responseText + ')');
var tid=availablejson.tid;
if(availablejson.responsemap.status=="success"){
	if(seating_enabled_tkt_wedget=='YES')
		checkseatsavailibilityatprofilesubmit(tid);
	else
		submitProfiles(tid);
}
else{
	delete_locked_temp(tid);
	var jobj=availablejson.responsemap;
	ticketsunavailable(jobj);
}

}

function checkseatsavailibilityatprofilesubmit(tid){
	var jsonFormat="{";
	var sec_ids="";
	for(i=0;i<allsectionid.length;i++){
		if(sec_ids==""){
			sec_ids=allsectionid[i];
		}
		else{
			sec_ids=sec_ids+"_"+allsectionid[i];
		}
		if(section_sel_seats[allsectionid[i]]!=undefined){
			jsonFormat=jsonFormat+'"'+allsectionid[i]+'":['+section_sel_seats[allsectionid[i]]+']';
				if(i!=allsectionid.length-1){
				jsonFormat=jsonFormat+",";
				}
		}
	}
	
	jsonFormat=jsonFormat+"}";
	new Ajax.Request('/embedded_reg/seating/checkseatstatus.jsp?timestamp='+(new Date()).getTime(),{
	method: 'get',
	parameters:{eid:eventid,tid:tid,eventdate:evtdate,selected_seats:jsonFormat,all_section_ids:sec_ids},
	onSuccess: seatavailableprofileresponse,
	onFailure: seatunavailable
	});
		
}

function seatavailableprofileresponse(response){
var data=response.responseText;
var availablejson=eval('('+data+')');
if(availablejson.status == "success"){
	var tid=availablejson.tid;
	isavailableseat="yes";
	submitProfiles(tid);
}
else{
	isavailableseat="no";
	for(i=0;i<ticketsArray.length;i++){
		var ticketd=ticketsArray[i];
		if(document.getElementById("qty_"+ticketd).type=='hidden'){
			document.getElementById("qty_"+ticketd).value=0;
			if(document.getElementById("show_"+ticketd))
			document.getElementById("show_"+ticketd).innerHTML=0;
		}
	}
	alert("Few of the seats you are trying to book are currently on hold or already soldout");
	if($('registration')){
		$('registration').show();
	}
	if($('eventdate')){
		$('eventdate').disabled=false;
	}
	if($('ticket_div')){
		$('ticket_div').hide();
	}
	if($('ticket_timer')){
		$('ticket_timer').remove();
		clearTimeout(reg_timeout);
	
	}
	if($('seatingsection')){
		hideTicLoadingImage();
		$('seatingsection').innerHTML='';
		getseatingsection();
	}
	updatecurrentaction("tickets page");
}
}

function submitProfiles(tid){
var eid=document.getElementById("eid").value;
$('ebee_profile_frm').action='/embedded_reg/profileformaction.jsp?tid='+tid+'&seatingenabled='+seating_enabled_tkt_wedget+'&ticketids='+ticketsArray+'&eventdate='+evtdate+'&timestamp='+(new Date()).getTime();
$('ebee_profile_frm').request( {
onSuccess: ProfileActionResponse,
onFailure:  failureJsonResponse
});

}

function ProfileActionResponse(response){
data=response.responseText;
var statusJson=eval('('+data+')');
var status=statusJson.status;
fbsharepopup=statusJson.showfbsharepopup;
if(status=='Success'){

getPaymentSection(tranid,eventid);

}
}

//**************************************addeded for screen split*********************************
function getPaymentSection(tid,eid){

new Ajax.Request('/embedded_reg/paymentsection.jsp?timestamp='+(new Date()).getTime(),{
method: 'get',
parameters:{eid:eid,tid:tid},
onSuccess: PrcocesPaymentSectionResponse,
onFailure:  failureJsonResponse
});
}

function PrcocesPaymentSectionResponse(response){
document.getElementById('registration').style.display='none';
document.getElementById('profile').style.display='none';
document.getElementById('paymentsection').style.display='block';
hideTicLoadingImage();
if(document.getElementById("eventdate"))
document.getElementById("eventdate").disabled=true;

if(document.getElementById('pageheader')){
document.getElementById('pageheader').style.display='block';
document.getElementById('pageheader').innerHTML='<a name="ticketing"></a>'+headers.paymentpage;

}

document.getElementById('paymentsection').innerHTML=response.responseText;
location.href='#ticketing';
profilepageclickcount=0;
updatecurrentaction("payment section");
}

function getProfilePage(){
if(document.getElementById("imageLoad")){
Element.hide('imageLoad');
loaded = true;
}
	  
document.getElementById('paymentsection').style.display='none';
if(document.getElementById('profilesubmitbtn'))
document.getElementById('profilesubmitbtn').style.display='block';
document.getElementById('profile').style.display='block';
if(document.getElementById('pageheader')){
if(headers.profilepage!=''){
document.getElementById('pageheader').style.display='block';
document.getElementById('pageheader').innerHTML=headers.profilepage;
}
else
document.getElementById('pageheader').style.display='none';
}
profilepageclickcount=0;
updatecurrentaction("profile page");
}

//**************************************addeded for screen split*********************************

function getConfirmation(tid,eid){
if(document.getElementById("backgroundPopup"))
	document.getElementById("backgroundPopup").style.display='none';
if($('ticket_div')){
		$('ticket_div').hide();
	}
if($('ticketpoup_div')){
		$('ticketpoup_div').hide();
	}	
	if($('ticket_timer')){
		$('ticket_timer').remove();
		clearTimeout(reg_timeout);
	
	}

new Ajax.Request('/embedded_reg/done.jsp?timestamp='+(new Date()).getTime(),{
method: 'get',
parameters:{eid:eid,tid:tid,eventdate:evtdate,seatingenabled:seating_enabled_tkt_wedget},
onSuccess: PrcocesConfirmationResponse,
onFailure:  failureJsonResponse
});
}

function PrcocesConfirmationResponse(response){
clickcount=0;

//if(document.getElementById('imageLoad'))
//document.getElementById('imageLoad').style.display='none';
document.getElementById('registration').style.display='block';
document.getElementById('profile').style.display='none';

if(document.getElementById('paymentsection'))
document.getElementById('paymentsection').style.display='none';
if(document.getElementById('pageheader')){
document.getElementById('pageheader').style.display='block';
document.getElementById('pageheader').innerHTML='<a name="ticketing"></a>'+headers.confirmationpage
}

document.getElementById('registration').innerHTML=response.responseText;
hideTicLoadingImage();
location.href='#ticketing';
updatecurrentaction("confirmation page");
if(fbsharepopup!='N'){
	getconfirmationfbsharepopup();
	}
}

//***************************************************************************//
function getEventbeecreditcardScreen(tid,eid){
if(document.getElementById("backgroundPopup"))
document.getElementById("backgroundPopup").style.display="block";
windowOpener(serveradd+'/embedded_reg/payment.jsp?tid='+tid+'&eid='+eid,'Payment_'+tid,'WIDTH=740,HEIGHT=600,RESIZABLE=No,SCROLLBARS=YES,TOOLBAR=NO,LEFT=150,TOP=100');
gPopupIsShown = true;
disableTabIndexes();
}

function getPaypalPaymentsPopUp(tid,eid,paytype){
if(document.getElementById("backgroundPopup"))
document.getElementById("backgroundPopup").style.display="block";

windowOpener('/portal/embedded_reg/paymentdata.jsp?tid='+tid+'&eid='+eid+'&paytype='+paytype,'Payment_'+tid,'WIDTH=950,HEIGHT=700,RESIZABLE=No,SCROLLBARS=YES,TOOLBAR=NO,LEFT=150,TOP=100');
gPopupIsShown = true;
disableTabIndexes();
}

function getPaypalXPaymentsPopUp(tid,eid,paytype){
if(document.getElementById("backgroundPopup"))
document.getElementById("backgroundPopup").style.display="block";
windowOpener('/portal/embedded_reg/paypalxpaymentdata.jsp?tid='+tid+'&eid='+eid+'&paytype='+paytype,'Payment_'+tid,'WIDTH=950,HEIGHT=700,RESIZABLE=No,SCROLLBARS=YES,TOOLBAR=NO,LEFT=150,TOP=100');
gPopupIsShown = true;
disableTabIndexes();
}

function getGooglePaymentsPopUp(tid,eid,paytype){
if(document.getElementById("backgroundPopup"))
document.getElementById("backgroundPopup").style.display="block";

windowOpener('/portal/embedded_reg/googlepaymentdata.jsp?tid='+tid+'&eid='+eid+'&paytype='+paytype,'Payment_'+tid,'WIDTH=740,HEIGHT=500,RESIZABLE=No,SCROLLBARS=YES,TOOLBAR=NO,LEFT=150,TOP=100');
gPopupIsShown = true;
disableTabIndexes();
}

function getMemeberLoginPopUp(eid){
if(document.getElementById("backgroundPopup"))
document.getElementById("backgroundPopup").style.display="block";

windowOpener('/portal/embedded_reg/memberlogingblock.jsp?eid='+eid,'memberLogin','WIDTH=400,HEIGHT=300,RESIZABLE=No,SCROLLBARS=YES,TOOLBAR=NO,LEFT=150,TOP=100');


}

//**********************************************************************************//

var popupWin="";
var modelwin;
var val='';
function windowOpener(url, name, args) 
{
val='';
popupWin="";

if (typeof(popupWin) != "object")
{
popupWin = window.open(url,name,args);

if (popupWin && popupWin.top) {

} else {
alert("Pop-up blocker seem to have been enabled in your browser.\nFor completing registration, please change your Pop-up settings.");
if(document.getElementById("backgroundPopup"))
document.getElementById("backgroundPopup").style.display="none";
clickcount=0;
return;
} 

if(name=='memberLogin'){

val='member';
}
else{
val='register';
}
closeIt();

} 
else 
{
if (!popupWin.closed)
{
popupWin.location.href = url;
}
else 
{
popupWin = window.open(url, name,args);
closeIt();
}
}
popupWin.focus();
}



function closeIt()
{

if(val=='register'){
tid=tranid;
eid=eventid;
}
if (!popupWin.closed)
{
setTimeout("closeIt()",1)//adjust timing
try
{
		
}
catch (err)
{
}
}
else
{
if(document.getElementById("backgroundPopup"))
document.getElementById("backgroundPopup").style.display="none";
if(val=='register'){
if(paymenttype=='paypal'&&paymentmode=='paypalx')
getPaypalxStatus();
else
getStatus();
}
else{
if(document.getElementById('clubuserid').value!='')
EnableMemberTickets();
}
if($('seatingsection'))
	displaydivpopuptimeup();
}
}


var eventbeepaymentclickcount=0;
function AjaxSubmit(action){
eventbeepaymentclickcount++;
if(eventbeepaymentclickcount>1)
return;
if(document.getElementById('ebeepay'))
document.getElementById('ebeepay').style.display='none';
if(action=='cancel'){
eventbeepaymentclickcount=0;
window.close();

return;
}
$('form-register-event').request({
onComplete:EbeepaymentResponse
});
}

function EbeepaymentResponse(response){
data=response.responseText;
var statusJson=eval('('+data+')');
var status=statusJson.status;

tranid=statusJson.tid;
eventid=statusJson.eid;

if(status=='success'){
$("cardScreenContent").update("<table height='200px'><tr><td></td></tr></table><center>Your event ticket purchase is completed successfully<br/><a href='#' onClick='window.close();return false;'>Click here to reach confirmation page. Please print confirmation page and bring it to the venue</a> </center>");
eventbeepaymentclickcount=0;
}
else if(status=='alreadyCompleted'){
$("cardScreenContent").update("<table height='200px'><tr><td></td></tr></table><center>Your event registration is already completed. Your card is not charged this time.<br/><a href='#' onClick='window.close();return false;'>Click here to reach confirmation page</a> </center>");
eventbeepaymentclickcount=0;
}
else
{
if(document.getElementById('ebeepay'))
document.getElementById('ebeepay').style.display='block';
eventbeepaymentclickcount=0;
var info ="<table class='error'>";
info+="There are "+statusJson.errors.length+" Error[s]";
for(var i=0;i<statusJson.errors.length;i++){
if(statusJson.errors[i].indexOf("please try back later")>-1)
{
		document.getElementById('cardScreenContent').style.display='none';
		$("errormsg").innerHTML="<table width='90%' align='center' valign='middle'><tr><td height='200'></td></tr><tr><td align='center' valign='top'>We haven’t received payment confirmation from our credit card processing company, your registration is still pending, we will email you status within 24 hours! </td></tr><tr valign='top'><td align='center'><input type='button' onclick='window.close();return false;' value='OK' /></td></tr></table>"
		document.getElementById('errormsg').style.display='block';
	break;
}
info += "<tr><td >"+statusJson.errors[i]+"</td></tr>";
}
info +="</table>";
$('paymenterror').update(info);
}
}

function getStatus(){
tid=document.getElementById('tid').value;
new Ajax.Request('/embedded_reg/checkstatus.jsp?timestamp='+(new Date()).getTime(), {
method: 'get',
parameters:{tid:tid},
onSuccess: PrcocesgetStatusResponse,
onFailure:  failureJsonResponse
});
}

function PrcocesgetStatusResponse(response){
data=response.responseText;
	var statusJson=eval('('+data+')');
	var status=statusJson.status;
	if(status=='Completed'){
	getConfirmation(tid,eid);
	}
	else if(status=='Processing'){
	//for google transaction
	getConfirmation(tid,eid);
	}
	else if(status=='waiting'){
	//paypal not yet completed payment
	getConfirmation(tid,eid);
	}
	else if(status=='ccfatalerror'){
		//Eventbee CC Fatal Error
		refreshPage();
	}
	else if(paymenttype=='paypal'){
	clickcount=0;
	showContinueOptions(tid,eid);
	}
	else{
 	clickcount=0;
	}
}


function getPaypalxStatus(){
new Ajax.Request('/embedded_reg/papalxstatus.jsp?timestamp='+(new Date()).getTime(), {
method: 'get',
parameters:{tid:tranid},
onCreate : startLoading("Loading"),
onSuccess: PrcocesPaypalxResponse,
onFailure:  failureJsonResponse
});

}

function PrcocesPaypalxResponse(response){

data=response.responseText;
	var statusJson=eval('('+data+')');
	
	var status=statusJson.status;
	if(status=='Completed')
	getConfirmation(tid,eid);
	
    else if(status=='INCOMPLETE'||status=='PROCESSING'||status=='EXPIRED'){
	if(document.getElementById('imageLoad'))
document.getElementById('imageLoad').style.display='none';

document.getElementById('profile').style.display='none';

if(document.getElementById('profile'))
document.getElementById('paymentsection').style.display='none';

if(document.getElementById('pageheader')){
document.getElementById('pageheader').style.display='none';
}

document.getElementById('registration').style.display='block';
document.getElementById('registration').innerHTML=statusJson.msg;	
}
else if(status=='CREATED'||status=='INVALID'){
	clickcount=0;
	  Element.hide('imageLoad');
	  loaded = true;
	  document.getElementById('paymentsection').style.display='block';
 	}
 	else
 	{
 	clickcount=0;
		  Element.hide('imageLoad');
		  loaded = true;
	  document.getElementById('paymentsection').style.display='block';
 	
 	}
}

function showContinueOptions(tid,eid) {
new Ajax.Request('/embedded_reg/continueoptions.jsp?timestamp='+(new Date()).getTime(),{
method: 'get',
parameters:{eid:eid,tid:tid},
onSuccess: showOptions,
onFailure:  failureJsonResponse
});
}


function showOptions(response){
var el = document.getElementById("imageLoad");
if (el) {
document.getElementById("profile").style.display='none'
document.getElementById("paymentsection").style.display='none'
el.innerHTML =response.responseText;
document.getElementById("imageLoad").style.display='block';
}
}

function continueRegistration(){
document.getElementById("paymentsection").style.display='block';
document.getElementById("imageLoad").style.display='none';

}

function processRegistration(tid,eid,paytype){
if($('paymentsection'))
$('paymentsection').hide();
showTicLoadingImage("Loading...");
new Ajax.Request('/embedded_reg/registrationprocess.jsp?timestamp='+(new Date()).getTime(), {
method: 'get',
parameters:{eid:eid,tid:tid,paytype:paytype},
onSuccess: PrcocesRegResponse,
onFailure: failureJsonResponse
});
}

function PrcocesRegResponse(response){
var data=response.responseText;
var statusJson=eval('('+data+')');
var status=statusJson.status;
if(status=='Success')
getConfirmation(tranid,eventid);
else
showErrorMessage();
}

//***********************PAYPAL PAMENT SCREEN************************

function closePaypalPopUp(){
window.close();
}
//***********************PAYPAL PAMENT SCREEN ************************

//***********************GOOGLE PAMENT SCREEN************************

function closeGooglePopUp(){
window.close();
}

//***********************GOOGLE PAMENT SCREEN************************

function refreshPage(){
window.location.reload(true);
}


function showAttendeesList(groupid){
var attdate='';
var eventtype='';
var showlist=true;
if(document.getElementById('event_date')){
insertOptionBefore('attendeelist');
var index=document.getElementById('event_date').selectedIndex;
var attdate=document.getElementById('event_date').options[index].value;

eventtype ='rsvp';
if(attdate=='Select Date'){
attdate=' ';
showlist=false;
}

}

if(showlist){

new Ajax.Request('/customevents/showattendeelist.jsp?timestamp='+(new Date()).getTime(), {
	  method: 'get',
	  parameters:{groupid:groupid,eventdate:attdate,eventtype:eventtype},
	  onSuccess: AttendeesListResponse,
	  onFailure:  failureJsonResponse
  });


}
else{

if($('attendeeinfo'))
$('attendeeinfo').innerHTML='';;
}
	
	
}


function AttendeesListResponse(response){
if($('attendeeinfo'))
$('attendeeinfo').update(response.responseText);		
}


function submitMemberLogin(){
$('membercommunity').request({
onComplete:MemberLoginResponse
});
}

function MemberLoginResponse(response){
data=response.responseText;
responsejsondata=eval('(' + data + ')');
var status=responsejsondata.status;
if(status=='Success'){
parent.window.forward(responsejsondata.userid);
}
else
alert("invalid Login");
}


function EnableMemberTickets(){

for(var i=0;i<ticketsArray.length;i++){
ticketd=ticketsArray[i];		
ticketWidgets[ticketd].ClearMemberTicketLogin();
		}
		
if($('seatingsection'))		{
	showmemberseats();
}
}

function forward(id){
opener.document.forms['regform'].clubuserid.value=id;
window.close();
}

function checkGoogleStatus(tid,eid){
setTimeout("getStatus()",2000)


}

function checkPaymentStatus(tid,eid){
setTimeout("getStatus()",2000)


}

//***************************************************************

function CheckTheTicketsStatus(){
var count=0;
for(ticketd in ticketWidgets){
if(ticketWidgets[ticketd].ticketIsAvailable=='Y'&&ticketWidgets[ticketd].ticketStatusMsg!='NA')
count++
}
if(count==0){
document.getElementById("registerBttn").style.display='none';
document.getElementById("calculatelink").style.display='none';
}
else{
document.getElementById("registerBttn").style.display='block';
document.getElementById("calculatelink").style.display='block';
}
}


var loaded = false;
var paymentstatusmsg='';
function startLoading(msg){
document.getElementById("paymentsection").style.display='none';
paymentstatusmsg=msg;
 loaded = false;
 showLoadingImage();
 	}

function showLoadingImage() {

var el = document.getElementById("imageLoad");
if (el && !loaded) {
el.innerHTML = paymentstatusmsg+' ......<br/><br/><br/><img src="/home/images/ajax-loader.gif">';
new Effect.Appear('imageLoad');
}
}

function getRsvpAttendeeList(groupid){
	new Ajax.Request('/customevents/rsvpattendeelist.jsp?timestamp='+(new Date()).getTime(), {
	  method: 'get',
	  parameters:{groupid:groupid},
	  onSuccess: AttendeesListResponse,
	  onFailure:  failureJsonResponse
  });
	
	
}

function createFBSectionForHeader(fbconnapi,eid){
	FB_RequireFeatures(["XFBML"], function(){
		FB.Facebook.init(fbconnapi, "/portal/xd_receiver.jsp");
		Confirmationpagefbfeed(eid);
		if(FB.Facebook.apiClient!=null && FB.Facebook.apiClient.get_session()!=null){
			
		} 
		});
	}

function copyByuerData(ticketid){
var phone='';
var fname=document.getElementById('q_buyer_fname_1').value;
var lname=document.getElementById('q_buyer_lname_1').value;
var email=document.getElementById('q_buyer_email_1').value;
if(document.getElementById('q_buyer_phone_1'))
phone=document.getElementById('q_buyer_phone_1').value;
if(document.getElementById('q_'+ticketid+'_fname_1'))
document.getElementById('q_'+ticketid+'_fname_1').value=fname;
if(document.getElementById('q_'+ticketid+'_lname_1'))
document.getElementById('q_'+ticketid+'_lname_1').value=lname;
if(document.getElementById('q_'+ticketid+'_email_1'))
document.getElementById('q_'+ticketid+'_email_1').value=email;
if(document.getElementById('q_'+ticketid+'_phone_1'))
document.getElementById('q_'+ticketid+'_phone_1').value=phone;
}

function setNewTransactionId(newTrnId){
$('regform').tid.value=newTrnId;
tranid=newTrnId;
}

function ignorekeypress(e){
var keycode;
if (e) keycode = e.which;
if(keycode==13)
return false;
else 
return true;

}

function seatingticketidlabel(){
 new Ajax.Request('/embedded_reg/seating/seatingticket.jsp?timestamp='+(new Date()).getTime(), {
	 method: 'get',
	 parameters:{eid:eventid},
	 onSuccess: seatingticketresponseassign,
	 onFailure:  failureJsonResponse
	 });
}

function seatingticketresponseassign(response){
var seatingticket=response.responseText;
seatingticketidresponse=eval('(' + seatingticket + ')');
Initialize("registration");
}

function seatingticketresponse(){
notavailableticketids=[];
var cur_ids=seatingticketidresponse.seatticketid+"";

var sel_tic_id=new Array();
ticket_ids_seats=cur_ids.split(",");
sel_tic_id=cur_ids.split(",");
for(i=0;i<sel_tic_id.length;i++){
	var cur_id=sel_tic_id[i];
	var dropdown_id='qty_'+cur_id;
	var dropdown_id1='show_'+cur_id;
	if($(dropdown_id) && $(dropdown_id).disabled==true){
		notavailableticketids[notavailableticketids.length]=cur_id;
		memberseatticketids[memberseatticketids.length]=cur_id;
		var tic_dropdown=document.getElementById(dropdown_id);
		var drop_down_length=tic_dropdown.length;
		min_ticketid[cur_id]=tic_dropdown[1].value;
		max_ticketid[cur_id]=tic_dropdown[Number(drop_down_length)-1].value;
	}
	else if($(dropdown_id) && $(dropdown_id).type!='hidden'){
		var td_id="td_ticketid_"+cur_id;
		var tic_dropdown=document.getElementById(dropdown_id);
		var drop_down_length=tic_dropdown.length;
		min_ticketid[cur_id]=tic_dropdown[1].value;
		max_ticketid[cur_id]=tic_dropdown[Number(drop_down_length)-1].value;
		$(td_id).innerHTML="";
		$(td_id).innerHTML="<center title='Select Seats below'><span id='"+dropdown_id1+"' style='font-size:14px;margin-left:40px' >0</span></center><input value='0' type='hidden' name='"+dropdown_id+"' id='"+dropdown_id+"'>Select seats";
		
	}
	else{
		notavailableticketids[notavailableticketids.length]=cur_id;
	}
	
}
}

function getticketseatsdisplay(){
for(i=0;i<ticket_ids_seats.length;i++){
	var tktID=ticket_ids_seats[i];
	
	if($('qty_'+tktID)){
	if(ticketseatcolor[tktID]!=undefined){
		var seatingimg='seatingimg_'+tktID;
		var cell=document.getElementById(tktID);
		var div=document.createElement("div");
		div.setAttribute('id',seatingimg);
		div.className='widgetcontainer';
		cell.appendChild(div);
		
		var allimgs="";
		var groupid=$('ticketGroup_'+tktID).value;
		if(ticket_groupnames[groupid]!=undefined){
			allimgs="<table><tr><td style='width: 26px;' rowspan='3'></td><td>";
		}
		var ticketcolor=ticketseatcolor[tktID];
		for(j=0;j<ticketcolor.length;j++){
			allimgs=allimgs+"<img src='/main/images/seatingimages/"+ticketcolor[j]+".png' style='padding:5px; border:0px;'> ";
				
		}
		if(ticket_groupnames[groupid]!=undefined){
			allimgs=allimgs+"</td></tr></table>";
		}
		
		if(document.getElementById(seatingimg))
		document.getElementById(seatingimg).innerHTML=allimgs;
	}

	}
	}
	
}

function updatecurrentaction(cur_action){
new Ajax.Request('/embedded_reg/updatetempaction.jsp?timestamp='+(new Date()).getTime(), {
	method: 'post',
	parameters:{eid:eventid,tid:tranid,current_action:cur_action}
	});
}

function getJsonFormat(){
	var jsonFormat="{";
	if($('seatingsection')){
		var tick_id=$('ticketids').value;
		var tic_id=tick_id.split(",");
		for(i=0;i<tic_id.length;i++){
			if(sel_ticket[tic_id[i]]!=undefined){
				jsonFormat=jsonFormat+'"'+tic_id[i]+'":['+sel_ticket[tic_id[i]]+']';
				if(i!=tick_id.length-1){
				jsonFormat=jsonFormat+",";
				}
				}
		}
	}
	jsonFormat=jsonFormat+"}";
	return jsonFormat;
}

function insertOptionBefore(purpose){ 
  var elSel;
if(purpose=='tickets')
  elSel = document.getElementById('eventdate');
  else
    elSel = document.getElementById('event_date');

  if(elSel.options.length>0){
  var elOptOld = elSel.options[0]; 
  if(elOptOld.text!='--Select Date--'){
    var elOptNew = document.createElement('option');
    elOptNew.text = '--Select Date--';
    elOptNew.value = 'Select Date';
    
    
    try {
      elSel.add(elOptNew, elOptOld); // standards compliant; doesn't work in IE
    }
    catch(ex) {
      elSel.add(elOptNew, 0); // IE only
    }
  
  elSel.selectedIndex=0;
}}
}

function showTicLoadingImage(msg) {
loaded = false;
var el = document.getElementById("imageLoad");
if (el && !loaded) {
el.innerHTML='';
el.innerHTML = msg+'<br/><img src="/home/images/ajax-loader.gif">';
//new Effect.Appear('imageLoad');
Element.show('imageLoad');
}
}

function hideTicLoadingImage(){
if(document.getElementById("imageLoad")){

Element.hide('imageLoad');
loaded = true;
}
}
