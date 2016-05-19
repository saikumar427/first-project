package com.eventregister;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import org.json.JSONArray;
import org.json.JSONObject;

import com.event.i18n.dbmanager.ConfirmationPageDAO;
import com.eventbee.cachemanage.CacheManager;
import com.eventbee.general.DBManager;
import com.eventbee.general.DateUtil;
import com.eventbee.general.DbUtil;
import com.eventbee.general.EncodeNum;
import com.eventbee.general.GenUtil;
import com.eventbee.general.StatusObj;
import com.eventbee.general.formatting.CurrencyFormat;
import com.eventbee.layout.DBHelper;

public class RegistrationTiketingManager{

final String GET_TRANSACTION_ID_QUERY = "select nextval('seq_transactionid') as transactionid";
final String GET_PAYMENT_TYPES_QUERY="select distinct paytype,attrib_1 from payment_types where refid=? and status=? and purpose=?";
final String GET_TICKETS_QUERY="select groupname,ticket_groupid,price_id,ticket_name from tickets_info where eventid=?";
final String BUYER_BASE_INFO="select fname,lname,email,phone from buyer_base_info where transactionid=?";
final String BUYER_CUSTOM_QUESTIONS="select attribid from buyer_custom_questions where eventid=CAST(? AS BIGINT)";
final String GET_SELECTED_TICKETS="select * from event_reg_ticket_details_temp where tid=? order by transaction_at";

private String  transactionid=null;
private int selectedTicketsQty=0;
private int collectedTicketsQty=0;
public	String  createNewTransaction(String eventid,HashMap contextMap){
	try{
		transactionid=getTransactionId();
		StatusObj sb=DbUtil.executeUpdateQuery("insert into event_reg_details_temp(tid,useragent,eventid,transactiondate,trackurl,clubuserid,ticketurlcode,context,discountcode,current_action,source,waitlist_id,priority_list_id,priority_token) values(?,?,?,to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'),?,?,?,?,?,'profile page',?,?,?,?)",new String[]{transactionid,(String)contextMap.get("useragent"),eventid,DateUtil.getCurrDBFormatDate(),(String)contextMap.get("trackurl"),(String)contextMap.get("clubuserid"),(String)contextMap.get("ticketurlcode"),(String)contextMap.get("context"),(String)contextMap.get("discountcode"),(String)contextMap.get("registrationsource"),(String)contextMap.get("wid"),(String)contextMap.get("prilistid"),(String)contextMap.get("pritoken")});
		if(!"".equals((String)contextMap.get("trackurl"))&&(String)contextMap.get("trackurl")!=null)
			DbUtil.executeUpdateQuery("insert into trackURL_transaction(transactionid,trackingcode) values(?,?)",new String [] {transactionid,(String)contextMap.get("trackurl")});
		if((String)contextMap.get("eventdate")!=null&&!"".equals((String)contextMap.get("eventdate")))
			DbUtil.executeUpdateQuery("update event_reg_details_temp set eventdate=? where tid=?",new String [] {(String)contextMap.get("eventdate"),transactionid});
	    /*if("ning".equals((String)contextMap.get("context")))
	    	DbUtil.executeUpdateQuery("update event_reg_details_temp set attrib1=?,attrib2=? where tid=?",new String [] {(String)contextMap.get("oid"),(String)contextMap.get("domain"),transactionid});*/
    }
    catch(Exception e){
    	System.out.println("Exception in createNewTransaction--"+e.getMessage());	
    }
	return transactionid;
}

	public String getTransactionId(){
		String transid=DbUtil.getVal(GET_TRANSACTION_ID_QUERY,new String[]{});
		String transactionid="RK"+EncodeNum.encodeNum(transid).toUpperCase();
		return transactionid;
	}

