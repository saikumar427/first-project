<%@ page import="com.eventbee.general.*"%>
<%!
public void SendEmail(String fromemail,String toemail,String message)
	{	 
		try
		{
			EmailObj obj=EventbeeMail.getEmailObj();							
			obj.setTextMessage(message);
			obj.setFrom(fromemail);			
			obj.setTo(toemail);
			EventbeeMail.sendHtmlMail(obj);			
		}
		catch(Exception e)
		{
			System.out.println(" There is an error in send mail:"+ e.getMessage());
		}
	}
%>
<% 
String partnerid=request.getParameter("partnerid");
System.out.println(partnerid);
String eventid=request.getParameter("eventid");
String toemail=DbUtil.getVal("select email from eventinfo where eventid=?",new String[]{eventid});

String message=request.getParameter("message");

String fromemail=request.getParameter("email");

SendEmail(fromemail,toemail,message);
String isexist=DbUtil.getVal("select 'Yes' from manual_nts_events where eventid=? and partnerid=?",new String[]{eventid,partnerid});
if(isexist==null)
DbUtil.executeUpdateQuery("insert into manual_nts_events(partnerid,status,eventid)values(?,'Pending',?)",new String[]{partnerid,eventid});

%>
<status>success</status>