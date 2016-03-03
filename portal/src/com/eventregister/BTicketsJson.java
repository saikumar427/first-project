package com.eventregister;

import java.util.ArrayList;
import java.util.HashMap;

import org.json.JSONArray;
import org.json.JSONObject;

import com.eventbee.general.DBManager;
import com.eventbee.general.DbUtil;
import com.eventbee.general.GenUtil;
import com.eventbee.general.StatusObj;
import com.eventbee.general.formatting.CurrencyFormat;


public class BTicketsJson {
	TicketingInfo ticketInfo=new TicketingInfo();
	public  JSONObject getTicketsJSON(String eid,String edate,String tid,String ticketUrlCode,String discountCode,String source){
		JSONObject ticketsJSON=new JSONObject();
		HashMap<String, String> lockedQuantity=new HashMap<String, String>();
		JSONArray tickets=new JSONArray();
		try{
			long startTime = System.currentTimeMillis();
			ticketInfo.intialize(eid,ticketUrlCode,edate);
			long endTime = System.currentTimeMillis();
			System.out.println("time for all intialization "+ (endTime - startTime));
			startTime = System.currentTimeMillis();
			ticketsJSON.put("disc_exists",ticketInfo.isDiscountExists);	
			ticketsJSON.put("currency",ticketInfo.currencyformat);
			ticketsJSON.put("discnbuy",ticketInfo.discnbuy);
			HashMap configMap=(HashMap)ticketInfo.ticketSettingsMap.get("TicketDisplayOptionsMap");
			String descMode=(String) configMap.get("event.general.tktDescMode");
			if(descMode==null) descMode="collapse";
			ticketsJSON.put("ticket_desc_mode",descMode);
			descMode=(String) configMap.get("event.group.tktDescMode");
			if(descMode==null) descMode="collapse";
			ticketsJSON.put("ticket_group_desc_mode",descMode);
			ticketsJSON.put("ticket_status",(String) configMap.get("event.activetickets.status"));
			
			HashMap<String, String> regFlowWordings=(HashMap<String,String>)ticketInfo.ticketSettingsMap.get("RegFlowWordingsMap");
			JSONObject reg_flow_wordings=new JSONObject();
			reg_flow_wordings.put("apply_button_label",GenUtil.getHMvalue(regFlowWordings,"discount.code.applybutton.label","Apply Code"));
			reg_flow_wordings.put("order_button_label",GenUtil.getHMvalue(regFlowWordings,"event.reg.orderbutton.label","Buy Tickets"));
			reg_flow_wordings.put("process_fee_label",GenUtil.getHMvalue(regFlowWordings,"event.reg.processfee.label","Fee"));
			reg_flow_wordings.put("disc_box_label",GenUtil.getHMvalue(regFlowWordings,"event.reg.discount.box.label","Have a discount code, enter it here"));
			reg_flow_wordings.put("total_amount_label",GenUtil.getHMvalue(regFlowWordings,"event.reg.total.amount.label","Total"));
			reg_flow_wordings.put("tax_label",GenUtil.getHMvalue(regFlowWordings,"event.reg.tax.amount.label","Process Fee"));
			ticketsJSON.put("reg_flow_wordings", reg_flow_wordings);
			
			Double taxExtra=0.00;
			String taxPercent=(String) GenUtil.getHMvalue((HashMap)ticketInfo.ticketSettingsMap.get("configmap"),"event.tax.amount","0");
			if(taxPercent==null) taxPercent="0";
			try{			   
				String taxarr[]=taxPercent.split("\\+");
				if(taxarr.length==2){
					taxPercent=taxarr[0];
				    taxExtra=Double.parseDouble(taxarr[1]);
				}
				Double.parseDouble(taxPercent);
			}catch(Exception e){
				System.out.println("exeception::"+e.getMessage());
				taxPercent="0.00";
				taxExtra=(Double)0.00;
			}
			ticketsJSON.put("tax_percent", Double.parseDouble(taxPercent));
			ticketsJSON.put("extra_tax", taxExtra);
			
			ArrayList<TicketGroup> ticketsArray=ticketInfo.requiredTicketGroups;
			if(!"".equals(tid) && tid!=null)
				lockedQuantity=getQuantity(tid, eid);
			HashMap<String,String> mgrConfigMessages=new HashMap<String, String>();
			if("widget".equalsIgnoreCase(source))		
				mgrConfigMessages=getTicketMessage(eid,edate);
			Double totalFee=0.0;
			for(int i=0;i<ticketsArray.size();i++){
				TicketGroup eachGroup=(TicketGroup)ticketsArray.get(i);
				EventTicket eventTicketsArray[]=(EventTicket[])eachGroup.getGroupTicketsArray();
				ArrayList<JSONObject> eachGroupTicketsJSON=new ArrayList<JSONObject>();
				for(int k=0;k<eventTicketsArray.length;k++){
					try{
						JSONObject eachTicketJSON=new JSONObject();
						eachTicketJSON.put("name",eventTicketsArray[k].getTicketName());
						
						eachTicketJSON.put("actual_price",CurrencyFormat.getCurrencyFormat("",eventTicketsArray[k].getTicketPrice()+"",true));
						if("".equals(discountCode)){
							eachTicketJSON.put("charging_price",CurrencyFormat.getCurrencyFormat("",eventTicketsArray[k].getTicketPrice()+"",true));
						}
						
						totalFee+=Double.parseDouble(CurrencyFormat.getCurrencyFormat("",eventTicketsArray[k].getTicketProcessFee()+"",true));
						
						eachTicketJSON.put("charging_fee",CurrencyFormat.getCurrencyFormat("",eventTicketsArray[k].getTicketProcessFee()+"",true));
						eachTicketJSON.put("actual_fee",CurrencyFormat.getCurrencyFormat("",eventTicketsArray[k].getTicketProcessFee()+"",true));
						eachTicketJSON.put("id",eventTicketsArray[k].getTicketId());
						if("Active".equalsIgnoreCase(eventTicketsArray[k].getTicketStatus())){
							eachTicketJSON.put("available","y");
						}
						else
							eachTicketJSON.put("available","n");
						
						if("donationType".equalsIgnoreCase(eventTicketsArray[k].getTicketType())){
							eachTicketJSON.put("is_donation","y");
							try{
								if(lockedQuantity.get(eventTicketsArray[k].getTicketId())!=null)									
									eachTicketJSON.put("donation_amount",Double.parseDouble(lockedQuantity.get(eventTicketsArray[k].getTicketId())));
								else
									eachTicketJSON.put("donation_amount",0);
							}catch(Exception e){
								System.out.println("exc"+e.getMessage());
								eachTicketJSON.put("donation_amount",0);
							}
							
						}else{
							System.out.println("attendee ticketid"+eventTicketsArray[k].getTicketId());
							eachTicketJSON.put("is_donation","n");
							if(lockedQuantity.get(eventTicketsArray[k].getTicketId())!=null)
								eachTicketJSON.put("ticket_selected",Integer.parseInt(lockedQuantity.get(eventTicketsArray[k].getTicketId())));
							else
								eachTicketJSON.put("ticket_selected",0);
						}
						
						String shortmsg="";
						eachTicketJSON.put("availability_msg","");
						eachTicketJSON.put("min",eventTicketsArray[k].getTicketMinQty()+"");
						eachTicketJSON.put("max",eventTicketsArray[k].getTicketMaxQty()+"");
						eachTicketJSON.put("desc",eventTicketsArray[k].getTicketDescription());
						if(eventTicketsArray[k].isMemberTicket())
							eachTicketJSON.put("is_member_ticket","y");
						
						System.out.println(" *** 000 BTicketsJson: source: "+source+" getIsAtDoor: "+eventTicketsArray[k].getIsAtDoor());
						
						if("Closed".equals(eventTicketsArray[k].getTicketStatus())&&"yes".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.closedtickets.status","yes")) && "widget".equalsIgnoreCase(source)){
							eachTicketJSON.put("availability_msg",GenUtil.getHMvalue(configMap,"event.closedtickets.statusmessage","Closed"));
							if("yes".equals(GenUtil.getHMvalue(configMap,"event.closedtickets.strikethrough","no")))
								eachTicketJSON.put("strike","Y");
							eachTicketJSON.put("available","n");
							//if("y".equalsIgnoreCase(eventTicketsArray[k].getIsAtDoor()))
							eachGroupTicketsJSON.add(eachTicketJSON);
						}
						else if("Sold Out".equals(eventTicketsArray[k].getTicketStatus())&&"yes".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.soldouttickets.status","yes")) && "widget".equalsIgnoreCase(source)){
							if("yes".equals(GenUtil.getHMvalue(configMap,"event.soldouttickets.strikethrough","no")))
								eachTicketJSON.put("strike","y");
							eachTicketJSON.put("availability_msg",GenUtil.getHMvalue(configMap,"event.soldouttickets.statusmessage","SOLD OUT"));
							eachTicketJSON.put("available","n");
							eachGroupTicketsJSON.add(eachTicketJSON);
						}
						else if("NOT_STARTED".equals(eventTicketsArray[k].getTicketStatus())){
							if("yes".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.notyetstartedtickets.status","no")) && "widget".equalsIgnoreCase(source)){
								System.out.println(" *** 111 BTicketsJson: source: "+source+" getIsAtDoor: "+eventTicketsArray[k].getIsAtDoor());
								notStarted(eventTicketsArray[k],configMap,mgrConfigMessages,eachTicketJSON);
								eachGroupTicketsJSON.add(eachTicketJSON);
							}
							if(!"widget".equalsIgnoreCase(source) && "Y".equalsIgnoreCase(eventTicketsArray[k].getIsAtDoor())){
								System.out.println(" *** 222 BTicketsJson: source: "+source+" getIsAtDoor: "+eventTicketsArray[k].getIsAtDoor());
								notStarted(eventTicketsArray[k],configMap,mgrConfigMessages,eachTicketJSON);
								eachGroupTicketsJSON.add(eachTicketJSON);
							}
						}
						else if("Active".equals(eventTicketsArray[k].getTicketStatus())){
							if("yes".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.activetickets.status","yes")) && "widget".equalsIgnoreCase(source)){
								System.out.println(" *** 333 BTicketsJson: source: "+source+" getIsAtDoor: "+eventTicketsArray[k].getIsAtDoor());
								activeTicket(eventTicketsArray[k],configMap,mgrConfigMessages,eachTicketJSON);
								eachGroupTicketsJSON.add(eachTicketJSON);
							}
							if(!"widget".equalsIgnoreCase(source) && "Y".equalsIgnoreCase(eventTicketsArray[k].getIsAtDoor())){
								System.out.println(" *** 444 BTicketsJson: source: "+source+" getIsAtDoor: "+eventTicketsArray[k].getIsAtDoor());
								activeTicket(eventTicketsArray[k],configMap,mgrConfigMessages,eachTicketJSON);
								eachGroupTicketsJSON.add(eachTicketJSON);
							}
						}
						
					}catch(Exception e){
						System.out.println("Exception is is"+e.getMessage());
					}
				}
				if(eachGroupTicketsJSON.size()==1&&"".equals(eachGroup.getTicketGroupName())){
					eachGroupTicketsJSON.get(0).put("type", "ticket");
					tickets.put(eachGroupTicketsJSON.get(0));
				}else if(eachGroupTicketsJSON.size()!=0){
					JSONObject tempObject=new JSONObject();
					tempObject.put("type", "group");
					tempObject.put("id",eachGroup.getTicketGroupId());
					tempObject.put("desc",eachGroup.getTicketGroupDescription());
					tempObject.put("name",eachGroup.getTicketGroupName());
					tempObject.put("tickets", eachGroupTicketsJSON);
					tickets.put(tempObject);
				}
			}
			if(totalFee>0)
				ticketsJSON.put("feecolrequeired","Y");
			else
				ticketsJSON.put("feecolrequeired","N");
			System.out.println("the final total fee is:::"+totalFee);
			ticketsJSON.put("items", tickets);
			endTime = System.currentTimeMillis();
			 System.out.println("time for processing collection values "+ (endTime - startTime));
		}catch(Exception e){
			System.out.println("Exception occured in BTicketsJson.getTicketsJSON()  is: "+e.getMessage()+"eid:"+eid);
			e.printStackTrace();
		}
		return ticketsJSON;	
		
	}
	
