package com.eventregister;

import java.util.ArrayList;
import java.util.HashMap;

import org.json.JSONArray;
import org.json.JSONObject;

import com.eventbee.general.DBManager;
import com.eventbee.general.DbUtil;
import com.eventbee.general.EventbeeLogger;
import com.eventbee.general.StatusObj;
import com.sun.media.sound.JavaSoundAudioClip;

public class CCheckTicketStatus {
	
	public static String TICKET_LEVEL_QTY_CRITERIA_MSG= "ticket-level-qty-criteria";
	public static String EVENT_LEVEL_QTY_CRITERIA_MSG= "event-level-qty-criteria";
	String GET_TICKETS_QUERY="select groupname,ticket_groupid,price_id,ticket_name,networkcommission from tickets_details_view where eventid=?";
	
	public JSONArray getConditionalTicketingRules(String eid){
		JSONArray conditionJsonAry=new JSONArray();
		String conditions = DbUtil.getVal("select rules from conditional_ticketing_rules where eventid=CAST(? AS BIGINT)", new String[]{eid});
		if(conditions==null) conditions="";
		try{
			conditionJsonAry = new JSONArray(conditions);
		}catch(Exception e){
		}
		return conditionJsonAry;
	}
	
	public HashMap<String,HashMap<String, String>> eventLevelCheck(String eid,String tid,String eventdate,String sel_qty){
		HashMap<String,HashMap<String, String>> result=new HashMap<String,HashMap<String, String>>();
		String limitCount=DbUtil.getVal("select value from config where config_id=(select config_id from eventinfo where eventid=?::bigint) and name='event.reg.eventlevelcheck.count'",new String[]{eid});
		limitCount=limitCount==null?"":limitCount.trim();

		System.out.println("(Box Office) eid::"+eid);
		System.out.println("(Box Office) tid::"+tid);
		System.out.println("(Box Office) eventdate::"+eventdate);
		System.out.println("(Box Office) el_qty::"+sel_qty);
		System.out.println(eid+"limitcount::"+limitCount);
		
		if("".equals(limitCount))
			return result;

		try{
			Integer.parseInt(limitCount);
		}catch(Exception e){
			return result;
		}

		String query="";
		String params[]=null;	 
		if(!"".equals(tid)){
			if("".equals(eventdate))
			{     query="select  (?::integer -((select COALESCE(sum(locked_qty),0) from  event_reg_locked_tickets where eventid=? and tid!=?)+(select COALESCE(sum(sold_qty),0) from price where evt_id=?::bigint and isdonation='No' ))) as re_qty";
			params=new String[]{limitCount,eid,tid,eid};
			}
			else
			{	    query="select  (?::integer -((select COALESCE(sum(locked_qty),0) from event_reg_locked_tickets where eventid=? and eventdate=? and tid!=?)+(select COALESCE (sum (soldqty),0) from  reccurringevent_ticketdetails where eventid=?::bigint and eventdate=? and isdonation='No'))) as re_qty";
			params=new String[]{limitCount,eid,eventdate,tid,eid,eventdate};
			}	
		}
		else{
			if("".equals(eventdate))
			{    query="select  (?::integer -((select COALESCE(sum(locked_qty),0) from event_reg_locked_tickets where eventid=?)+(select COALESCE(sum(sold_qty),0) from price where evt_id=?::bigint and isdonation='No'))) as re_qty";
			params=new String[]{limitCount,eid,eid};
			}
			else
			{query="select (? ::integer -((select COALESCE(sum(locked_qty),0) from event_reg_locked_tickets where eventid=? and eventdate=?)+(select COALESCE( sum (soldqty),0) from reccurringevent_ticketdetails where eventid=?::bigint and eventdate=? and isdonation='No'))) as re_qty";
			params=new String[]{limitCount,eid,eventdate,eid,eventdate};
			}
		}
		if("".equals(query))	
			return result;
		String requireQty=DbUtil.getVal(query,params);
		System.out.println("(Box office)reqty:::::::"+requireQty+"  params::"+ params);
		try{
			if(Integer.parseInt(requireQty)<Integer.parseInt(sel_qty)){
				HashMap<String, String> temp=new HashMap<String, String>();
				temp.put("selected_qty",sel_qty);
				temp.put("remaining_qty",requireQty);
				temp.put("eventname",DbUtil.getVal("select eventname from eventinfo where eventid=?::bigint",new String[]{eid}));
				result.put(eid, temp);				
			}	
		}catch(Exception e ){System.out.println("Error While calculating the event level check:::"+tid+"::"+e.getMessage());
		}
		System.out.println("result:::::::"+result);
		return result;	
	}
	
