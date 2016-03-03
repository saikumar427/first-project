<%@page import="com.eventregister.RegistrationTiketingManager"%>
<%@page import="java.text.Format"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="com.eventregister.SeatingDBHelper,com.eventregister.SeatingJSONHelpers,com.eventbee.general.DbUtil,com.eventbee.general.DateUtil"%>
<%@ page import="java.util.ArrayList,java.util.HashMap,java.util.List,org.json.JSONArray,org.json.JSONObject,java.util.UUID"%>
<%
SeatingDBHelper seatingdbhelper=new SeatingDBHelper();
SeatingJSONHelpers seatingjsonhelper=new SeatingJSONHelpers();
String eid=request.getParameter("eid");
String eventid=eid;
String eventdate=request.getParameter("evtdate");
String tid=request.getParameter("tid");
String venueid=request.getParameter("venueid");
HashMap completevenuedetailsmap=new HashMap();
HashMap hmap=new HashMap();
hmap.put("eid",eid);
hmap.put("eventdate",eventdate);
hmap.put("venueid",venueid);
hmap.put("tid",tid);
String uid=UUID.randomUUID().toString();
System.out.println("uid::"+uid);
hmap.put("uid",uid);
long sttime=new java.util.Date().getTime();
System.out.println("seatLoadjosn Seating section start: eid:"+eid+"  uid::"+uid);

RegistrationTiketingManager regtktmgr=new RegistrationTiketingManager();
regtktmgr.autoLocksAndBlockDelete(eid, tid, "seatingsectionlevel");

/*Delete from temp tables End*/

/*insert into seat_booking_status*/

if(!"".equals(eventdate) &&  !" ".equals(eventdate) && eventdate!=null){
	//DbUtil.executeUpdateQuery("insert into seat_booking_status (eventid,venue_id,seatindex,profilekey,tid,ticketid,eventdate)  select to_number(?,'99999999999999999'), to_number(?,'999999999'),seatindex,profilekey,transactionid,ticketid,eventdate from  profile_base_info a,event_reg_transactions b where a.eventid=to_number(?,'99999999999999999') and eventdate=? and seatindex is not null and a.transactionid=b.tid and b.paymentstatus='Completed' and b.eventid=? and seatindex not in (select seatindex from seat_booking_status where eventid=to_number(?,'99999999999999999') and eventdate=?)", new String[]{eventid,venueid,eventid,eventdate,eventid,eventid,eventdate});
	DbUtil.executeUpdateQuery("insert into seat_booking_status (eventid,venue_id,seatindex,profilekey,tid,ticketid,eventdate,section_id,bookingtime)  select CAST(? AS BIGINT), CAST(? AS INTEGER),seatindex,profilekey,transactionid,ticketid,eventdate,CAST(split_part(seatindex,'_', 1) AS INTEGER),b.transaction_date from  profile_base_info a,event_reg_transactions b where a.eventid=CAST(? AS BIGINT) and eventdate=? and seatindex is not null and seatindex like '%_%' and a.transactionid=b.tid and b.paymentstatus='Completed' and b.eventid=? and seatindex not in (select seatindex from seat_booking_status where eventid=CAST(? AS BIGINT) and eventdate=?)", new String[]{eventid,venueid,eventid,eventdate,eventid,eventid,eventdate});
	System.out.println("seatLoadjosn end of insert : eid:"+eid+" uid::"+uid);
}
else{
	//DbUtil.executeUpdateQuery("insert into seat_booking_status (eventid,venue_id,seatindex,profilekey,tid,ticketid,eventdate)  select to_number(?,'99999999999999999'), to_number(?,'999999999'),seatindex,profilekey,transactionid,ticketid,eventdate from  profile_base_info a,event_reg_transactions b where a.eventid=to_number(?,'99999999999999999') and seatindex is not null and a.transactionid=b.tid and b.paymentstatus='Completed' and b.eventid=? and seatindex not in (select seatindex from seat_booking_status where eventid=to_number(?,'99999999999999999'))", new String[]{eventid,venueid,eventid,eventid,eventid});
	DbUtil.executeUpdateQuery("insert into seat_booking_status (eventid,venue_id,seatindex,profilekey,tid,ticketid,eventdate,section_id,bookingtime)  select CAST(? AS BIGINT), CAST(? AS INTEGER),seatindex,profilekey,transactionid,ticketid,eventdate,CAST(split_part(seatindex,'_', 1) AS INTEGER),b.transaction_date  from  profile_base_info a,event_reg_transactions b where a.eventid=CAST(? AS BIGINT) and seatindex is not null and seatindex like '%_%' and a.transactionid=b.tid and b.paymentstatus='Completed' and b.eventid=? and seatindex not in (select seatindex from seat_booking_status where eventid=CAST(? AS BIGINT))", new String[]{eventid,venueid,eventid,eventid,eventid});
	System.out.println("seatLoadjosn end of insert :eid:"+eid+" uid::"+uid);
	
}

