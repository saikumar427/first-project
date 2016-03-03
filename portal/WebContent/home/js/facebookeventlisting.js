var _ms_XMLHttpRequest_ActiveX;
var year1;
var month1;
var day1;
var now1;
var evtid;
var attributename;
var attributetype;
var attributerequired;
var path="";
var attributeoptions=new Array();
//var cal = new CalendarPopup('calendar');
var cal = new CalendarPopup();
cal.setCssPrefix("TEST");
function displayCalendar(anchor,yearelm,monthelm,dayelm,now){
year1=yearelm;
month1=monthelm;
day1=dayelm;
cal.addDisabledDates(null,now);
cal.setReturnFunction("setValues");
cal.showCalendar(anchor,now);
}
function setValues(y,m,d) {
   	 document.getElementById(year1).value=y;
	 document.getElementById(month1).value=LZ(m);
	 document.getElementById(day1).value=LZ(d);
}
function testtrim(str){
	var temp='';
	temp=new String(str);
	temp=temp.replace(/[^a-zA-Z 0-9]+/g,'');
	return temp;
}


function getEventPowerTypeData(evtidses,fpath){
evtid=evtidses;
path=fpath;
advAJAX.get( {
	url : '/facebook/addevent/getEventPoweringBlock.jsp?GROUPID='+evtid,
	
    onSuccess : function(obj) {
   	document.getElementById('powerblock').innerHTML=obj.responseText;
	showPowerBlock();
	/* show power block is called. This will display the corresponding html based on the power type choosen*/
	},
	onError : function(obj) { alert("Error: " + obj.status); }
});

}


function getPowerBlock() {
				/* first calls editPoweredBy.jsp which will return some html with place holders
				for tickets and custom attributes which are to be filled by using ajax calls*/
advAJAX.get( {
	url : '/facebook/addevent/editPoweredBy.jsp?GROUPID='+evtid,
    onSuccess : function(obj) {document.getElementById('eventPowerBlock').innerHTML=obj.responseText; getTicketsBlock(path); getCustomAttributes();},
	onError : function(obj) { alert("Error: " + obj.status); }
});
/* there are three function calls after 'eventPowerBlock' is filled.
getTicketsBlock-- this will display entire tickets block.
getCustomAttributes-- this will get the html which has place holders for displaying custom attributes.
showAttributes-- will display the custom attributes that are added in the 'showattributes' place holder.
*/
}
function getRsvpBlock() {



advAJAX.get( {
	url : '/facebook/addevent/rsvp.jsp?GROUPID='+evtid,
    onSuccess : function(obj) {document.getElementById('eventPowerBlock').innerHTML=obj.responseText;getCustomAttributes();},
	onError : function(obj) { alert("Error: " + obj.status); }
});
}

/* for displaying power with options in addevent.jsp*/

function showPowerBlock(){
				/* will check for the option choosen by the user i.e, registration or rsvp or none*/
				/* will display corresponding html based on the option choosed*/
var frm=document.getElementById('frmpowerWithType');
	var val='registration';
	var options=frm.powerWithType;
		for(var j=0;j<options.length;j++){
			if(options[j].checked==true){
				val=options[j].value;
				break;
			}
		}
		if(val=='registration') getPowerBlock();
		/* getPowerBlockis called for power with online registration*/
		else if(val=='rsvp') getRsvpBlock();
		/* getRsvpBlock is called for power with rsvp functionality*/
		else if(val=='none')
			document.getElementById('eventPowerBlock').innerHTML='';
		/* if none is choosen then eventPowerBlock is filled with empty*/
		setPowerType(val);
	
}
function setPowerType(val) {
	advAJAX.get( {
	url : '/facebook/addevent/setEventPowerType.jsp?GROUPID='+evtid+'&type='+val,
    onSuccess : function(obj) {},
    onError : function(obj) { }
});
}
function getTicketsBlock(path,from) {

	/* tickets block is filled */
	advAJAX.get( {
	url : '/facebook/addevent/editTickets.jsp?GROUPID='+evtid+'&from='+from,
    onSuccess : function(obj) {
	    if(document.getElementById('ticketsblock'))
	    document.getElementById('ticketsblock').innerHTML=obj.responseText;},
    onError : function(obj) { alert("Error: " + obj.status); }
});
}
function getTicketsBlock1(id) {
	/* will call the edittickets.jsp and displays the data. This is same as getTicketsBlock() but the id given (button id) is disabled */
	/* at any time only only one ticket can be added on the page. For this to work "add ticket" button of another block is disabled*/
	advAJAX.get( {
	url : '/facebook/addevent/editTickets.jsp?GROUPID='+evtid,
    onSuccess : function(obj) {document.getElementById('ticketsblock').innerHTML=obj.responseText;disableObject(id)},
    onError : function(obj) { alert("Error: " + obj.status); }
});
}
function addTicketsOnSubbmit(path,id,id1,position,tickettype,isedit,purpose,isfrom,isgrouptkt,groupticketid){
   document.getElementById("submit").disabled=true;
 advAJAX.submit(document.getElementById("addtickets"), {
    onSuccess : function(obj) {
	var data=obj.responseText;
	var url='';
	data=testtrim(data);
	
		if(data=='yes'){
			url='/facebook/addevent/addticket.jsp?error=yes&GROUPID='+evtid;
			if(isedit=='yes')
				url=url+"&isedit="+isedit;
			if(isfrom=='EventManage')	
			url=url+"&isedit="+isedit+"&isfrom="+isfrom;
			if(isgrouptkt=='yes'){
				url=url+"&isedit="+isedit+"&grptkt="+isgrouptkt+"&groupid="+groupticketid;
				}
			addTicketBlock(id,id1,position,tickettype,url,isfrom);
		}else{
			getTicketsBlock(path);	
			showTicketsellinBlock('new',path);
		}
	},
    onError : function(obj) { alert("Error: " + obj.status); }
});
}

