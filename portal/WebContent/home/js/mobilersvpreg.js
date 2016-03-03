
var prodileJson;
var evetid;
var rsvp_event_date;
var seloption;
var CtrlWidgets=[];
var ctrlwidget=[];
var responsesdata=[];
var reqelms=[];
var index=new Boolean(false);
var rsvpurl='';
var rsvpsharepopup="";
var onlysureattend=false;
function getRsvpOptionsBlock(evtid){
	if(document.getElementById('trackcode'))
		rsvpurl=document.getElementById('trackcode').value;
		
 new Ajax.Request('/rsvpregister/rsvpoptions.jsp?timestamp='+(new Date()).getTime(), {
   method: 'get',
   parameters:{eventid:evtid,rsvpurl:rsvpurl},
   onSuccess: successFunc,
   onFailure:  failureFunc
  });
 
}
function successFunc(response){
var backtoboxoffice="";
if($('username').value!=""){
	backtoboxoffice="<a class='button backtoboxoffice' id='backtoboxoffice' style='max-width:115px; float:right;'>Back To Box Office</a><br><br>";	
}
 document.getElementById('rsvpreg').innerHTML=backtoboxoffice+response.responseText;
 if($('backtoboxoffice')){
 jQuery("#backtoboxoffice").click(function(){
	
	jQuery("#rsvpreg").removeClass("current")
	.attr("class","slide out");
	window.location.href="/view/"+$('username').value;
	});
} 		rsvpheader();
		document.getElementById('rsvpreg').style.display="block";
		jQuery('#rsvpreg').attr("class","slide in ");
		var sure=$('sureattend').value;
		var ntsure =$('notsureattend').value;
		var rec=$('rsvprecurringval').value;
		var na=$('notattending').value;
		if(na == 'null'){
		na='N';
		}
		if($('rsvpstatus').value=="CLOSED" || $('rsvpstatus').value=="CANCEL"){
			return;
		}
		if(sure == '1' && ntsure == '0' && na == 'N')
		onlysureattend=true;
		if(sure == '1' && ntsure == '0' && rec == 'null' && na == 'N'){
		
			showrsvpLoadingImage("Loading");
			Element.hide('rsvpreg');
			Element.hide('rsvpprofilecontent');

			getRsvpquestionsJson($('eid').value,"1","0");
		}
		
		addOption();
 }



function failureFunc()
{
alert("failed");
}


function getRsvpProfileJson(evtid,option){
	if(document.getElementById('attendeeno')){
	if(document.getElementById('attendeeno').checked)
		hide_attendee_show();
	}
	else
		document.getElementById('rsvpprofilecontent').style.display='block';
	
	
evetid=evtid;
seloption=option;

 new Ajax.Request('/rsvpregister/rsvpprofilejson.jsp?timestamp='+(new Date()).getTime(), {
  method: 'get',
  parameters:{eventid:evtid,option:option},
  onSuccess: assignjson
  });

  
}



function assignjson(response){

prodileJson=response.responseText;
getRsvpProfileVm();
}

function getRsvpProfileVm(){

	var rsvp_event_date=getrecurringvalue();
new Ajax.Request('/rsvpregister/rsvpprofilevm.jsp?timestamp='+(new Date()).getTime(), {
method: 'get',
parameters:{eventid:evetid,option:seloption,rsvp_event_date:rsvp_event_date},
onSuccess: getprofiles,
  onFailure:  failurep

});
 
}


function getprofiles(response){
	
reqelms=[];
document.getElementById('rsvpprofilecontent').innerHTML=response.responseText;
var responsejsondata=eval('(' + prodileJson + ')');
var questionsdata=responsejsondata.questions;

for(i=0;i<questionsdata.length;i++){
var qid=questionsdata[i];
putWidget('p',qid, '1');
}
}

function failurep(){
	hidersvpLoadingImage();
	Element.show('rsvpreg');
Element.show('rsvpprofilecontent');
alert("please try back later");
}


