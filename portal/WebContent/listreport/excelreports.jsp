<%@ page contentType="application/vnd.ms-excel"%>
<%

response.setContentType("application/vnd.ms-excel");  
response.setHeader("Content-disposition","attachment; filename=report.xls");  

String vec=(String)request.getAttribute("REPORTSCONTENT");
out.println(vec);
out.println(" ");
%>
