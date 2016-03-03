var eventid;
var tid;
var jsondata;
var amountjsondata;
var discountsjson;
var memberjsondata;
var reqTicketsList=new Array();
var optTicketsList=new Array();
var allTicketsList=new Array();
var memberTickets=new Array();
var donationsArray=new Array();
var currentprofilecount=0;
//**************************************************
function ajaxSubmitFormForTicketSelections(){
document.getElementById('ticketingpageform').action='/ningregister/ticketingformaction.jsp';
jsonAJAX.submit(document.getElementById('ticketingpageform'),{
onSuccess : function(obj) {
	data=obj.responseText;
	
	responsejsondata=eval('(' + data + ')');
	if(responsejsondata.status&&responsejsondata.status=='error'){
	alert("Unable to calculate ticketing total. Please try again");
	return;
	}
	amountjsondata=responsejsondata.amounts;
	displayTotalAmounts();
	updatePaymentTypesDisplay();
	enableMemberTickets();
},
onError : function(obj) { 
        enableMemberTickets();
	alert("Unable to calculate ticketing total. Please try again"); 
}
});
}
//**************************************************
function ajaxSubmitForDiscountedTotals(showAlert){
resetPrices();
document.getElementById('ticketingpageform').action='/ningregister/ticketingformaction.jsp?submitdiscount=Y';
jsonAJAX.submit(document.getElementById('ticketingpageform'),{
onSuccess : function(obj) {
	data=obj.responseText;
	responsejsondata=eval('(' + data + ')');
	if(responsejsondata.status&&responsejsondata.status=='error'){
		if(showAlert){
		alert("Unable to calculate ticketing total. Please try again");	
		}
	}
	discountsjson=responsejsondata.discounts;
	fillDiscountBox();
	discountedprices=responsejsondata.discountedprices;
	updatePrices(discountedprices);
	amountjsondata=responsejsondata.amounts;
	displayTotalAmounts();
	updatePaymentTypesDisplay();
	enableMemberTickets();
},
onError : function(obj) { 
	if(showAlert){
	alert("Unable to apply the discount. Please try again."); 
	}
	enableMemberTickets();
}
});
}
//**************************************************
function ajaxSubmitForTicketsAndProfile(){
document.getElementById('ticketingpageform').action='/ningregister/ticketingformaction.jsp?submitprofile=Y';
document.getElementById('ticketingpageform').currentcount.value=currentprofilecount;
document.getElementById('ticketingpageform').attribsetid.value=jsondata.profileset.attribsetid;
jsonAJAX.submit(document.getElementById('ticketingpageform'),{
onSuccess : function(obj) {
	data=obj.responseText;
	responsejsondata=eval('(' + data + ')');
	if(responsejsondata.status&&responsejsondata.status=='error'){
	alert("Unable to calculate ticketing total. Please try again");
	return;
	}
	amountjsondata=responsejsondata.amounts;
	displayTotalAmounts();
	updatePaymentTypesDisplay();
	if(responsejsondata.profilestatus && responsejsondata.profilestatus=='error'){
		alert("Unable to process attendee profiles. Please try again");
		
	}else{		
		submitBasedOnAmount();
	}
	enableMemberTickets();
},
onError : function(obj) { 
        enableMemberTickets();
	alert("Unable to calculate ticketing total. Please try again"); 
}
});
}
//**************************************************
function ajaxGetTicketPageData(eid, tranid){

eventid=eid;
tid=tranid;
jsonAJAX.get( {
url   : '/ningregister/ticketingPageJson.jsp?eid='+eventid+'&tid='+tid,
onSuccess : function(obj) {
	data=obj.responseText;
	try{
	jsondata=eval('(' + data + ')');
	if(jsondata.status&&jsondata.status=='error'){
	
		displayErrorMessage();
		return;
	}
	if(jsondata.istransactioncompleted &&jsondata.istransactioncompleted=='Y'){
		handleCompletedTransactionCase();
		return;
	}
	if(jsondata.isUnavailableReqTicketsExists &&jsondata.isUnavailableReqTicketsExists=='Y'){
		handleNoTicketsCase();
		return;
	}
	discountsjson=jsondata.discounts;
	amountjsondata=jsondata.amounts;
	getMemberTicketsLoginBlock();
	getRequiredTicketsBlock();
	getOptionalTicketsBlock();
	if(allTicketsList.length==0){
	handleNoTicketsCase();
	return;
	}
	getPaymentsBlock();
	fillAttendeeProfileBox();
	
	fillDiscountBox();
	
	if(discountsjson.discountcode!=''){
	ajaxSubmitForDiscountedTotals(false);
	}else{
	displayTotalAmounts();	
	
	}
	}catch(err){
	
	displayErrorMessage();
	}
	document.getElementById('center').style.display='block';
	document.getElementById('loadingmsg').style.display='none';
},
onError : function(obj) { 
	
	displayErrorMessage();
}
});

}
//******************************************************
function ajaxHandleCCPayment(){
	jsonAJAX.get( {
		url   : '/ningregister/ccpaymentformaction.jsp?eid='+eventid+'&tid='+tid,
		onSuccess : function(obj) {
		data=obj.responseText;
		ccjsondata=eval('(' + data + ')');
		document.getElementById('ebeeccform').amount.value=amountjsondata.grandtotamount;
		document.getElementById('ebeeccform').submit();
		},
		onError : function(obj) { 
		alert("Error: " + obj.status); 
		}
		});	
	}
