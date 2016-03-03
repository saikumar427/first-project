<%@ page import="java.util.*,java.sql.*,com.eventbee.general.EventbeeConnection,com.eventbee.general.formatting.*" %>
<html>

<script language='javascript'>
function changeDB(){
document.form.dbquery.value='';
document.form.submit();
}
</script>
<body>
<%

String [] DB_codes={"PostgresDS","RollerDb"};
String [] DB_names={"General","Roller"};

String selectedDB=request.getParameter("db_name");
if(selectedDB==null||"".equals(selectedDB))
selectedDB=DB_codes[0];


%>



<form action="dbquery.jsp" method="post" name="form">
<table border="0" width="100%" align="center"  class="innerbeelet" cellspacing="0">


<tr>
	<td width="10%" align="center" ><font face="verdana">Database</font></td>
	<td>
		<%=WriteSelectHTML.getSelectHtml(DB_names,DB_codes,"db_name",selectedDB,null,null,"onchange='changeDB()'" )%>
	</td>
</tr>



<tr>
     <td width="10%" align="center"><font face="verdana">Query</font></td>
     <td width="90%" align="left">
        <%
        	String isquery=request.getParameter("dbquery");
        	if(isquery==null)isquery="";
        %>
	<textarea cols="100" rows="4" name="dbquery"><%=isquery%></textarea>
</td></tr>
<tr><td colspan="2" height="20"></td></tr>
<tr>
	<td align="left" colspan="2">
		<input align="left" type="submit" value="Execute"/>		
	</td>

</tr>
<tr><td colspan="2" height="20"><font face="verdana"><A href="dbquery.jsp?req=all&db_name=<%=selectedDB%>">All Tables</A></font></td></tr>
<tr><td colspan="2" height="20"><font face="verdana"><A href="dbquery.jsp?req=all&cnt=yes&db_name=<%=selectedDB%>">All Tables with count</A></font></td></tr>
<tr><td colspan="2" height="20"></td></tr>
<tr width="100%"><td colspan="2">	
	<%@ include file="processdb.jsp" %>
</td></tr>

</table>
</form>
</body>
</html>

