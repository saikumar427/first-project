function showAttendeesList(groupid){
var attdate='';
var eventtype='';
var showlist=true;
if($('attendeeinfo'));
	$('attendeeinfo').hide();
if(document.getElementById('event_date')){
	insertOptionBeforeAttending('attendeelist');
	document.getElementById('event_date').style.display="none";
	var index=document.getElementById('event_date').selectedIndex;
	var attdate=document.getElementById('event_date').options[index].value;
	if($('whosattendingimageload')){
		$('whosattendingimageload').show();
	}		
	eventtype ='rsvp';
	if(attdate=='Select Date'){
		attdate=' ';
		showlist=false;
	document.getElementById('event_date').style.display="block";
		if($('whosattendingimageload'))
			$('whosattendingimageload').hide();
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
if($('attendeeinfo')){
	$('attendeeinfo').update(response.responseText);	
	$('attendeeinfo').show();	
}
if($('whosattendingimageload'))
		$('whosattendingimageload').hide();	

if($('event_date')){
	document.getElementById('event_date').style.display="block";
}		
}

function getRsvpAttendeeList(groupid){
	if(document.getElementById('event_date')){
		insertOptionBeforeAttending('attendeelist');
	}
	new Ajax.Request('/customevents/rsvpattendeelist.jsp?timestamp='+(new Date()).getTime(), {
	  method: 'get',
	  parameters:{groupid:groupid},
	  onSuccess: AttendeesListResponse,
	  onFailure:  failureJsonResponse
  });
	
	
}

function showRSVPAttendeesList(groupid){
var attdate='';
var eventtype='';
var showlist=true;
if($('attendeeinfo'));
	$('attendeeinfo').hide();
if(document.getElementById('event_date')){
	document.getElementById('event_date').style.display="none";
var index=document.getElementById('event_date').selectedIndex;
var attdate=document.getElementById('event_date').options[index].value;
if($('whosattendingimageload')){
		$('whosattendingimageload').show();
	}
eventtype ='rsvp';
if(attdate=='Select Date'){
attdate=' ';
showlist=false;
	document.getElementById('event_date').style.display="block";
if($('whosattendingimageload'))
			$('whosattendingimageload').hide();
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

function failureJsonResponse(){
alert("failed");
}

function insertOptionBeforeAttending(purpose){ 
  var elSel;
if(purpose=='tickets')
  elSel = document.getElementById('eventdate');
  else
    elSel = document.getElementById('event_date');

	var elOptNew = document.createElement('option');
    elOptNew.text = props.rec_select_date_lbl;
    elOptNew.value = 'Select Date';
    if(elSel.options.length==0){
		try{
			elSel.add(elOptNew,elSel.options[0]);
		}
		catch(ex){
			elSel.add(elOptNew,0);
		}	
	}
  if(elSel.options.length>0){
  var elOptOld = elSel.options[0]; 
  if(elOptOld.value!='Select Date'){
    try {
      elSel.add(elOptNew, elOptOld); // standards compliant; doesn't work in IE
    }
    catch(ex) {
      elSel.add(elOptNew, 0); // IE only
    }
  
  elSel.selectedIndex=0;
}}
}
