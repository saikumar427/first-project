<tr><td id='showdonemessages' colspan='<%=al.size()%>' align='center'>
<% if(request.getParameter("MID")!=null&&!"".equals((request.getParameter("MID")).trim())){
	out.println(EbeeConstantsF.get(request.getParameter("MID"),"Done Successfully"));
}%>
</td></tr>

<tr align="left">
<%
	border=("Yes".equals(border))?"beelettable":border;
	int maxcols=al.size();
	for(int i=1; i<=maxcols; i++){
		String[] colarr=(String[])colmap.get("col"+i);
		if(colarr !=null){
			String colwidth=(String)colmap.get("col"+i+"width");
			if(colwidth==null)colwidth="25%";
%>
			<td valign="top" align="left" width='<%=colwidth%>'>
			<table  border="0" width='100%' cellspacing="0" cellpadding="0"  valign="top" align="left">

<%
			for(int j=0; j<colarr.length; j++){
%>
				<jsp:include page="<%=PageUtil.getSpecificUrl( urlmapping, colarr[j]) %>" >
	 			<jsp:param name="width" value="<%=colwidth%>"/>
	 			<jsp:param name="border" value="<%=border%>"/>
	 			<jsp:param name="frompagebuilder" value="true"/>
				<jsp:param name='Dummy_ph' value='' /></jsp:include>
<%
			}//end of null
%>

			</table>
			</td>
<%
			if(i<maxcols)
				out.println("<td width='10'><img src='/home/images/spacer.gif' width='10'/></td>");
 		}
	}//end main for
%>
</tr>

