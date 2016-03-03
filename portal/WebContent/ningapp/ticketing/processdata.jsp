

<%@ page import="com.eventbee.general.*" %>

<link rel="stylesheet" type="text/css" href="/home/index.css" />

<%
String source=request.getParameter("source");

String id=request.getParameter("transactionid");

String eventid=request.getParameter("GROUPID");
%>


<%
String login_name=DbUtil.getVal("select au.login_name from authentication au,eventinfo e where au.user_id=e.mgr_id and eventid=?",new String[]{request.getParameter("GROUPID")});

String evtname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{request.getParameter("GROUPID")});
String listurl=ShortUrlPattern.get(login_name)+"/event?eventid="+request.getParameter("GROUPID");
String evtlink="<a href='"+listurl+"'>"+evtname+"</a>";
request.setAttribute("tasktitle","Event Registration > "+evtname+" > Confirmation");
%>

<jsp:include page="/ningapp/taskheader.jsp" > 
<jsp:param  name='showhome'  value='No' />
</jsp:include>


<jsp:include page='/eventregister/reg/processdata.jsp'>
<jsp:param  name='source'  value='<%=source%>' />
<jsp:param  name='id'  value='<%=request.getParameter("id")%>' />
<jsp:param  name='GROUPID'  value='<%=eventid%>' />
</jsp:include>

