<%@ page import="java.util.*,com.eventbee.general.*,com.themes.*" %>
<%@ page import="com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>
<%!
String CLASS_NAME="mythemes/mythemetemplate.jsp";

String GET_SELECTEDTHEME_INFO="select themetype,themecode,cssurl from user_roller_themes where module=? and userid=? ";
String [] getMyPublicPageThemeCodeAndType(String module,String userid,String deftheme){
		DBManager dbmanager=new DBManager();
		StatusObj statobj=dbmanager.executeSelectQuery(GET_SELECTEDTHEME_INFO,new String []{module,userid});
		if(statobj.getStatus()&&statobj.getCount()>0)
			return new String [] {dbmanager.getValue(0,"themetype","DEFAULT"),dbmanager.getValue(0,"themecode",deftheme),dbmanager.getValue(0,"cssurl",deftheme+".css")};
		else
			return new String [] {"DEFAULT",deftheme,deftheme+".css"};
	}
  %>
 <%
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"Entered","",null);
String rollercontext=(application.getInitParameter("rollercontext")!=null)?application.getInitParameter("rollercontext"):"/roller";
String act=request.getParameter("act");
String type=request.getParameter("type");
String customthemeid=request.getParameter("customthemeid");
String title=request.getParameter("title");
String userthemecode="";
String selectedthemetype="";
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"type====="+type,"",null);
String userid="";
String editdatalink="";
String editcsslink="";
Authenticate authData=AuthUtil.getAuthData(pageContext);
if(authData !=null)
userid=authData.getUserID();
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"userid====="+userid,"",null);
	if(customthemeid!=null){	 
		userthemecode=customthemeid;
		selectedthemetype="PERSONAL";
		editdatalink="/portal/mytasks/mytemplates.jsp?themetype="+selectedthemetype+"&type="+type+"&act=editdata&customthemeid="+customthemeid+"&title="+request.getParameter("title");
		editcsslink="/portal/mytasks/mytemplates.jsp?themetype="+selectedthemetype+"&type="+type+"&act=editcss&customthemeid="+customthemeid+"&title="+request.getParameter("title");
	 }
	 else if(type!=null){
		String [] themedata=getMyPublicPageThemeCodeAndType(type,userid,"basic");
		userthemecode=themedata[1];
		selectedthemetype=themedata[0];
		editdatalink="/portal/mytasks/mytemplates.jsp?themetype="+selectedthemetype+"&title="+request.getParameter("title")+"&type="+type+"&act=editdata";
		editcsslink="/portal/mytasks/mytemplates.jsp?themetype="+selectedthemetype+"&title="+request.getParameter("title")+"&type="+type+"&act=editcss";
	 
	 }
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"userthemecode====="+userthemecode,"",null);
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"selectedthemetype====="+selectedthemetype,"",null);

boolean dispmaintemplate=true;
boolean displayeditblock=false;
boolean displayconfirm=false;

if("editcss".equals(act) || "editdata".equals(act) ){
	displayeditblock=true;
	dispmaintemplate=false;
}

if(dispmaintemplate ){
%>
<table width='100%'  cellspacing="0" cellpadding="0">
<form name="geturllifestyle" method="post"  action="/mythemes/savethemes.jsp">

<input type='hidden' name='type' value="<%=type %>" />
<input type='hidden' name='themeid' value='<%=userthemecode %>' />
<input type='hidden' name='themetype' value='<%=selectedthemetype %>' />

<tr class='colheader'>
        <td width="20%">Name</td>
        <td width="70%">Description</td>
        <td width="5%">Edit</td>
       </tr>
<tr class="evenbase"><td >CSS</td>
            <td>Theme CSS style sheet</td>
            <td class="center">
               <a href="<%=editcsslink%>"><img src='/home/images/Edit16.png' border="0" alt="icon" /></a>
               <input type="hidden" name="title"  value='<%=request.getParameter("title")%>'/>
		
            </td>
             </tr>
    
<tr class="oddbase"><td >HTML</td>
            
            <td>Theme HTML data</td>
            <td class="center">
               <a href="<%=editdatalink%>"><img src='/home/images/Edit16.png' border="0" alt="icon" /></a>
            
            </td>
             </tr>
	    <tr></tr>
	    <tr></tr>
		
<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>	
</form>
</table>

<%
}
%>


<%
if(displayeditblock ){
String editedcontent="themecontent";
if("editcss".equals(act))editedcontent="css";
%>
		<table width='100%'  cellspacing="0" cellpadding="0">
		<form name="edit" method="post" action="/mythemes/themecontroller" >
		<input type="hidden" name="title"  value='<%=request.getParameter("title")%>'/>
		<input type='hidden' name='theme' value='<%=userthemecode %>' />
		<input type='hidden' name='themeid' value='<%=userthemecode %>' />
		<tr><td align='center'>
			<%
			String themetype=request.getParameter("themetype");
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"themetype====="+themetype,"",null);

			String content=null;

			if("editcss".equalsIgnoreCase(act)){
				if("CUSTOM".equals(themetype)){
					content=ThemeController.getCSS(userid+"_"+userthemecode,themetype,type);
					//content=getPublicPageCSS(userid+"_"+type+"_"+userthemecode,themetype,type);
				}
				else{
					content=ThemeController.getCSS(userthemecode,themetype,type);
				}

			}else{
				//content=getPublicPageContent(userid,type,userthemecode,themetype);
				
			content=ThemeController.getPublicPageContent(userid,type,userthemecode,themetype);
			}
			%>
			<textarea name='editcontent' rows='30' cols='80'><%=content %></textarea>
		
		</td></tr>
		<tr><td align='center'>
				<input type='submit' name='submit' value='Submit' />
				</td></tr>
		<input type='hidden' name='themetype' value='<%=themetype %>' />
		<input type='hidden' name='formname' value="edit" />
		<input type='hidden' name='purpose' value="<%=type %>" />
		<input type='hidden' name='act' value="<%=act %>" />
		<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>	
		</form>

		
		</table>

<%
}
%>


<%
if(displayconfirm ){
%>
<table width='100%'  cellspacing="0" cellpadding="0">
		<form name="edit" method="post" action="/mythemes/themecontroller" >
		<input type='hidden' name='theme' value='<%=userthemecode %>' />
		<tr><td align='center'>This will remove your customization
		</td></tr>
		<tr><td align='center'>
		<input type='submit' name='submit' value='Submit' />
		</td></tr>
		<input type='hidden' name='formname' value="remove" />
		<input type='hidden' name='purpose' value="<%=type %>" />
		<input type='hidden' name='act' value="<%=act %>" />
		<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>	
		</form>
		</table>
<%
}
%>

