<%@ page import="java.io.*, java.util.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*,com.eventbee.event.ticketinfo.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.customconfig.*,com.eventbee.event.BeeletController,com.eventbee.event.*" %>
<%@ page import="com.customattributes.CustomAttributesDB" %>
<script type="text/javascript" language="JavaScript" src="/home/js/advajax.js">
        function dummy1() { }
</script>
<link rel="stylesheet" type="text/css"  href="/home/css/modal.css" />
<script type="text/javascript" language="JavaScript" src="/home/js/modal.js"></script>

<script>
var ajaxwin;
function showattributes(groupid){
ajaxwin=dhtmlmodal.open("ajaxbox", "ajax", "/portal/eventmanage/showattribs.jsp?eid="+groupid, "Display Attributes", "width=650px,height=400px,resize=0,scrolling=1,center=1", "recal") 		
}

function editAttributes(groupid){
ajaxwin=dhtmlmodal.open("ajaxbox", "ajax", "/portal/eventmanage/editattribs.jsp?eid="+groupid, "Display Attributes", "width=650px,height=400px,resize=0,scrolling=1,center=1", "recal") 		
}


function hideattribs(){
ajaxwin.hide();
}
var NS4 = (navigator.appName == "Netscape" && parseInt(navigator.appVersion) < 5);

function selectAll(process) {
  var selone=document.getElementById('sel1');
  var seltwo=document.getElementById('sel2');
if(seltwo.length==0){
alert('Select Attribute');
return false;
} 
	// have we been passed an ID
	if (typeof selectBox == "string") {
		selectBox = document.getElementById(selectBox);
	}
	// is the select box a multiple select box?
	if (selone.type == "select-multiple") {
		for (var i = 0; i < selone.options.length; i++) {
		    
			selone.options[i].selected = selectAll;
		}
	}
	if (seltwo.type == "select-multiple") {
		for (var i = 0; i < seltwo.options.length; i++) {
		    seltwo.options[i].selected = selectAll;
		}
	}
var formid="addattribs";
if(process=='edit'){
formid="editattributes";
}
advAJAX.submit(document.getElementById(formid), {

   	onSuccess : function(obj) {
   		var data=obj.responseText;   		
   		window.location.reload(true);	
   		},
   onError : function(obj) { alert("Error: " + obj.status); }
  });
  }
function deleteOption(theSel, theIndex)
{ 
  var selLength = theSel.length;
  if(selLength>0)
  {
    theSel.options[theIndex] = null;
  }
}
function addOption(theSel, theText, theValue)
{

  var newOpt = new Option(theText, theValue);
  var selLength = theSel.length;
  theSel.options[selLength] = newOpt;
}

function moveOptions(theSelFrom, theSelTo)
{
  
  var selLength = theSelFrom.length;
  var selectedText = new Array();
  var selectedValues = new Array();
  var selectedCount = 0;
  
  var i;
  
  // Find the selected Options in reverse order
  // and delete them from the 'from' Select.
  for(i=selLength-1; i>=0; i--)
  {
    if(theSelFrom.options[i].selected)
    { 
      selectedText[selectedCount] = theSelFrom.options[i].text;
      selectedValues[selectedCount] = theSelFrom.options[i].value;
      deleteOption(theSelFrom, i);
      selectedCount++;
    }
  }
  
  // Add the selected text/values in reverse order.
  // This will add the Options to the 'to' Select
  // in the same order as they were in the 'from' Select.
  for(i=selectedCount-1; i>=0; i--)
  {
    addOption(theSelTo, selectedText[i], selectedValues[i]);
  }
  
  if(NS4) history.go(0);
}

function moveup(theSelFrom){
selindex=theSelFrom.selectedIndex;
var selectOptions = theSelFrom.getElementsByTagName('option');

if(selindex>0){
	for (var i = 1; i < selectOptions.length; i++) {
	  var opt = selectOptions[i];
	  if (opt.selected) {
	   theSelFrom.removeChild(opt);
	   theSelFrom.insertBefore(opt, selectOptions[i - 1]);
	     }
    }
}

}

