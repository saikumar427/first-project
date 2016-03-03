<script>

function generatePdf(ext){
document.report.action ='/portal/listreport/membership_report.jsp?rtype=fo';
document.report.submit;
return true;
}
function generateExcel(ext){ 

document.report.action = '/portal/listreport/membership_report.jsp?rtype=excel';
document.report.submit;
return true;

}
<%

%>
</script>
<form name="report" method="post" >
<input type="hidden" name="unitid" value="<%=unitid%>"/>
<input type="hidden" name="groupid" value="<%=groupid%>"/>
<input type="hidden" name="groupname" value="<%=groupname%>"/>
<input type="hidden" name="selindex" value="<%=selindex%>"/>

<input type="hidden" name="startMonth" value="<%=request.getParameter("startMonth")%>"/>
<input type="hidden" name="startDay" value="<%=request.getParameter("startDay")%>"/>
<input type="hidden" name="startYear" value="<%=request.getParameter("startYear")%>"/>

<input type="hidden" name="endMonth" value="<%=request.getParameter("endMonth")%>"/>
<input type="hidden" name="endDay" value="<%=request.getParameter("endDay")%>"/>
<input type="hidden" name="endYear" value="<%=request.getParameter("endYear")%>"/>

<table class="block" border="0" align="center" width="100%" cols="10" >

<tbody>
<tr><td><%=content.toString()%></td></tr>

<% if (submitbtn==null){ %>
   <tr><td align="center" colspan="11">
       <input type="submit" name="submit" onClick="javascript:generatePdf('.pdf');" value="Export to PDF"/>
      <input type="submit" name="submit" onClick="javascript:generateExcel('.xsl');" value="Export to Excel"/></td>
  </tr>
 <% }
   %>
<% if (tv==null){ %>
<tr>
<td colspan="11" align="center">No membership renewals </td>
</tr>
<% } %>
</tbody>
</table>
</form>
