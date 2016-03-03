<%@ page import="java.util.*,com.eventbee.general.*,com.themes.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>

<%!
String DEFTHEMESQ="select themename, themecode from ebee_roller_def_themes where module='lifestyle' order by themename ";


String THEMECONTBYTHEMECODE="select themename,defaultcontent ,cssurl from ebee_roller_def_themes where module=? and themecode=?";

String THEMEDELETEQUERY="delete from ebee_roller_def_themes where module=? and themecode=?";



String THEMEINSERTQUERY="insert into ebee_roller_def_themes(module ,themecode,themename,defaultcontent ,cssurl ) values (?,?,?,?,? )";

String THEMEEXISTSQUERY="select themename from ebee_roller_def_themes where module=? and themecode=?";




public Map getThemes(){
	Map thememap=new HashMap();
	DBManager dbmanager=new DBManager();
	StatusObj statobj=dbmanager.executeSelectQuery( DEFTHEMESQ,null);
	int recount=0;
	if(statobj !=null && statobj.getStatus() && (recount=statobj.getCount())>0){
	String[] themenames=new String[recount];
	String[] themevals=new String[recount];
	
		for(int i=0;i<recount;i++){
			themenames[i]=dbmanager.getValue(i,"themename","");
			themevals[i]=dbmanager.getValue(i,"themecode","");
		 
		}
		
		thememap.put("themenames",themenames);
		thememap.put("themevals",themevals);
		
		
		
	}
	return thememap;
	}
	
	
	
	public String[] getTheme(String themecode, String modulename){
		String[] themevals=new String[]{"","",""};
		
		if(themecode!=null && !"".equals(themecode.trim()) ){
			DBManager dbmanager=new DBManager();
			StatusObj statobj=dbmanager.executeSelectQuery( THEMECONTBYTHEMECODE,new String[]{modulename,themecode.trim()} );
			int recount=0;
			if(statobj !=null && statobj.getStatus() && (recount=statobj.getCount())>0){
			//themename,defaultcontent ,cssurl
				themevals[2]=dbmanager.getValue(0,"themename","");
				themevals[1]=dbmanager.getValue(0,"defaultcontent","");
				themevals[0]=dbmanager.getValue(0,"cssurl","");
			}
		
		}
		return themevals;
	}
	

%>

<%
String modulename=request.getParameter("modulename");

String filepath=EbeeConstantsF.get("usertheme.file.path","C:\\jboss-3.2.2\\server\\default\\deploy\\home.war\\userthemes\\");
if(modulename==null||"".equals(modulename)){
modulename="lifestyle";
}


String themename="";
String themecode="";
String csscontent="";
String themecontent="";


boolean displaycontblock=false;

boolean displaymessage=false;
String message="" ;


String act =request.getParameter("act");
themecode=(request.getParameter("themecode")!=null)?request.getParameter("themecode"):"";


 
if("delete".equalsIgnoreCase(act) ){
	
	DbUtil.executeUpdateQuery(THEMEDELETEQUERY,new String[]{modulename,request.getParameter("themecode").trim() }, null);
	response.sendRedirect("thememanager.jsp?message=deleted&modulename="+modulename);
	return;
	

}else{
	displaycontblock=true;
	
	String submit=request.getParameter("submit");
	
	if(submit==null){
		displaycontblock=true;
		if("edit".equalsIgnoreCase(act) ){
			
			String[] themevals=getTheme(themecode,modulename);
			csscontent=themevals[0];
			themecontent=themevals[1];
			themename=themevals[2];
		}
	}else{
		displaycontblock=false;
		if("edit".equalsIgnoreCase(act) ){
			DbUtil.executeUpdateQuery(THEMEDELETEQUERY,new String[]{modulename,request.getParameter("themecode").trim() }, null);
			//themecode,themename,defaultcontent ,cssurl
			DbUtil.executeUpdateQuery(THEMEINSERTQUERY,new String[]{modulename,
							request.getParameter("themecode").trim(),
							request.getParameter("themename").trim(),
							request.getParameter("themecont").trim(),
							request.getParameter("csscont").trim()
			}, null);
			//out.println("update db");
			ThemeFileController.createFiles(request.getParameter("csscont").trim(),modulename+"/DEFAULT/"+request.getParameter("themecode").trim(),".css");
			response.sendRedirect("thememanager.jsp?message=updated&modulename="+modulename);
			return;
		}
		if("add".equalsIgnoreCase(act) ){
			csscontent=request.getParameter("csscont").trim();
			themecontent=request.getParameter("themecont").trim();
			themename=request.getParameter("themename").trim();
			themecode=request.getParameter("themecode").trim();
			
			String themeexists=DbUtil.getVal(THEMEEXISTSQUERY,new String[]{modulename,request.getParameter("themecode").trim()} );
			if(themeexists==null){
				DbUtil.executeUpdateQuery(THEMEINSERTQUERY,new String[]{modulename,
							request.getParameter("themecode").trim(),
							request.getParameter("themename").trim(),
							request.getParameter("themecont").trim(),
							request.getParameter("csscont").trim()
				}, null);
				ThemeFileController.createFiles(request.getParameter("csscont").trim(),modulename+"/DEFAULT/"+request.getParameter("themecode").trim(),".css");
				response.sendRedirect("thememanager.jsp?message=added&modulename="+modulename);
				return;
			}else{
				message="Theme code already exists";
				displaycontblock=true;
			}
		
			//out.println("add db");
		}
	}


}

%>


<%@ include file="/main/tabsheader.jsp" %>


<%

if(displaycontblock){
String readonly=("edit".equalsIgnoreCase(act))?"readonly=readonly":"";


String actionlabel=("edit".equalsIgnoreCase(act))?"Edit Theme":"Add Theme";


%>
<style type='text/css'>
	#header_top{
		position: absolute;
	}
</style>
<div align='center'><h1><%=actionlabel %></h1></div>
<div align='left' class='error'><%=message %></div>
<table width='100%'  cellspacing="0" cellpadding="0"  align='center'>
<form name='dd' method='post' action='managetheme.jsp'>
<tr ><td class='inputlabel' width='30%' >Theme Name</td>   <td class='inputvalue'><input type='text' name='themename' value='<%=themename %>'  <%=readonly %>/></td> </tr>
<tr ><td class='inputlabel' width='30%' >Theme Code</td>   <td class='inputvalue'><input type='text' name='themecode' value='<%=themecode %>' <%=readonly %>/></td> </tr>
<tr><td colspan='2' width='100%'>
	<table width='100%' align='center'>
	<tr class=colheader><td width='100%' colspan='2'>CSS</td></tr>
	<tr><td align='center' colspan='2'><textarea name='csscont' rows='20' cols='80' ><%=csscontent %></textarea></td></tr>
	<tr class=colheader><td width='100%' colspan='2'>Theme content</td></tr>
	<tr><td align='center'><textarea name='themecont' rows='40' cols='80' ><%=themecontent %></textarea></td>
	<td><jsp:include page='themehelpcont.jsp' /></td>
	</tr>
	</table>
</td></tr>

<input type='hidden' name='act' value='<%=act %>'>
<input type='hidden' name='UNITID' value='13579'>
<input type='hidden' name='modulename' value='<%=modulename%>'>

<tr><td colspan='3' align='center'><input type='submit' name='submit' value='Submit' /></td></tr>

</form>

</table>


<%
}
%>

<%@ include file="/main/footer.jsp" %>