function putWidget(ticketid,qid, profileid){

var elmid=ticketid+'_'+qid;
var responsejsondata=eval('(' + prodileJson + ')');
var questionjson=responsejsondata[ticketid+'_'+qid];
var  objWidget = new InitControlWidget(questionjson,elmid);
reqelms.push(elmid);
CtrlWidgets[elmid] = objWidget;

}


function submitRsvpprofile(){
	
$('rsvpprofile').request({
 onComplete:res
});
}


function res(response)
{ 
var statusjson=eval('('+response.responseText+')');;
var status=statusjson.Status;
if(status=='Success'){
$('rsvpreg').innerHTML='';
$('rsvpprofilecontent').innerHTML=statusjson.Msg+"<br/><br/><a href='#' onClick='refreshPage()' align='center'>Back To Event Page</a>";
}
else
$('rsvpprofilecontent').innerHTML='completed';
}


function validateRsvpProfiles(){
	
	rsvprecurring=document.getElementById('rsvprecurringval').value;
	if(rsvprecurring == 'Y' && document.getElementById('rsvp_event_date')){
		if(document.getElementById('rsvp_event_date').value=='--Select Dates--'){
			alert('Select Date and time to attend');
			
			document.getElementById('rsvp_event_date').focus();
			return false;
	}
	}

var count=0;
for(var i=0;i<reqelms.length;i++){
p=reqelms[i];
if(CtrlWidgets[p]){
if(CtrlWidgets[p].Validate())
{
	if(p=="s_email_1" || p=="ns_email_1" || p== 'p_email'){
		var emailtest=Validate_email(CtrlWidgets[p].GetValue(),p);
		
				if(emailtest){
					getemailmessage(true,p);
				}
				else{
					getemailmessage(false,p);
					count++;
				}
	}
}
else{
count++;
}
}
}

if(count==0){
	showrsvpLoadingImage("Loading");
	Element.hide('rsvpreg');
	Element.hide('rsvpprofilecontent');
	submitRsvprecprofile();
}
else{
	
if(parseInt(count)>1){
	document.getElementById('profileerr').innerHTML="<font color='red'>There are "+count+" errors</font>";
window.top;
count=0;
}
else{
document.getElementById('profileerr').innerHTML="<font color='red'>There is an  "+count+" errors</font>";
count=0;
window.top;
}
}


}



function display_attendee_show(eventid)
{	
getresponses();
getenablepromotion();
//document.getElementById('rsvpprofilecontent').innerHTML='';
document.getElementById('rsvpprofilecontent').style.display='none';
var checkdropdown=validateRsvpselectedoptions();
	if(checkdropdown == false){
		deselectall();
	}
	else{
	var sure = document.getElementById('sureattend').value;
	var notsure = document.getElementById('notsureattend').value;
	sure=Number(sure);
	notsure=Number(notsure);
	eventid=Number(eventid);
		if(document.getElementById('attendeeyes').checked== true){
			if(sure=='1'){
			
				getRsvpquestionsJson(eventid,'1','0');
			}
			if($('suretoattendlist'))
				$('suretoattendlist').disabled=false;
		}
		else{
			if($('suretoattendlist')){
			$('suretoattendlist').options[0].selected = true;
			$('suretoattendlist').disabled=true;
			}
		}
		if(document.getElementById('attendeenotsure')){
		if(document.getElementById('attendeenotsure').checked== true){
			if(notsure== '1'){
				getRsvpquestionsJson(eventid,'0','1');
			}
			if($('notsuretoattend'))
				$('notsuretoattend').disabled=false;
		}
		else{
			if($('notsuretoattend')){
			$('notsuretoattend').options[0].selected = true;
			$('notsuretoattend').disabled=true;
			}
		}}
	//document.getElementById('rsvp_list_disp').style.display='block';
	document.getElementById('rsvpprofilecontent').innerHTML='';
	//document.getElementById('rsvpprofilecontent').style.display='block'
	//document.getElementById('continue_options').style.display='block';
	selctOptions(sure,notsure);
	}
	
}
function hide_attendee_show()
{
	document.getElementById('rsvpprofilecontent').style.display='block';
	//document.getElementById('rsvp_list_disp').style.display='none';
}

