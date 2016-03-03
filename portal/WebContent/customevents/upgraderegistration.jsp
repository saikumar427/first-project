<%@ page import="com.eventbee.general.*" %>
<%@ page import="org.eventbee.sitemap.util.Presentation" %>

<%
String groupid=Presentation.GetRequestParam(request,  new String []{"eid","eventid", "id","groupid"});

String isupgrade=DbUtil.getVal("select value from config where config_id=(select config_id from eventinfo where eventid=?) and name='event.upgrade.registration'",new String[]{groupid});
	
%>


<script>

function validateTransactionId(){
document.getElementById("upgraderegister").action='/portal/customevents/validatetransactionid.jsp?GROUPID=<%=groupid%>'

    advAJAX.submit(document.getElementById("upgraderegister"), {			
    onSuccess : function(obj) {
	var data=obj.responseText;
		  
    if(data.indexOf("Success")>-1){		
    	window.location.href = "/portal/eventregister/register?groupid=<%=groupid%>";
	}
	else 
		document.getElementById('pwdprotect').innerHTML='<font color="red">Enter valid Transactionid</font>';
				
	},
    onError : function(obj) { alert("Error: " + obj.status); }
});
}


function SendTransactionId(){
document.getElementById("upgraderegister").action='/portal/customevents/sendtransactionid.jsp?GROUPID=<%=groupid%>'
    advAJAX.submit(document.getElementById("upgraderegister"), {			
    onSuccess : function(obj) {
	var data=obj.responseText;
		  
    if(data.indexOf("Success")>-1){		
    document.getElementById('pwdprotect').innerHTML='<font color="red">Transaction ID has been sent to your email</font>';	}
	else 
		document.getElementById('pwdprotect').innerHTML='<font color="red">No transaction for this email</font>';
				
	},
    onError : function(obj) { alert("Error: " + obj.status); }
});
}










</script>

<form id="upgraderegister" name="upgraderegister" method="POST" action=""  onSubmit="validateTransactionId(); return false;">
<input type="hidden" name="GROUPID" value="<%=request.getParameter("groupid")%>" />
<table cellspacing="0" class="inputvalue"  valign="top" border="0" align="center">


<%if("yes".equalsIgnoreCase(isupgrade)){%>
<tr>
<td height="50" align="left" ></td>
</tr>
<tr>
	<td id="pwdprotect" align="left"></td></tr>
<tr>
	<td class="inputvalue" align="left">Enter your existing Transaction ID	<input description="transactionid" id="transactionid" size="30" type="text" name="transactionid" />
	<input value="Continue" name="submit" type="submit" /></td>
</tr>
<tr height='10'><td></td></tr>
<tr>
<td align="left" class='smallestfont'>Forgot Transaction ID? Check your registration confirmation Email.</td>
</tr>
<tr>
<td  align="left" class='smallestfont'>Email ID <input description="email" id="email" size="30" type="text" name="email" /> <input value="Resend Transaction ID" name="submit" size="40" type="button" onClick="SendTransactionId();" /></td>
</tr>
<tr>
<td align="left" class='smallestfont'>Please do check your Spam folder if you don't see Email in your Inbox.</td>
</tr>
<tr height='50'><td></td></tr>
<%}

else{

%>
<tr>
<td height="50" align="left" ></td>
</tr>

<tr>
<td align="left" >Upgrade Registration is not allowed for this event</td>
</tr>
<tr height='50'><td></td></tr>



<%}%>



</table>
</form>








