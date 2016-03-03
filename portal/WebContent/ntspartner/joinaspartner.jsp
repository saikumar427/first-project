<%@ page import="java.util.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.Authenticate" %>

<script language="javascript">	
function checkform(){
var policy=document.frm.policy;
if(policy.checked){return true;}
else{
alert('Accept Terms and Conditions');
return false;}
}
</script>

<%
String userid="";
String partnerid="";
String linkpath="http://"+EbeeConstantsF.get("serveraddress","www.beeport.com")+"/home/links";
Authenticate authData=AuthUtil.getAuthData(pageContext);
StatusObj status=null;
String UPDATEQ="update group_partner set status='Active'  where partnerid=?";
if(authData!=null){
userid=authData.getUserID();
request.setAttribute("subtabtype","Eventbee Partner Network"); 
String alreadypartner=DbUtil.getVal("select partnerid from group_partner where userid=? and status='Active'",new String[]{userid});
String inactivepartnerid=null;
if(alreadypartner==null)
	inactivepartnerid=DbUtil.getVal("select partnerid from group_partner where userid=? and status='InActive'",new String[]{userid});
if(inactivepartnerid!=null){
	status=DbUtil.executeUpdateQuery(UPDATEQ,new String [] {inactivepartnerid});
	status=DbUtil.executeUpdateQuery("update group_agent set status='Active' where userid=?",new String[]{userid});
}
HashMap partnermap=new HashMap();
String platform = request.getParameter("platform");
	String URLBase="/portal/mytasks/networkticketsellingpage.jsp";
	if("ning".equals(platform)){		
		URLBase="/ningapp/ntstab";
	}

EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"joinaspartner.jsp"," Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
%>


<form id='joinpartner' name='frm' method="post" action="/eventpartner/confirm" onsubmit="return checkform()">
<table class="block" cellspacing="0" cellpadding='0' width='100%' >

<tr><td colspan="2" height="5"></td></tr>

<% if(inactivepartnerid!=null){ %>
<tr><td align="center">
	<%=EbeeConstantsF.get("thank.you.partner","Thank you for joining again Eventbee Partner Network")%>
</td></tr>
<tr><td align="center">Back to <a href="<%=URLBase%>">Eventbee Partner Network</a> </td></tr>
<%}else if(alreadypartner!=null){ %>
<tr><td align="center">
	<%=EbeeConstantsF.get("already.joined.partner","You already joined Eventbee Partner Network")%>
</td></tr>
<tr><td align="center">Back to <a href="<%=URLBase%>">Eventbee Partner Network</a> </td></tr>
<%}else{%>
<tr><td colspan="2" height="5"></td></tr>
<tr>
<td class='inputlabel' width="30%" height="30">My Website or Blog URL </td>
<td class='inputvalue'><input type="text" name='url' size="67" value="<%=GenUtil.getHMvalue(partnermap,"url","",true)%>"/></td>
</tr>
<tr><td colspan="2" height="5"></td></tr>
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
<input type="checkbox" name="policy" value="yes"/>  By clicking Submit, I accept Eventbee Partner Network
 <a href="javascript:popupwindow('<%=linkpath%>/eventspartnerterms.html','Tags','600','400')"> Terms and Conditions</a></td>
</tr>

<tr><td colspan='2'><br>
<center><input type='submit' value="Submit" name="submit"/>
<input type='button' name='cancel' value='Cancel' onclick="javascript:window.history.back()"/>
</center></td>
</tr> 
<%}%>
</table>
</form>  



<%}%>
