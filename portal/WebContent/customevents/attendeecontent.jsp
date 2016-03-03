<%@ page import="java.util.*,java.sql.*,java.text.*,java.net.*" %>
<%@ page import="com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.eventbee.useraccount.*" %>
<%@ page import="com.eventbee.event.*" %>
<%@ page import="com.eventbee.event.ticketinfo.*" %>
<%@ page import="com.eventbee.editevent.*" %>
<%@ page import="com.eventbee.general.formatting.*"%>
<%@ page import="com.eventbee.customconfig.MemberFeatures" %>
<%@ page import="com.eventbee.contentbeelet.*"%>
<%@ page import="com.eventbee.noticeboard.NoticeboardDB" %>
<%@ page import="com.eventbee.polls.*" %>
<%@ page import="com.eventbee.general.DBQueryObj.*"%>
<%@ page import="com.eventbee.event.EventsContent" %>
<%@ page import="com.eventbee.eventpartner.*" %>

<%!
String VIEW_ATTENDEE_QUERY="select 'Userid' as totype,a.attendeekey,a.attendeeid,a.firstname || ' ' || a.lastname as name,b.login_name as login_name ,"
	+" a.statement,a.comments,'Y' as priattendee,a.authid,cast(a.authid as text) as msgto, "
	+" a.username,a.eventid,a.shareprofile, k.photourl,b.unit_id from authentication b,eventattendee a, user_profile k "
	+" where a.eventid=? and a.authid=b.auth_id and b.user_id=k.user_id "
	+" union "
	+" select 'Transactionid' as totype,a.attendeekey,a.attendeeid ,a.firstname || ' ' || a.lastname as name,'yy' as login_name, "
	+" a.statement,a.comments,a.priattendee,a.authid as authid,a.transactionid as msgto,username,a.eventid,a.shareprofile,'' as photourl, '0' as unit_id "
	+" from eventattendee a where a.authid='0' and a.eventid=? order by attendeeid desc";

String GET_ATTENDEE_PHOTO="select a.attendeepagephoto as photourl,b.caption as caption from"
	+" eventinfo a,member_photos b where a.attendeepagephoto=b.uploadurl and a.eventid=?";


public Vector getAttendeeList(String groupid){
	DBManager dbmanager=new DBManager();
	StatusObj stobj=dbmanager.executeSelectQuery(VIEW_ATTENDEE_QUERY,new String[]{groupid,groupid});
	Vector v=null;
	if(stobj.getStatus()){
		v=new Vector();
		for(int i=0;i<stobj.getCount();i++){
			HashMap hm=new HashMap();
			hm.put("totype",dbmanager.getValue(i,"totype",""));
			hm.put("attendeekey",dbmanager.getValue(i,"attendeekey","") );
			hm.put("attendeeid",dbmanager.getValue(i,"attendeeid","") );
			hm.put("name",dbmanager.getValue(i,"name","") );
			hm.put("login_name",dbmanager.getValue(i,"login_name",""));
			hm.put("comments",dbmanager.getValue(i,"statement","") );
			hm.put("priattendee",dbmanager.getValue(i,"priattendee","") );
			hm.put("authid",dbmanager.getValue(i,"authid","") );
			hm.put("msgto",dbmanager.getValue(i,"msgto",""));
			hm.put("username",dbmanager.getValue(i,"username","") );
			hm.put("eventid",dbmanager.getValue(i,"eventid","") );
			hm.put("shareprofile",dbmanager.getValue(i,"shareprofile","") );
			hm.put("photourl",dbmanager.getValue(i,"photourl",""));
			hm.put("unit_id",dbmanager.getValue(i,"unit_id","") );
			hm.put("comments",dbmanager.getValue(i,"comments","") );
			
			 if("Userid".equals(dbmanager.getValue(i,"totype",""))){
			 	if("Yes".equals(dbmanager.getValue(i,"shareprofile",""))){
					hm.put("name","<a href='"+ShortUrlPattern.get(dbmanager.getValue(i,"login_name",""))+"/network'>"+ dbmanager.getValue(i,"name","")+"</a>");
				}
			}
						
			v.addElement(hm);
		}
	}
	return v;
}

 private String getConfigVal(HashMap confighm, String key, String defaultval){
	String val=(String)confighm.get(key);
	if(val==null)
		return defaultval;
	else
		return val;
    }