	public void InsertTicketDetailsToDb(HashMap ticketHash,String tid,String eid){
	try{
		String eventdate=(String)ticketHash.get("eventdate");
		String qty=(String)ticketHash.get("qty");
		String price=(String)ticketHash.get("originalPrice");
		String discount=(String)ticketHash.get("discount");
		String fee=(String)ticketHash.get("originalFee");
		String finalPrice=(String)ticketHash.get("finalPrice");
		String ticketname=(String)ticketHash.get("ticketName");
		String finalprocessfee=(String)ticketHash.get("finalFee");
		String ticketGroupid=(String)ticketHash.get("ticketGroupId");
		String ticketType=(String)ticketHash.get("ticketType");
		String ticketid=(String)ticketHash.get("ticketid");
		String ticketgroupname=(String)ticketHash.get("groupname");
		/* Nts commission start*/
		String nts_enable=(String)ticketHash.get("nts_enable");
		String referral_ntscode=(String)ticketHash.get("referral_ntscode");
		double final_nts_commission=0;
		if("Y".equals(nts_enable) && !"".equals(referral_ntscode)){
			String nts_commission=(String)ticketHash.get("nts_commission");
			if("0".equals(nts_commission))
				nts_commission=(String)ticketHash.get("ticket_nts_commission");
			if(Double.parseDouble(nts_commission)>100){
				nts_commission="100";
			}
			final_nts_commission=Double.parseDouble(finalPrice)*Double.parseDouble(nts_commission)*Double.parseDouble(qty)/100;
		}
		final_nts_commission=Double.parseDouble(CurrencyFormat.getCurrencyFormat("", Double.toString(final_nts_commission), true));
		if("donationType".equals(ticketType))
			final_nts_commission=0;
		/* Nts commission ends*/
		
		JSONArray seat_index = new JSONArray((String)ticketHash.get("seat_index"));
		//JSONArray seat_index=(JSONArray)ticketHash.get("seat_index");
		System.out.println("seat_index - "+seat_index);

		if(finalPrice==null||"".equals(finalPrice)){
			finalPrice=price;
		}
		if(Double.parseDouble(finalPrice)==Double.parseDouble(price)){
			discount="0";
		}
		if(fee==null)	fee="0";
		if(finalprocessfee==null)	finalprocessfee=fee;
		try{
			selectedTicketsQty+=Integer.parseInt(qty);
			
		}
		catch(Exception e)
		{
			selectedTicketsQty+=0;
		}
		try{
			if(Double.parseDouble(finalPrice)>0)
				collectedTicketsQty+=Integer.parseInt(qty);
		}catch(Exception e){
			collectedTicketsQty+=0;
		}
		if(discount==null||"".equals(discount))	discount="0";
		StatusObj sb=DbUtil.executeUpdateQuery("insert into event_reg_ticket_details_temp(tid,ticketid,tickettype,qty,originalprice,originalfee,discount,finalprice,ticketname,finalfee,ticketgroupid,eid,ticketgroupname,final_nts_commission,transaction_at) " +
				"values(?,CAST(? AS BIGINT),?,CAST(? AS INTEGER),CAST(? AS NUMERIC),CAST(? AS NUMERIC),CAST(? AS NUMERIC),CAST(? AS NUMERIC),?,CAST(? AS NUMERIC),?,?,?,CAST(? AS NUMERIC),to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'))",
		new String[]{tid,ticketid,ticketType,qty,price,fee,discount,finalPrice,ticketname,finalprocessfee,ticketGroupid,eid,ticketgroupname,Double.toString(final_nts_commission),DateUtil.getCurrDBFormatDate()});
		String lock_query="insert into event_reg_locked_tickets (eventid,tid,locked_qty,ticketid,eventdate,locked_time) values (?,?,CAST(? AS BIGINT),CAST(? AS BIGINT),?,to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'))";
		StatusObj lockedsb=DbUtil.executeUpdateQuery(lock_query, new String []{eid,tid,qty,ticketid,eventdate,DateUtil.getCurrDBFormatDate()});
		String Blockseats_query="insert into event_reg_block_seats_temp (eventid,seatindex,transactionid,blocked_at,ticketid,eventdate) values (?,?,?,to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'),CAST(? AS BIGINT),?)";
	    for(int i=0;i<seat_index.length();i++){
			StatusObj blockseatsb=DbUtil.executeUpdateQuery(Blockseats_query, new String[]{eid,(String)seat_index.get(i),tid,DateUtil.getCurrDBFormatDate(),ticketid,eventdate});
		}
	}
	catch(Exception e){
		System.out.println("Exception in InsertTicketDetailsToDb--"+e.getMessage());
	}
	}

