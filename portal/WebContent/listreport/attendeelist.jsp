<script>
<!--
function generatePdf(ext,appname,groupid){
document.report.action = '/portal/listreport/attendeelist_report.jsp?rtype=fo';
document.report.submit;
return true;
}
function generateExcel(ext,appname,groupid){ 
document.report.action = '/portal/listreport/attendeelist_report.jsp?rtype=excel';
document.report.submit;
return true;
//window.location.href='/portal/listreport/xslreport.jsp';
}

function generate1(appname,groupid,URLBase){
document.report.action =appname+'/'+URLBase+'/selecthw.jsp?GROUPID='+groupid;
document.report.submit;
return true;
}
function generate2(ext,appname,groupid,evtname){
document.report.action =appname+'/mytasks/BulkRegScreen1.jsp?GROUPID='+groupid+'&evtname='+evtname;
document.report.submit;
return true;
}
-->
</script>
<form name="report" method="post" action="<%=appname%>/listreport/excelreports.jsp">
<input type="hidden" name="GROUPID" value="<%=groupid%>"/>
<input type="hidden" name="GROUPTYPE" value="<%=groupname%>"/>
<div STYLE=" height: 500px; width: 840px; font-size: 12px; overflow: auto;">

<table class="block" border="0" align="center" width="100%">
<tbody>
<tr><td><%=content.toString()%></td></tr>
<% if (submitbtn==null){

%>
        <tr><td align="center" >
   	    <input type="submit" name="submit" onClick="javascript:generate2('add','<%=appname%>','<%=groupid%>','<%=evtname%>');" value="Add Attendee"/>
        <input type="submit" name="submit" onClick="javascript:generatePdf('.pdf','<%=appname%>','<%=groupid%>');" value="Export to PDF"/>
        <input type="submit" name="submit" onClick="javascript:generateExcel('.xsl','<%=appname%>','<%=groupid%>');" value="Export to Excel"/>
        <input type="submit" name="submit" onClick="javascript:generate1('<%=appname%>','<%=groupid%>','<%=URLBase%>');" value="Name Tags PDF"/></td>
        </tr>
 <% }
     %>
</tbody>
</table>
</form>
