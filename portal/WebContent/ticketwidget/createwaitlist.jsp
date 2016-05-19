<%@page import="java.util.HashMap"%>
<%@page import="com.eventbee.general.EbeeConstantsF"%>
<%@page import="com.eventbee.util.CoreConnector"%>
<%@page import="org.json.JSONArray"%>
<%@page import="com.eventbee.general.StatusObj"%>
<%@page import="com.eventbee.general.EncodeNum"%>
<%@page import="com.eventbee.general.DbUtil"%>
<%@page import="com.eventbee.general.DBManager"%>
<%@page import="org.json.JSONObject"%>
<%!
public void sendEmail(String eid,String email,String name){
	
	HashMap<String,String> inputparams=new HashMap<String,String>();
	String data="";
	inputparams.put("email",email);
	inputparams.put("eid",eid);
	inputparams.put("name",name);
	String serveraddress=EbeeConstantsF.get("serveraddress","www.eventbee.com");
	System.out.println("the server address::"+serveraddress);
	try{
		CoreConnector cc1=new CoreConnector("http://"+serveraddress+"/attendee/utiltools/sendWaitListMail.jsp");
		cc1.setArguments(inputparams);
		cc1.setTimeout(50000);
		data=cc1.MGet();
	}catch(Exception e){
		System.out.println("Exception Occured while Sending waitListMail:"+e.getMessage());
	}
}
%>
<%
	JSONObject responseData = new JSONObject();
	String eventID = request.getParameter("event_id");
	String eventDate = request.getParameter("event_date");
	String notes = request.getParameter("notes");
	eventID = eventID == null ? "" : eventID;
	eventDate = eventDate == null ? "" : eventDate;
	notes = notes == null ? "" : notes;
     String userEmail="";
	JSONObject userData = null;
	try {
		try {
			userData = new JSONObject(
					request.getParameter("user_details"));
			
			userEmail=userData.getString("email")==null?" ":userData.getString("email");
			
		} catch (Exception e) {
			responseData.put("status", "fail");
			responseData.put("reason", "invalid params");
			out.println(responseData.toString(2));
			return;
		}
		DBManager db = new DBManager();
		String waitListID = DbUtil.getVal(
				"select nextval('SEQ_attendeeid')", new String[] {});
		String waitListKey = "WK"
				+ EncodeNum.encodeNum(waitListID).toUpperCase();
		StatusObj statobj = null;
		String query = "insert into wait_list_transactions(notes,phone, status, wait_list_id,eventid,eventdate, updated_at, email, name, created_at)"
				+ "values (?, ?, 'Waiting', ?, cast(? as bigint), ?, now(), ?,  ?, now())";
		DbUtil.executeUpdateQuery(
				query,
				new String[] {notes,
						userData.getString("phone") == null ? ""
								: userData.getString("phone"),
						waitListKey,
						eventID,
						eventDate,
						userData.getString("email") == null ? ""
								: userData.getString("email"),
						userData.getString("name") == null ? ""
								: userData.getString("name") });
		String ticetsQtyString = request.getParameter("tickets_info");
		JSONArray tickets = new JSONArray(ticetsQtyString);
		for (int i = 0; i < tickets.length(); i++) {
			JSONObject eachTicket = tickets.getJSONObject(i);
			String inserQuery = "insert into wait_list_tickets(ticket_qty, ticket_name, wait_list_id, eventid, ticketid )"
					+ "values (cast(? as integer), ?, ?, cast(? as integer), cast(? as integer))";
			DbUtil.executeUpdateQuery(inserQuery, new String[] {
					eachTicket.getString("qty"), eachTicket.getString("ticket_name"),waitListKey, eventID,
					eachTicket.getString("ticket_id") });
			
		}
		responseData.put("status", "success");	
		if(!"".equals(userEmail))
		sendEmail(eventID,userEmail,userData.getString("name"));
	} catch (Exception e) {
		responseData.put("status", "fail");
		responseData.put("reason", "invalid params");
	}
	out.println(responseData.toString(2));
	
%>