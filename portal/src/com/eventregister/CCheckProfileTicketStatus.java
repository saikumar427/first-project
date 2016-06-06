package com.eventregister;

import java.util.HashMap;
import org.json.JSONArray;
import org.json.JSONObject;
import com.eventbee.general.DBManager;
import com.eventbee.general.DbUtil;
import com.eventbee.general.StatusObj;

public class CCheckProfileTicketStatus {
	public static String EVENT_LEVEL_QTY_CRITERIA_MSG= "event-level-qty-criteria";
	
	public HashMap<String,HashMap<String, String>> eventLevelCheck(String eid,String tid,String eventdate){
		HashMap<String,HashMap<String, String>> result=new HashMap<String,HashMap<String, String>>();
		String limitCount=DbUtil.getVal("select value from config where config_id=(select config_id from eventinfo where eventid=?::bigint) and name='event.reg.eventlevelcheck.count'",new String[]{eid});
		limitCount=limitCount==null?"":limitCount.trim();
		
		System.out.println("(Box Office) eid::"+eid);
		System.out.println("(Box Office) tid::"+tid);
		System.out.println("(Box Office) eventdate::"+eventdate);
		System.out.println(eid+"limitcount::"+limitCount);
		
		if("".equals(limitCount))
			return result;

		try{
			Integer.parseInt(limitCount);
		}catch(Exception e){ return result; }
		
		String query="";
		String params[]=null;
		if("".equals(eventdate)){
			query="select  (?::integer -((select COALESCE(sum(locked_qty),0) from         event_reg_locked_tickets where eventid=? and locked_time <=(select locked_time from event_reg_locked_tickets where  tid=? order by locked_time desc limit 1))+(select COALESCE(sum(sold_qty),0) from price where evt_id=?::integer and isdonation='No'))) as re_qty";
			params=new String[]{limitCount,eid,tid,eid};
		}else{
		   query="select  (?::integer -((select COALESCE(sum(locked_qty),0) from event_reg_locked_tickets where eventid=? and eventdate=? and locked_time <=(select locked_time from event_reg_locked_tickets where  tid=? order by locked_time desc limit 1))+(select COALESCE (sum (soldqty),0) from  reccurringevent_ticketdetails where eventid=?::integer and eventdate=? and isdonation='No' ))) as re_qty";			
		   params=new String[]{limitCount,eid,eventdate,tid,eid,eventdate};
		}
		if("".equals(query))	
			return result;
		String requireQty=DbUtil.getVal(query,params);
		System.out.println("(Box office)reqty:::::::"+requireQty+"  params::"+ params);
		try{
			if(Integer.parseInt(requireQty)<0){
				HashMap<String, String> temp=new HashMap<String, String>();
				int sel_qty=0;
				try{
					sel_qty=Integer.parseInt(DbUtil.getVal("select sum(locked_qty) from event_reg_locked_tickets where tid=?",new String[]{tid}));
					requireQty=sel_qty+Integer.parseInt(requireQty)+"";
				}catch(Exception e){ sel_qty=0; }
				temp.put("selected_qty",sel_qty+"");
				temp.put("remaining_qty",requireQty);
				temp.put("eventname",DbUtil.getVal("select eventname from eventinfo where eventid=?::bigint",new String[]{eid}));
				result.put(eid, temp);	
				DbUtil.executeUpdateQuery("delete from event_reg_locked_tickets where tid=?",new String[]{tid});
			}
		}catch(Exception e){
			System.out.println("Error While calculating the event level check::: CCheckProfileTicketStatus.java "+tid+"::"+e.getMessage());
		}
		System.out.println("result eventLevelCheck in CCheckProfileTicketStatus.java "+result);
		return result;	
	}
	