function movedown(theSelFrom){
	var selectOptions = theSelFrom.getElementsByTagName('option');
	 for (var i = selectOptions.length - 2; i >= 0; i--) {
	  var opt = selectOptions[i];
	  if (opt.selected) {
	   var nextOpt = selectOptions[i + 1];
	   opt = theSelFrom.removeChild(opt);
	   nextOpt = theSelFrom.replaceChild(opt, nextOpt);
	   theSelFrom.insertBefore(nextOpt, opt);
	     }
    }
}


function pwdprotection()
{	
	document.getElementById('pwdprotect').style.display="block";		
	//document.getElementById('protect').focus();
}
</script>

<script>
function insertpwd(groupid){	
	//alert(groupid);
	var password=document.getElementById('password').value;	
	password=encodeURIComponent(password);	    
		advAJAX.get( {			
		url : '/portal/eventmanage/passwordprotection.jsp?groupid='+groupid+'&password='+password,
		onSuccess : function(obj) {
		var data=obj.responseText;
		data=testtrim(data);		
		document.getElementById('pwdprotect').style.display="none";			
		},
		onError : function(obj) { alert("Error: " + obj.status); }
	});

}
function hide()
{
	document.getElementById('pwdprotect').style.display="none";
}
function eventlogo(){	
	
	document.getElementById('logomsg').style.display="block";
}
function inserteventinfo(groupid){	
	var image=document.getElementById('image').value;
	var message=document.getElementById('message').value;	
	
		advAJAX.get( {			
		url : '/portal/eventmanage/inserteventpagemessage.jsp?groupid='+groupid+'&image='+image+'&message='+message,
		onSuccess : function(obj) {
		var data=obj.responseText;
		data=testtrim(data);		
		document.getElementById('logomsg').style.display="none";			
		},
		onError : function(obj) { alert("Error: " + obj.status); }
	});

}


function hidelogo()
{
	document.getElementById('logomsg').style.display="none";
}
function attendeelogo(){	
	
	document.getElementById('attendeelogomsg').style.display="block";
}
function insertattendeeinfo(groupid){	
	var attendeeimage=document.getElementById('attendeeimage').value;
	var attendeemessage=document.getElementById('attendeemessage').value;	
	
		advAJAX.get( {			
		url : '/portal/eventmanage/insertattendeepagemessage.jsp?groupid='+groupid+'&attendeeimage='+attendeeimage+'&attendeemessage='+attendeemessage,
		onSuccess : function(obj) {
		var data=obj.responseText;
		data=testtrim(data);		
		document.getElementById('attendeelogomsg').style.display="none";			
		},
		onError : function(obj) { alert("Error: " + obj.status); }
	});

}


function hideattendeelogo()
{
	document.getElementById('attendeelogomsg').style.display="none";
}

function contentpagedisp(){
document.getElementById('contentdispnames').style.display="block";
}
function hidecontent(){
document.getElementById('contentdispnames').style.display="none";
}
function emailreceiveoptions(){
document.getElementById('emailreceiveoptionnames').style.display="block";
}

function hideemailreceive(){
document.getElementById('emailreceiveoptionnames').style.display="none";
}
function mailto(value,sendto,groupid){
advAJAX.get( {			
		url : '/portal/eventmanage/setemailreceiveoptions.jsp?groupid='+groupid+'&value='+value+'&sendto='+sendto,
		onSuccess : function(obj) {
		var data=obj.responseText;
		data=testtrim(data);		
				
		},
		onError : function(obj) { alert("Error: " + obj.status); }
	});
}
</script>
<%
String groupid=request.getParameter("GROUPID");
String mgrtokenid = (String)request.getAttribute("mgrtokenid");
boolean ispowered=false;
	
ispowered=("Yes".equalsIgnoreCase((new EventTicketDB()).getEventConfig(groupid, "event.poweredbyEB")));

