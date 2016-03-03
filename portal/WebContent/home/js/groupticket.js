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
var context='';
var domain='';
var ticketurl='';
var discountcode='';
var track='';
var serveradd;
var code='';
var headers;
var timestamp;
var bfname='';
var blname='';
var bemail='';
var bphone='';
var paymentmode='';
var promotionenable=true;
var selectTktMsg='';
var clickcount=0;
var selectticketid='';
var trigger_fail_accept=false;
function getGroupTicketsJson(eid){

eventid=eid;
if(document.getElementById('ticketurlcode'))
ticketurl=document.getElementById('ticketurlcode').value;


new Ajax.Request('/groupticket/groupticketsjson.jsp?timestamp='+(new Date()).getTime(), {
  method: 'get',
  parameters:{eid:eid,ticketurl:ticketurl,evtdate:evtdate},
  onSuccess: groupticketJsonResponse,
  onFailure:  failureJsonResponse
  });
 }
 
 function groupticketJsonResponse(response){
  var jsonTicketData=response.responseText;
  tktsData=eval('(' + jsonTicketData + ')');
 
  selectTktMsg=tktsData.selectticketmsg;
   if(tktsData.ticketstatus == 'no'){
	//hideTicLoadingImage();
	
	    document.getElementById('pageheader').style.display='block';
		document.getElementById('pageheader').innerHTML=tktsData.page_header;
		document.getElementById('registration').innerHTML='<center><b>Tickets are currently unavailable</b></center>';
		document.getElementById('ticketrecurring').innerHTML='';
	}
	else{
		
	getGroupTicketsBlock(eventid);
	}
 
  }
 
 
 function getGroupTicketsBlock(eid){
 
 
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

 new Ajax.Request('/groupticket/getgroupticketsblockvm.jsp?timestamp='+(new Date()).getTime(), {
 method: 'get',
 parameters:{eid:eid,track:track,evtdate:evtdate,ticketurl:ticketurl,discountcode:discountcode},
 onSuccess: GroupTicketsBlockresponse,
 onFailure:  failureJsonResponse
 });
 }
 
 function GroupTicketsBlockresponse(response){
  $('registration').update(response.responseText);

//hideTicLoadingImage();
 Initialize("registration");
if(discountcode!=null&&discountcode!=''&&discountcode!='null'){
// getDiscountAmounts();
 }
}

function validateTicketSelect(){
	var ticketarray=new Array();
	var ticketqty=new Array();
	ticketarray=$('ticketids').value.split(',');
	for(i=0;i<ticketarray.length;i++){
		var selqty=$('qty_'+ticketarray[i]).value
		ticketqty[i]=selqty;
	}
	count=0;
	for(i=0;i<ticketqty.length;i++){
		if(ticketqty[i]>0){
			count++;
		}
	}
	if(count==1){
		submitTickets();
	}
	else{
		alert("you can select only one ticket type in one transaction");
		for(i=0;i<ticketarray.length;i++){
			$('qty_'+ticketarray[i]).options[0].selected = "selected";
		}
	}
}
function getGroupTicketProfile(ticketID){
	$('registration').hide();
	selectticketid=ticketID;
	resetalldropdown(ticketID);
	 var selqty=$('qty_'+ticketID).value
	if(Number(selqty)>0)
		submitTickets();
	else
		$('registration').show();
	
}


