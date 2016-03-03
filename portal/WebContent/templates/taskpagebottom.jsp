
<tiles:insert definition=".taskpage" flush="true" >
<tiles:put name="mytabs"         value="/main/mytabsmenu.jsp" />
<%
	if(!"".equals(footerpage))
	{
%>
		<tiles:put name="footer" value="<%=footerpage%>"  />
<%
	}
%>
<tiles:put name="content" value="<%=taskpage%>"  />
</tiles:insert>