	public HashMap<String,HashMap<String,String>> getNONRecurringEventTicketsAvailibility(String eid,String tid,JSONArray ticketsQtyArray,String edate){
		HashMap<String,HashMap<String,String>> qtyDetails=new HashMap<String,HashMap<String,String>>();
		HashMap<String,String> remainingCountMap=new HashMap<String,String>();
		try{
			DBManager Db=new DBManager();
			StatusObj sb=null,price_sb=null,curr_lsb=null;
			/****start eventlevel check****/
			qtyDetails=eventLevelCheck(eid, tid,"");
			if(!qtyDetails.isEmpty()){//event level quantity  criteria has reached 
				HashMap<String, String> temp=new HashMap<String, String>();
				temp.put("criteria", EVENT_LEVEL_QTY_CRITERIA_MSG);
				qtyDetails.put("criteria", temp);
				return qtyDetails;
			}
			/****end eventlevel check****/
			
			String soldlquery="select sold_qty,max_ticket,price_id from price where evt_id=cast(? as bigint)";
			String current_locked_qry="select locked_qty,ticketid from event_reg_locked_tickets  where tid=? ";			
			price_sb=Db.executeSelectQuery(soldlquery,new String[]{eid});
			if(price_sb.getStatus()&&price_sb.getCount()>0){
				for(int i=0;i<price_sb.getCount();i++){
					remainingCountMap.put("p_"+Db.getValue(i,"price_id",""),Db.getValue(i,"max_ticket","0"));
					remainingCountMap.put("s_"+Db.getValue(i,"price_id",""),Db.getValue(i,"sold_qty","0"));
				}
			}
			curr_lsb=Db.executeSelectQuery(current_locked_qry,new String[]{tid});
			if(curr_lsb.getStatus()&&curr_lsb.getCount()>0){
				for(int i=0;i<curr_lsb.getCount();i++){
					System.out.println(Db.getValue(i,"ticketid","")+"  lockedqty "+Db.getValue(i,"locked_qty","0"));
					remainingCountMap.put("cl_"+Db.getValue(i,"ticketid",""),Db.getValue(i,"locked_qty","0"));
				}
			}
			curr_lsb=null;
			String lquery2="select ticketid,sum(locked_qty)as lock from event_reg_locked_tickets where eventid=? and locked_time <=(select locked_time from event_reg_locked_tickets where  tid=? order by locked_time desc limit 1) group by ticketid";
			curr_lsb=Db.executeSelectQuery(lquery2,new String[]{eid,tid});
			if(curr_lsb.getStatus()&&curr_lsb.getCount()>0){
				for(int i=0;i<curr_lsb.getCount();i++){
					System.out.println(Db.getValue(i,"ticketid","")+" lock "+Db.getValue(i,"lock","0"));
					remainingCountMap.put("lk_"+Db.getValue(i,"ticketid",""),Db.getValue(i,"lock","0"));
				}
			}
			
			for(int i=0;i<ticketsQtyArray.length();i++){
				JSONObject eachTicketQtyJSON=ticketsQtyArray.getJSONObject(i);
				String ticketId=eachTicketQtyJSON.getString("ticket_id");
				int max_ticket=0;
				int sold=0;
				int currentlock=0;
				int lock=0;
				
				try{
					if(remainingCountMap.get("p_"+ticketId)!=null)
						max_ticket=Integer.parseInt((String)remainingCountMap.get("p_"+ticketId));
				}catch(Exception e){max_ticket = 0;}
				
				try{
					if(remainingCountMap.get("s_"+ticketId)!=null)
						sold=Integer.parseInt((String)remainingCountMap.get("s_"+ticketId));
				}catch(Exception e){sold=0;}
				
				try{
					if(remainingCountMap.get("cl_"+ticketId)!=null)
						currentlock=Integer.parseInt((String)remainingCountMap.get("cl_"+ticketId));
				}catch(Exception e){currentlock=0;}
				
				try{	
					if(remainingCountMap.get("cl_"+ticketId)!=null)
						   lock=Integer.parseInt((String)remainingCountMap.get("lk_"+ticketId));
				}catch(Exception e){lock=0;}
				
				System.out.println("max "+max_ticket+" sold "+sold+" lock "+lock+" currentlock "+currentlock);
				
				if(max_ticket<(sold+lock)){
					HashMap<String, String> temp=new HashMap<String, String>();
					int remainingqty=max_ticket-(sold+lock-currentlock);
					String res=DbUtil.getVal("select array_agg( 'eventid='||eventid ||' ticketid='||ticketid||' tid='||tid||' qty='||locked_qty||' eventdate='||eventdate||' time='||locked_time) ::text"+
							 " as response from event_reg_locked_tickets where eventid=? and tid=?", new String[]{eid,tid});
					temp.put("ticket_id",ticketId+"");
					temp.put("selected_qty",currentlock+"");
					temp.put("remaining_qty",remainingqty+"");
					qtyDetails.put(ticketId, temp);	
				}
			}
		}catch(Exception e){
			System.out.println("Exception at CCheckProfileTicketStatus.java function: getNONRecurringEventTicketsAvailibility "+e.getMessage());
		}
		return qtyDetails;
	}
	
