<%@ page import="com.eventbee.general.*" %>
<%@ page import="java.util.*,java.io.*" %>

<%
String filelocation=EbeeConstantsF.get("static.content.location","c:/jboss-3.2.2/server/default/deploy/content.war/static/")+"content2j.html";
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, "in content2j.jsp", "in /staticcontent/content2j.jsp", "filelocation is-------"+filelocation,null);
File f=new File(filelocation);
String filecontent="";
	if(!f.exists()){ 
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, "in content2j.jsp", "in /staticcontent/content2j.jsp", "f.exists() is-------"+f.exists(),null);
	}else{
		char content[]=new char[(int)f.length()];
		FileReader fr=new FileReader(f);
		int file_chars=fr.read(content,0,(int)f.length());
		filecontent=new String(content);
		fr.close();
	}
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, "in content2j.jsp", "in /staticcontent/content2j.jsp", "filecontent is-------"+filecontent,null);
%>
<%=filecontent%>

