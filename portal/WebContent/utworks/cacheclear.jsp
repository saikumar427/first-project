<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.layout.EventGlobalTemplates" %>
<%
String purpose=request.getParameter("purpose");
if(purpose!=null && "globtemps".equals(purpose)){
	String lang=request.getParameter("lang");
	if(lang!=null){
		EventGlobalTemplates.clearCache(lang);
		out.println("EventGlobalTemplates Cache Cleared for language: "+lang);
	}else{
		EventGlobalTemplates.clearAllCache();
		out.println("EventGlobalTemplates Cache Cleared");
	}
}else{
	EbeeCachingManager.clearAllCache();
	out.println("EbeeCachingManager Cache Cleared");
}

%>