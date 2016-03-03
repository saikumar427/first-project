<%@ page import="com.eventbee.general.*" %>



<%


String groupid=request.getParameter("groupid");
String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{groupid});

if(eventname==null)
eventname=" ";
String link="<a href='/mytasks/eventmanage.jsp?GROUPID="+groupid+"'>"+eventname+"</a>";
request.setAttribute("tasktitle","Event Manage > "+link+"  > Add  Discount");
request.setAttribute("mtype","My Console");

request.setAttribute("stype","Events");


%>






<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/discounts/MemCouponAddScreen1.jsp";
%>
	      		
<%@ include file="/templates/taskpagebottom.jsp" %>
	

	