function addOption(){
	
	var sure = document.getElementById('sureattend').value;
	var notsure = document.getElementById('notsureattend').value;
		if($('suretoattendlist'))
			addtolist(sure,document.getElementById('suretoattendlist'));
		if($('notsuretoattend'))
		addtolist(notsure,document.getElementById('notsuretoattend'));
	}

function addtolist(len,optlist){

for(var i=0;i<=len;i++){
		var optn = document.createElement("OPTION");
		if(i=='0')
			optn.text = 'Select Count';
		else
			optn.text = i;
		optn.value = i;
		try {
				optlist.add(optn, null); // standards compliant; doesn't work in IE
			}
			catch(err) {
						optlist.add(optn); // IE only
						}
	}
}


function selctOptions(sure,notsure) {
	
	if(sure > '1'){
	sellist = document.getElementById("suretoattendlist");	
		sellist.options[0].selected = true;
		
	}
	else{
		if($('suretoattendlist'))
		document.getElementById("suretoattendlist").value= '1';
	}
	if(notsure > '1'){
	selllist1 = document.getElementById("notsuretoattend");
		selllist1.options[0].selected = true;
		
	}
	else{
	if($('notsuretoattend'))
		document.getElementById("notsuretoattend").value= '0';
	}
	
}



function disp_rsvp_onchange(){
getresponses();
getenablepromotion();
//document.getElementById('rsvpprofilecontent').innerHTML='';
document.getElementById('rsvpprofilecontent').style.display='none';
var eid=document.getElementById('eid').value;
var chkrecdate=validateRsvpselectedoptions();
if(chkrecdate){
validateRsvpSelected(eid);
}
else{
return false;
}
//document.getElementById('continue_options').style.display='block';
}

function rsvp_recurring_change_list(){
	//document.getElementById('rsvpprofilecontent').innerHTML='';
	document.getElementById('rsvpprofilecontent').style.display='none';
	var notattending=document.getElementById('notattending').value;

	if(document.getElementById('attendeeyes')){
		document.getElementById('attendeeyes').checked=false;
		if($('suretoattendlist')){
			$('suretoattendlist').options[0].selected = true;
			$('suretoattendlist').disabled= true;
		}
	}
	if(document.getElementById('attendeeno'))
	document.getElementById('attendeeno').checked=false;
	if(document.getElementById('attendeenotsure')){
	document.getElementById('attendeenotsure').checked=false;
	if($('notsuretoattend')){
			$('notsuretoattend').options[0].selected = true;
			$('notsuretoattend').disabled= true;
		}
	}
	if(notattending != 'Y' && !$('attendeenotsure') && $('suretoattendlist')){
		document.getElementById('attendeeyes').checked=true;
		if($('suretoattendlist')){
			$('suretoattendlist').options[0].selected = true;
			$('suretoattendlist').disabled= false;
		}
	}
		disp_rsvp_onchange();
	if(document.getElementById('continue_options'))
		document.getElementById('continue_options').style.display='none';	
	if(document.getElementById('rsvp_list_disp'))
		document.getElementById('rsvp_list_disp').style.display='none';

}

