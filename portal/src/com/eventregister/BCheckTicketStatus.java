package com.eventregister;

import java.util.HashMap;
import org.json.JSONArray;
import org.json.JSONObject;
import com.eventbee.general.DBManager;
import com.eventbee.general.DbUtil;
import com.eventbee.general.EventbeeLogger;
import com.eventbee.general.StatusObj;

public class BCheckTicketStatus {
	public static String TICKET_LEVEL_QTY_CRITERIA_MSG= "ticket-level-qty-criteria";
	public static String EVENT_LEVEL_QTY_CRITERIA_MSG= "event-level-qty-criteria";
	String GET_TICKETS_QUERY="select groupname,ticket_groupid,price_id,ticket_name,networkcommission from tickets_details_view where eventid=?";

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
	public HashMap<String,HashMap<String,String>> getNONRecurringEventTicketsAvailibility(String eid,String tid,JSONArray ticketsQtyArray,HashMap<String,HashMap<String, String>> eventTickets){
		HashMap<String,HashMap<String,String>> qtyDetails=new HashMap<String,HashMap<String,String>>();
		HashMap<String,String> remainingCountMap=new HashMap<String,String>();
		try{			

			DBManager db=new DBManager();
			StatusObj sb=null;

			///event level check
			int sel_qty=0;
			try{	 
				for(int i=0;i<ticketsQtyArray.length();i++){
					JSONObject eachTicket=ticketsQtyArray.getJSONObject(i);
					HashMap<String, String> ticketDetails=eventTickets.get(eachTicket.get("ticket_id"));
					if("yes".equalsIgnoreCase(ticketDetails.get("isdonation"))||"y".equalsIgnoreCase(ticketDetails.get("isdonation"))){
						//sel_qty=sel_qty+1;
					}else
						sel_qty=sel_qty+Integer.parseInt(ticketsQtyArray.getJSONObject(i).getString("qty"));
				}				
			}catch(Exception e){System.out.println("error qty cal::"+tid);sel_qty=0;}	

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
					remainingCountMap.put(db.getValue(i,"ticketid",""),db.getValue(i,"remaining_qty",""));
				}
			}


