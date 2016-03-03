<script>
function generatePdf(groupid){
document.report.action = '/portal/ntspartner/trackingreports.jsp?rtype=fo';
document.report.target = '_blank';
document.report.submit;
return true;
}
function generateExcel(agentid,groupid){ 
document.report.action = '/portal/ntspartner/trackingreports.jsp?rtype=excel';
document.report.target = '_blank';
document.report.submit;
return true;
}
</script>
<%
String width="740";
%>
<form name="report" method="post" action="/ntspartner/excelreports.jsp">
<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>
<input type="hidden" name="GROUPID" value="<%=groupid%>"/>
<input type="hidden" name="trackingcode" value="<%=trackingcode%>"/>



<table class="block" border="0" align="center" width="100%" cols="14">
<tbody>


<tr><td><div />
<%=content.toString()%></div></td></tr>

  <!-- <tr align="center"><td  colspan="14"><table align="center"><tr ><td align="center">
       <input type="submit" name="submit" onClick="javascript:generatePdf(<%=groupid%>,'<%=trackingcode%>');"  value="Export to PDF"/>
       <input type="submit" name="submit" onClick="javascript:generateExcel(<%=groupid%>,'<%=trackingcode%>');" value="Export to Excel"/></td>
  </tr></table></td></tr>-->
       

</tbody>
</table>

</form>