function validateRsvpselectedoptions(){
	rsvprecurring=document.getElementById('rsvprecurringval').value;
	if(rsvprecurring == 'Y' && document.getElementById('rsvp_event_date')){
		if(document.getElementById('rsvp_event_date').value=='--Select Date--' ){
		if(!onlysureattend)
			alert('Select Date and time to attend');
			
			document.getElementById('rsvp_event_date').focus();
			return false;
		}
		else{
			return true;
		}
	
	}
	else{
		return true;
	}

}
function validateRsvpSelected(eventid){
	var sure,notsure,alertmsg;
	if(document.getElementById('sureattend'))
		sure = document.getElementById('sureattend').value;
	else
		sure='1';
	if(document.getElementById('notsureattend'))
		notsure = document.getElementById('notsureattend').value;
	else
		notsure='0';
	
	alertmsg=document.getElementById('alertmsg').value;
	var sureselect='0',notsureselect='0';
	
		var na=$('notattending').value;
		if(na == 'null'){
		na='N';
		}
		
		if(sure == '1' && notsure == '0' && na == 'N'){
			showrsvpLoadingImage("Loading");
			Element.hide('rsvpreg');
			Element.hide('rsvpprofilecontent');

			getRsvpquestionsJson($('eid').value,"1","0");
		}
	
	
	else if(document.getElementById('suretoattendlist'))
		sureselect=document.getElementById('suretoattendlist').value;
	else if($('attendeeyes').checked== true)
		sureselect=sure;
	if(document.getElementById('notsuretoattend'))
		notsureselect=document.getElementById('notsuretoattend').value;
	else if($('attendeenotsure')){
		if($('attendeenotsure').checked== true)
			notsureselect=notsure;
	}

	if(document.getElementById('notattending').value=='Y'){
		if(document.getElementById('attendeeyes').checked == true ){
			if(sureselect > 0)
				getRsvpquestionsJson(eventid,sureselect,'0');		
		}
		if(document.getElementById('attendeenotsure')){
		if(document.getElementById('attendeenotsure').checked == true ){
			if(notsureselect>0)
				getRsvpquestionsJson(eventid,'0',notsureselect);		
		}
		}
	}
	else{
			
	if(Number(sureselect)>0){
		getRsvpquestionsJson(eventid,sureselect,'0');
	}
	else if(Number(notsureselect)>0){
		getRsvpquestionsJson(eventid,'0',notsureselect);
	}
	
	}	
		
		

	
}


function getRsvpquestionsJson(eventid,sureattend,notsureattend){
try{
getresponses();
}catch(err){}
	getenablepromotion();
	document.getElementById('rsvpprofilecontent').innerHTML='';

	var x=validateRsvpselectedoptions();
	if(x == false){
	deselectall();
	return false;
	}
	else{
	var rsvp_event_date=getrecurringvalue();

var option='yes';
evetid=eventid;
if(document.getElementById('attendeeno')){
if(document.getElementById('attendeeno').checked == true){
	display_attendee_show(eventid);
	hide_attendee_show();
	option='no';
	sureselect='0';
	notsureselect='0';
}
}
//showrsvpLoadingImage("Loading");
//Element.hide('rsvpreg');
//Element.hide('rsvpprofilecontent');

new Ajax.Request('/rsvpregister/rsvpquestionsjson.jsp?timestamp='+(new Date()).getTime(), {
  method: 'get',
  parameters:{eventid:eventid,sureattend:sureattend,notsureattend:notsureattend,option:option,rsvp_event_date:rsvp_event_date},
 
  onSuccess: rsvpquesassignjson,
	   onFailure:  failurep
  });

  }
	
	
	}
	
  function rsvpquesassignjson(response){
		prodileJson=response.responseText;
		var responsejson=eval('(' + prodileJson + ')');
		var rsvpstatus=responsejson.Available;
		serveradd=responsejson.serveraddress;
		rsvpsharepopup=responsejson.showsharepopup;	
		if(rsvpstatus == 'NO'){
				rsvpcompleted();
		}
		else{
			jQuery("#rsvpreg").removeClass("current");
			jQuery("#rsvpprofilecontent").attr("class","slide in current");
			document.getElementById('rsvpprofilecontent').style.display='block';
			getRsvprecurrProfileVm();
		}
		//hidersvpLoadingImage();
		$('rsvpreg').show();
			$('rsvpprofilecontent').show();
}



