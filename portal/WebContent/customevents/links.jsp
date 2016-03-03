<%@ page import="java.util.*,java.sql.*" %>
<%@ page import="com.eventbee.event.EventsContent,com.eventbee.general.*" %>
<%@ page import="com.eventbee.authentication.*"%>
<%@ page import="com.eventbee.useraccount.*" %>
<%@ page import="com.eventbee.context.ContextConstants" %>
<%@ page import="com.eventbee.creditcard.PaymentTypes"%>
<%@ page import="org.eventbee.sitemap.util.Presentation" %>
<%@ page import="java.text.*"%>
<%@ page import="com.customattributes.*"%>
<%@ page import="com.eventbee.editevent.EditEventDB,com.eventbee.event.*"%>


<%!
public HashMap getDetails(String evtid){
String evtdate="select city,eventname,description,to_char(start_date,'yyyy') as start_yy,to_char(start_date,'mm') as start_mm,  "
              +" to_char(start_date,'dd') as start_dd, "
	          +" to_char(to_timestamp(COALESCE(starttime,'00'),'HH:MI'),'HH24') "
              +" as start_hh,"+" to_char(to_timestamp(COALESCE(starttime,'00'),'HH:MI'),'MI') "
              +" as start_mi,"
              +" to_char(end_date,'yyyy') as end_yy, "
              +" to_char(end_date,'mm') as end_mm, "
              +" to_char(end_date,'dd') as end_dd, "
              +" to_char(to_timestamp(COALESCE(endtime,'00'),'HH:MI'),'HH24') "
              +" as end_hh,"
              +" to_char(to_timestamp(COALESCE(endtime,'00'),'HH:MI'),'MI') "
              +" as end_mi "
              +" from eventinfo where eventid=? ";
      

DBManager dbmanager = new DBManager();
HashMap hm=new HashMap();
StatusObj statobj=dbmanager.executeSelectQuery(evtdate,new String []{evtid});
if(statobj.getStatus())
{

for(int i=0;i<statobj.getCount();i++)
                {
		hm.put("/startYear",dbmanager.getValue(i,"start_yy",""));
		hm.put("/startMonth",dbmanager.getValue(i,"start_mm",""));
		hm.put("/startDay",dbmanager.getValue(i,"start_dd",""));
		hm.put("/startYear",dbmanager.getValue(i,"start_yy",""));
		hm.put("/startHour",dbmanager.getValue(i,"start_hh",""));
		hm.put("/startMinute",dbmanager.getValue(i,"start_mi",""));
		hm.put("/endYear",dbmanager.getValue(i,"end_yy",""));
		hm.put("/endMonth",dbmanager.getValue(i,"end_mm",""));
		hm.put("/endDay",dbmanager.getValue(i,"end_dd",""));
		hm.put("/endHour",dbmanager.getValue(i,"end_hh",""));
		hm.put("/endMinute",dbmanager.getValue(i,"end_mi",""));
		hm.put("/location",dbmanager.getValue(i,"city",""));
		hm.put("/eventname",dbmanager.getValue(i,"eventname",""));
		hm.put("/description",dbmanager.getValue(i,"description",""));

                        }
                }
         return hm;
}
%>

<%
 SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyyMMdd'T'HHmm'00'");
SimpleDateFormat DATE_FORMATT = new SimpleDateFormat("HHmm");
String eventid=(String)request.getAttribute("GROUPID");

HashMap hm=getDetails(eventid);
String location="";
String eventname="";
String description="";
String sdate="";
String edate="";

String durationstr="";
String textdesc=DbUtil.getVal("select description  from eventinfo where descriptiontype='text' and eventid=?",new String[]{eventid});
if(textdesc!=null)
	textdesc=textdesc;
	else
	textdesc="";
