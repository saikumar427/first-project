package com.eventregister;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import com.customquestions.beans.BAttribOption;
import com.eventbee.general.DBManager;
import com.eventbee.general.DateUtil;
import com.eventbee.general.DbUtil;
import com.eventbee.general.EventbeeLogger;
import com.eventbee.general.GenUtil;
import com.eventbee.general.StatusObj;

public class BProfileActionDB{
	
	public HashMap<String,ArrayList<String>> getSeatingCodeDetails(String eid,String tid,String eventdate,ArrayList<HashMap<String, String>> ticketsList){
		HashMap<String,ArrayList<String>> seatingDetails=new HashMap<String,ArrayList<String>>();
		if(" ".equals(eventdate))eventdate="";
		String query="select seatcode,seatindex from venue_seats where venue_id =CAST((select value from config where name='event.seating.venueid' and config_id in (select config_id from eventinfo where eventid=CAST(? AS BIGINT))) AS INTEGER) and seatindex in(select seatindex from event_reg_block_seats_temp where eventid=? and transactionid=? and ticketid=CAST(? AS BIGINT))";
		if(!"".equals(eventdate)){
			query="select seatcode,seatindex from venue_seats where venue_id =CAST((select value from config where name='event.seating.venueid' and config_id in (select config_id from eventinfo where eventid=CAST(? AS BIGINT))) AS INTEGER) and seatindex in(select seatindex from event_reg_block_seats_temp where eventid=? and transactionid=? and ticketid=CAST(? AS BIGINT) and eventdate=?)";		
		}
		DBManager db=new DBManager();
		StatusObj Sel_tic_sb;	
		for(int k=0;k<ticketsList.size();k++){
			ArrayList<String> seatCodes=new ArrayList<String>();
			ArrayList<String> seatIndex=new ArrayList<String>();
			String ticketid=ticketsList.get(k).get("selectedTicket");
			if(!"".equals(eventdate))
				Sel_tic_sb=db.executeSelectQuery(query,new String[]{eid,eid,tid,ticketid,eventdate});
			else
				Sel_tic_sb=db.executeSelectQuery(query,new String[]{eid,eid,tid,ticketid});
			if(Sel_tic_sb.getStatus()&&Sel_tic_sb.getCount()>0){
				for(int i=0;i<Sel_tic_sb.getCount();i++){
					seatCodes.add(db.getValue(i, "seatcode", ""));
					seatIndex.add(db.getValue(i, "seatindex", ""));
				}				
			}
			seatingDetails.put(ticketid, seatCodes);
			seatingDetails.put(ticketid+"_index", seatIndex);
		}		
		return seatingDetails;
	}
		
