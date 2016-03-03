<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.general.formatting.*" %>
<%!
	Vector getclosedevents(String startdate,String enddate)
	{
	Vector eventsvector=new Vector();
	DBManager dbmanager=new DBManager();
	HashMap eventshashmap = null; 
	StatusObj statobj=dbmanager.executeSelectQuery("select a.eventid, eventname, b.end_date, sum(ticketqty), c.first_name,last_name,d.login_name,password from attendeeticket a, eventinfo b, user_profile c,authentication d where a.eventid=b.eventid and c.user_id=b.mgr_id and c.user_id=d.user_id and b.end_date>? and b.end_date<? group by a.eventid, eventname,  b.end_date, first_name, last_name,login_name,password order by b.end_date ",new String [] {startdate,enddate});		 
	if(statobj.getStatus())
	{
		for(int k=0;k<statobj.getCount();k++)
		{
			eventshashmap=new HashMap();
			eventshashmap.put("first_name",dbmanager.getValue(k,"first_name",""));	
			eventshashmap.put("last_name",dbmanager.getValue(k,"last_name",""));
			eventshashmap.put("end_date",dbmanager.getValue(k,"end_date",""));			
			eventshashmap.put("eventid",dbmanager.getValue(k,"eventid",""));
			eventshashmap.put("sum",dbmanager.getValue(k,"sum",""));
			eventshashmap.put("eventname",dbmanager.getValue(k,"eventname",""));
			eventshashmap.put("login_name",dbmanager.getValue(k,"login_name",""));
			eventshashmap.put("password",dbmanager.getValue(k,"password",""));

			eventsvector.add(eventshashmap);
		}
	}
	return eventsvector;
	}
%>

<center><FONT SIZE="5" COLOR=""><B>Ticket sale report for closed events.</B></FONT>
<TABLE width="100%" border="">
<th>Event Name</th>
<th>End Date</th>
<th>First Name</th>
<th>Last Name</th>
<th>EventId</th>
<th>Sum</th>
<th>Login Name</th>
<th>Password</th>
<br>
<br>
<%
    Vector v1=null;   
  	String startdate=request.getParameter("startdate");  
	String enddate=request.getParameter("enddate"); 
	v1=getclosedevents(startdate,enddate);
    if(v1!=null&&v1.size()>0)
    {
    	for(int i=0;i<v1.size();i++)
    	{
    		HashMap hmt=(HashMap)v1.elementAt(i);
    		String first_name = (String)hmt.get("first_name");
			String end_date = (String)hmt.get("end_date");
			String last_name=(String)hmt.get("last_name");
			String eventid = (String)hmt.get("eventid");
			String sum = (String)hmt.get("sum");
			String eventname = (String)hmt.get("eventname");
			String login_name=(String)hmt.get("login_name");
			String password=(String)hmt.get("password");
%>
<tr>
<td align="center"><%=eventname%></td>
<td align="center"><%=end_date%></td>
<td align="center"><%=first_name%></td>
<td align="center"><%=last_name%></td>
<td align="center"><%=eventid%></td>
<td align="center"><%=sum%></td>
<td align="center"><%=login_name%></td>
<td align="center"><%=(new StringEncrypter(StringEncrypter.DES_ENCRYPTION_SCHEME) ).decrypt(password)%></td>
</tr>
<%    
    	}
    }
	
%>

</TABLE>