Vector getRSVPList(String eventid,HashMap countmap){
	String VIEW_RSVP_QUERY="select getMemberPref(authid||'','pref:myurl','') as  loginname,phone,comments,address,address1,firstname,lastname,email,company,attendeecount,attendingevent   from rsvpattendee where eventid=? ";
	Vector v=new Vector();
	Vector v1=new Vector();
	Vector v2=new Vector();
	Vector v3=new Vector();
	int yes=0;
	int notsure=0;
	int no=0;
	DBManager dbmanager=new DBManager();
	StatusObj statobj=dbmanager.executeSelectQuery(VIEW_RSVP_QUERY,new String []{eventid});
	if(statobj.getStatus()){
		for(int i=0;i<statobj.getCount();i++){
			HashMap hm=new HashMap();
			hm.put("phone",dbmanager.getValue(i,"phone",""));
			hm.put("comments",GenUtil.textToHtml(dbmanager.getValue(i,"comments","")));
			hm.put("address",dbmanager.getValue(i,"address",""));
			hm.put("address1",dbmanager.getValue(i,"address1",""));
			hm.put("firstname",dbmanager.getValue(i,"firstname",""));
			hm.put("lastname",dbmanager.getValue(i,"lastname",""));
			hm.put("email",dbmanager.getValue(i,"email",""));
			hm.put("loginname",dbmanager.getValue(i,"loginname",""));
			if(!"".equals(dbmanager.getValue(i,"loginname","")))
				hm.put("name","<a href='"+ShortUrlPattern.get(dbmanager.getValue(i,"loginname",""))+"/network'>"+dbmanager.getValue(i,"firstname","")+" "+dbmanager.getValue(i,"lastname","")+"</a>");
			else
				hm.put("name",dbmanager.getValue(i,"firstname","")+" "+dbmanager.getValue(i,"lastname",""));
			hm.put("attendeecount",dbmanager.getValue(i,"attendeecount","1"));
			hm.put("attendingevent",dbmanager.getValue(i,"attendingevent","yes"));
			if("yes".equals(dbmanager.getValue(i,"attendingevent","yes"))){
				try{
					yes=yes+Integer.parseInt(dbmanager.getValue(i,"attendeecount","1"));
				}catch(Exception e){yes=yes+1;}
				v1.add(hm);
			}
			else if("notsure".equals(dbmanager.getValue(i,"attendingevent","yes"))){
				try{
					notsure=notsure+Integer.parseInt(dbmanager.getValue(i,"attendeecount","1"));
				}catch(Exception e){notsure=notsure+1;}
				v2.add(hm);
			}else if("no".equals(dbmanager.getValue(i,"attendingevent","yes"))){
				try{
				no=no+Integer.parseInt(dbmanager.getValue(i,"attendeecount","1"));
				}catch(Exception e){no=no+1;}
				v3.add(hm);
			}
						
		}
	}
	countmap.put("yes",yes+"");
	countmap.put("notsure",notsure+"");
	countmap.put("no",no+"");
	v.add(v1);
	v.add(v2);
	v.add(v3);
	return v;
}
%>

<%@ include file="/../plaxo_js.jsp" %>

<script type="text/javascript" language="JavaScript" src="/home/js/messagevalidate.js">
        function dummy1() { }
</script>

<script type="text/javascript" language="JavaScript" src="/home/js/Tokenizer.js">
        function dummy1() { }
</script>

<script type="text/javascript" language="JavaScript" src="/home/js/advajax.js">
        function dummy() { }
</script>

<script>

function getAgentsPage(loginname){
				var id=document.agents.participant.value;
				document.agents.participant.value=document.agents.participant.value;
					if(id!=null&&id!=''){
						document.agents.target="_self";
						document.agents.action="/member/"+loginname+"/event";
						document.agents.submit();
					}
}

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
		  
		    document.getElementById('message').innerHTML=restxt;
		    document.getElementById("Invitation").style.display = 'none'
		   // document.getElementById("uparrow").style.display = 'none'
		   // document.getElementById("sidearrow").style.display = 'block'
		    document.invitationForm.sendmsg.value="Send";
		    document.invitationForm.to_email1.value='';
		    document.invitationForm.from_email.value='';
		    document.invitationForm.from_name.value='';
		 
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
		  
		    document.getElementById('urmessage').innerHTML=restxt;
		   
		    document.getElementById("AttendeeForm").style.display = 'none'
		   
		    document.AttendeeForm.sendmgr.value="Send";
		    document.AttendeeForm.from_email.value='';
		    document.AttendeeForm.from_name.value='';
		 
		    },
		    onError : function(obj) { alert("Error: " + obj.status);}
		});
		
	}


function Show(div)
	{
		var theDiv = document.getElementById(div);
		if (theDiv.style.display == 'none') {
			theDiv.style.display = 'block';
			//document.getElementById("sidearrow").style.display = 'none'
			//document.getElementById("uparrow").style.display = 'block'
			document.getElementById("message").innerHTML='';
			
		} 
		
		
		else
		theDiv.style.display = 'none'
	}

