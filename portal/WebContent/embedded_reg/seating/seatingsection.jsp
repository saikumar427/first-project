<%@page import="com.eventbee.general.EbeeConstantsF"%>
<%@page import="com.eventbee.util.CoreConnector"%>
<%@page import="com.eventregister.RegistrationTiketingManager"%>
<%@page import="java.text.Format"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="com.eventregister.SeatingDBHelper,com.eventregister.SeatingJSONHelpers,com.eventbee.general.DbUtil,com.eventbee.general.DateUtil"%>
<%@ page import="java.util.ArrayList,java.util.HashMap,java.util.List,org.json.JSONArray,org.json.JSONObject,java.util.UUID"%>
<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
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
//System.out.println("uid::"+uid);
hmap.put("uid",uid);
long sttime=new java.util.Date().getTime();
//System.out.println("Seating section start: eid:"+eid+"  uid::"+uid);
/*Delete from temp tables Start*/
//DbUtil.executeUpdateQuery("delete from event_reg_block_seats_temp where transactionid in (select tid from event_reg_details_temp where eventid=? and transactiondate < (select now()- interval '20 minutes') and current_action in ('','profile page','tickets page','payment section','confirmation page') );",new String[]{eventid});
//DbUtil.executeUpdateQuery("delete from event_reg_block_seats_temp where transactionid in (select tid from event_reg_details_temp where eventid=? and transactiondate < (select now()- interval '1 hours') and current_action in  ('paypal','google','eventbee','other','ebeecredits'));",new String[]{eventid});
//DbUtil.executeUpdateQuery("delete from event_reg_block_seats_temp where transactionid in (select tid from event_reg_details_temp where eventid=? and transactiondate < (select now()- interval '20 minutes') and current_action is null );",new String[]{eventid});

/* DbUtil.executeUpdateQuery("delete from event_reg_block_seats_temp where transactionid in (select tid from event_reg_details_temp where eventid=? and transactiondate < (to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS')- interval '20 minutes') and current_action in ('','profile page','tickets page','payment section','confirmation page') );",new String[]{eventid,DateUtil.getCurrDBFormatDate()});
System.out.println("end of 1st delete:: eid:"+eid+" uid::"+uid);

DbUtil.executeUpdateQuery("delete from event_reg_block_seats_temp where transactionid in (select tid from event_reg_details_temp where eventid=? and transactiondate < (to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS')- interval '1 hours') and current_action in  ('paypal','google','eventbee','other','ebeecredits'));",new String[]{eventid,DateUtil.getCurrDBFormatDate()});
System.out.println("end of 2nd delete:eid:"+eid+" uid::"+uid);

DbUtil.executeUpdateQuery("delete from event_reg_block_seats_temp where transactionid in (select tid from event_reg_details_temp where eventid=? and transactiondate < (to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS')- interval '20 minutes') and current_action is null );",new String[]{eventid,DateUtil.getCurrDBFormatDate()});
System.out.println("end of 3rd delete:eid:"+eid+" uid::"+uid); */

RegistrationTiketingManager regtktmgr=new RegistrationTiketingManager();
regtktmgr.autoLocksAndBlockDelete(eid, tid, "seatingsectionlevel");


/*Delete from temp tables End*/

/*insert into seat_booking_status*/

