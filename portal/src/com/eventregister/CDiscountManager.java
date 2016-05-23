package com.eventregister;

import java.util.ArrayList;
import java.util.HashMap;

import com.eventbee.general.DBManager;
import com.eventbee.general.DbUtil;
import com.eventbee.general.StatusObj;
import com.eventbee.general.formatting.CurrencyFormat;

public class CDiscountManager {
	
	ArrayList<String> getDiscountPriceIds(String eid,String discountcode){
		String query="select price_id from coupon_ticket  where couponid in(select couponid from coupon_master where couponid in (select couponid from coupon_codes where couponcode=?) and groupid=?)";
		ArrayList<String> priceIdsList=new ArrayList<String>();
		DBManager db=new DBManager();
		StatusObj sb=db.executeSelectQuery(query,new String []{discountcode,eid});
		if(sb.getStatus()){
			for(int i=0;i<sb.getCount();i++){
				priceIdsList.add(db.getValue(i,"price_id",""));
			} 
		}
		return priceIdsList;
	}
	
	public 	HashMap<String,String> getDiscountDetails(String code,String groupid){
		String query="select discount,discounttype from coupon_master where couponid in (select couponid from coupon_codes where couponcode=?) and groupid=?";
		HashMap<String,String> discountsMap=new HashMap<String,String>();
		DBManager db=new DBManager();
		try{
			StatusObj sb=db.executeSelectQuery(query,new String[]{code,groupid});
			if(sb.getStatus()){
				discountsMap.put("discounttype",db.getValue(0,"discounttype",""));
				discountsMap.put("discount",db.getValue(0,"discount",""));

			}
		}catch (Exception e) {
			// TODO: handle exception
		}
		return discountsMap;
	}
	
	public HashMap<String,HashMap<String, String>> getTickets(String discountcode, String eventid,String discount,String discounttype){
		double afterDiscount=0;
		double discountamount=0;
		String query="select price_id,ticket_type,ticket_name,process_fee,ticket_price,isdonation from price where evt_id=cast(? as numeric) ";
		ArrayList<String> Discountpriceids=getDiscountPriceIds(eventid,discountcode);
		HashMap<String,HashMap<String, String>> ticketList=new HashMap<String,HashMap<String, String>>();
		DBManager db=new DBManager();
		StatusObj sb=db.executeSelectQuery(query,new String []{eventid});
		if(sb.getStatus() && sb.getCount()>0){
			for(int i=0;i<sb.getCount();i++)
			{
				HashMap<String,String>  hm=new HashMap<String,String>();
				String price=db.getValue(i,"ticket_price","");
				String finalprice=price;
				String processFee=db.getValue(i,"process_fee","");
				String ticketid=db.getValue(i,"price_id","");
				if(Discountpriceids.contains(ticketid)){
					if("PERCENTAGE".equals(discounttype))
						discountamount=Double.parseDouble(price)*Double.parseDouble(discount)/100;
					else
						discountamount=Double.parseDouble(discount);
					System.out.println("amount"+discountamount);
					afterDiscount=Double.parseDouble(price)-discountamount;
					if(afterDiscount<0){
						afterDiscount=0.00;
						discountamount=Double.parseDouble(price);
					}
					finalprice=Double.toString(afterDiscount);
					hm.put("disc_applied","yes");
				}
				else {
					hm.put("disc_applied","no");
					discountamount=0;
				}
				hm.put("ticketid",db.getValue(i,"price_id",""));
				hm.put("ticket_name",db.getValue(i,"ticket_name",""));
				hm.put("price",CurrencyFormat.getCurrencyFormat("",price,true));
				hm.put("discount",CurrencyFormat.getCurrencyFormat("",discountamount+"",true));
				hm.put("final_price",CurrencyFormat.getCurrencyFormat("",finalprice+"",true));
				hm.put("isdonation",db.getValue(i,"isdonation",""));
				hm.put("process_fee",CurrencyFormat.getCurrencyFormat("",processFee,true));
				
				ticketList.put(db.getValue(i,"price_id",""), hm);
				
				
			}
		}
		return ticketList;
	}
	