   public void setTransactionAmounts(String eventid, String tid){
	   try{
		    Double taxad=0.0;
		    String taxpercent="0";
		   //String taxpercent=DbUtil.getVal("select value from config where name='event.tax.amount' and config_id=(select config_id from eventinfo where eventid=to_number(?,'99999999999999'))",new String[]{eventid} );
		    try{
		    	Map ticketSettingsMap=CacheManager.getData(eventid, "ticketsettings");
		    	HashMap configMap=(HashMap)ticketSettingsMap.get("configmap");
		    	taxpercent=GenUtil.getHMvalue(configMap,"event.tax.amount","0");
		    	System.out.println("::::: taxpercent from cachemanager: "+taxpercent+" for eventid: "+eventid);
		    }catch(Exception e){
		    	System.out.println("Exception taxpercent from cachemanager: "+taxpercent+" for eventid: "+eventid+" ERROR: "+e.getMessage());
		    }
		   if(taxpercent==null) taxpercent="0";
		   try{			   
			   String taxarr[]=taxpercent.split("\\+");
			    if(taxarr.length==2)
			   {taxpercent=taxarr[0];
			    taxad=Double.parseDouble(taxarr[1]);
			   }
			   Double.parseDouble(taxpercent);
		   }
		   catch(Exception e){
			   System.out.println("exeception::"+e.getMessage());
			   taxpercent="0";
			   taxad=0.0;
		   }
		   

		   String total="0.00";
		   String discountamt="0.00";
		   String nettotal="0.00";
		   String nts_commission="0.00";
		   String query="select sum((originalprice+originalfee)*qty) as total,sum((finalprice+finalfee)*qty) as netamount,sum(discount*qty) as disamount,sum(final_nts_commission) as nts_commission from event_reg_ticket_details_temp where tid=?";
		   DBManager dbmanager=new DBManager();
		   StatusObj sb=dbmanager.executeSelectQuery(query,new String []{tid});
		   if(sb.getStatus()){
			   discountamt=dbmanager.getValue(0,"disamount","0");
			   total=dbmanager.getValue(0,"total","0");
			   nettotal=dbmanager.getValue(0,"netamount","0");
			   nts_commission=dbmanager.getValue(0,"nts_commission","0");
		   }
		   if(total==null) total="0.00";
		   if(discountamt==null) discountamt="0.00";
		   if(nettotal==null) nettotal="0.00";
		   if(nts_commission==null)nts_commission="0.00";
		   if("0.00".equals(nettotal))
			   taxad=0.00;
		   
		   DbUtil.executeUpdateQuery("update event_reg_details_temp set totalamount=CAST(? AS NUMERIC),granddiscount=CAST(? AS NUMERIC),nettotal=CAST(? AS NUMERIC),nts_commission=? where tid=?",
			   new String[]{total,discountamt,nettotal,nts_commission,tid});
		   Map Feesmap=getFessDetails(eventid);
		   HashMap<String,String> ebeefeeMap=getEbeeFee(eventid); 
		   String ebeefee=ebeefeeMap.get("finalebeefee");
		   String ebeefee_usd=ebeefeeMap.get("ebeefee_usd");
		   String cardfactor=GenUtil.getHMvalue(Feesmap,"card_factor","0");
		   String cardbase=GenUtil.getHMvalue(Feesmap,"card_base","0");
		   String tax=DbUtil.getVal("select (CAST(? AS NUMERIC) * nettotal/100)+cast(? as numeric) as totaltax from event_reg_details_temp where tid=?",new String [] {taxpercent,taxad+"", tid} );
		    if(tax==null) tax="0.00";				   
		   //System.out.println("TAXPerCEnt::"+taxpercent+"  taxad::"+taxad+" tax::"+tax);		 
		   sb=DbUtil.executeUpdateQuery("update event_reg_details_temp set grandtotal=(nettotal+CAST(? AS NUMERIC)),tax=CAST(? AS NUMERIC),ebeefee="+ebeefee+"*(CAST(? AS NUMERIC)),ebeefee_usd="+ebeefee_usd+"*(CAST(? AS NUMERIC)),cardfee=((nettotal*CAST(? AS NUMERIC))+("+cardbase+")) where tid=?",new String[]{tax,tax,collectedTicketsQty+"",collectedTicketsQty+"",cardfactor,tid});
		   sb=DbUtil.executeUpdateQuery("update event_reg_details_temp set totticketsqty=CAST(? AS NUMERIC),collected_ticketqty=CAST(? AS INTEGER),currency_conversion_factor=?::numeric,currency_code=?,current_service_fee=?::numeric where tid=?",new String[]{selectedTicketsQty+"",collectedTicketsQty+"",ebeefeeMap.get("conv_factor"),ebeefeeMap.get("currency_code"),ebeefee,tid});
	   }
	   catch(Exception e){
		   System.out.println("Exception in setTransactionAmounts"+e.getMessage());
	   }
	}
   
