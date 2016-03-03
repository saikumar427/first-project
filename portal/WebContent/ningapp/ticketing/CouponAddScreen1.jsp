<%@ page import="com.eventbee.general.*" %>

<link rel="stylesheet" type="text/css" href="/home/index.css" />

<%
String groupid=request.getParameter("groupid");
String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{groupid});

if(eventname==null)
eventname=" ";
String link="<a href='/ningapp/ticketing/eventmanage.jsp;jsessionid="+session.getId()+"?eventname="+eventname+"&GROUPID="+groupid+"'>"+eventname+"</a>";
String Myevents="<a href='/ningapp/ticketing/canvasownerpagebeelets.jsp;jsessionid="+session.getId()+"'>My Events</a>";
request.setAttribute("tasktitle", Myevents+" > Event Manage > "+link+" > Add  Discount");

//request.setAttribute("tasktitle","Event Manage > "+link+" > Add  Discount");

%>

<jsp:include page="/ningapp/taskheader.jsp"/> 

<%
request.setAttribute("mtype","Events");
request.setAttribute("stype","Events");
%>
<jsp:include page='/discounts/CouponAddScreen1.jsp'>
<jsp:param  name='GROUPID'  value='<%=groupid%>' />
<jsp:param  name='platform'  value='ning' />

</jsp:include>

