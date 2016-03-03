<script>
function generatePdf(ext,agentid,groupid){
document.report.action = '/portal/listreport/partner_reports.jsp?rtype=fo';
document.report.submit;
return true;
}
function generateExcel(ext,agentid,groupid){ 
document.report.action = '/portal/listreport/partner_reports.jsp?rtype=excel';
document.report.submit;
return true;
}
</script>

<form name="report" method="post" action="/listreport/excelreports.jsp">
<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>
<input type="hidden" name="GROUPID" value="<%=groupid%>"/>


<input type="hidden" name="agentid" value="<%=request.getParameter("agentid")%>"/>
<div STYLE=" height: 500px; width: 840px; font-size: 12px; overflow: auto;">
<table class="block" border="0" align="center" width="100%" cols="11">
<tbody>


<tr><td><%=content.toString()%></td></tr>


   <tr align="center"><td  colspan="11"><table align="center"><tr ><td align="center">
       <input type="submit" name="submit" onClick="javascript:generatePdf('.pdf','<%=agentid%>','<%=groupid%>');" value="Export to PDF"/>
       <input type="submit" name="submit" onClick="javascript:generateExcel('.xsl','<%=agentid%>','<%=groupid%>');" value="Export to Excel"/></td>
  </tr></table></td></tr>
       

</tbody>
</table>
</div>
</form>