	public HashMap<String,HashMap<String,String>> getRecurringEventTicketsAvailibility(String eventid,String eventdate,String tid,JSONArray ticketsQtyArray){
		HashMap<String,HashMap<String,String>> qtyDetails=new HashMap<String,HashMap<String,String>>();
		HashMap<String,String> remainingCountMap=new HashMap<String,String>();
		try{
			StatusObj price_sb=null,rec_sb=null,locked_sb=null,curr_lsb=null;
			DBManager Db=new DBManager();
			/****start eventlevel check****/
			qtyDetails=eventLevelCheck(eventid, tid,eventdate);
			if(!qtyDetails.isEmpty()){//event level quantity  criteria has reached
				HashMap<String, String> temp=new HashMap<String, String>();
				temp.put("criteria", EVENT_LEVEL_QTY_CRITERIA_MSG);
				qtyDetails.put("criteria", temp);
				return qtyDetails;
			}
			/****end eventlevel check****/
			
			String price_qry="select price_id,max_ticket,min_qty,max_qty from price where evt_id=cast(? as numeric)";
			price_sb=Db.executeSelectQuery(price_qry,new String[]{eventid});
			String rec_sold_qty_qry="select ticketid,soldqty from reccurringevent_ticketdetails where eventid=cast(?as numeric) and eventdate=?";
			String current_locked_qry="select locked_qty ,ticketid from event_reg_locked_tickets where  tid=?";
			
			if(price_sb.getStatus()&&price_sb.getCount()>0){
				for(int i=0;i<price_sb.getCount();i++){
					remainingCountMap.put("p_"+Db.getValue(i,"price_id",""),Db.getValue(i,"max_ticket","0"));
					remainingCountMap.put("min_"+Db.getValue(i,"price_id",""),Db.getValue(i,"min_qty","0"));
					remainingCountMap.put("max_"+Db.getValue(i,"price_id",""),Db.getValue(i,"max_qty","0"));
				}
			}
			rec_sb=Db.executeSelectQuery(rec_sold_qty_qry,new String[]{eventid,eventdate});
			
			if(rec_sb.getStatus()&&rec_sb.getCount()>0){
				for(int i=0;i<rec_sb.getCount();i++){
					remainingCountMap.put("r_"+Db.getValue(i,"ticketid",""),Db.getValue(i,"soldqty","0"));
				}
			}
			curr_lsb=Db.executeSelectQuery(current_locked_qry,new String[]{tid});
			if(curr_lsb.getStatus()&&curr_lsb.getCount()>0){
				for(int i=0;i<curr_lsb.getCount();i++){
					System.out.println(Db.getValue(i,"ticketid","")+" curentlock "+Db.getValue(i,"locked_qty","0"));
					remainingCountMap.put("cl_"+Db.getValue(i,"ticketid",""),Db.getValue(i,"locked_qty","0"));
				}
			}
			String locked_qry="select ticketid,sum(locked_qty) as locked_qty from event_reg_locked_tickets where eventid=? and eventdate=? and  locked_time <=(select locked_time from event_reg_locked_tickets  where  tid=? order by locked_time desc limit 1)group by ticketid";
			
			locked_sb=Db.executeSelectQuery(locked_qry,new String[]{eventid,eventdate,tid});
			
			if(locked_sb.getStatus()&&locked_sb.getCount()>0){
				for(int i=0;i<locked_sb.getCount();i++){
					System.out.println(Db.getValue(i,"ticketid","")+" reclock  "+Db.getValue(i,"locked_qty","0"));
					remainingCountMap.put("lk_"+Db.getValue(i,"ticketid",""),Db.getValue(i,"locked_qty","0"));
				}
			}
			
			for(int i=0;i<ticketsQtyArray.length();i++){
				JSONObject eachTicketQtyJSON=ticketsQtyArray.getJSONObject(i);
				String tktid=eachTicketQtyJSON.getString("ticket_id");
				int lockcount=0;
				int max=0;
				int sold=0;
				int curenthold=0;
				int minqty=0;
				int maxqty=0;
				
				try{
					if(remainingCountMap.get("p_"+tktid)!=null)
						max=Integer.parseInt((String)remainingCountMap.get("p_"+tktid));
				}catch(Exception e){max=0;}
				
				try{
					if(remainingCountMap.get("r_"+tktid)!=null)
						sold=Integer.parseInt((String)remainingCountMap.get("r_"+tktid));
				}catch(Exception e){sold=0;}
				
				try{
					if(remainingCountMap.get("cl_"+tktid)!=null)
						curenthold=Integer.parseInt((String)remainingCountMap.get("cl_"+tktid));
				}catch(Exception e){curenthold=0;}
				
				try{
					if(remainingCountMap.get("lk_"+tktid)!=null)
						lockcount=Integer.parseInt((String)remainingCountMap.get("lk_"+tktid));
				}catch(Exception e){lockcount=0;}
				
				try{
					if(remainingCountMap.get("min_"+tktid)!=null)
						minqty=Integer.parseInt((String)remainingCountMap.get("min_"+tktid));
				}catch(Exception e){minqty=0;}
				
				try{
					if(remainingCountMap.get("max_"+tktid)!=null)
						maxqty=Integer.parseInt((String)remainingCountMap.get("max_"+tktid));
				}catch(Exception e){maxqty=0;}
				System.out.println("2max "+max+" sold "+sold+" lock "+lockcount+" currentlock "+curenthold+" minqty "+minqty+" maxqty "+maxqty+" tktid "+tktid+" tid "+tid);
				
				if((max<(sold+lockcount)) || (curenthold<minqty) || (curenthold>maxqty)){
					HashMap<String, String> temp=new HashMap<String, String>();
					int remainingqty=max-(sold+lockcount-curenthold);
		            int hh=(lockcount-curenthold);
		            temp.put("ticket_id",tktid+"");
					temp.put("selected_qty",curenthold+"");
					temp.put("remaining_qty",remainingqty+"");
					qtyDetails.put(tktid, temp);	
				}
			}
			
		}catch(Exception e){
			System.out.println("Exception in  recurring event hold at profile level:"+e.getMessage());
		}
		return qtyDetails;
	}
	
}