   public HashMap<String,String> getEbeeFee(String eid){
	   HashMap<String,String> feeMap=new HashMap<String, String>();
	   //String ebeefee=DbUtil.getVal("select current_fee from eventinfo where eventid=to_number(?,'99999999999999')", new String[]{eid});
	   String ebeefee="";
	   try{
		   Map eventinfoMap=CacheManager.getData(eid, "eventinfo");
		   ebeefee=(String)eventinfoMap.get("current_fee");
		   System.out.println("::::: ebeefee from cachemanager: "+ebeefee+" for evnetid: "+eid);
	   }catch(Exception e){
		   System.out.println("Exception ebeefee from cachemanager: "+ebeefee+" for evnetid: "+eid+" ERROR: "+e.getMessage());
	   }
	   if(ebeefee==null || "".equals(ebeefee)){
		   ebeefee=DbUtil.getVal("select l100 from ebee_special_fee where userid='0' and eventid='0'", null);;
	   }
	   String conv_factor="1";//DbUtil.getVal("select conversion_factor from currency_symbols a,event_currency b where b.eventid=? and a.currency_code=b.currency_code", new String[]{eid});
	   String currency_code="USD";
	   DBManager db=new DBManager();
	   StatusObj sb=db.executeSelectQuery("select conversion_factor,b.currency_code as currency from currency_symbols a,event_currency b where b.eventid=? and a.currency_code=b.currency_code", new String[]{eid});
	   if(sb.getStatus()){
		   conv_factor=db.getValue(0, "conversion_factor", "1");
		   currency_code=db.getValue(0, "currency", "USD");
	   }
	   feeMap.put("conv_factor", conv_factor);
	   feeMap.put("currency_code", currency_code);
	   feeMap.put("ebeefee_usd",(Double.parseDouble(ebeefee))+"");
	   double finalebeefee=1;
	   try{
		   finalebeefee=(Double.parseDouble(ebeefee))*(Double.parseDouble(conv_factor));
	   }catch(Exception e){
		   System.out.println("Exception occured in getEbeeFee(eid:"+eid+")."+e.getMessage());
	   }
	   feeMap.put("finalebeefee", finalebeefee+"");
	   return feeMap;
   }
   
	public HashMap getRegTotalAmounts(String tid){
		String query="select totalamount, granddiscount, nettotal, tax, grandtotal,status,currency_code from event_reg_details_temp where tid=?";
		DBManager dbmanager=new DBManager();
		String totalamount="0.00";
		String granddiscount="0.00";
		String netamount="0.00";
		String tax="0.00";
		String grandtotal="0.00";
		HashMap hm=new HashMap();
		try{
			StatusObj sb=dbmanager.executeSelectQuery(query,new String []{tid});
			if(sb.getStatus()){
				totalamount=dbmanager.getValue(0,"totalamount","0");
				granddiscount=dbmanager.getValue(0,"granddiscount","0");
				netamount=dbmanager.getValue(0,"nettotal","0");
				tax=dbmanager.getValue(0,"tax","0");
				grandtotal=dbmanager.getValue(0,"grandtotal","0");
			}
			if(totalamount==null) totalamount="0";
			if(granddiscount==null) granddiscount="0";
			if(netamount==null) netamount="0";
			if(tax==null) tax="0";
			if(grandtotal==null) grandtotal="0";
			hm.put("status",dbmanager.getValue(0,"status","0"));
			hm.put("totamount",CurrencyFormat.getCurrencyFormat("",totalamount,true));
			hm.put("disamount",CurrencyFormat.getCurrencyFormat("",granddiscount,true));
			hm.put("netamount",CurrencyFormat.getCurrencyFormat("",netamount,true));
			hm.put("tax",CurrencyFormat.getCurrencyFormat("",tax,true));
			hm.put("grandtotamount",CurrencyFormat.getCurrencyFormat("",grandtotal,true));
			hm.put("currencycode",dbmanager.getValue(0,"currency_code","0"));
		}
		catch(Exception e){
			System.out.println("Exception in getRegTotalAmounts"+e.getMessage());
		}
		return hm;
	}

	public void fillAmountDetails(HashMap amountsMap, JSONObject jsonObj,String tid){
		JSONObject obj=new JSONObject();
		try{
			obj.put("tid",tid);
			obj.put("totamount",amountsMap.get("totamount"));
			obj.put("disamount",amountsMap.get("disamount"));
			obj.put("netamount",amountsMap.get("netamount"));
			obj.put("tax",amountsMap.get("tax"));
			obj.put("grandtotamount",amountsMap.get("grandtotamount"));
			jsonObj.put("amounts",obj);
		}
		catch(Exception e){
			System.out.println("Exception in fillAmountDetails()"+e.getMessage());
		}
	}

	public ArrayList  getSelectedTickets(String tid){
		ArrayList  ticketsList=new ArrayList();
		try{
			DBManager dbmanager=new DBManager();
			StatusObj sb=dbmanager.executeSelectQuery(GET_SELECTED_TICKETS,new String []{tid});
			if(sb.getStatus())
			{
				for(int index=0;index<sb.getCount();index++){
					HashMap ticketMap=new HashMap();
					ticketMap.put("ticketName",dbmanager.getValue(index,"ticketname",""));
					ticketMap.put("selectedTicket",dbmanager.getValue(index,"ticketid",""));
					ticketMap.put("qty",dbmanager.getValue(index,"qty",""));
					ticketMap.put("type",dbmanager.getValue(index,"tickettype",""));
					ticketsList.add(ticketMap);
				}
			}
		}
		catch(Exception e){
			System.out.println("Exception in getSelectedTickets()"+e.getMessage());
		}
		return ticketsList;
	}

