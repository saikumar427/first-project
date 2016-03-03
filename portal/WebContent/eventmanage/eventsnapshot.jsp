<%@ page import="java.util.*,com.eventbee.event.*,com.eventbee.event.ticketinfo.*"%>
<%@ page import="com.eventbee.general.*,com.eventbee.editevent.*"%>
<%@ page import="com.eventbee.general.formatting.*"%>
<%!
String ticketstatusquery="select distinct a.price_id, groupname, ticket_name, max_ticket ,sold_qty, "
				+" case when start_date+cast(cast(starttime as text) as time )>now()  "
				+" then 'NOT_STARTED' else 'STARTED' end as startstatus,"
				+" case when end_date+cast(cast(endtime as text) as time )<now()  "
				+" then 'CLOSED' else 'NOT_CLOSED' end as endstatus,"
				+" case when sold_qty<max_ticket then 'AVAILABLE' else 'SOLD_OUT' end as soldstatus "
				+" from price a, event_ticket_groups b, group_tickets c where evt_id=? and sold_qty>0 "
				+" and a.price_id=to_number(c.price_id,'999999999999') and c.ticket_groupid=b.ticket_groupid "
				+" order by groupname, ticket_name";
String deleteedticketsquery="select sum(case when (UPPER(coalesce(paymentstatus,'COMPLETED')) in ('COMPLETED','CHARGED','PENDING')) "
			   +" then ticketqty else 0 end) as sold,ticketid, groupname,  ticketname "
			   +" from transaction_tickets a, event_reg_transactions b where a.eventid=? "
			   +" and a.eventid=b.eventid and a.tid=b.tid and ticketid not in "
			   +" (select price_id from price where evt_id=?) group by ticketid, "
			   +" ticketname, groupname having sum(case when (UPPER(coalesce(paymentstatus,'COMPLETED')) in "
			   +" ('COMPLETED','CHARGED','PENDING')) then ticketqty else 0 end)>0 "
			   +" order by groupname, ticketname";
			
			
String ticketsourcequery="select sum(case when (UPPER(coalesce(paymentstatus,'COMPLETED')) in ('COMPLETED','CHARGED','PENDING')) "
			+" then ticketqty else 0 end) as sold,ticketid,b.bookingsource "
			+" from transaction_tickets a, event_reg_transactions b, price c "
			+" where a.eventid=? and a.eventid=b.eventid and a.tid=b.tid and "
			+" a.ticketid=c.price_id group by ticketid, bookingsource "
			+" having sum(case when (UPPER(coalesce(paymentstatus,'COMPLETED')) in "
			+" ('COMPLETED','CHARGED','PENDING')) then ticketqty else 0 end)>0";
			
String deletedticketsourcequery="select sum(case when (UPPER(coalesce(paymentstatus,'COMPLETED')) in ('COMPLETED','CHARGED','PENDING')) "
			      +" then ticketqty else 0 end) as sold,ticketid,ticketname, "
			      +" b.bookingsource from transaction_tickets a, event_reg_transactions b "
			      +" where a.eventid=? and a.eventid=b.eventid and a.tid=b.tid and "
			      +" a.ticketid not in (select price_id from price where evt_id=?) "
			      +" group by ticketid, bookingsource, ticketname "
			      +" having sum(case when (UPPER(coalesce(paymentstatus,'COMPLETED')) in "
			      +" ('COMPLETED','CHARGED','PENDING')) then ticketqty else 0 end)>0";
			
			
String totalsalesquery="select sum(case when (UPPER(coalesce(paymentstatus,'COMPLETED')) in "
		      +" ('COMPLETED','CHARGED','PENDING')) and UPPER(bookingsource)='MANAGER' "
		      +" then ticketqty else 0 end) as manual, sum(case when (UPPER(coalesce(paymentstatus,'COMPLETED')) "
		      +" in ('COMPLETED','CHARGED','PENDING')) and  UPPER(bookingsource)='ONLINE' "
		      +" then ticketqty else 0 end) as online, sum(ticketqty ) as total "
		      +" from transaction_tickets a, event_reg_transactions b where a.eventid=? "
		      +" and a.eventid=b.eventid and a.tid=b.tid";

