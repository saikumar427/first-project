<%@page import="java.util.List"%>
<%@page import="com.eventbee.general.DbUtil"%>
<%@page import="com.event.dbhelpers.DisplayAttribsDB"%>
<%@page import="com.eventbee.general.StatusObj"%>
<%@page import="com.eventbee.general.DBManager"%>
<%@ include file='/globalprops.jsp' %>
<%@ page import="org.json.JSONObject"%>
<%@page import="java.util.ArrayList"%>
<%
JSONObject fieldListObject=new JSONObject();
JSONObject priorityListData=new JSONObject();
ArrayList<JSONObject> list=new ArrayList<JSONObject>();
String eventId = request.getParameter("eid");
String powertype = request.getParameter("powertype");
String listsQuery="select list_id,list_name,field1,field2,nooffields from priority_list where eventid=CAST(? AS BIGINT) order by list_id";
DBManager dbmanager=new DBManager();
StatusObj statobj=null;
statobj=dbmanager.executeSelectQuery(listsQuery,new String []{eventId});
int count=statobj.getCount();
if(statobj.getStatus() && count>0){
	for(int k=0;k<count;k++){
		 String list_id=dbmanager.getValue(k,"list_id","");
		 String list_name=dbmanager.getValue(k,"list_name","");
		 String nooffields=dbmanager.getValue(k,"nooffields","");
		 String field1=dbmanager.getValue(k,"field1","");
		 String field2=dbmanager.getValue(k,"field2","");
		 JSONObject listIdNmObject=new JSONObject();
		 listIdNmObject.put("list_id",list_id);
		 listIdNmObject.put("list_name",list_name);
		 listIdNmObject.put("no_of_flds",nooffields);
		 list.add(listIdNmObject);
		 JSONObject fieldsObject=new JSONObject();
		 fieldsObject.put("label1",field1);
		 fieldsObject.put("label2",field2);
		 fieldListObject.put(list_id,fieldsObject);
	}
}
List tickets=null;
if(!"RSVP".equals(powertype)){
	String compareTicketsQry="select price_id from price where price_id::text not in (SELECT distinct(regexp_split_to_table(tickets, ',')) AS split_tickets FROM priority_list where eventid=?) and evt_id=CAST(? AS BIGINT)";
	tickets=DbUtil.getValues(compareTicketsQry,new String []{eventId,eventId});
}
if(tickets!=null && tickets.size()>0) priorityListData.put("skip_btn_req","Y");
else priorityListData.put("skip_btn_req","N");
priorityListData.put("list_labels",fieldListObject);
priorityListData.put("list",list);
if("RSVP".equals(powertype)){
	String rsvprecurring=DbUtil.getVal("Select value from config where name='event.recurring' and config_id=(select config_id from eventinfo where eventid=CAST(? AS BIGINT))",new String[]{eventId});
	if("Y".equals(rsvprecurring)){
		String Rsvp_RECURRING_EVEBT_DATES = "select date_display,date_key from event_dates where eventid=CAST(? AS BIGINT) "+
					"and (zone_startdate+cast(cast(to_timestamp(COALESCE(zone_start_time,'00'),'HH24:MI:SS') as text) as time ))>=current_date "+
					"order by cast(zone_startdate||' '|| zone_start_time AS timestamp)";
				DBManager rsvpdbmanager = new DBManager();
				StatusObj rsvpstatobj = rsvpdbmanager.executeSelectQuery(Rsvp_RECURRING_EVEBT_DATES, new String[]{eventId});
				int rsvpcount = rsvpstatobj.getCount();
				String str="";
				if (rsvpstatobj.getStatus() && rsvpcount > 0) {
					str="<select name='rsvp_event_date' id='rsvp_event_date'>";
					str=str+"<option value='--Select Date--'>"+getPropValue("rsvp.sel.date",eventId)+"</option>";
					for (int k = 0; k < rsvpcount; k++) {
						String get_value = rsvpdbmanager.getValue(k, "date_display", "");
						String get_key = rsvpdbmanager.getValue(k, "date_key", "");
						str=str+"<option value='"+get_value+"'>"+get_value+"</option>";
						

						}
					str=str+"</select>";
					
				}
				priorityListData.put("rsvprecselect",str);
	}
	priorityListData.put("PriorityRegWordings",DisplayAttribsDB.getAttribValues(eventId,"RSVPFlowWordings"));
}else
	priorityListData.put("PriorityRegWordings",DisplayAttribsDB.getAttribValues(eventId,"RegFlowWordings"));
priorityListData.put("powertype",powertype);
out.println(priorityListData);
%>