	public HashMap<String,HashMap<String,String>> getNONRecurringEventTicketsAvailibility(String eid,String tid,JSONArray ticketsQtyArray,HashMap<String,HashMap<String, String>> eventTickets,String waitListID,String edate){
		HashMap<String,HashMap<String,String>> qtyDetails=new HashMap<String,HashMap<String,String>>();
		HashMap<String,String> remainingCountMap=new HashMap<String,String>();
		try{			
			DBManager db=new DBManager();
			StatusObj sb=null;
			ArrayList<HashMap<String,Integer>> waitListHoldQty=null;
			///event level check
			int sel_qty=0;
			try{	 
				for(int i=0;i<ticketsQtyArray.length();i++){
					JSONObject eachTicket=ticketsQtyArray.getJSONObject(i);
					
					HashMap<String, String> ticketDetails=eventTickets.get(eachTicket.get("ticket_id"));
					
					if("Yes".equalsIgnoreCase(ticketDetails.get("isdonation"))||"yes".equalsIgnoreCase(ticketDetails.get("isdonation"))||"y".equalsIgnoreCase(ticketDetails.get("isdonation"))){
						//sel_qty=sel_qty+1;
					}else
						sel_qty=sel_qty+Integer.parseInt(ticketsQtyArray.getJSONObject(i).getString("qty"));
				}				
			}catch(Exception e){System.out.println("error qty cal::"+tid);sel_qty=0;}	
			
			waitListHoldQty = getWaitListHoldQty(eid,edate,waitListID);

			qtyDetails=eventLevelCheck(eid, tid,"",sel_qty+"");
			if(!qtyDetails.isEmpty()){//event level quantity  criteria has reached 
				HashMap<String, String> temp=new HashMap<String, String>();
				temp.put("criteria", EVENT_LEVEL_QTY_CRITERIA_MSG);
				qtyDetails.put("criteria", temp);
				return qtyDetails;
			}
			/****end eventlevel check****/


			if(!"".equals(tid)){
				String pricequery="select (max_ticket-sold_qty) as remaining_qty, price_id as "
						+"ticketid from price a where evt_id=CAST(? AS BIGINT) and price_id not"
						+" in (select ticketid from event_reg_locked_tickets where "
						+"eventid=? and tid!=?) union "
						+"select a.max_ticket-a.sold_qty-sum(locked_qty)  as remaining_qty,"
						+"ticketid from event_reg_locked_tickets b,  price a "
						+"where eventid=? and tid!=? and a.price_id=b.ticketid "
						+"group by ticketid, a.max_ticket, a.sold_qty";

				sb=db.executeSelectQuery(pricequery,new String[]{eid,eid,tid,eid,tid});

			}
			else{
				String pricequery="select (max_ticket-sold_qty) as remaining_qty, price_id as "
						+" ticketid from price a where evt_id=CAST(? AS BIGINT) and price_id not "
						+"in (select ticketid from event_reg_locked_tickets where "
						+"eventid=? ) union "
						+"select a.max_ticket-a.sold_qty-sum(locked_qty)  as remaining_qty, "
						+"ticketid from event_reg_locked_tickets b,  price a " 
						+"where eventid=? and a.price_id=b.ticketid "
						+"group by ticketid, a.max_ticket, a.sold_qty";
				sb=db.executeSelectQuery(pricequery,new String[]{eid,eid,eid});
			}
			
			
			
			if(sb.getStatus() && sb.getCount()>0){
				for(int i=0;i<sb.getCount();i++){
					if( !"".equals(waitListID) && waitListHoldQty.get(0).containsKey(waitListID) ){
						remainingCountMap.put(db.getValue(i,"ticketid",""),db.getValue(i,"remaining_qty",""));
					}else{
						int waitedQty=0;
						if(waitListHoldQty!=null)
							waitedQty=waitListHoldQty.get(1).get(db.getValue(i,"ticketid",""))==null?0:waitListHoldQty.get(1).get(db.getValue(i,"ticketid",""));
						remainingCountMap.put(db.getValue(i,"ticketid",""),(Integer.parseInt(db.getValue(i,"remaining_qty",""))-waitedQty)+"");
					}
					//remainingCountMap.put(db.getValue(i,"ticketid",""),db.getValue(i,"remaining_qty",""));
				}
			}


			for(int i=0;i<ticketsQtyArray.length();i++){
				
				JSONObject eachTicketQtyJSON=ticketsQtyArray.getJSONObject(i);
				String ticketId=eachTicketQtyJSON.getString("ticket_id");
				String ticket_name=eachTicketQtyJSON.getString("ticket_name");
				int qty=0;
				if(eachTicketQtyJSON.has("qty"))
					qty=Integer.parseInt(eachTicketQtyJSON.getString("qty"));
				int remainingQty=Integer.parseInt((String)remainingCountMap.get(ticketId));

				if(qty>remainingQty){
					HashMap<String, String> temp=new HashMap<String, String>();
					temp.put("ticket_id",ticketId+"");
					temp.put("selected_qty",qty+"");
					temp.put("remaining_qty",remainingQty+"");
					temp.put("ticket_name",ticket_name);
					qtyDetails.put(ticketId, temp);	
				}

			}
			if(!qtyDetails.isEmpty()){
				HashMap<String, String> temp=new HashMap<String, String>();
				temp.put("criteria", TICKET_LEVEL_QTY_CRITERIA_MSG);
				qtyDetails.put("criteria", temp);
			}
				
		}catch(Exception e){
			System.out.println("exception in regular method is: "+e.getMessage());
		}

		return qtyDetails;
	}
	