//**************************************************
function ajaxHandleGooglePayment(){
	jsonAJAX.get( {
	url   : '/ningregister/googledata.jsp?eid='+eventid+'&tid='+tid,
	onSuccess : function(obj) {
	data=obj.responseText;
	googlejsondata=eval('(' + data + ')');
	document.getElementById('googleform').submit();
	},
	onError : function(obj) { 
	alert("Error: " + obj.status); 
	}
	});	
}
//**************************************************
function ajaxHandlePaypalPayment(){
	jsonAJAX.get( {
	url   : '/ningregister/paypalcontent.jsp?eid='+eventid+'&tid='+tid,
	onSuccess : function(obj) {
	data=obj.responseText;
	paypaljsondata=eval('(' + data + ')');	
	document.getElementById('paypalform').action=paypaljsondata.action;
	document.getElementById('paypalform').tax.value=paypaljsondata.tax;
	document.getElementById('paypalform').notify_url.value=paypaljsondata.notify_url;
	document.getElementById('paypalform').item_name.value=paypaljsondata.item_name;
	document.getElementById('paypalform').business.value=paypaljsondata.business;
	document.getElementById('paypalform').amount.value=paypaljsondata.amount;
	document.getElementById('paypalform').currency_code.value=paypaljsondata.currency_code;
	document.getElementById('paypalform').submit();
	},
	onError : function(obj) { 
	alert("Error: " + obj.status); 
	}
	});	
}
//*************************************************
function ajaxSubmitMemberLogin(){
document.getElementById('ticketingpageform').action='/ningregister/memberloginformaction.jsp';
jsonAJAX.submit(document.getElementById('ticketingpageform'),{
onSuccess : function(obj) {
	data=obj.responseText;
	memberjsondata=eval('(' + data + ')');
	if(memberjsondata.isMemberLoggedIn && memberjsondata.isMemberLoggedIn=='Y'){
	jsondata.isMemberLoggedIn='Y';
	document.getElementById('afterloginmsg').style.display='block';
	document.getElementById('hublogin').style.display='none';
	document.getElementById('membererror').innerHTML='';
	enableMemberTickets();
	}else{
	document.getElementById('membererror').innerHTML='Invalid Login';
	}
},
onError : function(obj) { 
	alert("Error: " + obj.status); 
}
});
}
//**************************************
function updateScreenBasedOnTicketSelection(isRequiredTicket){
ajaxSubmitFormForTicketSelections();
if(isRequiredTicket){
fillAttendeeProfileBox();
}
}
//**************************************************
function updatePaymentTypesDisplay(){
strnopayshowtype='none';
strmainpayshowtype='block'
if(validateTickets() && amountjsondata.grandtotamount=='0.00'){
strnopayshowtype='block';
strmainpayshowtype='none';
}
document.getElementById('nopaymentoption').style.display=strnopayshowtype;
if(document.getElementById('paypalpaymentoption')){
document.getElementById('paypalpaymentoption').style.display=strmainpayshowtype;
}
if(document.getElementById('googlepaymentoption')){
document.getElementById('googlepaymentoption').style.display=strmainpayshowtype;
}
if(document.getElementById('ebeeccpaymentoption')){
document.getElementById('ebeeccpaymentoption').style.display=strmainpayshowtype;
}
if(document.getElementById('otherpaymentoption')){
document.getElementById('otherpaymentoption').style.display=strmainpayshowtype;
}
}
//**************************************************
function displayTotalAmounts(){
document.getElementById('totamount').innerHTML=amountjsondata.totamount;
document.getElementById('disamount').innerHTML=amountjsondata.disamount;
document.getElementById('netamount').innerHTML=amountjsondata.netamount;
if(document.getElementById('taxamount')){
document.getElementById('taxamount').innerHTML=amountjsondata.tax;
}
if(document.getElementById('grandtotamount')){
document.getElementById('grandtotamount').innerHTML=amountjsondata.grandtotamount;
}
}
//**************************************
function fillDiscountBox(){
if(discountsjson && discountsjson.IsCouponsExists && discountsjson.IsCouponsExists=='Y'){
document.getElementById('discountCouponsBox').style.display='block';
if(discountsjson.discountapplied && discountsjson.discountapplied=='Y'){
document.getElementById('discountmsg').innerHTML=discountsjson.discountmsg;
document.getElementById('discountcode').value=discountsjson.discountcode;
}
}else{
document.getElementById('discountCouponsBox').style.display='none';
}
}
//**************************************
function getMemberTicketsLoginBlock(){
if(jsondata.memberTicketsExists && jsondata.memberTicketsExists=='Y'){
document.getElementById('MemberTicketsLoginBlock').style.display='block';
}
if(jsondata.isMemberLoggedIn && jsondata.isMemberLoggedIn=='Y'){
document.getElementById('afterloginmsg').style.display='block';
document.getElementById('hublogin').style.display='none';
}
}
//**************************************
function handleCompletedTransactionCase(){
document.getElementById("center").style.height='300px';
document.getElementById('center').style.display='block';
document.getElementById('loadingmsg').style.display='none';
document.getElementById("center").innerHTML="<br/><br/><div align='center'>You seem to have already completed the registration. Click here to view the <a href='/ningregister/registrationdone.jsp?tid="+tid+"&eid="+eventid+"'>confirmation details</a></div>";
}
//**************************************
function handleNoTicketsCase(){
document.getElementById("center").style.height='300px';
document.getElementById('center').style.display='block';
document.getElementById('loadingmsg').style.display='none';
document.getElementById("center").innerHTML="<br/><br/><div align='center'>Sorry, currently there are no tickets available for this event</div>";
}
//**************************************
function displayErrorMessage(){
document.getElementById("center").style.height='300px';
document.getElementById('center').style.display='block';
document.getElementById('loadingmsg').style.display='none';
document.getElementById("center").innerHTML="<br/><br/><div align='center'>Sorry, currently ticketing cannot be processed for this event</div>";
}
//**************************************

