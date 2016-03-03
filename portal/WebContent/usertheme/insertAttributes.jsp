<%@ page import="java.util.*,java.io.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.customthemes.UserCustomThemeDB,com.themes.*" %>


<%!
String CLASS_NAME="usertheme/insertAttributes.jsp";  
String THEMEINSERTQUERY="insert into user_customized_themes (userid,cssurl,content,module,themeid,themename,created_at,updated_at) values(?,?,?,?,?,?,now(),now())";
String UPDATE_THEME="update user_customized_themes set updated_at=now(), themename=? where themeid=?";


%>
<%

String streamid=null,authid=null,refid="";
String msg="add";
String themeid="";
String module=request.getParameter("module");
if(module==null||"".equals(module))
	module="eventspage";

Authenticate authData=AuthUtil.getAuthData(pageContext);
if(authData!=null)authid=authData.getUserID();

String act=request.getParameter("act");
if(act!=null&&"edit".equals(act)){
	msg="edit";
	themeid=request.getParameter("themeid");
	streamid=DbUtil.getVal("select streamid from streaming_details where refid=?",new String[]{themeid});
	
	UserCustomThemeDB.updateStreamingAttributes(request,streamid);
}else{
	themeid=ThemeController.getThemeid();
	streamid=UserCustomThemeDB.insertStreamingDetails(authid,module,themeid);
	UserCustomThemeDB.insertStreamingAttributes(request,streamid);
}

HashMap hm=new HashMap();
String themename=request.getParameter("THEME_NAME");
if(themename==null)themename="";
String background=request.getParameter("BACKGROUND");
if("BACKGROUND_COLOR".equals(background))
	hm.put("#**BACKGROUND**#",request.getParameter("BACKGROUND_COLOR"));
else{
	String bgimg=request.getParameter("BACKGROUND_IMAGE");
	hm.put("#**BACKGROUND**#","url("+bgimg+")");
	}
	
hm.put("#**BIGGER_FONT_SIZE**#",request.getParameter("BIGGER_FONT_SIZE"));
hm.put("#**BIGGER_FONT_TYPE**#",request.getParameter("BIGGER_FONT_TYPE"));
hm.put("#**BIGGER_TEXT_COLOR**#",request.getParameter("BIGGER_TEXT_COLOR"));

hm.put("#**MEDIUM_FONT_SIZE**#",request.getParameter("MEDIUM_FONT_SIZE"));
hm.put("#**MEDIUM_FONT_TYPE**#",request.getParameter("MEDIUM_FONT_TYPE"));
hm.put("#**MEDIUM_TEXT_COLOR**#",request.getParameter("MEDIUM_TEXT_COLOR"));

hm.put("#**SMALL_FONT_SIZE**#",request.getParameter("SMALL_FONT_SIZE"));
hm.put("#**SMALL_FONT_TYPE**#",request.getParameter("SMALL_FONT_TYPE"));
hm.put("#**SMALL_TEXT_COLOR**#",request.getParameter("SMALL_TEXT_COLOR"));


String filepath=EbeeConstantsF.get("usertheme.file.path","C:\\jboss-3.2.2\\server\\default\\deploy\\home.war\\userthemes\\");




String staticcssfilepath=module+"/TEMPLATES/staticstyles.css";
	//System.out.println("---------staticcssfilepath------------------"+staticcssfilepath);

String statichtmlfilepath=module+"/TEMPLATES/staticcontent.html";

	String htmlfilecontent=ThemeFileController.readFilesNReturnContent(statichtmlfilepath);
	//System.out.println("---------------------------"+htmlfilecontent);
	String cssfilecontent=ThemeFileController.readFilesNReturnContent(staticcssfilepath);
	String csscontent=TemplateConverter.getMessage(hm,cssfilecontent);	
	
	
	if(act!=null&&"edit".equals(act)){
		StatusObj sobj=ThemeController.updateMyThemeWithName(csscontent,themeid,module,themename.trim());
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"status of editing the theme css and name======="+sobj.getStatus(),"",null);
	}
	else
	{
		
		StatusObj sobj=ThemeController.createMyTheme(new String []{csscontent,htmlfilecontent}, authid,module,themename.trim(),themeid);
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"status of creating new theme======="+sobj.getStatus(),"",null);

	}

		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"themeid======="+themeid,"",null);

	
	
response.sendRedirect("done.jsp?UNITID="+request.getParameter("UNITID"));
%>
