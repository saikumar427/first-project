<%@ page import="java.util.*,java.sql.*" %>
<%@ page import="com.eventbee.event.EventsContent,com.eventbee.general.*" %>
<%@ page import="com.eventbee.contentbeelet.*"%>

<%
HashMap evtinfo=(HashMap)request.getAttribute("EVENT_INFORMATION");
HashMap confighm=(HashMap)request.getAttribute("EVENT_CONFIG_INFORMATION");
String groupid=(String)request.getAttribute("GROUPID");



String content="";
String title="";
HashMap customcontent=CustomContentDB.getCustomContent("EVENT_VIEW_PAGE", groupid);
if(customcontent!=null){
title=(String)customcontent.get("title");
}

content=GenUtil.getHMvalue(customcontent,"desc" );
customcontent=CustomContentDB.getCustomContent("DESI_AD_EVENT_VIEW_PAGE", "13579");
request.setAttribute("CONENTBEELETTITLE",title);
request.setAttribute("CONENTBEELET",content);
content=GenUtil.getHMvalue(customcontent,"desc" );
request.setAttribute("ADCONENTBEELET",content);
content="";

HashMap customcontent_ad=null;
customcontent_ad=CustomContentDB.getCustomContent("G_AD_EVENT_DETAILS", "13579");
if(customcontent_ad!=null){
content=GenUtil.getHMvalue(customcontent_ad,"desc" );
}
if(content==null)content="";
request.setAttribute("GEOOGLEADS",content);


content=null;
HashMap customcontent_yahooad=null;
customcontent_yahooad=CustomContentDB.getCustomContent("Y_AD_EVENT_VIEW_PAGE", "13579");
if(customcontent_yahooad!=null){
content=GenUtil.getHMvalue(customcontent_yahooad,"desc" );
}
if(content==null)content="";
request.setAttribute("YAHOOADS",content);
	
%>