String premiumlevel=DbUtil.getVal("select premiumlevel from eventinfo where eventid=?",new String [] {request.getParameter("GROUPID")});
String photourl1=DbUtil.getVal("select photourl from eventinfo  where eventid=?",new String[] {(String)request.getParameter("GROUPID")});
String attendeephoto=DbUtil.getVal("select attendeepagephoto  from eventinfo  where eventid=?",new String[] {(String)request.getParameter("GROUPID")});
String password=DbUtil.getVal("select password from view_security where eventid=?",new String[]{request.getParameter("GROUPID")});
if(password==null) password="";
boolean powered=false;
boolean isdisplay=false;
HashMap hm=(HashMap)session.getAttribute("groupinfo");
powered="Yes".equalsIgnoreCase(EventTicketDB.getEventConfig((String)hm.get("groupid"), "event.poweredbyEB"));
String authid=null,role=null,unitid=null;
String config_id="",value="";
String gmapPref="";
String accounttype=null;
boolean showeventpageattendeelist = false;
boolean showrecommenedeventbox = false;
boolean showloginbox = false;
boolean sendmailtoattendeecheck = true;
boolean sendmailtomanagercheck = true;
Authenticate authData=AuthUtil.getAuthData(pageContext);
 	 if (authData!=null){

      	 	 authid=authData.getUserID();
		  role=authData.getRoleName();
		 unitid=authData.getUnitID();
		 accounttype=authData.getAccountType();
	 }
	 String googlemapshow=DbUtil.getVal("select b.value from eventinfo a,config b where a.config_id=b.config_id and mgr_id=? and eventid=? and b.name='eventpage.map.show' ",new String[]{authid,groupid});
	 String evtname="";
	String googlemapstring="Show Google Map";
	if("yes".equalsIgnoreCase(googlemapshow))googlemapstring="Hide Google Map";
	
	//Streamer Show/Hide
	String streamershow=DbUtil.getVal("select b.value from eventinfo a,config b where a.config_id=b.config_id and mgr_id=? and eventid=? and b.name='eventpage.streamer.show' ",new String[]{authid,groupid});
	String streamerlink="Hide Recommended Events Box";
	if("No".equalsIgnoreCase(streamershow)){
	streamerlink="Show Recommended Events Box";	
	}else
	showrecommenedeventbox=true;
	
	
	//For Attendee Page Google Map
	String googlemapshow1=DbUtil.getVal("select b.value from eventinfo a,config b where a.config_id=b.config_id and mgr_id=? and eventid=? and b.name='attendeepage.map.show' ",new String[]{authid,groupid});
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, "ConfigureEvet.jsp", "null", "in AttendeePage googlemapshow1 String value is-------"+googlemapshow1,null);
	String googlemapstring1="Show Google Map";
	if("yes".equalsIgnoreCase(googlemapshow1))googlemapstring1="Hide Google Map";
	///End Attendee Page Google Map 
	
	String attendeepageattendeestring="Show Attendee List";
	String eventpageattendeepref=DbUtil.getVal("select b.value from eventinfo a,config b where a.config_id=b.config_id and mgr_id=? and eventid=? and b.name='eventpage.attendee.show' ",new String[]{authid,groupid});
	String attendeepagepref=DbUtil.getVal("select b.value from eventinfo a,config b where a.config_id=b.config_id and mgr_id=? and eventid=? and b.name='attedeepage.attendee.show' ",new String[]{authid,groupid});
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, "ConfigureEvet.jsp", "null", "in AttendeePage attendeepagepref String value is-------"+attendeepagepref,null);
	String showloginstring="Show Eventbee Login Box During Registration";
	String showloginsignup=DbUtil.getVal("select showlogin from eventinfo e,config c where e.config_id=c.config_id and c.name='event.poweredbyEB' and c.value='yes' and e.eventid=?",new String[]{groupid});
	if("Yes".equals(showloginsignup)){
		showloginstring="Hide Eventbee Login Box During Registration";
		showloginbox=true;
		}
	else{
	
		showloginsignup="No";
		}
	String eventpageattendeestring="Show Attendee List";
	evtname=request.getParameter("evtname");
	if(evtname!=null)
		evtname=java.net.URLEncoder.encode(evtname);
	if("Yes".equalsIgnoreCase(attendeepagepref))attendeepageattendeestring="Hide Attendee List";
	else
	attendeepagepref="No";
		
	if("Yes".equalsIgnoreCase(eventpageattendeepref)){
	eventpageattendeestring="Hide Attendee List";
	showeventpageattendeelist=true;
	}
	else{
	eventpageattendeepref="No";
	
	}
	String configid="select config_id from eventinfo where eventid=?";
	String confid=DbUtil.getVal(configid, new String[]{groupid});
	String message=DbUtil.getVal("select value from config where name='eventpage.logo.message' and config_id=?",new String[]{confid});
	if(message==null) message="";
	
	String imageurl=DbUtil.getVal("select value  from config where name='eventpage.logo.url' and config_id=?",new String[]{confid});
	if(imageurl==null) imageurl="";
	
	String attendeemessage=DbUtil.getVal("select value from config where name='attendeepage.logo.message' and config_id=?",new String[]{confid});
	if(attendeemessage==null) attendeemessage="";
		
	String attendeeimage=DbUtil.getVal("select value  from config where name='attendeepage.logo.url' and config_id=?",new String[]{confid});
	if(attendeeimage==null) attendeeimage="";
	
	String sendmailtoattendee=DbUtil.getVal("select value from config where name='event.sendmailtoattendee' and config_id=(select config_id from eventinfo where eventid=?)",new String[]{groupid});
	if("Yes".equalsIgnoreCase(sendmailtoattendee)){
	sendmailtoattendeecheck=true;
	}
	if("No".equalsIgnoreCase(sendmailtoattendee)){
		sendmailtoattendeecheck=false;
	}
	String sendmailtomgr=DbUtil.getVal("select value from config where name='event.sendmailtomgr' and config_id=(select config_id from eventinfo where eventid=?)",new String[]{groupid});
	if("Yes".equalsIgnoreCase(sendmailtomgr)){
	sendmailtomanagercheck=true;
	}
	if("No".equalsIgnoreCase(sendmailtomgr)){
	sendmailtomanagercheck=false;
	}
	String isattindeeattibsexist=DbUtil.getVal("select 'Yes' from attendeelist_attributes where eventid=?",new String[]{groupid});
	if(isattindeeattibsexist==null){
	String custom_setid=CustomAttributesDB.getAttribSetID(groupid,"EVENT");
	String INSERT_ATTENDEE_ATTRIBUTES="insert into attendeelist_attributes(eventid,position,attrib_setid,attribname,created_at)values(?,1,?,'Attendee Name',now())";
	DbUtil.executeUpdateQuery(INSERT_ATTENDEE_ATTRIBUTES,new String[]{groupid,custom_setid});

	}

	
