<%@ page import="com.eventbee.general.*" %>



<%String groupid=request.getParameter("groupid");
String clubname=DbUtil.getVal("select clubname from clubinfo where clubid=?",new String[]{groupid});

if(clubname==null)
clubname=" ";
String link="<a href='/mytasks/clubmanage.jsp?clubname="+clubname+"&GROUPID="+groupid+"'>"+clubname+"</a>";
request.setAttribute("tasktitle","Community Manage > "+link+" > Summary Reports");
request.setAttribute("stype","Events");
request.setAttribute("mtype","community");


%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%
	taskpage="/listreport/sales_reports.jsp";
%>
	      		
<%@ include file="/templates/taskpagebottom.jsp" %>
	

	