if(hm!=null){

String sd=(String)hm.get("/startDay");
String ed=(String)hm.get("/endDay");
String sm=(String)hm.get("/startMonth");
String em=(String)hm.get("/endMonth");
String eh=(String)hm.get("/endHour");
String sh=(String)hm.get("/startHour");
String ey=(String)hm.get("/endYear");
String sy=(String)hm.get("/startYear");
String emin=(String)hm.get("/endMinute");
String smin=(String)hm.get("/startMinute");
location=(String)hm.get("/location");
location=java.net.URLEncoder.encode(location);
eventname=(String)hm.get("/eventname");
eventname=java.net.URLEncoder.encode(eventname);
description=(String)hm.get("/description");

Calendar calendar = new GregorianCalendar(Integer.parseInt(sy),
                                        Integer.parseInt(sm)-1,
                                        Integer.parseInt(sd),
                                        Integer.parseInt(sh),
                                        Integer.parseInt(smin));

Calendar calendar1 = new GregorianCalendar(Integer.parseInt(ey),
                                        Integer.parseInt(em)-1,
                                        Integer.parseInt(ed),
                                        Integer.parseInt(eh),
                                        Integer.parseInt(emin));

sdate=DATE_FORMAT.format(calendar.getTime());
edate=DATE_FORMAT.format(calendar1.getTime());
long differenceInMillis = calendar1.getTimeInMillis() - calendar.getTimeInMillis();
long differenceInDays = differenceInMillis /(24*60*60*1000);
long diffHours = differenceInMillis/(60*60*1000);
long diffMins = differenceInMillis/(60*1000);
diffMins=diffMins-diffHours*60;
String hoursstr=""+diffHours;
if(hoursstr.length()==1)hoursstr="0"+hoursstr;
String minsstr=""+diffMins;
if(minsstr.length()==1) minsstr="0"+minsstr;
if(hoursstr.length()>2) hoursstr="99";
 durationstr=hoursstr+minsstr;


}


String action1="",fromuserid="",appname="",role="",unitid="";
Authenticate authData=AuthUtil.getAuthData(pageContext);
if(authData!=null){
 role=authData.getRoleName();
 unitid=authData.getUnitID();
 fromuserid=authData.getUserID();
 
}else{
	String entryid=(String)session.getAttribute("entryunitid");
	if(entryid!=null){
		if(!(entryid.equals(unitid))){
				//session.setAttribute("entryunitid",unitid);
		}
	}else{
		session.setAttribute("entryunitid",unitid);
	}
}
appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";
HashMap shm=new HashMap();
action1=appname+"/auth/listauth.jsp";
%>
<%
if(request.getParameter("frompagebuilder") !=null)
out.println(PageUtil.startContent(null,request.getParameter("border"),request.getParameter("width"),true) );

%>
<script>
function checkInvitationForm()
	{
				
		if (!document.invitationForm.fromname.value) {
		    
			alert('Please enter your name.');
			return false;
		}
		
			
		if (!document.invitationForm.fromemail.value) {
			
			alert('Please enter your email address.');
			return false;
		}
		
			
		if (!document.invitationForm.toemails.value) {
		    alert('Please enter a valid email address in the To: field.');
			return false;
		}
				
			
		if (!document.invitationForm.subject.value) {
			alert('Please enter a subject for your message.');
			return false;
		}
		
			
		if (!document.invitationForm.personalmessage.value) {
			alert('Please enter your message.');
			return false;
		}
		if (!/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(document.invitationForm.fromemail.value)){
			alert('Your email address is not valid.');
			return false;
		}
		

		  var toemail=document.invitationForm.toemails.value;
		
			var tokens = toemail.tokenize(",", " ", true);
				

		for(var i=0; i<tokens.length; i++){
		   //alert(tokens[i]);
		  
			if (!/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(tokens[i])){
			  
				alert(tokens[i] + ' is not a valid email address.');
				return false;
			}
		}
		//return true;
		
		document.invitationForm.sendmsg.value="Sending...";
		  
		advAJAX.submit(document.getElementById("invitationForm"), {
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
		});
		
	}


function checkAttendeeForm()
	{
			
		if (!document.AttendeeForm.from_email.value) {

			alert('Please enter your email address.');
			return false;
		}
		if (!document.AttendeeForm.from_name.value) {
		    
			alert('Please enter your name.');
			return false;
		}
		if (!document.AttendeeForm.subject.value) {
			alert('Please enter a subject for your message.');
			return false;
		}
		if (!document.AttendeeForm.note.value) {
			alert('Please enter your note.');
			return false;
		}
		if (!/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(document.AttendeeForm.from_email.value)){
			alert('Your email address is not valid.');
			return false;
		}
				
		document.AttendeeForm.sendmgr.value="Sending...";
		  
		advAJAX.submit(document.getElementById("AttendeeForm"), {
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
		});
		
	}





