<%@ page import="java.util.*,com.eventbee.general.*,com.themes.*" %>
<%@ page import="com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>
<%@ include file="/mythemes/mythemesdb.jsp" %>

<%!
String CLASS_NAME="mythemes/themecontroller.jsp";

public void processContent(HttpServletRequest request,Authenticate authData ){
	String themetype=request.getParameter("themetype");
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"/mythemes/themecontroller.jsp, in processContent method","themetype  is  :"+themetype,"",null);

	String modulename=request.getParameter("purpose");
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"/mythemes/themecontroller.jsp, in processContent method","modulename  is  :"+modulename,"",null);

	String formname=request.getParameter("formname");
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"/mythemes/themecontroller.jsp, in processContent method","formname  is  :"+formname,"",null);

	String userid=authData.getUserID();
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"/mythemes/themecontroller.jsp, in processContent method","userid  is  :"+userid,"",null);
	String unitid=authData.getUnitID();
	
	String act=request.getParameter("act");
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"/mythemes/themecontroller.jsp, in processContent method","act  is  :"+act,"",null);

	String themecode=request.getParameter("userthemecode");
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"/mythemes/themecontroller.jsp, in processContent method","themecode  is  :"+themecode,"",null);

	String themeid=request.getParameter("themeid");
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"/mythemes/themecontroller.jsp, in processContent method","themeid  is  :"+themeid,"",null);


	if(!"PERSONAL".equals(themetype)){
		
			Map currentrecmap=new HashMap();
			currentrecmap.put("userid",userid);
			currentrecmap.put("module",modulename);
			currentrecmap.put("themecode",themeid);
			//ThemeController.getCustomContent(modulename,userid,themeid,currentrecmap);
			getPublicPageCustomContent(modulename,userid,themeid,currentrecmap); 
		if("edit".equals(formname)){
			String editcontent=request.getParameter("editcontent");
			if("editdata".equals(act)){
				currentrecmap.put("content", editcontent );
			}else if("editcss".equals(act)){
				currentrecmap.put("cssurl",  editcontent );
				ThemeFileController.createFiles((String)currentrecmap.get("cssurl"),modulename+"/CUSTOM/"+userid+"_"+modulename+"_"+themeid,".css");
				DbUtil.executeUpdateQuery("update user_roller_themes set themetype='CUSTOM',cssurl=? where userid=? and module=?",new String [] {userid+"_"+modulename+"_"+themeid+".css",userid,modulename});
			}
		}//end of edi
		//ThemeController.updateCustomThemes(currentrecmap);
		updatePublicPageCustomThemes(currentrecmap);
	}
	else if("PERSONAL".equals(themetype)){
		if("editcss".equals(act)){
			String csscontent=request.getParameter("editcontent");
			ThemeFileController.createFiles(csscontent,modulename+"/PERSONAL/"+themeid,".css");
		}
		if("editdata".equals(act)){
			String htmlcontent=request.getParameter("editcontent");
			//StatusObj statobj=ThemeController.updateMyThemeContent(new String []{"",htmlcontent},themeid);
			StatusObj statobj=updatePublicPageMyThemeContent(new String []{"",htmlcontent},themeid);
		}

	
	}
}



%>

<jsp:include page="/auth/authenticate.jsp" />

<jsp:include page="/stylesheets/CoreRequestMap.jsp" />


<%


String modulename=request.getParameter("purpose");
String formname=request.getParameter("formname");
String themeid=request.getParameter("themeid");

Authenticate authData=AuthUtil.getAuthData(pageContext);
String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";
if(authData !=null){
	String userid=authData.getUserID();
	String unitid=authData.getUnitID();
	String act=request.getParameter("act");
%>
<%
	if("edit".equals(formname)){
		processContent(request,authData);
		
		if("editdata".equals(act)){
		response.sendRedirect(     PageUtil.appendLinkWithGroup("ThemeDone.jsp?operation=Edit Template", (HashMap)request.getAttribute("REQMAP")    )     );
		}else if("editcss".equals(act)){
			response.sendRedirect(     PageUtil.appendLinkWithGroup("ThemeDone.jsp?operation=Edit CSS", (HashMap)request.getAttribute("REQMAP")    )     );
		}
	}else if("mytheme".equals(formname)){
		if("editcss".equals(act)){
			String csscontent=request.getParameter("editcontent");
			ThemeFileController.createFiles(csscontent,modulename+"/PERSONAL/"+themeid,".css");
			}
		if("editdata".equals(act)){
			String htmlcontent=request.getParameter("editcontent");
			//StatusObj statobj=ThemeController.updateMyThemeContent(new String []{"",htmlcontent},themeid);
			StatusObj statobj=updatePublicPageMyThemeContent(new String []{"",htmlcontent},themeid);
		}
		response.sendRedirect(PageUtil.appendLinkWithGroup("ThemeDone.jsp", (HashMap)request.getAttribute("REQMAP"))    );
	}else{
System.out.println("AAAAAAAAAAAAAAAAAAAAAAAAA");
		String themecode=request.getParameter("theme");
		if("PERSONAL".equals(request.getParameter("themetype")))
			themecode=request.getParameter("mytheme");

		String currenttheme=request.getParameter("currenttheme");
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, CLASS_NAME, "changing theme", "currentthem="+currenttheme+", selected theme="+request.getParameter("theme"), null);

		if(!themecode.equals(currenttheme)){
			//ThemeController.updateThemes(userid,modulename,themecode,userid,request.getParameter("themetype"));
			updatePublicPageThemes(userid,modulename,themecode,request.getParameter("themetype"));
		}
		session.setAttribute("message","Theme added successfully");
		response.sendRedirect(PageUtil.appendLinkWithGroup("ThemeDone.jsp?from=add&type=Events", (HashMap)request.getAttribute("REQMAP")    )     );
	}

%>
<%

	

%>


<%

}
%>



