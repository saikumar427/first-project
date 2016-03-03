<%@ page import="java.text.*,com.eventbee.general.formatting.*,com.eventbee.general.PageUtil"%>
<%@ page import="com.eventbee.authentication.*" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.*"%>
<%
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"sales_selector.jsp","Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
     String currentdate1=null;
     int year=0;
     java.util.Date d=new java.util.Date();
     year=d.getYear()+1900;
     Date date=new Date();
     SimpleDateFormat format=new SimpleDateFormat("MM/dd/yyyy");
     currentdate1=format.format(date);
     String unitid=null;
     Authenticate authData=AuthUtil.getAuthData(pageContext);
		if (authData!=null){
			unitid=authData.getUnitID();
		}
DateFormat DATEFORMAT=new SimpleDateFormat("MM/dd/yyyy");
java.util.Date dt=new java.util.Date();
String currentdate=DATEFORMAT.format(dt);


	%>

<script language = "Javascript">
function ValidateForm(){
	var syear=document.frmSample.startYear
	var eyear=document.frmSample.endYear

	if (syear.value>eyear.value){
		alert('Start year should be less than end year')
		return false
	}
    return true
 }

</script>
<%
String groupid=request.getParameter("groupid");


%>
<table align="center" border='0' class='block'>

<form name="frmSample" action='/mytasks/sales_report.jsp' method='post' onSubmit="return ValidateForm()">
<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>
<input type='hidden' name='landf' value='yes'>
<input type='hidden' name='groupid' value='<%=groupid%>'>

<tr>
<td align="right"   ><input type="radio" name="selindex" value="1" checked="true"/></td>
<td width="40%">All Time (Since 01-01-2005)</td>
</tr>

<tr>
<td align="right" width="20%"><input type="radio" name="selindex" value="2"/></td>
<td>Start Date
 <%=EventbeeStrings.getMonthHtml("","startMonth","","")%>
<%=EventbeeStrings.getYearHtml(year-1,3,0,"startYear","","")%>

</td>
</tr>
<tr>
<td align="center"></td><td align="left">End Date
<%=EventbeeStrings.getMonthHtml("","endMonth","","")%>

<%=EventbeeStrings.getYearHtml(year-1,3,0,"endYear","","")%>

</td>
</tr>
<tr height='10'></tr>
<tr><td align='center' colspan='2'>
<input type='button' name='bbb' value='Back' onClick='javascript:history.back()' />&nbsp
<input type='submit' value="Go"></td></tr>


</form>
</table>