	void notStarted(EventTicket eventTicket,HashMap configMap,HashMap<String,String> mgrConfigMessages,JSONObject eachTicketJSON){
		try{
			String shortmsg="";
			eachTicketJSON.put("availability_msg","NA");
			eachTicketJSON.put("available","y");
			
			if("yes".equals(GenUtil.getHMvalue(configMap,"event.notyetstartedtickets.showstartdate","yes"))){
				String format=GenUtil.getHMvalue(configMap,"event.ticketsale.startdatewithnotime","");
				shortmsg=format.replace("**Startdate**",eventTicket.getTicketStartDate());
			}
			if("yes".equals(GenUtil.getHMvalue(configMap,"event.notyetstartedtickets.showstartdate","yes"))&&"yes".equals(GenUtil.getHMvalue(configMap,"event.notyetstartedtickets.showtime","yes"))){
				String format=GenUtil.getHMvalue(configMap,"event.ticketsale.startdatewithtime","");
				shortmsg=format.replace("**Startdate**",eventTicket.getTicketStartDate());
				shortmsg=shortmsg.replace("**Starttime**",eventTicket.getTicketStartTime());
			}
			if("yes".equals(GenUtil.getHMvalue(configMap,"event.notyetstartedtickets.showenddate","yes"))){
				String format=GenUtil.getHMvalue(configMap,"event.ticketsale.enddatewithnotime","");
				shortmsg=format.replace("**Enddate**",eventTicket.getTicketEndDate());
			}
			if("yes".equals(GenUtil.getHMvalue(configMap,"event.notyetstartedtickets.showenddate","yes"))&&"yes".equals(GenUtil.getHMvalue(configMap,"event.notyetstartedtickets.showtime","yes"))){
				String format=GenUtil.getHMvalue(configMap,"event.ticketsale.enddatewithtime","");
				shortmsg=format.replace("**Enddate**",eventTicket.getTicketEndDate());
				shortmsg=shortmsg.replace("**Endtime**",eventTicket.getTicketEndTime());
			}
			if("yes".equals(GenUtil.getHMvalue(configMap,"event.notyetstartedtickets.showstartdate","yes"))&&"yes".equals(GenUtil.getHMvalue(configMap,"event.notyetstartedtickets.showenddate","yes"))){
				String format=GenUtil.getHMvalue(configMap,"event.ticketsale.bothwithnotime","");
				shortmsg=format.replace("**Startdate**",eventTicket.getTicketStartDate());
				shortmsg=shortmsg.replace("**Enddate**",eventTicket.getTicketEndDate());
				//shortmsg=eventTicket.getTicketStartDate()+" - "+eventTicket.getTicketEndDate();
			}
			if("yes".equals(GenUtil.getHMvalue(configMap,"event.notyetstartedtickets.showstartdate","yes"))&&"yes".equals(GenUtil.getHMvalue(configMap,"event.notyetstartedtickets.showenddate","yes"))&&"yes".equals(GenUtil.getHMvalue(configMap,"event.notyetstartedtickets.showtime","yes"))){
				String format=GenUtil.getHMvalue(configMap,"event.ticketsale.bothwithtime","");
				shortmsg=format.replace("**Startdate**",eventTicket.getTicketStartDate());
				shortmsg=shortmsg.replace("**Enddate**",eventTicket.getTicketEndDate());
				shortmsg=shortmsg.replace("**Starttime**",eventTicket.getTicketStartTime());
				shortmsg=shortmsg.replace("**Endtime**",eventTicket.getTicketEndTime());
			}
			eachTicketJSON.put("small_desc",shortmsg);
			eachTicketJSON.put("mgr_config_msg",(mgrConfigMessages.get(eventTicket.getTicketId())!=null)?mgrConfigMessages.get(eventTicket.getTicketId()):"");
		}catch(Exception e){
			System.out.println("Exception in notStarted is::: "+e.getMessage());
		}
		
	}
	
