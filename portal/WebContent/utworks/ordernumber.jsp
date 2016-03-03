<%@ page import="java.util.ArrayList"%>
<%@ page import="com.eventbee.general.*"%>
<%!

	ArrayList getIds(){
ArrayList al=new ArrayList();
		DBManager db=new DBManager();
		StatusObj sb=db.executeSelectQuery("SELECT distinct eventid from event_reg_transactions where eventid in (select eventid from eventinfo where status='ACTIVE')", null);
		
		if(sb.getStatus()){
		for(int i=0;i<sb.getCount();i++){		
		al.add(db.getValue(i,"eventid",""));
		}
		}

		return al;
	}
	
	ArrayList getTIds(String eventid){
ArrayList al=new ArrayList();

			DBManager db=new DBManager();
			StatusObj sb=db.executeSelectQuery("SELECT tid from event_reg_transactions where ordernumber is null and eventid =? order by transaction_date", new String[]{eventid});
			
			if(sb.getStatus()){
			for(int i=0;i<sb.getCount();i++){		
			al.add(db.getValue(i,"tid",""));
			}
			}

			return al;
	}
	String update_tid_query="update event_reg_transactions set ordernumber=? where tid=?";	
	%>

<%
ArrayList refids=getIds();
for (int i=0;i<refids.size();i++)
{
String refid=(String)refids.get(i);

ArrayList tids=getTIds(refid);
for(int k=0;k<tids.size();k++)
{
String tid=(String)tids.get(k);
out.println("<br>Eventid: "+refid+" tid: "+tid+" </br>");
DbUtil.executeUpdateQuery(update_tid_query, new String[]{""+(k+1), tid});
}

}
%>

Done