function Show(div)
	{
	
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
</script>

<%
String discountcode=request.getParameter("code");

		
HashMap evtinfo=(HashMap)request.getAttribute("EVENT_INFORMATION");
HashMap confighm=(HashMap)request.getAttribute("EVENT_CONFIG_INFORMATION");
String groupid=(String)request.getAttribute("GROUPID");
String particpant=request.getParameter("participant");
String particpantid=Presentation.GetRequestParam(request,  new String []{"pid","partnerid", "participantid","participant"});
String friendid=Presentation.GetRequestParam(request,  new String []{"fid","friendid"});
String salelimit=(String)request.getAttribute("SALESLIMIT");
String totalsales=(String)request.getAttribute("TOTALSALES");
String message=EbeeConstantsF.get("groupticket.saleslimit.exceed","The Participant through whom you registering has crossed his permitted limit");
String registerlink="";
String rsvplink="";
String rsvpbutton="";
String attendeelink=null;
String registerform="";
String creditcardlogos="";
if (totalsales==null)
totalsales="0";
String registrationlink="/event/register?eventid="+groupid+"&isnew=yes"+(particpantid!=null?"&participant="+particpantid:"")+(friendid!=null?"&friendid="+friendid:"")+(discountcode!=null?"&code="+discountcode:"");

String emailfriendButton="<input type='button' name='button1' value='Email this to a Friend' onclick=javascript:popupwindow('/portal/emailprocess/emailprocess.jsp?id="+groupid+"&purpose=INVITE_FRIEND_TO_EVENT','Email','800','500') />";

String eventprintableversionButton="<input type='button' name='button1' value='Printable version' onclick=javascript:popupwindow('/portal/printdetails/eventinfo.jsp?groupid="+groupid+"','Email','800','500') />";

String addCalendarButton="<input type='button' name='button1' value='Add this to my calendar' onclick=javascript:popupwindow('"+EbeeConstantsF.get("vcal.webpath","/jboss32/server/default/deploy/home.war/vcal")+"/vcal_event_"+groupid+".ics','vCal','400','400') />";
//String emailfriendLink="<a href=javascript:popupwindow('/portal/emailprocess/emailprocess.jsp?id="+groupid+"&purpose=INVITE_FRIEND_TO_EVENT','Email','800','500') >Email this to a friend</a>";


String name="";String email="";
String phone="";
//String groupid=request.getParameter("GROUPID");

String subject=DbUtil.getVal("select eventname from eventinfo where eventid=?", new String[]{groupid});
if(fromuserid!=null&&fromuserid!="")
{
//name =DbUtil.getVal("select getMemberName(user_id||'') as name from user_profile where user_id=?",new String[]{fromuserid});
email=DbUtil.getVal("select email from user_profile where user_id=?",new String[]{fromuserid});
//phone=DbUtil.getVal("select phone from user_profile where user_id=?",new String[]{fromuserid});
}
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","http://www.desihub.com");
HashMap userhm=(HashMap)request.getAttribute("userhm");
String loginname=null;


String mgrid=DbUtil.getVal("select mgr_id  from eventinfo where eventid=?",new String[]{groupid});
String company=DbUtil.getVal("select company from user_profile where user_id=?",new String[]{mgrid});



String hostedby="";
if(company!=null&&!"".equals(company))
hostedby=company;
else
hostedby=(String)request.getAttribute("USERFULLNAME");


if(userhm!=null)
loginname=(String)userhm.get("login_name");

HashMap paytypes=PaymentTypes.getPaymentTypesStatus(groupid,"Event");

String listurl=ShortUrlPattern.get(loginname)+"/event?eventid="+groupid;
String msg="Hi,\n\n"+"I thought you might be interested in - "+subject+"\n"+"Here is the listing URL: "+listurl+"\n\n"+"Thanks";

String contactMgrLink="<a  href=javascript:Show('contactmgr')>Hosted by "+hostedby+"</a>";
      contactMgrLink+=" <div id='contactmgr' style='display: none; margin: 10 5 10 5;'> " ;
      contactMgrLink+=" <form name='AttendeeForm'  id='AttendeeForm' action='/portal/emailprocess/emailtoevtmgr.jsp?UNITID=13579&id="+groupid+"&purpose=CONTACT_EVENT_MANAGER'  method='post' >" ;
      contactMgrLink+=" Your Email ID* :<br> " ;
      contactMgrLink+=" <input type='text' name='from_email' value=''  style='width: 200px;'><br><br>" ;
      contactMgrLink+=" Your Name* :  <br>" ;
      contactMgrLink+=" <input type='text' name='from_name' value=''  style='width: 200px;'><br><br> " ;
      contactMgrLink+=" Subject :<br> " ;
      contactMgrLink+=" <input type='text' name='subject' value='Re: "+subject+"' style='width: 200px;'><br><br> " ;
      contactMgrLink+=" Message :<br> " ;
      contactMgrLink+=" <textarea name='note' style='width: 210px; height: 75px;'></textarea><br><br> " ;
      contactMgrLink+=" <p align='center'> " ;
      //contactMgrLink+=" <input type='button' name='sendmgr' value='Send'  onClick=' return checkInvitationForm(\"AttendeeForm\")' /> " ;
      
contactMgrLink+=" <div id='captchamsgmgr' style='display: none; color:red' >Enter Correct Code</div> " ;

contactMgrLink+="Enter the code as shown below:<div style='padding:5px;' valign='top' width='100%'><input type='text'   name='captchamgr'  value=''   valign='top'/>";
contactMgrLink+="  <img  id='captchaidmgr'  alt='Captcha'  /></div><br><br>";
contactMgrLink+="<input type='hidden' name='formnamemgr' value='AttendeeForm'/>";

      contactMgrLink+=" <input type='button' name='sendmgr' value='Send'  onClick=' return checkAttendeeForm()' /> " ;
      contactMgrLink+=" <input type='button' value='Cancel' onclick=javascript:Cancel('contactmgr'); />" ;
      contactMgrLink+=" </p>" ;
      contactMgrLink+=" </form> </div>";
      contactMgrLink+=" <div id='urmessage'></div>";
      

String emailfriendLink="<a  href=javascript:Show('Invitation')>Email this to a friend</a>";
emailfriendLink+=" <div id='Invitation' style='display: none; margin: 10 5 10 5;'> " ;
emailfriendLink+=" <form name='invitationForm'  id='invitationForm' action='/portal/emailprocess/emailsend.jsp?UNITID=13579&id="+groupid+"&purpose=INVITE_FRIEND_TO_EVENT'  method='post' >" ;
emailfriendLink+="<input type='hidden' name='url' value='"+listurl+"' />";
emailfriendLink+=" To* :<br> ";
emailfriendLink+=" <textarea id='toheader' name='toemails' style='width: 210px; height: 70px;'></textarea><br>(separate emails with commas) " ;
emailfriendLink+=" <br><br> " ;
emailfriendLink+=" Your Email ID* :<br> " ;
emailfriendLink+=" <input type='text' name='fromemail' value='"+email+"'  style='width: 200px;'><br><br>" ;
emailfriendLink+=" Your Name* :  <br>" ;
emailfriendLink+=" <input type='text' name='fromname' value='"+name+"'  style='width: 200px;'><br><br> " ;
emailfriendLink+=" Subject :<br> " ;
emailfriendLink+=" <input type='text' name='subject' value='Fw: "+subject+"' style='width: 200px;'><br><br> " ;
emailfriendLink+=" Message :<br> " ;
emailfriendLink+=" <textarea name='personalmessage' style='width: 210px; height: 75px;'>"+msg+"</textarea><br><br> " ;
emailfriendLink+=" <p align='center'> " ;
// emailfriendLink+=" <input type='button' name='sendmsg' value='Send'  onClick=' return checkInvitationForm(\"invitationForm\")' /> " ;
emailfriendLink+=" <div id='captchamsg' style='display: none; color:red' >Enter Correct Code</div> " ;
emailfriendLink+="Enter the code as shown below:<div style='padding:5px;' valign='top' width='100%'><input type='text'   name='captcha'  value=''   valign='top'/>";
emailfriendLink+="  <img  id='captchaid'  alt='Captcha'  /></div><br><br>";
emailfriendLink+="<input type='hidden' name='formname' value='invitationForm'/>";
emailfriendLink+=" <input type='button' name='sendmsg' value='Send'  onClick=' return checkInvitationForm()' /> " ;
emailfriendLink+=" <input type='button' value='Cancel' onclick=javascript:Cancel('Invitation'); />" ;
emailfriendLink+=" </p>" ;
emailfriendLink+=" </form> </div>";
emailfriendLink+=" <div id='message'></div>";

   	  
   	  
String  addCalendarLink="<a  href=javascript:Show('calendarlinks')>Add to my calendar</a>";
addCalendarLink+=" <div id='calendarlinks' style='display: none; margin: 10 5 10 5;'> " ;
addCalendarLink+=" <a href=javascript:popupwindow('"+EbeeConstantsF.get("vcal.webpath","/jboss32/server/default/deploy/home.war/vcal")+"/vcal_event_"+groupid+".ics','VCal','400','400') ><img src='/home/images/ical.png' alt='iCal'  border='0' />&nbsp;iCal</a>";
addCalendarLink+=" <br> " ;
addCalendarLink+=" <a href='http://www.google.com/calendar/event?action=TEMPLATE&text="+eventname+"&dates="+sdate+"/"+edate+"&sprop=website:http://www.eventbee.com&details="+textdesc+"&location="+location+"&trp=true' target='_blank'><img src='/home/images/google.png' alt='Google'  border='0' />&nbsp;Google</a>";
// addCalendarLink+=" <a href='javascript:submitForm();'><img src='/home/images/google.png' alt='Google'  border='0' />&nbsp;Google</a>"; 
addCalendarLink+=" <br> " ;
addCalendarLink+=" <a href='http://calendar.yahoo.com/?v=60&DUR="+durationstr+"&TITLE="+eventname+"&ST="+sdate+"&ET="+edate+"&in_loc="+location+"&DESC="+textdesc+"' target='_blank'><img src='/home/images/yahoo.png' alt='Yahoo'  border='0' />&nbsp;Yahoo!</a>";       
addCalendarLink+=" </div>";
/* addCalendarLink+="<script type=\"text/javascript\"> \n"
+"   function submitForm(){ \n"
+"   document.myform.submit(); \n"
+"   } \n"
+"   </script> ";
addCalendarLink+=" <form  name='myform' method='post' target='_blank' action='http://www.google.com/calendar/event'>";
addCalendarLink+=" <input type='hidden' name='action' value='TEMPLATE' />";
addCalendarLink+=" <input type='hidden' name='text' value='"+eventname+"' />";
addCalendarLink+=" <input type='hidden' name='dates' value='"+sdate+"/"+edate+"' />";
addCalendarLink+=" <input type='hidden' name='sprop' value='website:http://www.eventbee.com' />";
addCalendarLink+=" <input type='hidden' name='details' value='"+textdesc+"' />";
addCalendarLink+=" <input type='hidden' name='location' value='"+location+"' />";
addCalendarLink+=" <input type='hidden' name='trp' value='true' />";
addCalendarLink+=" </form>";
*/

String addBlogLink="<a href=javascript:popupwindow('/portal/printdetails/bloginfo.jsp?groupid="+groupid+"&participant="+request.getParameter("participant")+"','Email','600','400') >Add to my blog</a>";

boolean registrationAllowed=("Yes".equalsIgnoreCase(GenUtil.getHMvalue(confighm,"event.poweredbyEB","no")));
boolean isrsvpd=("Yes".equalsIgnoreCase(GenUtil.getHMvalue(confighm,"event.rsvp.enabled","no")));

if(registrationAllowed){
	if (particpantid!=null)
	registerform+="<form name='register' action='/event/register?eid="+groupid+"' method='post' onSubmit=\"return validateAgent('"+salelimit+"','"+totalsales+"','"+message+"')\"/>";
	else
	registerform+="<form name='register' action='/event/register?eid="+groupid+"' method='post' />";

	registerform+="<input type='hidden' name='GROUPID' value='"+groupid+"' />";
	registerform+="<input type='hidden' name='eventid' value='"+groupid+"' />";
	if("FB".equals(request.getParameter("context"))){
	registerform+="<input type='hidden' name='context' value='FB' />";
	}
	registerform+="<input type='hidden' name='participant' value='"+particpantid+"'/>";
	registerform+="<input type='hidden' name='friendid' value='"+friendid+"'/>";
	registerform+="<input type='hidden' name='code' value='"+discountcode+"'/>";

	registerform+="<input type='hidden' name='newreq' value='yes'/>";
	registerform+="<input type='submit' name='submit' value='"+GenUtil.getHMvalue(confighm,"event.cnr","Register")+"'/>";

	registerform+="</form>";
}



if(registrationAllowed){
registerlink+="<a href='"+registrationlink+"'>"+GenUtil.getHMvalue(confighm,"event.cnr","Register")+"</a>";






creditcardlogos+="<a href='"+registrationlink+"'><img src='/home/images/eventbeecc.gif'  border='0'/></a>";


	
	
	
	attendeelink="<a href='/guesttasks/viewattendeelist.jsp?GROUPID="+groupid+"'>Registered Attendee List</a>";
}else{
	String rsvpevent=GenUtil.getHMvalue(confighm, "event.rsvp.enabled",null);
	//isrsvpd=(GenUtil.getHMvalue(confighm, "event.rsvp.enabled",null)!=null);
	isrsvpd=(rsvpevent!=null&&!"".equals(rsvpevent));
		if(isrsvpd){
			rsvplink="<a href='/portal/guesttasks/memberlogin.jsp?GROUPID="+groupid+"'/>RSVP</a>";
			rsvpbutton="<form action='/portal/guesttasks/memberlogin.jsp' method='post'>";
			rsvpbutton+="<input type='hidden' name='GROUPID' value='"+groupid+"' />";
			if("FB".equals(request.getParameter("context"))){
				rsvpbutton+="<input type='hidden' name='context' value='FB' />";
			}
			rsvpbutton+="<input type='submit' name='submit' value='RSVP'/>";
			rsvpbutton+="</form>";
		}
		attendeelink="<a href='/sms/viewrsvpattendeelist.jsp?GROUPID="+groupid+"'>RSVP Attendee List</a>";

}

String evturl=DbUtil.getVal("select url from event_custom_urls where eventid=?",new String[]{groupid});
if(evturl==null)
evturl=listurl;
String EventURL="<a href=javascript:Show('eventurl') >Event URL</a>";
EventURL+="<div id='eventurl' style='display: none; align='right' width='200 'margin: 10 5 10 5;>";
EventURL+="<textarea  cols='27' rows='2' onClick='this.select()'>"+evturl+"</textarea></div>";



Vector attendeelist=new Vector();
Map attendeelistmap=null;
HashMap countmap=new HashMap();
if(!("Yes".equalsIgnoreCase(GenUtil.getHMvalue(confighm,"eventpage.attendee.show","no")))){
attendeelink=null;
}else{
if(isrsvpd){
attendeelist=EventsContent.getRSVPList(groupid,countmap);
if(attendeelist!=null&&attendeelist.size()>0){
	attendeelistmap=new HashMap();
	Vector v1= (Vector)attendeelist.elementAt(0);
	if(v1.size()>0) {
	attendeelistmap.put("yesattending",v1);
	attendeelistmap.put("yesattendingcount",countmap.get("yes"));
	}
	 v1= (Vector)attendeelist.elementAt(1);
	if(v1.size()>0){ 
	attendeelistmap.put("notsureattending",v1);
	attendeelistmap.put("notsureattendingcount",countmap.get("notsure"));
	}
	 v1= (Vector)attendeelist.elementAt(2);
	if(v1.size()>0){ 
	attendeelistmap.put("notattending",v1);
	attendeelistmap.put("notattendingcount",countmap.get("no"));
	}
	if(attendeelistmap.size()==0)attendeelistmap=null;
}
}else if(registrationAllowed){
attendeelist=EventsContent.getAttendeeList(groupid);
if(attendeelist!=null&&attendeelist.size()>0){
attendeelistmap=new HashMap();
attendeelistmap.put("registeredattendees",attendeelist);
}
}
}
  request.setAttribute("RSVPLINK",rsvplink);
  request.setAttribute("RSVPBUTTON",rsvpbutton);
  request.setAttribute("REGISTRSATIONALLOWED",registrationAllowed+"");
	request.setAttribute("RSVPALLOWED",isrsvpd+"");
  request.setAttribute("EMAILTOFRIENDBUTTON",emailfriendButton);
	request.setAttribute("EVENTPRINTABLEVERSIONBUTTON",eventprintableversionButton);
	request.setAttribute("ADDCALENDARBUTTON",addCalendarButton);
	request.setAttribute("EMAILTOFRIENDLINK",emailfriendLink);
	request.setAttribute("ADDCALENDARLINK",addCalendarLink);
	request.setAttribute("ADDBLOGLINK",addBlogLink);
	request.setAttribute("VIEWATTENDEELIST",attendeelink);
	request.setAttribute("REGISTRATIONLINK",registerlink);
	request.setAttribute("REGISTRATIONFORM",registerform);
	request.setAttribute("ATTENDEELIST",attendeelistmap);
	request.setAttribute("CONTACTMGRLINK",contactMgrLink);
	request.setAttribute("CREDITCARDLOGOS",creditcardlogos);
	
	request.setAttribute("EVENTURL",EventURL);
	
%>
