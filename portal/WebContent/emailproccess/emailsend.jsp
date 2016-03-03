<%@ page import="com.eventbee.general.*,java.util.*"%>
<%@ page import="java.io.*,java.sql.*,com.eventbee.general.EventbeeConnection"%>
<%@ page import="com.eventbee.useraccount.AccountDB,com.eventbee.authentication.*"%>
<%@ page import="com.eventbee.invitedemails.InvitedEmailDB"%>
<%!
String CLASS_NAME="emailsend.jsp";

String [] getValidEmailid(String [] emails){
	List strlst=new ArrayList();
	for(int i=0;i<emails.length;i++)
	{
	String st=emails[i];
	int s1=st.indexOf('@');
	int s2=st.indexOf('.');
	if ((s1==-1)||(s2==-1)){
	}
	else
	strlst.add(st);
	}
	String [] str = (String [])strlst.toArray(new String[strlst.size()]);
	return str;
}


public int SendEmail(EmailTemplate emailtemplate,String toemails,String fromemail,String subject,HashMap wordmap,String unitid,String purpose,String userid){
	  String emails[]=new String [0];
	  EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, CLASS_NAME, "sendmail(..", " enetered the SendMail ", null);
	  try{
              	EmailObj emailobj=new EmailObj();
	 	 emails=GenUtil.strToArrayStr(toemails,",");
		 emails=getValidEmailid(emails);
         	 for(int i=0;i<emails.length;i++){
             	if(i>=50) break;
    	        emailobj.setFrom(fromemail);
		emailobj.setTo(emails[i]);
		emailobj.setSubject(TemplateConverter.getMessage(wordmap,subject));
		emailobj.setTextMessage(TemplateConverter.getMessage(wordmap,emailtemplate.getTextFormat()));
		emailobj.setHtmlMessage(TemplateConverter.getMessage(wordmap,emailtemplate.getHtmlFormat()));
		emailobj.setSendMailStatus(new SendMailStatus(unitid,purpose,userid,"1"));
	 	EventbeeMail.sendHtmlMail(emailobj);

         	}
	}catch(Exception e){
		 System.out.println(" There is an error in send mail:"+ e.getMessage());
	   }
	   return emails.length;
	}
%>
<%

	String userid=session.getId();
        Authenticate au=(Authenticate)com.eventbee.general.AuthUtil.getAuthData(pageContext);
        if(au!=null) userid=au.getUserID();
	
	String toemails=request.getParameter("toemails");
	String fromemail=request.getParameter("fromemail");
	String fromname=request.getParameter("fromname");
	String subject=request.getParameter("subject");
	String personalmessage=request.getParameter("personalmessage");

	String id=request.getParameter("id");
	String purpose=request.getParameter("purpose");
	//String unitid=request.getParameter("UNITID");

      	EmailTemplate emailtemplate=(EmailTemplate)session.getAttribute(id+"_"+purpose+"_EMAILTEMPLATE");
	if(emailtemplate==null)
	emailtemplate=new EmailTemplate("13579",purpose);
	HashMap wordmap=(HashMap)session.getAttribute(id+"_"+purpose);
	if(wordmap!=null){
	wordmap.put("#**personalmessage**#",personalmessage);
	wordmap.put("#**personalmessagehtml**#",GenUtil.textToHtml(personalmessage,true));
	wordmap.put("#**fromname**#",fromname);
	}
	int count=0;
	//EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, CLASS_NAME, "jspservice(..", " toid= "+toid, null);
	if(emailtemplate!=null&&wordmap!=null)
	count=SendEmail(emailtemplate,toemails,fromemail,subject,wordmap,"13579",purpose,userid);
	session.removeAttribute(id+"_"+purpose+"_EMAILTEMPLATE");
	session.removeAttribute(id+"_"+purpose);
	response.sendRedirect("done.jsp?count="+count);
 %>
