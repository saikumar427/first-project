<%@ page import="java.io.*, java.util.*,java.sql.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*,com.eventbee.authentication.*" %>
<%
String contextpath="/manager".equals( request.getContextPath() )?"/manager":"/portal"; 
Authenticate authData=AuthUtil.getAuthData(pageContext);

if (authData!=null){
Map newpref=new HashMap();
newpref.put("themepage.snapshot.title", request.getParameter("themepage.snapshot.title") );
PreferencesDB.updatePref(authData.getUserID(), newpref,"themepage.snapshot.title");
}
%>	
<table align="center" width="100%" class='block'>
<tr><td align='center'  class="inform"><%=EbeeConstantsF.get("lifestyle.settings.update.done","Settings updated successfully") %></td></tr>
<tr><td align="center" class="inform"> 
<a href='<%=contextpath %>/mytasks/publicpages.jsp?type=Network'> Back to My Public Pages</a> 
&nbsp;
</td></tr>
</table>