	public ArrayList   getTicketIdsForBaseProfiles(String eventid){
		String query="select ticketid from eventbaseprofiletickets where eventid=CAST(? AS BIGINT)";
		ArrayList baseprofileTickets=new ArrayList();
		try{
			DBManager db=new DBManager();
			StatusObj sb=db.executeSelectQuery(query,new String[]{eventid} );
			if(sb.getStatus()){
				for(int k=0;k<sb.getCount();k++){
					baseprofileTickets.add(db.getValue(k,"ticketid",""));
				}
			}
		}
		catch(Exception e){
			System.out.println("Exception in getTicketIdsForBaseProfiles()"+e.getMessage());
		}
		return baseprofileTickets;
	}

	public ArrayList getBuyerSpecificAttribs(String eventid){
		ArrayList attribidList=new ArrayList();
		try{
			DBManager dbmanager=new DBManager();
			StatusObj sb=dbmanager.executeSelectQuery(BUYER_CUSTOM_QUESTIONS,new String[]{eventid});
			if(sb.getStatus()){
				for(int p=0;p<sb.getCount();p++){
					attribidList.add(dbmanager.getValue(p,"attribid",""));
				}
			}
		}
		catch (Exception e){
			System.out.println("Exception in getBuyerSpecificAttribs"+e.getMessage());
		}
		return attribidList;
	}

	public Vector getAllPaymentTypes(String eventid,String purpose){
		Vector payVector=new Vector();
		try{
			DBManager dbmanager=new DBManager();
			StatusObj sb=dbmanager.executeSelectQuery(GET_PAYMENT_TYPES_QUERY,new String[]{eventid,"Enabled","Event"});
			if(sb.getStatus()){
				for(int i=0;i<sb.getCount();i++){
					HashMap hm=new HashMap();
					hm.put("paytype",dbmanager.getValue(i,"paytype",""));
					hm.put("desc",dbmanager.getValue(i,"attrib_1",""));
					payVector.add(hm);
				}
			}
		}
		catch(Exception e){
			System.out.println("Exception in getAllPaymentTypes"+e.getMessage());
		}
		return payVector;
	}

	public HashMap getBuyerDeails(String transactionid){
		HashMap buyerMap=new HashMap();
		try{
			DBManager db=new DBManager();
			StatusObj sb=db.executeSelectQuery(BUYER_BASE_INFO,new String[]{transactionid});
			if(sb.getStatus()){
				buyerMap.put("fname",db.getValue(0,"fname",""));
				buyerMap.put("lname",db.getValue(0,"lname",""));
				buyerMap.put("email",db.getValue(0,"email",""));
				buyerMap.put("phone",db.getValue(0,"phone",""));
			}
		}
		catch(Exception e){
			System.out.println("Exception in getBuyerDeails"+e.getMessage());
		}
		return buyerMap;
	}

    public HashMap getTicketDetails(String eid){
    	HashMap ticketsMap=new HashMap();
    	DBManager db=new DBManager();
    	StatusObj sb=db.executeSelectQuery(GET_TICKETS_QUERY,new String[]{eid});
    	if(sb.getStatus()){
    		for(int i=0;i<sb.getCount();i++){
    			HashMap priceMap=new HashMap();
    			priceMap.put("ticketname",db.getValue(i,"ticket_name",""));
    			priceMap.put("groupname",db.getValue(i,"groupname",""));
    			priceMap.put("ticket_groupid",db.getValue(i,"ticket_groupid",""));
    			priceMap.put("price_id",db.getValue(i,"price_id",""));
    			ticketsMap.put(db.getValue(i,"price_id",""),priceMap);
    		}
    	}
    	return ticketsMap;
    }
    
    public String getVelocityTemplate(String eid,String purpose){
    	String template=null;
    	try{
    		HashMap<String, String> hm= new HashMap<String,String>();
    		hm.put("purpose", purpose);
    		ConfirmationPageDAO pageDao=new ConfirmationPageDAO();
    		String lang=DBHelper.getLanguageFromDB(eid);
    		template=(String)pageDao.getData(hm, lang, eid).get("content");
    		/*template=DbUtil.getVal("select content from custom_reg_flow_templates where eventid=CAST(? AS BIGINT) and purpose=?",new String[]{eid,purpose});
    		if(template==null){
    			template=DbUtil.getVal("select content from default_reg_flow_templates where  purpose=? and eventid=CAST(? AS BIGINT)",new String[]{purpose,lang});
    		}*/
    	}
    	catch(Exception e){
    		System.out.println("Exception in getVelocityTemplate"+e.getMessage());
    	}
    	return template;
    }

