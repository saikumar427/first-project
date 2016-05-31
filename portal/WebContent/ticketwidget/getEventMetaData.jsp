<%@page import="com.event.dbhelpers.CDisplayAttribsDB"%>
<%@page import="com.eventbee.general.GenUtil"%>
<%@page import="com.eventbee.cachemanage.CacheManager"%>
<%@page import="com.eventbee.general.DbUtil"%>
<%@page import="com.eventregister.CTicketsDB"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.json.JSONArray"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.eventbee.general.StatusObj"%>
<%@page import="com.eventbee.general.DBManager"%>
<%@ page import="com.eventbee.layout.DBHelper" %>
<%@page trimDirectiveWhitespaces="true"%>
<%@ include file="cors.jsp" %>
<%@ page language="java" contentType="application/json; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%
	String eid = request.getParameter("event_id");
	String apiKey = request.getParameter("api_key");
	JSONObject responseJSON = new JSONObject();
	if(eid==null||"".equals(eid)||apiKey==null||"".equals(apiKey)){
		responseJSON.put("status", "fail");
		responseJSON.put("reason", "required parameters missing");
		responseJSON.put("do_continue", false);
		out.println(responseJSON.toString(2));		
		return;
	}
	CTicketsDB ticketsDB=new CTicketsDB();
	boolean flag=ticketsDB.getBlockedInfo(eid);
	if(flag){
		responseJSON.put("status","blockedbytraffic");
		responseJSON.put("message","<span style='font-size: 14px'>There are more people buying tickets than available. You are now put in the queue, Please wait you will be taken to event page once tickets become available. We'll automatically try after few seconds.</span><br/><img src='/main/images/home/trafficloader.gif'>");
		responseJSON.put("remaintime","30");
		responseJSON.put("do_continue", false);
		out.println(responseJSON.toString(2));	
		return;
	}

	responseJSON.put("status", "success");
	responseJSON.put("do_continue", true);
	DBManager db = new DBManager();
	Map eventinfoMap=CacheManager.getData(eid, "eventinfo");
	//HashMap<String,String> configMap =ticketsDB.getConfigValuesFromDb(eid);	
	HashMap<String,String> configMap =(HashMap)eventinfoMap.get("configmap");
	String isRecurring=configMap.get("event.recurring");
	String hasSeating=configMap.get("event.seating.enabled");
	String isRsvp=configMap.get("event.rsvp.enabled");
	String isPriority = configMap.get("event.priority.enabled");
	String venueid=configMap.get("event.seating.venueid");
	venueid=venueid==null?"0":venueid;
	if(!"Y".equalsIgnoreCase(isPriority)||isPriority==null)
		responseJSON.put("is_priority",false);
	else
		responseJSON.put("is_priority",true);
	if(!"yes".equalsIgnoreCase(hasSeating)||hasSeating==null)
		responseJSON.put("has_seating",false);
	else
		responseJSON.put("has_seating",true);
	if(!"yes".equalsIgnoreCase(isRsvp)||isRsvp==null)
		responseJSON.put("is_rsvp",false);
	else
		responseJSON.put("is_rsvp",true);
	
	responseJSON.put("venueid",venueid);
	if(!"y".equalsIgnoreCase(isRecurring)||isRecurring==null){
		responseJSON.put("is_recurring",false);
		//String status = DbUtil.getVal("select status from eventinfo where eventid=CAST(? AS BIGINT)",new String[]{eid});
		String status=(String)eventinfoMap.get("status");
		if("pending".equalsIgnoreCase(status)||"cancel".equalsIgnoreCase(status)){
			responseJSON.put("do_continue", false);
			responseJSON.put("message","Tickets currently not available" );			
		}else if(status==null){
			JSONObject temp=new JSONObject();
			temp.put("do_continue", false);
			temp.put("message","Event unavailable" );
			out.println(temp.toString(2));
			return;
		}
		
	}else{
		responseJSON.put("is_recurring",true);
		//String selectTitle=DbUtil.getVal("select attrib_value from custom_event_display_attribs where attrib_name='event.reg.recurringdates.label' and eventid=CAST(? AS BIGINT)", new String[]{eid});
		String lang="en_US";
		if(!"".equals(eid) && eid !=null) lang=DBHelper.getLanguageFromDB(eid);
		HashMap<String,String> disAttribsForKeys=new HashMap<String,String>();
		String selectTitle=CDisplayAttribsDB.getAttribValuesForKeys(eid, "RegFlowWordings", lang, new String [] {"event.reg.recurringdates.label"}).get("event.reg.recurringdates.label");
		if(selectTitle!=null)
			responseJSON.put("date_select_label",selectTitle);
		else
			responseJSON.put("date_select_label","Select a date and time to attend:");
		
		responseJSON.put("date_default_option","-- Select a date --");
			
		String query = "select info.eventid as eventid,to_char(dates.zone_startdate+cast(cast(to_timestamp(COALESCE(dates.zone_start_time,'00'),'HH24:MI:SS') as text) as time ),'Dy, Mon DD, YYYY HH12:MI AM') as  edate from eventinfo info, event_dates dates where info.eventid=dates.eventid and info.eventid=CAST(? AS BIGINT)";
		StatusObj statusObj = db.executeSelectQuery(query,
				new String[] {eid });
		JSONArray dates = new JSONArray();
		if (statusObj.getStatus()) {
			JSONObject eachDate=null;
			for (int i = 0; i < statusObj.getCount(); i++) {
				eachDate=new JSONObject();
				eachDate.put("name", db.getValue(i, "edate", ""));
				eachDate.put("value", db.getValue(i, "edate", ""));
				dates.put(eachDate);
			}
		}
		responseJSON.put("dates",dates);
	}
	
	out.println(responseJSON.toString(2));
%>