	public HashMap<String,HashMap<String, String>> getTicketsPrices(String eventid){
		HashMap<String,HashMap<String, String>> ticketsWithPrices=new  HashMap<String,HashMap<String, String>>();   
	
		String query="select price_id,ticket_type,ticket_name,ticket_price,process_fee,isdonation from price where evt_id=cast(? as numeric) ";
		DBManager db=new DBManager();
		StatusObj sb=db.executeSelectQuery(query,new String []{eventid});
		if(sb.getStatus() && sb.getCount()>0){
			for(int i=0;i<sb.getCount();i++)
			{
				HashMap<String,String>  hm=new HashMap<String,String>();
				String price=db.getValue(i,"ticket_price","");			
				String ticketid=db.getValue(i,"price_id","");	
				String processFee=db.getValue(i,"process_fee","");
				hm.put("ticket_name",db.getValue(i,"ticket_name",""));
				hm.put("ticketid",ticketid);
				hm.put("price",CurrencyFormat.getCurrencyFormat("",price,true));
				hm.put("final_price",CurrencyFormat.getCurrencyFormat("",price+"",true));
				hm.put("isdonation",db.getValue(i,"isdonation",""));
				hm.put("process_fee",CurrencyFormat.getCurrencyFormat("",processFee,true));
				
				ticketsWithPrices.put(db.getValue(i,"price_id",""), hm);
			}
		}	
		return ticketsWithPrices;		
	}
	
	public HashMap<String,Object> getDiscountInfo(String discountCode, String eid,String tid){

		String  discountSuccessFlag="true";
		String discountMsg="";
		//HashMap<String,ArrayList<HashMap<String, String>>> discountInfo = new HashMap<String,ArrayList<HashMap<String, String>>>();
		HashMap<String,HashMap<String, String>> eventTickets=new HashMap<String,HashMap<String, String>>();
		String discount="0";
		String discountType="ABSOLUTE";
		int remainingCount=0;
		if(discountCode!=null){discountCode=discountCode.trim();}
		HashMap<String,String> discountsMap=getDiscountDetails(discountCode,eid);
		if(discountsMap!=null&&discountsMap.size()>0){
			discount=(String)discountsMap.get("discount");
			discountType=(String)discountsMap.get("discounttype");
			//Query...Venkat
			/*String copid=DbUtil.getVal("select a.couponid from coupon_master a,coupon_codes b where a.couponid=b.couponid and a.groupid=? and b.couponcode=?",new String[]{eid,discountCode} );
				String dicountcount=DbUtil.getVal("select maxcount from coupon_codes where  couponcode=? and couponid=? ",new String[]{discountCode,copid});
				String ecachcode_limit=DbUtil.getVal("select eachcode_limit from coupon_master where couponid=? and groupid=?",new String[]{copid,eid} );
			 *///Query...Venkat
			String query="select a.couponid,a.eachcode_limit,b.maxcount from coupon_master a,coupon_codes b where a.couponid=b.couponid and a.groupid=? and b.couponcode=?";

			DBManager dbManager=new DBManager();
			StatusObj statusObj=dbManager.executeSelectQuery(query, new String[]{eid,discountCode});
			String couponId="";
			String dicountcount="";
			String ecachcode_limit="";	
			if(statusObj.getStatus()){
				couponId=dbManager.getValue(0, "couponid", "");
				ecachcode_limit=dbManager.getValue(0, "eachcode_limit", "");
				dicountcount=dbManager.getValue(0, "maxcount", "");		
			}
			if(ecachcode_limit==null||"".equals(ecachcode_limit))ecachcode_limit="N";
			String totcurrentcouponcounthold=null;
			String couponcount="0";
			if(couponId!=null && "N".equals(ecachcode_limit)){
				couponcount=DbUtil.getVal("select sum(ticketqty) from transaction_tickets tt,event_reg_transactions et where et.tid=tt.tid and tt.eventid=? and et.discountcode in(select couponcode from coupon_codes where couponid=?) and tt.discount>0",new String[]{eid,couponId});
				totcurrentcouponcounthold=DbUtil.getVal("select sum(totticketsqty) from event_reg_details_temp where tid in(select tid from event_reg_locked_tickets where eventid=?) and discountcode in(select couponcode from coupon_codes where couponid=?) ",new String[]{eid,couponId});
			}else{ 
				couponcount=DbUtil.getVal("select sum(ticketqty) from transaction_tickets tt,event_reg_transactions et where et.tid=tt.tid and tt.eventid=? and et.discountcode=? and tt.discount>0",new String[]{eid,discountCode});
				totcurrentcouponcounthold=DbUtil.getVal("select sum(totticketsqty) from event_reg_details_temp where tid in(select tid from event_reg_locked_tickets where eventid=?) and discountcode=?",new String[]{eid,discountCode});
			}

			String nototcurrentcouponcounthold=DbUtil.getVal("select sum(case when locked_qty=0 then 1 else locked_qty end) from event_reg_locked_tickets where eventid=? and ticketid  not in(select price_id from coupon_ticket a,coupon_codes b where a.couponid=b.couponid  and couponcode=?)",new String[]{eid,discountCode});
			if(totcurrentcouponcounthold==null)totcurrentcouponcounthold="0";
			if(nototcurrentcouponcounthold==null)nototcurrentcouponcounthold="0";
			int completedDiscountsCount=0;
			int currentholddiscountCount=0;
			int availableDiscounts=0;

			try{		
				String currentcouponcount=""+(Integer.parseInt(totcurrentcouponcounthold)-Integer.parseInt(nototcurrentcouponcounthold));
				if(currentcouponcount==null||"".equals(currentcouponcount))currentcouponcount="0";
				if(couponcount==null)couponcount="0";
				if(dicountcount==null)dicountcount="0";

				System.out.println("current_hold:"+currentcouponcount+" sale_count:"+couponcount+" dicountlimitcount:"+dicountcount);
				availableDiscounts=Integer.parseInt(dicountcount);
				completedDiscountsCount=Integer.parseInt(couponcount);
				currentholddiscountCount=Integer.parseInt(currentcouponcount);

				//System.out.println("currentholddiscountCount"+currentholddiscountCount);
				//System.out.println("****end****");
				remainingCount=availableDiscounts-(completedDiscountsCount+currentholddiscountCount);
				if(remainingCount<0){remainingCount=0;}

			}
			catch(Exception e){
				completedDiscountsCount=0;
				currentholddiscountCount=0;
				System.out.println("error in discount manager"+e.getMessage());
			}
			//System.out.println("TotalCount"+(completedDiscountsCount+currentholddiscountCount));
			/**/
			if(!"".equals(tid)){
				 if(availableDiscounts<(completedDiscountsCount+currentholddiscountCount)){
					 discountSuccessFlag="false";
						discountMsg="Applied code is Unavailable";
					}else{
						eventTickets=getTickets(discountCode, eid,discount,discountType);
						if(eventTickets!=null&&eventTickets.size()>0){
							discountMsg="Applied";
						}
					}
			    }else{
			    	if(availableDiscounts<=(completedDiscountsCount+currentholddiscountCount)){
						 discountSuccessFlag="false";
							discountMsg="Applied code is Unavailable";
						}else{
							eventTickets=getTickets(discountCode, eid,discount,discountType);
							if(eventTickets!=null&&eventTickets.size()>0){
								discountMsg="Applied";

							}
						}
			     }
			
			/*	if(availableDiscounts<=(completedDiscountsCount+currentholddiscountCount)){
					discountSuccessFlag="false";
					discountMsg="Applied code is Unavailable";
				}else{
					eventTickets=getTickets(discountCode, eid,discount,discountType);
					if(eventTickets!=null&&eventTickets.size()>0){
						discountMsg="Applied";

					}
				}*/
		}else{
			discountSuccessFlag="false";
			discountMsg="Invalid Discount code";
		}
		HashMap<String, Object> returnMap=new HashMap<String, Object>();

		if("false".equals(discountSuccessFlag))	
			returnMap.put("disc_applied_flag", discountSuccessFlag);
		if("".equals(discountCode)) discountMsg="";
		returnMap.put("message", discountMsg);
		returnMap.put("remaining_count", remainingCount+"");
		returnMap.put("disc_info", eventTickets);
		return returnMap;
	}
	