	public HashMap<String,HashMap<String,String>> getRecurringEventTicketsAvailibility(String eventid,String eventdate,String tid,JSONArray ticketsQtyArray,HashMap<String,HashMap<String, String>> eventTickets){
		HashMap<String,HashMap<String,String>> qtyDetails=new HashMap<String,HashMap<String,String>>();
		HashMap<String,String> remainingCountMap=new HashMap<String,String>();
		try{
			StatusObj price_sb=null,rec_sb=null,locked_sb=null;
			DBManager Db=new DBManager();

			/****strt eventlevelcheck****/

			int sel_qty=0;
			try{	 
				for(int i=0;i<ticketsQtyArray.length();i++){					
					JSONObject eachTicket=ticketsQtyArray.getJSONObject(i);
					HashMap<String, String> ticketDetails=eventTickets.get(eachTicket.get("ticket_id"));
					if("Yes".equalsIgnoreCase(ticketDetails.get("isdonation"))||"yes".equalsIgnoreCase(ticketDetails.get("isdonation"))||"y".equalsIgnoreCase(ticketDetails.get("isdonation"))){
						//sel_qty=sel_qty+1;
					}else
						sel_qty=sel_qty+Integer.parseInt(ticketsQtyArray.getJSONObject(i).getString("qty"));
				}				
			}catch(Exception e){System.out.println("error qty cal::"+tid);sel_qty=0;}

			qtyDetails=eventLevelCheck(eventid, tid,eventdate,sel_qty+"");
			if(!qtyDetails.isEmpty()){//event level quantity  criteria has reached
				HashMap<String, String> temp=new HashMap<String, String>();
				temp.put("criteria", EVENT_LEVEL_QTY_CRITERIA_MSG);
				qtyDetails.put("criteria", temp);
				return qtyDetails;
			}
			/****end eventlevel check****/


			String price_qry="select price_id,max_ticket,min_qty,max_qty from price where evt_id=CAST(? AS BIGINT)";
			price_sb=Db.executeSelectQuery(price_qry,new String[]{eventid});
			String rec_sold_qty_qry="select ticketid,soldqty from reccurringevent_ticketdetails where eventid=CAST(? AS BIGINT) and eventdate=?";

			String locked_qry="select sum(locked_qty) as locked_qty,ticketid from event_reg_locked_tickets where eventid=? and eventdate=? group by ticketid";

			if(price_sb.getStatus()&&price_sb.getCount()>0){
				for(int i=0;i<price_sb.getCount();i++){
					remainingCountMap.put("p_"+Db.getValue(i,"price_id",""),Db.getValue(i,"max_ticket",""));
					remainingCountMap.put("min_"+Db.getValue(i,"price_id",""),Db.getValue(i,"min_qty","0"));
					remainingCountMap.put("max_"+Db.getValue(i,"price_id",""),Db.getValue(i,"max_qty","0"));
				}
			}
			rec_sb=Db.executeSelectQuery(rec_sold_qty_qry,new String[]{eventid,eventdate});
			if(rec_sb.getStatus()&&rec_sb.getCount()>0){
				for(int i=0;i<rec_sb.getCount();i++){
					remainingCountMap.put("r_"+Db.getValue(i,"ticketid",""),Db.getValue(i,"soldqty",""));
				}
			}
			if(!"".equals(tid)){
				locked_qry="select sum(locked_qty) as locked_qty,ticketid from event_reg_locked_tickets where eventid=? and eventdate=? and tid!=? group by ticketid";
				locked_sb=Db.executeSelectQuery(locked_qry,new String[]{eventid,eventdate,tid});
			}
			else{
				locked_sb=Db.executeSelectQuery(locked_qry,new String[]{eventid,eventdate});
			}

			if(locked_sb.getStatus()&&locked_sb.getCount()>0){

				for(int i=0;i<locked_sb.getCount();i++){
					remainingCountMap.put("l_"+Db.getValue(i,"ticketid",""),Db.getValue(i,"locked_qty",""));
				}
			}


			for(int i=0;i<ticketsQtyArray.length();i++){
				JSONObject eachTicketQtyJSON=ticketsQtyArray.getJSONObject(i);
				String ticketId=eachTicketQtyJSON.getString("ticket_id");
				String ticket_name=eachTicketQtyJSON.getString("ticket_name");
				int qty=0;
				if(eachTicketQtyJSON.has("qty"))
					qty=Integer.parseInt(eachTicketQtyJSON.getString("qty"));
				int l_qty=0,p_qty=0,r_qty=0;
				int minqty=0;
				int maxqty=0;
				
				try{
					if(remainingCountMap.get("p_"+ticketId)!=null)
						p_qty=Integer.parseInt((String)remainingCountMap.get("p_"+ticketId));
				}catch(Exception e){}
				try{
					if(remainingCountMap.get("l_"+ticketId)!=null)
						l_qty=Integer.parseInt((String)remainingCountMap.get("l_"+ticketId));
				}catch(Exception e){}
				try{
					if(remainingCountMap.get("r_"+ticketId)!=null)
						r_qty=Integer.parseInt((String)remainingCountMap.get("r_"+ticketId));
				}catch(Exception e){System.out.println("exception is"+e.getMessage());}
				
				try{
					if(remainingCountMap.get("min_"+ticketId)!=null)
						minqty = Integer.parseInt((String)remainingCountMap.get("min_"+ticketId));
				}catch(Exception e){minqty=0;}
				try{
					if(remainingCountMap.get("max_"+ticketId)!=null)
						maxqty = Integer.parseInt((String)remainingCountMap.get("max_"+ticketId));
				}catch(Exception e){maxqty=0;}
				
				
				int remainingQty=p_qty-l_qty-r_qty;
				if(qty>remainingQty || qty<minqty || qty>maxqty){
					HashMap<String, String> temp=new HashMap<String, String>();
					temp.put("ticket_id",ticketId+"");
					temp.put("selected_qty",qty+"");
					temp.put("remaining_qty",remainingQty+"");
					temp.put("ticket_name", ticket_name);
					qtyDetails.put(ticketId, temp);	
				}

			}
			
			if(!qtyDetails.isEmpty()){
				HashMap<String, String> temp=new HashMap<String, String>();
				temp.put("criteria", TICKET_LEVEL_QTY_CRITERIA_MSG);
				qtyDetails.put("criteria", temp);
			}
		}catch(Exception e){
		}

		return qtyDetails;
	}

