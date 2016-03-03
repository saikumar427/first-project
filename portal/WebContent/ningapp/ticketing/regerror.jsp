<%@ page import="com.eventbee.general.*" %>

<link rel="stylesheet" type="text/css" href="/home/index.css" />

<%
String login_name=null;
String evtname=null;
if((String)session.getAttribute("evtmgrname")!=null)
	login_name=(String)session.getAttribute("evtmgrname");
else if((String)session.getAttribute("evtmgrname")==null)
      login_name=DbUtil.getVal("select au.login_name from authentication au,eventinfo e where au.user_id=e.mgr_id and eventid=?",new String[]{request.getParameter("GROUPID")});

if((String)session.getAttribute("evtname")!=null)
	evtname=(String)session.getAttribute("evtname");
else if((String)session.getAttribute("evtname")==null)
	evtname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{request.getParameter("GROUPID")});


String listurl=ShortUrlPattern.get(login_name)+"/event?eventid="+request.getParameter("GROUPID");
String evtlink="<a href='"+listurl+"'>"+evtname+"</a>";

request.setAttribute("tasktitle","Event Registration > "+evtlink+ " > Error" );
%>

<jsp:include page="/ningapp/taskheader.jsp" > 
<jsp:param  name='showheader'  value='No' />
</jsp:include>


<jsp:include page='/eventregister/reg/error.jsp'>
<jsp:param  name='GROUPID'  value='<%=request.getParameter("GROUPID")%>' />
</jsp:include>

