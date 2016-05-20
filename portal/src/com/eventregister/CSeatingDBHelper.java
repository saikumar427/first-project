package com.eventregister;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.eventbee.cachemanage.CacheLoader;
import com.eventbee.cachemanage.CacheManager;
import com.eventbee.general.DBManager;
import com.eventbee.general.DbUtil;
import com.eventbee.general.StatusObj;
import com.eventbee.regcaheloader.SeatingVenueLoader;

public class CSeatingDBHelper {
	public static HashMap glsecseats=new HashMap();
	public static HashMap getCompleteVenueDetails(HashMap hmap){
		String venueid=(String)hmap.get("venueid");
		String eid=(String)hmap.get("eid");
		String eventdate=(String)hmap.get("eventdate");
		String tid=(String)hmap.get("tid");
		String uid=(String)hmap.get("uid");
		HashMap completedetailmap=new HashMap();
		
		Map seatingVenueDetailsMap = getSeatingVenueDetailsMap(eid,venueid);

		//completedetailmap.put("layoutdetails", GetVenueLayout(venueid));
		completedetailmap.put("layoutdetails", seatingVenueDetailsMap.get("venue_layout"));
		
		//completedetailmap.put("AllcotedTicketidForSeatgroupid", getAllcotedTicketidForSeatgroupid(eid,venueid));
		completedetailmap.put("AllcotedTicketidForSeatgroupid", seatingVenueDetailsMap.get("allcoted_ticketid_for_seatgroupid"));
		
		//completedetailmap.put("getsections", getSection(venueid));
		completedetailmap.put("getsections", seatingVenueDetailsMap.get("venue_sections"));
		
		//completedetailmap.put("AllotedSeats", getAllotedSeats(eid,""));
		completedetailmap.put("AllotedSeats", seatingVenueDetailsMap.get("allotedseats"));
		
		//completedetailmap.put("TicketSeatColors", getTicketSeatColors(eid));
		completedetailmap.put("TicketSeatColors", seatingVenueDetailsMap.get("ticket_seat_colors"));
		
		completedetailmap.put("SoldOutSeats", getSoldOutSeats(eid,"",eventdate));
		
		completedetailmap.put("OnHoldSeats", getOnHoldSeats(eid,eventdate));
		
		if(!"".equals(tid)){
			//completedetailmap.put("holdseatstid",getOnHoldSeatsTid(eid,eventdate,tid));
			completedetailmap.put("holdseatstkts",getHoldSeatTickets(eid,eventdate,tid));
		}
			
		
		//completedetailmap.put("TicketGroupdetails", getTicketGroupdetails(eid));
		completedetailmap.put("TicketGroupdetails", seatingVenueDetailsMap.get("ticket_group_details"));
		
		//completedetailmap.put("seatticketgroupdetails", getSeatingTicketGroupdetails(eid));
		completedetailmap.put("seatticketgroupdetails", seatingVenueDetailsMap.get("seattickets_group_details"));
		
		return completedetailmap;
	}
	
	public static HashMap GetVenueLayout(String venueid){
		HashMap venuelayout=new HashMap();
		
		DBManager db=new DBManager();
		StatusObj layoutsb=db.executeSelectQuery("select layout_display,layout_display_path,layout_display_link from seating_venues where venue_id=CAST(? AS INTEGER)",new String[]{venueid});
		if(layoutsb.getStatus()){
			venuelayout.put("layout",db.getValue(0,"layout_display",""));
			venuelayout.put("path",db.getValue(0,"layout_display_path",""));
			venuelayout.put("link",db.getValue(0,"layout_display_link",""));
		}
		return venuelayout;
	}
	
	public static HashMap getAllcotedTicketidForSeatgroupid(String eventid,String venueid){
		String query="select seat_groupid,ticketid from seat_tickets where eventid=CAST(? AS BIGINT) and venue_id=CAST(? AS INTEGER) order by seat_groupid";
		HashMap hm=new HashMap();
		DBManager db= new DBManager();
		StatusObj sb=db.executeSelectQuery(query,new String[]{eventid,venueid});
		if(sb.getStatus()&&sb.getCount()>0){
			for(int i=0;i<sb.getCount();i++){
				String seat_grpid=db.getValue(i, "seat_groupid", "");
				ArrayList ticketid=new ArrayList();
				ticketid.add(db.getValue(i, "ticketid", ""));
				try{
					if(hm.containsKey(seat_grpid)){
						ArrayList tktid=(ArrayList) hm.get(seat_grpid);
						tktid.add(db.getValue(i, "ticketid", ""));
						hm.put(seat_grpid, tktid);
					}else{
						hm.put(seat_grpid, ticketid);
					}
				}catch(Exception e){System.out.println("exception in ticketids for each seat groupid is"+e.getMessage());}
			}
		}
		return hm;
	}
	