function Cancel(div)
{
var theDiv = document.getElementById(div);
theDiv.style.display = 'none';
document.getElementById("sidearrow").style.display = 'block'
document.getElementById("uparrow").style.display = 'none'
}
</script>
<%
String groupid=request.getParameter("eventid");
if(groupid==null||"".equals(groupid.trim()))
groupid=request.getParameter("GROUPID");
boolean registrationAllowed=false;
String mapstring="";
String gmstring="";
String mstr="";	
String trackPartnerMessage="";
String trackPartnerPhoto="";
String configid="";
String confid="";
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","")+"/";

String gmappref=DbUtil.getVal("select value from config a,eventinfo b where b.eventid=? and a.name=? and a.config_id=b.config_id",new String [] {groupid,"eventpage.map.show"});
String GOOGLEMAP="";
if("Yes".equals(gmappref)){
String lon=DbUtil.getVal("select longitude from eventinfo where eventid=?",new String [] {groupid});
String lat=DbUtil.getVal("select latitude from eventinfo where eventid=?",new String [] {groupid});

if(lon!=null&&lat!=null){
 GOOGLEMAP="<script type=\"text/javascript\"> \n"
      +"   function map(){ \n"
      +"   //<![CDATA[ \n"
      +"   var lat,lon; \n "
      +"   var map = new GMap(document.getElementById(\"map\")); \n"
      +"   map.addControl(new GSmallMapControl());  \n"
      +"   map.centerAndZoom(new GPoint("+lon+","+lat+"), 4); \n"
      +"   var point = new GPoint("+lon+","+lat+"); \n"
      +"   var marker = new GMarker(point); \n"
      +"   map.addOverlay(marker); \n"
      +"   //]]>  \n"
      +"   } \n"
      +"   </script> ";
   }   
   }

String evttype=DbUtil.getVal("select type from eventinfo where eventid=?",new String [] {groupid});
String registerform="";
String eventname="";
String startdate="";
String enddate="";
String description="";
String mgr_email="";
String contact_label="";
String comments="";
String moreinfo="";
String state="";
String country="";
String phone="";
String descriptionlabel="";
String location="";
String address2="";
String address1="";
String address="";
String city="";
String endlabel="";
String startlabel="";
String printableversion="";
String emailtofriend="";
String rsvp_limit="";
String rsvp_count="";
int size=0;
String attendeelink=null;
String creditcardlogos="";
String mgr_events_link="";
String evtmgrname="";
String salelimit= DbUtil.getVal("select saleslimit from group_agent_settings where groupid=?",new String[]{groupid});
boolean ebeecontext=true;
EditEventDB evtDB=new EditEventDB();

HashMap evtinfo=EventDB.getMgrEvtDetails(groupid);
registrationAllowed=("Yes".equalsIgnoreCase(EventTicketDB.getEventConfig(groupid, "event.poweredbyEB")));

HashMap confighm=evtDB.getEventInfo(groupid);
String message=EbeeConstantsF.get("groupticket.saleslimit.exceed","The Participant through whom you registering has crossed his permitted limit");
String mgrid=DbUtil.getVal("select mgr_id from eventinfo where eventid=?",new String[]{groupid});
String userfullname=DbUtil.getVal("select getMemberName(?||'')",new String[]{mgrid});
String partnerid=DbUtil.getVal("select partnerid from group_partner where userid=? and status='Active'",new String[]{mgrid});	
Map attribmap=PartnerDB.getStreamingAttributes(mgrid,partnerid);
configid="select config_id from eventinfo where eventid=?";
confid=DbUtil.getVal(configid, new String[]{groupid});
trackPartnerMessage=DbUtil.getVal("select value from config where name='attendeepage.logo.message' and config_id=?",new String[]{confid});
trackPartnerPhoto=DbUtil.getVal("select value  from config where name='attendeepage.logo.url' and config_id=?",new String[]{confid});
	if(trackPartnerPhoto!=null){
		trackPartnerPhoto="<img src='"+trackPartnerPhoto+"' width='200'/>";
	}	
%>
			
<%@ include file="userstreamer.jsp" %>

<%
HashMap user=(HashMap)request.getAttribute("userhm");
String loginname="";
String name="";
String email="";
String fromuserid="";

loginname=DbUtil.getVal("select login_name from authentication where user_id=?",new String[]{mgrid});
String subject=DbUtil.getVal("select eventname from eventinfo where eventid=?", new String[]{groupid});

String  totalsales="0";
String networklink="<a href='"+ShortUrlPattern.get(loginname)+"/network'>Network Page</a>";
String Bloglink="<a href='"+ShortUrlPattern.get(loginname)+"/blog'>Blog Page</a>";
String photoslink="<a href='"+ShortUrlPattern.get(loginname)+"/photos'>Photos Page</a>";
String communitylink="<a href='"+ShortUrlPattern.get(loginname)+"/community'>Community Page</a>";
String eventslink="<a href='"+ShortUrlPattern.get(loginname)+"/events'>Events Page</a>";

