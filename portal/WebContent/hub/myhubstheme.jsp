<%@ page import="java.util.*,com.eventbee.general.*,com.themes.*" %>
<%@ page import="com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>
<%@ include file="/mythemes/mythemesdb.jsp" %>

<%!
	String CLASS_NAME="hub/myhubstheme.jsp";
%>



<%

	request.setAttribute("themetype","PERSONAL");
	String type1=request.getParameter("type");
	if(type1==null||"".equals(type1))type1="hubspage";
	String appname="/portal";
	Authenticate authData=AuthUtil.getAuthData(pageContext);
	if(authData !=null){
		session.removeAttribute("REDIRECT_HASH");
		String userid=authData.getUserID();
		String unitid=authData.getUnitID();
		
		Map themesmap=ThemeController.getThemes(new String [] {type1});
		String themevals[]=(String [])themesmap.get("themevals");
		String themenames[]=(String [])themesmap.get("themenames");
		Map mythemesmap=ThemeController.getMyThemes(new String [] {userid,type1});
		String mythemevals[]=new String[0];
		String mythemenames[]=new String[0];
		if(mythemesmap!=null&&mythemesmap.size()>0){
			mythemevals=(String [])mythemesmap.get("themevals" );
			mythemenames=(String [])mythemesmap.get("themenames" );
		}

		String [] themedata=getMyPublicPageThemeCodeAndType(type1,userid,"basic");
		String selectedtheme=themedata[1];
		String selectedthemetype=themedata[0];
		com.eventbee.myaccount.MyAccount myacct=(com.eventbee.myaccount.MyAccount)authData.UserInfo.get("MyAccount");

%>

<script language='javascript'>


function changeloc(){
     	var result;
	result=document.geturlifestyle.themetype.value;
	for(i=0;i<document.geturlifestyle.themetype.length;i++){
		if(document.geturlifestyle.themetype[i].checked==true){
			result=document.geturlifestyle.themetype[i].value;
		
		}
	}
	
	if(result=='DEFAULT'){

		var e= parent.frames.preview.location;
		var seltheme=document.geturlifestyle.theme.value;
		var currenttheme=document.geturlifestyle.currenttheme.value;
		var purpose=document.geturlifestyle.purpose.value;
		parent.frames.preview.location = '/portal/mythemes/previewThemeProcessornew.jsp?modulename=hubspage&currenttheme='+currenttheme+'&type=<%=type1%>&forchange=y&themetype='+result+'&deftheme='+seltheme;
		
		}
		
	}

</script>
<script language='javascript'>
function changeloc1(){
var purpose=document.geturlifestyle.purpose.value;
	for(i=0;i<document.geturlifestyle.themetype.length;i++){
		if(document.geturlifestyle.themetype[i].checked==true){
		var result=document.geturlifestyle.themetype[i].value;
			if(result=='PERSONAL'){
			var e= parent.frames.preview.location;
				var seltheme=document.geturlifestyle.mytheme.value;
				var currenttheme=document.geturlifestyle.currenttheme.value;
				parent.frames.preview.location = '/portal/mythemes/previewThemeProcessornew.jsp?modulename=hubspage&currenttheme='+currenttheme+'&type=<%=type1%>&forchange=y&themetype='+result+'&deftheme='+seltheme;
							}
		}
	}
}

</script>

	<table width='100%'  cellspacing="0" cellpadding="0">
	<form name="geturlifestyle" method="post" action="/mythemes/themecontroller?type=mypageshubs" >
	<input type='hidden' name='currenttheme' value='<%=selectedtheme %>'  />
	<input type='hidden' name='purpose' value='<%=type1 %>'  />
	<tr>
	<td class="inputlabel">
	
	<%if(mythemenames!=null&&mythemenames.length>0){%>
	<input type='radio' name='themetype' value='DEFAULT' <%=("DEFAULT".equals(selectedthemetype))?"checked='checked'":""%> "onChange='changeloc()'"/>
	<%}else{%>
	<input type="hidden" name="themetype" value="DEFAULT" />
	<%}%>
	<%=EbeeConstantsF.get("application.name","")%> Themes:
	<%=WriteSelectHTML.getSelectHtml(themenames,themevals,"theme",selectedtheme,null,null,"onChange='changeloc()'" )%>
	</td>
	<%
	
	if(mythemenames!=null&&mythemenames.length>0){
	%>
	<td class="inputlabel"><input type='radio' name='themetype' value='PERSONAL'  <%=("PERSONAL".equals(selectedthemetype))?"checked='checked'":""%> "onChange='changeloc1()'"/>My Themes:
	<%=WriteSelectHTML.getSelectHtml(mythemenames,mythemevals,"mytheme",selectedtheme,null,null,"onChange='changeloc1()'")%> 
	</td>
	<%}
	else{%>
	<td></td><td></td>
	<%}%>
	</tr>
	<tr><td colspan="4" align='right'>Theme Preview</td></tr>
	<tr><td colspan='4'>
	<iframe name="preview" id="preview" 
				src="/portal/mythemes/previewThemeProcessornew.jsp?modulename=hubspage&currenttheme=<%=selectedtheme%>&type=hubspage&forchange=y&deftheme=<%=selectedtheme %>&themetype=<%=selectedthemetype%>"
				frameborder=1 width="100%" height="400" 
				marginheight="0" marginwidth="0">
	</iframe>
	
	
	</td></tr>
	<tr><td colspan='4' align='center'> <input type='submit' name='submit' value='Submit' />&nbsp;<input type="button"  name="back" value="Cancel" onClick="javascript:history.back()" /></td></tr>
	<input type='hidden' name='type' value="<%=(String)request.getAttribute("type") %>" />
	<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>	
	</form>
	</table>
<%
	}

%>


