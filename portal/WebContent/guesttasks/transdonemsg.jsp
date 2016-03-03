<%@ page import="com.eventbee.general.*"%>

<%
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","")+"/";

String evtname=null;

if((String)session.getAttribute("evtname")!=null)
	evtname=(String)session.getAttribute("evtname");
else if((String)session.getAttribute("evtname")==null)
	evtname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{request.getParameter("GROUPID")});

String listurl=serveraddress+"event?eventid="+request.getParameter("GROUPID");
String evtlink=evtname;

request.setAttribute("CustomLNF_Type","EventDetails");
request.setAttribute("CustomLNF_ID",request.getParameter("GROUPID"));


request.setAttribute("tasktitle","Event Registration > "+evtlink);
//request.setAttribute("mtype","My Console");
request.setAttribute("stype","Events");

%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/eventregister/reg/transdonemsg.jsp";
	footerpage="/main/eventfootermain.jsp";
	%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	