request.setAttribute("NETWORKLINK",networklink);
request.setAttribute("BLOGLINK",Bloglink);
request.setAttribute("PHOTOSLINK",photoslink);
request.setAttribute("COMMUNITYLINK",communitylink);
request.setAttribute("EVENTSLINK",eventslink);
request.setAttribute("TRACKMESSAGE",trackPartnerMessage);
request.setAttribute("TRACKPHOTO",trackPartnerPhoto);


%>

<% /* ######## YAHOO AND GOOGLE ADS FOR EVENTS PAGE 04/04/2007 rajesh #######*/
String content="";
String showAttendee="";
HashMap customcontent_yahooad=null;
customcontent_yahooad=CustomContentDB.getCustomContent("THEME_YAHOO_AD", "13579");
if(customcontent_yahooad!=null){
 content=GenUtil.getHMvalue(customcontent_yahooad,"desc" );
}
if(content==null)content="";
request.setAttribute("YAHOOADS",content);


HashMap customcontent_ad=null;
customcontent_ad=CustomContentDB.getCustomContent("THEME_GOOGLE_AD", "13579");
if(customcontent_ad!=null){
content=GenUtil.getHMvalue(customcontent_ad,"desc" );
}
if(content==null)content="";
request.setAttribute("GEOOGLEADS",content);
/*####### END OF YAHOO AND GOOGLE ADS CONTENT ############*/

%>

<%

String particpantid=request.getParameter("participant");

if(registrationAllowed){
if (particpantid!=null)
registerform+="<form name='register' action='/portal/eventregister/register' method='post' onSubmit=\"return validateAgent('"+salelimit+"','"+totalsales+"','"+message+"')\"/>";
else
registerform+="<form name='register' action='/portal/eventregister/register' method='post' />";

registerform+="<input type='hidden' name='GROUPID' value='"+groupid+"' />";
registerform+="<input type='hidden' name='eventid' value='"+groupid+"' />";
registerform+="<input type='hidden' name='participant' value='"+request.getParameter("participant")+"'/>";
registerform+="<input type='hidden' name='newreq' value='yes'/>";
registerform+="<input type='submit' name='submit' value='"+getConfigVal(confighm,"event.cnr","Register")+"'/>";
registerform+="</form>";

}


if(evtinfo!=null){

	eventname=(String)evtinfo.get("eventname");
	startdate=getConfigVal(confighm,"event.starts.desc",(String)evtinfo.get("startdate")+", "+(String)evtinfo.get("starttime"));
	enddate=getConfigVal(confighm,"event.ends.desc",(String)evtinfo.get("enddate")+", "+(String)evtinfo.get("endtime"));
	mgr_email="<a href=mailto:"+getConfigVal(confighm,"event.contact.email",(String)evtinfo.get("email"))+" >"+getConfigVal(confighm,"event.contact.email",(String)evtinfo.get("email"))+"</a>";
	contact_label=getConfigVal(confighm,"event.contact.label","Manager");
	String desctype=(String)confighm.get("descriptiontype");
	if("text".equalsIgnoreCase(desctype))
		description=GenUtil.textToHtml((String)evtinfo.get("description"),true);
	else
		description=(String)evtinfo.get("description");
	comments=GenUtil.textToHtml((String)evtinfo.get("comments"),true);
	moreinfo=getConfigVal(confighm,"event.moreinfo.label","More Info");
	phone=getConfigVal(confighm, "event.contact.phone", (String)evtinfo.get("phone"));
	descriptionlabel=getConfigVal(confighm,"event.desc.label","Description");
	address=GenUtil.getCSVData(new String[]{(String)evtinfo.get("city"),(String)evtinfo.get("state"), (String)evtinfo.get("country")});

	address2=(String)evtinfo.get("address2");
	address1=(String)evtinfo.get("address1");
	city=(String)evtinfo.get("city");
	state=(String)evtinfo.get("state");
	country=(String)evtinfo.get("country");

	location=getConfigVal(confighm,"event.location.label","Location");
	endlabel=getConfigVal(confighm,"event.ends.label","Ends");
	startlabel=getConfigVal(confighm,"event.starts.label","Starts");
	rsvp_limit="0".equals(GenUtil.getHMvalue(evtinfo,"rsvp_limit","",false))?"None":GenUtil.getHMvalue(evtinfo,"rsvp_limit","",false);
	rsvp_count=GenUtil.getHMvalue(evtinfo,"rsvp_count","",false);
}
mgr_events_link="<a href='"+ShortUrlPattern.get(evtmgrname)+"/events' >View other events by "+userfullname+"</a>";

