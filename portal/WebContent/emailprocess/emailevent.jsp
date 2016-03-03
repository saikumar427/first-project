<%@ page import="java.util.*,java.io.*,java.io.IOException"%>
<%@ page import="com.eventbee.classifieds.ClassifiedDB,com.eventbee.general.formatting.*"%>
<%@ page import="com.eventbee.authentication.*,com.eventbee.general.*"%>
<%@ page import="com.eventbee.useraccount.*" %>
<%@ page import="com.eventbee.context.ContextConstants" %>
<%

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
				
		if (!document.invitationForm.from_name.value) {
		    
			alert('Please enter your name.');
			return false;
		}
		
			
		if (!document.invitationForm.from_email.value) {
			
			alert('Please enter your email address.');
			return false;
		}
		
			
		if (!document.invitationForm.to_email1.value) {
		    alert('Please enter a valid email address in the To: field.');
			return false;
		}
				
			
		if (!document.invitationForm.subject.value) {
			alert('Please enter a subject for your message.');
			return false;
		}
		
			
		if (!document.invitationForm.note.value) {
			alert('Please enter your note.');
			return false;
		}
		if (!/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(document.invitationForm.from_email.value)){
			alert('Your email address is not valid.');
			return false;
		}
		

		  var toemail=document.invitationForm.to_email1.value;
		
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
		    document.getElementById("uparrow").style.display = 'none'
		    document.getElementById("sidearrow").style.display = 'block'
		    document.invitationForm.sendmsg.value="Send";
		    document.invitationForm.to_email1.value='';
		 
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
			document.getElementById("sidearrow").style.display = 'none'
			document.getElementById("uparrow").style.display = 'block'
			document.getElementById("message").innerHTML='';
			document.getElementById("sidearrowAd").style.display = 'block'
			document.getElementById("uparrowAd").style.display = 'none'
		} 
	}
	
</script>


<script>
function Cancel(div)
{
var theDiv = document.getElementById(div);
theDiv.style.display = 'none';
document.getElementById("sidearrow").style.display = 'block'
document.getElementById("uparrow").style.display = 'none'
}
</script>



<%

String name="";String email="";
String phone="";
String groupid=request.getParameter("GROUPID");

String subject=DbUtil.getVal("select eventname from eventinfo where eventid=?", new String[]{groupid});
if(fromuserid!=null&&fromuserid!="")
{
name =DbUtil.getVal("select getMemberName(user_id||'') as name from user_profile where user_id=?",new String[]{fromuserid});
email=DbUtil.getVal("select email from user_profile where user_id=?",new String[]{fromuserid});
phone=DbUtil.getVal("select phone from user_profile where user_id=?",new String[]{fromuserid});
}
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","http://www.desihub.com");

String listurl=serveraddress+"/eventmanage/eventmange.jsp?GROUPID="+groupid+"&UNITID=13579";
 		
String msg="Hi,\n\n"+"I thought you might be interested in - "+subject+"\n"+"Here is the listing URL: "+listurl+"\n\n"+"Thanks";

%>


<table class="portaltable" align="center" width="100%" cellspacing="0" cellpadding="2" valign='top'>

<%= PageUtil.writeHiddenCore( (HashMap)request.getAttribute("REQMAP") )%>

<input type="hidden" name="purpose" value="sendsms"/>
<input type="hidden" name="fromid" value="<%=fromuserid%>"/>
<%--<input type="hidden" name="msgto" value="<%=GenUtil.getHMvalue(hm,"owner","-1")%>"/>
<input type="hidden" name="to" value="<%=GenUtil.getHMvalue(hm,"name","")%>"/> --%>
<input type="hidden" name="totype" value="Userid"/>


<%
HashMap wordmap=new HashMap();
wordmap.put("#**name**#",subject);
wordmap.put("#**groupid**#",groupid);
wordmap.put("#**UNITID**#",request.getParameter("UNITID"));
session.setAttribute(groupid+"_INVITE_FRIEND_TO_EVENT",wordmap);
%>

<tr><td></td></tr>
<tr>
	<td>
	<div colspan='2' height="30" id='sidearrow' align="left">&raquo;
		<span class='bigfont'><a  href="javascript: Show('Invitation');"/>  Email this to a friend</a></span>
	</div>

	<div colspan='2' height="30" align="left" id='uparrow'  style="display: none;"><img id="upimg" src="/home/images/uparrow.gif"/>
	<span class='bigfont'><a href="javascript: Show('Invitation');"/>  Email this to a friend</a></span>
	</td>
	</tr>
<tr><td></td></tr>
</table>

<%@ include file="/../plaxo_js.jsp" %>


<div id="Invitation" style="display: none; margin: 10 5 10 5;">
		<form name="invitationForm"  id="invitationForm" action="/portal/emailprocess/emailsend.jsp?UNITID=<%=request.getParameter("UNITID")%>&id=<%=groupid%>&purpose=INVITE_FRIEND_TO_EVENT"  method="post" >

		To* : <a href="#" onclick="showPlaxoABChooser('to_email', '/home/links/addressimport.html'); return false"><img src="http://www.plaxo.com/images/abc/buttons/add_button.gif" alt="Add from my address book" hspace="20" align="absmiddle" border='0'/></a>
		<textarea id="to_email" style="display: none;"></textarea>
		<textarea id="toheader" name="to_email1" style="width: 210px; height: 70px;"></textarea><br>(separate emails with commas)

		<br><br>

		Your Email ID* :<br>
		<input type="text" name="from_email" value="<%=email%>"  style="width: 200px;"><br><br>

		Your Name* :  <br>
		<input type="text" name="from_name" value="<%=name%>"  style="width: 200px;"><br><br>

		Subject :<br>
		<input type="text" name="subject" value="Fw: <%=subject%>" style="width: 200px;"><br><br>
		Message :<br>
		<textarea name="note" style="width: 210px; height: 75px;"><%=msg%></textarea><br><br>

		<p align="center">
		<input type="button" name='sendmsg' value="Send"  onClick=" return checkInvitationForm()" />
		<input type="button" value="Cancel" onclick="javascript: Cancel('Invitation');"/>
		</p>
		</form>
	</div>
			

</div>
			<div id='message'></div>

<%
if(request.getParameter("frompagebuilder") !=null)
		out.println(PageUtil.endContent());
%>

