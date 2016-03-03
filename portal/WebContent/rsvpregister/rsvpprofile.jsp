
<script language="javascript" src="/home/js/prototype.js" >
	
</script>
		<script type='text/javascript' language='JavaScript' src='/home/js/controls/checkboxWidget.js'></script>
		<script type='text/javascript' language='JavaScript' src='/home/js/controls/selectWidget.js'></script>
		<script type='text/javascript' language='JavaScript' src='/home/js/controls/radioWidget.js'></script>
		<script type='text/javascript' language='JavaScript' src='/home/js/controls/textboxWidget.js'></script>
		<script type='text/javascript' language='JavaScript' src='/home/js/controls/buildcontrol.js'></script>
		<script type='text/javascript' language='JavaScript' src='/home/js/controls/textareaWidget.js'></script>






<table width='100%'>

<tr><td id='rsvpreg' class='boxheader'></td></tr>

<tr><td id='profile'></td></tr>


<script>
function getRsvpOptionsBlock(evtid){
alert("jjjjjjjjjjj");
 new Ajax.Request('/rsvpregister/rsvpoptions.jsp', {
   method: 'get',
   parameters:{eventid:evtid},
   onSuccess: successFunc
   
  });
 
}
function successFunc(response){
 document.getElementById('rsvpreg').innerHTML=response.responseText;
 }
getRsvpOptionsBlock('473157294');
//getRsvpProfileJson();
</script>