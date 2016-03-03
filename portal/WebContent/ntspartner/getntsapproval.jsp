<%@ page import="com.eventbee.general.*,com.eventbee.authentication.*" %>

<%
String groupid=request.getParameter("groupid");
String userid="";
String firstname="";
String lastname="";
Authenticate authData=AuthUtil.getAuthData(pageContext);
if(authData !=null){
	userid=authData.getUserID();
	 firstname=authData.getFirstName();
	lastname=authData.getLastName();
}
String oid=request.getParameter("oid");

String partnerid=DbUtil.getVal("select partnerid from group_partner where userid=?",new String[]{userid});
if(partnerid==null){
	userid=DbUtil.getVal("select ebeeid from ebee_ning_link where nid=?",new String[]{oid});
	partnerid=DbUtil.getVal("select partnerid from group_partner where userid=?",new String[]{userid});
	
}
String evtname=DbUtil.getVal("select eventname from eventinfo where eventid=CAST(? AS INTEGER)",new String[]{request.getParameter("groupid")});
String email=DbUtil.getVal("select email from user_profile where user_id=?",new String[] {userid});

if(email==null)
	email="";
if(firstname==null)
	firstname="";
if(lastname==null)
	lastname="";

String mgrname=DbUtil.getVal("select login_name from authentication where user_id=(select mgr_id::VARCHAR from eventinfo where eventid=CAST(? AS INTEGER))",new String[]{groupid});
%>
<script type="text/javascript" language="JavaScript" src="/home/js/advajax.js">
        function dummy2() { }
</script>

<script type="text/javascript" language="JavaScript" src="/home/js/ajax.js">
        function dummy3() { }
</script>

<script>
function sendmail(){
advAJAX.submit(document.getElementById("frm"), {
    onSuccess : function(obj) {    
	window.location.href="<%=request.getAttribute("backurl")%>";    
    },
    onError : function(obj) { alert("Error: " + obj.status); }
});

}
</script>

<script>
function partnernetwork(){
window.location.href="<%=request.getAttribute("backurl")%>";
}
</script>


<form name="frm" id="frm" action="/portal/ntspartner/ajaxsendntsrequestmailprocessor.jsp" method="post" >
<input type="hidden" name="partnerid" value="<%=partnerid%>">
<input type="hidden" name="eventid" value="<%=groupid%>">
<table width="100%">
<tr>
<td width="25%">To</td>
<td width="75%"><%=mgrname%></td>
</tr>
<tr><td colspan="2" height="5"</tr>
<tr>
<td width="15%">From</td>
<td width="85%"><input type="text" size="30" id="email" name="email" value="<%=email%>"></td>
</tr>
<tr><td colspan="2" height="5"</tr>
<tr>
<td width="15%">Subject</td>
<td width="85%">Requesting Network Ticket Selling Approval - <%=evtname%></td>
</tr>
<tr><td colspan="2" height="5"</tr>
<tr>
<td width="15%">Messeage</td>
<td width="85%"><textarea id="message" name="message" rows='10' cols='50'>
Hi,

Please approve me as Network Ticket Selling participant on your event - <%=evtname%>.

Thanks,
<%=firstname%> <%=lastname%>
</textarea></td>
</tr>
<tr><td colspan="2" height="5"</tr>
<tr>
<td colspan="2" align="center"><input type="button" value="Send" onclick="sendmail(<%=partnerid%>,<%=groupid%>);">
<input type="button" value="Cancel" onclick="partnernetwork();">
</td></tr>
</table>
