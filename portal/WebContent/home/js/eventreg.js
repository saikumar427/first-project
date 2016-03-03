var isevtmem='no';
var code;
var tktcost;
var tktqty;
var dreqtotal;
var reqtotal;
var discountamt;
var discontflag=false;
var totamt=0.00;
var distotamt=0.00;
var isloginsubmitted=false;	
var discount;
 var tktqtyinc=0;
 var directsubmitbtnclick=1;
	
function selectOne(name,i){





	if(name.value>0)
	document.form1.ticketSelect[i].checked = true;

	if(document.getElementById("qtypublicTickets"+i).value!=""&&document.form1.ticketSelect[i].checked){
		document.getElementById('showerror').innerHTML='';
		document.getElementById('showtkterror').innerHTML='';
		SubmitTicketOnBlur();
	}else if(document.form1.ticketSelect[i].checked){
		document.getElementById('showtkterror').innerHTML=' Please select one required ticket';
		//document.getElementById("attendeePersonalInfo").innerHTML="";
	}
	
	
	if(document.getElementById("membercommunity")){
	
		if(isloginsubmitted){
		for(i=0;i<memberTickets.length;i++){
		//alert(memberTickets[i]);
		if(document.getElementById("price_"+memberTickets[i]))
		document.getElementById("price_"+memberTickets[i]).disabled=false;
		if(document.getElementById("option_"+memberTickets[i]))
		var option=document.getElementById("option_"+memberTickets[i]).value;
		if(document.getElementById("ival_"+memberTickets[i]))
		var ival=document.getElementById("ival_"+memberTickets[i]).value;
		if(document.getElementById("qty"+option+ival))
		document.getElementById("qty"+option+ival).disabled=false;
		
		}
	}}
	
   



}

function testtrim(str){
	var temp='';
	temp=new String(str);
	temp=temp.replace(/[^a-zA-Z 0-9]+/g,'');
	return temp;
}

function showMemberBlock(){
	var frm=document.getElementById('memberType');
	var options=document.attendeelogininfo.memberType;
	for(var j=0;j<options.length;j++){
		if(options[j].checked==true){
			val=options[j].value;
			break;
		}
	}
	if(val=='evtmem') getLoginBlock();
	else if(val=='newmem') {
	getSignupBlock();
	SubmitTicketOnBlur();
	}
}
function getLoginBlock() {
	advAJAX.get( {
		url   : '/eventregister/attendeeauth/checklogin.jsp?GROUPID='+evtid,
	    onSuccess : function(obj) {
	    document.getElementById('attendeeBlock').innerHTML=obj.responseText;},
		onError : function(obj) { 
		//alert("Error: " + obj.status); 
		}
	});
}



function getCouponBlock(reqt) {
		advAJAX.get( {
		url   : '/eventregister/reg/coupon.jsp?GROUPID='+evtid,
	    onSuccess : function(obj) {
	    
		    document.getElementById('couponBlock').innerHTML=obj.responseText;
		    if(reqt=='refresh'){
		      validateCoupon('General','refresh');
		    }
		   },
	    onError : function(obj) { 
	    //alert("Error: " + obj.status); 
	    }
	});
}


function getMemCouponBlock(reqt1) {
		advAJAX.get( {
		url   : '/eventregister/reg/memcoupon.jsp?GROUPID='+evtid,
	    onSuccess : function(obj) {
		    document.getElementById('memcouponBlock').innerHTML=obj.responseText;
		    if(reqt1=='refresh'){
		    
		    validateCoupon('Member','refresh');
		    }
		   },
	    onError : function(obj) { 
	    //alert("Error: " + obj.status); 
	    }
	});
}




