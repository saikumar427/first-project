<%@ page import="com.eventbee.general.*" %>


<%String groupid=request.getParameter("GROUPID");
String clubname=DbUtil.getVal("select clubname from clubinfo where clubid=?",new String[]{groupid});

if(clubname==null)
clubname=" ";
String link="<a href='/mytasks/clubmanage.jsp?clubname="+clubname+"&GROUPID="+groupid+"'>"+clubname+"</a>";
request.setAttribute("tasktitle","Community Manage > "+link+" > Edit Discount");
request.setAttribute("mtype","My Console");
request.setAttribute("stype","Community");

%>




<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/clubdiscounts/EditDiscount.jsp";
%>
	      		
<%@ include file="/templates/taskpagebottom.jsp" %>
	

	