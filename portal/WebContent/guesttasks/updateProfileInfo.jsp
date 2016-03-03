<%@ page import="com.eventbee.general.*"%>

<%
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","")+"/";


String login_name=null;
String evtname=null;
request.setAttribute("CustomLNF_Type","EventDetails");
request.setAttribute("CustomLNF_ID",request.getParameter("GROUPID"));

	
if((String)session.getAttribute("evtname")!=null)
	evtname=(String)session.getAttribute("evtname");
else if((String)session.getAttribute("evtname")==null)
	evtname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{request.getParameter("GROUPID")});


String listurl=serveraddress+"event?eid="+request.getParameter("GROUPID");

if("FB".equals(request.getParameter("context"))){
	listurl+="&context=FB";
}
String evtlink="<a href='"+listurl+"'>"+evtname+"</a>";

request.setAttribute("tasktitle",evtlink+" > Edit Registration");
//request.setAttribute("mtype","My Console");
request.setAttribute("stype","Events");
%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/eventregister/reg/updateProfileInfo.jsp";
	footerpage="/main/eventfootermain.jsp";
	%>
	      		
<%@ include file="/templates/taskpagebottom.jsp" %>
		