DbUtil.executeUpdateQuery("delete from event_reg_block_seats_temp where transactionid in (select tid from event_reg_transactions where eventid=? and paymentstatus ='Completed')",new String[]{eventid});
System.out.println("seatLoadjosnend 4th delete :eid:"+eid+" uid::"+uid);
System.out.println(" seatLoadjosn strtstime:"+new java.util.Date()+" uid::"+uid+"  eid::"+eid+" mis::"+new java.util.Date().getTime());

completevenuedetailsmap=seatingdbhelper.getCompleteVenueDetails(hmap);
System.out.println(" seatLoadjosn endstime:"+new java.util.Date()+" uid::"+uid+"  eid::"+eid+" mis::"+new java.util.Date().getTime());

System.out.println("end of all seat queries:eid:"+eid+" uid::"+uid);

HashMap layoutdetails=(HashMap) completevenuedetailsmap.get("layoutdetails");

HashMap hm=(HashMap) completevenuedetailsmap.get("AllcotedTicketidForSeatgroupid");
HashMap seatingsectionhm=(HashMap) completevenuedetailsmap.get("getsections");
HashMap allotedseatshm=(HashMap) completevenuedetailsmap.get("AllotedSeats");

HashMap ticketcolormap=(HashMap) completevenuedetailsmap.get("TicketSeatColors");
HashMap allticket_id_name=(HashMap) ticketcolormap.get("ticketnames");
HashMap ticketseat_colors=(HashMap)ticketcolormap.get("TicketSeatColors");
hmap.put("getAllotedSeatColors",ticketcolormap.get("AllotedSeatColors"));

hmap.put("getSoldOutSeats",completevenuedetailsmap.get("SoldOutSeats"));
hmap.put("getOnHoldSeats",completevenuedetailsmap.get("OnHoldSeats"));

hmap.put("allticket_id_name",allticket_id_name);
hmap.put("tktid_seat_grpid",hm);
hmap.put("allotedseats",allotedseatshm);

HashMap sectiondetails=new HashMap();
String sectionid="";
ArrayList sectionids=(ArrayList)seatingsectionhm.get("sectionid");
ArrayList sectionnames=(ArrayList)seatingsectionhm.get("sectionname");
	for(int i=0;i<sectionids.size();i++){	
		sectionid=sectionids.get(i).toString();
		hmap.put("sectionid",sectionid);
		hmap.put("sectionheader",seatingsectionhm.get("header_"+sectionid));
		hmap.put("getsectiondetails",seatingsectionhm.get(sectionid));
		sectiondetails.put(sectionid,seatingjsonhelper.getSectionSeatingDetails(hmap));

	}
	
HashMap ticketgroupdetails=(HashMap) completevenuedetailsmap.get("TicketGroupdetails");

JSONObject seatingdetailobj=new JSONObject();
if(!layoutdetails.isEmpty()){
	seatingdetailobj.put("venuelayout",(String)layoutdetails.get("layout"));
	seatingdetailobj.put("venuepath",(String)layoutdetails.get("path"));
	seatingdetailobj.put("venuelinklabel",(String)layoutdetails.get("link"));
}

seatingdetailobj.put("ticketseatcolor",ticketseat_colors);
seatingdetailobj.put("allsections",sectiondetails);
seatingdetailobj.put("allsectionid",sectionids);
seatingdetailobj.put("allsectionname",sectionnames);
seatingdetailobj.put("ticketgroups",ticketgroupdetails);
System.out.println("end seating section eid:"+eid+" uid::"+uid+" total time in ms:"+(new java.util.Date().getTime()-sttime));

System.out.println(" seatLoadjosn processtime:"+new java.util.Date()+" uid::"+uid+"  eid::"+eid+" mis::"+new java.util.Date().getTime());
DbUtil.executeUpdateQuery("update config set value=? where config_id=(select config_id from eventinfo where eventid=?::bigint) and name='event.seatjson'", new String []{seatingdetailobj.toString(),eid});


//out.println(seatingdetailobj.toString());
%>