function addTicketBlock(id,id1,position,tickettype,url,from) {
var evtstartdate="";
var evtstartyear="";
var evtstartmonth="";
   if(from=="EventManage"){
   }
   else{
    	 evtstartdate=document.getElementById("/startDay").value;
	 evtstartyear=document.getElementById("/startYear").value;
	 evtstartmonth=document.getElementById("/startMonth").value;
	}
       
	advAJAX.get( {
		url : url+"&position="+position+"&tickettype="+tickettype+"&id="+id+"&id1="+id1+"&GROUPID="+evtid+"&eventsdate="+evtstartdate+"&eventsyear="+evtstartyear+"&eventsmonth="+evtstartmonth,
		onSuccess : function(obj) {
		document.getElementById(id).style.display='none'
		document.getElementById(id1).innerHTML=obj.responseText;
		//document.getElementById('optionalticketbttn').enabled=true;
	},
    onError : function(obj) { alert("Error: " + obj.status); }
});
}

function deleteTicket(id,position,tickettype,url,a,c,purpose,groupindex){
     	url=url+"?tickettype="+tickettype+"&id="+id+"&GROUPID="+evtid+"&groupindex="+groupindex;	
	url=url+"&position="+position;
	getTicketData(url,purpose);
	
}

function getTicketData(url,path){
advAJAX.get( {
			url :url,
			onSuccess : function(obj) {getTicketsBlock(path);},
			onError : function(obj) { alert("Error: " + obj.status); }
		});
}

function addAttributes(){
advAJAX.submit(document.getElementById("registerform"), {
    onSuccess : function(obj) {
	var data=obj.responseText;
	var url='';
	data=trim(data);
		if((data.indexOf("ATTRIB_ERROR")>-1)){
		document.getElementById('dynaattrib_1').style.display='none';
		document.getElementById('addAtribute').style.display='block';
		document.getElementById('attriberrors').style.display='none';
		showAttributes();
		}else{
		document.getElementById('dynaattrib_1').style.display='block';
		document.getElementById('addAtribute').style.display='none';
		document.getElementById('attriberrors').innerHTML=data;
		document.getElementById('attriberrors').style.display='block';
		}
	},
    onError : function(obj) { alert("Error: " + obj.status); }
});
}
function chaangeattributes(){
	document.getElementById('dynaattrib_1').style.display='none';
		document.getElementById('addAtribute').style.display='block';
		document.getElementById('attriberrors').style.display='none';
		showAttributes();
}

function showAttributes() {
	/* fills the 'showattributes' place holder of the custom attributes block*/
	advAJAX.get( {
		url : '/facebook/customattributes/displayCustomAttributes.jsp?GROUPID='+evtid,
		onSuccess : function(obj) {document.getElementById('showattributes').innerHTML=obj.responseText; },
		onError : function(obj) { alert("Error: " + obj.status); }
	});
}

function getCustomAttributes() {
     
	/* fills the 'customattributes' place holder of the power block*/
	advAJAX.get( {
		url : '/facebook/customattributes/customnew.jsp?GROUPID='+evtid,
		onSuccess : function(obj) {document.getElementById('customattributes').innerHTML=obj.responseText; showAttributes();},
		onError : function(obj) { alert("Error: " + obj.status); }
	});
}

