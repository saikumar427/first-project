<%@ page import="com.eventbee.general.*" %>
<%@ page import="java.util.*,java.io.*" %>
<%
	if(session.getAttribute("authDatauttool")==null){
		response.sendRedirect("login.jsp?usereq=fileopen");
		return;
	}
%>
<jsp:include page="fileredirector.jsp" />
<%
	String file= request.getParameter(".file");
	if(file!=null){
	
	File f=new File(file);
	if(!f.exists()){ System.out.println(" f.exists(): "+f.exists()); %>
		<jsp:forward page="createfile.jsp" />	
<%	}else{
	char content[]=new char[(int)f.length()];
	FileReader fr=new FileReader(f);
	
	int file_chars=fr.read(content,0,(int)f.length());
	String filecontent=new String(content);
	fr.close();
	
%>
<html>
<body>
<table border='0' cellpadding='5' cellspacing='5' width='100%' align='center'>
<form name='f' action='filewriter.jsp' method='post'>
<input type='hidden' name='.file' value='<%=file%>' />
	<tr>
		<td><font color='blue'><B>File Path:</B></font><font color='red'><%=f.getAbsolutePath()%></font></td>
	</tr>
	<tr>
		<td>
		<table border='0' cellpadding='0' cellspacing='0' width='100%'>
		<tr>
			<td><b>Server:</b><%=request.getServerName()%>:<%=request.getServerPort()%></td>
			<td><b>Remote Address:</b><%=request.getRemoteHost()%>(<%=request.getRemoteAddr()%>)</td>
			<td><b>Length:</b><%=f.length()%> Bytes</td>
		</tr>	
		</table>	
		</td>
	</tr>
	<tr>
		<td>
		<table border='0' cellpadding='0' cellspacing='0' width='100%'>
		<tr>
			<td><b>is Writable:</b><%=(f.canWrite())?"Yes":"No"%></td>
			<td><b>Last Modified:</b><%=new Date(f.lastModified())%></td>
			<td><b>Length:</b><%=f.length()%> Bytes</td>
		</tr>	
		</table>	
		</td>
	</tr>
	<tr>	
		<td>
		<table border='0' cellpadding='0' cellspacing='0' width='100%'>
		<tr>
			<td><textarea cols='125' rows='35' name='filecontent'><%=GenUtil.getEncodedXML(filecontent)%></textarea></td>
			<td valign='top'>
				<input type='submit' name='submit' value='  Save  ' title='Modify & Save ' /> 
			</td>
		</tr>
		</table>
		</td>
	</tr>	
</form>	
</table>
</body>
</html>
<%}}%>
