<%@ page import="java.util.*,com.eventbee.general.EbeeCachingManager,com.eventbee.util.CoreConnector" %>
<%
	String key=request.getParameter("key");
	String purpose=request.getParameter("purpose");
	String action=request.getParameter("action");
	String ack="";
	CoreConnector cc1=new CoreConnector("http://107.22.215.190/utworks/manageblockedcache.jsp?key="+key+"&purpose="+purpose+"&action="+action);
	cc1.setTimeout(30000);
	ack=cc1.MGet();
	if("success".equals(ack)){
		CoreConnector cc2=new CoreConnector("http://184.73.184.208/utworks/manageblockedcache.jsp?key="+key+"&purpose="+purpose+"&action="+action);
		cc2.setTimeout(30000);
		ack=cc2.MGet();
	}
	response.sendRedirect("/utworks/blockedcontent.jsp");
%>