	public ArrayList<HashMap<String, Integer>> getWaitListHoldQty(String eid, String eventdate,String waitListID) {
		ArrayList<HashMap<String, Integer>> returnMap=new  ArrayList<HashMap<String, Integer>>();
		HashMap<String, Integer> totalHoldTickets = new HashMap<String, Integer>();
		HashMap<String, Integer> allWids = new HashMap<String, Integer>();
		DBManager dbManager=new DBManager();
		StatusObj statusObj=null;
		int totalQty=0;
		if(eventdate==null || "".equals(eventdate))
			statusObj=dbManager.executeSelectQuery("select a.wait_list_id, a.ticket_qty,a.ticketid from wait_list_tickets a, wait_list_transactions b where  a.wait_list_id= b.wait_list_id and  b.status in('In Process','Waiting')  and a.eventid=cast(? as integer)", new String[]{eid});
		else
			statusObj=dbManager.executeSelectQuery("select a.wait_list_id, a.ticket_qty,a.ticketid from wait_list_tickets a, wait_list_transactions b where  a.wait_list_id= b.wait_list_id and  b.status in('In Process','Waiting')  and b.eventid=cast(? as integer) and b.eventdate=?", new String[]{eid,eventdate});
		for(int i=0;i<statusObj.getCount();i++){
			totalQty=totalQty+Integer.parseInt(dbManager.getValue(i, "ticket_qty", "0"));
			if(waitListID.equalsIgnoreCase(dbManager.getValue(i, "wait_list_id", "0")))
				allWids.put(dbManager.getValue(i, "wait_list_id", "0"),0);			
			if(totalHoldTickets.containsKey(dbManager.getValue(i, "ticketid", "")))
				totalHoldTickets.put(dbManager.getValue(i, "ticketid", ""), totalHoldTickets.get(dbManager.getValue(i, "ticketid", ""))+Integer.parseInt(dbManager.getValue(i, "ticket_qty", "0")));			
			else
				totalHoldTickets.put(dbManager.getValue(i, "ticketid", ""), Integer.parseInt(dbManager.getValue(i, "ticket_qty", "0")));
		}	
		totalHoldTickets.put("all_tickets_qty", totalQty);
		returnMap.add(allWids);
		returnMap.add(totalHoldTickets);
	
		System.out.println("returnMap:"+returnMap);

		return returnMap;
	}
	