function submitTickets(){

//document.getElementById('actiontype').value='Order Now';
$('regform').action='/groupticket/groupregformaction.jsp?timestamp='+(new Date()).getTime(),
$('regform').request({
parameters:{evtdate:evtdate,code:code,context:context},
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
new Ajax.Request('/groupticket/profilejsondata.jsp?timestamp='+(new Date()).getTime(), {
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
new Ajax.Request('/groupticket/getprofilesblock.jsp?timestamp='+(new Date()).getTime(), {
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

if(document.getElementById('q_buyer_fname_1'))
document.getElementById('q_buyer_fname_1').focus();
}

function resetalldropdown(ticketID){

var ticketsarray=new Array();
	ticketsarray=$('ticketids').value
	ticketsarray=ticketsarray.split(",");
	for(i=0;i<ticketsarray.length;i++){
	
		if(ticketsarray[i]!=ticketID){
			var	sellist = $('qty_'+ticketsarray[i]);	
			sellist.options[0].selected = "selected";
		}
		
	}
}

function validateProfiles(tid){
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
else if(id=='buyer_email_1')
bemail=CtrlWidgets[id].GetValue();
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
	showTicLoadingImage("Loading");
document.getElementById('profileerr').innerHTML='';
submitProfiles(tid)
}
else{
clickcount=0;
document.getElementById('profilesubmitbtn').style.display='block';
if(parseInt(count)>1)
document.getElementById('profileerr').innerHTML="<font color='red'>There are "+count+" errors</font>";
else
document.getElementById('profileerr').innerHTML="<font color='red'>There is  "+count+" error</font>";
}
}


function submitProfiles(tid){
var eid=document.getElementById("eid").value;
$('ebee_profile_frm').action='/groupticket/profileformaction.jsp?tid='+tid+'&timestamp='+(new Date()).getTime();
$('ebee_profile_frm').request( {
onSuccess: ProfileActionResponse,
onFailure:  failureJsonResponse
});

}





function ProfileActionResponse(response){
data=response.responseText;
var statusJson=eval('('+data+')');
var status=statusJson.status;
if(status=='Success'){

getPaymentSection(tranid,eventid);

}
}


function getProfilePage(){
	if($('trigger_fail_checkbox')){
		if($('trigger_fail_checkbox').checked){
			trigger_fail_accept=true;
		}
		else{
			trigger_fail_accept=false;
		}	
	}
	else{
		trigger_fail_accept=false;
	}
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


}
//**************************************addeded for screen split*********************************
function getPaymentSection(tid,eid){

new Ajax.Request('/groupticket/paymentsection.jsp?timestamp='+(new Date()).getTime(),{
method: 'get',
parameters:{eid:eid,tid:tid,selectticketid:selectticketid},
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
if(trigger_fail_accept==true){
$('trigger_fail_checkbox').checked=true;
$('notrigger_section').style.display='block';
}
else{
	$('trigger_fail_checkbox').checked=false;
	$('notrigger_section').style.display='none';
}

}

function SubmitForm(tid,type,serveraddress){

if($('paymentsection'))
		$('paymentsection').hide();
showTicLoadingImage("Loading");
if($('trigger_fail_checkbox')){
	if($('trigger_fail_checkbox').checked){
		update_failure_action(tid,"Y");
	}
	else{
		update_failure_action(tid,"N");
	}
}
else{
		update_failure_action(tid,"N");
	}
paymenttype=type;
if(clickcount>1)
{
return;
}
tid=document.getElementById('tid').value;
tranid=tid;
serveradd=serveraddress;
var eid=document.getElementById("eid").value;
//if(paymenttype=='eventbee') {
getEventbeecreditcardScreen(tid,eid);
hideimage_showpaysection();
//}
/*
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
*/
}

function getEventbeecreditcardScreen(tid,eid){
if(document.getElementById("backgroundPopup"))
document.getElementById("backgroundPopup").style.display="block";
windowOpener(serveradd+'/groupticket/payment.jsp?tid='+tid+'&eid='+eid,'Payment_'+tid,'WIDTH=740,HEIGHT=600,RESIZABLE=No,SCROLLBARS=YES,TOOLBAR=NO,LEFT=150,TOP=100');
gPopupIsShown = true;
disableTabIndexes();
}


function hideimage_showpaysection(){
hideTicLoadingImage();
if($('paymentsection'))
$('paymentsection').show();

}

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

}
}

function update_failure_action(tid,type){
new Ajax.Request('/groupticket/updatefailureresponse.jsp?timestamp='+(new Date()).getTime(),{
method:'post',
parameters:{tid:tid,type:type},
onFailure:  failureJsonResponse,
});
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

function getConfirmation(tid,eid){
new Ajax.Request('/groupticket/done.jsp?timestamp='+(new Date()).getTime(),{
method: 'get',
parameters:{eid:eid,tid:tid},
onSuccess: PrcocesConfirmationResponse,
onFailure:  failureJsonResponse
});
}

function PrcocesConfirmationResponse(response){
//alert("Confirmation Commented");
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
	else if(paymenttype=='paypal'){
	clickcount=0;
	showContinueOptions(tid,eid);
	}
	else{
 	clickcount=0;
	}
}

function showContinueOptions(tid,eid) {
new Ajax.Request('/groupticket/continueoptions.jsp?timestamp='+(new Date()).getTime(),{
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





function failureJsonResponse(){
clickcount=0;
alert("Sorry this request cannot be processed at this time");
}

function showTicLoadingImage(msg) {
loaded = false;
var el = document.getElementById("imageLoad");
if (el && !loaded) {
el.innerHTML = msg+'<br/><img src="/home/images/images/103.gif">';
//new Effect.Appear('imageLoad');
Element.show('imageLoad');
}
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

function hideTicLoadingImage(){
if(document.getElementById("imageLoad")){

Element.hide('imageLoad');
loaded = true;
}
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
getgroupresponses();
$('profile').hide();
$('registration').show();
//resetalldropdown(0);
}
function getgroupresponses(){
for (var p=0;p<ctrlwidget.length;p++){
var id=ctrlwidget[p];
responsesdata[id]=CtrlWidgets[id].GetValue();
}
}
/*-----------Filling the progress bar and refreshing it------------------*/

var f_eventid='',f_ticketid='',f_trigger_qty='';
function fill_progress_bar(sold_qty,trigger_qty,ticketid,eventid){
	f_eventid=eventid;
	f_ticketid=ticketid;
	f_trigger_qty=trigger_qty;
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

function fill_progress(eid,ticketid,trigger_qty){

//document['refresh_img_'+ticketid].src="/home/images/images/refresh.gif";
$.getJSON("groupticket/fillbar.jsp?eid="+eid+"&ticketid="+ticketid+"&trigger_qty="+trigger_qty+"&timestamp="+(new Date()).getTime(),function(result){
        fill_bar(result);       
    });

}



function fill_bar(result){

var responsedata=result;
var sold_qty1=responsedata.sold_qty;

var trigger_qty1=responsedata.trigger_qty;
var ticketid1=responsedata.ticketid;
var input_id='trigger_action_'+ticketid1;
var eventid1=responsedata.eventid;
if(sold_qty1!=undefined){
if(document.getElementById(input_id).value=='1' && (Number(sold_qty1)>=Number(trigger_qty1))){
document.getElementById("click_here_"+ticketid1).disabled= true;
}
else{
document.getElementById("click_here_"+ticketid1).disabled= false;
}
document.getElementById('countcenter_'+ticketid1).innerHTML=sold_qty1;
fill_progress_bar(sold_qty1,trigger_qty1,ticketid1,eventid1);
//document['refresh_img_'+ticketid1].src="/home/images/images/arrow_cycle.png";
}
}

function reloadpage(){
self.parent.location.reload();
}
/*-------------------end of fill and refresh bar-------------------------*/
function slideit(id,count){

 $('innerdiv_'+id).show();


}



var currentEid='';
var isBannerOpened=false;
function closeBannerWindow(i){
isBannerOpened=false;
if(document.getElementById('tcktwidget_'+i)){
		document.getElementById('tcktwidget_'+i).style.display="none";
		document.getElementById('_EbeeIFrame_'+i).src='';
		if(document.getElementById('_EbeeIFrames_'+i))
			document.getElementById('_EbeeIFrames_'+i).src='';
}


if(document.getElementById('infowidget_'+i)){
		document.getElementById('infowidget_'+i).style.display="none";
		document.getElementById('_EbeeIFrames_'+i).src='';
}



}

function bannerOpener(elmId, frmId, eid,count)
{	
	var serveraddress=document.getElementById('serveraddress').value;
	for(i=0;i<count;i++){
		closeBannerWindow(i);
	}
	if(isBannerOpened) return;
   	document.getElementById(frmId).src=serveraddress+"/groupticketr?customtheme=no&viewType=iframe;resizeIFrame=true&context=web&eid="+eid;
	currentEid=eid;
	//sliderActor.stop();
	document.getElementById(elmId).style.top='30%';
	document.getElementById(elmId).style.left='26%';
	document.getElementById(elmId).style.display="block";
	scrollTo(0,0);
	isBannerOpened=true;
}

function banner_Opener(elmId, frmId, eid,count)
{	
	var serveraddress=parent.document.getElementById('serveraddress').value;
	for(i=0;i<count;i++){
		closeWindow(i);
	}
	if(isBannerOpened) return;
   	parent.document.getElementById(frmId).src=serveraddress+"/groupticketr?customtheme=no&viewType=iframe;resizeIFrame=true&context=web&eid="+eid;
	currentEid=eid;
	//sliderActor.stop();
	parent.document.getElementById(elmId).style.top='30%';
	parent.document.getElementById(elmId).style.left='26%';
	parent.document.getElementById(elmId).style.display="block";
	scrollTo(0,0);
	isBannerOpened=true;
}
function closeWindow(i){
isBannerOpened=false;
if(document.getElementById('tcktwidget_'+i)){
		document.getElementById('tcktwidget_'+i).style.display="none";
		document.getElementById('_EbeeIFrames_'+i).src='';
}

}

function infoOpener(elmId, frmId, eid,count)
{	
	var serveraddress=document.getElementById('serveraddress').value;
	for(i=0;i<count;i++){
		closeBannerWindow(i);
	}
	if(isBannerOpened) return;
   	document.getElementById(frmId).src=serveraddress+"/groupticketeventinfo?customtheme=no&viewType=iframe;resizeIFrame=true&context=web&eid="+eid;
	currentEid=eid;
	//sliderActor.stop();
	document.getElementById(elmId).style.top='30%';
	document.getElementById(elmId).style.left='26%';
	document.getElementById(elmId).style.display="block";
	scrollTo(0,0);
	isBannerOpened=true;
}

var tcktwidgets = [];
/*function windowOpener(elmId, frmId, eid)
{
if(tcktwidgets[elmId]){
}else{
tcktwidgets[elmId]='hide';
}
if(tcktwidgets[elmId]=='hide'){
document.getElementById(elmId).style.display="block";
tcktwidgets[elmId]='show';
}
else{
document.getElementById(elmId).style.display="none";
tcktwidgets[elmId]='hide';
}
}*/

function hide_trigger_section(){
	if($('trigger_fail_checkbox').checked == true)
		$('notrigger_section').show();
	else
		$('notrigger_section').hide();
}