			for(int i=0;i<ticketsQtyArray.length();i++){
				JSONObject eachTicketQtyJSON=ticketsQtyArray.getJSONObject(i);
				String ticketId=eachTicketQtyJSON.getString("ticket_id");

				int qty=Integer.parseInt(eachTicketQtyJSON.getString("qty"));
				int remainingQty=Integer.parseInt((String)remainingCountMap.get(ticketId));

				if(qty>remainingQty){
					HashMap<String, String> temp=new HashMap<String, String>();
					temp.put("ticket_id",ticketId+"");
					temp.put("selected_qty",qty+"");
					temp.put("remaining_qty",remainingQty+"");
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
					if("yes".equalsIgnoreCase(ticketDetails.get("isdonation"))||"y".equalsIgnoreCase(ticketDetails.get("isdonation"))){
						sel_qty=sel_qty+1;
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


			String price_qry="select price_id,max_ticket from price where evt_id=CAST(? AS BIGINT)";
			price_sb=Db.executeSelectQuery(price_qry,new String[]{eventid});
			String rec_sold_qty_qry="select ticketid,soldqty from reccurringevent_ticketdetails where eventid=CAST(? AS BIGINT) and eventdate=?";

			String locked_qry="select sum(locked_qty) as locked_qty,ticketid from event_reg_locked_tickets where eventid=? and eventdate=? group by ticketid";

			if(price_sb.getStatus()&&price_sb.getCount()>0){
				for(int i=0;i<price_sb.getCount();i++){
					remainingCountMap.put("p_"+Db.getValue(i,"price_id",""),Db.getValue(i,"max_ticket",""));
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

				int qty=Integer.parseInt(eachTicketQtyJSON.getString("qty"));
				int l_qty=0,p_qty=0,r_qty=0;
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
				int remainingQty=p_qty-l_qty-r_qty;
				if(qty>remainingQty){
					HashMap<String, String> temp=new HashMap<String, String>();
					temp.put("ticket_id",ticketId+"");
					temp.put("selected_qty",qty+"");
					temp.put("remaining_qty",remainingQty+"");
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

/*	private HashMap<String, String> getProcessFees(String eventId){
		String query="select * from eventinfo where eventid=?";
		
		
	}*/
	
	
	public HashMap<String,String> doRegformAction(HashMap<String, String> paramsData,BRegistrationTiketingManager regManager,BDiscountManager discountManager, HashMap<String,HashMap<String, String>> eventTickets){
		HashMap<String, String> returnParams=new HashMap<String, String>();
		System.out.println("in registration form action");
		String trackQuery="insert into querystring_temp (tid,useragent,created_at,querystring,jsp ) values(?,?,now(),?,?)";
		DbUtil.executeUpdateQuery(trackQuery,new String[]{paramsData.get("tid"),paramsData.get("user_agent"),paramsData.get("json")+"","regformaction"});
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "Regformaction.jsp", "Registration Strated for the  event---"+paramsData.get("eid")+" and transactionid is"+paramsData.get("tid"), "", null);

		//String ticketids=request.getParameter("ticketids");

		//EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "Regformaction.jsp", "ticketids---"+ticketids, "", null);

		DbUtil.executeUpdateQuery("delete from event_reg_locked_tickets where eventid=? and tid=?",new String[]{paramsData.get("eid"),paramsData.get("tid")});
		DbUtil.executeUpdateQuery("delete from event_reg_block_seats_temp where eventid=? and transactionid=?", new String[]{paramsData.get("eid"),paramsData.get("tid")});
		DbUtil.executeUpdateQuery("delete from event_reg_ticket_details_temp where tid=?",new String[]{paramsData.get("tid")});

		
		//String processFee=DbUtil.getVal("select current_fee from eventinfo where eventid=?::integer", new String[]{paramsData.get("eid")});
		
		HashMap<String, HashMap<String, String>> ticketIDsWithGroupNames=getGroupDetailsOfTickets(paramsData.get("eid"));
		
		try{
				JSONArray ticketsQtyArray=new JSONArray(paramsData.get("json"));
				
				
				for(int i=0;i<ticketsQtyArray.length();i++){					
					JSONObject eachTicketQtyJSON=ticketsQtyArray.getJSONObject(i);
					String ticketId=eachTicketQtyJSON.getString("ticket_id");			
					
					HashMap<String, String> ticketDetails=eventTickets.get(ticketId);
					HashMap<String, String> paramsSet=new HashMap<String,String>();
				
					
					if("yes".equalsIgnoreCase(ticketDetails.get("isdonation"))||"y".equalsIgnoreCase(ticketDetails.get("isdonation"))){
					
						paramsSet.put("qty", "1");
						paramsSet.put("original_price", eachTicketQtyJSON.getString("amount"));
						paramsSet.put("final_price", eachTicketQtyJSON.getString("amount"));
					
					}
					else{
						String qty=eachTicketQtyJSON.getString("qty");
						paramsSet.put("qty", qty);
						paramsSet.put("original_price", ticketDetails.get("price"));
						paramsSet.put("final_price", ticketDetails.get("final_price"));
					}
					if(Double.parseDouble(ticketDetails.get("final_price"))==0){
						paramsSet.put("original_fee", "0");
						paramsSet.put("final_fee","0");
					}else{
						paramsSet.put("original_fee", ticketDetails.get("process_fee"));
						paramsSet.put("final_fee",ticketDetails.get("process_fee"));
					}
					paramsSet.put("ticketid",ticketId);
					paramsSet.put("ticket_groupid",ticketIDsWithGroupNames.get(ticketId).get("group_id"));
					paramsSet.put("ticket_name",ticketDetails.get("ticket_name"));
					paramsSet.put("group_name",ticketIDsWithGroupNames.get(ticketId).get("group_name"));
			
					paramsSet.put("ticket_type",ticketDetails.get("isdonation"));
					paramsSet.put("discount",ticketDetails.get("discount"));
					try{
						paramsSet.put("seat_ids", eachTicketQtyJSON.getString("seat_ids"));
					}catch(Exception e){
						paramsSet.put("seat_ids", "[]");
					}
				
					regManager.InsertTicketDetailsToDb(paramsSet,paramsData.get("tid"),paramsData.get("eid"),paramsData.get("edate"));					
				}	
			
				regManager.setTransactionAmounts(paramsData.get("eid"), paramsData.get("tid"));
			
				HashMap<String,String> amounts=regManager.getRegTotalAmounts(paramsData.get("tid"));
				
				
				DbUtil.executeUpdateQuery("update event_reg_details_temp set discountcode=? where tid=?",new String[]{paramsData.get("disc_code"),paramsData.get("tid")});
				
				if(paramsData.get("disc_code")!=null && !"".equals(paramsData.get("disc_code")))
				{ 							
				    HashMap<String, String> discAppliedDetMap=discountManager.isDiscountApplied(paramsData.get("disc_code"), paramsData.get("eid"));
					String discFlag=(String)discAppliedDetMap.get("disc_applied_flag");
					String discountMsg=(String)discAppliedDetMap.get("message");					
					if("false".equals(discFlag)){
						DbUtil.executeUpdateQuery("delete from event_reg_locked_tickets where tid=? ",new String[]{paramsData.get("tid")});
						returnParams.put("status", "fail");
						returnParams.put("reason", discountMsg);
						return returnParams;
					}
			/*V**	else{
						returnParams.put("status", "success");
					}*/

				}
	    /*V*     else{
					returnParams.put("status", "success");
				}*/
				returnParams.put("tid",paramsData.get("tid"));
		////returnParams.put("total_amount",amounts.get("totamount"));
				returnParams.put("disc_amount",amounts.get("disamount"));
				returnParams.put("tickets_cost",amounts.get("netamount"));
				returnParams.put("tax",amounts.get("tax"));
				returnParams.put("total_amount",amounts.get("grandtotamount"));					
				
			}
			catch (Exception e) {
				// TODO: handle exception
				System.out.println("error in  doing regform action");
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
}