function getRsvprecurrProfileVm(){
	var more='false';
	var sure = document.getElementById('sureattend').value;
	var notsure = document.getElementById('notsureattend').value;
	var sureselect,notsureselect;
		if($('attendeeyes')){
		if($('attendeeyes').checked== true  ){
			if(Number(sure) == 1){
				sureselect='1';
				notsureselect='0';
			}
			else{
				sureselect=document.getElementById('suretoattendlist').value;
				notsureselect='0';
				}more ='true';
		}
		
	}
	if($('attendeenotsure')){
		if($('attendeenotsure').checked== true ){
			
			if(Number(notsure) == 1){
				notsureselect='1';
				sureselect='0';
		}
		else{
				notsureselect=document.getElementById('notsuretoattend').value;
				sureselect='0';
		}more='true';
		}
		
	}
	var option="yes";
	if(sure == 1 && notsure == 0){
sureselect =1;
notsureselect = 0;
}
if(document.getElementById('attendeeno')){
	if(document.getElementById('attendeeno').checked== true){
		option='no';
		sureselect='0';
		notsureselect='0';
		more='true';
	}
}
	

	var rsvp_event_date=getrecurringvalue();
try{
new Ajax.Request('/rsvpregister/rsvprecprofilevm.jsp?timestamp='+(new Date()).getTime(), {
method: 'get',
parameters:{eventid:evetid,option: option,sure:sureselect,notsure:notsureselect,rsvp_event_date:rsvp_event_date,more:more,trackcode:rsvpurl,regtype:"mobile"},
onSuccess: getrsvprecprofiles,
  onFailure:  failurep

});
}
catch(err){
alert("try later");
}
}


function getrsvprecprofiles(response){

	var sure = document.getElementById('sureattend').value;
	var notsure = document.getElementById('notsureattend').value;
	var sureselect,notsureselect;
if($('attendeeyes')){
		if($('attendeeyes').checked== true  ){
			notsureselect='0';
			if(Number(sure) == 1){
				sureselect='1';
			}
			else{
				sureselect=document.getElementById('suretoattendlist').value;
			}
		}
	}
	if($('attendeenotsure')){
		if($('attendeenotsure').checked== true ){
			sureselect='0';
			if(Number(notsure) == 1){
				notsureselect='1';
			}
			else{
				notsureselect=document.getElementById('notsuretoattend').value;
			}
		}
	}

if(sure == 1 && notsure == 0){
sureselect =1;
notsureselect = 0;
}
if(document.getElementById('attendeeno')){
	if(document.getElementById('attendeeno').checked== true){
		sureselect='0';
		notsureselect='0';
	}
}

	reqelms=[];
var backlink="";
if(!onlysureattend  || $('rsvp_event_date'))
backlink="<a class='back' id='backlink'>back</a><br><br>";
document.getElementById('rsvpprofilecontent').innerHTML=backlink+response.responseText;

jQuery("#backlink").click(function(){
getresponses();
getenablepromotion();
if($('rsvp_event_date') && onlysureattend){
		
		$('rsvp_event_date').options[0].selected = true;

}
rsvp_recurring_change_list();
	jQuery("#rsvpprofilecontent").addClass("slide in reverse");
	jQuery("#rsvpprofilecontent").removeClass("current");
	jQuery("#rsvpreg").addClass("slide in reverse current");
})
.attr("style","cursor:pointer");
jQuery("#rsvpprofile").attr("class","tableborder");
var responsejsondata=eval('(' + prodileJson + ')');
var questionsdata=responsejsondata.questions;
var surequestions=responsejsondata.surequestions;
var notsurequestions=responsejsondata.notsurequestions;
var type=$('selectedOption').value;

var rsvpsuspended=document.getElementById('rsvpsuspended').value;
if(rsvpsuspended == 'PENDING'){
document.getElementById('submit').disabled= true;
}

for(var p=1;p<=sureselect;p++){
	for(i=0;i<surequestions.length;i++){
		var qid=surequestions[i];
		putsureWidget('s',qid, p);
	}
}

for(var p=1;p<=notsureselect;p++){
	for(i=0;i<notsurequestions.length;i++){
		var qid=notsurequestions[i];
		putsureWidget('ns',qid, p);
	}
}
if(type=='no'){
	for(i=0;i<questionsdata.length;i++){
		var qid=questionsdata[i];
		putrsvpWidget('p',qid, '1');
	}		
}
else{
if(sureselect!=0 || notsureselect!=0)
	putcustomattend(questionsdata);
}
if(document.getElementById('enablepromotion')){

document.getElementById('enablepromotion').checked=promotionenable;
if(promotionenable){
document.getElementById('enablepromotion').value="yes";
}

}		
}

