<%@ page import="com.eventbee.general.*,java.util.*"%>
<%@ page import="java.io.*,java.sql.*,com.eventbee.general.EventbeeConnection"%>
<%@ page import="com.eventbee.useraccount.AccountDB,com.eventbee.authentication.*"%>
<%@ page import="com.eventbee.invitedemails.InvitedEmailDB"%>
<%!
String CLASS_NAME="emailtoevtmgr.jsp";

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


public int SendEmail(String toemail,String fromemail,String subject,String unitid,String userid,String message,String purpose,String url){
	  EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, CLASS_NAME, "sendmail(..", " entered the SendMail ", null);
	  try{
              	EmailObj emailobj=new EmailObj();
	 	 
    	        emailobj.setFrom(fromemail);
		emailobj.setTo(toemail);
		emailobj.setSubject(subject);
		
		emailobj.setHtmlMessage(message);
		message=message.replaceAll("<br/>","\n");
		emailobj.setTextMessage(message);
		
		emailobj.setSendMailStatus(new SendMailStatus(unitid,purpose,userid,"1"));
	 	EventbeeMail.sendHtmlMail(emailobj);
		//EventbeeMail.sendHtmlMailPlain(emailobj);
		//EventbeeMail.insertStrayEmail(emailobj, "html", "S");

	 	      	
	}catch(Exception e){
		 System.out.println(" There is an error in send mail:"+ e.getMessage());
	   }
	 return 1;
	}
%>
<%  
	System.out.println("Email to Manager");
	String msg="Email sent to event manager";
	String id=request.getParameter("id");
	if(id==null)
    { out.print("<data>"+msg+"</data>"); return;}
	try{Long.parseLong(id.trim());}catch(Exception e){out.print("<data>"+msg+"</data>");return; }
	
	String userid=session.getId();
	Authenticate au=(Authenticate)com.eventbee.general.AuthUtil.getAuthData(pageContext);
        if(au!=null) userid=au.getUserID();
        String message=" ";
	String url1=request.getParameter("url");

	String purpose=request.getParameter("purpose");
	String unitid="13579";
	int count=0;
	String toemail=DbUtil.getVal("select email from eventinfo where eventid=CAST(? AS INTEGER)",new String[]{id});
	String fromemail=request.getParameter("from_email");
	String fromname=request.getParameter("from_name");
	String subject=request.getParameter("subject");
	String personalmessage=request.getParameter("note");
	personalmessage=GenUtil.processTextHtml(personalmessage,true);
		
	message=personalmessage;
	
	String captchatxt=request.getParameter("captchamgr");
	String text="";
	String formname=request.getParameter("formnamemgr");
	String captchasession=(String)session.getAttribute("captcha_"+formname);
	//System.out.println("Email to Manager captchasession"+captchasession);
	if(captchatxt!=null)
	text=captchatxt.trim();
	else{
	
	text="";
	}
	 if(!text.equalsIgnoreCase(captchasession)){
	        
	          out.print("<data>Error</data>");
               }
	  else{            
	SendEmail(toemail,fromemail,subject,unitid,userid,message,purpose,url1);

	
	
	session.removeAttribute("captcha_"+formname);   
	out.print("<data>"+msg+"</data>");
}
 %>
 
 