List addressList=new ArrayList();
if(address1!=null&&(address1.trim()).length()>0)
addressList.add(address1);
if(address2!=null&&(address2.trim()).length()>0)
addressList.add(address2);
if(address!=null&&(address.trim()).length()>0)
addressList.add(address);


if(!GOOGLEMAP.equals("")){

	if(address2.equals("")){
		mstr=address1+"+"+city+"+"+state+"+"+country;
	}
	else{
		mstr=address1+"+"+address2+"+"+city+"+"+state+"+"+country;
	}
	mstr=URLEncoder.encode(mstr);
	gmstring="http://maps.google.com/maps?q="+mstr;
	mapstring="<a href="+gmstring+">Map/Driving directions</a>";
}

String [] adress=(String [])addressList.toArray(new String [0]);

request.setAttribute("EVENTNAME",eventname);
request.setAttribute("STARDATE",startdate);
request.setAttribute("ENDDATE",enddate);
request.setAttribute("MOREINFORMATION",moreinfo);
request.setAttribute("EVENTPHONENUMBER",phone);
request.setAttribute("EVENTCOMMENTS",comments);
request.setAttribute("GOOGLEMAP",GOOGLEMAP);//googlemap
request.setAttribute("mapstring",mapstring);//whole googlemap 

String registerlink="";
String rsvplink="";
String rsvpbutton="";
boolean isrsvpd=false;
String registrationlink="/portal/eventregister/register?eventid="+groupid+"&GROUPID="+groupid+"&isnew=yes"+(request.getParameter("participant")!=null?"&participant="+request.getParameter("participant"):"");

if(registrationAllowed){
registerlink+="<a href='"+registrationlink+"'>"+getConfigVal(confighm,"event.cnr","Register")+"</a>";
attendeelink="<a href='/guesttasks/viewattendeelist.jsp?GROUPID="+groupid+"'>Registered Attendee List</a>";
}else{
isrsvpd=(EventTicketDB.getEventConfig(groupid, "event.rsvp.enabled")!=null);
if(isrsvpd){
rsvplink="<a href='/portal/guesttasks/memberlogin.jsp?GROUPID="+groupid+"'/>RSVP</a>";
rsvpbutton="<form action='/portal/guesttasks/memberlogin.jsp' method='post'>";
rsvpbutton+="<input type='hidden' name='GROUPID' value='"+groupid+"' />";
rsvpbutton+="<input type='submit' name='submit' value='RSVP'/>";
rsvpbutton+="</form>";
}
attendeelink="<a href='/mytasks/viewrsvpattendeelist.jsp?GROUPID="+groupid+"'>RSVP Attendee List</a>";

}
Vector attendeelist=new Vector();
Map attendeelistmap=null;
HashMap countmap=new HashMap();
 
if(isrsvpd){
	attendeelist=getRSVPList(groupid,countmap);
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
}else{ 
	if(registrationAllowed){
		
		String showAttendeeQ="select value from config where config_id=(select config_id from eventinfo where eventid=?) and name='attedeepage.attendee.show'";
		 showAttendee=DbUtil.getVal(showAttendeeQ,new String [] {groupid});

		attendeelist=EventsContent.getAttendeeList(groupid);
		if(attendeelist!=null&&attendeelist.size()>0){
			attendeelistmap=new HashMap();
			attendeelistmap.put("registeredattendees",attendeelist);
		}

	}
}
		
		
request.setAttribute("REGISTRSATIONALLOWED",registrationAllowed+"");
request.setAttribute("RSVPLINK",rsvplink);
request.setAttribute("RSVPCOUNT",rsvp_count);
request.setAttribute("RSVPLIMIT",rsvp_limit);
request.setAttribute("RSVPALLOWED",isrsvpd+"");
request.setAttribute("FULLADDRESS",adress);
request.setAttribute("VIEWATTENDEELIST",attendeelink);
request.setAttribute("RSVPBUTTON",rsvpbutton);
request.setAttribute("MGREVENTSLINK",mgr_events_link);
request.setAttribute("ATTENDEELIST",attendeelistmap);
request.setAttribute("SHOWATTENDEE",showAttendee);
String f2fTagline=null,f2fimage="";
String event_link=null;
String main_event_link=null;
String displayed=null;
Vector agentsinfo=null;
Vector topsellers=null;
Vector agentsettings=null;

String enableparticipant=DbUtil.getVal("select 'yes' from group_agent_settings a,group_agent b where a.settingid=b.settingid and a.groupid=? and b.agentid=? and a.enableparticipant='Yes' and b.customised='Yes'",new String[]{groupid,particpantid});
String isf2fenabled=DbUtil.getVal("select enablenetworkticketing from group_agent_settings where groupid=? ",new String [] {groupid});

