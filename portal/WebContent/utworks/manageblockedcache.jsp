<%@ page import="java.util.*,com.eventbee.general.EbeeCachingManager" %>
<%
HashMap blockedUsers=(HashMap)EbeeCachingManager.ebeeCache.get("blocked_user_urls");
HashMap blockedCustomURLs=(HashMap)EbeeCachingManager.ebeeCache.get("blocked_custom_urls");
HashMap blockedEvents=(HashMap)EbeeCachingManager.ebeeCache.get("blockedEvents");
String key=request.getParameter("key");
String purpose=request.getParameter("purpose");
String action=request.getParameter("action");
if("deleteall".equals(action)){
	if("user".equals(purpose))
		((HashMap)EbeeCachingManager.ebeeCache.get("blocked_user_urls")).clear();
	if("customurl".equals(purpose))
		((HashMap)EbeeCachingManager.ebeeCache.get("blocked_custom_urls")).clear();
	if("event".equals(purpose))
		((HashMap)EbeeCachingManager.ebeeCache.get("blockedEvents")).clear();
	response.sendRedirect("/utworks/blockedcontent.jsp");
	return;
}
else if(key!=null && !"".equals(key) && purpose!=null && !"".equals(purpose)){
	if("add".equals(action)){
	if("user".equals(purpose)){
		if(blockedUsers==null) blockedUsers=new HashMap();
		blockedUsers.put(key,"Y");
		EbeeCachingManager.put("blocked_user_urls",blockedUsers);
		response.sendRedirect("/utworks/blockedcontent.jsp");
		return;
	}
	if("customurl".equals(purpose)){
		if(blockedCustomURLs==null) blockedCustomURLs=new HashMap();
		blockedCustomURLs.put(key,"Y");
		EbeeCachingManager.put("blocked_custom_urls",blockedCustomURLs);
		response.sendRedirect("/utworks/blockedcontent.jsp");
		return;
	}
	if("event".equals(purpose)){
		if(blockedEvents==null) blockedEvents=new HashMap();
		blockedEvents.put(key,"Y");
		EbeeCachingManager.put("blockedEvents",blockedEvents);
		response.sendRedirect("/utworks/blockedcontent.jsp");
		return;
	}
	}
	if("delete".equals(action)){
		if("user".equals(purpose) && blockedUsers!=null){
		((HashMap)EbeeCachingManager.ebeeCache.get("blocked_user_urls")).remove(key);
		response.sendRedirect("/utworks/blockedcontent.jsp");
		return;
	}
		if("customurl".equals(purpose) && blockedCustomURLs!=null){
		((HashMap)EbeeCachingManager.ebeeCache.get("blocked_custom_urls")).remove(key);
		response.sendRedirect("/utworks/blockedcontent.jsp");
		}
		if("event".equals(purpose) && blockedEvents!=null){
		((HashMap)EbeeCachingManager.ebeeCache.get("blockedEvents")).remove(key);
		response.sendRedirect("/utworks/blockedcontent.jsp");
		return;
		}
	}
}else{
	response.sendRedirect("/utworks/blockedcontent.jsp");
	return;
}
	
%>
