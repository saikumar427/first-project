<%@ page import="com.eventbee.event.ticketinfo.*"%>
<%@ page import="com.event.dbhelpers.*,com.eventregister.*,com.eventbee.general.*"%>
<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ include file='/globalprops.jsp' %>

<%
RegConfirmationDBHelper regConfirmdb=new RegConfirmationDBHelper();
String tid=request.getParameter("tid");
String eid=request.getParameter("eid");
String eventdate=request.getParameter("eventdate");
String seatingenabled=request.getParameter("seatingenabled");
String venueid=request.getParameter("venueid");
String hidelink=request.getParameter("hidelink");
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "done.jsp", "Entered done.jsp tid is "+tid, "", null);
RegistrationTiketingManager regtktmgr=new RegistrationTiketingManager();
regtktmgr.setEventRegTempAction(eid,tid,"confirmation page");

if("YES".equals(seatingenabled)){
	DbUtil.executeUpdateQuery("delete from seat_booking_status where eventid=?::bigint and tid=?", new String[]{eid,tid});	
	regConfirmdb.fillseatingstatus(tid, eid, eventdate,venueid);
	DbUtil.executeUpdateQuery("delete from event_reg_block_seats_temp where transactionid=?",new String [] {tid});
}	
DbUtil.executeUpdateQuery("delete from event_reg_locked_tickets where tid=?",new String [] {tid});

String qry="select 'Yes' from event_reg_transactions where tid=?";
String isExisted=DbUtil.getVal(qry,new String[]{tid});
if("Yes".equalsIgnoreCase(isExisted)){
System.out.println("hidelink: "+hidelink);

regConfirmdb.fillConfirmation(tid,eid,out);
if(hidelink!=null && "yes".equals(hidelink)){
	out.println("<script>document.getElementById('toplink').innerHTML='<a href=\"JavaScript:window.print();\">"+getPropValue("done.print",eid)+"</a>';");
	out.println("document.getElementById('btmlink').innerHTML='<a href=\"JavaScript:window.print();\">"+getPropValue("done.print",eid)+"</a>';");
	out.println("document.getElementById('subbtn').innerHTML='';</script>");
	}
return ;
}
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "done.jsp", "pending confirmation screen tid is"+tid, "", null);

%>
<div style="text-align:left;height:400px;padding-left:2px;" >
<br/>
<%=getPropValue("done.payment.not.received.first",eid)%><%=tid%><%=getPropValue("done.payment.not.received.second",eid)%>  
<p/>
<span class="error"><%=getPropValue("done.payment.not.received.note",eid)%></span>
<p><a href="#" onClick='refreshPage();'><%=getPropValue("done.back",eid)%></a><br/>


</div>



