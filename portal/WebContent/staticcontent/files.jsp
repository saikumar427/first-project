<%@ page import= "com.eventpageloader.StaticEventPageManager"%>
<%@ page import= "java.util.*"%>
<%
	String name=request.getParameter("deletefile");
	if(name!=null){
		StaticEventPageManager.deleteFile(name);
	}
	String pagename=request.getParameter("pagename");
	String filecontent=request.getParameter("filecontent");
	
	if(pagename!=null && filecontent!=null){
		StaticEventPageManager.createFile(pagename,filecontent);
	}
%>
<html>
<head>
<script language="javascript">
	function deleteFile(key){
		document.deletefile_form.deletefile.value=key;
		document.deletefile_form.submit();
	}
</script>
</head>
<body>

<table border="1">
<tr>
<td valign="top">
<table>
<form name="deletefile_form" action="">
<%
	try{
		StaticEventPageManager.reload();		
		HashMap filesmap=StaticEventPageManager.getAllFiles();
		Set keys = filesmap.keySet();
		Iterator iter = keys.iterator();
		while (iter.hasNext()) {
			String key = (String) iter.next();
			out.println("<tr>");
			out.println("<td>"+key+"</td>");
			out.println("<td><input type='button' value='Delete' onclick=deleteFile('"+key+"')></td>");
			out.println("</tr>");
		}
	}catch(Exception e){
		System.out.println("Exception: "+e);
	}
%>
<input type="hidden" name="deletefile">
</form>
</table>
</td>
<td valign="top">
	<table>
	<form name="createfile_form" action="" method="post">
		<tr>
			<td colspan="2" align="center"><b>Add Page</b></td>
		</tr>
		<tr>
			<td>Page Name</td>
			<td><input type="text" name="pagename"></td>
		</tr>
		<tr>
			<td colspan="2">Content</td>
		</tr>
		<tr> 
			<td colspan="2">
				<textarea rows="50" cols="100" name="filecontent">
				</textarea>
			</td>
		</tr>
		<tr>
		<td colspan="2" align="center">
			<input type="submit" value="Create">
		</td>
		</tr>
		</form>
	</table>
	
</td>
</tr>
</table>
</html>