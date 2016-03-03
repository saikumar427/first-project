<%@page import="com.eventbee.general.DbUtil"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.Map.Entry"%>
<%@page import="java.util.Set"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.eventbee.general.StatusObj"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.eventbee.general.DBManager"%>
<%!
public static Boolean deleteTransaction(String eid, String tid) {
	System.out.println("deleteTransaction tid: "+tid+" eid: "+eid);
	String configid=DbUtil.getVal("select config_id from eventinfo where eventid=CAST(? AS BIGINT)",new String[]{eid});
	String isrecurr=DbUtil.getVal("select value from config where name='event.recurring' and config_id=CAST(? AS INTEGER)",new String[]{configid});
	StatusObj statob = DbUtil.executeUpdateQuery(
					"update event_reg_transactions set paymentstatus=? where tid=? and eventid=?",
					new String[] { "Cancelled", tid, eid });
	if("Y".equals(isrecurr)) rec_updateSoldQty(tid,eid,"-1");
	else updateSoldQty(tid, eid, "-1");
	
	if(statob.getStatus())
		return true;
	else
		return false;
}


public static void rec_updateSoldQty(String tid,String eid,String factor){
	System.out.println("rec_updateSoldQty tid: "+tid+" eid: "+eid+" factor: "+factor);
	StatusObj statobj = null;
	DBManager dbmanager = new DBManager();
	String TRN_TICKETS_SELECT_QUERY = "select ticketid,sum(ticketqty) as qty from "
			+ " transaction_tickets where tid=? and eventid=? group by ticketid";

	String rec_soldqty = "update reccurringevent_ticketdetails set soldqty=soldqty+CAST(? AS INTEGER)"
			+ " where ticketid=CAST(? AS BIGINT) and eventid=CAST(? AS BIGINT) and eventdate in(select eventdate"
			+" from event_reg_transactions where tid=? and eventid=?)";
	statobj = dbmanager.executeSelectQuery(TRN_TICKETS_SELECT_QUERY,
			new String[] { tid, eid });

	int count = statobj.getCount();
	if (statobj.getStatus()) {
		for (int k = 0; k < count; k++) {
			String ticketid = (String) dbmanager
					.getValue(k, "ticketid", "");
			String qty = (String) dbmanager.getValue(k, "qty", "");
			int qtytemp = Integer.parseInt(qty) * Integer.parseInt(factor);
			String temp = Integer.toString(qtytemp);
			StatusObj statobj1 = DbUtil.executeUpdateQuery(rec_soldqty,
					new String[] { temp, ticketid, eid, tid,eid});
		} // end for()
	} // end if()

}
static String SOLDQTY_UPDATE = "update price set sold_qty=sold_qty+CAST(? AS INTEGER) where price_id=CAST(? AS INTEGER) and evt_id=CAST(? AS BIGINT)";

public static void updateSoldQty(String tid, String eventid, String factor) {
	System.out.println("updateSoldQty tid: "+tid+" eventid: "+eventid+" factor: "+factor);
	DBManager dbmanager = new DBManager();
	StatusObj statobj = null;
	String TRN_TICKETS_SELECT_QUERY = "select ticketid,sum(ticketqty) as qty from transaction_tickets where tid=? and eventid=? group by ticketid";
	statobj = dbmanager.executeSelectQuery(TRN_TICKETS_SELECT_QUERY,
			new String[] { tid, eventid });
	int count = statobj.getCount();
	if (statobj.getStatus()) {
		for (int k = 0; k < count; k++) {
			String ticketid = (String) dbmanager
					.getValue(k, "ticketid", "");
			String qty = (String) dbmanager.getValue(k, "qty", "");
			int qtytemp = Integer.parseInt(qty) * Integer.parseInt(factor);
			String temp = Integer.toString(qtytemp);
			StatusObj statobj1 = DbUtil.executeUpdateQuery(SOLDQTY_UPDATE,
					new String[] { temp, ticketid, eventid });
			System.out.println("soldqty updated for:"+ticketid+" effected rows:"+statobj1.getCount());
		} // end for()
	} // end if()
} // end method()


%>

<%	//Author: Venkat Reddy
	//Version: 0.1
	//File: getSellerTransactions.jsp 
	//Created: 08/06/2014 
	//Modified: 11/06/2014 by venkat reddy
%>

<%@page trimDirectiveWhitespaces="true"%>
<%@ page language="java"
	contentType="application/json; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>		
<%
String sellerId=request.getParameter("seller_id");
String apiKey=request.getParameter("api_key");
String transactionId=request.getParameter("transaction_id");
String eventId=request.getParameter("event_id");


JSONObject responseObject=new JSONObject();
if (sellerId == null ||"".equals(sellerId)||apiKey == null||"".equals(apiKey)||transactionId == null ||"".equals(transactionId)||eventId == null||"".equals(eventId)){
	responseObject.put("status", "fail");
	responseObject.put("reason", "required parameters missing");
	out.println(responseObject.toString(2));
	return;
}

if(deleteTransaction(eventId,transactionId  )){
	responseObject.put("status", "success");
	out.println(responseObject.toString(2));
}else{
	responseObject.put("status", "fail");
	responseObject.put("reason", "Invalid data");
	out.println(responseObject.toString(2));
}

%>