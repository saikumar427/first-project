<%@ page import="com.eventbee.general.*" %>
<%
String groupid=request.getParameter("GROUPID");
String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{groupid});
String pageToInclude="";

String link="<a href='/mytasks/eventmanage.jsp?GROUPID="+groupid+"'>"+eventname+"</a>";
//request.setAttribute("tasktitle","Event Manage > "+link+ " > Transaction Management" );
request.setAttribute("layout", "EE");
request.setAttribute("mtype","Transaction Management");
if("google".equals(request.getParameter("type"))){
request.setAttribute("stype","Google Transactions");
pageToInclude="/googlepaypaltransactions/vendortransactions.jsp";
request.setAttribute("tasktitle","Event Manage > "+link+ " > Google Transaction Management" );
}
if("paypal".equals(request.getParameter("type"))){
request.setAttribute("stype","PayPal Transactions");
pageToInclude="/googlepaypaltransactions/vendortransactions.jsp";
request.setAttribute("tasktitle","Event Manage > "+link+ " > PayPal Transaction Management" );
}
if("eventbee".equals(request.getParameter("type"))){
request.setAttribute("stype","Eventbee Transactions");
pageToInclude="/googlepaypaltransactions/eventbeetransactions.jsp";
request.setAttribute("tasktitle","Event Manage > "+link+ " > Eventbee Transaction Management" );
}


%>



<%@ include file="/templates/taskpagetop.jsp" %>

<%
	taskpage=pageToInclude;
%>
	      		
<%@ include file="/templates/taskpagebottom.jsp" %>
      		
	