	public	HashMap<String,HashMap<String, String>> getTicketDetails(String eid){
		HashMap<String,HashMap<String, String>> ticketsMap=new HashMap<String,HashMap<String, String>>();
		DBManager db=new DBManager();
		StatusObj sb=db.executeSelectQuery(GET_TICKETS_QUERY,new String[]{eid});
		if(sb.getStatus()){
			for(int i=0;i<sb.getCount();i++){
				HashMap<String,String> priceMap=new HashMap<String,String>();
				priceMap.put("ticketname",db.getValue(i,"ticket_name",""));
				priceMap.put("groupname",db.getValue(i,"groupname",""));
				priceMap.put("ticket_groupid",db.getValue(i,"ticket_groupid",""));
				priceMap.put("price_id",db.getValue(i,"price_id",""));
				String ntscommission=db.getValue(i,"networkcommission","0.00");
				ntscommission=ntscommission==null?"0.00":ntscommission;
				if(Double.parseDouble(ntscommission)<0)
					ntscommission="0";
				priceMap.put("nts_commission",ntscommission);
				ticketsMap.put(db.getValue(i,"price_id",""),priceMap);
			}
		}

		return ticketsMap;
	}
	public HashMap<String,String> doRegformAction(HashMap<String, String> paramsData,CRegistrationTiketingManager regManager,CDiscountManager discountManager, HashMap<String,HashMap<String, String>> eventTickets){
		HashMap<String, String> returnParams=new HashMap<String, String>();
		System.out.println("in registration form action");

		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "CCheckTicketStatus.java", "Registration Strated for the event :- "+paramsData.get("eid")+" & transactionid :- "+paramsData.get("tid"), "", null);
		
		
		
		DbUtil.executeUpdateQuery("delete from event_reg_locked_tickets where eventid=? and tid=?",new String[]{paramsData.get("eid"),paramsData.get("tid")});
		DbUtil.executeUpdateQuery("delete from event_reg_block_seats_temp where eventid=? and transactionid=?", new String[]{paramsData.get("eid"),paramsData.get("tid")});
		DbUtil.executeUpdateQuery("delete from event_reg_ticket_details_temp where tid=?",new String[]{paramsData.get("tid")});

