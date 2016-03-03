<%@ page import="com.eventbee.general.*" %>
<%@ page import="java.util.*,java.io.*" %>

<%
	String file= request.getParameter(".file");
	String action=request.getParameter("submit");
	if("Edit File".equals(action)){ %>
		<jsp:forward page="fileopen.jsp" />
	<%}else{%>
<html>
<body>
<table border='0' cellpadding='5' cellspacing='5' width='100%' align='center'>
<form name='f' action='createfile.jsp' method='post'>
<input type='hidden' name='.file' value='<%=file%>' />
       <% if(!"Create File".equals(action)){ %>
	<tr><td align='center'>
		<B>File Not Exists</B>
	</td></tr>
	<tr><td height='20'></td></tr>
        <tr><td align='center'>
		<input type='submit' name='submit' value='Create File'/>
	</td></tr>
	 <%}else{
	 	File f=new File(file);
		boolean created=false;
		try{
			created=f.createNewFile();
		}catch(Exception e){created=false;}
		if(created){ %>
			<tr><td align='center'><B>File Created Sucessfully</B></td></tr>
			<tr><td height='20'></td></tr>
			<tr><td align='center'>
				<input type='submit' name='submit' value='Edit File'/>
			</td></tr>	
	       <%}else{%>
	       		<tr><td align='center'><B>Sorry., File cannot be created</B></td></tr>
			<tr><td height='20'></td></tr>
			<tr><td align='center'>
				<input type='button' name='button' value='Back' Onclick="javascript:window.location.href='file.jsp'"/>
			</td></tr>
	       <%}%>
	 <%}%>
</form>	
</table>
</body>
</html>
<%}%>
