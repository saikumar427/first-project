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


public int SendEmail(String toemails,String fromemail,String subject,String unitid,String userid,String message,String purpose,String url){
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
		emailobj.setSubject(subject);
		
		emailobj.setHtmlMessage(message);
		message=message.replaceAll("<br/>","\n");
		emailobj.setTextMessage(message);
		
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
        String message=" ";
	String url1=request.getParameter("url");
	
	String toemails=request.getParameter("toemails");
	String fromemail=request.getParameter("fromemail");

	String fromname=request.getParameter("fromname");

	String subject=request.getParameter("subject");

	String personalmessage=request.getParameter("personalmessage");

	personalmessage=GenUtil.processTextHtml(personalmessage,true);
	String evttype=request.getParameter("evttype");
	
	if("events".equals(evttype))
	{
	 message=personalmessage 
	               +"<br/><br/> Visit page by clicking on the following URL <br/><br/>"
	               +"<a href="+url1+">events.eventbee.com</a>";
	  }             
	  if("events".equals(evttype))             
	               {
	                message=personalmessage 
		       	               +"<br/><br/> Visit page by clicking on the following URL <br/><br/>"
	               +"<a href="+url1+">classes.eventbee.com</a>";
	               }
	   
	   if("photos".equals(evttype)) 
	   {
	   	                message=personalmessage 
	   		       	               +"<br/><br/> Visit page by clicking on the following URL <br/><br/>"
	   	               +"<a href="+url1+">photos.eventbee.com</a>";
	   	               }
	   
	               
	               
	String id=request.getParameter("id");

	String purpose=request.getParameter("purpose");

	String unitid=request.getParameter("UNITID");

     
	int count=0;
	
	count=SendEmail(toemails,fromemail,subject,unitid,userid,message,purpose,url1);

String url="Email sent to "+count+" recepient(s)";

 %>
 
 <%=url%>
