<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.event.DateTime"%>
<%@ page import="com.eventbee.event.*"%>
<%@ page import="com.eventbee.general.GenUtil"%>
<%@ page import="com.eventbee.general.formatting.*"%>
<%@ page import="com.eventbee.general.validations.DateValidation"%>
<%@ page import="com.eventbee.general.*,com.eventbee.context.ContextConstants,com.eventbee.authentication.*" %>
<%@ include file="/createevent/EventUniqueId.jsp" %>

<link rel="stylesheet" type="text/css" href="/home/calendar.css" />


<%!
	
static String[] mm=new String[]{"00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23",
				"25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48",
				"49","50","51","52","53","54","55","56","57","58","59"};

String getSupportedType(String useragent){
	String type="text";
	String user = useragent.toLowerCase();
	if(user.indexOf("msie") != -1||user.indexOf("netscape6") != -1||user.indexOf("firefox") != -1)
		type="wysiwyg";
	return type;
}
String getMinuteHtml(String toselect,String nameofsel, String firstdisp, String firstval){
	return WriteSelectHTML.getSelectHtml(mm, mm, nameofsel,
		toselect, firstdisp, firstval);
}
private String formatMinute( int minute) {	
	String timeStr;
	
	if( minute < 10) {
	    timeStr= "0" + minute;
	} else {
	    timeStr= "" + minute;
	}

	return timeStr;
 }
    
private String formatHour( int hour) {	
   	String timeStr;
   	
   	if( hour == 0) {
   	    timeStr= "12";
   	} else {
   	    timeStr= "" + hour;
   	}
   
   	return timeStr;
}

%>

<%
java.util.Date date=new java.util.Date();

%>
<script type="text/javascript" language="JavaScript" src="/home/js/ajax.js">
        function dummy1() { }
</script>

<script>
var selectedcat="";
var partnerid="";
var listpurpose="";
function chekselectevt(){
var selectedevt=document.getElementById("evtname").value;
if(selectedevt==' '){
        
document.getElementById("selecteventerror").innerHTML='No Event is selected';
return false;
}
return true;
}

var totalcost=0;
var count=0;

function getSelectedCat(){
selectedcat=document.getElementById("category").value;
if(document.getElementById("listingpartnerid"))
	partnerid=document.getElementById("listingpartnerid").value;
if(document.getElementById("listpurpose"))
	listpurpose=document.getElementById("listpurpose").value;
getPartnersBlock();
}


</script>
<%
String platform = request.getParameter("platform");

String URLBase="mytasks";
if(session.getAttribute("From")!=null)
session.removeAttribute("From");

HashMap pm=(HashMap)session.getAttribute("partner_selected_attribs");
String totamt=(String)session.getAttribute("PARTNER_TOTAL");

        if((HashMap)session.getAttribute("UPDATED_COMM_PRICE")!=null)
        session.removeAttribute("UPDATED_COMM_PRICE");
        

session.setAttribute("platform",platform);

String  purpose=request.getParameter("purpose");

String partner_total=request.getParameter("partner_total");

//EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"addevent.jsp","Authdata is not null. Authid: "+(AuthUtil.getAuthData(pageContext)).getUserID(),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
HashMap hm=null;

//String tstring=EbeeConstantsF.get("events.tags.exceeded","Tag contains more than two words, maximum number of words allowed in Tag is two.");	
String useragent = request.getHeader("User-Agent");
String linkpath ="http://"+EbeeConstantsF.get("serveraddress","www.beeport.com")+"/home/links";
String applicname=EbeeConstantsF.get("application.name","Eventbee");
String eventbeeURL=EbeeConstantsF.get("eventbee.url","http://www.eventbee.com/home/index.jsp");
String contactemail="";
String [] totalweeks = {"1st","2nd","3rd","4rth"};

Authenticate authData=AuthUtil.getAuthData(pageContext);

String authid=null,role=null,unitid=null,oid=null;
if (authData!=null){
	authid=authData.getUserID();
	role=authData.getRoleName();
	unitid=authData.getUnitID();
	contactemail=authData.getEmail();
}
else{
if(oid!=null){
session.setAttribute("platform","ning");
authid=DbUtil.getVal("select ebeeid from ebee_ning_link where nid=?",new String[]{oid});
if(authid!=null){
AuthDB adb=new AuthDB();
authData=adb.authenicateUserByID(authid);
if (authData!=null){role=authData.getRoleName();
	unitid=authData.getUnitID();
	contactemail=authData.getEmail();
session.setAttribute("authData",authData);
}
}
}
}



