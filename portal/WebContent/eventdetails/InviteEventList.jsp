<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.event.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.nuser.*,com.eventbee.context.ContextConstants,com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.useraccount.*" %>

<%
request.setAttribute("tabtype","event");
request.setAttribute("tasktitle","Invite Event Manager");
%>


<%
String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";
String userid=null;
String unitid=request.getParameter("UNITID");
String email=null;
Authenticate authData=AuthUtil.getAuthData(pageContext);
if (authData!=null){
      	 	 userid=authData.getUserID();
   		 email=(String)authData.UserInfo.get("Email");
}
%>
<form name='inviteevt' id='inviteevt' action="<%=appname%>/eventdetails/emailsend.jsp" method="post" onsubmit="emailsubmit();return false">
    <table cellspacing="0" class="taskblock" cellpadding="0" border="0" align='center' width="100%">
        <tr>
      	  <td > Subject * : </td>
      	  </tr><tr>
      	  <td  >
          <input type="text"  name="subject" value='Please list your event at Eventbee' size="40" />
      	  </td>
	</tr>
	<tr>
	  <td >From * :</td>
	  </tr><tr>
	  <td >
	  <input type="text" maxlength="120" name="fromemail" value="<%=GenUtil.getEncodedXML(email)%>"  size="40" />
	  </td>
	</tr>
	<tr>
	  <td >To * :</td>
	  </tr><tr>
	  <td >
	  <input type="text" maxlength="120" name="toemail" value=""  size="40" />
	  </td>
	</tr>
	<tr>
	  <td >Personal Message :</td>
	  </tr><tr>
	  <td >
		<textarea name="personalmessage" cols="30" rows="10" >I would like to register for your event through Eventbee. Please list your event at Eventbee </textarea>
	  </td>
	</tr>
        <tr>
          <td colspan="2" align="center">
      	  
	  <%= com.eventbee.general.PageUtil.writeHiddenCore( (HashMap)request.getAttribute("REQMAP") )%>
          <input type="Submit" name="Submit" value="Submit" />
          <input type="button" name="Back" value="Cancel" onclick="CancelInvite();"/>
        </td></tr>
   </table>
</form>
