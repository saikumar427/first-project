<%@ page import="com.eventbee.general.*" %>
<%@ page import="org.eventbee.sitemap.util.Presentation" %>

<%
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","")+"/";

String eventid=Presentation.GetRequestParam(request,  new String []{"eid","eventid", "id","GROUPID","gid","groupid"});

request.setAttribute("CustomLNF_Type","EventDetails");
request.setAttribute("CustomLNF_ID",eventid);
String evtname=null;
evtname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{eventid});
String listurl=serveraddress+"event;jsessionid="+session.getId()+"?eid="+eventid;
if("FB".equals(request.getParameter("context"))){
	listurl+="&context=FB";
}

String evtlink="<a href='"+listurl+"'>"+evtname+"</a>";
/*String platform=(String)session.getAttribute("platform");
if("ning".equals(platform)){
evtlink=evtname;
}*/
request.setAttribute("tasktitle","Event Registration > "+evtlink+ " > Not Available" );
//request.setAttribute("mtype","My Console");
request.setAttribute("stype","Events");
%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/eventregister/reg/ticketnotavailable.jsp";
	footerpage="/main/eventfootermain.jsp";
%>
<%@ include file="/templates/taskpagebottom.jsp" %>
		      		
	