var discountflag=false;
var ticket;
var price;
var tkttype;
function validateCouponTickets(){
if (http_request.readyState == 4) {
         if (http_request.status == 200) {
            var xmldoc = http_request.responseXML;
               if (window.ActiveXObject){
	                  	xmldoc.load(http_request.responseStream);
	                     }  
	                  var tickets = xmldoc.getElementsByTagName('tickets');
	                    
	                  for (var x = 0; x < tickets.length; x++) {
	                  var isdonationticket='';

	                  var status=tickets.item(x).getAttribute('codestatus');
	                  
	                  ticket= xmldoc.getElementsByTagName('ticket');
	                 
	                  if(status.indexOf("success")>-1){
	                     
	                     discountflag=true;
	                     for (var x = 0; x < ticket.length; x++) { 
			     newprice=ticket.item(x).getAttribute('newprice');
			     
			     discount=ticket.item(x).getAttribute('discount');
			     priceid=ticket.item(x).getAttribute('id');
			     price=ticket.item(x).getAttribute('price');
			     tkttype=ticket.item(x).getAttribute('type');
			     isdonationticket=ticket.item(x).getAttribute('isdonation');
			     if(isdonationticket!='Yes'){
			        if(newprice!=null)
			      {
			     
			      // if(newprice==0.0)
			     if(document.getElementById("discount_"+priceid))
			     document.getElementById("discount_"+priceid).value=discount; 
			     if(document.getElementById("ticket_"+priceid))
			     document.getElementById("ticket_"+priceid).innerHTML= '<font color="red"><strike>'+price+'</strike></font>';
		             if(document.getElementById("upticket_"+priceid))
		             document.getElementById("upticket_"+priceid).innerHTML=newprice; 
		             if(document.getElementById("discost_"+priceid))
		             document.getElementById("discost_"+priceid).value=newprice;
			     resetMemCoupon();
			     
			     resetCodeCoupon();
			     getTotalAmt(); 

		             
		             }
		             else{
		            if(document.getElementById("discount_"+priceid))
		             document.getElementById("discount_"+priceid).value='';
		             if(document.getElementById("ticket_"+priceid))
		             document.getElementById("ticket_"+priceid).innerHTML=price;
		             if(document.getElementById("discost_"+priceid))
		             document.getElementById("discost_"+priceid).value=price;
                              
			     getTotalAmt();
			     }
			     }
			      else{
                              if(document.getElementById("donation_"+priceid))
		              document.getElementById("discost_"+priceid).value=document.getElementById("donation_"+priceid).value;
			       getTotalAmt();
			   
			     }
			     
			     
			     
			     }
			     if(coupontype=='General'){
			      document.getElementById("couponcode").value=document.getElementById("discountcode").value;
                               resetCodeCoupon();
			     displayCodeCouponMessages();
			     }
			     else
			     displayMemCouponMessage()
			     
			    }
			    else if(status.indexOf("Not Available")>-1){
			      for (var x = 0; x < ticket.length; x++) { 
			   
			    priceid=ticket.item(x).getAttribute('id');
			   if(document.getElementById("discount_"+priceid))
			    document.getElementById("discount_"+priceid).value='';
			    }
			    document.getElementById("showacouponerror").innerHTML="Sorry, the discount code you entered is no longer available";


			    
			    
			    
			    }
			    else {
			    
                            discountflag=false;
			    for (var x = 0; x < ticket.length; x++) { 
			    priceid=ticket.item(x).getAttribute('id');
			    price=ticket.item(x).getAttribute('price');
			    isdonationticket=ticket.item(x).getAttribute('isdonation');
			     if(isdonationticket!='Yes'){
			    if(document.getElementById("discost_"+priceid))
			    document.getElementById("discost_"+priceid).value=price;
			    if(document.getElementById("ticket_"+priceid))
                            document.getElementById("ticket_"+priceid).innerHTML=price;
                            if(document.getElementById("upticket_"+priceid))
                            document.getElementById("upticket_"+priceid).innerHTML=''; 
                            if(document.getElementById("discount_"+priceid))
                            document.getElementById("discount_"+priceid).value=' '; 
			    
			    }}
			     resetMemCoupon();
			     resetCodeCoupon();
			     if(coupontype=='General')
			     displayCodeCouponError();
			     else
			     if(coupontype=='Member'){
			       displayMemCouponError();
			       
			     }
			     getTotalAmt();
			     }
			    
			    
	                  }
	                   
	                  
	                  
	                  
			
               }  
            
}

}
var username;
var password;
var http_request = false;
var coupontype;
var urls;
   function validateCoupon(type,req) {
  var d1 = new Date();
     coupontype=type;
     
      http_request = false;
      if (window.XMLHttpRequest) { // Mozilla, Safari,...
         http_request = new XMLHttpRequest();
         if (http_request.overrideMimeType) {
            http_request.overrideMimeType('text/xml');
         }
         else{
          try {
	             http_request = new ActiveXObject("Msxml2.XMLHTTP");
	             
	             } catch (e) {
	             try {
	                http_request = new ActiveXObject("Microsoft.XMLHTTP");
	                } catch (e) {}
         }
         
         
         
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
      http_request.onreadystatechange = validateCouponTickets;

      if(type=='General'){
     
      if(req=='isnew'){
      var dcode=document.getElementById("couponcode").value
       code=encodeURIComponent(document.getElementById("couponcode").value);
      document.getElementById("discountcode").value=dcode;
     		    
      urls='/eventregister/reg/validatecoupon.jsp?GROUPID='+evtid+'&code='+code+'&ct='+d1.getTime()+'&isnew=yes';
      }
      else{
     urls='/eventregister/reg/validatecoupon.jsp?GROUPID='+evtid+'&ct='+d1.getTime();
      }
      }
      else if(type=='Member'){
      username=document.getElementById("username").value;
      password=document.getElementById("password").value;
      if(req=='isnew')
      urls='/eventregister/reg/validatememcoupon.jsp?GROUPID='+evtid+'&username='+username+'&password='+password+'&ct='+d1.getTime()+'&isnew=yes';
      else
      urls='/eventregister/reg/validatememcoupon.jsp?GROUPID='+evtid+'&username='+username+'&password='+password+'&ct='+d1.getTime();
      
      
      }
      http_request.open('GET',urls,true);
      
      http_request.send(null);
   }
   









function resetMemCoupon(){
document.getElementById("memshowacouponerror").innerHTML='';
document.getElementById("memshowacouponstatus").innerHTML='';
}
function resetCodeCoupon(){
document.getElementById("showacouponerror").innerHTML='';
document.getElementById("showacouponstatus").innerHTML='';
}



function displayCodeCouponMessages(){
document.getElementById("showacouponstatus").innerHTML="Applied";

}
function displayCodeCouponError(){
document.getElementById("showacouponerror").innerHTML="Invalid Code";
}
function displayMemCouponError(){
document.getElementById("showacouponerror").innerHTML="Invalid Login";


}
function displayMemCouponMessage(){
document.getElementById("memshowacouponstatus").innerHTML="Applied";

}



function getSignupBlock() {
	getEventAttendees();
	advAJAX.get( {
		url   : '/portal/eventregister/attendeeauth/newsignup.jsp?GROUPID='+evtid,
	    onSuccess : function(obj) {
		    document.getElementById('attendeeBlock').innerHTML=obj.responseText;
		   },
	    onError : function(obj) { 
	    //alert("Error: " + obj.status); 
	    }
	});
}
function submitLoginForm(){
   
	advAJAX.submit(document.getElementById("attendeelogininfo"),{

		 onSuccess : function(obj) {
			var restxt=obj.responseText;
			if(restxt.indexOf("Success")>-1){
				getEventAttendees();
				document.getElementById("attendeelogininfo").style.display="none";
				document.getElementById("submsg").style.display="block";
			}else{
				if(document.getElementById("selectionerror")){
					document.getElementById("selectionerror").innerHTML="Invalid Login";
				}else if(document.getElementById("signuperror")){
				document.getElementById("signuperror").innerHTML=restxt;
				document.getElementById("signuperror").className="error";
				}

			}
		},
		onError : function(obj) { 
		//alert("Error: " + obj.status);
		}
	});
	
}

function SubmitTicketBlock(){
submitflag=true;
var frm=document.form1;
var nooftkts="";
if(document.getElementById("pubticketblock")){

       var options=frm.ticketSelect;
	if(options.length>0){
		for(var j=0;j<options.length;j++){
			if(options[j].checked==true){
			
				nooftkts=document.getElementById("qtypublicTickets"+j).value;
				
                        
			}
		}
	}else{
	               
	                if(document.form1.onlyonereq.checked==true){
		       		
		       		nooftkts=document.getElementById("qtypublicTickets0").value;
		}
	               
	               
			
	}
	if(nooftkts==""){
	
	        submitflag=false;
		document.getElementById('showtkterror').innerHTML=' Please select one required ticket';
		document.getElementById('tkterr').focus();
		
		return false;
	}else if(nooftkts=="0"){
	        submitflag=false;
		document.getElementById('showtkterror').innerHTML=' No of tickets should not be 0';
		document.getElementById('tkterr').focus();
		return false;
		
	}
	}
	
	
	
	
	
	else{ 
		
		if(document.getElementById("optionalticketsblock")){
		 var options=frm.optTicketsSelect;
			
			if(options.length>0){
				for(var j=0;j<options.length;j++){
					if(options[j].checked==true){
					
						nooftkts=document.getElementById("qtyOptional"+j).value;
						
		                        
					}
				}
			}else{
			              
			               if(document.form1.optTicketsSelect.checked==true){
			               
					nooftkts=document.getElementById("qtyOptional0").value;
					}
					else{
					if(document.getElementById('upgrade').value=='false')
					document.getElementById('showtkterror').innerHTML='Please select one  ticket';
				        }
					
			}
			if(nooftkts==""){			
			        submitflag=false;
			        if(document.getElementById('upgrade').value=='false')
					{
				document.getElementById('showtkterror').innerHTML=' Please select one  ticket';
				document.getElementById('tkterr').focus();
				
				return false;
				}
			}else if(nooftkts=="0"){
			        submitflag=false;
				document.getElementById('showtkterror').innerHTML=' No of tickets should not be 0';
				document.getElementById('tkterr').focus();
				return false;
				
		}
		
		
	
		
	}	
	}
	 
	       
             getTotalAmt();
            	
        
            	advAJAX.submit(frm,{
			onSuccess : function(obj) {
				var restxt=obj.responseText;
				if(restxt.indexOf("Ticketsuccess")>-1){
					document.getElementById('showerror').innerHTML='';
					document.getElementById('showtkterror').innerHTML='';
					ValidateAttendeeInfo();
					
					return true;
				}else{
				       
					document.getElementById('showtkterror').innerHTML=restxt;
					document.getElementById('tkterr').focus();
					
					
					
					submitflag=false;
					return false;
				}
			},
			onError : function(obj) { 
			return false;
			//alert("Error: " + obj.status);
		}
		});
		
		
		
		
		
		
	}
	
	


function SubmitTicketOnBlur(){
directsubmitbtnclick=0;
				
if(document.getElementById("pubticketblock")){
       var options=document.form1.ticketSelect;    

	var nooftkts="";
	if(options.length>0){
		for(var j=0;j<options.length;j++){
			if(options[j].checked==true){
				nooftkts=document.getElementById("qtypublicTickets"+j).value;
                               
			if(nooftkts==""){
						document.getElementById('showtkterror').innerHTML=' Please select one  ticket';
						document.getElementById('tkterr').focus();
			
					//document.getElementById("attendeePersonalInfo").innerHTML="";
				}else if(nooftkts=="0"){
						document.getElementById('showtkterror').innerHTML=' Number of tickets should not be 0';
						document.getElementById('tkterr').focus();
				}
				else if(nooftkts>0){	
				document.getElementById('showtkterror').innerHTML=' ';
						
	}
			}
		}
	}else{
	         if(document.form1.onlyonereq.checked==true){
		
		nooftkts=document.getElementById("qtypublicTickets0").value;
		
		
	
	if(nooftkts==""){
	
			document.getElementById('showtkterror').innerHTML=' Please select one  ticket';
			document.getElementById('tkterr').focus();

		//document.getElementById("attendeePersonalInfo").innerHTML="";
	}else if(nooftkts=="0"){
			document.getElementById('showtkterror').innerHTML=' Number of tickets should not be 0';
			document.getElementById('tkterr').focus();
	}
	else if(nooftkts>0){	
	document.getElementById('showtkterror').innerHTML=' ';
			
	}}
	}
	}
	        
		getTotalAmt();
	
		setAttendeeInfoBean(nooftkts);
	
if(document.getElementById("membercommunity")){
	
		if(isloginsubmitted){
		for(i=0;i<memberTickets.length;i++){
		//alert(memberTickets[i]);
		if(document.getElementById("price_"+memberTickets[i]))
		document.getElementById("price_"+memberTickets[i]).disabled=false;
		if(document.getElementById("option_"+memberTickets[i]))
		var option=document.getElementById("option_"+memberTickets[i]).value;
		if(document.getElementById("ival_"+memberTickets[i]))
		var ival=document.getElementById("ival_"+memberTickets[i]).value;
		if(document.getElementById("qty"+option+ival))
		document.getElementById("qty"+option+ival).disabled=false;
		
		}
	}}	
}

function AuthCheck(){
      	var rtxt;
	advAJAX.get( {
		url   : '/portal/eventregister/attendeeauth/checkauthen.jsp',
	    onSuccess : function(obj) {
	    		rtxt=obj.responseText;
	    		if(rtxt.indexOf("authsucess")>-1){
	    			isevtmem='yes';
	    			
	    		}else{
	    		}
	    		
	  	},
		onError : function(obj) { 
		//alert("Error: " + obj.status); 
		}
	});
	
}
function getEventAttendees(){
	document.getElementById('msgtab').innerHTML='Attendee Info section is loading...';
	document.getElementById("paymentbuttons").style.display="none";
				
	advAJAX.get( {
		url : '/portal/eventregister/reg/attendeeInfo.jsp;jsessionid='+jid+'?GROUPID='+evtid,
		
		 onSuccess : function(obj) {
		
		
    		document.getElementById('attendeePersonalInfo').innerHTML=obj.responseText;
    		document.getElementById('msgtab').innerHTML='';
    		document.getElementById('showattendeeerror').innerHTML='';
    		
	        document.getElementById("paymentbuttons").style.display="block";

		},
		onError : function(obj) { 
			//alert("Error: " + obj.status); 
		}
	});
}
function showRegTerms(){
	advAJAX.get( {
		url : '/portal/eventregister/reg/regterms.jsp?GROUPID='+evtid,
		 onSuccess : function(obj) {
			 document.getElementById('registerTerms').innerHTML=obj.responseText;
		},
		onError : function(obj) { 
		//alert("Error: " + obj.status); 
		}
	});
}

function getAmount(amount){
var l=0;
	if(amount.indexOf(".",0)>-1){
		 l=amount.length-1;
		var k=amount.indexOf(".",0);
		if((l-k)==1){
			amount=amount+"0";
		}
	      var dpos=amount.indexOf(".",0);
	      
	      	if((l-dpos)>2)
	amount=amount.substring(0,dpos)+amount.substring(dpos,dpos+3);
	
	
	}else{
		amount=amount+".00";
	}
	
	return amount;
}
function   getTotalAmt(){
      	var value;
	var selticket;
	var selopttkt;
	var reqquantity;
	var costRequired;
	var costOptional=0;
	var qtyOptional=0;
	var opttotal=0;
	var discostRequired;
	var discostOptional=0;
	//var reqtotal=0;
	var flag='false';
	var optflag='false';
	var total=0.00;
	var distotal=0.00;
	var disreqtotal;
	var i,j;
	var disopttotal=0;
	var disamount=0.00;
	var disamt=0.00;
	
	var processfeeRequired=0;
	var processfeeOptional=0;
	var totalprocessfee=0;	
	if(document.getElementById("pubticketblock")){
	       value=document.form1.ticketSelect.length;
	
	if(document.form1.ticketSelect.length>0){
		for(i=0;i<value;i++){
			if(document.form1.ticketSelect[i].checked==true){	
				flag='true';
				selticket=document.form1.ticketSelect[i].value;
				reqquantity=document.getElementById("qtypublicTickets"+i).value;
			        costRequired=document.getElementById("costpublicTickets"+i).value;
			        if(discountflag){
				discostRequired=document.getElementById("discost_"+selticket).value;	       
				}
				else
				discostRequired=costRequired;
				if(discostRequired==0.0)
				processfeeRequired=0.0;
				else	
				processfeeRequired=document.getElementById("processfee_"+selticket).value;
				reqtotal=(reqquantity*costRequired)+(parseFloat(processfeeRequired)*reqquantity);
			        if(discountflag)
			        disreqtotal=(reqquantity*discostRequired)+(parseFloat(processfeeRequired)*reqquantity);
			        
			}
		}
	}else{   
	          if(document.form1.onlyonereq.checked==true){		
		reqquantity=document.getElementById("qtypublicTickets0").value;
		}
		else
		reqquantity=0;
		if(reqquantity){
			flag='true';
		}
		selticket=document.form1.ticketSelect.value;
		costRequired=document.getElementById("costpublicTickets0").value;
		if(discountflag){
		discostRequired=document.getElementById("discost_"+selticket).value;	       
		}
		else
		discostRequired=costRequired;
		if(discostRequired==0.0)
		processfeeRequired=0.0;
		else				
		processfeeRequired=document.getElementById("processfee_"+selticket).value;
				reqtotal=(reqquantity*costRequired)+(parseFloat(processfeeRequired)*reqquantity);
                if(discountflag)
	       	 disreqtotal=(reqquantity*discostRequired)+(parseFloat(processfeeRequired)*reqquantity);
			        
	}
	}
	var opttotal=0;
	if(document.form1.optTicketCount.value>1){
		var optticklength=document.form1.optTicketsSelect.length;
		for (j=0;j<optticklength;j++){
		
			if(document.form1.optTicketsSelect[j].checked==true){
			
			selopttkt=document.form1.optTicketsSelect[j].value;
			costOptional=document.getElementById("costOptional"+j).value;
			
			qtyOptional=document.getElementById("qtyOptional"+j).value;
				if(discountflag){
			if(document.getElementById("discost_"+selopttkt))
			discostOptional=document.getElementById("discost_"+selopttkt).value;
			}
			else
			discostOptional=costOptional;
			
			if(document.getElementById("processfee_"+selopttkt)&&qtyOptional>=1){
			if(discostOptional==0.0)
			processfeeOptional=0.0;
			else{
				
			if(document.getElementById("processfee_"+selopttkt)){
			processfeeOptional=document.getElementById("processfee_"+selopttkt).value;
			}      
			 }     }
			 
			
			 opttotal=opttotal+((costOptional*qtyOptional)+(parseFloat(processfeeOptional)*qtyOptional));
                           
                            if(discountflag)
			       disopttotal=disopttotal+((discostOptional*qtyOptional)+(parseFloat(processfeeOptional)*qtyOptional));
			     
			    
			}
			
				
		}
	}else{
		if(document.getElementById("qtyOptional0")){
		if(document.form1.optTicketsSelect.checked==true){
		selopttkt=document.form1.optTicketsSelect.value;
			qtyOptional=document.getElementById("qtyOptional0").value;
		}else
			qtyOptional=0;
		}
		if(qtyOptional)optflag='true';
		
		if(document.getElementById("costOptional0")){
			costOptional=document.getElementById("costOptional0").value;
			
			if(discountflag){    
			
			
			
			                        if(document.form1.optTicketsSelect.checked==true){
			                        if(document.getElementById("discost_"+selopttkt))
						discostOptional=document.getElementById("discost_"+selopttkt).value;
						}
						}
						else
			discostOptional=costOptional;
		}
		if(document.form1.optTicketsSelect){
			if(document.form1.optTicketsSelect.checked==true&&document.getElementById("processfeeOptional0")&&qtyOptional>=1){
				if(discostOptional==0.0)
				processfeeOptional=0.0;
				else{
				if(document.getElementById("processfee_"+selopttkt)){
				processfeeOptional=document.getElementById("processfee_"+selopttkt).value;
				}
				}}
		}
		opttotal=(qtyOptional*costOptional)+(parseFloat(processfeeOptional)*qtyOptional);
	         if(discountflag){
	        disopttotal=disopttotal+((discostOptional*qtyOptional)+(parseFloat(processfeeOptional)*qtyOptional));
		}	      
	}
	if(document.getElementById("pubticketblock")){
    	if(flag=='true'){
	total=opttotal+reqtotal;
	
	
	if(disreqtotal>=0)distotal=disopttotal+disreqtotal;
	else if(disreqtotal==0)
	distotal=disopttotal+disreqtotal;
	else{
	distotal=total;
	}
	}
	}
	else
		{
		
		
		
		total=opttotal;
		if(discountflag&&disopttotal>=0){
		distotal=disopttotal;
		}
		else 
		distotal=total;
		
			
		
	}
	
	if(distotal>=0) 
	disamt=total-distotal;
		
	totamt=getAmount(''+total);
	var gtotal=0.0;
	var  tax=0.0;
	var taxamt=0.0;
	 distotamt=getAmount(''+distotal);
	 disamount=getAmount(''+disamt);
	 if(document.getElementById("taxfee")){
	var  tax= document.getElementById("taxfee").value;
	 taxamt=(parseFloat(tax)/100)*distotamt;
	 }
	 document.getElementById("taxAmount").value=taxamt;
	 gtotal=taxamt+distotal;
	document.getElementById("totamount").innerHTML=totamt;
	document.getElementById("disamount").innerHTML=disamount;
	document.getElementById("netamount").innerHTML=distotamt;
	if(document.getElementById("tax")){
	document.getElementById("tax").innerHTML=getAmount(''+taxamt);
	document.getElementById("grandtotamount").innerHTML=getAmount(''+gtotal);
	}
	if(parseInt(distotamt)==0)
	document.getElementById("nopaymentbutton").style.display='block';
	else
	document.getElementById("nopaymentbutton").style.display='none';
	
	if(document.getElementById("membercommunity")){

	if(isloginsubmitted){
	for(i=0;i<memberTickets.length;i++){
	if(document.getElementById("price_"+memberTickets[i]))
	document.getElementById("price_"+memberTickets[i]).disabled=false;
	if(document.getElementById("option_"+memberTickets[i]))
	var option=document.getElementById("option_"+memberTickets[i]).value;
	if(document.getElementById("ival_"+memberTickets[i]))
	var ival=document.getElementById("ival_"+memberTickets[i]).value;
	if(document.getElementById("qty"+option+ival))
	document.getElementById("qty"+option+ival).disabled=false;
	
	}
	}
}


	
}

var submitflag=false;

function ValidateAttendeeInfo(){
	               
var frm=document.getElementById("attendeeinfo");
if(frm){

	
frm.action='/portal/eventregister/reg/validateProfile.jsp';
  	advAJAX.submit(frm,{
		onSuccess : function(obj) {
			var restxt=obj.responseText;
			if(restxt.indexOf("AttendeeSucess")>-1){
                               
				finalfrmSubmit();
				
			}else{
			        submitflag=false;
			        if(document.getElementById("membercommunity")){
				var ival="";	
				var option="";
				if(isloginsubmitted){
				for(i=0;i<memberTickets.length;i++){
				if(document.getElementById("price_"+memberTickets[i]))
				document.getElementById("price_"+memberTickets[i]).disabled=false;
				if(document.getElementById("option_"+memberTickets[i]))
				 option=document.getElementById("option_"+memberTickets[i]).value;
				if(document.getElementById("ival_"+memberTickets[i]))
				 ival=document.getElementById("ival_"+memberTickets[i]).value;
				if(document.getElementById("qty"+option+ival))
				document.getElementById("qty"+option+ival).disabled=false;

				}
				}}	

				ShowAttendeeError();
			}
		},
		onError : function(obj) { 
		//alert("Error: " + obj.status);
		}
	});
}
}
function ValidateRegData(){
  	document.getElementById('showattendeeerror').innerHTML='';
	document.getElementById('showerror').innerHTML='';
	document.getElementById('showtkterror').innerHTML='';
	var statusflag=true;
	if(document.getElementById('donationsExists')){
         statusflag=checkForDonationTickets();
         }
         if(statusflag){
	//SubmitTicketOnBlur();
	if(!submitflag){
	var status= SubmitTicketBlock();
	}
	return status;
	}
}
function ShowAttendeeError(){
	advAJAX.get( {
			url   : '/portal/eventregister/reg/attendeerror.jsp',
		    onSuccess : function(obj) {
				document.getElementById('showattendeeerror').innerHTML=obj.responseText;
				document.getElementById('tkterr').focus();
			},
			onError : function(obj) { 
			//alert("Error: " + obj.status); 
			}
	});
}
function finalfrmSubmit(){
var type=document.getElementById("/selectPayType").value;
var context='';
if((type=='google' || type=='paypal')&&(distotamt>0)){
   if(document.getElementById("fbcontext")){
   
   	context=document.getElementById("fbcontext").value;
   	//alert(context);
   }  
	
	getPaymentData(type,context);
}else{
	document.frm.submit();
	}
}

function setAttendeeInfoBean(nooftkts){
	if(document.getElementById("attendeeinfo")){
	
		document.getElementById("attendeeinfo").action='/eventregister/reg/setAttendeeBean.jsp';
	
		     advAJAX.submit(document.getElementById("attendeeinfo"),{
				onSuccess : function(obj) {
				
					if(val=='evtmem'){
							advAJAX.submit(document.getElementById("attendeefrm"),{
								onSuccess : function(obj) {
									var restxt=obj.responseText;
									if(restxt.indexOf("Ticketsuccess")>-1){
										AuthCheck();
										
				                                                 if(parseInt(nooftkts)>parseInt(tktqtyinc)||parseInt(nooftkts)<parseInt(tktqtyinc)){
				                                                 tktqtyinc =nooftkts;
										getEventAttendees();
										
										}
										
										
									}else{
									
									}
								},
								onError : function(obj) { 
								//alert("Error: " + obj.status);
							}
							});
							
							
						}
						else if(val=='newmem'){
							advAJAX.submit(document.getElementById("attendeefrm"),{
								onSuccess : function(obj) {
									var restxt=obj.responseText;
									if(restxt.indexOf("Ticketsuccess")>-1){
									         if(parseInt(nooftkts)>parseInt(tktqtyinc)||parseInt(nooftkts)<parseInt(tktqtyinc)){
				                                                 tktqtyinc =nooftkts;
										getEventAttendees();
										}
										
									}else{
									}
								},
								onError : function(obj) { 
								//alert("Error: " + obj.status);
								}
							});
							
						}
		
				
				
				
				},
				onError : function(obj) { 
				//alert("Error: " + obj.status);
				}
			}); 
	}

}

function selectPayType(context){

var options=document.frm.paymentbutton;
var type="";
if(options.length>0){
for(var j=0;j<options.length;j++){
if(options[j].checked==true){
type=options[j].value;

}}}

if(type==""){
alert("Select a Payment Method");
return false;
}
else
{
if(type=='nopayment'){
document.getElementById("/selectPayType").value=type;
ValidateContinuAction();
}
else{
document.getElementById("/selectPayType").value=type;
ValidateRegData()
}
}
}


function getPaymentData(type,context){
  var payurl='/portal/eventregister/reg/paymentdata.jsp?type='+type;
  if(context=='FB')
  		payurl+='&fbcontext=yes';

	advAJAX.get( {
			url   : payurl,
		    onSuccess : function(obj) {
		    		document.getElementById('paydata').innerHTML=obj.responseText;
				document.paytypeform.submit();
			},
			onError : function(obj) { 
			//alert("Error: " + obj.status); 
			}
	});

}




function getPartnerCommision(evtid,partnerid, friendid){

	//alert('partner commision....');
	var d1 = new Date();
    http_request = false;
    if (window.XMLHttpRequest) { // Mozilla, Safari,...
         http_request = new XMLHttpRequest();
         if (http_request.overrideMimeType) {
            http_request.overrideMimeType('text/xml');
         }
         else{
          try {
	             http_request = new ActiveXObject("Msxml2.XMLHTTP");
	             
	             } catch (e) {
	             try {
	                http_request = new ActiveXObject("Microsoft.XMLHTTP");
	                } catch (e) {}
         }
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
      http_request.onreadystatechange = getPartnercommision;
    
      urls='/eventregister/reg/getPartnercommisiondetails.jsp?GROUPID='+evtid+'&partnerid='+partnerid+'&friendid='+friendid+'&ct='+d1.getTime();
      http_request.open('GET',urls,true);
      http_request.send(null);


}


function getPartnercommision(){

	if (http_request.readyState == 4) {
         if (http_request.status == 200) {
            var xmldoc = http_request.responseXML;
               if (window.ActiveXObject){
	                  	xmldoc.load(http_request.responseStream);
	                     }  
	                  var tickets = xmldoc.getElementsByTagName('tickets');
	                    
	                  for (var x = 0; x < tickets.length; x++) {
	                  var status=tickets.item(x).getAttribute('codestatus');
	                  ticket= xmldoc.getElementsByTagName('ticket');
	                 
	                  if(status.indexOf("success")>-1){
	                     
	                     discountflag=true;
	                      
	                     for (var x = 0; x < ticket.length; x++) { 
	                     
			     newprice=ticket.item(x).getAttribute('newprice');
			     
			     discount=ticket.item(x).getAttribute('discount');
			     priceid=ticket.item(x).getAttribute('id');
			     price=ticket.item(x).getAttribute('price');
			     tkttype=ticket.item(x).getAttribute('type');
			        if(newprice!=null)
			      {
			     // if(newprice==0.0)
			     //document.getElementById("processfee_"+priceid).innerHTML="0.0";
			     if(document.getElementById("discount_"+priceid))
			     document.getElementById("discount_"+priceid).value=discount; 
			     if(newprice!=price){
				     document.getElementById("ticket_"+priceid).innerHTML= '<font color="red"><strike>'+price+'</strike></font>';
					 document.getElementById("upticket_"+priceid).innerHTML=newprice; 
				 document.getElementById("discost_"+priceid).value=newprice;
				  }
			     else
			     {
			     
			       if(document.getElementById("ticket_"+priceid))
			       document.getElementById("ticket_"+priceid).innerHTML= price;
			    // document.getElementById("upticket_"+priceid).innerHTML=price; 
			       if(document.getElementById("discost_"+priceid))
			       document.getElementById("discost_"+priceid).value=price;
			     
			     }
			     
			     getTotalAmt(); 

		             
		             }
		             else{
		             if(document.getElementById("discount_"+priceid))
		             document.getElementById("discount_"+priceid).value='';
		             if(document.getElementById("ticket_"+priceid))
		             document.getElementById("ticket_"+priceid).innerHTML=price;
		             if(document.getElementById("discost_"+priceid))
		             document.getElementById("discost_"+priceid).value=price;

			     	getTotalAmt();
			     }
			     }
			    
			    }
			    
			    
	                  }
	                   
	                  
	                  
	                  
			
               }  
            
}

}



function assignDiscounts(evtid,discountcode){
		advAJAX.get( {
		url   : '/eventregister/reg/coupon.jsp?GROUPID='+evtid+'&discountcode='+discountcode,
	    onSuccess : function(obj) {
	    	    document.getElementById('couponBlock').innerHTML=obj.responseText;
		   validateCoupon('General','isnew');

		   },
	    onError : function(obj) { 
	    //alert("Error: " + obj.status); 
	    }
	});

//validateCoupon('General','isnew');

}
function SubmitLogin(req){

advAJAX.submit(document.getElementById("membercommunity"), {
onSuccess : function(obj) {
var data=obj.responseText;
if(data.indexOf("validMember")>-1){
	enableMemberTickets();
}	
else if(data.indexOf("NotMember")>-1){
document.getElementById("memberTicket").value="Invalid";
document.getElementById("membererror").innerHTML="Not a Valid Member";
}
else if(data.indexOf("Loginfailed")>-1){
document.getElementById("memberTicket").value="Invalid";

document.getElementById("membererror").innerHTML="Invalid Login";
}

},
onError : function(obj) { alert("Error: " + obj.status); }
});

}


function enableMemberTickets(){
	document.getElementById("membererror").innerHTML="  ";
	document.getElementById("memberTicket").value="Success";
	isloginsubmitted=true;
	for(i=0;i<memberTickets.length;i++){
	var option="";
	var ival="";
	if(document.getElementById("price_"+memberTickets[i]))
	document.getElementById("price_"+memberTickets[i]).disabled=false;
	if(document.getElementById("option_"+memberTickets[i]))
	option=document.getElementById("option_"+memberTickets[i]).value;
	if(document.getElementById("ival_"+memberTickets[i]))
	ival=document.getElementById("ival_"+memberTickets[i]).value;
	if(document.getElementById("qty"+option+ival))
	document.getElementById("qty"+option+ival).disabled=false;
	if(document.getElementById("login_"+memberTickets[i]))
	document.getElementById("login_"+memberTickets[i]).style.display='none';
	}
	document.getElementById("hublogin").style.display='none';
	document.getElementById("loginmsg").style.display='block';
}

function MemberLoginCheck(){
      	var rtxt;
	advAJAX.get( {
		url   : '/portal/eventregister/reg/checkmemberlogin.jsp',
	    onSuccess : function(obj) {
	    		rtxt=obj.responseText;
	    		if(rtxt.indexOf("loggedin")>-1){
	    			enableMemberTickets();
	    			
	    		}
	    		
	  	},
		onError : function(obj) { 
		//alert("Error: " + obj.status); 
		}
	});
	
}

function ValidateContinuAction(){

getTotalAmt();
if(distotamt>0)
{
alert("Your Grand Total is more than 0, please select valid Payment Method");
submitflag=false;
return false;

}
else{
ValidateRegData();
return true;

}
}




function CheckCouponCodes(){

	var rtxt;
	advAJAX.get( {
		url   : '/portal/eventregister/reg/checkcouponcodes.jsp',
	    onSuccess : function(obj) {
	    		rtxt=obj.responseText;
	    		if(rtxt.indexOf("discountapplied")>-1){
	    			 validateCoupon('General','refresh');
		  
	    			
	    		}
	    		
	  	},
		onError : function(obj) { 
		//alert("Error: " + obj.status); 
		}
	});





}


function CheckMemCoupon(){
var rtxt;
	advAJAX.get( {
		url   : '/portal/eventregister/reg/checkcouponcodes.jsp?member=yes',
	    onSuccess : function(obj) {
	    		rtxt=obj.responseText;
	    		
	    		if(rtxt.indexOf("discountapplied")>-1){
	    			 validateCoupon('Member','refresh');
		      			
	    		   }
	    		
	  	},
		onError : function(obj) { 
		//alert("Error: " + obj.status); 
		}
	});





}



function setDonation(tiketid,index,tickettype){
donation=0;
var validdonation=true;
if(document.getElementById("donation_"+tiketid)){
if(document.getElementById("price_"+tiketid).checked==true){
donation=document.getElementById("donation_"+tiketid).value;
invaliddonation=isNaN(donation)
if(!invaliddonation){
document.getElementById("donationerror_"+tiketid).innerHTML='';
document.getElementById("cost"+tickettype+index).value=donation;
document.getElementById("discost_"+tiketid).value=donation;
getTotalAmt();
}
else{
document.getElementById("donationerror_"+tiketid).innerHTML='Enter a valid amount';
document.getElementById("donation_"+tiketid).value=0;
getTotalAmt();
}
}

}
return false;
}



function checkForDonationTickets(){
var amt=0;
var dstatus=true;
for(i=0;i<DonationTickets.length;i++){
if(document.getElementById("price_"+DonationTickets[i])){
if(document.getElementById("price_"+DonationTickets[i]).checked==true){
if(document.getElementById("donation_"+DonationTickets[i])){
amt=document.getElementById("donation_"+DonationTickets[i]).value;
var invaliddonation=isNaN(amt)
if(parseFloat(amt)>0){
document.getElementById("discost_"+DonationTickets[i]).value=amt;
dstatus=true;
}
else{
document.getElementById('showtkterror').innerHTML='Please uncheck the option, if you do not wish to pay donation';
document.getElementById("tkterr").focus();
dstatus=false;
return dstatus;
}
}
}
else
dstatus=true;
}
else{
dstatus=true;
}
}
return dstatus;
}