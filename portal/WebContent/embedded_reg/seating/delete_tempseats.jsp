<%@ page import="com.eventbee.general.*,java.util.*"%>
<%
String eid=request.getParameter("eid");
String tid=request.getParameter("tid");

String res=DbUtil.getVal("select array_agg( 'eventid='||eventid ||' ticketid='||ticketid||' tid='||tid||' qty='||locked_qty||' eventdate='||eventdate||' time='||locked_time) ::text"+
		 " as response from event_reg_locked_tickets where eventid=? and tid=?", new String[]{eid,tid});


System.out.println("delete tempres:::::"+res);
res=DbUtil.getVal("select array_agg( 'eventid='||eventid ||' ticketid='||ticketid||' tid='||transactionid||' seatindex='||seatindex||' eventdate='||eventdate||' time='||blocked_at ) ::text"+
		  " as response  from event_reg_block_seats_temp  where eventid=? and transactionid=?", new String[]{eid,tid});
res=res==null?"":res;
System.out.println("delete tempreseat:::::"+res);

StatusObj blockseats_del=DbUtil.executeUpdateQuery("delete from event_reg_block_seats_temp where eventid=? and transactionid=?", new String[]{eid,tid});
StatusObj locked_del =DbUtil.executeUpdateQuery("delete from event_reg_locked_tickets where eventid=? and tid=?", new String[]{eid,tid});


%>