if(!"".equals(eventdate) &&  !" ".equals(eventdate) && eventdate!=null){
	//DbUtil.executeUpdateQuery("insert into seat_booking_status (eventid,venue_id,seatindex,profilekey,tid,ticketid,eventdate)  select to_number(?,'99999999999999999'), to_number(?,'999999999'),seatindex,profilekey,transactionid,ticketid,eventdate from  profile_base_info a,event_reg_transactions b where a.eventid=to_number(?,'99999999999999999') and eventdate=? and seatindex is not null and a.transactionid=b.tid and b.paymentstatus='Completed' and b.eventid=? and seatindex not in (select seatindex from seat_booking_status where eventid=to_number(?,'99999999999999999') and eventdate=?)", new String[]{eventid,venueid,eventid,eventdate,eventid,eventid,eventdate});
	//commented on 2015-01-24//DbUtil.executeUpdateQuery("insert into seat_booking_status (eventid,venue_id,seatindex,profilekey,tid,ticketid,eventdate,section_id,bookingtime)  select to_number(?,'99999999999999999'), to_number(?,'999999999'),seatindex,profilekey,transactionid,ticketid,eventdate,to_number(split_part(seatindex,'_', 1),'999999999999'),b.transaction_date from  profile_base_info a,event_reg_transactions b where a.eventid=CAST(? AS BIGINT) and eventdate=? and seatindex is not null and seatindex like '%_%' and a.transactionid=b.tid and b.paymentstatus='Completed' and b.eventid=? and seatindex not in (select seatindex from seat_booking_status where eventid=to_number(?,'99999999999999999') and eventdate=?)", new String[]{eventid,venueid,eventid,eventdate,eventid,eventid,eventdate});
	//System.out.println("end of insert : eid:"+eid+" uid::"+uid);
}
else{
	//DbUtil.executeUpdateQuery("insert into seat_booking_status (eventid,venue_id,seatindex,profilekey,tid,ticketid,eventdate)  select to_number(?,'99999999999999999'), to_number(?,'999999999'),seatindex,profilekey,transactionid,ticketid,eventdate from  profile_base_info a,event_reg_transactions b where a.eventid=to_number(?,'99999999999999999') and seatindex is not null and a.transactionid=b.tid and b.paymentstatus='Completed' and b.eventid=? and seatindex not in (select seatindex from seat_booking_status where eventid=to_number(?,'99999999999999999'))", new String[]{eventid,venueid,eventid,eventid,eventid});
	//commented on 2015-01-24//DbUtil.executeUpdateQuery("insert into seat_booking_status (eventid,venue_id,seatindex,profilekey,tid,ticketid,eventdate,section_id,bookingtime)  select to_number(?,'99999999999999999'), to_number(?,'999999999'),seatindex,profilekey,transactionid,ticketid,eventdate,to_number(split_part(seatindex,'_', 1),'9999999999999'),b.transaction_date  from  profile_base_info a,event_reg_transactions b where a.eventid=to_number(?,'99999999999999999') and seatindex is not null and seatindex like '%_%' and a.transactionid=b.tid and b.paymentstatus='Completed' and b.eventid=? and seatindex not in (select seatindex from seat_booking_status where eventid=to_number(?,'99999999999999999'))", new String[]{eventid,venueid,eventid,eventid,eventid});
	//System.out.println("end of insert :eid:"+eid+" uid::"+uid);
	
}

//commented on 2015-01-24//DbUtil.executeUpdateQuery("delete from event_reg_block_seats_temp where transactionid in (select tid from event_reg_transactions where eventid=? and paymentstatus ='Completed')",new String[]{eventid});
//System.out.println("end 4th delete :eid:"+eid+" uid::"+uid);

System.out.println("seating    ..........eid:"+eid+" uid::"+uid);
ArrayList<String> evids=new ArrayList<String>();
evids.add("174901002");
evids.add("125114992");


if(evids.contains(eid)){
 final HashMap<String,String> params=new HashMap<String,String>();
	params.put("eid",eid);
	params.put("evtdate",eventdate);
	params.put("venueid",venueid);
	params.put("uid",uid);
	System.out.println("seatingparams::uid"+uid+" eid"+eid+" params"+params);
	
	System.out.println("inside db json"+eid+" uid::"+uid);
	String jjson=DbUtil.getVal("select value from config where name='event.seatjson' and config_id in (select config_id from eventinfo where eventid=?::bigint )", new String[]{eid});
	new Thread()
	{
	    public void run() {
	        System.out.println("threadstrt");
	        CoreConnector cc1=null;
	        try{
			 cc1=new CoreConnector("http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com")+"/embedded_reg/seating/seatingsectionLoad.jsp");
			 cc1.setTimeout(500000);
			 cc1.setArguments(params);
			 cc1.MGet();	
       	  }catch(Exception e){System.out.println(e.getMessage());}
		     
	    }
	}.start();
	out.println(jjson);
	return;

}



completevenuedetailsmap=seatingdbhelper.getCompleteVenueDetails(hmap);

String seatGroupTickets=(String)completevenuedetailsmap.get("seatticketgroupdetails");


if(seatGroupTickets==null || "".equals(seatGroupTickets.trim()))
	seatGroupTickets="{}";

JSONObject seatGroupTicketsJSON=new JSONObject(seatGroupTickets);

//System.out.println("end of all seat queries:eid:"+eid+" uid::"+uid);

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




//JSONObject ticketGroupDetails=seatingdbhelper.getTicketGroupDetails(eid);
seatingdetailobj.put("seatticketgroups",seatGroupTicketsJSON);

seatingdetailobj.put("ticketseatcolor",ticketseat_colors);
seatingdetailobj.put("allsections",sectiondetails);
seatingdetailobj.put("allsectionid",sectionids);
seatingdetailobj.put("allsectionname",sectionnames);
seatingdetailobj.put("ticketgroups",ticketgroupdetails);
System.out.println("end seating section eid:"+eid+" uid::"+uid+" total time in ms:"+(new java.util.Date().getTime()-sttime));
out.println(seatingdetailobj.toString());
%>