session.setAttribute("ADD_NEW_EVENT","Y");

String ebeecategory[]=EventbeeStrings.getCategoryNames();
String Category[]=new String[(ebeecategory.length)+1];
String[] CategoryVals=new String[(ebeecategory.length)+1];
String[] SubCategoryCodes=EventbeeStrings.getSubCategoryNames();
String beeporturl="http://"+EbeeConstantsF.get("serveraddress","www.beeport.com")+"/";

Category[0]="-- Select Category --";
CategoryVals[0]="";
System.arraycopy(ebeecategory,0,Category,1,ebeecategory.length);
System.arraycopy(ebeecategory,0,CategoryVals,1,ebeecategory.length);
String[] Type={"Camp","Conference","Fund Raiser", "Meeting","Party","Trade Show","Training","Other"};
String[] TypeVals={"Camp","Conference","Fund Raiser", "Meeting","Party","Trade Show","Training","Other"};

String entryunitid=(String)session.getAttribute("entryunitid");

Vector v=null;

Calendar curr_date=Calendar.getInstance();
curr_date.add(Calendar.DATE, 1);
String ampm="AM";
int year = curr_date.get(Calendar.YEAR);
int selstyear=year;
int selendyear=year;
try{
	selstyear=Integer.parseInt(GenUtil.getHMvalue(hm,"/startYear","",false));
	selendyear=Integer.parseInt(GenUtil.getHMvalue(hm,"/endYear",""));
}catch(Exception e){
			selstyear=year;
			selendyear=year;
}//try catch
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"addevent.jsp","selstyear----"+selstyear,"selendyear: "+selendyear,null);
String [] str1={};
List l=new ArrayList();
String eventid=request.getParameter("GROUPID");
/* the following block is executed first and redirected to the same page.*/

if("yes".equals(request.getParameter("isnew"))){
        
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"addevent.jsp","first click for this page","sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
	session.setAttribute("MEMBER_EVENT_VECTOR",null);
	session.setAttribute("EVENTIDS_HASH",null);
	
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"addevent.jsp","MEMBER_EVENT_VECTOR"+session.getAttribute("MEMBER_EVENT_VECTOR"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
	EventDB evtdb=new EventDB();
	hm=new HashMap();
	
	EventUniqueId euniueid=new EventUniqueId();
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"addevent.jsp","eventid---------------"+eventid,"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
	eventid=euniueid.getUniqueEid((String)hm.get("eventid"));
	hm.put("eventid",eventid);
	session.setAttribute("eventid",eventid);

	session.setAttribute("FIRST_EVENT_INFO",hm);
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"addevent.jsp","FIRST_EVENT_INFO---------------"+hm,"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
	session.setAttribute(eventid+"_AJAX_EDITPWD",null);
	generate_State_Country(authid,hm,role);
	String hourStr=formatHour(curr_date.get(Calendar.HOUR));
	String minuteStr= formatMinute( curr_date.get(Calendar.MINUTE));
              
	hm.put("desctype",getSupportedType(useragent));
	hm.put("/startMonth",EventbeeStrings.monthvals[curr_date.get(Calendar.MONTH)]);
	hm.put("/endMonth",EventbeeStrings.monthvals[curr_date.get(Calendar.MONTH)]);
	hm.put("/startDay",EventbeeStrings.days[curr_date.get(Calendar.DAY_OF_MONTH)-1]);
	hm.put("/endDay",EventbeeStrings.days[curr_date.get(Calendar.DAY_OF_MONTH)-1]);
	hm.put("/startHour","9");
	hm.put("/endHour","10");
	hm.put("/startMinute",""+minuteStr);
	hm.put("/endMinute",""+minuteStr);
	hm.put("/contactEmail",contactemail);
	//if(curr_date.get(Calendar.AM_PM)==1)
	//ampm="PM";
	hm.put("stampm",ampm);
	hm.put("endampm",ampm);
	session.setAttribute("MEMBER_EVENT_HASH",hm);
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"addevent.jsp","MEMBER_EVENT_HASH---------------"+hm,"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
	
}


else if("AUTOFILL".equals(purpose)){
hm=(HashMap)session.getAttribute("EventDetails");
eventid=(String)hm.get("eventid"); 

session.setAttribute("purpose",purpose);
}





else{ 
  	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"addevent.jsp","eventid from request---------------"+eventid,"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
	v=(Vector)session.getAttribute("MEMBER_EVENT_VECTOR");
	hm=(HashMap)session.getAttribute("MEMBER_EVENT_HASH");
	eventid=(String)hm.get("eventid"); 
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"addevent.jsp","request is not new","",null);
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"addevent.jsp","MEMBER_EVENT_VECTOR=="+v,"",null);
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"addevent.jsp","MEMBER_EVENT_HASH=="+hm,"",null);

}//end if("yes".equals(request.getParameter("isnew")))
	
	
if(hm!=null){
	if(hm.get("selectweeksno") instanceof String []){
		str1=(String [])hm.get("selectweeksno");
	}else{
		String str2=(String)hm.get("selectweeksno");
		str1=new String[1];
		str1[0]=str2;
	}//if hm
}//if  hm!=null