Vector getTicketStatusInfo(String groupid, Vector ticketsVector, HashMap ticketSourceMap){
DBManager dbmanager=new DBManager();

StatusObj stobj=dbmanager.executeSelectQuery(ticketstatusquery,new String[]{groupid});
if(stobj.getStatus()){
for(int i=0;i<stobj.getCount();i++){
HashMap hm=new HashMap();
String ticketid=dbmanager.getValue(i,"price_id","");
String ticketname=dbmanager.getValue(i,"ticket_name","");
String groupname=dbmanager.getValue(i,"groupname","");
String source=dbmanager.getValue(i,"bookingsource","");

String key="online"+"_"+ticketid;
String onlinesales=(String)ticketSourceMap.get(key);
if(onlinesales==null) onlinesales="0";
key="Manager"+"_"+ticketid;
String offlinesales=(String)ticketSourceMap.get(key);
if(offlinesales==null) offlinesales="0";
hm.put("offlinesales",offlinesales);
hm.put("onlinesales",onlinesales);
hm.put("ticket_name",ticketname);
hm.put("groupname",groupname);
int soldqty=Integer.parseInt(offlinesales)+Integer.parseInt(onlinesales);
int actualsold=Integer.parseInt(dbmanager.getValue(i,"sold_qty","0"));
hm.put("sold_qty",soldqty+"/"+dbmanager.getValue(i,"max_ticket",""));
String startstatus=dbmanager.getValue(i,"startstatus","");
String endstatus=dbmanager.getValue(i,"endstatus","");
String soldstatus=dbmanager.getValue(i,"soldstatus","");
String status="Available";		
if("SOLD_OUT".equals(soldstatus)){
status="Sold Out";
}else if("CLOSED".equals(endstatus)){
status="Ended";
}else if("NOT_STARTED".equals(startstatus)){
status="On Hold";
}
hm.put("status",status);
ticketsVector.add(hm);
}
}
return ticketsVector;
}

Vector getDeletedTicketsInfo(String groupid, Vector ticketsVector, HashMap ticketSourceMap){
DBManager dbmanager=new DBManager();
StatusObj stobj=dbmanager.executeSelectQuery(deleteedticketsquery,new String[]{groupid,groupid});
if(stobj.getStatus()){
for(int i=0;i<stobj.getCount();i++){
HashMap hm=new HashMap();
String ticketid=dbmanager.getValue(i,"ticketid","");
String ticketname=dbmanager.getValue(i,"ticketname","");
String groupname=dbmanager.getValue(i,"groupname","");
String source=dbmanager.getValue(i,"bookingsource","");

String key="online"+"_"+ticketid+"_"+ticketname;
String onlinesales=(String)ticketSourceMap.get(key);
if(onlinesales==null) onlinesales="0";
key="Manager"+"_"+ticketid+"_"+ticketname;
String offlinesales=(String)ticketSourceMap.get(key);
if(offlinesales==null) offlinesales="0";
hm.put("offlinesales",offlinesales);
hm.put("onlinesales",onlinesales);
hm.put("ticket_name",ticketname);
hm.put("groupname",groupname);
hm.put("sold_qty",dbmanager.getValue(i,"sold",""));

hm.put("status","Deleted");
ticketsVector.add(hm);
}
}
return ticketsVector;
}

HashMap getTicketSourceMap(String groupid){
DBManager dbmanager=new DBManager();
HashMap hm=new HashMap();
StatusObj stobj=dbmanager.executeSelectQuery(ticketsourcequery,new String[]{groupid});
if(stobj.getStatus()){
for(int i=0;i<stobj.getCount();i++){
String ticketname=dbmanager.getValue(i,"ticketname","");
String ticketid=dbmanager.getValue(i,"ticketid","");
String source=dbmanager.getValue(i,"bookingsource","");
String key=source+"_"+ticketid;
hm.put(key,dbmanager.getValue(i,"sold",""));
}
}
return hm;
}

HashMap getDeletedTicketSourceMap(String groupid){
DBManager dbmanager=new DBManager();
HashMap hm=new HashMap();
StatusObj stobj=dbmanager.executeSelectQuery(deletedticketsourcequery,new String[]{groupid, groupid});
if(stobj.getStatus()){
for(int i=0;i<stobj.getCount();i++){
String ticketname=dbmanager.getValue(i,"ticketname","");
String ticketid=dbmanager.getValue(i,"ticketid","");
String source=dbmanager.getValue(i,"bookingsource","");
String key=source+"_"+ticketid+"_"+ticketname;
hm.put(key,dbmanager.getValue(i,"sold",""));
}
}
return hm;
}


HashMap getTotalsales(String groupid){
DBManager dbmanager=new DBManager();
HashMap hm=new HashMap();
StatusObj stobj=dbmanager.executeSelectQuery(totalsalesquery,new String[]{groupid});
if(stobj.getStatus()){
for(int i=0;i<stobj.getCount();i++){
String total=dbmanager.getValue(i,"total","");
String manual=dbmanager.getValue(i,"manual","");
String online=dbmanager.getValue(i,"online","");
if("".equals(online)) online="0";
if("".equals(manual)) manual="0";
hm.put("total",total);
hm.put("manual",manual);
hm.put("online",online);

}
}
return hm;
}