    public ArrayList getQuestionsFortheSelectedOption(String option,String eventid){
    	String query="select attrib_id from rsvp_attribs where eventid=CAST(? AS BIGINT) and rsvp_status=?";
    	ArrayList attribsList=new ArrayList();
    	DBManager db=new DBManager();
    	try{
    		StatusObj sb=db.executeSelectQuery(query,new String[]{eventid,option});
    		System.out.println("sb.getStatus()--"+sb.getStatus());
    		if(sb.getStatus()){
    			for(int i=0;i<sb.getCount();i++){
    				attribsList.add(db.getValue(i,"attrib_id",""));
    			}
    		}
    	}
    	catch(Exception e){
    	}
    	return attribsList;
    }

    public Map getFessDetails(String eventid){
    	Map hm=new HashMap();
    	try{
    		String eventlevelquery="select ebee_base as ebeefee,card_factor,card_base from ebeefees where ref1=? and purpose='EVENT_REGISTRATION'";
    		DBManager dbManager=new DBManager();
    		StatusObj sb=dbManager.executeSelectQuery(eventlevelquery,new String[]{eventid});
    		if(sb.getStatus()){
    			hm.put("ebeefee",dbManager.getValue(0,"ebeefee",""));
    			hm.put("card_factor",dbManager.getValue(0,"card_factor",""));
    			hm.put("card_base",dbManager.getValue(0,"card_base",""));
    		}
    		else{
    			String managerlevelquery="select ebee_base as ebeefee,card_factor,card_base from ebeefees where CAST(ref2 AS INTEGER) =(select mgr_id from eventinfo where eventid=CAST(? AS BIGINT)) and purpose='EVENT_REGISTRATION'";
    			sb=dbManager.executeSelectQuery(managerlevelquery,new String[]{eventid});
    			if(sb.getStatus()){
    				hm.put("ebeefee",dbManager.getValue(0,"ebeefee",""));
    				hm.put("card_factor",dbManager.getValue(0,"card_factor",""));
    				hm.put("card_base",dbManager.getValue(0,"card_base",""));
    			}else{
    				String defaultquery="select ebee_base as ebeefee,card_factor,card_base from ebeefees where ref1 is null and ref2 is null and purpose='EVENT_REGISTRATION'";
    				sb=dbManager.executeSelectQuery(defaultquery,new String[]{});
    				if(sb.getStatus()){
    					hm.put("ebeefee",dbManager.getValue(0,"ebeefee",""));
    					hm.put("card_factor",dbManager.getValue(0,"card_factor",""));
    					hm.put("card_base",dbManager.getValue(0,"card_base",""));
    				}
    			}
    		}
    	}
    	catch (Exception e){
    		System.out.println("Exception in fee calculations==="+e.getMessage());
    	}
    	return hm;
    }

    public HashMap getSeatingCodeDetails(String eid,String tid,String eventdate,String ticketids){
    	String []arrayticketids=ticketids.split(",");
    	HashMap seatingdetails=new HashMap();
    	if(" ".equals(eventdate))eventdate="";
    	String query="select seatcode from venue_seats where venue_id =CAST((select value from config where name='event.seating.venueid' and config_id in (select config_id from eventinfo where eventid=CAST(? AS BIGINT))) AS INTEGER) and seatindex in(select seatindex from event_reg_block_seats_temp where eventid=? and transactionid=? and ticketid=CAST(? AS BIGINT))";
    	if(!"".equals(eventdate)){
    		query="select seatcode from venue_seats where venue_id =CAST((select value from config where name='event.seating.venueid' and config_id in (select config_id from eventinfo where eventid=CAST(? AS BIGINT))) AS INTEGER) and seatindex in(select seatindex from event_reg_block_seats_temp where eventid=? and transactionid=? and ticketid=CAST(? AS BIGINT) and eventdate=?)";		
    	}
    	DBManager db=new DBManager();
    	StatusObj Sel_tic_sb;	
    	for(int k=0;k<arrayticketids.length;k++){
    		ArrayList seatcodes=new ArrayList();
    		String ticketid=arrayticketids[k];
    		if(!"".equals(eventdate))
    			Sel_tic_sb=db.executeSelectQuery(query,new String[]{eid,eid,tid,ticketid,eventdate});
    		else
    			Sel_tic_sb=db.executeSelectQuery(query,new String[]{eid,eid,tid,ticketid});
    		if(Sel_tic_sb.getStatus()&&Sel_tic_sb.getCount()>0){
    			for(int i=0;i<Sel_tic_sb.getCount();i++){
    				String seatcode=db.getValue(i, "seatcode", "");
    				seatcodes.add(seatcode);
    			}
    		}
    		seatingdetails.put(ticketid, seatcodes);
    	}
    	return seatingdetails;
    }

