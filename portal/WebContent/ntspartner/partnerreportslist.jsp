<script>
function generatePdf(agentid,groupid){
document.report.action = '/portal/ntspartner/partner_reports.jsp?rtype=fo';
document.report.target = '_blank';
document.report.submit;
return true;
}
function generateExcel(agentid,groupid){ 
document.report.action = '/portal/ntspartner/partner_reports.jsp?rtype=excel';
document.report.target = '_blank';
document.report.submit;
return true;
}
</script>
<%
String width="740";
if("ning".equals(platform)){
width="680";
}
%>
<form name="report" method="post" action="http://www.eventbee.com/ntspartner/excelreports.jsp">
<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>
<input type="hidden" name="GROUPID" value="<%=groupid%>"/>


<input type="hidden" name="agentid" value="<%=request.getParameter("agentid")%>"/>

<table class="block" border="0" align="center" width="100%" cols="11">
<tbody>


<tr><td><div  STYLE=" height: 300px; width: <%=width%>px; font-size: 12px; overflow: auto;"/>
<%=content.toString()%></div></td></tr>

<%if(!"ning".equals(platform)){%>
   <tr align="center"><td  colspan="11"><table align="center"><tr ><td align="center">
       <input type="submit" name="submit" onClick="javascript:generatePdf(<%=agentid%>,<%=groupid%>);"  value="Export to PDF"/>
       <input type="submit" name="submit" onClick="javascript:generateExcel(<%=agentid%>,<%=groupid%>);" value="Export to Excel"/></td>
  </tr></table></td></tr>
       
<%}%>
</tbody>
</table>
</div>
</form>