if("yes".equalsIgnoreCase(isf2fenabled)&&request.getParameter("participant")==null){
agentsinfo=EventsContent.getAllAgents(groupid);
}

if((particpantid!=null)&&!"yes".equals(enableparticipant)){
	agentsinfo=EventsContent.getAllAgents(groupid);
}	
request.setAttribute("GROUP_AGENTS_INFO",agentsinfo);


StringBuffer selectagents=null;

String setid="";
String saleslimit="";
String groupheader="";
Vector vect=new Vector();
agentsettings=EventsContent.getAgentSettings(vect,groupid);

HashMap hash=new HashMap(); 
for(int i=0;i<agentsettings.size();i++)
hash=(HashMap)agentsettings.elementAt(i);
String showagents=GenUtil.getHMvalue(hash,"showagents","");
saleslimit=GenUtil.getHMvalue(hash,"saleslimit","");
setid=GenUtil.getHMvalue(hash,"settingid",null);
if((particpantid==null)||((particpantid!=null)&&!"yes".equals(enableparticipant))){
	if ("Yes".equalsIgnoreCase(showagents)){
		if(agentsinfo!=null&&agentsinfo.size()>0){
			topsellers=new Vector();
			for(int i=0;i<agentsinfo.size();i++){
			HashMap hm1=(HashMap)agentsinfo.get(i);
			String str1="<a href='"+ShortUrlPattern.get(loginname)+"/event?eventid="+groupid+"&participant="+GenUtil.getHMvalue(hm1,"agentid","")+"'>"+(String)hm1.get("username")+"</a>";
			groupheader=GenUtil.getHMvalue(hash,"header","");
			topsellers.add(str1);
			}
		}

	}
}

if(agentsinfo!=null&&agentsinfo.size()>0){
	selectagents=new StringBuffer();
	selectagents.append("<form name='agents' >");
	selectagents.append("<input type='hidden' name='eventid' value='"+groupid+"' />");
	selectagents.append("<select name='participant' onChange='getAgentsPage(\""+loginname+"\")' >");
	selectagents.append("<option value='' >---Select Participant---</option>");
	for(int i=0;i<agentsinfo.size();i++){
	HashMap agentmap=(HashMap)agentsinfo.elementAt(i);
	selectagents.append("<option value='"+(String)agentmap.get("agentid")+"' >"+(String)agentmap.get("username")+"</option>");
	}
	selectagents.append("</select>");
	selectagents.append("</form>");
}

String isenableyes=DbUtil.getVal("select enableparticipant from group_agent_settings where groupid=?",new String[]{groupid});
if(("Yes".equals(isenableyes)&&particpantid==null)||((particpantid!=null)&&!"yes".equals(enableparticipant)))
	request.setAttribute("FRIENDSTOEVENT",selectagents);

if("yes".equalsIgnoreCase(isf2fenabled)&&particpantid==null){
	setid=DbUtil.getVal("select settingid from group_agent_settings where groupid=?",new String [] {groupid});
	f2fTagline="<a href='/portal/mytasks/loginevent.jsp?setid="+setid+"&GROUPID="+groupid+"&foroperation=add'>"+DbUtil.getVal("select tagline from group_agent_settings where settingid=?",new String [] {setid})+"</a>";
	f2fimage="<a href='/portal/mytasks/loginevent.jsp?setid="+setid+"&GROUPID="+groupid+"&foroperation=add'><image src='/home/images/f2fenabled.gif'/></a>";
}
if (particpantid!=null)
	event_link="<a href=http://"+EbeeConstantsF.get("serveraddress","serveraddress")+ShortUrlPattern.get(loginname)+"/event?eventid="+request.getParameter("eventid")+" >"+"Visit Main Event Page"+"</a>";
%>




<%-------------tickets block-------------------------%>

<%

Vector vm_pub=new Vector();
Vector vm_mem=new Vector();
Vector vm_evt=new Vector();
Vector vm_opt=new Vector();
Vector alltickets=null;
String ticketheader="";
String ticketprintableversion="";
String ticketprintableversionlink="";