    public HashMap getSeatingDetails(String eid,String tid,String eventdate,ArrayList ticketids){
    	//String []arrayticketids=ticketids.split(",");
    	HashMap seatingdetails=new HashMap();
    	if(" ".equals(eventdate))eventdate="";
    	String query="select seatcode,venue_id,section_id,seatindex from venue_seats where venue_id =CAST((select value from config where name='event.seating.venueid' and config_id in (select config_id from eventinfo where eventid=CAST(? AS BIGINT))) AS INTEGER) and seatindex in(select seatindex from event_reg_block_seats_temp where eventid=? and transactionid=? and ticketid=CAST(? AS BIGINT))";
    	if(!"".equals(eventdate)){
    		query="select seatcode,venue_id,section_id,seatindex from venue_seats where venue_id =CAST((select value from config where name='event.seating.venueid' and config_id in (select config_id from eventinfo where eventid=CAST(? AS BIGINT))) AS INTEGER) and seatindex in(select seatindex from event_reg_block_seats_temp where eventid=? and transactionid=? and ticketid=CAST(? AS BIGINT) and eventdate=?)";		
    	}
    	DBManager db=new DBManager();
    	StatusObj Sel_tic_sb;
    	for(int k=0;k<ticketids.size();k++){
    		ArrayList seatcodes=new ArrayList();
    		ArrayList seat_index=new ArrayList();
    		String ticketid=(String)ticketids.get(k);
    		if(!"".equals(eventdate))
    			Sel_tic_sb=db.executeSelectQuery(query,new String[]{eid,eid,tid,ticketid,eventdate});
    		else
    			Sel_tic_sb=db.executeSelectQuery(query,new String[]{eid,eid,tid,ticketid});
    		if(Sel_tic_sb.getStatus()&&Sel_tic_sb.getCount()>0){
    			for(int i=0;i<Sel_tic_sb.getCount();i++){
    				String seatcode=db.getValue(i, "seatcode", "");
    				String seatindex=db.getValue(i,"seatindex","");
    				seatcodes.add(seatcode);
    				seat_index.add(seatindex);
					HashMap hm=new HashMap();
					hm.put("venue_id",db.getValue(i,"venue_id",""));
					hm.put("section_id",db.getValue(i,"section_id",""));
					hm.put("seatindex",seatindex);
					seatingdetails.put(ticketid+"_"+seatindex+"_"+seatcode,hm);
    			}
    		}
    		seatingdetails.put(ticketid, seatcodes);
    		seatingdetails.put("seatindex_"+ticketid, seat_index);
    	}
    	return seatingdetails;
    }

    public ArrayList getTicketIds(String eventid) {
    	String query="select price_id from price where evt_id=CAST(? AS BIGINT)";
    	ArrayList profileTickets=new ArrayList();
    	try{
    		DBManager db=new DBManager();
    		StatusObj sb=db.executeSelectQuery(query,new String[]{eventid} );
    		if(sb.getStatus()){
    			for(int k=0;k<sb.getCount();k++){
    				profileTickets.add(db.getValue(k,"price_id",""));
    			}
    		}
    	}
    	catch(Exception e){
    		System.out.println("Exception in getTicketIdsForBaseProfiles()"+e.getMessage());
    	}
    	return profileTickets;
    }

    public void setEventRegTempAction(String eid,String tid,String action){
    	String query="update event_reg_details_temp set current_action=? where eventid=? and tid=?";
    	DbUtil.executeUpdateQuery(query, new String[]{action,eid,tid});
    }
    public HashMap getPartnerNTSCode(HashMap ntsdata){
    	HashMap hm=new HashMap();
    	String ntscode="";
    	String display_ntscode="";
    	String fbuserid=(String) ntsdata.get("fbuserid");
    	String ntspartnerselectquery="select nts_code,nts_code_display from ebee_nts_partner where external_userid=?";
    	DBManager db=new DBManager();
    	StatusObj sb=db.executeSelectQuery(ntspartnerselectquery, new String[]{fbuserid});
    	if(sb.getStatus()){
    		ntscode=db.getValue(0, "nts_code", "");
    		display_ntscode=db.getValue(0, "nts_code_display", "");
    	}
    	//ntscode=DbUtil.getVal(ntspartnerselectquery, new String[]{fbuserid});
    	if(ntscode==null ||"".equals(ntscode) || "null".equals(ntscode)){
    		String ntspartnerid="";
    		String ntspartneridseq="select nextval('nts_partner_seq') as ntspartnerid";
    		ntspartnerid=DbUtil.getVal(ntspartneridseq,new String[]{});
    		ntscode="nt"+EncodeNum.encodeNum(ntspartnerid).toLowerCase();
    		String becomeebeentspartnerinsertquery="insert into ebee_nts_partner (nts_code,source,partner_from,external_userid,nts_partnerid,nts_code_display,fname,lname,email,network) values(?,'Registration',to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'),?,?,?,?,?,?,?)";
    		StatusObj ebeeNTSPartnerSB=DbUtil.executeUpdateQuery(becomeebeentspartnerinsertquery,new String[]{ntscode,DateUtil.getCurrDBFormatDate(),fbuserid,ntspartnerid,ntscode,(String)ntsdata.get("fname"),(String)ntsdata.get("lname"),(String)ntsdata.get("email"),(String)ntsdata.get("network")});
    	}
    	if("".equals(display_ntscode))
    		display_ntscode=ntscode;
    	hm.put("nts_code",ntscode);
    	hm.put("display_ntscode",display_ntscode);
    	if("Y".equals(ntsdata.get("ntsenable"))){
    		String alreadyntspartner="";
    		String ntspartnerquery="select 'YES' from event_nts_partner where eventid=? and nts_code=?";
    		alreadyntspartner=DbUtil.getVal(ntspartnerquery, new String[]{(String)ntsdata.get("eventid"),ntscode});
    		if(!"YES".equals(alreadyntspartner)){
    			String becomeeventntspartnerinsertquery="insert into event_nts_partner (nts_code,eventid,status,partner_from_date) values(?,?,?,to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'))";
    			StatusObj becomepartnersbobj=DbUtil.executeUpdateQuery(becomeeventntspartnerinsertquery, new String []{ntscode,(String)ntsdata.get("eventid"),"ACTIVE",DateUtil.getCurrDBFormatDate()});
    		}
    	}
    	return hm;
    }