function putcustomattend(questionsdata){
	for(i=0;i<questionsdata.length;i++){
			var qid=questionsdata[i];
			if(qid != 'fname' && qid != 'email' && qid != 'phone' && qid != 'lname')
				putrsvpWidget('p',qid, '1');
		}
}

function putrsvpWidget(ticketid,qid, profileid){
var elmid=ticketid+'_'+qid;
var responsejsondata=eval('(' + prodileJson + ')');
var questionjson=responsejsondata[ticketid+'_'+qid];
var  objWidget = new InitControlWidget(questionjson,elmid);
reqelms.push(elmid);
ctrlwidget.push(elmid);
CtrlWidgets[elmid] = objWidget;

}

function putsureWidget(ticketid,qid, profileid){
var elmid=ticketid+'_'+qid+'_'+profileid;
var responsejsondata=eval('(' + prodileJson + ')');
var questionjson=responsejsondata[ticketid+'_'+qid];
var  objWidget = new InitControlWidget(questionjson,elmid);
reqelms.push(elmid);
ctrlwidget.push(elmid);
CtrlWidgets[elmid] = objWidget;

}

function getrecurringvalue(){
	rsvprecurring=document.getElementById('rsvprecurringval').value;
	
	if(rsvprecurring=='Y' && document.getElementById('rsvp_event_date')){
		
		rsvp_event_date=document.getElementById('rsvp_event_date').value;
			
	}
	else{
		rsvp_event_date='null';
	}
	
	return rsvp_event_date;
}

function submitRsvprecprofile(){
	
	
$('rsvpprofile').request({
 onComplete:rsvpres
});
}


function rsvpres(response)
{ 
	

var statusjson=eval('('+response.responseText+')');
var status=statusjson.Status;

var rsvpstatus=statusjson.Available;
var emailid=statusjson.emailid;
var rsvppageheader=document.getElementById("confirmationpageheader").value;
if($('pageheader')){
		$('pageheader').innerHTML=rsvppageheader;
	}
if(rsvpstatus == "YES"){
	var response=statusjson.responsetype;
	
		if(status=='Success'){
			if(response=='N'){
				$('rsvpreg').innerHTML='';
				$('rsvpprofilecontent').innerHTML="";
				jQuery("#rsvpprofilecontent").removeClass("current");
				var backtoboxoffice="<a href='' id='rsvpbacktoevtpage' onClick='refreshPage()' align='center' class='button backtoboxoffice'>Back To Event Page</a>";
				jQuery("#rsvpprofilecontent").addClass("slide in");
				if($('username').value!=""){
				backtoboxoffice+="<a class='button backtoboxoffice' id='confbacktoboxoffice' style='max-width:115px; float:right;'>Back To Box Office</a><br><br>";	
				}
				else
					backtoboxoffice+="<br><br>";
				$('rsvpreg').innerHTML=backtoboxoffice+"<table class='tableborder' width='100%'><tr><td >"+statusjson.Msg+"</td></tr></table>";
				jQuery("#rsvpreg").addClass("current slide in ");
				if($('confbacktoboxoffice')){
					jQuery("#confbacktoboxoffice").click(function(){
					jQuery("#registration").removeClass("current")
					.attr("class","slide in reverse");
					window.location.href="/view/"+$('username').value;
					});
					jQuery("#rsvpbacktoevtpage").attr("style","right:160px;");
				}
				hidersvpLoadingImage();
				Element.show('rsvpreg');
				Element.show('rsvpprofilecontent');
			}
			else{
				rsvpconformationpage(statusjson.transactionid,emailid);
			}
	}
	else
		$('rsvpprofilecontent').innerHTML='completed';
}
else{
rsvpcompleted();
}

}