if(registrationAllowed){
creditcardlogos=" <img src='/home/images/mastercard.gif'  border='0'/><img src='/home/images/visa.gif'  border='0'/><img src='/home/images/amex.gif'  border='0'/>";
	alltickets=EventTicketDB.getAllActiveTicketInfo(groupid);
EventConfigScope evt_scope=new EventConfigScope();
   HashMap scopemap=evt_scope.getEventConfigValues(groupid,"Registration");
   String currformat=GenUtil.getHMvalue(scopemap,"event.reg.currency.format","$");

	for(int i=0;i<alltickets.size();i++){
                    HashMap ticketmp=(HashMap)alltickets.elementAt(i);
                   
               if ("Public".equals((String)ticketmp.get("tickettype")))
                        vm_pub.addElement(ticketmp);
               else if("Optional".equals((String)ticketmp.get("tickettype")))
	       		vm_opt.addElement(ticketmp);
	       else if("Member".equals((String)ticketmp.get("tickettype")))
               	        vm_mem.addElement(ticketmp);
 	       else 
                        vm_evt.addElement(ticketmp);
               }
	    if (ebeecontext||registrationAllowed)
                  size=vm_pub.size()+vm_mem.size()+vm_evt.size();
              else
                  size=vm_pub.size()+vm_mem.size();
		  request.setAttribute("TICKETHEADER",new String [] {"Name","Description","Price ("+currformat+")"});
		  ticketprintableversion="<input type='button' name='button1' value='Printable version' onclick=javascript:popupwindow('/portal/printdetails/ticketinfo.jsp?groupid="+groupid+"','Print','400','400') />";
		  ticketprintableversionlink="<a href=javascript:popupwindow('/portal/printdetails/ticketinfo.jsp?groupid="+groupid+"','Print','400','400') >";
}

request.setAttribute("TICKETPRINTABLEVERSIONBUTTON",ticketprintableversion);
request.setAttribute("TICKETPRINTABLEVERSIONLINK",ticketprintableversionlink);
if(vm_pub.size()==0)vm_pub=null;
if(vm_opt.size()==0)vm_opt=null;
%>

<%------------------------------notices-------------------------------------%>
<%
Vector notices=EventsContent.getAllNotices(groupid);
request.setAttribute("NOTICES",notices);
String listeddate=DbUtil.getVal("select to_char(created_at,'Month DD, YYYY') as created_at1 from eventinfo where eventid="+groupid,null);
String userfullnamelink="<a href='http://"+EbeeConstantsF.get("serveraddress","serveraddress")+ShortUrlPattern.get(loginname)+"/network' >"+userfullname+"</a>";
//String emailfriendButton="<input type='button' name='button1' value='Email this to a Friend' onclick=javascript:popupwindow('/portal/emailprocess/emailprocess.jsp?id="+groupid+"&purpose=INVITE_FRIEND_TO_EVENT','Email','800','500') />";
//String eventprintableversionButton="<input type='button' name='button1' value='Printable version' onclick=javascript:popupwindow('/portal/printdetails/eventinfo.jsp?groupid="+groupid+"','Email','800','500') />";
String addCalendarButton="<input type='button' name='button1' value='Add this to my calendar' onclick=javascript:popupwindow('"+EbeeConstantsF.get("vcal.webpath","/jboss32/server/default/deploy/home.war/vcal")+"/vcal_event_"+groupid+".vcs','vCal','400','400') />";
String eventprintableversionLink="<a href=javascript:popupwindow('/portal/printdetails/eventinfo.jsp?groupid="+groupid+"','Email','600','400') >Printable version</a>";
String addCalendarLink="<a href=javascript:popupwindow('"+EbeeConstantsF.get("vcal.webpath","/jboss32/server/default/deploy/home.war/vcal")+"/vcal_event_"+groupid+".vcs','VCal','400','400') >Add to my calendar</a>";
String particpant=request.getParameter("participant");
String addBlogLink="<a href=javascript:popupwindow('/portal/printdetails/bloginfo.jsp?groupid="+groupid+"&participant="+request.getParameter("participant")+"','Email','600','400') >Add to my blog</a>";
    
boolean exists=false;
HashMap photohash=null;
String webpathname="photo.image.webpath";
String imgname="",caption="";
webpathname="big.photo.image.webpath";
DBManager dbmanager1=new DBManager();
StatusObj statobj1=dbmanager1.executeSelectQuery(GET_ATTENDEE_PHOTO,new String[]{groupid} );
if(statobj1.getStatus()){
exists=true;
photohash=new HashMap();
for(int i=0;i<statobj1.getCount();i++){
imgname="<img src='"+EbeeConstantsF.get(webpathname,"")+"/"+dbmanager1.getValue(i,"photourl","")+"' />";
caption=dbmanager1.getValue(i,"caption","");
}
}
String listurl=ShortUrlPattern.get(loginname)+"/event?eventid="+groupid;
String msg="Hi,\n\n"+"I thought you might be interested in - "+subject+"\n"+"Here is the listing URL: "+listurl+"\n\n"+"Thanks";

String company=DbUtil.getVal("select company from user_profile where user_id=?",new String[]{mgrid});



