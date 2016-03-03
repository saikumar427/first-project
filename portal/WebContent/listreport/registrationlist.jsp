

<form name="report" method="post" action="/portal/listreport/excelreports.jsp">
<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>
<input type="hidden" name="groupid" value="<%=groupid%>"/>
<input type="hidden" name="groupname" value="<%=groupname%>"/>

<input type="hidden" name="startDay" value="<%=request.getParameter("startDay")%>"/>
<input type="hidden" name="startYear" value="<%=request.getParameter("startYear")%>"/>
<input type="hidden" name="selindex" value="<%=selindex%>"/>
<input type="hidden" name="startMonth" value="<%=request.getParameter("startMonth")%>"/>
 <input type="hidden" name="attendee" value="<%=request.getParameter("attendee")%>"/>
<input type="hidden" name="key" value="<%=request.getParameter("key")%>"/>
	
		

<%if(request.getParameter("agentid")!=null){%>
<input type="hidden" name="agentid" value="<%=request.getParameter("agentid")%>"/>
<%}%>
<input type="hidden" name="endMonth" value="<%=request.getParameter("endMonth")%>"/>
<input type="hidden" name="endDay" value="<%=request.getParameter("endDay")%>"/>
<input type="hidden" name="endYear" value="<%=request.getParameter("endYear")%>"/>
<div STYLE=" height: 500px; width: 840px; font-size: 12px; overflow: auto;">
<table class="block" border="0" align="center" width="100%" cols="11">
<tbody>


<tr><td><%=content.toString()%></td></tr>


<%if (submitbtn==null){ %>
   <tr align="center"><td  colspan="11"><table align="center"><tr ><td align="center">
       <input type="submit" name="submit" onClick="javascript:generatePdf('.pdf','<%=groupid%>');" value="Export to PDF"/>
       <input type="submit" name="submit" onClick="javascript:generateExcel('.xsl','<%=groupid%>');" value="Export to Excel"/></td>
  </tr></table></td></tr>
 <% }%>
      

</tbody>
</table>
</div>
</form>
