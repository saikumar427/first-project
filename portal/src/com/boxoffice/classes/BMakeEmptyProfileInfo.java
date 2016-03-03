package com.boxoffice.classes;

import java.util.ArrayList;
import java.util.HashMap;
import com.eventbee.general.DbUtil;
import com.eventbee.general.EncodeNum;
import com.eventbee.general.EventbeeLogger;
import com.eventregister.BProfileActionDB;
import com.eventregister.BRegistrationTiketingManager;

public class BMakeEmptyProfileInfo {	
	public void makeEmptyProfileInfo(String seatingEnabled,String eid,String edate,String tid){

		BRegistrationTiketingManager regManager = new BRegistrationTiketingManager();
		BProfileActionDB profileActionDB= new BProfileActionDB();	


		ArrayList<HashMap<String, String>>  selTicketsList = regManager.getSelectedTickets(tid);

		HashMap<String,ArrayList<String>> seatingTickets = null;

		if ("Y".equalsIgnoreCase(seatingEnabled)) {		
			seatingTickets = profileActionDB.getSeatingCodeDetails(eid, tid, edate,selTicketsList);
		}
		try{
			String buyer_profileid = DbUtil.getVal(	"select nextval('SEQ_attendeeid')", new String[] {});
			for (int i = 0; i < selTicketsList.size(); i++) {	

				HashMap<String, String> ticketData =  selTicketsList.get(i);
				ArrayList<String> seatingData=null;		
				String ticketId = (String) ticketData.get("selectedTicket");
				String ticketType = (String) ticketData.get("type");
				String count = (String) ticketData.get("qty");

				String attendeeIds[] = DbUtil.getSeqVals("seq_attendeeId",Integer.parseInt(count));

				String seatCode = "", seatIndex = "";
				if("y".equalsIgnoreCase(seatingEnabled))
					seatingData =  seatingTickets.get(ticketId);

				for (int index = 0; index < Integer.parseInt(count); index++) {

					HashMap<String,String> basicProfile = new HashMap<String,String>();
					if("y".equalsIgnoreCase(seatingEnabled)){	
						try{
						seatCode = (String) seatingData.get(index);
						}catch(Exception e){seatCode = "";}
					} else{
						seatCode = "";
					}
					basicProfile.put("seatcode", seatCode);
					String attendeeKey = "AK"+ EncodeNum.encodeNum(attendeeIds[index]).toUpperCase();

					basicProfile.put("fname", "");
					basicProfile.put("lname", "");
					basicProfile.put("email", "");
					basicProfile.put("phone", "");
					basicProfile.put("profileid", attendeeIds[index]);
					basicProfile.put("profilekey", attendeeKey);
					basicProfile.put("eventid", eid);
					basicProfile.put("tid", tid);
					basicProfile.put("ticketid", ticketId);
					basicProfile.put("tickettype", ticketType);
					basicProfile.put("profile_setid", buyer_profileid);
					EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, " (Box office)Empty data profileformaction.jsp", "(Box Office)before Updating  profile data---------"+tid+"--------"+basicProfile, "", null);
							
					if ("y".equalsIgnoreCase(seatingEnabled)) {
						try {
							ArrayList<String> seating = seatingTickets.get(ticketId + "_index");
							if (seating.get(index) != null
									|| !"null".equals(seating.get(index)))
								seatIndex=(String) seating.get(index);
						} catch (Exception e) {seatIndex="";	}
					}		
					basicProfile.put("seat_index", seatIndex);
					profileActionDB.updateBaseProfile(basicProfile);	
					
				}
			} //selected Tickets loop close
			
			String profilekey = "AK"
					+ EncodeNum.encodeNum(buyer_profileid).toUpperCase();
			HashMap<String,String> buyerBasInfo = new HashMap<String,String>();
			buyerBasInfo.put("fname", "");
			buyerBasInfo.put("lname", "");
			buyerBasInfo.put("email", "");
			buyerBasInfo.put("phone", "");
			buyerBasInfo.put("profileid", buyer_profileid);
			buyerBasInfo.put("profilekey", profilekey);
			buyerBasInfo.put("tid", tid);
			buyerBasInfo.put("eventid", eid);
			//EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "profileformaction.jsp", "before Updating  buyer data---------"+tid+"--------"+buyerBasInfo, "", null);

			/*db*/profileActionDB.inserBuyerInfo(buyerBasInfo);			
			
			
		}catch(Exception e){

		}
		
		
		
		
		
		
	}
}
