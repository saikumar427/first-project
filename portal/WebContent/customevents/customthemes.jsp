<%@ page import="java.util.*,com.eventbee.general.*,com.themes.*" %>
<%@ page import="com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>


<%!

String CLASS_NAME="customevents/customthemes.jsp";
%>

<%

String [] themedata=new String [2]; 
String userid="";
Authenticate authData=AuthUtil.getAuthData(pageContext);
if(authData !=null){
	userid=authData.getUserID();
}
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"userid======="+userid,"",null);

String theme=null;
String themename=request.getParameter("themename");
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"themename======="+themename,"",null);

boolean isnew=false;
if (themename!=null&&"new".equals(themename))
{
	isnew=true;
	theme=request.getParameter("theme");
}
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"theme======="+theme,"",null);
String type=request.getParameter("type");
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"type======="+type,"",null);

String themeid=request.getParameter("themeid");
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"themeid======="+themeid,"",null);
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"GROUPID======="+request.getParameter("GROUPID"),"",null);

DBManager dbmanager=new DBManager();
StatusObj statobj=null;
StatusObj sobj=null;
String templatedata="";
String customcss="";

String themetype=DbUtil.getVal(ThemeQueries.GET_THEME_TYPE,new String[] {type,request.getParameter("GROUPID")});
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"themetype is :"+themetype," ",null);

themedata=ThemeController.getSelectedThemeData(userid,type,themeid,type,request.getParameter("GROUPID"),themetype);
	templatedata=themedata[1];
	customcss=themedata[0];
if(isnew){
	themeid=ThemeController.getThemeid();
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"new themeid======="+themeid,"",null);
	sobj=ThemeController.createMyTheme(themedata, userid,type,theme,themeid);
}else{
	themeid=themename;
	sobj=ThemeController.updateMyTheme(new String []{customcss,templatedata},themeid,type);
}

%>

<%
response.sendRedirect("/customevents/confirmtheme.jsp?GROUPID="+request.getParameter("GROUPID")+"&type="+type+"&themeid="+themeid);
%>





