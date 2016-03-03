<%@ page import="java.util.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.eventpartner.*" %>

<script language="javascript">	
function checkform(){
var policy=document.frm.policy;
if(policy.checked){return true;}
else{
alert('Accept Terms and Conditions');
return false;}
}
</script>
<link rel="stylesheet" type="text/css" href="/home/index.css" />
<%
request.setAttribute("mtype","Network Ticket Selling");
request.setAttribute("stype","My Network Event Listing");
%>
<jsp:include page='/ningapp/mytabsmenu.jsp' />

<%
String partnerid="";
String linkpath="http://"+EbeeConstantsF.get("serveraddress","www.beeport.com")+"/home/links";
request.setAttribute("subtabtype","Eventbee Partner Network"); 
partnerid=request.getParameter("partnerid");
HashMap partnermap=PartnerDB.getPartnerInformation(partnerid);	
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"editpartner.jsp"," Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
Vector errorVector=null;
if("yes".equals(request.getParameter("error"))){
	errorVector=(Vector)session.getAttribute("CREATE_PARTNER_ERROR_DATA");
}
if(!"edit".equals(request.getParameter("type")))
	partnermap=(HashMap)session.getAttribute(partnerid+"_partner_map");

%>



<form id='editpartner' name='frm' method="post" action="/ning/update" onsubmit="return checkform()">
<table class="block" cellspacing="0" cellpadding='0' width='100%'>

<tr><td colspan="2" height="5"></td></tr>
<tr><td colspan="2">
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<%=GenUtil.displayErrMsgs("<tr><td class='error'>",errorVector,"</td></tr>")%>
	</table>
</td></tr>
<tr><td colspan="2" height="5"></td></tr>

<tr>
<td class='inputlabel' width="30%" height="30">My Website or Blog URL </td>
<td class='inputvalue'><input type="text" name='url' size="67" value="<%=GenUtil.getHMvalue(partnermap,"url","",true)%>"/></td>
</tr>
<tr>
<td class='inputlabel' width="30%" height="30">My Website or Blog Title </td>
<td class='inputvalue'><input type="text" name='title' size="67" value="<%=GenUtil.getHMvalue(partnermap,"title","",true)%>"/></td>
</tr>

<tr>
<td class='inputlabel' valign='top'  height="30">My Website or Blog Description </td>
<td class='inputvalue'><textarea name="message"  rows='12' cols='50'><%=GenUtil.getHMvalue(partnermap,"message","",true)%></textarea></td>
</tr>
<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>
<tr>
<td colspan="2" align="center" class="inputvalue">
<input type="checkbox" name="policy" value="yes" checked />  By clicking Submit, I accept Eventbee Partner Network
 <a href="javascript:popupwindow('<%=linkpath%>/eventspartnerterms.html','Tags','600','400')"> Terms and Conditions</a></td>
</tr>

<tr><td colspan='2'><br>
<center><input type='submit' value="Update" name="update"/>
<input type='button' name='cancel' value='Back' onclick="javascript:window.history.back()"/>
<input type="hidden" name="partnerid" value="<%=partnerid%>" >
</center></td>
</tr> 
</table>
</form>  




