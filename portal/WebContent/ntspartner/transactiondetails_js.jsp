var ajaxwin;
var loopid;
function getAmount(amount){
var tamount=""+amount;
	if(tamount.indexOf(".",0)>-1){
		var l=tamount.length-1;
		var k=tamount.indexOf(".",0);
		if((l-k)==1){
		tamount=tamount+"0";
		}
	}else{
	tamount=tamount+".00";
}

return tamount;
}
function RemoveDecimals(amount){
var tempamount=""+amount;
var idx=tempamount.indexOf(".",0);
if(idx<0){
	
	}
else
	{
	var tempamount=tempamount.substr(0,idx);
	}
return tempamount;
}
function hideattendee(){
ajaxwin.hide();
}

function updateAttendeeDetails(transactionid,tokenid,platform,cardtype,eid,secretcode,from,trackcode,mgrtokenid){
var firstname=trim(document.getElementById('firstname').value);
if(firstname=="") {
alert("Enter firstname");
return false;
}
var lastname=trim(document.getElementById('lastname').value);
if(lastname=="") {
alert("Enter lastname");
return false;
}
var email=trim(document.getElementById('email').value);
if(email=="") {
alert("Enter E-mail");
return false;
}

advAJAX.submit(document.getElementById("editattendeedetails"), {
onSuccess : function(obj) { 	    
var data=obj.responseText; 
if(data.indexOf("Success")>-1){
window.location.href="/"+urlbase+"/transaction.jsp?updated=yes&tokenid="+tokenid+"&GROUPID="+eid+"&groupid="+eid+"&cardtype="+cardtype+"&platform="+platform+"&key="+transactionid+"&secretcode="+secretcode+"&from="+from+"&trackcode="+trackcode+"&mgrtokenid="+mgrtokenid;
}else
document.getElementById("updatemsg").innerHTML=data;
},
onError : function(obj) { alert("Error: " + obj.status);}
});
}
function callModifyTicket(eid, elmindex, selindex,discount,qty){
modifyticket(eid, elmindex, selindex-1,discount,qty);
}

function deleteattendee(transactionid, eid, attendeekey,tokenid,platform,cardtype,secretcode,from,trackcode,mgrtokenid){
advAJAX.get( {
url : '/portal/ntspartner/deleteattendeedetails.jsp?groupid='+eid+'&transactionid='+transactionid+'&attendeekey='+attendeekey,
onSuccess : function(obj) {
var data=obj.responseText;	
window.location.href="/"+urlbase+"/transaction.jsp?tokenid="+tokenid+"&GROUPID="+eid+"&groupid="+eid+"&cardtype="+cardtype+"&platform="+platform+"&key="+transactionid+"&secretcode="+secretcode+"&from="+from+"&trackcode="+trackcode+"&mgrtokenid="+mgrtokenid;
},
onError : function(obj) { alert("Error: " + obj.status); }
});
}

function deleteTransactions(transactionid,eventid,tokenid)
{
advAJAX.get( {
url : '/portal/eventmanage/deleteManualTransactions.jsp?transactionid='+transactionid+'&eventid='+eventid,
onSuccess : function(obj) {
var data=obj.responseText;	
window.location.href="/"+urlbase+"/attendeelist_report.jsp?isdeleted=yes&tokenid="+tokenid+"&GROUPID="+eventid;
},
onError : function(obj) { alert("Error: " + obj.status); }
});
}
function canceltransaction(transactionid,eventid,secretcode,from,trackcode,mgrtokenid)
{

var agree;

	agree=confirm("Registration information of this transaction will be removed.");
	
	if (agree){	

advAJAX.get( {
url : '/portal/eventmanage/canceltransaction.jsp?transactionid='+transactionid+'&eventid='+eventid+'&mgrtokenid='+mgrtokenid,
onSuccess : function(obj) {
var data=obj.responseText;	
window.location.href="/"+urlbase+"/reg_reports.jsp?filter=manager&evttype=event&GROUPID="+eventid+"&secretcode="+secretcode+"&from="+from+"&trackcode="+trackcode+"&mgrtokenid="+mgrtokenid;
},
onError : function(obj) { alert("Error: " + obj.status); }
});
}
else
{return false;
}
}
function reactivatetransaction(transactionid,eventid,secretcode,from,trackcode,mgrtokenid)
{

advAJAX.get( {
url : '/portal/eventmanage/reactivatetransaction.jsp?transactionid='+transactionid+'&eventid='+eventid+'&mgrtokenid='+mgrtokenid,
onSuccess : function(obj) {
var data=obj.responseText;	
window.location.href="/"+urlbase+"/reg_reports.jsp?filter=manager&evttype=event&GROUPID="+eventid+"&secretcode="+secretcode+"&from="+from+"&trackcode="+trackcode+"&mgrtokenid="+mgrtokenid;
},
onError : function(obj) { alert("Error: " + obj.status); }
});

}
function editdetails(key, eid, attendeekey,tokenid,platform,cardtype,secretcode,from,trackcode,mgrtokenid){
ajaxwin=dhtmlmodal.open("ajaxbox", "ajax", "/portal/ntspartner/editattendeedetails.jsp?key="+key+"&eid="+eid+"&attendeekey="+attendeekey+"&tokenid="+tokenid+"&platform="+platform+"&cardtype="+cardtype+"&secretcode="+secretcode+"&from="+from+"&trackcode="+trackcode+"&mgrtokenid="+mgrtokenid, "Edit Attendee", "width=650px,height=400px,resize=0,scrolling=1,center=1", "recal") 		

}

