<%@ page import="com.event.dbhelpers.*,com.eventregister.*,com.eventbee.general.*"%>
<%@ page import="java.util.*,java.util.ArrayList,java.util.HashMap,java.util.List,org.json.JSONArray,org.json.JSONObject"%>
<%
String eid=request.getParameter("eid");
SeatingDBHelper seatingdbhelper=new SeatingDBHelper();
ArrayList ticketid=seatingdbhelper.getAllticketid(eid);
JSONObject seatticketid=new JSONObject();
seatticketid.put("seatticketid",ticketid);
out.println(seatticketid.toString());
%>