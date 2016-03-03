<%@ page import="java.util.*,com.eventbee.general.*,com.themes.*" %>
<%@ page import="com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>

<%!
String CLASS_NAME="customevents/gettheme.jsp";
%>



<jsp:include page="/auth/checkpermission.jsp">
 <jsp:param name='Dummy_ph' value='' /></jsp:include>
<jsp:include page="/stylesheets/CoreRequestMap.jsp" />


<% 
request.setAttribute("linktohighlight","theme");
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
	
	
%>

<jsp:include page="/stylesheets/TabSetter.jsp" >
<jsp:param name='DEFTAB' value='community' />
<jsp:param name='Dummy_ph' value='' /></jsp:include>                                                                      

<%

request.setAttribute("themetype","PERSONAL");
String type1=request.getParameter("type");
if(type1==null||"".equals(type1))type1="event";
String eventlisttype=DbUtil.getVal("select premiumlevel from eventinfo where eventid=?",new String [] {request.getParameter("GROUPID")});

String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";
String groupid=request.getParameter("GROUPID");
Authenticate authData=AuthUtil.getAuthData(pageContext);
if(authData !=null){
session.removeAttribute("REDIRECT_HASH");
String userid=authData.getUserID();
String unitid=authData.getUnitID();
HashMap hm=new HashMap();
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"Module Name======="+type1,"",null);
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"userid======="+userid,"",null);

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


String [] themedata=ThemeController.getThemeCodeAndType(type1+"%",request.getParameter("GROUPID"),"basic");
String selectedtheme=themedata[1];
String selectedthemetype=themedata[0];

EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"selectedtheme======="+selectedtheme,"",null);
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"selectedthemetype======="+selectedthemetype,"",null);


com.eventbee.myaccount.MyAccount myacct=(com.eventbee.myaccount.MyAccount)authData.UserInfo.get("MyAccount");

%>

<script language='javascript'>
var gr1=<%=groupid%>;

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
		
		if(purpose.indexOf('%')!=-1){
			purpose=purpose.substring(0,purpose.indexOf('%'));
		}
		if(purpose=='event'){
			parent.frames.preview.location = '/portal/customevents/previewThemeProcessor.jsp?modulename='+purpose+'&currenttheme='+currenttheme+'&type=<%=type1%>&forchange=y&themetype='+result+'&deftheme='+seltheme+'&GROUPID='+gr1;
		}
		else{
			parent.frames.preview.location = '/portal/customevents/previewAttendeeThemeProcessor.jsp?modulename='+purpose+'&currenttheme='+currenttheme+'&type=<%=type1%>&forchange=y&themetype='+result+'&deftheme='+seltheme+'&GROUPID='+gr1;
		}
	}
}
</script>
<script language='javascript'>
function changeloc1(){
	for(i=0;i<document.geturlifestyle.themetype.length;i++){
		if(document.geturlifestyle.themetype[i].checked==true){
		var result=document.geturlifestyle.themetype[i].value;
			if(result=='PERSONAL'){
				var e= parent.frames.preview.location;
				var seltheme=document.geturlifestyle.mytheme.value;
				var currenttheme=document.geturlifestyle.currenttheme.value;
				parent.frames.preview.location = '/portal/customevents/previewThemeProcessor.jsp?modulename=event&currenttheme='+currenttheme+'&type=<%=type1%>&forchange=y&themetype='+result+'&deftheme='+seltheme+'&GROUPID='+gr1;
			}
		}
	}
}

</script>
<table width='100%'  cellspacing="0" cellpadding="0">
<form name="geturlifestyle" method="post" action="/customevents/themecontroller" >
<input type='hidden' name='currenttheme' value='<%=selectedtheme %>'  />
<input type='hidden' name='purpose' value='<%=type1+"%"%>'  />
<input type='hidden' name='frompage' value='eventpages' />
<input type='hidden' name='evtname' value='<%=request.getParameter("evtname") %>'  />
<tr>
<td class="inputlabel">
<%if((mythemesmap!=null&&mythemesmap.size()>0)){
if(mythemenames!=null&&mythemenames.length>0){%>

<input type='radio' name='themetype' value='DEFAULT'  <%=("DEFAULT".equals(GenUtil.getHMvalue(hm,"themetype",selectedthemetype)))?"checked='checked'":""%> "onChange='changeloc()'"/>
<%}%>
<%}else{%>
<input type="hidden" name="themetype" value="DEFAULT" />
<%}%>
<%=EbeeConstantsF.get("application.name","")%> Themes</td>
<td class="inputvalue" ><%=WriteSelectHTML.getSelectHtml(themenames,themevals,"theme",GenUtil.getHMvalue(hm,"theme",selectedtheme),null,null,"onChange='changeloc()'" )%>
</td>
<%
if((mythemesmap!=null&&mythemesmap.size()>0)){
if(mythemenames!=null&&mythemenames.length>0){%>
<td class="inputlabel"><input type='radio' name='themetype' value='PERSONAL'  <%=("PERSONAL".equals(GenUtil.getHMvalue(hm,"themetype",selectedthemetype)))?"checked='checked'":""%> "onChange='changeloc1()'"/>My Themes </td>
<td class="inputvalue" ><%=WriteSelectHTML.getSelectHtml(mythemenames,mythemevals,"mytheme",GenUtil.getHMvalue(hm,"theme",selectedtheme),null,null,"onChange='changeloc1()'")%>
</td>
<%}%>
<%}else{%>
<td></td><td></td>
<%}%>
</tr>
<tr><td colspan="4" align='right'>Theme Preview</td></tr>

<% if ("event".equals(type1)){

%>
<tr><td colspan='4'>
<iframe name="preview" id="preview" 
			src="/portal/customevents/previewThemeProcessor.jsp?modulename=event&currenttheme=<%=selectedtheme%>&type=<%=type1%>&forchange=y&deftheme=<%=selectedtheme %>&GROUPID=<%=groupid%>&themetype=<%=selectedthemetype%>"
			frameborder=1 width="100%" height="400" 
			marginheight="0" marginwidth="0"></iframe>


</td></tr>
<%}else{

%>
<tr><td colspan='4'>
<iframe name="preview" id="preview" 
			src="/portal/customevents/previewAttendeeThemeProcessor.jsp?modulename=<%=type1%>&currenttheme=<%=selectedtheme%>&type=<%=type1%>&forchange=y&deftheme=<%=selectedtheme %>&GROUPID=<%=groupid%>&themetype=<%=selectedthemetype%>"
			frameborder=1 width="100%" height="400" 
			marginheight="0" marginwidth="0"></iframe>


</td></tr>



<%}%>


<tr><td colspan='4' align='center'> <input type='submit' name='submit' value='Submit' />
     <input type="button"  value="Cancel" onClick="javascript:window.history.back()"/></td></tr>
<input type='hidden' name='type' value="<%=(String)request.getAttribute("type") %>" />
<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>	
</form>
</table>
<%
}

%>

