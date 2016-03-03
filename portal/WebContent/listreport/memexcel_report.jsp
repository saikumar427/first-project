<%@ page import="java.util.*,java.io.*,javax.servlet.http.*,com.eventbee.event.ticketinfo.AttendeeInfoDB,com.eventbee.general.GenUtil,com.eventbee.general.*"%>
<%
response.setContentType("application/vnd.ms-excel");  
response.setHeader("Content-disposition","attachment; filename=memberreports.xls");  
String CLASSNAME="excelreports.jsp";
Vector v1=null;
String type="";
String vec=(String)request.getAttribute("REPORTSCONTENT");
out.println(vec);
out.println(" ");
%>
