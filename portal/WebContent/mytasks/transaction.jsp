<%@ page import="com.eventbee.general.*" %>

<%
String groupid=request.getParameter("groupid");
String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{groupid});
if(eventname==null)
eventname=" ";
String platform=request.getParameter("platform");
String tokenid=request.getParameter("tokenid");
String from=request.getParameter("from");
String trackcode=request.getParameter("trackcode");
String secretcode=request.getParameter("secretcode");

String toURL="";
if("regreports".equals(from)){
toURL="<a href='/mytasks/reg_reports.jsp?filter=manager&evttype=event&GROUPID="+groupid+"&platform="+platform+"&tokenid="+tokenid+"'>Event Registrations</a>";
}else if("attendeereports".equals(from)){
toURL="<a href='/mytasks/attendeelist_report.jsp?filter=manager&evttype=event&GROUPID="+groupid+"&platform="+platform+"&tokenid="+tokenid+"'>Attendee List</a>";
}else if("trackreport".equals(from)){
toURL="<a href='/mytasks/trackreport.jsp?filter=manager&evttype=event&trackcode="+trackcode+"&secretcode="+secretcode+"&gid="+groupid+"&platform="+platform+"&tokenid="+tokenid+"'>Tracking URL Report</a>";
}else{
toURL="Report";
}

String link="<a href='/mytasks/eventmanage.jsp?GROUPID="+groupid+"'>"+eventname+"</a>";
request.setAttribute("tasktitle","Event Manage > "+link+" > "+toURL+" > Transaction Report");
request.setAttribute("mtype","My Console");
request.setAttribute("stype","Events");
       
%>
<%@ include file="/templates/taskpagetop.jsp" %>
<%
taskpage="/ntspartner/transaction.jsp";
%>
<%@ include file="/templates/taskpagebottom.jsp" %>
	