for(int i=0;i<str1.length;i++){
	l.add(str1[i]);
}// for
%>

<script>
var jid='<%=session.getId()%>';

</script>


<script type="text/javascript" language="JavaScript" >
var evtid=<%=eventid%>;

</script>
<script type="text/javascript" language="JavaScript" >
var eventid='<%=eventid%>';
function checklistselection(){
        var user_input='';
        if(document.forms[0].weeklist!=null){
		for (i=0;i<document.forms[0].weeklist.length;i++) {
			if (document.forms[0].weeklist[i].checked) {
				user_input = document.forms[0].weeklist[i].value;
			}
		}
	
		if(!user_input){
			document.getElementById('selerrorlisting').innerHTML='There is an error';
			document.getElementById('selectionerrorlisting').innerHTML='* Please select listing option';
			document.getElementById('selerrorlisting').focus();
			return false;
		}else{  
		       submitpartnerblock();
			
		}
	}else{
		validateData(false);
	}
	
  
}


</script>

<table class="block" cellspacing="0" cellpadding='0' width='100%' onClick="hidePopUp()">

<tr><td class='taskblock'>
		<div>
		<%@ include file="/ningapp/ticketing/eventdata.jsp" %>
		</div>
</td></tr>
<tr><td class='taskblock'>
		<div id="partnerblock">
		</div>
</td></tr>
<tr><td class='taskblock'>
		<div id="powerblock">
		</div>
</td></tr>

<tr>
<td colspan="2" align="center">
<form id='finalform' action='/validate;jsessionid=<%=session.getId()%>'  method='post' >
 <input type="hidden" name='partner_total'   id='partner_total'  value=''/>
<table>
<tr><td>
<div id='calendar' STYLE='position:absolute;visibility:visible;background-color:white;layer-background-color:white;z-index:1000;'></div>
<input type='hidden' name='GROUPID' value='<%=eventid%>'/>
<%

if("ning".equals(platform)){
       session.setAttribute("platform","ning");
        URLBase="ningapp/ticketing";
        
        session.setAttribute(eventid+"_POWER_TYPE","none");

        
}




HashMap nwevtmap=(HashMap)session.getAttribute("NETWORK_EVENTLIST_ATTRIBS");
%>
<input name="submit1" type="button" value="Continue" class="button" 
title="Continue" onClick="validateData(document.frm);"/>

<input type="button" class="button"  name="Back" value="Cancel" onclick='homepagebeelets();'/>
</td></tr>
</table>
</form>
</td>
		</tr>
</table>
<!-- this js function calls getEventPoweringBlock.jsp for displaying radio buttons
with power type options. The data is filled in "powerblock" div -->
<!--
In this method another js method is called showPowerBlock(). 
In thie method based on the power type choosen i.e registration or rsvp corresponding block will be displayed in 'eventPowerBlock'
For powering with online registration three js functions are called getTicketsBlock(); getCustomAttributes();showAttributes();.
getTicketsBlock for displaying all thge tickets. this will call editTickets.jsp and the data is filled in 'ticketsblock'
getCustomAttributes-- customnew.jsp and 'customattributes' is filled for collecting attribute data .
showAttributes-- displayCustomAttributes.jsp for displaying all the attributes
-->


<%
if(nwevtmap!=null){
%>
<script type="text/javascript" language="JavaScript" >getSelectedCat();</script>
<%}

if(totamt!=null||totamt!="0"){
%>
<script type="text/javascript" language="JavaScript" >partnerCost(<%=totamt%>);</script>
<%}%>
