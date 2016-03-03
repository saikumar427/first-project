<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.general.*" %>

<%!
public Vector getTrackingURLdetails(String groupid){
	Vector v= new Vector();
	DBManager dbm =new DBManager();
	HashMap userhashmap=null;
	StatusObj statobj=null;
	String	query="select eventid,trackingcode,trackingid,count,secretcode from trackURLs where eventid=? ";
	statobj=dbm.executeSelectQuery(query,new String[]{groupid});
	
	if(statobj.getStatus()){
		for(int k=0;k<statobj.getCount();k++){
			userhashmap=new HashMap();
			userhashmap.put("eventid",dbm.getValue(k,"eventid",""));
			userhashmap.put("trackingid",dbm.getValue(k,"trackingid",""));
			userhashmap.put("trackingcode",dbm.getValue(k,"trackingcode",""));
			userhashmap.put("count",dbm.getValue(k,"count",""));			
			userhashmap.put("secretcode",dbm.getValue(k,"secretcode",""));
			v.add(userhashmap);
		}
	}
	return v;
	}	
	
Vector getTrackDetails(String groupid, String trackingcode){
String ticketid="";
String ticketname="";
Vector v=new Vector();
String query="select sum(ticketqty) as qty,ticketname,ticketid,groupname  from transaction_tickets where eventid=? and tid in (select transactionid from trackURL_transaction where trackingcode=?) group by ticketid,ticketname,groupname";
	  
	DBManager dbmanager=new DBManager();
	StatusObj statobj=dbmanager.executeSelectQuery(query,new String[]{groupid,trackingcode});
	if(statobj.getStatus()){
			for(int i=0;i<statobj.getCount();i++){
			HashMap hm=new HashMap();
			hm.put("qty", dbmanager.getValue(i,"qty",""));	
			hm.put("ticketid", dbmanager.getValue(i,"ticketid",""));
		        ticketid=dbmanager.getValue(i,"ticketid",""); 
		        ticketname=dbmanager.getValue(i,"ticketname","");
		        String groupName=dbmanager.getValue(i,"groupname","");
			if(!"".equals(groupName) && groupName!=null)
				ticketname=groupName+" - "+ticketname;
			else
			ticketname=ticketname;			
			hm.put("ticketname",ticketname);
			v.add(hm);
			}
	}
	return v;

}
	
	
%>
<%
String groupid=request.getParameter("eid");
String serveraddress=EbeeConstantsF.get("serveraddress","www.eventbee.com");
String eventurl=DbUtil.getVal("select url from event_custom_urls where eventid=?",new String[]{groupid});
if(eventurl!=null)
eventurl=eventurl+"/track/";
String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{groupid});
String linkpath="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com")+"/home/links";

Vector v1=getTrackingURLdetails(groupid);
String base="oddbase";
%>

<table class="portaltable" align="center" cellpadding="0" cellspacing="0" width="100%" border='0'>
<tr>
<td class='colheader' >Tracking URL</td>
<td class='colheader' align="center">Views</td>
<td class='colheader'>Tickets</td>
</tr>

<%
if(v1.size()>0){
   if(v1!=null&&v1.size()>0){
   for(int i=0;i<v1.size();i++){
   	   if(i%2==0) 
   	   base="evenbase";
   	  	else
   		base="oddbase";
   		String Ticketname="";
		String TicketCount="";
   		  HashMap hmt=(HashMap)v1.elementAt(i);
   		  String eventid=(String)hmt.get("eventid");	
   		  String trackingcode=(String)hmt.get("trackingcode");	
   		  String trackingid=(String)hmt.get("trackingid");
   		  String count=(String)hmt.get("count");
   		  String secretcode=(String)hmt.get("secretcode");

   		  
%>
<tr>
<td class="<%=base%>"><%=eventurl%><%=trackingcode%><br>
<a href='/mytasks/trackreport.jsp?landf=yes&filter=manager&gid=<%=eventid%>&trackcode=<%=trackingcode%>&secretcode=<%=secretcode%>'>Report</a>
</td>
<td class="<%=base%>" align="center"><%=count%></td>
<td class="<%=base%>">
<%
Vector vec=getTrackDetails(groupid,trackingcode);
if (vec!=null&&vec.size()>0){
for(int j=0;j<vec.size();j++){
   		  HashMap tiketdet=(HashMap)vec.elementAt(j);
   		  
%>
<%=tiketdet.get("ticketname")%> - <%=tiketdet.get("qty")%><br>
<%}}
}%></td></tr>
<%
}
}%></table>