		//String processFee=DbUtil.getVal("select current_fee from eventinfo where eventid=?::integer", new String[]{paramsData.get("eid")});
		
		HashMap<String, HashMap<String, String>> ticketIDsWithGroupNames=getTicketDetails(paramsData.get("eid"));
		
		try{
				JSONArray ticketsQtyArray=new JSONArray(paramsData.get("selected_tickets"));
				
				for(int i=0;i<ticketsQtyArray.length();i++){					
					JSONObject eachTicketQtyJSON=ticketsQtyArray.getJSONObject(i);
					String ticketId=eachTicketQtyJSON.getString("ticket_id");			
					
					HashMap<String, String> ticketDetails=eventTickets.get(ticketId);
					HashMap<String, String> paramsSet=new HashMap<String,String>();
					
					if("yes".equalsIgnoreCase(ticketDetails.get("isdonation"))||"y".equalsIgnoreCase(ticketDetails.get("isdonation"))){
						paramsSet.put("qty", "1");
						paramsSet.put("originalPrice", eachTicketQtyJSON.getString("amount"));
						paramsSet.put("finalPrice", eachTicketQtyJSON.getString("amount"));
					
					}else{
						String qty=eachTicketQtyJSON.getString("qty");
						paramsSet.put("qty", qty);
						paramsSet.put("originalPrice", ticketDetails.get("price"));
						paramsSet.put("finalPrice", ticketDetails.get("final_price"));
					}
					if(Double.parseDouble(ticketDetails.get("final_price"))==0){
						paramsSet.put("originalFee", "0");
						paramsSet.put("finalFee","0");
					}else{
						paramsSet.put("originalFee", ticketDetails.get("process_fee"));
						paramsSet.put("finalFee",ticketDetails.get("process_fee"));
					}
					paramsSet.put("nts_enable",paramsData.get("nts_enable"));
					paramsSet.put("nts_commission","0");
					paramsSet.put("referral_ntscode",paramsData.get("referral_ntscode"));
					paramsSet.put("ticketid",ticketId);
					paramsSet.put("ticketName",ticketDetails.get("ticket_name"));
					
					paramsSet.put("ticketGroupId",ticketIDsWithGroupNames.get(ticketId).get("ticket_groupid"));
					paramsSet.put("groupname",ticketIDsWithGroupNames.get(ticketId).get("groupname"));
					paramsSet.put("ticket_nts_commission",ticketIDsWithGroupNames.get(ticketId).get("nts_commission"));
					if("Yes"==ticketDetails.get("isdonation"))
						paramsSet.put("ticketType","donationType");
					else
						paramsSet.put("ticketType","attendeeType");
					paramsSet.put("discount",ticketDetails.get("discount"));
					try{
						paramsSet.put("seat_index", eachTicketQtyJSON.getString("seat_ids"));
					}catch(Exception e){
						paramsSet.put("seat_index", "[]");
					}
				paramsSet.put("eventdate",paramsData.get("eventdate"));
				System.out.println("InsertTicketDetailsToDb in CCheckTicketStatus.java");
				
				regManager.InsertTicketDetailsToDb(paramsSet,paramsData.get("tid"),paramsData.get("eid"));	
				}	
			
				regManager.setTransactionAmounts(paramsData.get("eid"), paramsData.get("tid"));
			
				HashMap<String,String> amounts=regManager.getRegTotalAmounts(paramsData.get("tid"));
				
				DbUtil.executeUpdateQuery("update event_reg_details_temp set discountcode=? where tid=?",new String[]{paramsData.get("discountcode"),paramsData.get("tid")});
				if(paramsData.get("discountcode")!=null && !"".equals(paramsData.get("discountcode")))
				{ 	
				    HashMap<String, String> discAppliedDetMap=discountManager.isDiscountApplied(paramsData.get("discountcode"), paramsData.get("eid"));
					String discFlag=(String)discAppliedDetMap.get("disc_applied_flag");
					String discountMsg=(String)discAppliedDetMap.get("message");
					String remainingCount = (String)discAppliedDetMap.get("remainingCount");
					
					if("false".equals(discFlag)){
						DbUtil.executeUpdateQuery("delete from event_reg_locked_tickets where tid=? ",new String[]{paramsData.get("tid")});
						returnParams.put("status", "fail");
						returnParams.put("reason", discountMsg);
						return returnParams;
					}else{
						returnParams.put("discountStatus","success");
						returnParams.put("discountMsg", discountMsg);
						returnParams.put("remainingCount", remainingCount);
					}
				}
				
				returnParams.put("tid",paramsData.get("tid"));
				returnParams.put("disc_amount",amounts.get("disamount"));
				returnParams.put("tickets_cost",amounts.get("netamount"));
				returnParams.put("tax",amounts.get("tax"));
				returnParams.put("total_amount",amounts.get("grandtotamount"));
				//returnParams.put("ntscode",ntscode);
				//returnParams.put("display_ntscode",display_ntscode);
							
				
			}
			catch (Exception e) {
				// TODO: handle exception
				System.out.println("Exception In CCheckTicketStatus.java Error :- " + e.getMessage());
			}	
				
