<%@ page import="java.util.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>




<%@ include file="/main/tabsheader.jsp" %>


<%

String modulename[]={"groupevent","network","photo","event","hub","hubspage","attendeepage","eventspage","hubpage","event_fb","attendeepage_fb","eventspage_ning","event_ning","groupevent_ning"};

%>


<form  method="post" action="thememanager.jsp" >
<!--input type='hidden' name='UNITID' value='13579'-->
<table width='70%'  cellspacing="0" cellpadding="0" align='center'>
<tr> <td height='50' ></td></tr>
<tr >
<td >Module:      
<%=WriteSelectHTML.getSelectHtml(modulename,modulename,"modulename","",null,null,"")%>
</td>
</tr>
<tr height='5'></tr>
<tr><td><input type='submit' name='submit' value='Submit' /></td></tr>
</table>
</form>


<%@ include file="/main/footer.jsp" %>



