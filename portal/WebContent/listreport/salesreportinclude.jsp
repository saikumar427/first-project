<script>
<!--
function generatePdf(ext){
document.report1.action = '/portal/listreport/sales_reports.jsp?rtype=fo';
document.report1.submit;
return true;
}
function generateExcel(ext){ 

document.report1.action = '/portal/listreport/sales_reports.jsp?rtype=excel';
document.report1.submit;
return true;
//window.location.href='/portal/listreport/xslreport.jsp';
}
</script>

<form name="report1" method="post" action="/listreport/sales_reports.jsp">
<input type="hidden" name="unitid" value="<%=unitid%>"/>
<input type="hidden" name="groupid" value="<%=groupid%>"/>
<input type="hidden" name="UNITID" value="13579"/>
<input type="hidden" name="startMonth" value="<%=startMonth%>"/>
<input type="hidden" name="startYear" value="<%=startYear%>"/>
<input type="hidden" name="endMonth" value="<%=endMonth%>"/>
<input type="hidden" name="endYear" value="<%=endYear%>"/>
<input type="hidden" name="selindex" value="<%=selindex%>"/>
<table border='0' align='center' width="100%" cols="12">
<tbody>
<tr><td><%=content.toString()%></td></tr>
<% if (submitbtn==null){ %>
        <tr><td align="center" colspan="8">
   	    
        <input type="submit" name="submit" onClick="javascript:generatePdf('.pdf');" value="Export to PDF"/>
        <input type="submit" name="submit" onClick="javascript:generateExcel('.xsl');" value="Export to Excel"/>
        
        </tr>
 <% }
     %>
</tbody>
</table>
</form>
