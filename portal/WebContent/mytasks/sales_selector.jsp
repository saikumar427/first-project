<%@ page import="com.eventbee.general.*" %>
<%@ page import="java.text.*,java.text.SimpleDateFormat"%>
<%@ page import="com.eventbee.general.formatting.*" %>
<%
DateFormat DATEFORMAT=new SimpleDateFormat("MM/dd/yyyy");
java.util.Date dt=new java.util.Date();
String currentdate=DATEFORMAT.format(dt);
String groupid=request.getParameter("groupid");
String clubname=DbUtil.getVal("select clubname from clubinfo where clubid=?",new String[]{groupid});

if(clubname==null)
clubname=" ";
String link="<a href='/mytasks/clubmanage.jsp?clubname="+clubname+"&GROUPID="+groupid+"'>"+clubname+"</a>";
request.setAttribute("tasktitle","Community Manage > "+link+" > Summary Reports");
request.setAttribute("stype","Events");
request.setAttribute("mtype","community");

request.setAttribute("mtype","community");
//request.setAttribute("tasktitle","Sales Summary");
request.setAttribute("tasksubtitle",currentdate);


%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%
	taskpage="/listreport/sales_selector.jsp";
%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	

	