<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.authentication.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page errorPage="error.jsp"%>

<%
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"renewmembership_selector.jsp","Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
String unitid=null;
    String groupid=null;
    String groupname=null;
    String currentdate=null; 
    int year=0;
    groupid=request.getParameter("groupid");
    groupname=request.getParameter("groupname");
    java.util.Date d=new java.util.Date();
    year=d.getYear()+1900;
    Date date=new Date();	
    SimpleDateFormat format=new SimpleDateFormat("MM/dd/yyyy");
    currentdate=format.format(date);
     Authenticate authData=AuthUtil.getAuthData(pageContext);
    		if (authData!=null){

    			unitid=authData.getUnitID();
		}
%>
<%
request.setAttribute("tasktitle","Membership Renewals");
request.setAttribute("tasksubtitle",currentdate);
request.setAttribute("tabtype","reports");
%>

<script type="text/javascript" language="JavaScript" src="/home/js/calendar.js">
        function dummy(){ }
</script>

<table class="block" border="0" align="center" width="100%">
<form method="post" action="/mytasks/renewmembership_report.jsp">
<input type="hidden" name="groupid" value="<%=groupid%>"/>
<input type="hidden" name="groupname" value="<%=groupname%>"/>
<input type="hidden" name="UNITID" value="<%=request.getParameter("UNITID")%>">
<input type="hidden" name="unitid" value="<%=unitid%>"/>
<input type="hidden" name="landf" value="yes">
<tr>
<td align="right"><input type="radio" name="selindex" value="1" checked="true"/></td><td>Till Date</td>
</tr>
<tr>
<td align="right" width="40%"><input type="radio" name="selindex" value="2"/></td><td>Start Date
 <%=EventbeeStrings.getMonthHtml("","startMonth","","")%><%=EventbeeStrings.getDayHtml("","startDay","","")%>
<%=EventbeeStrings.getYearHtml(year-1,3,0,"startYear","","")%>
<a href="#" onClick="return CalanderPop(document.forms[0].elements['startMonth'], document.forms[0].elements['startDay'], document.forms[0].elements['startYear'],'No','Yes');"><img src="/home/images/calendar.gif" width="26" height="19" alt="" border="0" class="button"/></a>
</td>
</tr>
<tr>
<td align="left"></td><td>End Date
<%=EventbeeStrings.getMonthHtml("","endMonth","","")%>
<%=EventbeeStrings.getDayHtml("","endDay","","")%>
<%=EventbeeStrings.getYearHtml(year-1,3,0,"endYear","","")%>
<a href="#" onClick="return CalanderPop(document.forms[0].elements['endMonth'], document.forms[0].elements['endDay'], document.forms[0].elements['endYear'],'No','Yes');"><img src="/home/images/calendar.gif" width="26" height="19" alt="" border="0" class="button"/></a>
</td>
</tr>
<tr>
<td colspan="2" align="center"><input type="submit" name="sub" value="Submit"/></td>
</tr>
</form>
</table>