function modifyTicketReg(transactionid, eid,cardtype,secretcode,from,trackcode,mgrtokenid){
ajaxwin=dhtmlmodal.open("ajaxbox", "ajax", "/portal/ntspartner/modifyTicketDetails.jsp?transactionid="+transactionid+"&eid="+eid+"&cardtype="+cardtype+"&secretcode="+secretcode+"&from="+from+"&trackcode="+trackcode+"&mgrtokenid="+mgrtokenid, "Modify Transaction ", "width=650px,height=400px,resize=0,scrolling=1,center=1", "recal") 		

}

function ViewAddNotes(transactionid, eid,cardtype,secretcode,from,trackcode,mgrtokenid){
ajaxwin=dhtmlmodal.open("ajaxbox", "ajax", "/portal/ntspartner/viewaddnotes.jsp?transactionid="+transactionid+"&eid="+eid+"&cardtype="+cardtype+"&secretcode="+secretcode+"&from="+from+"&trackcode="+trackcode+"&mgrtokenid="+mgrtokenid, "View/Add Notes ", "width=650px,height=400px,resize=0,scrolling=1,center=1", "recal") 		

}
function modifyticket(eventid,i,selindex,discount,qty){


document.getElementById('ticketname'+i).innerHTML=ticketsdata[selindex][2];
document.getElementById('ticketprice'+i).innerHTML=ticketsdata[selindex][0];
document.getElementById('chngticket'+i).style.display="none";
document.getElementById('alltickets'+i).style.display="block";


}
function calculateamount(index,totalindex){

if(document.getElementById('error'))
document.getElementById('error').innerHTML="";
var tprice=document.getElementById('ticketprices'+index).value;
var discount=document.getElementById('discount'+index).value;

document.getElementById('ticketprices'+index).value=getAmount(tprice);
document.getElementById('discount'+index).value=getAmount(discount);

var qty=document.getElementById('qty'+index).value;
var tqty=RemoveDecimals(qty);
document.getElementById('qty'+index).value=tqty;
var qty=document.getElementById('qty'+index).value;

if(qty<0)
{
document.getElementById('qty'+index).value=0;
}
if(discount<0)
{
document.getElementById('discount'+index).value="0.00";
}
var discount=document.getElementById('discount'+index).value;
var qty=document.getElementById('qty'+index).value;

if((isNaN(discount))||((isNaN(qty))) || (discount<0) || (qty<0))
{
document.getElementById('error').innerHTML='<font color="red">Enter Valid Values</font>';
return false;
}
else
{
total=(tprice*qty)-discount;	
document.getElementById('totalval'+index).value=getAmount(total);
if(total<0)
{
document.getElementById('totalval'+index).value=getAmount(0);
document.getElementById('discount'+index).value=getAmount(0);


}
var totalamt=0;
var totdiscount=0;
var i;
for (i=1;i<=totalindex;i++){
var discount1=Number(document.getElementById('discount'+i).value);
var totalval1=Number(document.getElementById('totalval'+i).value);
totalamt=Number(totalamt)+Number(totalval1);
totdiscount=Number(totdiscount)+Number(discount1);
}
netcalculation(totalamt,totdiscount);


}

}
function netcalculation(totalamt,totdiscount)
{
document.getElementById('totalamount1').value=getAmount(totalamt);
document.getElementById('totalamount').innerHTML=getAmount(totalamt);
document.getElementById('totaldiscount1').value=getAmount(totdiscount);
document.getElementById('totaldiscount').innerHTML=getAmount(totdiscount);
var tax=document.getElementById('tax').value;

document.getElementById('tax').value=getAmount(tax);
if(tax<0){
document.getElementById('tax').value="0.00";
}

var net=Number(totalamt)+Number(tax);
document.getElementById('net').innerHTML=getAmount(net);

}
function changetax1()
{
var tax=document.getElementById('tax').value;

document.getElementById('tax').value=getAmount(tax);
if(tax<0){
document.getElementById('tax').value="0.00";
}
netcalculation(document.getElementById('totalamount').innerHTML,document.getElementById('totaldiscount').innerHTML);
}