	public void updateBaseProfile(HashMap baseprofile){
		try{
			String seatcode=(String)baseprofile.get("seatcode");
			String profilebasequery="insert into profile_base_info(eventid,fname,lname,transactionid,phone,email,profilekey,ticketid,tickettype,profileid,created_at,seatcode,profile_setid,seatindex)"
				+" values(CAST(? AS BIGINT),?,?,?,?,?,?,CAST(? AS BIGINT),?,CAST(? AS INTEGER),to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'),?,?::bigint,?)";
			StatusObj s1=DbUtil.executeUpdateQuery(profilebasequery,new String[]{(String)baseprofile.get("eventid"),(String)baseprofile.get("fname"),(String)baseprofile.get("lname"),(String)baseprofile.get("tid"),(String)baseprofile.get("phone"),(String)baseprofile.get("email"),(String)baseprofile.get("profilekey"),(String)baseprofile.get("ticketid"),(String)baseprofile.get("tickettype"),(String)baseprofile.get("profileid"),DateUtil.getCurrDBFormatDate(),seatcode,(String)baseprofile.get("profile_setid"),(String)baseprofile.get("seat_index")});
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "ProfileActionDB.java", "Status Of the inserting updateBaseProfile into profilebaseinfo for the transactionid---->"+baseprofile.get("tid"), ""+s1.getStatus(), null );
		}
		catch(Exception e){
			System.out.println("Exception occured in UpdeBaseProfileInfo--"+e.getMessage());
		}
	}
	
	public void InsertResponseMaster(HashMap<String,String> responseMaterMap){
		try{
			String response_master="insert into custom_questions_response_master(transactionid,attribsetid,ref_id,subgroupid,groupid,profileid,profilekey,created)" +
				" values(?,?,?,CAST(? AS BIGINT),CAST(? AS BIGINT),CAST(? AS BIGINT),?,to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'))";
			StatusObj s=DbUtil.executeUpdateQuery(response_master,new String[]{(String)responseMaterMap.get("tid"),(String)responseMaterMap.get("custom_setid"),(String)responseMaterMap.get("responseid"),(String)responseMaterMap.get("ticketid"),(String)responseMaterMap.get("eventid"),(String)responseMaterMap.get("profileid"),(String)responseMaterMap.get("profilekey"),DateUtil.getCurrDBFormatDate()});
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "ProfileActionDB.java", "Status Of the inserting Entry into respnseMaster for the transactionid---->"+responseMaterMap.get("tid"), ""+s.getStatus(), null );
		}
		catch(Exception e){
			System.out.println("Exception occured in InsertResponseMaster is "+e.getMessage());
		}
	}

	public void insertResponse(HashMap<String, String> respnseMap){
		try{
			StatusObj sb1=DbUtil.executeUpdateQuery("insert into custom_questions_response(ref_id,attribid,created,shortresponse,bigresponse)" +
			" values(?,CAST(? AS INTEGER),to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'),?,?)",new String[]{(String)respnseMap.get("responseid"),(String)respnseMap.get("questionid"),DateUtil.getCurrDBFormatDate(),(String)respnseMap.get("shortresponse"),(String)respnseMap.get("bigresponse")});
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "ProfileActionDB.java", "Status Of the inserting Response into insertResponse for the transactionid---->"+respnseMap.get("responseid"), ""+sb1.getStatus(), null );
		}
		catch(Exception e){
			System.out.println("Exception Occured while Insering Response"+e.getMessage());
		}
	}
	
	public void inserBuyerInfo(HashMap<String,String> buyerInfo){
		try{
			StatusObj sb=DbUtil.executeUpdateQuery("insert into buyer_base_info(fname,lname,email,phone,profileid,profilekey,transactionid,eventid,created_at) values (?,?,?,?,CAST(? AS INTEGER),?,?,CAST(? AS BIGINT),to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'))",new String[]{(String)buyerInfo.get("fname"),(String)buyerInfo.get("lname"),(String)buyerInfo.get("email"),(String)buyerInfo.get("phone"),(String)buyerInfo.get("profileid"),(String)buyerInfo.get("profilekey"),(String)buyerInfo.get("tid"),(String)buyerInfo.get("eventid"),DateUtil.getCurrDBFormatDate()});
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "ProfileActionDB.java", "Status Of the inserting buyerInfo into buyer_base_info for the transactionid---->"+buyerInfo.get("tid"), ""+sb.getStatus(), null );
		}
		catch(Exception e){
			System.out.println("Exception While Inserting BuyerInfo-----------"+e.getMessage());
		}
	}
	
	public String [] getOptionVal(ArrayList options,String responses[]){
		ArrayList responseList=new ArrayList();
		try{
			List als=Arrays.asList(responses);
			if(options!=null){
				for(int p=0;p<options.size();p++){
					BAttribOption attribop=(BAttribOption)options.get(p);
					String optionid=attribop.getOptionid();
					if(als.contains(optionid)){
						responseList.add(attribop.getOptionValue());
					}
				}
			}
		}
		catch(Exception e){
			System.out.println("Exception in getOptionVal-----------"+e.getMessage());
		}
		return (String[])responseList.toArray(new String[responseList.size()]);
	}
	/*
	RSVP Attendee Db Insertion
	 */
	public void InsertAttendeeInfo(HashMap attendeeMap){
		BRegistrationDBHelper regdbhelper=new BRegistrationDBHelper();
		String query="insert into rsvpattendee(firstname,lastname,attendeekey,attendeeid,eventid,phone,email,priattendee,attendeecount,attendingevent) values(?,?,?,CAST(? AS INTEGER),CAST(? AS BIGINT),?,?,?,?,?)";
		DbUtil.executeUpdateQuery(query,new String[]{(String)attendeeMap.get("fname"),(String)attendeeMap.get("lname"),"0",(String)attendeeMap.get("attendeeid"),(String)attendeeMap.get("eventid"),(String)attendeeMap.get("phone"),(String)attendeeMap.get("email"),"Y","1",(String)attendeeMap.get("attending")});
		if("yes".equals((String)GenUtil.getHMvalue(attendeeMap,"attending",""))){
			int r=BRsvpEmailProcessing.sendRsvpEmail(attendeeMap);
			regdbhelper.InserMailingList((String)attendeeMap.get("eventid"),attendeeMap);
		}
	}
	
	public void clearDBEntries(String tid){
		DbUtil.executeUpdateQuery("delete from profile_base_info where transactionid=?",new String []{tid});
		DbUtil.executeUpdateQuery("delete from promotion_mail_list where attrib1=?",new String []{tid});
		DbUtil.executeUpdateQuery("delete from buyer_base_info where transactionid=?",new String []{tid});
		DbUtil.executeUpdateQuery("delete from custom_questions_response where ref_id in(select ref_id from custom_questions_response_master where transactionid=?)",new String []{tid});
		DbUtil.executeUpdateQuery("delete from custom_questions_response_master where transactionid=?",new String []{tid});
		DbUtil.executeUpdateQuery("delete from seat_booking_status where tid=?", new String[]{tid});
	}

	public void updatePromotionList(HashMap buyermap){
		//String query="insert into promotion_mail_list(eid,attrib1,fname,lname,email,created_at) values (?,?,?,?,?,now())";
		String query="insert into promotion_mail_list(eid,attrib1,fname,lname,email,created_at) values (CAST(? AS BIGINT),?,?,?,?,to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'))";
		//DbUtil.executeUpdateQuery(query,new String[]{(String)buyermap.get("eventid"),(String)buyermap.get("tid"),(String)buyermap.get("fname"),(String)buyermap.get("lname"),(String)buyermap.get("email")});
		DbUtil.executeUpdateQuery(query,new String[]{(String)buyermap.get("eventid"),(String)buyermap.get("tid"),(String)buyermap.get("fname"),(String)buyermap.get("lname"),(String)buyermap.get("email"),DateUtil.getCurrDBFormatDate()});
	}
}