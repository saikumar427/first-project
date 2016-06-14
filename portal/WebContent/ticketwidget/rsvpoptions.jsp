<%@page import="org.json.JSONArray"%>
<%@page import="com.eventbee.general.StatusObj"%>
<%@page import="com.eventbee.general.DBManager"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.eventbee.general.DbUtil"%>
<%@page import="com.eventbee.general.GenUtil"%>
<%@page import="com.event.dbhelpers.CDisplayAttribsDB"%>
<%@page import="java.util.HashMap"%>
<%@ include file='../globalprops.jsp' %>
<%!
	HashMap getcompletedcount(String eventid,String isrecurring){
		String surecomcount,notsurecomcount;
		String rsvplimitallowed=DbUtil.getVal("select totallimit from rsvp_settings where eventid=?",new String[]{eventid});
		if(rsvplimitallowed == null){
			rsvplimitallowed = "0";
		}
		if("Y".equals(isrecurring)){
			surecomcount = "0";
			notsurecomcount = "0";
		}
		else{
			surecomcount=DbUtil.getVal("select sum(yescount) from rsvp_transactions where eventid=?",new String[]{eventid});
			if(surecomcount == null){
				surecomcount = "0";
			}
			notsurecomcount=DbUtil.getVal("select sum(notsurecount) from rsvp_transactions where eventid=?",new String[]{eventid});
			if(notsurecomcount == null){
				notsurecomcount = "0";
			}
		}
		int attendeecount=Integer.parseInt(surecomcount)+Integer.parseInt(notsurecomcount);
		
		HashMap count=new HashMap();
		count.put("attendeecount",attendeecount);
		count.put("rsvplimitallowed",rsvplimitallowed);
		return count;
}

%>
<% 
String eventid=request.getParameter("eventid");
String lang=DBHelper.getLanguageFromDB(eventid);
if(lang==null || "lang".equals(lang)) lang="en_US";
String promotionsection=DbUtil.getVal("Select value from config where name='show.ebee.promotions' and config_id=(select config_id from eventinfo where eventid=CAST(? AS BIGINT))",new String[]{eventid});
if("No".equals(promotionsection))
{
	promotionsection="No";
}
else
{
	promotionsection=GenUtil.getHMvalue(CDisplayAttribsDB.getDisplayAttribs(eventid,"RSVPFlowWordings",lang),"event.reg.profile.promotions.message","I would like to receive promotions and discounts from Eventbee and its partners");
}
HashMap profilePageLabels=CDisplayAttribsDB.getAttribValues(eventid,"RSVPFlowWordings");
String alertmsg=GenUtil.getHMvalue(profilePageLabels,"event.reg.response.error.message","Please select Attending Qantity to Continue");
String pageheaders=GenUtil.getHMvalue(profilePageLabels,"event.reg.rsvppage.header","RSVP");
String confirmationpageheader=GenUtil.getHMvalue(profilePageLabels,"event.reg.confirmationpage.header","Confirmation");
String rsvprecdateslable=GenUtil.getHMvalue(profilePageLabels,"event.reg.recurringdates.label","Select a date and time to attend");
if(rsvprecdateslable==null || "".equals(rsvprecdateslable))rsvprecdateslable="Select a date and time to attend";
String rsvprecurring=DbUtil.getVal("Select value from config where name='event.recurring' and config_id=(select config_id from eventinfo where eventid=CAST(? AS BIGINT))",new String[]{eventid});
String attendlimitallowed=DbUtil.getVal("select attendeelimit from rsvp_settings where eventid=?",new String[]{eventid});
String notattendingallowed=DbUtil.getVal("select notattending from rsvp_settings where eventid=?",new String[]{eventid});
String notsurelimitallowed=DbUtil.getVal("select notsurelimit from rsvp_settings where eventid=?",new String[]{eventid});
String rsvpstatus=DbUtil.getVal("select status from eventinfo where eventid=CAST(? AS BIGINT)",new String[]{eventid});
String attendingLbl=GenUtil.getHMvalue(profilePageLabels,"event.reg.response.attending.label","Attending");
String mayBeLbl=GenUtil.getHMvalue(profilePageLabels,"event.reg.response.notsuretoattend.label","Maybe");
String notAttendLbl=GenUtil.getHMvalue(profilePageLabels,"event.reg.response.notattending.label","Not Attending");
String defaultDrop=getPropValue("rsvp.sel.date",eventid);
JSONObject rsvpObj=new JSONObject();