    public void updateDetailsTempNTSDetails(HashMap ntsdata){
    	String fbuserid="",ntscode="",partnerstatus="Skip Partner",referral_ntscode="";
    	try{
    		fbuserid=(String)ntsdata.get("fbuserid");
    		if(!"0".equals(fbuserid)){
    			ntscode=(String)ntsdata.get("ntscode");
    			if("Y".equals(ntsdata.get("ntsenable"))){
    				partnerstatus="Became Partner";
    				referral_ntscode=(String)ntsdata.get("referral_ntscode");
    			}
    		}
    		else if("0".equals(fbuserid) && "Y".equals(ntsdata.get("ntsenable")) ){
    			referral_ntscode=(String)ntsdata.get("referral_ntscode");
    		}
    		else{
    			fbuserid="";
    			partnerstatus="";
    		}
    	}catch(Exception e){
    	}
    	String tempdetailsntsupdatequery="update event_reg_details_temp set buyer_ntscode=?,nts_selected_action=?,referral_ntscode=? where eventid=? and tid=?";
    	DbUtil.executeUpdateQuery(tempdetailsntsupdatequery, new String[]{ntscode,partnerstatus,referral_ntscode,(String)ntsdata.get("eventid"),(String)ntsdata.get("tid")});
    }
    
    
    public void autoLocksAndBlockDelete(String eventid,String tid,String module){
    	String timeout="",seatingEnabled="NO";
    	try{
	    	Map ticketSettingsMap=CacheManager.getData(eventid, "ticketsettings");	
	    	HashMap configMap=(HashMap)ticketSettingsMap.get("configmap");
	    	timeout=GenUtil.getHMvalue(configMap,"timeout","14");
	    	seatingEnabled=GenUtil.getHMvalue(configMap,"event.seating.enabled","NO");
	    	
    	}catch(Exception e){
    		System.out.println("Exception in autoLocksAndBlockDelete: "+e.getMessage());
    	}
    	autoLocksAndBlockDelete(eventid,tid,module,timeout,seatingEnabled);
    }
    
    public void autoLocksAndBlockDelete(String eventid,String tid,String module,String timeout,String seatingEnabled){
    	try{
    	Long.parseLong(eventid);
    	if(timeout==null || "".equals(timeout))
    		timeout=DbUtil.getVal("select value from config where config_id =(select config_id from eventinfo where eventid=?::bigint) and name='timeout' ",new String[]{eventid});
    	
    	timeout=timeout==null||"".equals(timeout) ?"14":timeout;
    	timeout=1+Integer.parseInt(timeout)+"";}catch(Exception e){timeout="15";}
    	System.out.println("Deleting holdy blocks:::eventid"+eventid+" tid:"+tid+" module:"+module+" timeout::"+timeout);
    	
    	DbUtil.executeUpdateQuery("delete from event_reg_locked_tickets where locked_time <(select now()- interval   ' "+timeout+" minutes') and eventid=?;",new String[]{eventid});
    	if("YES".equals(seatingEnabled))
    		DbUtil.executeUpdateQuery("delete from event_reg_block_seats_temp where blocked_at  <(select now()- interval ' "+timeout+" minutes') and eventid=?;",new String[]{eventid});
    	
    }

}

