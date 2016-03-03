<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.authentication.*,com.customattributes.*,com.eventbeepartner.partnernetwork.AttendeeListReports" %>
<script >
function dummy() { }
function generate1(){
	document.report.action ='/portal/listreport/attendeelabels.jsp?rtype=fo';
	document.report.submit();
	return true;
}
</script>
<%
	String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";
	String appliation_name=EbeeConstantsF.get("application.name","Eventbee");
	String linkpath="http://"+EbeeConstantsF.get("serveraddress","www.beeport.com")+"/home/links";
	request.setAttribute("tasktitle","Name Tags PDF");
	request.setAttribute("tasksubtitle","Settings");
	String [] fonttypes={"Arial","Arial Black","sans-serif"};
	String [] fontsizes={"8","10","12","14","16","18","20","22","24","26","28","30"};
	
	   String custom_setid=CustomAttributesDB.getAttribSetID(request.getParameter("groupid"),"EVENT");
	      AttendeeListReports reports=new AttendeeListReports();   
 
	    List list=reports.getAttributes(custom_setid);
  
	
	
%>
<table border="0" width="100%" cellpadding="0" cellspacing="0" class="block">
<form name="report" method="post" action="/portal/listreport/attendeelabels.jsp" >
<input type="hidden" name="groupid" value="<%=request.getParameter("groupid")%>"/>

<tr><td colspan="2" height="5"></td></tr>
<tr>
<td valign="top" width="20%" class="inputlabel" height='30'>Select Fields</td><td><table><tr><td>Name</td></tr>
<%if(list!=null && list.size()>0){ for(int k=0;k<list.size();k++){
%>
<tr><td><input type="checkbox" name="customattrib" value="<%=list.get(k)%>"><%=list.get(k)%></td></tr>
<%}}%>

</table></td>
</tr>
<tr><td colspan="2" height="5"></td></tr>
<tr>
<td valign="top" width="20%" class="inputlabel" height='30'>Page Size</td>
<td width='10%' > Width</td><td width='15%'> <input name="pagewidth" value="8.5" size='5'/> inches </td><td width='10%'> Height </td><td width='15%'><input name="pageheight" value="11.0" size='5' /> inches </td>
</tr>
<tr>
<td valign="top" width="20%" class="inputlabel" height='30'>Page Margin</td>
<td colspan='4' width='100%'><table width="100%"><tr>
<td width='10%'>Top</td><td width='15%'><input name="topmargin" value="0.5" size='5'/> inches </td><td width='10%'> Bottom </td><td width='15%'><input name="bottommargin" value="0.5" size='5' /> inches </td>
</tr><tr>
<td width='10%'>Left</td><td width='15%'><input name="leftmargin" value="0.25" size='5'/> inches </td><td width='10%'> Right </td><td width='15%'><input name="rightmargin" value="0.25" size='5' /> inches </td>
</tr>
</table></td></tr>
<tr>
<td valign="top" width="20%" class="inputlabel" height='30'>Name Tag Size</td>
<td width='10%'> Width</td><td width='15%'> <input name="colwidth" value="4.0" size='5'/> inches </td><td width='10%'> Height </td><td width='15%'><input name="colheight" value="2.0" size='5' /> inches </td>
</tr>
<tr>
<td valign="top" width="20%" class="inputlabel" height='30' >Name Font Settings</td>
<td width='10%'> Font Type</td><td width='15%'>
<%=WriteSelectHTML.getSelectHtml(fonttypes,fonttypes,"line1fontfamily","",null,null)%></td><td width='10%'> Font Size </td><td width='15%'><%=WriteSelectHTML.getSelectHtml(fontsizes,fontsizes,"line1fontsize","20",null,null)%></td>
</tr>
<tr>
<td valign="top" width="20%" class="inputlabel" height='30'>Other Font Settings</td>
<td width='10%'> Font Type</td><td width='15%'> <%=WriteSelectHTML.getSelectHtml(fonttypes,fonttypes,"line2fontfamily","",null,null)%></td><td width='10%'> Font Size </td><td width='15%'><%=WriteSelectHTML.getSelectHtml(fontsizes,fontsizes,"line2fontsize","16",null,null)%> </td>
</tr>
<tr><td colspan="2" height="5"></td></tr>
<tr>
<td colspan="8" align="center">
<%System.out.println((HashMap)request.getAttribute("REQMAP")+"");%>
<%= com.eventbee.general.PageUtil.writeHiddenCore( (HashMap)request.getAttribute("REQMAP") )%>
	<input type="submit" name="submit" value="Continue" OnClick="JavaScript:generate1()"  />
	<input type="button" name="back" value="Back" OnClick="JavaScript:history.back()" />

</td>
</tr>
</form>
</table>