	public static HashMap getSection(String venueid){
		HashMap allsections=new HashMap();
		ArrayList sectionids=new ArrayList();
		ArrayList sectionnames=new ArrayList();
		DBManager db=new DBManager();
		HashMap sectionseats;
		StatusObj sb=db.executeSelectQuery("select * from venue_sections where venue_id=CAST(? AS INTEGER) order by section_id", new String[]{venueid});
		if(!glsecseats.containsKey(venueid)){   
			sectionseats=getSectionsSeats(venueid);
			glsecseats.put(venueid,sectionseats);		
			System.out.println("::sectionseats comming from db:: venueid"+venueid);
		}else{
			sectionseats=(HashMap)glsecseats.get(venueid);
			System.out.println("::sectionseats comming from memory:: venueid"+venueid);
		}
		if(sb.getStatus()){
			for(int i=0;i<sb.getCount();i++){
				HashMap section=new HashMap();
				String sectionid=db.getValue(i, "section_id", "");
				section.put("Sectionid",sectionid);
				section.put("sectionname",db.getValue(i,"sectionname", ""));
				section.put("No_of_rows",db.getValue(i, "noofrows", ""));
				section.put("No_of_cols",db.getValue(i,"noofcols", ""));
				section.put("Layout_Width",db.getValue(i,"layout_width", ""));
				section.put("Layout_Height",db.getValue(i,"layout_height", ""));
				section.put("background_image",db.getValue(i,"background_image", ""));
				section.put("seat_image_width",db.getValue(i,"seat_image_width", ""));
				section.put("seat_image_height",db.getValue(i,"seat_image_height", ""));
				section.put("layout_css",db.getValue(i,"layout_css", ""));
				HashMap Sectionheader=new HashMap();
				sectionids.add(i,sectionid);
				sectionnames.add(i,db.getValue(i, "sectionname", ""));
				Sectionheader.put("rowheader",db.getValue(i,"row_header",""));
				Sectionheader.put("columnheader",db.getValue(i,"col_header",""));
				section.put("Seats",sectionseats.get(sectionid));
				allsections.put(db.getValue(i, "section_id", ""),section);
				allsections.put("header_"+db.getValue(i, "section_id", ""), Sectionheader);
			}
			allsections.put("sectionid",sectionids);
			allsections.put("sectionname",sectionnames);
		}
		return allsections;
	}
	
	public static HashMap getSectionsSeats(String venueid) {
		HashMap sectionseat=new HashMap();
		
		DBManager db=new DBManager();
		String query="select row_id,col_id,seatindex,isseat,seatcode,section_id from venue_seats where venue_id=CAST(? AS INTEGER) and isseat='Y'";
		StatusObj sb=db.executeSelectQuery(query, new String[]{venueid});
		if(sb.getStatus()){
			for(int i=0;i<sb.getCount();i++){
				String sectionid=db.getValue(i, "section_id", "");
				if(sectionseat.containsKey(sectionid)){
					ArrayList seats=(ArrayList) sectionseat.get(sectionid);
					HashMap seat=new HashMap();
					seat.put("row_id",db.getValue(i, "row_id",""));
					seat.put("col_id",db.getValue(i, "col_id",""));
					seat.put("seatindex",db.getValue(i, "seatindex",""));
					seat.put("isseat",db.getValue(i, "isseat",""));
					seat.put("seatcode",db.getValue(i, "seatcode",""));
					seats.add(seat);
				}else{
					ArrayList seats=new ArrayList();
					HashMap seat=new HashMap();
					seat.put("row_id",db.getValue(i, "row_id",""));
					seat.put("col_id",db.getValue(i, "col_id",""));
					seat.put("seatindex",db.getValue(i, "seatindex",""));
					seat.put("isseat",db.getValue(i, "isseat",""));
					seat.put("seatcode",db.getValue(i, "seatcode",""));
					seats.add(seat);
					sectionseat.put(sectionid,seats);
				}
			}
		}
		return sectionseat;
	}
	
