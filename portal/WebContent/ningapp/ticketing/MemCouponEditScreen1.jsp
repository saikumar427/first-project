<%@ page import="com.eventbee.general.*" %>

<link rel="stylesheet" type="text/css" href="/home/index.css" />

<%
String groupid=request.getParameter("GROUPID");
String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{groupid});

if(eventname==null)
eventname=" ";
String link="<a href='/ningapp/ticketing/eventmanage.jsp?eventname="+eventname+"&GROUPID="+groupid+"'>"+eventname+"</a>";

request.setAttribute("tasktitle","Event Manage > "+link+" > Add  Discount");

%>

<jsp:include page="/ningapp/taskheader.jsp"/> 

<%
request.setAttribute("mtype","Events");
request.setAttribute("stype","Events");
%>
<jsp:include page='/discounts/MemCouponEditScreen1.jsp'>
<jsp:param  name='GROUPID'  value='<%=groupid%>' />
<jsp:param  name='platform'  value='ning' />

</jsp:include>

