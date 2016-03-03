<%@ page import="com.eventbee.general.*" %>
<%@ page import="java.util.*,java.io.*" %>
<%
	String file= request.getParameter(".file");
	String filecontent=request.getParameter("filecontent");
	boolean error=false;
	try{
		File f=new File(file);
		FileWriter fw=new FileWriter(f);
		fw.write(filecontent);
		fw.close();
		out.println("<B> Sucessfully Changed </B>");
	}catch(Exception e){
		out.println("Exception: "+e);
	}	
%>	
	
