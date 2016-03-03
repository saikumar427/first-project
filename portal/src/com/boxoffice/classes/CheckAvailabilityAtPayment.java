package com.boxoffice.classes;

import com.eventbee.general.DBManager;
import com.eventbee.general.StatusObj;
import com.eventregister.BRegistrationTiketingManager;

public class CheckAvailabilityAtPayment {

	/**
	 * @param args
	 */
	public String paymentPageTicketAvailabilityCheck(String eid,String tid,String paytype){
		BRegistrationTiketingManager regManager = new BRegistrationTiketingManager();
		regManager.autoLocksAndBlockDelete(eid, tid, "checkavailabiltylevel");
		regManager.setEventRegTempAction(eid, tid, paytype);

		DBManager dbManager = new DBManager();
		String errorMessage = "";
		String isEntryExist = "select eventid from event_reg_locked_tickets where tid=?";
		StatusObj status = dbManager.executeSelectQuery(isEntryExist,
				new String[] { tid });
		if (status.getStatus() && (status.getCount() > 0)) {
		} else {
			errorMessage = "Timedout";
		}
		if("".equalsIgnoreCase(errorMessage)){
			String soldQtyQuery = "select price_id from price a,event_reg_ticket_details_temp b, event_reg_details_temp c where b.tid=?"
					+ " and b.tid=c.tid and c.eventdate is null and a.price_id=b.ticketid and b.qty+a.sold_qty>a.max_ticket";

			StatusObj soldStatus = dbManager.executeSelectQuery(soldQtyQuery,
					new String[] { tid });
			if (soldStatus.getStatus() && soldStatus.getCount() > 0) {
				errorMessage = "maxqty";
			}
		}
		return errorMessage;
	}
	
}