%>

<div class='memberbeelet-header'>Configure Event </div>

<script>
function configureEventView(id,url,prefval,donemsg) {
document.getElementById('showmessage').innerHTML='';
advAJAX.get( {
	url : url,
	onSuccess : function(obj) {
	document.getElementById(id).innerHTML=obj.responseText;
	document.getElementById('showmessage').innerHTML='<font class="smallestfont">'+donemsg+'</font>';
	},
    onError : function(obj) { alert("Error: " + obj.status); }
});
}
function deletephoto(id,url,groupid,purpose) {
advAJAX.get( {
	url : url,
    onSuccess : function(obj) {
	document.getElementById(id).innerHTML="<a href=javascript:document.getElementById('showmessage').innerHTML='';popupwindow('/eventmanage/addEventImage.jsp?GROUPID="+groupid+"&purpose="+purpose+"','getphoto','800','500')>Add Photo</a>";
	document.getElementById('showmessage').innerHTML='<font class="smallestfont">Event Photo deleted Successfully</font>';
	},
    onError : function(obj) { alert("Error: " + obj.status); }
});
}
</script>
<table width='100%'  cellpadding='0' cellspacing='0'>
	<%--<tr><td id='showmessage'></td></tr>--%>
	 <div id='showmessage'></div>
	<tr>
		<td  align="left">
		<table align='center' cellpadding='0' cellspacing='0' width='100%'>
		<tr ><td class="colheader" align='left' width="34%">Event Page</td>
		<input type="hidden" value='<%=(String)hm.get("GROUPID")%>' name="groupid">
		<td class="colheader" >
		
		<table cellpadding='0' cellspacing='0' align='left' >
	<tr ><td ><a href='/portal/mytasks/gettheme.jsp?type=event&GROUPID=<%=request.getParameter("GROUPID")%>&mgrtokenid=<%=mgrtokenid%>'>Theme</a>&nbsp;|&nbsp; 
	</td></tr>
	</table>


	 <table cellpadding='0' cellspacing='0' align='left' >
	<tr ><td  ><a href='/portal/mytasks/eventcustomthemetemplate.jsp?type=event&GROUPID=<%=request.getParameter("GROUPID")%>&mgrtokenid=<%=mgrtokenid%>'>&nbsp;Theme Templates</a>&nbsp;|&nbsp; 
	</td></tr>
	</table>

		
		 <table cellpadding='0' cellspacing='0' align='left' >
	<tr ><td  ><a href="javascript:popupwindow('/portal/eventdetails/eventdetails.jsp?GROUPID=<%=(String)hm.get("GROUPID")%>','Email','800','600');">&nbsp;Preview</a></td>
		</td></tr>
	</table>
		</tr>
		</table>
		</td>
	</tr>
	<tr>
	<td  align="left" class='evenbase' id='eventphoto'>
	<%if(photourl1==null||"".equals(photourl1.trim())){%>
			<a href="javascript:document.getElementById('showmessage').innerHTML='';popupwindow('/eventmanage/addEventImage.jsp?GROUPID=<%=groupid%>&purpose=event&mgrtokenid=<%=mgrtokenid%>','getphoto','800','500')">Add Photo</a>
	<%}else{%>
			<a HREF='#' onClick='deletephoto("eventphoto","/portal/eventmanage/deletePhoto.jsp?GROUPID=<%=groupid%>&purpose=event","<%=groupid%>","event")' >Delete Photo</a>
	<%}%>
	</td>
	</tr>
	<tr>
	<td align="left" class='evenbase' >
	<span style="cursor: pointer; text-decoration: underline" id="logo" onClick='eventlogo()' >Logo & Message</span>
	<td></td><td></td></td></tr>
	<tr ><td class="evenbase" id="logomsg"  style="display:none"> 
	<span class="smallestfont">Enter photo URL here, for best result make sure photo width is 200</span><br>
	<input type="text" name="image" id="image" value="<%=imageurl%>" size="60"/><br>
	<span class="smallestfont">Enter Message here, keep it 140 chars or less</span><br>
	<textarea name="message" id="message"  rows="2" cols="43" ><%=message%></textarea><br>
	<input type="button" name="button" value="Submit" onclick="inserteventinfo(<%=groupid %>);" />
	<input type="button" name="cancel" value="Cancel" onclick='javascript:hidelogo();' />
	</td>
	<td></td>
	</tr>