function addAttributesBlock(id,position,url) {
advAJAX.get( {
	url : url,
    onSuccess : function(obj) {
	document.getElementById(id).innerHTML=obj.responseText;
	},
    onError : function(obj) { alert("Error: " + obj.status); }
});
}
function setEditAttributes(k){
//document.getElementById('dynaattrib_1').innerHTML+='<input id="EDIT_ATTRIBUTE_ID" type="hidden" name="EDIT_ATTRIBUTE_ID" value="'+k+'"/>';
document.getElementById('EDIT_ATTRIBUTE_ID').value=k;
document.getElementById('dynaattrib_1').innerHTML+='<input type="hidden" name="EDITING_ATTRIBUTE" value="yes"/>';

}

function deleteAttribute(k){
var editid=document.getElementById('EDIT_ATTRIBUTE_ID').value;
advAJAX.get( {
		url : '/facebook/customattributes/displayCustomAttributes.jsp?removeid='+k+'&GROUPID='+evtid,
		onSuccess : function(obj) {
			if(editid&&editid==k){
			document.getElementById('dynaattrib_1').style.display='none';
			document.getElementById('addAtribute').style.display='block';
			}
		document.getElementById('showattributes').innerHTML=obj.responseText;
		},
		onError : function(obj) { alert("Error: " + obj.status); }
	});
}




function Trim(str)
{	while(str.charAt(0) == (" ") )
	{	str = str.substring(1);
	}
	while(str.charAt(str.length-1) == " " )
	{	str = str.substring(0,str.length-1);
	}
	return str;
}
function tagvalidate()
{
var tagmsg='<%=tstring%>';
var x=frm.tags.value;
var y=Trim(x);
var word=y.split(" ");
if(word.length>2){
alert(tagmsg);
return false;
}
else {
return true;
}
}

function disableObject(id){
document.getElementById(id).disabled=true;
}
function enableObject(id){
document.getElementById(id).enabled=true;
}
function reloaddata(desctype){
document.frm.target="_self"
document.frm.action='/validateeventform?reload=yes';
document.frm.submit();
}


function getpaydatablock(type){
 	//alert(document.powerregister1234.paypalckeck.checked);
  if(type=='paypal'){
  	if(document.powerregister1234.paypalckeck.checked){
  		document.getElementById('papaldatablock').style.display='block';
  	}else{
  		document.getElementById('papaldatablock').style.display='none';
  	}
  }
  if(type=='google'){
  	if(document.powerregister1234.googlecheck.checked){
  		document.getElementById('googledatablock').style.display='block';
  	}else{
  		document.getElementById('googledatablock').style.display='none';
  	}
  }
  if(type=='other'){
  	if(document.powerregister1234.othercheck.checked){
  		document.getElementById('otherblock').style.display='block';
  	}else{
  		document.getElementById('otherblock').style.display='none';
  	}
  }
  
  if(type=='eventbee'){
  	if(document.powerregister1234.eventbeeckeck.checked){
  		document.getElementById('eventbeedatablock').style.display='block';
  	}else{
  		document.getElementById('eventbeedatablock').style.display='none';
  	}
  }
  
 }



function getgroupTicketsBlock(id,id1,url,grpid,tktid,tkttype){

var from=document.getElementById("from").value;

if(from=="EventManage"){
}
else
{
 var evtstartdate=document.getElementById("/startDay").value;
 var evtstartyear=document.getElementById("/startYear").value;
 var  evtstartmonth=document.getElementById("/startMonth").value;

}


advAJAX.get( {
		url : url+"&position="+tktid+"&id="+id+"&id1="+id1+"&GROUPID="+evtid+'&groupid='+grpid+'&eventsdate='+evtstartdate+'&eventsyear='+evtstartyear+'&eventsmonth='+evtstartmonth+'&tickettype='+tkttype,
		onSuccess : function(obj) {
		document.getElementById(id).style.display='none';
		document.getElementById(id1).innerHTML=obj.responseText;
		
	},
    onError : function(obj) { alert("Error: " + obj.status); }
});




}

function moveUpTickets(path,groupindex,tktposition){

advAJAX.get( {
	url : '/facebook/addevent/editTickets.jsp?GROUPID='+evtid+'&groupindex='+groupindex+'&position='+tktposition+'&moveuptkt=yes',
    onSuccess : function(obj) {
    		  if(document.getElementById('ticketsblock')){
	    	    document.getElementById('ticketsblock').innerHTML=obj.responseText;
	    	    showTicketsellinBlock('yes',path);
	    }
	    },
    onError : function(obj) { alert("Error: " + obj.status); }
});

}


function movednTickets(path,groupindex,tktposition){

advAJAX.get( {
	url : '/facebook/addevent/editTickets.jsp?GROUPID='+evtid+'&groupindex='+groupindex+'&position='+tktposition+'&movedntkt=yes',
    onSuccess : function(obj) {
    		  if(document.getElementById('ticketsblock')){
	    	    document.getElementById('ticketsblock').innerHTML=obj.responseText;
	    	    showTicketsellinBlock('yes',path);
	    }
	    },
    onError : function(obj) { alert("Error: " + obj.status); }
});

}

