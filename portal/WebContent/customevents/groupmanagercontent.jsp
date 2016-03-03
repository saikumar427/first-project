<%@ page import="java.util.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.authentication.*"%>
<%@ page import="com.eventbee.creditcard.PaymentTypes"%>
<%@ page import="org.eventbee.sitemap.util.Presentation" %>


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

</script>

<script>

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


</script>


<script>

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
	
</script>


<script>
function Cancel(div)
{
var theDiv = document.getElementById(div);
theDiv.style.display = 'none';
}
</script>
<%
String fromuserid="";
String name="";
String email="";
String phone="";
String role="";
String unitid="";

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
String groupid=Presentation.GetRequestParam(request,  new String []{"eid","groupid", "eventid","GROUPID"});


String subject=DbUtil.getVal("select group_title from user_groupevents where event_groupid=?", new String[]{groupid});

if(fromuserid!=null&&fromuserid!="")
{
name =DbUtil.getVal("select getMemberName(user_id||'') as name from user_profile where user_id=?",new String[]{fromuserid});
email=DbUtil.getVal("select email from user_profile where user_id=?",new String[]{fromuserid});
phone=DbUtil.getVal("select phone from user_profile where user_id=?",new String[]{fromuserid});
}
HashMap userhm=(HashMap)request.getAttribute("userhm");
String loginname=null;
if(userhm!=null)
loginname=(String)userhm.get("login_name");
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","")+"/";


String listurl=serveraddress+"event?eid="+groupid;
String msg="Hi,\n\n"+"I thought you might be interested in - "+subject+"\n"+"Here is the listing URL: "+listurl+"\n\n"+"Thanks";
String hostedby="";
String mgrid=DbUtil.getVal("select userid from user_groupevents where   event_groupid=?",new String[]{groupid});
String company=DbUtil.getVal("select company from user_profile where user_id=?",new String[]{mgrid});
String fullusername=DbUtil.getVal("select first_name||' '||last_name from user_profile where user_id=?",new String[]{mgrid});
System.out.println("fullusername---"+fullusername);
if(company!=null&&!"".equals(company))
hostedby=company;
else
 hostedby=fullusername;



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
contactMgrLink+="  <img  id='captchaidmgr' src='/captcha?fid=AttendeeForm' alt='Captcha'  /></div><br><br>";
contactMgrLink+="<input type='hidden' name='formnamemgr' value='AttendeeForm'/>";
contactMgrLink+="<input type='hidden' name='isgroupevent' value='Yes'/>";

      contactMgrLink+=" <input type='button' name='sendmgr' value='Send'  onClick=' return checkAttendeeForm()' /> " ;
      contactMgrLink+=" <input type='button' value='Cancel' onclick=javascript:Cancel('contactmgr'); />" ;
      contactMgrLink+=" </p>" ;
      contactMgrLink+=" </form> </div>";
      contactMgrLink+=" <div id='urmessage'></div>";
      request.setAttribute("CONTACTMGRLINK",contactMgrLink);

System.out.println("subject-ddd---"+subject);


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
     // emailfriendLink+=" <input type='button' name='sendmsg' value='Send'  onClick=' return checkInvitationForm(\"invitationForm\")' /> " ;
	emailfriendLink+=" <div id='captchamsg' style='display: none; color:red' >Enter Correct Code</div> " ;

	emailfriendLink+="Enter the code as shown below:<div style='padding:5px;' valign='top' width='100%'><input type='text'   name='captcha'  value=''   valign='top'/>";
	emailfriendLink+="  <img  id='captchaid' src='/captcha?fid=invitationForm' alt='Captcha'  /></div><br><br>";
	emailfriendLink+="<input type='hidden' name='formname' value='invitationForm'/>";


      
      emailfriendLink+=" <input type='button' name='sendmsg' value='Send'  onClick=' return checkInvitationForm()' /> " ;
      emailfriendLink+=" <input type='button' value='Cancel' onclick=javascript:Cancel('Invitation'); />" ;
      emailfriendLink+=" </p>" ;
      emailfriendLink+=" </form> </div>";
      emailfriendLink+=" <div id='message'></div>";
      
   
   
String evturl=DbUtil.getVal("select url from event_custom_urls where eventid=?",new String[]{groupid});
if(evturl==null)
evturl=listurl;
String EventURL="<a href=javascript:Show('eventurl') >Event URL</a>";
EventURL+="<div id='eventurl' style='display: none; align='right' margin: 10 5 10 5;>";
EventURL+="<textarea  cols='35' rows='3' onClick='this.select()'>"+evturl+"</textarea></div>";

   
   
request.setAttribute("EMAILTOFRIENDLINK",emailfriendLink);
String creditcardlogos="";
String geventid="";
geventid=DbUtil.getVal("select eventid from group_events where event_groupid=? limit 1",new String[]{groupid});
creditcardlogos="<img src='/home/images/eventbeecc.gif'  border='0'/>";
request.setAttribute("CREDITCARDLOGOS",creditcardlogos);

request.setAttribute("EVENTURL",EventURL);

	
%>