<tr>
	<td  align="left" class='evenbase'><span id='eventattendeepref'>
	<a HREF='#' onClick='configureEventView("eventattendeepref","/portal/eventmanage/updateAttendeePref.jsp?purpose=event&GROUPID=<%=groupid%>&prefval=<%=eventpageattendeepref%>","<%=eventpageattendeepref%>","Attendee list preferences updated successfully")' ><%=eventpageattendeestring%></a></span>
	| <%if(isattindeeattibsexist==null){%><a href="#" onclick="showattributes(<%=groupid%>); return false;"><%}else{%><a href="#" onclick="editAttributes(<%=groupid%>); return false;"><%}%>Display Information</a>
	</td>
</tr>

<tr>
	<td  align="left" class='evenbase' id='googlemap'>
		<a HREF='#' onClick='configureEventView("googlemap","/portal/createevent/updateGmapPref.jsp?purpose=event&GROUPID=<%=groupid%>&prefval=<%=googlemapshow%>&mgrtokenid=<%=mgrtokenid%>","<%=googlemapshow%>","Google map preference updated successfully")' ><%=googlemapstring%></a>
	</td>
</tr>

<%--<tr>
	<td  align="left" class='evenbase' id='streamerdisplay'>
		<a HREF='#' onClick='configureEventView("streamerdisplay","/portal/createevent/updateStreamerPref.jsp?purpose=event&GROUPID=<%=groupid%>&prefval=<%=streamershow%>&mgrtokenid=<%=mgrtokenid%>","<%=streamershow%>","Streamer preference updated successfully")' ><%=streamerlink%></a>
	</td>
</tr> --%>

<tr>
	<td  align="left" class='evenbase' id='eventattendeelogin'>
	<a HREF='#' onClick='configureEventView("eventattendeelogin","/portal/eventmanage/updateAttendeeLogin.jsp?purpose=event&GROUPID=<%=groupid%>&prefval=<%=showloginsignup%>&mgrtokenid=<%=mgrtokenid%>","<%=showloginsignup%>","Updated Eventbee Login Box Display Setting")' ><%=showloginstring%></a>
	</td>