function rsvpconformationpage(transactionid,emailid){

	var sure = document.getElementById('sureattend').value;
	var notsure = document.getElementById('notsureattend').value;
	var sureselect,notsureselect;
	var na=$('notattending').value;
	if(na =='null'){
	na='N';
	}
	if(sure =='1' && notsure == '0' && na=='N'){
		sureselect = '1';
		notsureselect = '0';
	}
	else{
	if($('attendeeyes')){
		if($('attendeeyes').checked== true  ){
			notsureselect='0';
			if(Number(sure) == 1){
				sureselect='1';
			}
			else{
				sureselect=document.getElementById('suretoattendlist').value;
			}
		}
	}
	if($('attendeenotsure')){
		if($('attendeenotsure').checked== true ){
			sureselect='0';
			if(Number(notsure) == 1){
				notsureselect='1';
			}
			else{
				notsureselect=document.getElementById('notsuretoattend').value;
			}
		}
	}
	}
	new Ajax.Request('/rsvpregister/rsvpconformation.jsp?timestamp='+(new Date()).getTime(), {
method: 'get',
parameters:{eventid:evetid,sure:sureselect,notsure:notsureselect,rsvp_event_date:rsvp_event_date,transactionid:transactionid,emailid:emailid},

onSuccess: getrsvpconformationpage,
  onFailure:  failurep

});

}

function getrsvpconformationpage(response){
	reqelms=[];
	//$('rsvpreg').innerHTML='';
	//$('rsvpprofilecontent').innerHTML='';
	var backtoboxoffice="";
	var backtoboxoffice="<a href='' id='rsvpbacktoevtpage' onClick='refreshPage()' align='center' class='button backtoboxoffice'>Back To Event Page</a>";
	if($('username').value!=""){
	backtoboxoffice+="<a class='button backtoboxoffice' id='confbacktoboxoffice' style='max-width:115px; float:right;'>Back To Box Office</a><br><br>";	
	}
	else{
		backtoboxoffice+="<br><br>";
	}
	jQuery("#rsvpprofilecontent, #rsvpreg").removeClass("current reverse");
	jQuery("#rsvpprofilecontent").addClass("slide in");
	document.getElementById('rsvpreg').innerHTML=backtoboxoffice+response.responseText;
	if($('confbacktoboxoffice')){
		jQuery("#confbacktoboxoffice").click(function(){
		jQuery("#registration").removeClass("current")
		.attr("class","slide in reverse");
		window.location.href="/view/"+$('username').value;
		});
		jQuery("#rsvpbacktoevtpage").attr("style","right:160px;");
	}
	jQuery("#rsvpreg .boxcontent tr:first-child a,#rsvpreg .boxcontent tr:last-child a").attr("style","display:none;");
	jQuery("#rsvpreg").addClass("current slide in ");
	jQuery("p").parent("td").attr("style","display:none");
	jQuery("p:last").parent("td").attr("style","display:none");
	hidersvpLoadingImage();
	Element.show('rsvpreg');
	Element.show('rsvpprofilecontent');
	if(rsvpsharepopup!='N'){
	//getconfirmationfbsharepopup();
	}

}

function rsvpcompleted(){
		document.getElementById('rsvpprofilecontent').innerHTML='';
		alert("Attendee count exceeded max available limit");
		return false;
	}
function rsvpheader(){
	if($('pageheader')){
		$('pageheader').show();
		$('pageheader').innerHTML=document.getElementById('pageheaders').value;
		
	}
	}



	function copyRSVPData(pattern,id){
	var fname=document.getElementById('q_'+pattern+'_fname_'+id).value;
	var lname=document.getElementById('q_'+pattern+'_lname_'+id).value;
	var email='';
	var phone='';
	if(document.getElementById('q_'+pattern+'_email_'+id)){
		email=document.getElementById('q_'+pattern+'_email_'+id).value;
	}
	if(document.getElementById('q_'+pattern+'_phone_'+id)){
		phone=document.getElementById('q_'+pattern+'_phone_'+id).value;
	}
	//if(document.getElementById('q_p_fname'))
		document.getElementById('q_p_fname').value=fname;
	//if(document.getElementById('q_p_lname'))
		document.getElementById('q_p_lname').value=lname;
	//if(document.getElementById('q_p_email'))
		document.getElementById('q_p_email').value=email;
	//if(document.getElementById('q_p_phone'))
		//document.getElementById('q_p_phone').value=phone;
	
	
}



