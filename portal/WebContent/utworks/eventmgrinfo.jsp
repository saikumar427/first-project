<%@page import="com.eventbee.general.*"%>
<%
String query="select  eventname, email, login_name, password, 'http://www.eventbee.com/event?eid='||eventid as url "
      +" from eventinfo a, authentication b  where end_date in ('2009-12-31', '2010-01-01') and a.mgr_id=b.user_id";

DBManager db=new DBManager();
			 
			 StatusObj sob=db.executeSelectQuery(query,null);
			
%>
<table border="1"cellpadding=2 cellspacing=2>
<tr><th>Event Name</th><th>URL</th><th>Email</th><th>Login Name</th><th>Password</th></tr>	
<%
			
			for(int i=0;i<sob.getCount();i++){  
			
			String eventname=db.getValue(i,"eventname","");
			String login_name=db.getValue(i,"login_name","");
			String password=db.getValue(i,"password","");
		        password=(new StringEncrypter(StringEncrypter.DES_ENCRYPTION_SCHEME) ).decrypt(password);
		        String email=db.getValue(i,"email","");
		        String url=db.getValue(i,"url","");
%>
	<tr><td><%=eventname%></td><td><%=url%></td><td><%=email%></td><td><%=login_name%></td><td><%=password%></td></tr>	        
<%
		        }
%>
</table>
