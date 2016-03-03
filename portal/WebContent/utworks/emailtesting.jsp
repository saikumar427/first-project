<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.general.formatting.*" %>	
<%@ page import="java.util.*,com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>


<%


			EmailObj emailobj=new EmailObj();
			emailobj.setTo("kumar@eventbee.org");
			emailobj.setBcc("bala@eventbee.com");
			emailobj.setFrom("vamshi@eventbee.org");
			//emailobj.setTextMessage("Text message" );
			emailobj.setHtmlMessage("Test message from ser1");

			emailobj.setSubject("testing mails");
			emailobj.setReplyTo("vamshi@eventbee.org");
			EventbeeMail.sendHtmlMailPlain(emailobj);
			//EventbeeMail.sendTextMailPlain(emailobj);
			
			//EventbeeMail.sendHtmlMail(emailobj);
			//EventbeeMail.sendTextMail(emailobj);
			out.println("mails sent");



%>

