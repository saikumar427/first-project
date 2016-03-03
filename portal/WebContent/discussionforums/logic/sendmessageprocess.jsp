<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.general.*" %>


<%


String sendfrom=request.getParameter("sender");
String sendto=request.getParameter("receipent");
String message=request.getParameter("msg");
String touserid=request.getParameter("msgto");
String bcc=EbeeConstantsF.get("forum.message.mail.bcc","sridevi@beeport.com");


String encryptuserid=EncodeNum.encodeNum(touserid);


String groupid=request.getParameter("GROUPID");
String subject=request.getParameter("subject");
HashMap localParams=new HashMap();
localParams.put("groupid", (!"null".equals(request.getParameter("GROUPID"))?request.getParameter("GROUPID"):null));
localParams.put("grouptype", (!"null".equals(request.getParameter("grouptype"))?request.getParameter("grouptype"):null));
localParams.put("forumid", (!"null".equals(request.getParameter("forumid"))?request.getParameter("forumid"):null));
localParams.put("topicid", (!"null".equals(request.getParameter("topicid"))?request.getParameter("topicid"):null));
localParams.put("msgto", (!"null".equals(request.getParameter("msgto"))?request.getParameter("msgto"):null));

session.setAttribute("smshash",localParams);
		

try{
   	EmailTemplate emailtemplate=null;
   	String communityspecificemail=DbUtil.getVal("select 'yes' from email_templates where groupid=? and purpose=? and unitid=?", new String [] {groupid,"SEND_FORUM_MESSAGES","13579"});
	System.out.println("communityspecificemail====="+communityspecificemail);
	if("yes".equals(communityspecificemail))
	 emailtemplate=new EmailTemplate("13579","SEND_FORUM_MESSAGES",groupid);
	else
	emailtemplate=new EmailTemplate("13579","SEND_FORUM_MESSAGES");
	  EmailObj obj=EventbeeMail.getEmailObj();
        HashMap wordReplaceMap=new HashMap();
        wordReplaceMap.put("#**HTML_MESSAGE**#",message);
        wordReplaceMap.put("#**SUBJECT**#",subject);
	wordReplaceMap.put("#**FROMMAIL**#",sendfrom);
	wordReplaceMap.put("#**ENCUSRID**#",encryptuserid);
	wordReplaceMap.put("#**GROUPID**#",groupid);
        obj.setTo(sendto);
        obj.setFrom(TemplateConverter.getMessage(wordReplaceMap,emailtemplate.getFromMail() )  );
	obj.setBcc(bcc);
        obj.setSubject(TemplateConverter.getMessage(wordReplaceMap,emailtemplate.getSubjectFormat()));
        String htmlmessage=TemplateConverter.getMessage(wordReplaceMap,emailtemplate.getHtmlFormat());
       
        obj.setHtmlMessage(htmlmessage);
        EventbeeMail.sendHtmlMailPlain(obj);
        }
    catch(Exception e){
       EventbeeLogger.logException("com.eventbee.exception",EventbeeLogger.INFO,"sendMessageprocess.jsp","SendMail()","ERROR in SendMail method",e);
    }


response.sendRedirect("/mytasks/smsdone.jsp?GROUPID="+request.getParameter("GROUPID")+"&message=Message sent successfully&type=Messages");

%>