<%@ page import="com.eventbee.general.*,java.util.*"%>
<%@ page import="java.io.*,java.sql.*,com.eventbee.general.EventbeeConnection"%>
<%@ page import="com.eventbee.useraccount.AccountDB,com.eventbee.authentication.*"%>
<%@ page import="com.eventbee.invitedemails.InvitedEmailDB,com.eventbee.filters.IPFilter"%>
<%@ include file='/globalprops.jsp' %>
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


public int SendEmail(String toemails,String fromemail,String subject,String unitid,String userid,String personalmessage,String purpose){
	  String emails[]=new String [0];
	  EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, CLASS_NAME, "sendmail(..", " enetered the SendMail ", null);
	  try{
              	EmailObj emailobj=new EmailObj();
	 	 emails=GenUtil.strToArrayStr(toemails,",");
		 emails=getValidEmailid(emails);
         	 for(int i=0;i<emails.length;i++){
             	if(i>=10) break;
    	        emailobj.setFrom(fromemail);
		emailobj.setTo(emails[i]);
		emailobj.setSubject(subject);
		
		emailobj.setHtmlMessage(personalmessage);
		emailobj.setTextMessage(personalmessage);
		
		emailobj.setSendMailStatus(new SendMailStatus(unitid,purpose,userid,"1"));
	 	EventbeeMail.sendHtmlMail(emailobj);
		//EventbeeMail.sendHtmlMailPlain(emailobj);
		//EventbeeMail.insertStrayEmail(emailobj, "html", "S");
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
String ipd=request.getHeader("x-forwarded-for");
          if(ipd==null)ipd=request.getRemoteAddr();

personalmessage=GenUtil.processTextHtml(personalmessage,true);
String captchatxt=request.getParameter("captcha");
String text="";
String formname=request.getParameter("formname");
String captchasession=(String)session.getAttribute("captcha_"+formname);
String id=request.getParameter("id");
String purpose=request.getParameter("purpose");
String unitid=request.getParameter("UNITID");
int count=0;
if(captchatxt!=null)
text=captchatxt.trim();
else{
text="";
}
if(!text.equalsIgnoreCase(captchasession)){
out.print("<data>Error</data>");
}
else{String url="";
   
	int prevcount=IPFilter.EmailBlockIps.get(ipd)==null || "".equals(IPFilter.EmailBlockIps.get(ipd))?0:IPFilter.EmailBlockIps.get(ipd);
	 System.out.println("ipd::"+ipd+"prevcount::"+prevcount);
      if(prevcount<10)
	 {   if(GenUtil.strToArrayStr(toemails,",").length+prevcount <=10)
         { count=SendEmail(toemails,fromemail,subject,unitid,userid,personalmessage,purpose);
            url=getPropValue("email.sent.to.msg",id)+" "+count+" "+getPropValue("email.sent.to.msg2",id);
		   IPFilter.EmailBlockIps.put(ipd,count+prevcount);
	      }
	     else           
		   url="<font color='red'>"+getPropValue("email.invi.limit.msg",id)+"</font>";
		  
	 }
	 else{
	  url=getPropValue("no.email.sent.to.msg",id);
	 }
	session.removeAttribute("captcha_"+formname);   

 out.print("<data>"+url+"</data>");
}
 %>