function changetotal(index,totalindex){
if(document.getElementById('error'))
document.getElementById('error').innerHTML="";
var totalamt=0;
var totdiscount=0;
var i;
for (i=1;i<=totalindex;i++){
var discount1=Number(document.getElementById('discount'+i).value);
var totalval1=Number(document.getElementById('totalval'+i).value);
if(totalval1<0){
document.getElementById('totalval'+i).value=getAmount(0);
}else{
document.getElementById('totalval'+i).value=getAmount(totalval1);
}
var totalval1=Number(document.getElementById('totalval'+i).value);
totalamt=Number(totalamt)+Number(totalval1);
totdiscount=Number(totdiscount)+Number(discount1);
}

netcalculation(totalamt,totdiscount);


}



function cancelticket(eventid,elmindex){


document.getElementById('chngticket'+elmindex).style.display="block";
document.getElementById('ticketname'+elmindex).style.display="block";


document.getElementById('actions'+elmindex).style.display="none";
document.getElementById('alltickets'+elmindex).style.display="none";
document.getElementById('discount'+elmindex).disabled=true;
document.getElementById('qty'+elmindex).disabled=true;
}

function changeticket(eventid,elmindex) {
document.getElementById('chngticket'+elmindex).style.display="none";
document.getElementById('ticketname'+elmindex).style.display="none";


document.getElementById('actions'+elmindex).style.display="block";
document.getElementById('alltickets'+elmindex).style.display="block";
document.getElementById('discount'+elmindex).disabled=false;
document.getElementById('qty'+elmindex).disabled=false;

var temp="allticket"+elmindex;
var SelObj=document.getElementById(temp);
if(SelObj.options.length>1){
return;
}
for (var i=0; i < ticketsdata.length;++i){       	
var oOption=document.createElement("option");
var txt = document.createTextNode(ticketsdata[i][2]);
oOption.setAttribute('value',ticketsdata[i][0]);
oOption.appendChild(txt);
SelObj.appendChild(oOption);
}

}

function finalSubmit(eventid,totindex,transactionid,cardtype,secretcode,from,trackcode,mgrtokenid){
var index;
for (index=1;index<=totindex;index++){
var discount=document.getElementById('discount'+index).value;
var qty=document.getElementById('qty'+index).value;
var totalval=document.getElementById('totalval'+index).value;

if((isNaN(discount))||((isNaN(qty))) || (discount<0) || (qty<0) || (totalval<0))
{
document.getElementById('error').innerHTML='<font color="red">Enter Valid Values</font>';
return false;
} 	
}
var flag=true;
for (index=1;index<=totindex;index++){
var qty=document.getElementById('qty'+index).value;
if(qty>0){
flag=true;
break;
}
else {
flag=false;
}
}
if(!flag){
alert("Quantities for all tickets can not be zero. To totally remove all tickets, use Delete Transaction feature");
return false;

}
var totalamt=document.getElementById('totalamount').innerHTML;
var totdiscount=document.getElementById('totaldiscount').innerHTML;
if((isNaN(totalamt))||((isNaN(totdiscount))) || (totalamt<0) || (totdiscount<0))
{		 	
document.getElementById('error').innerHTML='<font color="red">Enter Valid Amount</font>';
return false;
} 
if(document.getElementById('error'))
document.getElementById('error').innerHTML="";
var tax=document.getElementById('tax').value;
var net=Number(totalamt)+Number(tax);
document.getElementById('net').innerHTML=getAmount(net);
document.getElementById('totalamount1').value=getAmount(totalamt);
document.getElementById('totaldiscount1').value=getAmount(totdiscount);
advAJAX.submit(document.getElementById("modifyform"), {
onSuccess : function(obj) { 	    
var data=obj.responseText; 
window.location.href="/"+urlbase+"/transaction.jsp?GROUPID="+eventid+"&groupid="+eventid+"&cardtype="+cardtype+"&key="+transactionid+"&secretcode="+secretcode+"&from="+from+"&trackcode="+trackcode+"&mgrtokenid="+mgrtokenid;

},
onError : function(obj) { alert("Error: " + obj.status);}
});
}

function addNoteSubmit(eventid,transactionid,cardtype,secretcode,from,trackcode,mgrtokenid){
var msg=trim(document.getElementById("newnote").value);
if(msg=="")
{
alert("Enter Note");
return false;
}
advAJAX.submit(document.getElementById("viewaddnotesform"), {
onSuccess : function(obj) { 	    
var data=obj.responseText; 
window.location.href="/"+urlbase+"/transaction.jsp?GROUPID="+eventid+"&groupid="+eventid+"&cardtype="+cardtype+"&key="+transactionid+"&secretcode="+secretcode+"&from="+from+"&trackcode="+trackcode+"&mgrtokenid="+mgrtokenid;
//window.location.href="/"+urlbase+"/viewaddnotes.jsp";

},
onError : function(obj) { alert("Error: " + obj.status);}
});
}