	public static HashMap<String, String> getAllotedSeats(String eid,String sectionid){
		HashMap<String, String> seatIndeces=new HashMap<String, String>();
		DBManager dbmanager=new DBManager();
		StatusObj sb=dbmanager.executeSelectQuery("select seatindex,seat_groupid from event_seating where eventid=CAST(? AS BIGINT)", new String[]{eid});
		for(int i=0;i<sb.getCount();i++){
			seatIndeces.put(dbmanager.getValue(i, "seatindex", ""), dbmanager.getValue(i, "seat_groupid", ""));
		}
		return seatIndeces;
	}
	
	public static HashMap getTicketSeatColors(String eid){
		DBManager dbmanager=new DBManager();
		HashMap ticketnames=new HashMap();
		ArrayList seatcolors=new ArrayList();
		String query="select distinct a.color as color,c.price_id as ticketid,c.ticket_name as ticketname,a.seat_groupid from seat_groups a,seat_tickets b,price c where c.price_id=b.ticketid and  a.seat_groupid=b.seat_groupid and a.eventid=CAST(? AS BIGINT)  order by color";
		HashMap<String,ArrayList<String>> tickets=new HashMap<String,ArrayList<String>>();
		HashMap seatgroups=new HashMap();
		StatusObj sb=dbmanager.executeSelectQuery(query,new String[]{eid});
		ArrayList<String> colors;
		for(int i=0;i<sb.getCount();i++)
		{
			String ticket=dbmanager.getValue(i, "ticketid", "");
			String color=dbmanager.getValue(i, "color", "");
			String seatgrpid=dbmanager.getValue(i,"seat_groupid","");
			if(!ticketnames.containsKey(ticket)){
				ticketnames.put(ticket, dbmanager.getValue(i, "ticketname", ""));
			}
			if(!seatgroups.containsKey(seatgrpid)){
				seatgroups.put(seatgrpid, color);
			}
			
			if(tickets.containsKey(ticket)){
				colors=(ArrayList<String>)tickets.get(ticket);
				colors.add(color);
			}else{
				colors=new ArrayList<String>();
				colors.add(color);
				tickets.put(ticket, colors);
			}
		}
		HashMap detailmap=new HashMap();
		detailmap.put("AllotedSeatColors", seatgroups);
		detailmap.put("TicketSeatColors",tickets);
		detailmap.put("ticketnames", ticketnames);
		return detailmap;
	}
	
	public static List getSoldOutSeats(String eid,String sectionid,String eventdate){
		String query="";
		List seats=new ArrayList();
		
		query="select seatindex from seat_booking_status where eventid=CAST(? AS BIGINT)";
		if(!"".equals(eventdate)){
			query="select seatindex from seat_booking_status where eventid=CAST(? AS BIGINT) and eventdate=?";
			
			seats=DbUtil.getValues(query, new String[]{eid,eventdate});
		}else
			seats=DbUtil.getValues(query, new String[]{eid});
		return seats;
	}
	
	public static List getOnHoldSeats(String eid,String eventdate){
		String query="";
		DBManager Db=new DBManager();
		List onholdseats=new ArrayList();
		query="select distinct seatindex from event_reg_block_seats_temp where eventid=? and seatindex NOT IN (select seatindex from seat_booking_status where eventid=CAST(? AS BIGINT))";
		if(!"".equals(eventdate)){
			query="select distinct seatindex from event_reg_block_seats_temp where eventid=? and eventdate=? and seatindex NOT IN (select seatindex from seat_booking_status where eventid=CAST(? AS BIGINT) and eventdate=?)";
			onholdseats=DbUtil.getValues(query,new String[]{eid,eventdate,eid,eventdate});
		}else
			onholdseats=DbUtil.getValues(query,new String[]{eid,eid});
		return onholdseats; 
	}
	
	// May this function not using..
	public static List getOnHoldSeatsTid(String eid,String eventdate,String tid){
		String query="";
		DBManager Db=new DBManager();
		List onholdseats=new ArrayList();
		query="select distinct seatindex from event_reg_block_seats_temp where eventid=? and transactionid!=? and seatindex NOT IN (select seatindex from seat_booking_status where eventid=CAST(? AS BIGINT) and seatindex is not null)";
		if(!"".equals(eventdate)){
			query="select distinct seatindex from event_reg_block_seats_temp where eventid=? and transactionid!=? and eventdate=? and seatindex NOT IN (select seatindex from seat_booking_status where eventid=CAST(? AS BIGINT) and eventdate=? and seatindex is not null)";
			onholdseats=DbUtil.getValues(query,new String[]{eid,tid,eventdate,eid,eventdate});
		}else
			onholdseats=DbUtil.getValues(query,new String[]{eid,tid,eid});
		return onholdseats; 
	}
	
