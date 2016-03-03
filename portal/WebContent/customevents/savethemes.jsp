<%@ page import="java.util.*,com.eventbee.authentication.*,com.eventbee.general.*,com.themes.ThemeController"%>
<%!
String CLASS_NAME="customevents/savethemes.jsp";

%>

<script language="JavaScript" type="text/javascript">
function formvalidator(theForm)
{
	var value=theForm.themename.value;
	if(theForm.themename.length>0){
		if(theForm.themename[0].checked==true)
		{
			value=theForm.themename[0].value;
		}
	}
	if(value=='new'&&theForm.theme.value==''){
		alert("Theme name is empty");
		return false;
	}else
		return true;
}
</script>

<%
String userid="";
Authenticate authData=AuthUtil.getAuthData(pageContext);
String modulename=request.getParameter("type");
if(modulename==null||"".equals(modulename))modulename="event";
if(authData !=null){
	userid=authData.getUserID();
}
Vector v=new Vector();
ThemeController.getCustomPosterData(v,userid,modulename);
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"userid---"+userid,"",null);
String eventid=request.getParameter("GROUPID");

%>

<html>
<body>

<form name="customtheme" method="get" action="/customevents/customthemes" onsubmit="return formvalidator(this)">
<input type='hidden' name='type' value="<%=request.getParameter("type") %>" />
<input type='hidden' name='frompage' value='eventpages' />
<input type='hidden' name='themeid' value='<%=request.getParameter("themeid") %>' />
<input type='hidden' name='themetype' value='<%=request.getParameter("themetype") %>' />
<input type='hidden' name='evtname' value='<%=request.getParameter("evtname") %>'  />		
<input type='hidden' name='GROUPID' value="<%=request.getParameter("GROUPID") %>" />

<table  width="100%"  columns=2 class='block'>

<tr><td class='inputlabel' colspan="1" width="45%" valign='top'>Select Existing Theme OR Save as a New Theme</td><td><table><tr><td>
		<td>
		
		<%
		if(v.size()>0){
		%>
		<input type="radio" name="themename"  value='new' checked="true" /> 
		<%}else{%>
		<input type='hidden' name='themename' value="new" />
		<%}%>
		New Theme Name <input type="text" name="theme" /></td>
		</tr>

<%
if(v.size()>0){
for(int i=0;i<v.size();i++){
HashMap hm=(HashMap)v.elementAt(i);
%>

<tr><td></td>
<td><input type="radio" name="themename" value="<%=(String)hm.get("themeid")%>"/>
<%=GenUtil.getHMvalue(hm,"themename","")%></td>
</tr>
<%}%>
<%}%>
</table></td></tr>

<tr><td></td>
</tr>
<tr><td colspan='2' align='center'><input type="submit" value="Save" name="submit"/><input type="button"  value="Back" onClick="javascript:window.history.back()"/>
</td></tr>
</table>
<%= com.eventbee.general.PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP"))%>
</table>
</form>
</body>
</html>