		return returnParams;
	}
	
	private   HashMap<String, HashMap<String, String>>  getGroupDetailsOfTickets(String eid){
		HashMap<String, HashMap<String, String>> returnMap=new HashMap<String, HashMap<String, String>>();
		String query="select a.ticket_groupid,a.groupname,b.price_id from event_ticket_groups a, group_tickets b where eventid=? and b.ticket_groupid=a.ticket_groupid";
		DBManager dbManager=new DBManager();
		StatusObj statusObj=dbManager.executeSelectQuery(query, new String[]{eid});
		if(statusObj.getStatus()){		
			HashMap<String, String> tempMap=null;
			for(int i=0;i<statusObj.getCount();i++){
				tempMap=new HashMap<String, String>();
				tempMap.put("group_id", dbManager.getValue(i, "ticket_groupid", ""));
				tempMap.put("group_name", dbManager.getValue(i, "groupname", ""));
				returnMap.put(dbManager.getValue(i, "price_id", ""), tempMap);				
			}
		}		
		return returnMap;
		
	}
	
	public boolean getSeatChecking(String seatingId, String eid, String edate, String tid, JSONArray selectedDetails,String check){
		System.out.println("check seats available.");
		boolean result = true;
		String seating_temp = "";
		String booked_seats = "";
		String forQueryString = "";
		StatusObj booked_status=null;
		StatusObj temp_status=null;
		DBManager db=new DBManager();
		DBManager dbt=new DBManager();
		JSONArray allIds = new JSONArray();
		try{
			//selectedDetails = [{"ticket_id":"71350","seat_ids":["1740_13_6","1740_13_7"],"qty":2},{"ticket_id":"71351","seat_ids":["1740_17_17","1740_17_18"],"qty":2}]
			for (int i =0; i<selectedDetails.length(); i++){
				JSONObject eachTicket=selectedDetails.getJSONObject(i);
				String eachSeat = eachTicket.getString("seat_ids");
				JSONArray eachSeatArray = new JSONArray(eachSeat);
				for(int k=0; k<eachSeatArray.length();k++){
					allIds.put(eachSeatArray.get(k));
				}
			}
			//allIds = ["1740_13_6","1740_13_7","1740_17_17","1740_17_18"]
			forQueryString  = allIds.toString();
			forQueryString = forQueryString.replace("[", "").replace("]", "");
			forQueryString = forQueryString.replace('"','\'');
			
		}catch(Exception e){
			System.out.println("Exception at CCheckTicketStatus.java "+e.getMessage());
		}
		
		String dd = "select * from event_reg_block_seats_temp where eventid=? and transactionid!=? and seatindex in ("+forQueryString+")";
		if(!"".equals(selectedDetails) || selectedDetails!=null){
			if(!"".equals(tid)){
				seating_temp="select * from event_reg_block_seats_temp where eventid=? and transactionid!=? and seatindex in ("+forQueryString+")";
				booked_seats="select * from seat_booking_status where eventid=cast(? as numeric)  and tid!=? and seatindex in ("+forQueryString+")";
			}else{
				seating_temp="select * from event_reg_block_seats_temp where eventid=? and seatindex in ("+forQueryString+")";
				booked_seats="select * from seat_booking_status where eventid=cast(? as numeric)  and seatindex in ("+forQueryString+")";
			}
			
			if(!"".equals(edate)||!" ".equals(edate)){
				if(!"".equals(tid)){
					seating_temp="select * from event_reg_block_seats_temp where eventid=? and transactionid!=? and eventdate=? and seatindex in ("+forQueryString+")";
					booked_seats="select * from seat_booking_status where eventid=cast(? as numeric)  and tid!=? and eventdate=? and seatindex in ("+forQueryString+")";
					booked_status=db.executeSelectQuery(booked_seats,new String[]{eid,tid,edate});
					temp_status=dbt.executeSelectQuery(seating_temp,new String[]{eid,tid,edate});
				}else{
					seating_temp="select * from event_reg_block_seats_temp where eventid=? and eventdate=? and seatindex in ("+forQueryString+")";
					booked_seats="select * from seat_booking_status where eventid=cast(? as numeric) and eventdate=? and seatindex in ("+forQueryString+")";
					booked_status=db.executeSelectQuery(booked_seats,new String[]{eid,edate});
					temp_status=dbt.executeSelectQuery(seating_temp,new String[]{eid,edate});
			
				}
			}else{
				if(!"".equals(tid)){
					booked_status=db.executeSelectQuery(booked_seats,new String[]{eid,tid});
					temp_status=dbt.executeSelectQuery(seating_temp,new String[]{eid,tid});
				}else{
					booked_status=db.executeSelectQuery(booked_seats,new String[]{eid});
					temp_status=dbt.executeSelectQuery(seating_temp,new String[]{eid});
				}
			}
			if(temp_status.getStatus() || booked_status.getStatus()){
				result = false;
			}else{
				result = true;
			}
		}else
			result = true;
		
		// level2 : this case from profile submit (profile submit 'check' is level2, ticket submit 'check' is empty)
		if("level2".equals(check)){
			System.out.println("in profile page submit");
			boolean break_flag=true;
			HashMap timeseat= new HashMap();
			try{
				DBManager dbm=new DBManager();
				StatusObj booked_statusinner=null;
				String timequery="";
				if(!"".equals(edate)||!" ".equals(edate)){
					timequery="select seatindex from event_reg_block_seats_temp where transactionid not in(?) and blocked_at<(select  blocked_at from  event_reg_block_seats_temp where transactionid=? order by blocked_at desc limit 1) and eventid=? and eventdate=?";
				    booked_statusinner=dbm.executeSelectQuery(timequery,new String[]{tid.trim(),tid.trim(),eid,edate});
				}else{
					timequery="select seatindex from event_reg_block_seats_temp where transactionid not in(?) and blocked_at<(select  blocked_at from  event_reg_block_seats_temp where transactionid =? order by blocked_at desc limit 1) and eventid=?";
					booked_statusinner=dbm.executeSelectQuery(timequery,new String[]{tid.trim(),tid.trim(),eid});
				}
				System.out.println("satatus: "+booked_statusinner.getStatus()+" checseatinnercount "+booked_statusinner.getCount());
				if(booked_statusinner.getStatus()){
					for(int i=0;i<booked_statusinner.getCount();i++){
						timeseat.put(dbm.getValue(i,"seatindex",""),"yes");
					}
				}
				if(booked_status.getCount()==0){
					for(int j=0;j<allIds.length() && break_flag;j++){
						String seatindex=allIds.getString(j);
						if(timeseat.containsKey(seatindex)){
							result = false;
							String	res=DbUtil.getVal("select array_agg( 'eventid='||eventid ||' ticketid='||ticketid||' tid='||transactionid||' seatindex='||seatindex||' eventdate='||eventdate||' time='||blocked_at ) ::text"+
									  " as response  from event_reg_block_seats_temp  where eventid=? and transactionid=?", new String[]{eid,tid});
							System.out.println("seat on hold profile level"+res);
							DbUtil.executeUpdateQuery("delete from event_reg_block_seats_temp where transactionid=? ",new String[]{tid});
							DbUtil.executeUpdateQuery("delete from event_reg_locked_tickets where tid=?",new String[]{tid});
							break_flag=false;
						}
					}
					if(!break_flag)
						result = false;
					else
						result = true;
					
				}else
					result = false;
				
			}catch(Exception e){
				result = true;
				System.out.println("Exception CCheckTicketStatus.java when profile submit "+e.getMessage());
			}
		}
		return result;
	}
}