	void activeTicket(EventTicket eventTicket,HashMap configMap,HashMap<String,String> mgrConfigMessages,JSONObject eachTicketJSON){
		try{
			String shortmsg="";
			if("yes".equals(GenUtil.getHMvalue(configMap,"event.activetickets.showstartdate","yes"))){
				String format=GenUtil.getHMvalue(configMap,"event.ticketsale.startdatewithnotime","");
				shortmsg=format.replace("**Startdate**",eventTicket.getTicketStartDate());
			}
			if("yes".equals(GenUtil.getHMvalue(configMap,"event.activetickets.showstartdate","yes"))&&"yes".equals(GenUtil.getHMvalue(configMap,"event.activetickets.showtime","yes"))){
				String format=GenUtil.getHMvalue(configMap,"event.ticketsale.startdatewithtime","");
				shortmsg=format.replace("**Startdate**",eventTicket.getTicketStartDate());
				shortmsg=shortmsg.replace("**Starttime**",eventTicket.getTicketStartTime());
			}
			if("yes".equals(GenUtil.getHMvalue(configMap,"event.activetickets.showenddate","yes"))){
				String format=GenUtil.getHMvalue(configMap,"event.ticketsale.enddatewithnotime","");
				//System.out.println("format===="+format);
				shortmsg=format.replace("**Enddate**",eventTicket.getTicketEndDate());
			}
			if("yes".equals(GenUtil.getHMvalue(configMap,"event.activetickets.showenddate","yes"))&&"yes".equals(GenUtil.getHMvalue(configMap,"event.activetickets.showtime","yes"))){
				String format=GenUtil.getHMvalue(configMap,"event.ticketsale.enddatewithtime","");
				shortmsg=format.replace("**Enddate**",eventTicket.getTicketEndDate());
				shortmsg=shortmsg.replace("**Endtime**",eventTicket.getTicketEndTime());
			}
			if("yes".equals(GenUtil.getHMvalue(configMap,"event.activetickets.showstartdate","yes"))&&"yes".equals(GenUtil.getHMvalue(configMap,"event.activetickets.showenddate","yes"))){
				String format=GenUtil.getHMvalue(configMap,"event.ticketsale.bothwithnotime","");
				shortmsg=format.replace("**Startdate**",eventTicket.getTicketStartDate());
				shortmsg=shortmsg.replace("**Enddate**",eventTicket.getTicketEndDate());
			}
			if("yes".equals(GenUtil.getHMvalue(configMap,"event.activetickets.showstartdate","yes"))&&"yes".equals(GenUtil.getHMvalue(configMap,"event.activetickets.showenddate","yes"))&&"yes".equals(GenUtil.getHMvalue(configMap,"event.activetickets.showtime","yes"))){
				String format=GenUtil.getHMvalue(configMap,"event.ticketsale.bothwithtime","");
				shortmsg=format.replace("**Startdate**",eventTicket.getTicketStartDate());
				shortmsg=shortmsg.replace("**Enddate**",eventTicket.getTicketEndDate());
				shortmsg=shortmsg.replace("**Starttime**",eventTicket.getTicketStartTime());
				shortmsg=shortmsg.replace("**Endtime**",eventTicket.getTicketEndTime());
			}
			eachTicketJSON.put("small_desc",shortmsg);
			eachTicketJSON.put("mgr_config_msg",(mgrConfigMessages.get(eventTicket.getTicketId())!=null)?mgrConfigMessages.get(eventTicket.getTicketId()):"");
		}catch(Exception e){
			System.out.println("Exception in activeTicket is::: "+e.getMessage());
		}
		
	}
	
