package com.eventregister;

import java.util.ArrayList;
import java.util.HashMap;

import com.eventbee.general.DateUtil;
import com.eventbee.general.DbUtil;
import com.eventbee.general.EventbeeLogger;
import com.eventbee.general.GenUtil;
import com.eventbee.general.StatusObj;
import com.eventbee.general.formatting.CurrencyFormat;
public class RegistrationProcessDB{
	private ArrayList TicketInfo=null;
	private HashMap buyerDetails=null;
	private HashMap<String,String> EventRegData=null;
	private String eventdate=null;
	final String Transaction_Tickets="insert into transaction_tickets"
								+"(ticketstotal,ticketqty,fee,ticket_groupid,ticketprice,ticketname,groupname,tid,eventid,ticketid,discount,total_nts_commission,transaction_at)"
								+"(select (finalprice+finalfee)*qty,qty,finalfee,ticketgroupid,originalprice+originalfee,ticketname,ticketgroupname,tid,eid,ticketid,discount*qty,final_nts_commission,to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS') from event_reg_ticket_details_temp where tid=? and eid=?)";
	final String DELETE_TRANSACTION_TICKETS="delete from transaction_tickets where tid=? and eventid=?";
	final String EVENT_ATTENDEE="insert into eventattendee(firstname,lastname,email,phone,transactionid,eventid,attendeeid,attendeekey,ticketid)(select fname,lname,email,phone,transactionid,eventid,profileid,profilekey,ticketid  from profile_base_info where transactionid=? and eventid=CAST(? AS BIGINT) and tickettype='attendeeType')";
	final String ORDER_SEQ="select sequence+1 from transaction_sequence where groupid=? and grouptype=?";
	final String ORDER_SEQ_INSERT="insert into transaction_sequence (groupid,sequence,grouptype) values(?,CAST(? AS INTEGER),'EVENT')";
	final String EVENT_REG_TRANSACTIONS_INSERT="insert into event_reg_transactions(current_discount,"
										+"discountcode,ccfee,paymentstatus,phone,userid,current_amount,transaction_date,ordernumber,"
										+"original_amount,servicefee,eventid,paymenttype,current_tax,"
										+"tid,original_discount,fname,bookingsource,lname,current_status_date,"
										+"original_tax,current_nts,email,original_nts,trackpartner,eventdate,ext_pay_id,bookingdomain,ticketurlcode,event_closed_date,amount_we_have,buyer_ntscode,partnerid,actual_ticketqty,collected_ticketqty,currency_code,currency_conversion_factor,current_service_fee,ebeefee_usd,cc_vendor) " +
										"values(CAST(? AS NUMERIC),?,CAST(? AS NUMERIC),?,?,?,CAST(? AS NUMERIC),to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'),?,CAST(? AS NUMERIC),CAST(? AS NUMERIC),?,?,CAST(? AS NUMERIC),?,CAST(? AS NUMERIC),?,?,?,to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'),CAST(? AS NUMERIC),CAST(? AS NUMERIC),?,CAST(? AS NUMERIC),?,?,?,?,?,?,?,?,?,?::BIGINT,?::INTEGER,?,?::NUMERIC,?::NUMERIC,?::NUMERIC,?)";
	final String ORDER_SEQ_UPDATE="update transaction_sequence set sequence=CAST(? AS INTEGER) where groupid=?";
	final String SOLD_QTY_UPDATE="update price set sold_qty=sold_qty+CAST(? AS INTEGER) where price_id=CAST(? AS INTEGER) ";
	final String RECCURRING_DETAILS_UPDATE="update reccurringevent_ticketdetails set soldqty=soldqty+CAST(? AS INTEGER) where ticketid=CAST(? AS BIGINT) and eventdate=? and eventid=CAST(? AS BIGINT)";
	final String RECCURRING_DETAILS_INSERT="insert into reccurringevent_ticketdetails(eventid,ticketid,eventdate,soldqty,isdonation) values(CAST(? AS BIGINT),CAST(? AS BIGINT),?,CAST(? AS INTEGER),?)";
	final String DUPLICATE_BASIC_PROFILES_DELETE="delete from profile_base_info where transactionid=? and profile_setid>(select min(profile_setid) from profile_base_info where transactionid=?)";
	final String DUPLICATE_BUYER_PROFILES_DELETE="delete from buyer_base_info where transactionid=? and profileid>(select min(profileid) from buyer_base_info where transactionid=?)";
	public int  InsertRegistrationDb(String tid,String eid){
		
		RegistrationDBHelper regdbhelper=new RegistrationDBHelper();
		EventRegData=regdbhelper.getRegistrationData(tid,eid);
		buyerDetails=regdbhelper.getBuyerInfo(tid,eid);
		TicketInfo=regdbhelper.getpurchasedTickets(tid);
		String externalpayid="";
		String nts_commission="0.00";
		String paymenttype=EventRegData.get("selectedpaytype");
		String paymentStatus=EventRegData.get("paymentstatus");
		String ccvendor=EventRegData.get("cc_vendor");
		String sts=EventRegData.get("status");
		String waitlistId=EventRegData.get("waitlist_id");
		if(waitlistId==null)waitlistId="";
		String prilistId=EventRegData.get("priority_list_id");
		if(prilistId==null)prilistId="";
		String priToken=EventRegData.get("priority_token");
		if(priToken==null)priToken="";
		
		if(EventRegData!=null&&EventRegData.size()>0){
			if("eventbee".equals(paymenttype)){
				nts_commission=EventRegData.get("nts_commission");
			}
			else{
			//EventRegData.put("cardfee","0");
			}
			externalpayid=regdbhelper.getExternalPayId(EventRegData);
		}
		regdbhelper.InserMailingList(eid,buyerDetails);
		DbUtil.executeUpdateQuery(DELETE_TRANSACTION_TICKETS,new String[]{tid,eid});
		StatusObj s=DbUtil.executeUpdateQuery(Transaction_Tickets,new String[]{DateUtil.getCurrDBFormatDate(),tid,eid});
		System.out.println("Status Of the inserting tickets into transaction_tickets for the transactionid---->"+tid+"---"+s.getStatus());
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "RegistrationProcessDB.java", "Status Of the inserting tickets into transaction_tickets for the transactionid---->"+tid, ""+s.getStatus(), null );
		
		
		StatusObj s1=DbUtil.executeUpdateQuery(EVENT_ATTENDEE,new String[]{tid,eid});
		//System.out.println("Status Of the inserting tickets into event_attendee for the transactionid---->"+tid+"---"+s1.getStatus());
		
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "RegistrationProcessDB.java", "Status Of the inserting details into Event Attendee for the transactionid---->"+tid, ""+s1.getStatus(), null);
		
		
		String orderseq=DbUtil.getVal(ORDER_SEQ,new String []{eid,"EVENT"});
		String paddedorderseq=null;
		String isexists=null;
		if(orderseq==null){
			orderseq="10000200";
			DbUtil.executeUpdateQuery(ORDER_SEQ_INSERT,new String[]{eid,orderseq});
		}
		else{
			StatusObj statobj=DbUtil.executeUpdateQuery(ORDER_SEQ_UPDATE,new String[]{orderseq,eid});
		}
		
		paddedorderseq=GenUtil.getLeftZeroPadded(orderseq,8,"0");
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "RegistrationProcessDB.java", "order seq   insertion into transaction_sequence for the transactionid---->"+tid, ""+paddedorderseq, null);
		eventdate=EventRegData.get("eventdate");
		StatusObj status=null;
		if(TicketInfo!=null&&TicketInfo.size()>0){
			for(int k=0;k<TicketInfo.size();k++){
				HashMap hmap=(HashMap)TicketInfo.get(k);
				DbUtil.executeUpdateQuery(SOLD_QTY_UPDATE,new String[]{(String)hmap.get("ticketQuantity"),(String)hmap.get("ticketId")});
				EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "RegistrationProcessDB.java", "updating price sold qty   of the ticketid for the transactionid---->"+tid, ""+(String)hmap.get("ticketId"), null);
				if(eventdate!=null&&!"".equals(eventdate)){
					isexists=DbUtil.getVal("select 'yes' from reccurringevent_ticketdetails where ticketid=CAST(? AS BIGINT) and eventdate=?",new String[]{(String)hmap.get("ticketId"),eventdate});
					if("yes".equals(isexists)){
					 status=DbUtil.executeUpdateQuery(RECCURRING_DETAILS_UPDATE,new String[]{(String)hmap.get("ticketQuantity"),(String)hmap.get("ticketId"),eventdate,eid});
					
					 }
					else
						 status=DbUtil.executeUpdateQuery(RECCURRING_DETAILS_INSERT,new String[]{eid,(String)hmap.get("ticketId"),eventdate,(String)hmap.get("ticketQuantity"),"donationType".equals((String)hmap.get("ticketType"))?"Yes":"No"});
					
					 EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "RegistrationProcessDB.java", "updating RECCURRING_DETAILS sold qty   of the ticketid for the transactionid---->"+tid, ""+status.getStatus(), null);
				 }
			}
		}
		
		String event_closed_date="";
		Double amount_we_have=0.00;
		if(eventdate!=null&&!"".equals(eventdate)){
			String close_datequery="select est_enddate from event_dates where  to_char(zone_startdate+cast(cast(to_timestamp(COALESCE(zone_start_time,'00'),'HH24:MI:SS') as text) as time ),'Dy, Mon DD, YYYY HH12:MI AM')=?   and eventid=CAST(? AS BIGINT)";
			event_closed_date=DbUtil.getVal(close_datequery, new String[]{eventdate,eid});
		}
		else{
			String close_datequery="select end_date from eventinfo where eventid=CAST(? AS BIGINT)";
			event_closed_date=DbUtil.getVal(close_datequery, new String[]{eid});
		}
		double current_amount=0.00,servicefee=0.00,ebee_usd=0.00,ccfee=0.00,collected_servicefee=0.00;
		collected_servicefee=Double.parseDouble(GenUtil.getHMvalue(EventRegData, "collected_servicefee", "0.00"));
		try{
			servicefee=Double.parseDouble(EventRegData.get("ebeefee"));	
		}catch(Exception e){
			servicefee=0.00;
		}
		try{
			ebee_usd=Double.parseDouble(EventRegData.get("ebeefee_usd"));	
		}catch(Exception e){
			ebee_usd=0.00;
		}
		
		if("eventbee".equals(paymenttype)){	 
			try{
				current_amount= Double.parseDouble(EventRegData.get("grandtotal"));
			}catch(Exception e){
				current_amount=0.00;
			}
			try{
				ccfee=Double.parseDouble(EventRegData.get("cardfee"));
			}catch(Exception e){
				ccfee=0.00;
			}
			try{
				amount_we_have=current_amount - servicefee - ccfee - Double.parseDouble(nts_commission);
			}catch(Exception e){
				amount_we_have=current_amount - servicefee - ccfee;
			}
		}
		else{
			amount_we_have=0.00 - servicefee;
		}
		if("ebeecredits".equals(paymenttype)){
			nts_commission=EventRegData.get("nts_commission");
			try{
				current_amount= Double.parseDouble(EventRegData.get("grandtotal"));
			}catch(Exception e){
				current_amount=0.00;
			}
			try{
				amount_we_have=current_amount - servicefee  - Double.parseDouble(nts_commission);
			}catch(Exception e){
				amount_we_have=current_amount - servicefee ;
			}
		}
		amount_we_have+=collected_servicefee;
		if("".equals(eventdate)){
			eventdate=null;
		}
		if("Authorized".equals(sts))
			paymentStatus ="Authorized";
		else
			paymentStatus ="Completed";
		if(paymenttype.equalsIgnoreCase("other")){
			String subtype=DbUtil.getVal("select attrib_4 from payment_types where refid =? and paytype='other'", new String[]{eid});
			if("manual".equals(subtype))
				paymentStatus="Need Approval";
		}
		
		if(("Completed".equals(paymentStatus) || "Need Approval".equals(paymentStatus)) && !"".equals(waitlistId) ){
			DbUtil.executeUpdateQuery("update wait_list_transactions set status='Completed',transaction_date=now(),updated_at=now() where eventid=?::bigint and wait_list_id=?",new String[]{eid,waitlistId});
		}
		//StatusObj sb=DbUtil.executeUpdateQuery(EVENT_REG_TRANSACTIONS_INSERT,new String[]{(String)EventRegData.get("granddiscount"),(String)EventRegData.get("discountcode"),(String)EventRegData.get("cardfee"),"Completed",(String)buyerDetails.get("phone"),"0",(String)EventRegData.get("grandtotal"),paddedorderseq,(String)EventRegData.get("grandtotal"),(String)EventRegData.get("ebeefee"),eid,(String)EventRegData.get("selectedpaytype"),(String)EventRegData.get("tax"),tid,(String)EventRegData.get("granddiscount"),(String)buyerDetails.get("firstName"),"online",(String)buyerDetails.get("lastName"),(String)EventRegData.get("tax"),"0",(String)buyerDetails.get("email"),"0",(String)EventRegData.get("trackurl"),eventdate,externalpayid,(String)EventRegData.get("context"),(String)EventRegData.get("ticketurlcode"),event_closed_date,amount_we_have.toString() });
		StatusObj sb1=DbUtil.executeUpdateQuery("delete from event_reg_transactions where eventid=? and tid=?",new String[]{eid,tid});
		if(sb1.getStatus() && sb1.getCount()>0)
			System.out.println("DUPLICATE-TRANSACTIONID found for tid: "+tid+", No of Duplicates deleted: "+sb1.getCount());
		StatusObj sb=DbUtil.executeUpdateQuery(EVENT_REG_TRANSACTIONS_INSERT,new String[]{EventRegData.get("granddiscount"),EventRegData.get("discountcode"),EventRegData.get("cardfee"),paymentStatus,(String)buyerDetails.get("phone"),"0",EventRegData.get("grandtotal"),DateUtil.getCurrDBFormatDate(),paddedorderseq,EventRegData.get("grandtotal"),EventRegData.get("ebeefee"),eid,EventRegData.get("selectedpaytype"),EventRegData.get("tax"),tid,EventRegData.get("granddiscount"),(String)buyerDetails.get("firstName"),"online",(String)buyerDetails.get("lastName"),DateUtil.getCurrDBFormatDate(),EventRegData.get("tax"),nts_commission,(String)buyerDetails.get("email"),nts_commission,EventRegData.get("trackurl"),eventdate,externalpayid,EventRegData.get("context"),EventRegData.get("ticketurlcode"),event_closed_date,CurrencyFormat.getCurrencyFormat("", Double.toString(amount_we_have), true),EventRegData.get("buyer_ntscode"),EventRegData.get("referral_ntscode"),EventRegData.get("totticketsqty"),EventRegData.get("collected_ticketqty"),EventRegData.get("currency_code"),EventRegData.get("currency_conversion_factor"),EventRegData.get("current_service_fee"),EventRegData.get("ebeefee_usd"),EventRegData.get("cc_vendor") });
		
		if("paypal".equals(paymenttype) && "chained".equals(EventRegData.get("paymentmode"))){
			DbUtil.executeUpdateQuery("update event_reg_transactions set collected_servicefee=CAST(? AS NUMERIC),amount_we_have=?,current_nts=CAST(? AS NUMERIC),original_nts=CAST(? AS NUMERIC),collected_by='paypalx' where tid=?",new String[]{(String)EventRegData.get("collected_servicefee"),"0.00",(String)EventRegData.get("nts_commission"),(String)EventRegData.get("nts_commission"),tid});
			String currencyconversion=regdbhelper.getcurrencyconversion(eid);
			EventRegData.put("currencyconversion", currencyconversion);
			InsertNTSPartnerCredits(EventRegData);
		}	
		if("eventbee".equals(paymenttype)){
			String currencyconversion=regdbhelper.getcurrencyconversion(eid);
			EventRegData.put("currencyconversion", currencyconversion);
			InsertNTSPartnerCredits(EventRegData);
		}
		String mgrId=DbUtil.getVal("select mgr_id from eventinfo where eventid=?::integer", new String[]{eid});
		//if("other".equals(paymenttype) || "google".equals(paymenttype) || ("paypal".equals(paymenttype) && !"chained".equals(EventRegData.get("paymentmode"))) || "authorize.net".equals(paymenttype) || "braintree_manager".equals(paymenttype)|| "stripe".equals(paymenttype)){
		if("other".equals(paymenttype) || "eventbee".equals(paymenttype) || ("paypal".equals(paymenttype) && !"chained".equals(EventRegData.get("paymentmode"))) || "authorize.net".equals(paymenttype) || "braintree".equals(paymenttype)|| "stripe".equals(paymenttype) || "payulatam".equals(paymenttype)){
			String iscollected=DbUtil.getVal("select 'yes' from mgr_credits_usage_history where tid=?", new String[]{tid});
			if(!"yes".equals(iscollected) && ebee_usd>0){
				String avail=DbUtil.getVal("select 'yes' from mgr_available_credits where mgr_id=?::BIGINT and available_credits>=?::NUMERIC", new String[]{mgrId,EventRegData.get("ebeefee_usd")});
				if("yes".equals(avail) && !"yes".equals(iscollected)){
					DbUtil.executeUpdateQuery("update mgr_available_credits set used_credits=used_credits+?::NUMERIC where mgr_id=?::BIGINT", new String[]{EventRegData.get("ebeefee_usd"),mgrId});
					DbUtil.executeUpdateQuery("update mgr_available_credits set available_credits=total_credits-used_credits,updated_by='registration',last_updated_at=to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS') where mgr_id=?::BIGINT", new String[]{DateUtil.getCurrDBFormatDate(),mgrId});
					DbUtil.executeUpdateQuery("insert into mgr_credits_usage_history(mgr_id,used_for_eventid,used_credits,tid,used_date) values(?::BIGINT,?::BIGINT,?::NUMERIC,?,to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'))", new String[]{mgrId,eid,EventRegData.get("ebeefee_usd"),tid,DateUtil.getCurrDBFormatDate()});
					DbUtil.executeUpdateQuery("update event_reg_details_temp set collected_servicefee=?::NUMERIC where tid=?", new String[]{EventRegData.get("ebeefee"),tid});
					DbUtil.executeUpdateQuery("update event_reg_transactions set collected_servicefee=?::NUMERIC,collected_by='beecredits' where tid=?", new String[]{EventRegData.get("ebeefee"),tid});
					DbUtil.executeUpdateQuery("update event_reg_transactions set amount_we_have=amount_we_have::NUMERIC+collected_servicefee where tid=?", new String[]{tid});
				}
				else
					System.out.println("RegistrationProcessDB-"+tid+": credits not available");
			}
		}
		if("ebeecredits".equals(paymenttype)){
			String currencyconversion=regdbhelper.getcurrencyconversion(eid);
			EventRegData.put("currencyconversion", currencyconversion);
			InsertNTSPartnerCredits(EventRegData);
			InsertNTSPartnerUsedCredits(EventRegData);
		}
		
		
		String seatingenabled=DbUtil.getVal("select value from config where config_id=(select config_id from eventinfo where eventid=?::bigint)" +
				" and name='event.seating.enabled'",new String[]{eid});		
		if("YES".equals(seatingenabled)){
			RegConfirmationDBHelper regConfirmdb=new RegConfirmationDBHelper();
			String venueid=DbUtil.getVal("select value from config where config_id=(select config_id from eventinfo where eventid=?::bigint)" +
					" and name='event.seating.venueid' ",new String[]{eid});
			DbUtil.executeUpdateQuery("delete from seat_booking_status where eventid=?::bigint and tid=?", new String[]{eid,tid});
			regConfirmdb.fillseatingstatus(tid, eid, eventdate,venueid);
		}	
		
		
		DbUtil.executeUpdateQuery("delete from event_reg_block_seats_temp where transactionid=?",new String [] {tid});
		DbUtil.executeUpdateQuery("delete from event_reg_locked_tickets where tid=?",new String [] {tid});
		
		DbUtil.executeUpdateQuery("update profile_base_info set profilestatus ='Completed' where transactionid=?",new String [] {tid});
		DbUtil.executeUpdateQuery("update buyer_base_info set profilestatus='Completed' where transactionid=?",new String [] {tid});
		deleteDuplicateProfiles(tid);
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "RegistrationProcessDB.java", "updating event_reg_transactions  status for the transactionid---->"+tid, ""+sb.getStatus(), null);
		
		String referral_ntscode=EventRegData.get("referral_ntscode");
		System.out.println("referral_ntscode at sale count:"+referral_ntscode);
		if(!"".equals(referral_ntscode)&& referral_ntscode!=null)
		{   referral_ntscode=referral_ntscode.trim();
			String salecount=DbUtil.getVal("SELECT sum(ticketqty) from transaction_tickets where total_nts_commission>0 and tid=?",new String[]{tid});
			System.out.println("salecount:"+salecount);
			if(!"".equals(salecount)&& salecount!=null) 
			{	try{ DbUtil.executeUpdateQuery("update nts_visit_track set ticket_sale_count=ticket_sale_count+cast(? as numeric) where nts_code =? and eventid=?",new String[]{salecount,referral_ntscode,eid});
				   }catch(Exception e){System.out.println("problem sale count"+salecount+":"+e.getMessage());}
					
			}
		}
		
		if(!"".equals(prilistId) && !"".equals(priToken)){
			//StatusObj priost=DbUtil.executeUpdateQuery("delete from priority_reg_transactions where eventid=? and tid=?",new String[]{eid,tid});
			String priorityStatus="Completed";
			String isPriorityTktQry="select 'yes' from transaction_tickets where tid=? and eventid=? and ticketid in(select unnest(string_to_array(tickets, ',')::bigint[]) from priority_list  where eventid=CAST(? AS BIGINT) and list_id=?) limit 1";
			String isPriorityTkt=DbUtil.getVal(isPriorityTktQry, new String[]{tid,eid,eid,prilistId});
			if(!"yes".equals(isPriorityTkt)) priorityStatus="No Priority";
			if(eventdate!=null && !"".equals(eventdate))
				DbUtil.executeUpdateQuery("update priority_reg_transactions set tid=?,status=?,eventdate=?,updated_at=to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS') where eventid=CAST(? AS BIGINT) and list_id=? and pri_token=?",new String[]{tid,priorityStatus,eventdate,DateUtil.getCurrDBFormatDate(),eid,prilistId,priToken});
			else
				DbUtil.executeUpdateQuery("update priority_reg_transactions set tid=?,status=?,updated_at=to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS') where eventid=CAST(? AS BIGINT) and list_id=? and pri_token=?",new String[]{tid,priorityStatus,DateUtil.getCurrDBFormatDate(),eid,prilistId,priToken});
		}
		
		if(sb.getStatus())
		return 1;
		else
		return 0;
	}
	
	public void deleteDuplicateProfiles(String tid){
		System.out.println("Searching DUPLICATE-BASIC-PROFILES for tid: "+tid);
		StatusObj basicsob=DbUtil.executeUpdateQuery(DUPLICATE_BASIC_PROFILES_DELETE, new String[]{tid,tid});
		if(basicsob.getStatus() && basicsob.getCount()>0){
			System.out.println("DUPLICATE-BASIC-PROFILES found for tid: "+tid+", No of Duplicates deleted: "+basicsob.getCount());
		}
		System.out.println("Searching DUPLICATE-BUYER-PROFILES for tid: "+tid);
		StatusObj buyersob=DbUtil.executeUpdateQuery(DUPLICATE_BUYER_PROFILES_DELETE, new String[]{tid,tid});
		if(buyersob.getStatus() && buyersob.getCount()>0){
			System.out.println("DUPLICATE-BUYER-PROFILES found for tid: "+tid+", No of Duplicates deleted: "+buyersob.getCount());
		}
	}
	
	public void InsertNTSPartnerUsedCredits(HashMap<String,String> tempDetailsMap) {
		//String query="insert into nts_partner_used_credits (nts_code,transactiondate,eventid,tid,credits,purpose) values(?,now(),?,?,?,'EVENT-REGISTRATION')";
		String query="insert into nts_partner_used_credits (nts_code,transactiondate,eventid,tid,credits,purpose) values(?,to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'),?,?,CAST(? AS NUMERIC),'EVENT-REGISTRATION')";
		String currencyconversion=tempDetailsMap.get("currencyconversion");	
		String credits=Double.toString(Double.parseDouble(tempDetailsMap.get("grandtotal"))/Double.parseDouble(currencyconversion));
		credits=CurrencyFormat.getCurrencyFormat("", credits, true);
		DbUtil.executeUpdateQuery(query, new String[]{tempDetailsMap.get("buyer_ntscode"),DateUtil.getCurrDBFormatDate(),tempDetailsMap.get("eventid"),tempDetailsMap.get("tid"),credits});
		query="update ebee_nts_partner set used_credits=used_credits+CAST(? AS NUMERIC) where nts_code=?";
		DbUtil.executeUpdateQuery(query, new String[]{credits,tempDetailsMap.get("buyer_ntscode")});
	}
	public void InsertNTSPartnerCredits(HashMap<String,String> tempdata){
		String referral_ntscode=tempdata.get("referral_ntscode");
		String eventid=tempdata.get("eventid");
		if(!"".equals(referral_ntscode)){
			String currencyconversion=tempdata.get("currencyconversion");
			String ebeentscommissionpercentage="0",ebeecommissiontype="default",ebeentscommission="0.00";
			String credits="0.00";
			String nts_commission=tempdata.get("nts_commission");
			if(!"0".equals(nts_commission)){
				RegistrationDBHelper regdbhelper=new RegistrationDBHelper();
				HashMap commissiondetails=regdbhelper.getebeeNTSCommission(referral_ntscode,eventid);
				ebeentscommissionpercentage=(String)commissiondetails.get("ebeentscommission");
				ebeecommissiontype=(String)commissiondetails.get("ebeecommissiontype");
				//ebeentscommission=regdbhelper.getebeeNTSCommission(referral_ntscode,eventid);
				
				try{
					ebeentscommission=Double.toString(Double.parseDouble(nts_commission)*Double.parseDouble(ebeentscommissionpercentage)/100);
					credits=Double.toString(Double.parseDouble(nts_commission)-Double.parseDouble(ebeentscommission));
					ebeentscommission=Double.toString(Double.parseDouble(ebeentscommission)/Double.parseDouble(currencyconversion));
				}catch(Exception e){
					credits=Double.toString(Double.parseDouble(nts_commission));
				}
				credits=Double.toString(Double.parseDouble(credits)/Double.parseDouble(currencyconversion));
			}
			credits=CurrencyFormat.getCurrencyFormat("", credits, true);
			ebeentscommission=CurrencyFormat.getCurrencyFormat("", ebeentscommission, true);
			String query="insert into event_reg_nts_partner(tid,nts_code,transaction_date,accrued_credits,eventid,eventdate,payment_type,hold_credits,status,ebee_commission,ebee_commission_percentage,commission_type) values(?,?,to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'),CAST(? AS NUMERIC),?,?,?,CAST(? AS NUMERIC),'On Hold',CAST(? AS NUMERIC),CAST(? AS NUMERIC),?)";
			DbUtil.executeUpdateQuery(query, new String[]{tempdata.get("tid"),referral_ntscode,DateUtil.getCurrDBFormatDate(),credits,tempdata.get("eventid"),tempdata.get("eventdate"),tempdata.get("selectedpaytype"),credits,ebeentscommission,ebeentscommissionpercentage,ebeecommissiontype});
			query="update ebee_partner_credits set accrued_credits=accrued_credits+CAST(? AS NUMERIC),hold_credits=hold_credits+CAST(? AS NUMERIC) where ref_id=? and nts_code=?";
			StatusObj sb=DbUtil.executeUpdateQuery(query,new String[]{credits,credits,eventid,referral_ntscode});
			if(sb.getCount()==0){
				query="insert into ebee_partner_credits(nts_code,ref_id,accrued_credits,hold_credits,cleared_credits,purpose) values (?,?,CAST(? AS NUMERIC),CAST(? AS NUMERIC),0,'NTS')";
				DbUtil.executeUpdateQuery(query, new String[]{referral_ntscode,eventid,credits,credits});
			}
			query="update ebee_nts_partner set accrued_credits=accrued_credits+CAST(? AS NUMERIC) where nts_code=?";
			DbUtil.executeUpdateQuery(query, new String[]{credits,referral_ntscode});
		}
	}

}