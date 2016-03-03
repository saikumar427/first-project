function checkInvitationForm(){
		if (!document.invitationForm.fromname.value) {
			alert(props.reg_event_widget_form_enter_name_lbl);
			return false;
		}
			
		if (!document.invitationForm.fromemail.value) {
			alert(props.reg_event_widget_form_email_lbl);
			return false;
		}
			
		if (!document.invitationForm.toemails.value) {
		    alert(props.reg_event_widget_form_valid_email_lbl);
			return false;
		}
			
		if (!document.invitationForm.subject.value) {
			alert(props.reg_event_widget_form_submessage_lbl);
			return false;
		}
			
		if (!document.invitationForm.personalmessage.value) {
			alert(props.reg_event_widget_form_enter_message_lbl);
			return false;
		}
		
		if (!/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(document.invitationForm.fromemail.value)){
			alert(props.reg_event_widget_form_email_notvalid_lbl);
			return false;
		}

		var toemail=document.invitationForm.toemails.value;
		var tokens = toemail.tokenize(",", " ", true);
		for(var i=0; i<tokens.length; i++){
			if (!/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(tokens[i])){
				alert(tokens[i] + ' '+props.reg_event_widget_form_not_valid_mail_lbl);
				return false;
			}
		}
		//return true;
		
		document.invitationForm.sendmsg.value=props.reg_event_widget_sending_lbl;
		var url = jQuery("#invitationForm").attr("action");
		jQuery.ajax({
			url:url,
			type:'POST',
			data:jQuery("#invitationForm").serialize(),
			success:function(result){
				console.log(result);
				if(result.indexOf("Error")>-1){
					document.getElementById('captchamsg').style.display='block';
		  		     document.invitationForm.sendmsg.value=props.reg_event_widget_send_lbl;
				    alert("Error");
				}
				else{
					jQuery('#Invitation').slideUp();
					document.getElementById("Invitation").style.display = 'none';
				 	document.getElementById('message').innerHTML=result;
		 		    document.invitationForm.sendmsg.value=props.reg_event_widget_send_lbl;
		 		    document.invitationForm.fromemail.value='';
		 		    document.invitationForm.toheader.value='';
		 		    document.invitationForm.captcha.value='';
		 		    document.invitationForm.fromname.value='';
		 		    document.getElementById('captchamsg').style.display='none';
				}
			},
			error:function(){
				//alert('error');
			}
		});
		
		  
		/*advAJAX.submit(document.getElementById("invitationForm"), {
		    onSuccess : function(obj) {
		    var restxt=obj.responseText;
		   if(restxt.indexOf("Error")>-1){
		  		       
		  		     document.getElementById('captchamsg').style.display='block';
		  		     document.invitationForm.sendmsg.value="Send";
		     }
		     else{
		    document.getElementById('message').innerHTML=restxt;
		    document.getElementById("Invitation").style.display = 'none'
		    document.invitationForm.sendmsg.value="Send";
		    document.invitationForm.fromemail.value='';
		    document.invitationForm.toheader.value='';
		    document.invitationForm.captcha.value='';
		  
		    document.invitationForm.fromname.value='';
		     document.getElementById('captchamsg').style.display='none';
		   
		   }
		    },
		    onError : function(obj) { alert("Error: " + obj.status);}
		});*/
		
		
		/*$('invitationForm').request({
	        onFailure: function() { 
	       alert("Error");
	        },
	        onSuccess: function(obj) {
	        	var restxt=obj.responseText;
	 		   if(restxt.indexOf("Error")>-1){
	 		  		       
	 		  		     document.getElementById('captchamsg').style.display='block';
	 		  		     document.invitationForm.sendmsg.value=props.reg_event_widget_send_lbl;
	 		     }
	 		     else{
	 		    document.getElementById('message').innerHTML=restxt;
	 		    document.getElementById("Invitation").style.display = 'none'
	 		    document.invitationForm.sendmsg.value=props.reg_event_widget_send_lbl;
	 		    document.invitationForm.fromemail.value='';
	 		    document.invitationForm.toheader.value='';
	 		    document.invitationForm.captcha.value='';
	 		    document.invitationForm.fromname.value='';
	 		     document.getElementById('captchamsg').style.display='none';
	 		   }
	        }
	    });*/
	}