	HashMap<String, String> getQuantity(String tid,String eid){
		HashMap<String, String> quantityWithTicketID=new HashMap<String, String>();
		String query="select ticketid, qty,tickettype,finalprice from event_reg_ticket_details_temp where tid=? and eid=?";
		DBManager dbManager=new DBManager();
		StatusObj statusObj=dbManager.executeSelectQuery(query,new String[]{tid,eid});
		if(statusObj.getStatus()){
			for(int i=0;i<statusObj.getCount();i++){
				if( "donationType".equalsIgnoreCase(dbManager.getValue(i, "tickettype", "")))
					quantityWithTicketID.put( dbManager.getValue(i, "ticketid", "0"),dbManager.getValue(i, "finalprice", "0"));
				else
					quantityWithTicketID.put( dbManager.getValue(i, "ticketid", "0"),dbManager.getValue(i, "qty", "0"));
			}	
		}		
		System.out.println("tickets with qty ::"+quantityWithTicketID);
		return quantityWithTicketID;		
	}
	
	public HashMap<String,String> getTicketMessage(String eventid,String eventdate){
		HashMap<String,String> returnMap=new HashMap<String,String>();
		HashMap<String,String> hashMap=new HashMap<String,String>();
		HashMap<String,String> rec_hm=new HashMap<String,String>();
		DBManager db=new DBManager();
		StatusObj sb=null;

		String checkAvalability=DbUtil.getVal("select 'y' from ticketsavailability_display_formats where eventid=?",new String[]{eventid});
		checkAvalability=checkAvalability==null?"":checkAvalability;
		if("".equals(checkAvalability))
			return returnMap;
		
		String hold_qty="select sum(locked_qty) as holdqty,ticketid  from event_reg_locked_tickets where eventid=? and tid not in (select tid from event_reg_transactions where eventid=?) group by ticketid";
		try{
			if(!"".equals(eventdate)){
				String rec_qry="select ticketid,soldqty from reccurringevent_ticketdetails where eventid=cast(? as numeric)and eventdate=?";
				sb=db.executeSelectQuery(rec_qry,new String[]{eventid,eventdate});
				if(sb.getStatus()){
					for(int i=0;i<sb.getCount();i++){
						rec_hm.put(db.getValue(i,"ticketid",""),db.getValue(i,"soldqty",""));
					}
				}
				hold_qty="select sum(locked_qty) as holdqty,ticketid  from event_reg_locked_tickets where eventid=? and tid not in (select tid from event_reg_transactions where eventid=?) and eventdate=? group by ticketid";
				sb=db.executeSelectQuery(hold_qty,new String[]{eventid,eventid,eventdate});

			}
			else{
				sb=db.executeSelectQuery(hold_qty,new String[]{eventid,eventid});

			}
			if(sb.getStatus()){
				for(int i=0;i<sb.getCount();i++){
					hashMap.put("hold_"+db.getValue(i, "ticketid", ""),db.getValue(i, "holdqty", ""));
				}
			}
			String query="select a.price_id as ticketid,a.max_ticket as capacity,a.sold_qty as soldoutqty,(a.max_ticket-a.sold_qty) as remainingqty,c.display_format as format from price a ,ticketsfordisplayformats b,ticketsavailability_display_formats c where  c.eventid=? and a.price_id=b.ticketid and b.formatid=c.formatid and c.eventid=b.eventid";

			sb=db.executeSelectQuery(query,new String[]{eventid});

			if(sb.getStatus()){

				for(int i=0;i<sb.getCount();i++){
					String tktid=db.getValue(i,"ticketid","");
					String format=db.getValue(i,"format","");
					String holdQty=(hashMap.get("hold_"+tktid)==null)?"0":hashMap.get("hold_"+tktid);
					if(!"".equals(eventdate)){
						if(	rec_hm.containsKey(tktid)){
							int remqty=Integer.parseInt(db.getValue(i,"capacity",""))-Integer.parseInt((String) rec_hm.get(tktid));
							returnMap.put(tktid,format.replace("$soldOutQty",rec_hm.get(tktid)).replace("$capacity", db.getValue(i,"capacity","")).replace("$onHoldQty", holdQty).replace("$remainingQty", ""+remqty));
							
						}else{
							returnMap.put(tktid,format.replace("$soldOutQty","0").replace("$onHoldQty", holdQty).replace("$remainingQty", db.getValue(i,"capacity","")));
							
						}
					}else
						returnMap.put(tktid,format.replace("$soldOutQty",db.getValue(i,"soldoutqty","")).replace("$capacity", db.getValue(i,"capacity","")).replace("$onHoldQty", holdQty).replace("$remainingQty",db.getValue(i,"remainingqty","")));
					
					//   sold:$soldOutQty cap:$capacity rem:$remainingQty hold:$onHoldQty 
				}
			}
		}catch(Exception e){System.out.println(" in exception retufn map is::"+returnMap);}
		
		System.out.println("retufn map is::"+returnMap);
		return returnMap;
	}

}