</tr>
<%if(ispowered){%>
<tr>
	<td  align="left" class='evenbase'>
	<a href='/mytasks/displayoptions.jsp?GROUPID=<%=groupid%>&mgrtokenid=<%=mgrtokenid%>'>Ticket Display Options</a>
	</td>
</tr>
<%}%>

<tr>
   <td align="left" class='evenbase' >

	<span style="cursor: pointer; text-decoration: underline" name="protect" id="protect" value="protection" onClick='pwdprotection()' >Password Protection</span>
<td></td><td></td></td></tr>
<tr >
<td >
<div class="evenbase" id="pwdprotect"  style="display:none">
<span class="smallestfont">Leave blank to remove password protection</span><br>
	<input type="text" name="password" id="password" value="<%=password %>" />
	<input type="button" name="button" value="Submit" onclick="insertpwd(<%=groupid %>);" />
	<input type="button" name="button" value="Cancel" onclick="hide();" />

</div>
</td>
<td></td>
</tr>
<tr>
	<td  align="left" class='evenbase'>
	<a href='/mytasks/enterlnfinfo.jsp?type=eventdetails&GROUPID=<%=groupid%>&PS=EVENTDET&mgrtokenid=<%=mgrtokenid%>'>Header/Footer Settings</a>
	</td>
</tr>
<tr><td>


<table align='center' cellpadding='0' cellspacing='0' width='100%'>
		<tr ><td class="colheader" align='left' width="34%">Attendee Page</td>
		<input type="hidden" value='<%=(String)hm.get("GROUPID")%>' name="groupid">
		<td class="colheader">
		
		<table cellpadding='0' cellspacing='0' align='left' >
	<tr ><td ><a href='/portal/mytasks/gettheme.jsp?type=attendeepage&GROUPID=<%=request.getParameter("GROUPID")%>&mgrtokenid=<%=mgrtokenid%>'>Theme</a>&nbsp;|&nbsp; 
	</td></tr>
	</table>
<table cellpadding='0' cellspacing='0' align='left' >
	<tr ><td  >&nbsp;<a href="javascript:popupwindow('/portal/eventdetails/eventdetails.jsp?type=attendeepage&GROUPID=<%=(String)hm.get("GROUPID")%>&mgrtokenid=<%=mgrtokenid%>','Email','800','600');">Preview</a></td>
		</td></tr>
	</table>
		</tr>
		</table>
		

</td></tr>

<tr>
	<td  align="left" class='evenbase' id='eventphoto1'>
	<%
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, "ConfigureEvet.jsp", "null", "attendeephoto value is"+attendeephoto,null);
	%>
	<%if(attendeephoto==null||"".equals(attendeephoto.trim())){%>
			<a href="javascript:document.getElementById('showmessage').innerHTML='';popupwindow('/eventmanage/addEventImage.jsp?GROUPID=<%=groupid%>&purpose=attendee&mgrtokenid=<%=mgrtokenid%>','getphoto','800','500')">Add Photo</a>
	<%}else{%>
			<a HREF='#' onClick='deletephoto("eventphoto1","/portal/eventmanage/deletePhoto.jsp?GROUPID=<%=groupid%>&type=attendeepage&purpose=attendee","<%=groupid%>&mgrtokenid=<%=mgrtokenid%>","attendee")' >Delete Photo</a>
	<%}%>
	</td>
	</tr>
	<tr>
	<td align="left" class='evenbase' >
	<span style="cursor: pointer; text-decoration: underline" id="logo" onClick='attendeelogo()' >Logo & Message</span>
	<td></td><td></td></td></tr>
	<tr ><td class="evenbase" id="attendeelogomsg"  style="display:none"> 
	<span class="smallestfont">Enter photo URL here, for best result make sure photo width is 200</span><br>
	<input type="text" name="attendeeimage" id="attendeeimage" value="<%=attendeeimage%>" size="60"/><br>
	<span class="smallestfont">Enter Message here, keep it 140 chars or less</span><br>
	<textarea name="attendeemessage" id="attendeemessage"  rows="2" cols="43" ><%=attendeemessage%></textarea><br>
	<input type="button" name="button" value="Submit" onclick="insertattendeeinfo(<%=groupid %>);" />
	<input type="button" name="cancel" value="Cancel" onclick='javascript:hideattendeelogo();' />
	</td>
	<td></td>
	</tr>
