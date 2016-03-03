<%@ page import="com.eventbee.general.*,java.util.*"%>
<%@ page import="java.io.*,java.sql.*,com.eventbee.general.EventbeeConnection"%>
<%@ page import="org.eventbee.sitemap.util.LinkConstants,com.eventbee.general.formatting.EventbeeStrings"%>
<%@ page import="org.eventbee.sitemap.util.LinksGenerator"%>
<%@ page import="com.eventbee.useraccount.AccountDB"%>
<%@ page import="com.eventbee.invitedemails.InvitedEmailDB"%>
<%@ page import="com.eventbee.authentication.*,com.eventbee.event.*"%>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>
<!--jsp:include page="/auth/authenticate.jsp" /-->
<%
String unitid=request.getParameter("UNITID");
%>
<%!
String CLASS_NAME="f2fsponsor/EmailSend.jsp";

	 HashMap fillData(String personalmessage){
		HashMap mp=new HashMap();
		//mp.put("#**firstname**#",fname);
		//mp.put("#**lastname**#",lname);
		mp.put("#**page**#","Event");
		mp.put("#**PERSONALMESSAGE**#",personalmessage);
		return mp;
	 }
	                                                     
       							     
	public int SendEmail(String toemail,String fromemail,String userid,String subject,String message,String HTMLcontent,String invite_id){

		int count=0;
		String emails[]=new String [0];
		String invitation_to="insert into invitation_to (inv_id,to_id,visit_count) values (?,?,0) ";
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, CLASS_NAME, "sendmail(..", " entered the SendMail ", null);
		try{
              		 EmailObj obj=EventbeeMail.getEmailObj();
		 	 String purpose="Invite Event Manager";
		 	 if(!"".equals(toemail)){
		 		 emails=GenUtil.strToArrayStr(toemail,",");
		 		
         	 for(int i=0;i<emails.length;i++){
			 obj.setFrom(fromemail);
			 obj.setReplyTo(fromemail);
			 obj.setSubject(subject);
			 obj.setTextMessage(message);
			 obj.setHtmlMessage(HTMLcontent);
			 obj.setSendMailStatus(new SendMailStatus("13579",purpose,userid,"1"));
			 
			 		obj.setTo(emails[i]);
					InvitedEmailDB.InvitedEmails(userid,purpose,emails[i].trim());
					EventbeeMail.sendHtmlMail(obj);
					DbUtil.executeUpdateQuery(invitation_to,new String[]{invite_id,emails[i].trim()});
			}
			}
		}catch(Exception e){
		}
	 return emails.length;
	}
%>

<%
        int isproxy=0;
        String contactEmail=null;
	String userid=null;
	String userunitid=null;
	
	Authenticate au=AuthUtil.getAuthData(pageContext);
	
        if(au!=null){
               userid=au.getUserID();
	       userunitid=au.getUnitID();
	}
	String fromid=request.getParameter("fromemail");
	String toid=request.getParameter("toemail");
	
	if(toid==null) toid="";
	
	String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";
	String fromproxy=(String)session.getAttribute("fromproxy");
	
	if("Yes".equals(fromproxy))
		isproxy=1;
	//if("13579".equals(userunitid))
	        isproxy=6;
	
	String subject=request.getParameter("subject");
	String personalmessage=request.getParameter("personalmessage");
	EmailTemplate emailtemplate=new EmailTemplate("13579","INVITE EVENT LIST");
	HashMap MessageMap=fillData(personalmessage);
	String content=TemplateConverter.getMessage(MessageMap,emailtemplate.getTextFormat());
	
	String HTMLcontent=TemplateConverter.getMessage(MessageMap,emailtemplate.getHtmlFormat());

	toid=GenUtil.traverseString(toid.trim()," ","");
	
        EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, CLASS_NAME, "jspservice(..", " toid= "+toid, null);
	String invitation_from=" insert into invitation_from (inv_id,from_id,invdate,message,subject,groupid,inv_type) values (?,?,now(),?,?,?,?) ";
	String inviteid=DbUtil.getVal("select nextval('inv_id_sequence')",null);
	StatusObj stob=DbUtil.executeUpdateQuery(invitation_from,new String[]{inviteid,userid,HTMLcontent,subject,null,"EVENT"});
	int result=SendEmail(toid,fromid,userid,subject,content,HTMLcontent,inviteid);
	//response.sendRedirect(appname+"/guesttasks/emaildone.jsp?count="+result);
%>
  <%--<%="Email sent to "+result+" member(s)"%>--%>
  <%="Invitation email sent to Event Manager"%>