function getRequiredTicketsBlock(){
var ticketsgroup=jsondata.ticketsgroup.reqgroups;
getTicketsBlock(ticketsgroup, "requiredTicketsBlock", "reqticketstable", true);
}
//**************************************
function getOptionalTicketsBlock(){
var ticketsgroup=jsondata.ticketsgroup.optgroups;
getTicketsBlock(ticketsgroup, "optionalTicketsBlock", "optticketstable", false);
}
//**************************************
function getTicketsBlock(ticketsgroup, ticketsBlockName, ticketstablename, isRequiredTicket){
if((ticketsgroup) && (ticketsgroup.length>0)){
document.getElementById(ticketsBlockName).style.display='block';
var srcTable = document.getElementById(ticketstablename);
for(i=0;i<ticketsgroup.length;i++){
groupclassnamebyrow=((i%2)==0)?'evenbase':'oddbase';
var looseticket=true;
var tktgrp=ticketsgroup[i];
if(tktgrp.group_name=='' && tktgrp.group_desc==''){
}else{
looseticket=false;
newTR=srcTable.insertRow(srcTable.rows.length);
newTD=newTR.insertCell(0);
newTD.colSpan = 5;
newTD.className = groupclassnamebyrow;
newTD.innerHTML =tktgrp.group_name+"<br>"+tktgrp.group_desc;
}
var tckts=tktgrp.tickets;
for(j=0;j<tckts.length;j++){
var tckt=tckts[j];
allTicketsList.push(tckt.ticket_id);
if(isRequiredTicket){
reqTicketsList.push(tckt.ticket_id);
}else{
optTicketsList.push(tckt.ticket_id);
}
var enablestring='';
var checkedstring='';

var membertktmessage=''
if(tckt.selected && tckt.selected=='Y'){
	checkedstring="checked='true'";
}

if(tckt.isMemberTicket && tckt.isMemberTicket=='Y' ){
memberTickets.push(tckt.ticket_id);
if(jsondata.isMemberLoggedIn && jsondata.isMemberLoggedIn=='Y'){
}else{
	enablestring="disabled='true'";
	membertktmessage="<span class='smallestfont'>Member Only Option</span> &nbsp;&nbsp;<span style='cursor: pointer; text-decoration: underline' class='smallestfont' id='login_"+tckt.ticket_id+"'   onclick='focusMemberLogin();' >Login</span><br/>";
}
}
strselectionControlName='ticketSelect';
strselectionControlType='radio';
if(isRequiredTicket && tckts.length==1&&ticketsgroup.length==1){
strselectionControlType='checkbox';
}
if(!isRequiredTicket){
	strselectionControlType='checkbox';
	strselectionControlName='optTicketSelect';
}
var ticket_discount='0.00';
var final_price=tckt.ticket_price;
var ticket_displaystr=tckt.ticket_price;
var final_processfee=tckt.processing_fee;
var donationticket=false;
var isdonation=tckt.isdonation;
if(isdonation=='Yes'){
donationticket=true;
donationsArray.push(tckt.ticket_id);
}
if(tckt.final_price && tckt.final_price!=tckt.ticket_price){
ticket_discount=tckt.discount;
final_price=tckt.final_price;
ticket_displaystr='<del>'+tckt.ticket_price+'</del><br/>'+final_price;
}
if(tckt.final_price && tckt.final_price=='0.00'){
final_processfee='0.00';
}
if(!donationticket){
strhiddenfield="<input type='hidden' id='price_"+tckt.ticket_id+"' name='price_"+tckt.ticket_id+"' value='"+tckt.ticket_price+"' />";
strhiddenfield+="<input type='hidden' id='finalprice_"+tckt.ticket_id+"' name='finalprice_"+tckt.ticket_id+"' value='"+final_price+"' />";
}
else{
strhiddenfield="<input type='hidden' id='price_"+tckt.ticket_id+"' name='price_"+tckt.ticket_id+"' value='"+tckt.donationprice+"' />";
strhiddenfield+="<input type='hidden' id='finalprice_"+tckt.ticket_id+"' name='finalprice_"+tckt.ticket_id+"' value='"+tckt.donationprice+"' />";
}
strhiddenfield+="<input type='hidden' id='discount_"+tckt.ticket_id+"' name='discount_"+tckt.ticket_id+"' value='"+ticket_discount+"' />";
strhiddenfield+="<input type='hidden' id='processfee_"+tckt.ticket_id+"' name='processfee_"+tckt.ticket_id+"' value='"+tckt.processing_fee+"' />";
strhiddenfield+="<input type='hidden' id='finalprocessfee_"+tckt.ticket_id+"' name='finalprocessfee_"+tckt.ticket_id+"' value='"+final_processfee+"' />";

if(donationticket)
strhiddenfield+="<input type='hidden' id='ticketqty_"+tckt.ticket_id+"' name='ticketqty_"+tckt.ticket_id+"' value='1' />";

document.getElementById("dynahiddenelements").innerHTML+=strhiddenfield;

newTR=srcTable.insertRow(srcTable.rows.length);
newTD=newTR.insertCell(0);
newTD.className = groupclassnamebyrow;
var secondtdindex=1;
if(looseticket){
newTD.colSpan = 2;
secondtdindex=1;

}else{
//for group tickets add a empty td
newTD.innerHTML ="";
newTD=newTR.insertCell(1);
newTD.className = groupclassnamebyrow;
secondtdindex=2;
}

newTD.innerHTML ="<input type='"+strselectionControlType+"' id='ticketselection_"+tckt.ticket_id+"' name='"+strselectionControlName+"' value='"+tckt.ticket_id+"' "+checkedstring+" "+enablestring+" onClick='setDonationPrice("+tckt.ticket_id+","+isRequiredTicket+");'> "+tckt.ticket_name+"<br/> "+membertktmessage+tckt.description;

newTD=newTR.insertCell(secondtdindex);
newTD.className = groupclassnamebyrow;
if(!donationticket)
newTD.innerHTML ="<span class='inform' id='displayprice_"+tckt.ticket_id+"'>"+ticket_displaystr+"</span>";
else
newTD.innerHTML ="<input type='text' size='5' id='donation_"+tckt.ticket_id+"' name='donation_"+tckt.ticket_id+"' value='"+tckt.donationprice+"' onblur='setDonationPrice("+tckt.ticket_id+","+isRequiredTicket+");'>";

newTD=newTR.insertCell(secondtdindex+1);
newTD.className = groupclassnamebyrow;
if(!donationticket)
newTD.innerHTML ="<span  class='inform' id='displayfee_"+tckt.ticket_id+"'>"+final_processfee+"</span>";

newTD=newTR.insertCell(secondtdindex+2);
newTD.className = groupclassnamebyrow;

tktqtystr="<span class='inform'><select   id='ticketqty_"+tckt.ticket_id+"' name ='ticketqty_"+tckt.ticket_id+"' onChange='updateScreenBasedOnTicketSelection("+isRequiredTicket+");'>";

for(k=parseFloat(tckt.min_qty);k<=tckt.max_qty;k++){
qtyoptionstr='';
if(tckt.selectedqty && tckt.selectedqty==''+k){
	qtyoptionstr='selected=selected';
}

tktqtystr+="<option name='"+k+"' value='"+k+"' "+qtyoptionstr+" >"+k+"</option>";
}
tktqtystr+="</select></span>";
if(!donationticket)
newTD.innerHTML =tktqtystr;
}
}
}else{
document.getElementById(ticketsBlockName).innerHTML='';
}
}
//**************************************
function resetPrices(){
for(var index=0;index<allTicketsList.length;index++){
var ticketid=allTicketsList[index];

old_price=document.getElementById('price_'+ticketid).value;
old_processfee=document.getElementById('processfee_'+ticketid).value;
document.getElementById('finalprice_'+ticketid).value=old_price;
document.getElementById('discount_'+ticketid).value='0.00';
document.getElementById('finalprocessfee_'+ticketid).value=old_processfee;
if(document.getElementById('displayfee_'+ticketid))
document.getElementById('displayfee_'+ticketid).innerHTML=old_processfee;
if(document.getElementById('displayprice_'+ticketid))
document.getElementById('displayprice_'+ticketid).innerHTML=old_price;
}
}
//**************************************
function updatePrices(discountedprices){

if(discountedprices){
for(var index=0;index<discountedprices.length;index++){
var ticketid=discountedprices[index].ticketid;
var donation=discountedprices[index].isdonation;
if(donation!='Yes'){
document.getElementById('finalprice_'+ticketid).value=discountedprices[index].final_price;
document.getElementById('discount_'+ticketid).value=discountedprices[index].discount;
}
if(discountedprices[index].final_price=='0.00'){
document.getElementById('finalprocessfee_'+ticketid).value='0.00';
if(document.getElementById('displayfee_'+ticketid))
document.getElementById('displayfee_'+ticketid).innerHTML='0.00';
}
old_price=document.getElementById('price_'+ticketid).value;
ticket_displaystr='<del>'+old_price+'</del><br/>'+discountedprices[index].final_price;
if(document.getElementById('displayprice_'+ticketid))
document.getElementById('displayprice_'+ticketid).innerHTML=ticket_displaystr;
}
}
}
//**************************************
function enableMemberTickets(){
if(jsondata.isMemberLoggedIn && jsondata.isMemberLoggedIn=='Y'){
	for(var index=0;index<memberTickets.length;index++){
	var ticketid=memberTickets[index];
	document.getElementById('ticketselection_'+ticketid).enabled=true;
	document.getElementById('ticketselection_'+ticketid).disabled=false;
	if(document.getElementById('login_'+ticketid))
	document.getElementById('login_'+ticketid).innerHTML='';
	}
}
}
//**************************************
function ValidateAndSubmit(){
isOK=checkForValidDonations();
if(isOK){
isOK=validateTickets();
}
else
{
alert("Please uncheck the option, if you do not wish to pay donation");
return;
}
if(isOK){
isOK=validateAttendeeProfiles();
}else{
alert("Please select a ticket for registration");
document.getElementById('ticketserror').innerHTML='Please select a ticket';
return;
}
if(isOK){
ajaxSubmitForTicketsAndProfile();
}else{
alert("All * marked profile entries are required to be filled");
}
}
//**************************************
function validateAttendeeProfiles(){
var reqcount=getRequiredProfilesCount();
for(var pi=0;pi<reqcount;pi++){
var isOK= validateAttendeeProfile(pi+1);
if(!isOK){

return false;
}
}
return true;
}
//**************************************
function validateAttendeeProfile(index){
if(document.getElementById('P'+index+'fname').value==''){
	return false;
}
if(document.getElementById('P'+index+'lname').value==''){
	return false;
}
if(document.getElementById('P'+index+'email').value==''){
	return false;
}
if(document.getElementById('P'+index+'phone').value==''){
	return false;
}
attribs=jsondata.profileset.attribs;
for(var k=0;k<attribs.length;k++){
if(attribs[k].req && attribs[k].req=='Y'){
var controlname='P'+index+'Q'+(k+1);		
		switch(attribs[k].type){
		 case 'text':
		 if(document.getElementById(controlname).value==''){
			return false;
		 }
		 break;
		 case 'textarea':
		 if(document.getElementById(controlname) .value==''){
			return false;
		 }
		 break;
		 case 'radio':
		 var radiooptions=attribs[k].options;
		 var selectedcount=0;
		 for(var ri=0;ri<radiooptions.length;ri++){
		 var item=document.getElementById(controlname+'_'+ri);
			if(item && item.checked){
				selectedcount++;
				break;				
			}
		 }
		 if(selectedcount==0){
		 	return false;
		 }
		 break;
		 case 'checkbox':
		 var checkoptions=attribs[k].options;
		 var selectedcount=0;
		 for(var ci=0;ci<checkoptions.length;ci++){
		  var item=document.getElementById(controlname+'_'+ci);
		 if(item && item.checked){
			selectedcount++;
			break;
		 }
		 }
		 if(selectedcount==0){
		 	return false;
		 }
		 break;
		 
		}
	}
}
return true;
}
//**************************************
function submitBasedOnAmount(){
	if(amountjsondata.grandtotamount=='0.00'){
	document.getElementById('center').style.display='none';
	document.getElementById('loadingmsg').style.display='block';
	document.nopaymentform.paytype.value='nopayment';
	document.getElementById('nopaymentform').submit();
	return;
	}
	paymenttype=document.getElementById('otherpayment');
	if(paymenttype && paymenttype.checked){
	document.getElementById('center').style.display='none';
	document.getElementById('loadingmsg').style.display='block';
	document.nopaymentform.paytype.value='other';
	document.getElementById('nopaymentform').submit();
	return;
	}
	paymenttype=document.getElementById('ebeecc');
	if(paymenttype && paymenttype.checked){
	document.getElementById('center').style.display='none';
	document.getElementById('loadingmsg').style.display='block';
	ajaxHandleCCPayment();
	return;
	}
	paymenttype=document.getElementById('paypalpayment');
	if(paymenttype && paymenttype.checked){
	document.getElementById('center').style.display='none';
	document.getElementById('loadingmsg').style.display='block';
	ajaxHandlePaypalPayment();
	return;
	}
	paymenttype=document.getElementById('googlepayment');
	if(paymenttype && paymenttype.checked){
	ajaxHandleGooglePayment();
	return;
	}
	alert("Select a payment type");	
	
}
//**************************************
function validateTickets(){
if(reqTicketsList.length>0){
	for(var i=0;i<reqTicketsList.length;i++){
		if(document.getElementById('ticketselection_'+reqTicketsList[i]).checked){
		document.getElementById('ticketserror').innerHTML='';
		return true;
		}
	}  
}else{
for(var i=0;i<optTicketsList.length;i++){
if(document.getElementById('ticketselection_'+optTicketsList[i]).checked){
document.getElementById('ticketserror').innerHTML='';
return true;
}
}
}
return false;
}
//**************************************
function getPaymentsBlock(){

var paytypes="<table width='100%'>";
if(jsondata.paymenttypes.paypal){
var paypalselected='';
if(jsondata.paymenttypes.payselected && jsondata.paymenttypes.payselected=='paypal'){
paypalselected="checked='true'";
}
paytypes+="<tr><td height='30' align='left' id='paypalpaymentoption' style='display:block;'><input type='radio' name='paytype' id='paypalpayment' value='paypal' "+paypalselected+" > PayPal Credit Card Processing <img src='/home/images/paypalcc.gif'    border='0' alt='PayPal Payment Processing'   /> <font class='smallestfont'> (No PayPal account required)</font></td></tr>";
}
if(jsondata.paymenttypes.google){
/*
var googleselected='';
if(jsondata.paymenttypes.payselected && jsondata.paymenttypes.payselected=='google'){
googleselected="checked='true'";
}
paytypes+="<tr><td height='30' id='googlepaymentoption' style='display:block;'><input type='radio' name='paytype' id='googlepayment' value='google'  "+googleselected+" > Google Credit Card processing <img src='/home/images/googlecc.gif'    border='0' alt='Google Payment Processing'   /><font class='smallestfont'>(Google account required)</font></td></tr>";
*/
}
if(jsondata.paymenttypes.eventbee){
var eventbeeselected='';
if(jsondata.paymenttypes.payselected && jsondata.paymenttypes.payselected=='eventbee'){
eventbeeselected="checked='true'";
}
paytypes+="<tr><td height='30' id='ebeeccpaymentoption' style='display:block;'><input type='radio' name='paytype' id='ebeecc' value='eventbee'  "+eventbeeselected+" > Eventbee Credit Card Processing  <img src='/home/images/eventbeecc.gif'    border='0' alt='Eventbee Payment Processing'   /><font class='smallestfont'>(No Eventbee login required)</font></td></tr>";
}
if(jsondata.paymenttypes.other){
var otherselected='';
if(jsondata.paymenttypes.payselected && jsondata.paymenttypes.payselected=='other'){
otherselected="checked='true'";
}
paytypes+="<tr><td height='30' id='otherpaymentoption' style='display:block;'><input type='radio' name='paytype' id='otherpayment' value='other'  "+otherselected+" > Other payment<br/>";
paytypes+="<font class='smallestfont' >"+jsondata.paymenttypes.other+"</font></td></tr>";
}
paytypes+="<tr><td height='30' id='nopaymentoption' style='display:none;'> No Payment</td></tr>";
paytypes+="</table>";
document.getElementById('paymentBox').innerHTML=paytypes;
}
//**************************************
function getRequiredProfilesCount(){
var reqcount=1;
if(jsondata.profileset.collectAll && jsondata.profileset.collectAll=='Y'){
for(var i=0;i<reqTicketsList.length;i++){
if(document.getElementById('ticketselection_'+reqTicketsList[i]).checked){
reqcount=document.getElementById('ticketqty_'+reqTicketsList[i]).selectedIndex;
reqcount=document.getElementById('ticketqty_'+reqTicketsList[i]).options[reqcount].value;
}
}
}
 return Number(reqcount);
}
//**************************************
function fillAttendeeProfileBox(){
var requiredcount=getRequiredProfilesCount();
var extra=requiredcount-currentprofilecount;
var srcTable = document.getElementById("profilestable");
var tBody = srcTable.getElementsByTagName('tbody')[0];
if(extra<0){
for(var i=currentprofilecount-1; i>=requiredcount; i--)
{
	srcTable.deleteRow(i);

}
}else{
for(var i=currentprofilecount; i<requiredcount; i++)
{
	var newTR=srcTable.insertRow(srcTable.rows.length);
	var newTD=newTR.insertCell(0);
	newTD.innerHTML = buildProfileForm(i+1);
	filledvals=jsondata.profiledata;
	if(filledvals && filledvals.length>i){
		fillPreviousProfileData(i+1);
	}	
}
}
currentprofilecount=requiredcount;
}
//**************************************
function fillPreviousProfileData(index){
filledvals=jsondata.profiledata;
var fname=filledvals[index-1].fname;
var lname=filledvals[index-1].lname;
var phone=filledvals[index-1].phone;
var email=filledvals[index-1].email;
if(document.getElementById('P'+index+'fname') && fname){
	document.getElementById('P'+index+'fname').value=fname;
}
if(document.getElementById('P'+index+'lname') && lname){
	document.getElementById('P'+index+'lname').value=lname;
}
if(document.getElementById('P'+index+'phone') && phone){
	document.getElementById('P'+index+'phone').value=phone;
}
if(document.getElementById('P'+index+'email') && email){
	document.getElementById('P'+index+'email').value=email;
}

attribs=jsondata.profileset.attribs;
responses=filledvals[index-1].attribresponses;
if(responses && attribs && responses.length>0 && attribs.length>0){
for(var j=0;j<responses.length;j++){
	question=responses[j].q;
	var matchindex=getProfileMatchingQid(question);
	if(matchindex>-1){
		var controlname='P'+index+'Q'+(matchindex+1);	
		switch(attribs[matchindex].type){
		 case 'text':
		 if(document.getElementById(controlname) ){
		document.getElementById(controlname).value=responses[j].A;
		 }
		 break;
		 case 'textarea':
		 if(document.getElementById(controlname) ){
		 document.getElementById(controlname).value=responses[j].A;
		 }
		 break;
		 case 'radio':
		 var radiooptions=attribs[matchindex].options;
		 for(var ri=0;ri<radiooptions.length;ri++){
		 var item=document.getElementById(controlname+'_'+ri);
			if(item && item.value==responses[j].A){
				item.checked=true;
			}
		 }			 	
		 break;
		 case 'checkbox':
		 var checkoptions=attribs[matchindex].options;
		 choices=(responses[j].A).split(",");
		 for(var ci=0;ci<checkoptions.length;ci++){
		 if(isContainedInArray(choices,checkoptions[ci])){
		 var item=document.getElementById(controlname+'_'+ci);
		 if(item){
			item.checked=true;
		 }
		 }
		 }
		 break;
		 case 'select':
		 var selectoptions=document.getElementById(controlname).options;
		 for(var si=0;si<selectoptions.length;si++){
			if( selectoptions[si].value==responses[j].A){
				document.getElementById(controlname).selectedIndex=si;
			}
		 }				
		 break;
		}
	}
}
}
}
//**************************************
function isContainedInArray(refArray, candidateString){
if(refArray){
for(var ai=0;ai<refArray.length;ai++){
if(refArray[ai]==candidateString){
return true;
}
}
}
return false;
}
//**************************************
function getProfileMatchingQid(response_q){
var mid=-1;
attribs=jsondata.profileset.attribs;
if(attribs && attribs.length>0){
	for(var qid=0;qid<attribs.length;qid++){
		attrib_q=attribs[qid].question;
		if(response_q==attrib_q){
			mid=qid;
			break;
		}
	}
}
return mid;
}
//**************************************
function buildProfileForm(index){
attribs=jsondata.profileset.attribs;
var Atteneeprofilelabel="";
if(index>1){
var word=toWords(index);
 Atteneeprofilelabel="Attendee "+word;
}
var str="";
str="<table>";
str+="<tr><td colspan=2>"+Atteneeprofilelabel+"</td></tr>";
str+="<tr><td colspan=2></td></tr>";
str+="<tr><td>First Name *</td><td><input type='text' size='30' id='P"+index+"fname' name='P"+index+"fname' /></td></tr>";
str+="<tr><td>Last Name *</td><td><input type='text' size='30' id='P"+index+"lname' name='P"+index+"lname'  /></td></tr>";
str+="<tr><td>Email *</td><td><input type='text' size='30' id='P"+index+"email' name='P"+index+"email'  /></td></tr>";
str+="<tr><td>Phone *</td><td><input type='text' size='30' id='P"+index+"phone' name='P"+index+"phone'  /></td></tr>";

if(attribs){
for(var i=0;i<attribs.length;i++){
var controlname='P'+index+'Q'+(i+1);
str+="<tr><td valign='top'>"+attribs[i].question;
if(attribs[i].req && attribs[i].req=='Y'){
str+=" *";
}
str+="</td><td>";
if(attribs[i].type=='text'){
str+="<input type='text' size='"+attribs[i].textbox_size+"' name='"+controlname+"' id='"+controlname+"'/>";
}else if(attribs[i].type=='textarea'){
str+="<textarea rows ='"+attribs[i].rows+"' cols='"+attribs[i].cols+"' name='"+controlname+"'  id='"+controlname+"'></textarea>";
}else if(attribs[i].type=='radio'){
for(var j=0;j<attribs[i].options.length;j++){
str+="<input type='radio'  id='"+controlname+"_"+j+"' name='"+controlname+"' value='"+attribs[i].options[j]+"'/> "+attribs[i].options[j]+"<br/>";
}
}else if(attribs[i].type=='select'){
str+="<select id='"+controlname+"' name='"+controlname+"'>";
for(var j=0;j<attribs[i].options.length;j++){
str+="<option value='"+attribs[i].options[j]+"'/>"+attribs[i].options[j]+"</option>";
}
str+="</select>";
}
else{
for(var j=0;j<attribs[i].options.length;j++){
str+="<input type='checkbox' id='"+controlname+"_"+j+"' name='"+controlname+"' value='"+attribs[i].options[j]+"'/> "+attribs[i].options[j]+"<br/>";
}
}
str+="</td></tr>";
}
}
str+="<tr><td height=20 colspan=2></table>";
return str;
}
//**************************************
function focusMemberLogin(){
try{
document.getElementById("username").focus();
}
catch(err){}
}


//***********************************

function setDonationPrice(ticketid,isRequiredTicket){
if(document.getElementById("ticketselection_"+ticketid).checked==true){
if(document.getElementById("donation_"+ticketid)){
var donamt=document.getElementById("donation_"+ticketid).value;
var donation=donamt;
if(!isNaN(donation)){
document.getElementById("price_"+ticketid).value=donation;
document.getElementById("finalprice_"+ticketid).value=donation;
}
else{
document.getElementById("donation_"+ticketid).value=0;
}
}
}
updateScreenBasedOnTicketSelection(isRequiredTicket);

}


function checkForValidDonations(){
var status=true;
for(i=0;i<donationsArray.length;i++){
var amt=0;
if(document.getElementById("donation_"+donationsArray[i])){
if(document.getElementById("ticketselection_"+donationsArray[i]).checked==true){
amt=document.getElementById("donation_"+donationsArray[i]).value;
if(amt>0){
}
else{
status=false;
}
}
}
else
{
status=true;
}
}
return status
}


 function isEmpty( str){
     strRE = new RegExp( );
    strRE.compile( '^[\s ]*$', 'gi' );
     return strRE.test( str.value );
 }