String hostedby="";
if(company!=null&&!"".equals(company))
hostedby=company;
else
hostedby=(String)request.getAttribute("USERFULLNAME");





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
      contactMgrLink+=" <input type='button' name='sendmgr' value='Send'  onClick=' return checkAttendeeForm()' /> " ;
      contactMgrLink+=" <input type='button' value='Cancel' onclick=javascript:Cancel('contactmgr'); />" ;
      contactMgrLink+=" </p>" ;
      contactMgrLink+=" </form> </div>";
      contactMgrLink+=" <div id='urmessage'></div>";

String emailfriendLink="<a  href=javascript:Show('Invitation')>Email this to a friend</a>";
      emailfriendLink+=" <div id='Invitation' style='display: none; margin: 10 5 10 5;'> " ;
      emailfriendLink+=" <form name='invitationForm'  id='invitationForm' action='/portal/emailprocess/emailsend.jsp?UNITID=13579&id="+groupid+"&purpose=INVITE_FRIEND_TO_EVENT'  method='post' >" ;
      emailfriendLink+="<input type='hidden' name='url' value='"+listurl+"' />";
      emailfriendLink+=" To* : <a href='#' onclick=showPlaxoABChooser('to_email','/home/links/addressimport.html'); return false><img src='http://www.plaxo.com/images/abc/buttons/add_button.gif' alt='Add from my address book' hspace='20' align='absmiddle' border='0'/></a> ";
      emailfriendLink+=" <textarea id='to_email' style='display: none;'></textarea> " ;
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
      emailfriendLink+=" <input type='button' name='sendmsg' value='Send'  onClick=' return checkInvitationForm()' /> " ;
      emailfriendLink+=" <input type='button' value='Cancel' onclick=javascript:Cancel('Invitation'); />" ;
      emailfriendLink+=" </p>" ;
      emailfriendLink+=" </form> </div>";
      emailfriendLink+=" <div id='message'></div>";



String commission=DbUtil.getVal("select max(networkcommission) from price where evt_id=?",new String[]{groupid});	
commission="$"+commission;

String userfirstname=DbUtil.getVal("select first_name from user_profile where user_id=?",new String[]{mgrid});



String evturl=DbUtil.getVal("select url from event_custom_urls where eventid=?",new String[]{groupid});
if(evturl==null)
evturl=listurl;
String EventURL="<a href=javascript:Show('eventurl') >Event URL</a>";
EventURL+="<div id='eventurl' style='display: none; align='right' margin: 10 5 10 5;>";
EventURL+="<textarea  cols='35' rows='3' onClick='this.select()'>"+evturl+"</textarea></div>";


request.setAttribute("USERFIRSTNAME",userfirstname);
request.setAttribute("USERFULLNAME",userfullname);
request.setAttribute("EVENTPHOTO",imgname);
request.setAttribute("EVENTPHOTOCAPTION",caption);
//request.setAttribute("AGENTINFO",agents);
request.setAttribute("EVENTTOPSELLERS",topsellers);
request.setAttribute("HEADERMSG",groupheader);
request.setAttribute("MAINEVENTLINK",main_event_link);
request.setAttribute("REGISTRATIONFORM",registerform);
request.setAttribute("REGISTRATIONLINK",registerlink);
//request.setAttribute("EMAILTOFRIENDBUTTON",emailfriendButton);
//request.setAttribute("EVENTPRINTABLEVERSIONBUTTON",eventprintableversionButton);
request.setAttribute("ADDCALENDARBUTTON",addCalendarButton);
request.setAttribute("EMAILTOFRIENDLINK",emailfriendLink);
//request.setAttribute("EVENTPRINTABLEVERSIONLINK",eventprintableversionLink);
request.setAttribute("ADDCALENDARLINK",addCalendarLink);
request.setAttribute("EVENTLISTEDON",listeddate);
request.setAttribute("EVENTLISTEDBY",userfullnamelink);
request.setAttribute("MANAGEREMAIL",mgr_email);
request.setAttribute("REQUIREDTICKETS",vm_pub);
request.setAttribute("OPTIONALTICKETS",vm_opt);
request.setAttribute("DESCRIPTION",description);
request.setAttribute("NOTICES",notices);
request.setAttribute("DISPLAYED",displayed);
//request.setAttribute("F2FTAGLINE",f2fTagline);
request.setAttribute("CREDITCARDLOGOS",creditcardlogos);
request.setAttribute("CONTACTMGRLINK",contactMgrLink);
request.setAttribute("PARTNERSTREAMER",partnerstreamer);
request.setAttribute("COMMISSION",commission);
request.setAttribute("EVENTURL",EventURL);

%>



<jsp:include page='/main/Themebeeheader.jsp' />
<jsp:include page='/main/eventfooter.jsp' />