	//checking whether coupon code reached maximum quantity
	public HashMap<String,String> isDiscountApplied(String discountCode, String eid){

		String  discountSuccessFlag="true";
		String discountMsg="";
		//HashMap<String,ArrayList<HashMap<String, String>>> discountInfo = new HashMap<String,ArrayList<HashMap<String, String>>>();
	
		int remainingCount=0;
		if(discountCode!=null){discountCode=discountCode.trim();}
		HashMap<String,String> discountsMap=getDiscountDetails(discountCode,eid);
		if(discountsMap!=null&&discountsMap.size()>0){//means discount code is right
				//Query...Venkat
			/*String copid=DbUtil.getVal("select a.couponid from coupon_master a,coupon_codes b where a.couponid=b.couponid and a.groupid=? and b.couponcode=?",new String[]{eid,discountCode} );
				String dicountcount=DbUtil.getVal("select maxcount from coupon_codes where  couponcode=? and couponid=? ",new String[]{discountCode,copid});
				String ecachcode_limit=DbUtil.getVal("select eachcode_limit from coupon_master where couponid=? and groupid=?",new String[]{copid,eid} );
			 *///Query...Venkat
			String query="select a.couponid,a.eachcode_limit,b.maxcount from coupon_master a,coupon_codes b where a.couponid=b.couponid and a.groupid=? and b.couponcode=?";

			DBManager dbManager=new DBManager();
			StatusObj statusObj=dbManager.executeSelectQuery(query, new String[]{eid,discountCode});
			String couponId="";
			String dicountcount="";
			String ecachcode_limit="";	
			if(statusObj.getStatus()){
				couponId=dbManager.getValue(0, "couponid", "");
				ecachcode_limit=dbManager.getValue(0, "eachcode_limit", "");
				dicountcount=dbManager.getValue(0, "maxcount", "");		
			}
			else
				if(ecachcode_limit==null||"".equals(ecachcode_limit))ecachcode_limit="N";
			String totcurrentcouponcounthold=null;
			String couponcount="0";
			if(couponId!=null && "N".equals(ecachcode_limit)){ 
				couponcount=DbUtil.getVal("select sum(ticketqty) from transaction_tickets tt,event_reg_transactions et where et.eventid=tt.eventid and et.eventid=? and et.discountcode in(select couponcode from coupon_codes where couponid=?) and tt.discount>0 and et.tid=tt.tid",new String[]{eid,couponId});
				totcurrentcouponcounthold=DbUtil.getVal("select sum(totticketsqty) from event_reg_details_temp where tid in(select tid from event_reg_locked_tickets where eventid=?) and discountcode in(select couponcode from coupon_codes where couponid=?) ",new String[]{eid,couponId});
			}else{ 
				couponcount=DbUtil.getVal("select sum(ticketqty) from transaction_tickets tt,event_reg_transactions et where et.eventid=tt.eventid and et.eventid=? and et.discountcode=? and tt.discount>0 and et.tid=tt.tid",new String[]{eid,discountCode});
				totcurrentcouponcounthold=DbUtil.getVal("select sum(totticketsqty) from event_reg_details_temp where tid in(select tid from event_reg_locked_tickets where eventid=?) and discountcode=?",new String[]{eid,discountCode});
			}

			String nototcurrentcouponcounthold=DbUtil.getVal("select sum(case when locked_qty=0 then 1 else locked_qty end) from event_reg_locked_tickets where eventid=? and ticketid  not in(select price_id from coupon_ticket a,coupon_codes b where a.couponid=b.couponid  and couponcode=?)",new String[]{eid,discountCode});
			if(totcurrentcouponcounthold==null)totcurrentcouponcounthold="0";
			if(nototcurrentcouponcounthold==null)nototcurrentcouponcounthold="0";
			int completedDiscountsCount=0;
			int currentholddiscountCount=0;
			int availableDiscounts=0;

			try{		
				String currentcouponcount=""+(Integer.parseInt(totcurrentcouponcounthold)-Integer.parseInt(nototcurrentcouponcounthold));
				if(currentcouponcount==null||"".equals(currentcouponcount))currentcouponcount="0";
				if(couponcount==null)couponcount="0";
				if(dicountcount==null)dicountcount="0";

				System.out.println("current_hold:"+currentcouponcount+" sale_count:"+couponcount+" dicountlimitcount:"+dicountcount);
				availableDiscounts=Integer.parseInt(dicountcount);
				completedDiscountsCount=Integer.parseInt(couponcount);
				currentholddiscountCount=Integer.parseInt(currentcouponcount);
				//System.out.println("****end****");
				remainingCount=availableDiscounts-(completedDiscountsCount+currentholddiscountCount);
				if(remainingCount<0){remainingCount=0;}
			}
			catch(Exception e){
				completedDiscountsCount=0;
				currentholddiscountCount=0;
				System.out.println("error in discount manager"+e.getMessage());
			}
			//System.out.println("TotalCount"+(completedDiscountsCount+currentholddiscountCount));		
				if(availableDiscounts<(completedDiscountsCount+currentholddiscountCount)){
					discountSuccessFlag="false";
					discountMsg="Applied code is Unavailable";
				}else{
					discountMsg="Applied";					
				}
		}else{
			discountSuccessFlag="false";
			discountMsg="Invalid Discount code";
		}
		HashMap<String, String> returnMap=new HashMap<String, String>();

		if("false".equals(discountSuccessFlag))	
			returnMap.put("disc_applied_flag", discountSuccessFlag);
		if("".equals(discountCode)) discountMsg="";
		returnMap.put("remainingCount", remainingCount+"");
		returnMap.put("message", discountMsg);
		System.out.println("retrunf map in checking discount appliedd::"+returnMap.toString());
		return returnMap;
	}
}
