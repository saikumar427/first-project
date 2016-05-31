package com.eventregister;

import java.util.ArrayList;
import java.util.HashMap;

import org.json.JSONArray;
import org.json.JSONObject;

import com.event.dbhelpers.BDisplayAttribsDB;
import com.eventbee.general.DBManager;
import com.eventbee.general.DbUtil;
import com.eventbee.general.GenUtil;
import com.eventbee.general.StatusObj;
import com.eventbee.general.formatting.CurrencyFormat;

public class CTicketsJson {	
	CTicketsInfo ticketInfo=new CTicketsInfo();
	public JSONObject getTicketsJSON(String eid,HashMap<String, String> params){
		JSONObject ticketsJSON=new JSONObject(); 	
		JSONArray tickets=new JSONArray();
		HashMap<String, String> lockedQuantity=new HashMap<String, String>();
		HashMap<String, String> waitlistDetailsMap=new HashMap<String, String>();
		try{
			String tid=params.get("tid");
			ticketInfo.intialize(eid,params);
			if(!"".equals(params.get("wid")))
				waitlistDetailsMap=ticketInfo.getWaitListDetails(eid,params.get("wid"));
			ticketsJSON.put("disc_exists",ticketInfo.isDiscountExists);			
			
			HashMap<String,String> configMap=BDisplayAttribsDB.getAttribValues(eid,"TicketDisplayOptions");
			System.out.println(configMap);
			String descMode=(String) configMap.get("event.general.tktDescMode");
			if(descMode==null)
				descMode="collapse";
			ticketsJSON.put("ticket_desc_mode",descMode);
			descMode=(String) configMap.get("event.group.tktDescMode");
			if(descMode==null)
				descMode="collapse";
			ticketsJSON.put("ticket_group_desc_mode",descMode);

			String eventActivstatus=(String) configMap.get("event.activetickets.status");
			ticketsJSON.put("ticket_status",eventActivstatus);


			HashMap<String, String> regFlowWordings=BDisplayAttribsDB.getAttribValues(eid,"RegFlowWordings");
			JSONObject reg_flow_wordings=new JSONObject();
			reg_flow_wordings.put("apply_button_label",GenUtil.getHMvalue(regFlowWordings,"discount.code.applybutton.label","Apply Code"));
			reg_flow_wordings.put("order_button_label",GenUtil.getHMvalue(regFlowWordings,"event.reg.orderbutton.label","Buy Tickets"));
			reg_flow_wordings.put("process_fee_label",GenUtil.getHMvalue(regFlowWordings,"event.reg.processfee.label","Fee"));
			reg_flow_wordings.put("disc_box_label",GenUtil.getHMvalue(regFlowWordings,"event.reg.discount.box.label","Have a discount code, enter it here"));
			reg_flow_wordings.put("total_amount_label",GenUtil.getHMvalue(regFlowWordings,"event.reg.total.amount.label","Total"));
			reg_flow_wordings.put("tax_label",GenUtil.getHMvalue(regFlowWordings,"event.reg.tax.amount.label","Process Fee"));
			
			ticketsJSON.put("reg_flow_wordings", reg_flow_wordings);
			
			 Double taxExtra=0.00;
			   String taxPercent=DbUtil.getVal("select value from config where name='event.tax.amount' and config_id=(select config_id from eventinfo where eventid=CAST(? AS BIGINT))",new String[]{eid} );
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

			ArrayList<CTicketGroup> ticketsArray=ticketInfo.requiredTicketGroups;
			if(!"".equals(tid)||tid!=null)
				lockedQuantity=getQuantity(tid, eid);	
			//BTicketsInfo ticketInfo = new BTicketsInfo();
			HashMap<String,String> mgrConfigMessages=new HashMap<String, String>();
			HashMap<String,String> selectedSeats = new HashMap<String,String>();
			if("widget".equalsIgnoreCase(params.get("source")))	{	
				mgrConfigMessages=ticketInfo.getTicketMessage(eid,params.get("evtdate"));
				selectedSeats=ticketInfo.getSelectedSeats(eid,params.get("evtdate"),tid);
			}
			Double totalFee=0.0;
			
			for(int i=0;i<ticketsArray.size();i++){
				CTicketGroup eachGroup=(CTicketGroup)ticketsArray.get(i);
				CEventTicket eventTicketsArray[]=(CEventTicket[])eachGroup.getGroupTicketsArray();
				ArrayList<JSONObject> eachGroupTicketsJSON=new ArrayList<JSONObject>();			

				for(int k=0;k<eventTicketsArray.length;k++){
					try{
						JSONObject eachTicketJSON=new JSONObject();
						/*(isLooseTicket)
							eachTicketJSON.put("isLooseTicket","Y");
						else
							eachTicketJSON.put("isLooseTicket","N");*/

						eachTicketJSON.put("name",eventTicketsArray[k].getTicketName());
						
						eachTicketJSON.put("actual_price",CurrencyFormat.getCurrencyFormat("",eventTicketsArray[k].getTicketPrice()+"",true));
						if("".equals(params.get("disc_code"))){
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
							
						}
						else{
							System.out.println("attendee ticketid"+eventTicketsArray[k].getTicketId());
							eachTicketJSON.put("is_donation","n");
							if(lockedQuantity.get(eventTicketsArray[k].getTicketId())!=null)
								eachTicketJSON.put("ticket_selected",Integer.parseInt(lockedQuantity.get(eventTicketsArray[k].getTicketId())));
							else
								eachTicketJSON.put("ticket_selected",0);
							
							if("widget".equals(params.get("source"))){
								eachTicketJSON.put("seatIndexes",selectedSeats.containsKey(eventTicketsArray[k].getTicketId())?selectedSeats.get(eventTicketsArray[k].getTicketId()):new ArrayList());
							}
						}
						String shortmsg="";
						eachTicketJSON.put("availability_msg","");
						eachTicketJSON.put("min",eventTicketsArray[k].getTicketMinQty()+"");
						eachTicketJSON.put("max",eventTicketsArray[k].getTicketMaxQty()+"");
						eachTicketJSON.put("tkt_inc",eventTicketsArray[k].getTicketIncrement());
						eachTicketJSON.put("desc",eventTicketsArray[k].getTicketDescription());
						if(eventTicketsArray[k].isMemberTicket())
							eachTicketJSON.put("is_member_ticket","y");
						/*if(lockedQuantity.get(eventTicketsArray[k].getTicketId())!=null)
							eachTicketJSON.put("ticket_selected",Integer.parseInt(lockedQuantity.get(eventTicketsArray[k].getTicketId())));
						else
							eachTicketJSON.put("ticket_selected",0);*/

						/*if("Closed".equalsIgnoreCase(eventTicketsArray[k].getTicketStatus())){
								eachTicketJSON.put("available_msg","closed");
							}
							else if("Sold Out".equalsIgnoreCase(eventTicketsArray[k].getTicketStatus())){
								eachTicketJSON.put("available_msg","sold out");
							}
							else if("NOT_STARTED".equalsIgnoreCase(eventTicketsArray[k].getTicketStatus())){							
								eachTicketJSON.put("available_msg","Not yet started, will start on "+eventTicketsArray[k].getTicketStartDate());
							}	*/
						
						Boolean flag = true;
						if(!"".equals(params.get("wid")) && waitlistDetailsMap.containsKey(eventTicketsArray[k].getTicketId())){//for waitlist transaction
							eachTicketJSON.put("wid_status",waitlistDetailsMap.get("status"));
							if(!"Expired".equals(waitlistDetailsMap.get("status"))){
								eachTicketJSON.put("wid",waitlistDetailsMap.get("wid"));
								eachTicketJSON.put("wid_tktqty",waitlistDetailsMap.get("tktqty"));
								flag = false;
							}
						}else if("Y".equals(eventTicketsArray[k].getWaitListType())){//for put me waitlist
							eachTicketJSON.put("wait_li_type",eventTicketsArray[k].getWaitListType());
							eachTicketJSON.put("wait_li_limit",eventTicketsArray[k].getWaitListLimit());
							flag = false;
						}
						if("Closed".equals(eventTicketsArray[k].getTicketStatus())&&"yes".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.closedtickets.status","yes"))){
							eachTicketJSON.put("availability_msg",GenUtil.getHMvalue(configMap,"event.closedtickets.statusmessage","Closed"));
							if("yes".equals(GenUtil.getHMvalue(configMap,"event.closedtickets.strikethrough","no")))
								eachTicketJSON.put("strike","Y");
							eachTicketJSON.put("available","n");
							eachGroupTicketsJSON.add(eachTicketJSON);
						}
						else if("Sold Out".equals(eventTicketsArray[k].getTicketStatus())&&"yes".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.soldouttickets.status","yes"))){
							if("yes".equals(GenUtil.getHMvalue(configMap,"event.soldouttickets.strikethrough","no"))){
								if(flag)
									eachTicketJSON.put("strike","y");
								
							}
							eachTicketJSON.put("availability_msg",GenUtil.getHMvalue(configMap,"event.soldouttickets.statusmessage","SOLD OUT"));
							eachTicketJSON.put("available","n");
							eachGroupTicketsJSON.add(eachTicketJSON);
						}
						else if("NOT_STARTED".equals(eventTicketsArray[k].getTicketStatus())&&"yes".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.notyetstartedtickets.status","no"))){
							eachTicketJSON.put("availability_msg","NA");
							eachTicketJSON.put("available","y");
							if("yes".equals(GenUtil.getHMvalue(configMap,"event.notyetstartedtickets.showstartdate","yes"))){
								String format=GenUtil.getHMvalue(configMap,"event.ticketsale.startdatewithnotime","");
								shortmsg=format.replace("**Startdate**",eventTicketsArray[k].getTicketStartDate());
							}
							if("yes".equals(GenUtil.getHMvalue(configMap,"event.notyetstartedtickets.showstartdate","yes"))&&"yes".equals(GenUtil.getHMvalue(configMap,"event.notyetstartedtickets.showtime","yes"))){
								String format=GenUtil.getHMvalue(configMap,"event.ticketsale.startdatewithtime","");
								shortmsg=format.replace("**Startdate**",eventTicketsArray[k].getTicketStartDate());
								shortmsg=shortmsg.replace("**Starttime**",eventTicketsArray[k].getTicketStartTime());
							}
							if("yes".equals(GenUtil.getHMvalue(configMap,"event.notyetstartedtickets.showenddate","yes"))){
								String format=GenUtil.getHMvalue(configMap,"event.ticketsale.enddatewithnotime","");
								shortmsg=format.replace("**Enddate**",eventTicketsArray[k].getTicketEndDate());
							}
							if("yes".equals(GenUtil.getHMvalue(configMap,"event.notyetstartedtickets.showenddate","yes"))&&"yes".equals(GenUtil.getHMvalue(configMap,"event.notyetstartedtickets.showtime","yes"))){
								String format=GenUtil.getHMvalue(configMap,"event.ticketsale.enddatewithtime","");
								shortmsg=format.replace("**Enddate**",eventTicketsArray[k].getTicketEndDate());
								shortmsg=shortmsg.replace("**Endtime**",eventTicketsArray[k].getTicketEndTime());
							}
							if("yes".equals(GenUtil.getHMvalue(configMap,"event.notyetstartedtickets.showstartdate","yes"))&&"yes".equals(GenUtil.getHMvalue(configMap,"event.notyetstartedtickets.showenddate","yes"))){
								String format=GenUtil.getHMvalue(configMap,"event.ticketsale.bothwithnotime","");
								shortmsg=format.replace("**Startdate**",eventTicketsArray[k].getTicketStartDate());
								shortmsg=shortmsg.replace("**Enddate**",eventTicketsArray[k].getTicketEndDate());
								//shortmsg=eventTicketsArray[k].getTicketStartDate()+" - "+eventTicketsArray[k].getTicketEndDate();
							}
							if("yes".equals(GenUtil.getHMvalue(configMap,"event.notyetstartedtickets.showstartdate","yes"))&&"yes".equals(GenUtil.getHMvalue(configMap,"event.notyetstartedtickets.showenddate","yes"))&&"yes".equals(GenUtil.getHMvalue(configMap,"event.notyetstartedtickets.showtime","yes"))){
								String format=GenUtil.getHMvalue(configMap,"event.ticketsale.bothwithtime","");
								shortmsg=format.replace("**Startdate**",eventTicketsArray[k].getTicketStartDate());
								shortmsg=shortmsg.replace("**Enddate**",eventTicketsArray[k].getTicketEndDate());
								shortmsg=shortmsg.replace("**Starttime**",eventTicketsArray[k].getTicketStartTime());
								shortmsg=shortmsg.replace("**Endtime**",eventTicketsArray[k].getTicketEndTime());
							}
							eachTicketJSON.put("small_desc",shortmsg);
							eachTicketJSON.put("mgr_config_msg",(mgrConfigMessages.get(eventTicketsArray[k].getTicketId())!=null)?mgrConfigMessages.get(eventTicketsArray[k].getTicketId()):"");
							eachGroupTicketsJSON.add(eachTicketJSON);
						}


						else if("Active".equals(eventTicketsArray[k].getTicketStatus())&&"yes".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.activetickets.status","yes"))){
							if("yes".equals(GenUtil.getHMvalue(configMap,"event.activetickets.showstartdate","yes"))){
								String format=GenUtil.getHMvalue(configMap,"event.ticketsale.startdatewithnotime","");
								shortmsg=format.replace("**Startdate**",eventTicketsArray[k].getTicketStartDate());
							}
							if("yes".equals(GenUtil.getHMvalue(configMap,"event.activetickets.showstartdate","yes"))&&"yes".equals(GenUtil.getHMvalue(configMap,"event.activetickets.showtime","yes"))){
								String format=GenUtil.getHMvalue(configMap,"event.ticketsale.startdatewithtime","");
								shortmsg=format.replace("**Startdate**",eventTicketsArray[k].getTicketStartDate());
								shortmsg=shortmsg.replace("**Starttime**",eventTicketsArray[k].getTicketStartTime());
							}
							if("yes".equals(GenUtil.getHMvalue(configMap,"event.activetickets.showenddate","yes"))){
								String format=GenUtil.getHMvalue(configMap,"event.ticketsale.enddatewithnotime","");
								//System.out.println("format===="+format);
								shortmsg=format.replace("**Enddate**",eventTicketsArray[k].getTicketEndDate());
							}
							if("yes".equals(GenUtil.getHMvalue(configMap,"event.activetickets.showenddate","yes"))&&"yes".equals(GenUtil.getHMvalue(configMap,"event.activetickets.showtime","yes"))){
								String format=GenUtil.getHMvalue(configMap,"event.ticketsale.enddatewithtime","");
								shortmsg=format.replace("**Enddate**",eventTicketsArray[k].getTicketEndDate());
								shortmsg=shortmsg.replace("**Endtime**",eventTicketsArray[k].getTicketEndTime());
							}
							if("yes".equals(GenUtil.getHMvalue(configMap,"event.activetickets.showstartdate","yes"))&&"yes".equals(GenUtil.getHMvalue(configMap,"event.activetickets.showenddate","yes"))){
								String format=GenUtil.getHMvalue(configMap,"event.ticketsale.bothwithnotime","");
								shortmsg=format.replace("**Startdate**",eventTicketsArray[k].getTicketStartDate());
								shortmsg=shortmsg.replace("**Enddate**",eventTicketsArray[k].getTicketEndDate());
							}
							if("yes".equals(GenUtil.getHMvalue(configMap,"event.activetickets.showstartdate","yes"))&&"yes".equals(GenUtil.getHMvalue(configMap,"event.activetickets.showenddate","yes"))&&"yes".equals(GenUtil.getHMvalue(configMap,"event.activetickets.showtime","yes"))){
								String format=GenUtil.getHMvalue(configMap,"event.ticketsale.bothwithtime","");
								shortmsg=format.replace("**Startdate**",eventTicketsArray[k].getTicketStartDate());
								shortmsg=shortmsg.replace("**Enddate**",eventTicketsArray[k].getTicketEndDate());
								shortmsg=shortmsg.replace("**Starttime**",eventTicketsArray[k].getTicketStartTime());
								shortmsg=shortmsg.replace("**Endtime**",eventTicketsArray[k].getTicketEndTime());
							}
							eachTicketJSON.put("small_desc",shortmsg);
							eachTicketJSON.put("mgr_config_msg",(mgrConfigMessages.get(eventTicketsArray[k].getTicketId())!=null)?mgrConfigMessages.get(eventTicketsArray[k].getTicketId()):"");
							eachGroupTicketsJSON.add(eachTicketJSON);
						}							
						


					}catch(Exception e){
						System.out.println("Exception is is"+e.getMessage());
					}
				}// k close
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
		}catch(Exception e){
			System.out.println("Exception occured in getJsonTicketsData is"+e.getMessage()+"eid:"+eid);
		}
		
		return ticketsJSON;	

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


}
