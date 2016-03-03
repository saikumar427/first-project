<%@ page import="java.util.*,java.sql.*" %>
<%@ page import="com.eventbee.general.formatting.EventbeeStrings,com.eventbee.event.*,com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.authentication.*"%>

<%
String evttype=request.getParameter("evttype");
String action1="",fromuserid="",appname="",role="",unitid="",username="";
Authenticate authData=AuthUtil.getAuthData(pageContext);
if(authData!=null){
 role=authData.getRoleName();
 unitid=authData.getUnitID();
 fromuserid=authData.getUserID();
 username=authData.getLoginName();
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
			alert('Please enter your note.');
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
		    document.invitationForm.sendmsg.value="Sending...";
		    document.getElementById('message1').innerHTML=restxt;
		    document.getElementById("Invitation").style.display = 'none'
		   document.invitationForm.toemails.value='';
		   		        document.invitationForm.fromemail.value='';
		   		         document.invitationForm.fromname.value='';
		   		          document.invitationForm.personalmessage.value='';
		                         document.getElementById('myAnchor').focus();


		    
		    
		    },
		    onError : function(obj) { alert("Error: " + obj.status);}
		});
		
	}

</script>


<script>

function Show(div)
	{
		var theDiv = document.getElementById(div);
		if (theDiv.style.display == 'none') {
			theDiv.style.display = 'block';
			
			document.getElementById("message1").innerHTML='';
			

			
		} 
	}
	
</script>
<script>
function Cancel(div)
{
var theDiv = document.getElementById(div);
theDiv.style.display = 'none';
 document.getElementById('myAnchor').focus();




}
</script>
<%
String name="";String email="";
String phone="";
HashMap partnerevtmap=(HashMap)session.getAttribute("PARTNER_EVENT_LISTING_ATTRIBS");
if(partnerevtmap!=null)
	session.removeAttribute("PARTNER_EVENT_LISTING_ATTRIBS");

HashMap networkevtmap=(HashMap)session.getAttribute("NETWORK_EVENTLIST_ATTRIBS");
if(networkevtmap!=null)
	session.removeAttribute("NETWORK_EVENTLIST_ATTRIBS");

if(fromuserid!=null&&fromuserid!="")
{
name =DbUtil.getVal("select getMemberName(user_id||'') as name from user_profile where user_id=?",new String[]{fromuserid});
email=DbUtil.getVal("select email from user_profile where user_id=?",new String[]{fromuserid});
phone=DbUtil.getVal("select phone from user_profile where user_id=?",new String[]{fromuserid});
}
 String url=ShortUrlPattern.get("events");

String homepageurl=EbeeConstantsF.get(request.getParameter("evttype")+".homepage.url","www.eventbee.com");
session.removeAttribute("13579_EMAIL_HOMEPAGE");
String groupid=(String)request.getAttribute("GROUPID");







String serveraddress="http://"+EbeeConstantsF.get("serveraddress","http://www.desihub.com");
HashMap userhm=(HashMap)request.getAttribute("userhm");
String loginname=null;
if(userhm!=null)
loginname=(String)userhm.get("login_name");

String listurl=ShortUrlPattern.get(loginname)+"/event?eventid="+groupid;
String submsg="";
if("event".equals(request.getParameter("evttype"))) submsg="events";
else submsg="classes";		


%>
	   <table width="100%" border="0" cellpadding="0" cellspacing="0"  bgcolor="#FFFFFF" >
<tr>
          <td  width="800" height="30">
            <table width="100%"  >
	    	<tr><td height="30" >
		<span class='bigfont'>&raquo <a href='/portal/guesttasks/addevent.jsp?isnew=yes' >List your Event</a></span>
		
		<span class='smallfont'>[<a href="/portal/helplinks/onlineregistration.jsp">Complete event management...</a>]</span>
		</td></tr>
		<tr>
			<td height="30" >
		
		    <span class='bigfont'>&raquo <a id="myAnchor" href=javascript:Show('Invitation')>  Email this to a friend</a></span>
		       <div id='Invitation' style='display: none; margin: 10 5 10 5;  ' class='taskblock'> 
		       <form name='invitationForm'  id='invitationForm' action='/portal/emailprocess/emailsent.jsp?UNITID=13579&id="+groupid+"&purpose=INVITE_FRIEND_TO_EVENT'  method='post' >
		       <input type='hidden' name='url' value='<%=url%>' />
		        <input type='hidden' name='evttype' value='<%=submsg%>' />
		       To* : <a href='#' onclick=showPlaxoABChooser('toemail','/home/links/addressimport.html'); return false><img src="/home/images/wizard_button.gif" alt='Add from my address book' hspace='20' align='absmiddle' border='0'/></a> 
		       <textarea id='toemail' style='display: none;'></textarea> 
		       <textarea id='toheader' name='toemails' style='width: 210px; height: 70px;'></textarea><br>(separate emails with commas) 
		       <br><br> 
		       Your Email ID* :<br> 
		       <input type='text' name='fromemail' value='<%=email%>'  style='width: 200px;'><br><br>
		       Your Name* :  <br>
		       <input type='text' name='fromname' value='<%=name%>'  style='width: 200px;'><br><br> 
		       Subject :<br> 
		       <input type='text' name='subject' value="Visit <%=submsg%>.eventbee.com" style='width: 200px;'><br><br> 
		       Message :<br> 
		       <textarea name='personalmessage' style='width: 210px; height: 75px;'> </textarea><br><br>
		        
		       <p align='center'> 
		      <input type='button' name='sendmsg' value='Send'  onClick=' return checkInvitationForm()' /> 
		       <input type='button' value='Cancel' onclick=javascript:Cancel('Invitation'); />
		       </p>
		      </form> </div>
		       <div id='message1'></div>
		
</td>
</tr>
		</table>
	</td>
</tr>
	   
	   </table>
