<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.authentication.*" %>
<%!

public void SendEmail(String email,String []emails1,String message,String subject){
		try{
			EmailObj obj=EventbeeMail.getEmailObj();
			obj.setHtmlMessage(message);
			obj.setFrom(email);
			obj.setSubject(subject);
			for(int k=0;k<emails1.length;k++){
           		String tomail=emails1[k];
			obj.setTo(tomail);				
			}
			
			EventbeeMail.sendHtmlMailPlain(obj);
			  
		}catch(Exception e){
			System.out.println(" There is an error in send mail:"+ e.getMessage());
		}
	}
%>
<% 
String eventid=request.getParameter("eventid");

String toemail=request.getParameter("emailsString");
toemail=GenUtil.traverseString(toemail.trim()," ","");
toemail=GenUtil.traverseString(toemail,",,",",");	
String message=request.getParameter("message");
String subject=request.getParameter("subject");
String userid="";
Authenticate authData=AuthUtil.getAuthData(pageContext);
	if(authData!=null){
		userid= authData.getUserID();
	}
	
	String fromemail=DbUtil.getVal("select email from user_profile where user_id=?",new String[]{userid});
	
String emails[]=GenUtil.strToArrayStr(toemail,",");
SendEmail(fromemail,emails,message,subject);

%>
<status>success</status>