%>

<%
	String groupid=request.getParameter("GROUPID");
	String mgrtokenid=(String)request.getAttribute("mgrtokenid");
	HashMap evtinfo=EventDB.getMgrEvtDetails(groupid);
	String location=GenUtil.getCSVData(new String[]{(String)evtinfo.get("venue"),(String)evtinfo.get("address1"),(String)evtinfo.get("address2"),(String)evtinfo.get("city"),(String)evtinfo.get("state"),(String)evtinfo.get("country")});
	Vector ticketstatusvec=new Vector();
	HashMap ticketSourceMap=getTicketSourceMap(groupid);
	HashMap deletedticketSourceMap=getDeletedTicketSourceMap(groupid);
	ticketstatusvec=getTicketStatusInfo(groupid, ticketstatusvec, ticketSourceMap);
	ticketstatusvec=getDeletedTicketsInfo(groupid, ticketstatusvec, deletedticketSourceMap);
	HashMap totalSales=getTotalsales(groupid);
	String platform = request.getParameter("platform");
	if(platform==null) platform="";
		String URLBase="mytasks";
		if("ning".equals(platform)){
			URLBase="ningapp/ticketing";	
	}
%>
<div class='memberbeelet-header'>Event Snapshot</div>
<table class="portaltable" align="center" width="100%" cellspacing='0' cellpadding='0'>
<tr ><td class="evenbase">Starts </td>
<td colspan='2' class="evenbase"><%=(String)evtinfo.get("eventstartdate")+", "+(String)evtinfo.get("starttime")%></td>
</tr>
<tr ><td class="oddbase">Ends</td>
<td colspan='2' class="oddbase" ><%=(String)evtinfo.get("eventenddate")+", "+(String)evtinfo.get("endtime")%></td>
</tr>
<tr ><td class="evenbase">Location</td>
<td colspan='2' class="evenbase"><%=location%></td></tr>
<tr ><td width="25%" class="oddbase">Manager</td>
<td colspan='2' class="oddbase">
<table width="100%">
<tr><td>
<a href="mailto:<%=(String)evtinfo.get("email")%>"><%=(String)evtinfo.get("email")%></a>
</td></tr>
<tr><td><%=(String)evtinfo.get("phone")%></td></tr>
</table>
</td>
</tr>
</table>
<%if(ticketstatusvec!=null && ticketstatusvec.size()>0){  %>
<table class="portaltable"  width="100%" cellspacing='0' cellpadding='0'>
<tr ><td class="colheader">
Ticket Sales - Total Sold <b><%=totalSales.get("total")%></b>&nbsp;(Online: <b><%=totalSales.get("online")%></b>, Manual: <b><%=totalSales.get("manual")%></b>)&nbsp;&nbsp;&nbsp;<a href="/<%=URLBase%>/reg_reports.jsp?GROUPID=<%=request.getParameter("GROUPID")%>&landf=yes&platform=<%=platform%>&filter=manager&evttype=event&mgrtokenid=<%=mgrtokenid%>">Report</a>
</td></tr>

<tr>
<td ><table width="100%" >
<tr><td class="colheader" width="10%">Status</td>
<td class="colheader" width="60%">Ticket Name</td>
<td class="colheader">Sold/Total Limit</td></tr>
<%
		String base="evenbase";
		for(int i=0;i < ticketstatusvec.size();i++){
		base=(i%2==0)?"oddbase":"evenbase";
		 HashMap ticstatushm=(HashMap)ticketstatusvec.elementAt(i);
		 String groupname=(String)ticstatushm.get("groupname");		  
		 String ticket_name=(String)ticstatushm.get("ticket_name");
		 String max_ticket=(String)ticstatushm.get("max_ticket");		
		 String sold_qty=(String)ticstatushm.get("sold_qty");
		 String status=(String)ticstatushm.get("status");
		 String onlinesales=(String)ticstatushm.get("onlinesales");
		 String offlinesales=(String)ticstatushm.get("offlinesales");
		 
%>
		 
<tr>
<td class="<%=base%>"><span class='smallestfont'><%=status%></span></td>
<td  align="left" class="<%=base%>" >
<%if(groupname!=null&&!"".equals(groupname)){%><%=groupname%><br>&nbsp;&nbsp;&nbsp;&nbsp;<%}%><%=ticket_name%></td>
<td class="<%=base%>" align='left'><%=sold_qty%>
<div align='left' >Online:&nbsp;<%=onlinesales%></div>
<div align='left' >Manual:&nbsp;<%=offlinesales%></div>
</td>
</tr>	   
<%}%>
</table></td></tr>
</table>
<%}%>

  