function addGroupOnSubbmit(path,id,id1,position,isedit){
   
    advAJAX.submit(document.getElementById("addgroups"), {
    onSuccess : function(obj) {
	var data=obj.responseText;
	var url='';
	data=testtrim(data);
	       
	getTicketsBlock(path);
	showTicketsellinBlock('new',path);	
	},
    onError : function(obj) { alert("Error: " + obj.status); }
});
}






function addGroupBlock(id,id1,position,grouptype,url) {
	
	advAJAX.get( {
		url : url+"&position="+position+"&id="+id+"&id1="+id1+"&GROUPID="+evtid+"&grouptype="+grouptype,
		onSuccess : function(obj) {
		document.getElementById(id).style.display='none'
		document.getElementById('requiredticketbttn').disabled=true;
		document.getElementById('optionalticketbttn').disabled=true;
		document.getElementById('TR_'+id1).style.display='none';
		
		document.getElementById(id1).innerHTML=obj.responseText;
		
	},
    onError : function(obj) { alert("Error: " + obj.status); }
});
}



function deleteGroup(path,id,position,groupindex,tickettype,url){
     	url=url+"?tickettype="+tickettype+"&id="+id+"&GROUPID="+evtid+"&groupindex="+groupindex;	
	
	url=url+"&position="+position;
	getTicketData(url,path);
	
}


function moveupGroup(path,url,grouptype){


advAJAX.get( {
	url : url+'&GROUPID='+evtid+'&grouptype='+grouptype,
    onSuccess : function(obj) {
    		  if(document.getElementById('ticketsblock')){
	    	    document.getElementById('ticketsblock').innerHTML=obj.responseText;
	    	    showTicketsellinBlock('yes',path);
	    }
	    },
    onError : function(obj) { alert("Error: " + obj.status); }
});
}




function moveupAttribute(k){
var editid=document.getElementById('EDIT_ATTRIBUTE_ID').value;

advAJAX.get( {
		url : '/portal/customattributes/displayCustomAttributes.jsp?moveupid='+k+'&GROUPID='+evtid,
		onSuccess : function(obj) {
			if(editid&&editid==k){
			document.getElementById('dynaattrib_1').style.display='none';
			document.getElementById('addAtribute').style.display='block';
			}
		document.getElementById('showattributes').innerHTML=obj.responseText;
		},
		onError : function(obj) { alert("Error: " + obj.status); }
	});
	}
function movedownAttribute(k){
var editid=document.getElementById('EDIT_ATTRIBUTE_ID').value;

advAJAX.get( {
		url : '/portal/customattributes/displayCustomAttributes.jsp?movedownid='+k+'&GROUPID='+evtid,
		onSuccess : function(obj) {
			if(editid&&editid==k){
			document.getElementById('dynaattrib_1').style.display='none';
			document.getElementById('addAtribute').style.display='block';
			}
		document.getElementById('showattributes').innerHTML=obj.responseText;
		},
		onError : function(obj) { alert("Error: " + obj.status); }
	});
	}

function Disabletktselling(){
document.getElementById('ticketsellingblock').innerHTML='';
}

function Enabletktselling(evtid){
showTicketsellinBlock('new',evtid);
}





function showTicketsellinBlock(reload,path) {
   var options=document.powerregister1234.networkticketing;
          var val;
           for(var j=0;j<options.length;j++){
   				if(options[j].checked==true){
   					val=options[j].value;
   					break;
   				}
		}
	
	advAJAX.get( {
		url : '/facebook/addevent/ticketselling.jsp?reload='+reload+'&GROUPID='+evtid,
		onSuccess : function(obj) {
		if(val=='enable')
				document.getElementById('ticketsellingblock').innerHTML=obj.responseText;
				else
		document.getElementById('ticketsellingblock').innerHTML='';
		},
    onError : function(obj) { alert("Error: " + obj.status); }
});
}


function setcurrency(){
document.getElementById("enabledid").disabled=false;
document.getElementById("disabledid").disabled=false;
document.getElementById("enabledid").checked=true;

var currency=document.getElementById("crncy").value;
document.getElementById("ebee").style.display="none";
document.getElementById("ebee").style.display="block";
if(currency!="USD"){
document.getElementById("disabledid").checked=true;
document.getElementById("enabledid").disabled=true;
document.getElementById("ebeeid").checked=false;
document.getElementById("ebee").style.display="block";
document.getElementById("ebee").style.display="block";
document.getElementById("ebee").style.display="none";
}
advAJAX.get( {
	url : '/facebook/addevent/setcurrency.jsp?currency='+currency,
	onSuccess : function(obj) {
					
			},
			onError : function(obj) { alert("Error: " + obj.status); }
	});
}





