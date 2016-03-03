<%
String link1="<a href='/mytasks/myhubs.jsp'>My Communities </a>";
String link="<a href='/mytasks/clubmanage.jsp?clubname="+request.getParameter("clubname")+"&GROUPID="+request.getParameter("GROUPID")+"'> "+request.getParameter("clubname")+" </a>";
request.setAttribute("tasktitle",link1+ "  > "+link );
request.setAttribute("mtype","My Console");
request.setAttribute("stype","Community");

%>
<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/hub/members.jsp";
%>
	      		
<%@ include file="/templates/taskpagebottom.jsp" %>
	
