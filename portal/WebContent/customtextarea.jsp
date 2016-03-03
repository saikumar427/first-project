<%@ page import="com.eventbee.general.formatting.*,java.io.*,java.io.*" %>
<%@ page import="com.eventbee.general.*,java.sql.*,java.io.File,java.io.RandomAccessFile,java.io.IOException"%>
<!--link href="../sample.css" rel="stylesheet" type="text/css" /-->
<script type="text/javascript" src="/fckeditor/fckeditor.js"></script>
<script type="text/javascript">

function FCKeditor_OnComplete( editorInstance )
{
window.status = editorInstance.Description ;
}

</script>
	<%
		String nameoftextarea=request.getParameter("textareaname");
		if(nameoftextarea ==null)nameoftextarea="mytextarea";
		String height=(request.getParameter("height")!=null)?request.getParameter("height") :"400";
		String width=(request.getParameter("width")!=null)?request.getParameter("width") :"100%";
	%>
<%
BufferedReader in=new BufferedReader(new InputStreamReader(new StringBufferInputStream((String)request.getAttribute("customtextareacontent"))));
String s=null;
String str="";
%>
<script type="text/javascript">
<!--
// Automatically calculates the editor base path based on the _samples directory.
// This is usefull only for these samples. A real application should use something like this:
// oFCKeditor.BasePath = '/fckeditor/' ;	// '/fckeditor/' is the default value.
var sBasePath ='/fckeditor/';
//document.location.pathname.substring(0,document.location.pathname.lastIndexOf('/home/FCKeditor/')) ;


var oFCKeditor = new FCKeditor( '<%=nameoftextarea %>' ) ;
oFCKeditor.BasePath	= sBasePath ;
oFCKeditor.Width='<%=width %>';
oFCKeditor.Height='<%=height %>';
oFCKeditor.ToolbarSet='ebeecustom';
oFCKeditor.Value	= '' ;
if(!oFCKeditor._IsCompatibleBrowser()){
document.write( '<input type="hidden" name="textareatype" value="text" />' ) ;
}else{
document.write( '<input type="hidden" name="textareatype" value="wysiwyg" />' ) ;
}
<%
while ((s=in.readLine())!=null){
s=s.replaceAll("'", "\\\\'");
%>
oFCKeditor.Value+= '<%=s%>'+'\n' ;
<%}
in.close();

%>
oFCKeditor.Create() ;
//-->
</script>