function checkAttendeeForm(){
		if (!document.AttendeeForm.from_email.value) {
			alert(props.reg_event_widget_form_email_lbl);
			return false;
		}
		if (!document.AttendeeForm.from_name.value) {
		    
			alert(props.reg_event_widget_form_enter_name_lbl);
			return false;
		}
		if (!document.AttendeeForm.subject.value) {
			alert(props.reg_event_widget_form_submessage_lbl);
			return false;
		}
		if (!document.AttendeeForm.note.value) {
			alert(props.reg_event_widget_form_enter_note_lbl);
			return false;
		}
		if (!/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(document.AttendeeForm.from_email.value)){
			alert(props.reg_event_widget_form_email_notvalid_lbl);
			return false;
		}
				
		document.AttendeeForm.sendmgr.value=props.reg_event_widget_sending_lbl;
		  
		var attendeeFormURL = jQuery("#AttendeeForm").attr("action");
		jQuery.ajax({
			url: attendeeFormURL,
			type: 'POST',
			data: jQuery("#AttendeeForm").serialize(),
			success:function(msg){
				if(msg.indexOf("Error")>-1){
					document.getElementById('captchamsgmgr').style.display='block';
				    document.AttendeeForm.sendmgr.value=props.reg_event_widget_send_lbl;
				    alert("Error");
				}
				else{
					jQuery('#contactmgr').slideUp();
					document.getElementById('contactmgr').style.display='none';
		  			document.getElementById('urmessage').innerHTML=props.reg_event_widget_from_email_sent_lbl;
		  			document.AttendeeForm.sendmgr.value=props.reg_event_widget_send_lbl;
		  			document.AttendeeForm.from_email.value='';
		  			document.AttendeeForm.from_name.value='';
		  			document.AttendeeForm.note.value='';
		  			document.AttendeeForm.captchamgr.value='';
		  			document.getElementById('captchamsgmgr').style.display='none';
				}
			},
			error:function(){
				//alert('error');
			}
		});
		
		/*advAJAX.submit(document.getElementById("AttendeeForm"), {
		    onSuccess : function(obj) {
		    var restxt=obj.responseText;
		  if(restxt.indexOf("Error")>-1){
		  		  		     
		   document.getElementById('captchamsgmgr').style.display='block';
		    document.AttendeeForm.sendmgr.value="Send";
		   
		     }
		     else{
			document.getElementById('contactmgr').style.display='none';
			document.getElementById('urmessage').innerHTML="Email sent to event manager";
			document.AttendeeForm.sendmgr.value="Send";
			document.AttendeeForm.from_email.value='';
			document.AttendeeForm.from_name.value='';
			  document.AttendeeForm.captchamgr.value='';
		  
			document.getElementById('captchamsgmgr').style.display='none';

		 }
		    },
		    onError : function(obj) { alert("Error: " + obj.status);}
		});*/
		
		/*$('AttendeeForm').request({
	        onFailure: function() { 
	       alert("Error");
	        },
	        onSuccess: function(obj) {
	        	var restxt=obj.responseText;
	  		  if(restxt.indexOf("Error")>-1){
	  		  		  		     
	  		   document.getElementById('captchamsgmgr').style.display='block';
	  		    document.AttendeeForm.sendmgr.value=props.reg_event_widget_send_lbl;
	  		   
	  		     }
	  		     else{
	  			document.getElementById('contactmgr').style.display='none';
	  			document.getElementById('urmessage').innerHTML=props.reg_event_widget_from_email_sent_lbl;
	  			document.AttendeeForm.sendmgr.value=props.reg_event_widget_send_lbl;
	  			document.AttendeeForm.from_email.value='';
	  			document.AttendeeForm.from_name.value='';
	  			  document.AttendeeForm.captchamgr.value='';
	  		  
	  			document.getElementById('captchamsgmgr').style.display='none';

	  		 }
	        }
	    });*/
}


function Show(div){
	    var currentDate = new Date()
		var theDiv = document.getElementById(div);
		if (theDiv.style.display == 'none') {
			theDiv.style.display = 'block';
			document.getElementById("message").innerHTML='';
			if(div=='Invitation')
			document.getElementById("captchaid").src="/captcha?fid=invitationForm&pt="+currentDate.getTime();
			else if(div=='contactmgr')
			document.getElementById("captchaidmgr").src="/captcha?fid=AttendeeForm&pt="+currentDate.getTime();
			else
			{}
		} 
		else
		theDiv.style.display = 'none'
	}
	
function Cancel(div)
{
var theDiv = document.getElementById(div);
theDiv.style.display = 'none';
}

