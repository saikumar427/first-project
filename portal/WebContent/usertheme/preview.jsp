<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.authentication.*,com.themes.*" %>
<%@ page import="com.eventbee.customthemes.UserCustomThemeDB" %>

<%
	String authid=null,unitid=null;
	Authenticate authData=AuthUtil.getAuthData(pageContext);
	if(authData!=null)authid=authData.getUserID();
	String ispreview=request.getParameter("ispreview");
	String module=request.getParameter("module");
	String bigger_font_size="",
	bigger_font_type="",
	bigger_text_color="",
	medium_font_size="",
	medium_font_type="",
	medium_text_color="",
	small_font_size="",
	small_font_type="",
	small_text_color="",
	background="";
	HashMap hm=new HashMap();


	String statichtmlfilepath=module+"/TEMPLATES/samplepreview.html";
	String htmlfilecontent=ThemeFileController.readFilesNReturnContent(statichtmlfilepath);
	String csscontent="";	
	if("yes".equals(ispreview)){
	HashMap hmnew=new HashMap();
	String themeid=request.getParameter("themeid");
	//String filepath=EbeeConstantsF.get("user.cssfile.webpath","C:\\jboss-3.2.2\\server\\default\\deploy\\home.war\\userthemes\\");
	String filepath=module+"/PERSONAL/"+themeid+".css";
	csscontent=ThemeController.getCSS(themeid,"PERSONAL",module);
%>	
<META HTTP-EQUIV="CACHE-CONTROL" CONTENT="NO-CACHE">		

<style>
<%=csscontent%>
</style>


<%

	}
	else
	{


	background=request.getParameter("BACKGROUND");
	
	bigger_font_size=request.getParameter("BIGGER_FONT_SIZE");
	bigger_font_type=request.getParameter("BIGGER_FONT_TYPE");
	bigger_text_color=request.getParameter("BIGGER_TEXT_COLOR");


	medium_font_size=request.getParameter("MEDIUM_FONT_SIZE");
	medium_font_type=request.getParameter("MEDIUM_FONT_TYPE");
	medium_text_color=request.getParameter("MEDIUM_TEXT_COLOR");
	
	small_font_size=request.getParameter("SMALL_FONT_SIZE");
	small_font_type=request.getParameter("SMALL_FONT_TYPE");
	small_text_color=request.getParameter("SMALL_TEXT_COLOR");



	if("BACKGROUND_COLOR".equals(background))
	{
		background=request.getParameter("BACKGROUND_COLOR");		
	}
	else{
		background=request.getParameter("BACKGROUND_IMAGE");
		background="url("+background+")";
	}
	
	hm.put("#**BACKGROUND**#",background);
	hm.put("#**BIGGER_FONT_SIZE**#",bigger_font_size);
	hm.put("#**BIGGER_FONT_TYPE**#",bigger_font_type);
	hm.put("#**BIGGER_TEXT_COLOR**#",bigger_text_color);

	hm.put("#**MEDIUM_FONT_SIZE**#",medium_font_size);
	hm.put("#**MEDIUM_FONT_TYPE**#",medium_font_type);
	hm.put("#**MEDIUM_TEXT_COLOR**#",medium_text_color);

	hm.put("#**SMALL_FONT_SIZE**#",small_font_size);
	hm.put("#**SMALL_FONT_TYPE**#",small_font_type);
	hm.put("#**SMALL_TEXT_COLOR**#",small_text_color);
	
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"preview.jsp","background is "+background,"",null);


	String staticcssfilepath=module+"/TEMPLATES/samplepreview.css";
	String cssfilecontent=ThemeFileController.readFilesNReturnContent(staticcssfilepath);
	csscontent=TemplateConverter.getMessage(hm,cssfilecontent);
%>	
	<style type="text/css">
	<%out.println(csscontent);%>
	</style>
<%	
	}

	out.println(htmlfilecontent);

%>
<center><input type="button" name="Submit" value="Close" onClick="javascript:window.close();"/><center/>
