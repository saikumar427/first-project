<%@ page import="java.util.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>

<%!

String DEFTHEMESQ="select themename, themecode from ebee_roller_def_themes where module=? order by themename ";


String INSERTDEFTHEME="insert into ebee_roller_def_themes(module ,themecode,themename,defaultcontent ,cssurl ) values(?,?,?,?,?)";
%>




<%@ include file="/main/tabsheader.jsp" %>

<table width='70%'  cellspacing="0" cellpadding="0" align='center'>
<tr class='colheader'>
<td>Theme Name</td>
<td>Theme Code</td>
<td>Edit</td>
<td>Delete</td>
</tr>

<%

String modulename=request.getParameter("modulename");

if(modulename==null||"".equals(modulename)){
modulename="lifestyle";
}

	
	DBManager dbmanager=new DBManager();
	StatusObj statobj=dbmanager.executeSelectQuery( DEFTHEMESQ,new String[]{modulename});
	int recount=0;
	if(statobj !=null && statobj.getStatus() && (recount=statobj.getCount())>0){
	
		for(int i=0;i<recount;i++){
			out.println("<tr>");
		
		out.println("<td>");out.println(dbmanager.getValue(i,"themename","") );out.println("</td>");
		out.println("<td>");out.println( dbmanager.getValue(i,"themecode","") );out.println("</td>");
		out.println("<td>");out.println( "<a href='managetheme.jsp?act=edit&modulename="+modulename+"&themecode="+dbmanager.getValue(i,"themecode","")+"' >Edit </a>" );out.println("</td>");
		out.println("<td>");out.println( "<a href='managetheme.jsp?act=delete&modulename="+modulename+"&themecode="+dbmanager.getValue(i,"themecode","")+"' >Delete </a>" );out.println("</td>");
			
			out.println("</tr>");
		 
		}
		
		
		
		
	}else{
	 out.println("<tr><td colspan='5'>No Existing themes</td></tr>");
	
	}

	out.println("<tr><td colspan='5' align='center'> <a href='managetheme.jsp?act=add&modulename="+modulename+"'>Add New Theme</a></td></tr>");

%>
</table>


<%@ include file="/main/footer.jsp" %>
