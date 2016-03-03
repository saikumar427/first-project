<%@ page import="java.io.*, java.util.*,java.sql.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*,com.eventbee.authentication.*" %>
<jsp:include page="/auth/checkpermission.jsp" />
<% 
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"lifestyle/setting.jsp","Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);

String userid="";
String firstname="";
Authenticate authData=AuthUtil.getAuthData(pageContext);
Map themeprefmap=new HashMap();
	if (authData!=null){
		userid=authData.getUserID();
		firstname=authData.getFirstName()+ "'s Network";
		
		themeprefmap=PreferencesDB.getUserPref(userid,"themepage.snapshot.title");
		
		firstname= GenUtil.getHMvalue( themeprefmap , "themepage.snapshot.title",firstname);
	}

   
%>	

<table align="center" width="100%">
	<form action='/mytasks/nwsettingsdone.jsp?type=Snapshot' method='post' >
	
		<tr>
		<td class='inputlabel'>Title </td>
		<td class='inputvalue' width='70%'><input type='text' name='themepage.snapshot.title' size='40' value="<%=firstname %>" /></td>
		</tr>
		<tr>
		<td colspan='2' align='center'><input type='submit' name="submit" value="Update"/></td>
		</tr>
	
		<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>	
	</form>

</table>

