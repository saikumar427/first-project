<%@ page import="java.util.*,com.eventbee.general.*" %>

<%

request.setAttribute("mtype","My Email Marketing");
String campname=DbUtil.getVal("select camp_name from email_campaign where campid=?",new String[]{request.getParameter("campid")});

request.setAttribute("tasktitle","My Email Blast ><a href=/mytasks/manageemailcamp.jsp?campid="+request.getParameter("campid")
								+">Status</a> > <a href=/mytasks/emailcampreports.jsp?landf=yes&campid="+request.getParameter("campid")+">Reports</a> >");
request.setAttribute("tasksubtitle","Graph View");


%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/emailcamp/graphview.jsp";
	%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	

	