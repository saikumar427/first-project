<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.general.formatting.*" %>	
<%@ page import="java.util.*,com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>


<%

 String from=request.getParameter("fromemail");
 String toid  =  request.getParameter("toemails");
 String testmessage=request.getParameter("personalmessage");
 String subject=request.getParameter("sub");
 toid=GenUtil.traverseString(toid.trim()," ","");
 toid=GenUtil.traverseString(toid,",,",",");

 String emails[]=GenUtil.strToArrayStr(toid,",");
 EmailObj emailobj=new EmailObj();
			
			
if(emails!=null){
	emailobj.setFrom(from);
	emailobj.setTextMessage(testmessage);
	testmessage=testmessage.replaceAll("\n","<br>");
	emailobj.setHtmlMessage(testmessage);

	emailobj.setSubject(subject);
	emailobj.setReplyTo(from);

	for(int i=0;i<emails.length;i++){
emailobj.setTo(emails[i]);




EventbeeMail.sendHtmlMailPlain(emailobj);
//EventbeeMail.sendTextMailPlain(emailobj);
}					
}
			
							
 out.println("mails sent");



%>