if("ACTIVE".equals(rsvpstatus)){
	rsvpObj.put("do_continue", true);
	
	rsvpObj.put("attendlimitallowed", attendlimitallowed==null?"1":attendlimitallowed=="0"?"1":attendlimitallowed);
	rsvpObj.put("notsurelimitallowed",notsurelimitallowed== null?"0":notsurelimitallowed);
	rsvpObj.put("notattendingallowed",notattendingallowed);
	rsvpObj.put("rsvprecurring",rsvprecurring);
	rsvpObj.put("confirmationpageheader",confirmationpageheader);
	rsvpObj.put("pageheaders",pageheaders);
	rsvpObj.put("alertmsg",alertmsg);
	rsvpObj.put("rsvpstatus",rsvpstatus);
	rsvpObj.put("rsvprecdateslable",rsvprecdateslable);
	rsvpObj.put("attendingLbl",attendingLbl);
	rsvpObj.put("mayBeLbl",mayBeLbl);
	rsvpObj.put("notAttendLbl",notAttendLbl);
	rsvpObj.put("defaultDrop",defaultDrop);
	rsvpObj.put("promotionsection",promotionsection);
	HashMap completedcount=new HashMap();
	completedcount=getcompletedcount(eventid,rsvprecurring);
	
	JSONArray date=new JSONArray();
	HashMap dates=new HashMap();
	if("Y".equals(rsvprecurring)){
		System.out.println("RSVP Recurring Event");
		String Rsvp_RECURRING_EVEBT_DATES = "select date_display,date_key from event_dates where eventid=CAST(? AS BIGINT) "+
					"and (zone_startdate+cast(cast(to_timestamp(COALESCE(zone_start_time,'00'),'HH24:MI:SS') as text) as time ))>=current_date "+
					"order by cast(zone_startdate||' '|| zone_start_time AS timestamp)";
				DBManager dbmanager = new DBManager();
				StatusObj statobj = dbmanager.executeSelectQuery(Rsvp_RECURRING_EVEBT_DATES, new String[]{eventid});
				int rsvpcount = statobj.getCount();
				
				if (statobj.getStatus() && rsvpcount > 0) {
					
					for (int k = 0; k < rsvpcount; k++) {
						dates.put("name",dbmanager.getValue(k, "date_display", ""));
						dates.put("value",dbmanager.getValue(k, "date_display", ""));
						date.put(dates);
						} 
				}
	}
	int limit=0;
	int count=0;
	try{
		limit=Integer.parseInt(completedcount.get("rsvplimitallowed").toString());
		count=Integer.parseInt(completedcount.get("attendeecount").toString());
		if(limit == 0){
			limit=100000000;
		}
		if(count == 0 && limit == 0){
			count=0;
			limit=100000000;
		}	
	}
	catch(Exception e){
		count=0;
		limit=100000000;
	}
	rsvpObj.put("limit",limit);
	rsvpObj.put("count",count);
	if(date.length()>0)
	rsvpObj.put("dates",date);
	
}else if("CLOSED".equals(rsvpstatus)){
	rsvpObj.put("do_continue",false);
	rsvpObj.put("reson","RSVP for this event are closed");
	rsvpObj.put("rsvpstatus", rsvpstatus);
}else if("CANCEL".equals(rsvpstatus)){
	rsvpObj.put("do_continue",false);
	rsvpObj.put("reson","Currently this event is not available");
	rsvpObj.put("rsvpstatus", rsvpstatus);
}else{
	rsvpObj.put("do_continue",false);
	rsvpObj.put("reson","Currently this event is not available");
	rsvpObj.put("rsvpstatus", rsvpstatus);
}


out.println(rsvpObj);

%>