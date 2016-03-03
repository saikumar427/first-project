<%@ page import="java.util.*,java.io.*,javax.servlet.http.*,com.eventbee.event.ticketinfo.AttendeeInfoDB,com.eventbee.general.GenUtil,com.eventbee.general.*"%>
<%
response.setContentType("application/vnd.ms-excel");
String CLASSNAME="excelreports.jsp";
Vector v1=null;
String type="";
String vec=(String)request.getAttribute("REPORTSCONTENT");
System.out.println("vec------------------"+vec);

//out.println(" ");
out.println(vec);
out.println(" ");
%>