var loaded = false;


function showrsvpLoadingImage(msg) {
loaded = false;

var el = document.getElementById("rsvpimageLoad");
if (el && !loaded) {
el.innerHTML = msg+' ......<br/><br/><br/><img src="/home/images/ajax-loader.gif">';
//new Effect.Appear('rsvpimageLoad');
Element.show('rsvpimageLoad');
}
}



function hidersvpLoadingImage(){

if(document.getElementById("rsvpimageLoad")){

Element.hide('rsvpimageLoad');
loaded = true;
}
}



function rsvp_copy(){
	var selectedcopy=document.getElementById('copyfrom').value;
	if(selectedcopy == 'Select'){
		$('q_p_fname').value='';
		$('q_p_lname').value='';
		if($('q_p_email'))
		$('q_p_email').value='';
		if($('q_p_phone'))
		$('q_p_phone').value='';
	}
	else{
		var pattern=new Array();
		pattern =selectedcopy.split(" ");
		copyRSVPData(pattern[0],pattern[1]);
	}
}



function showRSVPAttendeesList(groupid){

var attdate='';
var eventtype='';
var showlist=true;
if(document.getElementById('event_date')){
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

function deselectall(){
if($('attendeeyes'))
			$('attendeeyes').checked= false;
		if($('attendeenotsure'))
			$('attendeenotsure').checked= false;
		if($('attendeeno'))
			$('attendeeno').checked= false;	
}
function getresponses(){
	for (var p=0;p<ctrlwidget.length;p++){
		var id=ctrlwidget[p];
		try{
			responsesdata[id]=CtrlWidgets[id].GetValue();
			}catch(err){ }
	}
}


function emailcheck(str) {
		var at="@"
		var dot="."
		var lat=str.indexOf(at)
		var lstr=str.length
		var ldot=str.indexOf(dot)
		if (str.indexOf(at)==-1){
		   return false
		}

		if (str.indexOf(at)==-1 || str.indexOf(at)==0 || str.indexOf(at)==lstr){
		   return false
		}

		if (str.indexOf(dot)==-1 || str.indexOf(dot)==0 || str.indexOf(dot)==lstr){
		    return false
		}

		 if (str.indexOf(at,(lat+1))!=-1){
		    return false
		 }

		 if (str.substring(lat-1,lat)==dot || str.substring(lat+1,lat+2)==dot){
		    return false
		 }

		 if (str.indexOf(dot,(lat+2))==-1){
		    return false
		 }
		
		 if (str.indexOf(" ")!=-1){
		    return false
		 }


 		 var email_regex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
		//if(!email_regex.test(str)){
			return email_regex.test(str);
		//}
 		// return true				
	}

function Validate_email(emailID,textid){
	emailID=jQuery.trim(emailID);
	var id='q_'+textid;
	$(id).value=emailID;
	if ((emailID==null)||(emailID=="")){
		return false
	}
	if (emailcheck(emailID)==false){
		return false
	}
	return true
 }

function getemailmessage(type,textid){
	if(type){
		if($('email_err_msg')){
			$('email_err_msg').innerHTML='';
			$('email_err_msg').style.display='none';
		}
	}
	else{
		if($('email_err_msg')){
		}
		else{
			var cell=$(textid);
			var div=document.createElement('div');
			div.setAttribute('id','email_err_msg');
			div.setAttribute("style","color: red;");
			cell.appendChild(div);
		}
		$('email_err_msg').innerHTML='Invalid Email';
		$('email_err_msg').style.display='block';
	}
}

function getenablepromotion(){
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
}