<tr>
	<td  align="left" class='evenbase' id='eventattendeepref1'>
		<a HREF='#' onClick='configureEventView("eventattendeepref1","/portal/eventmanage/updateAttendeePref.jsp?GROUPID=<%=groupid%>&purpose=attendeePage&prefval=<%=attendeepagepref%>&type=attendeepage&mgrtokenid=<%=mgrtokenid%>","<%=attendeepagepref%>","Attendee list preferences updated successfully")' ><%=attendeepageattendeestring%></a>
	</td>
</tr>
<%--<tr>
	<td  align="left" class='evenbase' id='attendeegooglemap'>
		<a HREF='#' onClick='configureEventView("attendeegooglemap","/portal/createevent/updateGmapPref.jsp?purpose=attendeePage&GROUPID=<%=groupid%>&prefval=<%=googlemapshow1%>&type=attendeepage&mgrtokenid=<%=mgrtokenid%>","<%=googlemapshow1%>","Google map preference updated successfully")' ><%=googlemapstring1%></a>
	</td>
</tr>--%>

	<tr><td  align="left" >
	<table align='center' cellpadding='0' cellspacing='0' width='100%'>
	
	<%
	if(ispowered&&accounttype!=null){
	%>
	<tr><td class="colheader" align='left'>Registration Confirmation Email</td>
	<td class='colheader'>
	<a href='/portal/mytasks/customizeemailtemplate.jsp?type=event&GROUPID=<%=request.getParameter("GROUPID")%>&mgrtokenid=<%=mgrtokenid%>'    > Edit</a>
	</td>
	</tr>
	<%}%>
	</table></td></tr>
	<%--<tr>
	<td  align="left" class='evenbase' id='emailreceiveoptions'>
	<span style="cursor: pointer; text-decoration: underline" id="emailreceiveopt" onClick='emailreceiveoptions()' >Email Receive Options</span>
	</td>
	</tr> --%>
	<tr>
	<td class="evenbase" ><span id="emailreceiveoptionnames" style="display:none">
	<table width="100%">
	<tr><td >Send Email to Attendee</td><td>
	<input type="radio" onclick="mailto('Yes','attendee','<%=groupid%>');" name="attendeemailradio" <%=sendmailtoattendeecheck ? "checked='checked'" : ""%>/>Yes
	<input type="radio" onclick="mailto('No','attendee','<%=groupid%>');" name="attendeemailradio" <%=!sendmailtoattendeecheck ? "checked='checked'" : ""%>/>No
	</td></tr>
	<tr><td>Send Email to Manager</td><td>
	<input type="radio" onclick="mailto('Yes','manager','<%=groupid%>');" name="sendmailtomanagerradio" <%=sendmailtomanagercheck ? "checked='checked'" : ""%>/>Yes
	<input type="radio" onclick="mailto('No','manager','<%=groupid%>');" name="sendmailtomanagerradio" <%=!sendmailtomanagercheck ? "checked='checked'" : ""%>/>No
	</td></tr>	
	<tr><td colspan="2" align="center">
	<input type="button" name="cancel" value="Close" onclick='javascript:hideemailreceive();' />
	</td></tr>
	</table></span>
	</td>
	</tr>


<%

boolean isrsvpd=(EventTicketDB.getEventConfig(groupid, "event.rsvp.enabled")!=null);

if(isrsvpd&&accounttype!=null){

%>

<tr><td  align="left" >
<table align='center' cellpadding='0' cellspacing='0' width='100%'>
<tr><td class="colheader" align='left'>RSVP Confirmation Email</td>

<td class='colheader'><a href='/portal/mytasks/rsvpemailtemplate.jsp?type=event&GROUPID=<%=request.getParameter("GROUPID")%>&mgrtokenid=<%=mgrtokenid%>'    > Edit</a>
</td></tr></table></td></tr>
	
<%}%>



</table>