	public static HashMap getHoldSeatTickets(String eid,String eventdate,String tid){
		String query="";		DBManager dbm=new DBManager();		StatusObj sbj=null;
		HashMap blockedSeats=new HashMap();
		query="select distinct seatindex,ticketid from event_reg_block_seats_temp where eventid=? and transactionid=? and seatindex NOT IN (select seatindex from seat_booking_status where eventid=to_number(?,'99999999999') and seatindex is not null)";
		if(!"".equals(eventdate)){
			query="select distinct seatindex,ticketid from event_reg_block_seats_temp where eventid=? and transactionid=? and eventdate=? and seatindex NOT IN (select seatindex from seat_booking_status where eventid=to_number(?,'999999999') and eventdate=? and seatindex is not null)";
			sbj=dbm.executeSelectQuery(query,new String[]{eid,tid,eventdate,eid,eventdate});
			if(sbj.getStatus() && sbj.getCount()>0){
				for(int i=0;i<sbj.getCount();i++)
					blockedSeats.put(dbm.getValue(i,"seatindex",""),dbm.getValue(i,"ticketid",""));
				}	
		}else{
			sbj=dbm.executeSelectQuery(query,new String[]{eid,tid,eid});
			if(sbj.getStatus() && sbj.getCount()>0){
				for(int i=0;i<sbj.getCount();i++)
					blockedSeats.put(dbm.getValue(i,"seatindex",""),dbm.getValue(i,"ticketid",""));
				}
		}	//return onholdseats; 
	return blockedSeats;
	}
	
	public static HashMap getTicketGroupdetails(String eid){
		DBManager dbmanager=new DBManager();
		HashMap groupmap=new HashMap();
		
		StatusObj sb=dbmanager.executeSelectQuery("select ticket_groupid,groupname from event_ticket_groups where eventid=? and groupname!=?",new String[]{eid,""});
		if(sb.getStatus()){
				for(int i=0;i<sb.getCount();i++){
					groupmap.put(dbmanager.getValue(i,"ticket_groupid",""),dbmanager.getValue(i,"groupname",""));
				}
		}
		return groupmap;
	}
	
	public static String getSeatingTicketGroupdetails(String eid){
		String seattickets=DbUtil.getVal("select value from config where name='seating.tickets.groups' and config_id=(select config_id from eventinfo where eventid=?::bigint)  ",new String[]{eid});
		if(seattickets==null)seattickets="";
	return seattickets;
	}
	
	// Tickets settings loader this function using cache
	public static ArrayList getAllticketid(String eid){
		String query="select distinct ticketid from seat_tickets where eventid=CAST(? AS BIGINT) and seat_groupid in (select seat_groupid from seat_groups where eventid=CAST(? AS BIGINT) )";
		ArrayList ticketid=new ArrayList();
		DBManager db=new DBManager();
			StatusObj sb=db.executeSelectQuery(query,new String[]{eid,eid});
			if(sb.getStatus()){
				for(int i=0;i<sb.getCount();i++){
					ticketid.add(i,db.getValue(i,"ticketid",""));
				}
			}
		return ticketid;
	}
	
	public static Map getSeatingVenueDetailsMap(String eid, String venueid){
		if(!CacheManager.getInstanceMap().containsKey("seatingvenuedetails")){
			CacheLoader cacheLoader=new SeatingVenueLoader();
			cacheLoader.setRefreshInterval(3*60*1000);
			cacheLoader.setMaxIdleTime(3*60*1000);
			CacheManager.getInstanceMap().put("seatingvenuedetails",cacheLoader);		
		}
		Map seatingVenueDetailsMap=CacheManager.getData(eid+"_"+venueid, "seatingvenuedetails");
		int t=0;
		while(seatingVenueDetailsMap==null && t<20){
			try {
			    Thread.sleep(200);
			    seatingVenueDetailsMap=CacheManager.getData(eid+"_"+venueid, "seatingvenuedetails");
			    t++;
			} catch(InterruptedException ex) {
				System.out.println("InterruptedException in SeatingDBHelper getSeatingVenueDetailsMap: eventid_venueid: "+eid+"_"+venueid+" iteration: "+t+" Exception: "+ex.getMessage());
			    Thread.currentThread().interrupt();
			}
		}
		return seatingVenueDetailsMap;
	}
	
}
