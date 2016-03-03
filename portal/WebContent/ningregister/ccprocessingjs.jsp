function ajaxValidateCard(){
jsonAJAX.submit(document.getElementById('form-register-event'),{
onSuccess : function(obj) {
	var data=obj.responseText;
	var responsejsondata=eval('(' + data + ')');
	var status=responsejsondata.status;
	if(status=='success'){
	document.getElementById('confirmationform').submit();
	}
	else{
	var info ="<table class='error'>";
	for(var i=0;i<responsejsondata.errors.length;i++){
	info += "<tr><td >"+responsejsondata.errors[i]+"</td></tr>";
	}
	info +="</table>";
	document.getElementById('paymenterror').innerHTML=info;
	}
},
onError : function(obj) { 
	alert("Unable to process credit card information, please try again"); 
}
});
}



function getTransactionAmounts(tid,eid){
jsonAJAX.get( {
		url   : '/ningregister/getTransactionAmounts.jsp?eid='+eid+'&tid='+tid,
		onSuccess : function(obj) {
		var data=obj.responseText;
		var ccjsondata=eval('(' + data + ')');
		if(ccjsondata.status&&ccjsondata.status=='Completed'){
		document.getElementById("paymenterror").style.height='300px';
		document.getElementById("paymenterror").style.align='right';
		document.getElementById('paymenterror').innerHTML="<br/><br/>You seem to have already completed the registration. Click here to view the <a href='/ningregister/registrationdone.jsp?tid="+tid+"&eid="+eid+"'>confirmation details</a>";
		document.getElementById('center').innerHTML='';
		}
		else if(ccjsondata.total&&ccjsondata.total=='0.00'){
		document.getElementById("paymenterror").style.height='300px';
		document.getElementById('paymenterror').innerHTML="<br/><br/>Unable to retrieve your ticketing information. Click here to review <a href='/ningregister/register.jsp?tid="+tid+"&eid="+eid+"'>Registration details</a>";
		document.getElementById('center').innerHTML='';
		}
		else if(ccjsondata.reqTicketSelected=='N'){
		document.getElementById("paymenterror").style.height='300px';
		document.getElementById('paymenterror').innerHTML="<br/><br/>select One Required ticket Option  to continue. Click here to review <a href='/ningregister/register.jsp?tid="+tid+"&eid="+eid+"'>Registration details</a>";
		document.getElementById('center').innerHTML='';
		}
		else if(ccjsondata.total){
		document.getElementById("totalamount").value=ccjsondata.total;
		document.getElementById('grandtotal').innerHTML=ccjsondata.total;
		}
		else{
		document.getElementById("paymenterror").style.height='300px';
		document.getElementById('paymenterror').innerHTML="<br/><br/>Unable to retrieve your ticketing information. Click here to review <a href='/ningregister/register.jsp?tid="+tid+"&eid="+eid+"'>Registration details</a>";
		document.getElementById('center').innerHTML='';
		}
		},
		onError : function(obj) { 
		document.getElementById("paymenterror").style.height='300px';
		document.getElementById('paymenterror').innerHTML="<br/><br/>Unable to retrieve your ticketing information. Click here to review <a href='/ningregister/register.jsp?tid="+tid+"&eid="+eid+"'>Registration details</a>";
		document.getElementById('center').innerHTML='';
		}
		});	
	}
