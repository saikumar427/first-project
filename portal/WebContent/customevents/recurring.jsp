<%@ page import="java.util.*,com.eventbee.general.DBManager,com.eventbee.general.DbUtil,com.eventbee.general.StatusObj"%>
<%@ page import="com.eventbee.layout.DBHelper,com.event.dbhelpers.DisplayAttribsDB" %>
<%@ include file='/globalprops.jsp' %>

<%!
public class TicketsDBZ{
	public String getRecurringEventDates(String eventid,String purpose){
		String query="select  to_char(zone_startdate+cast(cast(to_timestamp(COALESCE(zone_start_time,'00'),'HH24:MI:SS') as text) as time ),'Dy, Mon DD, YYYY HH12:MI AM') as evt_start_date"
	      +",to_char(zone_startdate+cast(cast(to_timestamp(COALESCE(zone_start_time,'00'),'HH24:MI:SS') as text) as time ),'Dy, Mon DD, YYYY') as evt_start_date1 from event_dates where eventid=cast(? as numeric) and (zone_startdate+cast(cast(to_timestamp(COALESCE(zone_start_time,'00'),'HH24:MI:SS') as text) as time ))>=current_date order by (zone_startdate+cast(cast(to_timestamp(COALESCE(zone_start_time,'00'),'HH24:MI:SS') as text) as time ))";
		  String showTimePart=DbUtil.getVal("select value from mgr_config c,eventinfo e where e.eventid=?::BIGINT and c.name='mgr.recurring.showtime' and e.mgr_id=c.userid",new String[]{eventid});		  
			if(showTimePart==null || "".equals(showTimePart)) showTimePart="Y";
			ArrayList al=new ArrayList();
			DBManager db=new DBManager();
			String str=null;
			StatusObj stob=db.executeSelectQuery(query,new String[]{eventid} );
			if(stob.getStatus()){
				for(int i=0;i<stob.getCount();i++){
				HashMap<String,String> hm=new HashMap<String,String>();
					if("N".equals(showTimePart))
					hm.put("display",db.getValue(i,"evt_start_date1",""));
					//al.add(db.getValue(i,"evt_start_date1",""));
					else
					hm.put("display",db.getValue(i,"evt_start_date",""));
					//al.add(db.getValue(i,"evt_start_date",""));
					hm.put("value",db.getValue(i,"evt_start_date",""));
					al.add(hm);
				}
			}
			return getRecurringDatesForEventTickets(al,purpose,eventid);
		}

HashMap recurring_display(String eventid){
String get_key=null,get_value=null;
String RECURRING_EVEBT_DATES = "select date_display from event_dates where eventid=CAST(? AS BIGINT) and (zone_startdate+cast(cast(to_timestamp(COALESCE(zone_start_time,'00'),'HH24:MI:SS') as text) as time ))>=current_date order by date_key";
DBManager dbmanager = new DBManager();
HashMap gm=new HashMap();
StatusObj statobj = dbmanager.executeSelectQuery(RECURRING_EVEBT_DATES, new String[]{eventid});
int rsvpcount = statobj.getCount();
if (statobj.getStatus() && rsvpcount > 0) {
	
	for (int k = 0; k < rsvpcount; k++) {
		gm.put(k,dbmanager.getValue(k, "date_display", ""));
}
}	

return gm;
}

		String getRecurringDatesForEventTickets(ArrayList al,String purpose,String eventid){
			String str=null;
			String checkrsvp=null;
			if(al!=null&&al.size()>0){
				if("tickets".equals(purpose))
					str="<select name='eventdate' id='eventdate'  onchange=getTicketsJsonBefore('"+eventid+"');>";
					
				else{
					checkrsvp=DbUtil.getVal("Select value from config where name='event.rsvp.enabled' and config_id in (select config_id from eventinfo where eventid=?::bigint)",new String[]{eventid});
					if("yes".equals(checkrsvp)){
						String get_key=null,get_value=null;
						//String Rsvp_RECURRING_EVEBT_DATES = "select distinct eventdate as date_display from event_reg_transactions where eventid=? and eventdate!='' and tid in (select tid from rsvp_transactions where eventid=? and responsetype='Y') order by date_display";
						String Rsvp_RECURRING_EVEBT_DATES  = "select date_display from event_dates where eventid=CAST(? AS BIGINT) and (zone_startdate+cast(cast(to_timestamp(COALESCE(zone_start_time,'00'),'HH24:MI:SS') as text) as time ))>=current_date order by date_key";

						DBManager dbmanager = new DBManager();
						StatusObj statobj = dbmanager.executeSelectQuery(Rsvp_RECURRING_EVEBT_DATES, new String[]{eventid});
						int rsvpcount = statobj.getCount();
						str="<select name='event_date' id='event_date' onchange=showRSVPAttendeesList('"+eventid+"');>";
						str=str+"<option value='Select Date'>"+getPropValue("rsvp.sel.date",eventid)+"</option>";
						if (statobj.getStatus() && rsvpcount > 0) {
						str="<select name='event_date' id='event_date' onchange=showRSVPAttendeesList('"+eventid+"');>";
						str=str+"<option value='Select Date'>"+getPropValue("rsvp.sel.date",eventid)+"</option>";
							for (int k = 0; k < rsvpcount; k++) {
								get_value = dbmanager.getValue(k, "date_display", "");
								
								str=str+"<option value='"+get_value+"'>"+get_value+"</option>";
							}
						}	
					}
					else{
						str="<select name='event_date' id='event_date' onchange=showAttendeesList('"+eventid+"');>";
					}
				}
				if(!"yes".equals(checkrsvp)){
					//HashMap hm=recurring_display(eventid);
					for(int i=0;i<al.size();i++){
						HashMap<String,String> hm1=(HashMap<String,String>)al.get(i);
						str=str+"<option value='"+hm1.get("value")+"'>"+hm1.get("display")+"</option>";
						//str=str+"<option value='"+(String)al.get(i)+"'>"+(String)al.get(i)+"</option>";
						//str=str+"<option value='"+(String)al.get(i)+"'>"+(String)hm.get(i)+"</option>";
					}
				}
				str=str+"</select>";

			}
			return str;

		}
		
		/* public HashMap<String,String> getRecurringDatesTicketsHeaderLabels(String eventid,boolean isrecurring){
			HashMap<String,String> datestktslabels=new HashMap<String,String>();
			String customwordquery="",defaultwordquery="";
			String lang=DBHelper.getLanguageFromDB(eventid);
			if(isrecurring){
			   customwordquery="select  attrib_value,attrib_name from custom_event_display_attribs where module='RegFlowWordings' and attrib_name in('event.reg.ticket.page.Header','event.reg.recurringdates.label') and eventid=CAST(? AS BIGINT)";
			   defaultwordquery="select  attrib_value,attrib_name from default_event_display_attribs where module='RegFlowWordings' and attribname in('event.reg.ticket.page.Header','event.reg.recurringdates.label') and lang=?";			
				DisplayAttribsDB.getAttribValuesForKeys(eventid,"RegFlowWordings", new String []{"event.reg.ticket.page.Header","event.reg.recurringdates.label"});
			}else{
				customwordquery="select  attrib_value,attrib_name from custom_event_display_attribs where module='RegFlowWordings' and attrib_name='event.reg.ticket.page.Header' and eventid=CAST(? AS BIGINT)";
				defaultwordquery="select  attrib_value,attrib_name from default_event_display_attribs where module='RegFlowWordings' and attribname in('event.reg.ticket.page.Header') and lang=?";
				DisplayAttribsDB.getAttribValuesForKeys(eventid,"RegFlowWordings", new String []{"event.reg.ticket.page.Header"});
			}
			DBManager dbm=new DBManager();
			StatusObj sb=null;
			if(!"".equals(eventid) && eventid !=null)
			     sb=dbm.executeSelectQuery(customwordquery, new String[]{eventid});
			else
				sb=dbm.executeSelectQuery(defaultwordquery, null);
			if(sb.getCount()==0){
				sb=dbm.executeSelectQuery(defaultwordquery,null);
				if(sb.getStatus() && sb.getCount()>0){
					for(int i=0;i<sb.getCount();i++){
						if("event.reg.ticket.page.Header".equals(dbm.getValue(i,"attribname","")))
							datestktslabels.put("TicketsLabel", dbm.getValue(i,"attribdefaultvalue",""));
						else if("event.reg.recurringdates.label".equals(dbm.getValue(i,"attribname","")))
							datestktslabels.put("RecurringDatesLabel", dbm.getValue(i,"attribdefaultvalue",""));
					}
				}
			}else{
				if(sb.getStatus() && sb.getCount()>0){
					for(int i=0;i<sb.getCount();i++){
						if(!"".equals(eventid) && eventid !=null){
						if("event.reg.ticket.page.Header".equals(dbm.getValue(i,"attrib_name","")))
							datestktslabels.put("TicketsLabel", dbm.getValue(i,"attrib_value",""));
						else if("event.reg.recurringdates.label".equals(dbm.getValue(i,"attrib_name","")))
							datestktslabels.put("RecurringDatesLabel", dbm.getValue(i,"attrib_value",""));
						}else{
							if("event.reg.ticket.page.Header".equals(dbm.getValue(i,"attribname","")))
								datestktslabels.put("TicketsLabel", dbm.getValue(i,"attribdefaultvalue",""));
							else if("event.reg.recurringdates.label".equals(dbm.getValue(i,"attribname","")))
								datestktslabels.put("RecurringDatesLabel", dbm.getValue(i,"attribdefaultvalue",""));
						}
					}
				}
			}
			if(isrecurring && datestktslabels.size()==1){
				if("".equals(datestktslabels.get("RecurringDatesLabel")) || datestktslabels.get("RecurringDatesLabel")==null)
					datestktslabels.put("RecurringDatesLabel", "Select a date and time to attend");
			}
			return datestktslabels;
		} */
		
		public HashMap<String,String> getRecurringDatesTicketsHeaderLabels(String eventid,boolean isrecurring){
			HashMap<String,String> datestktslabels=new HashMap<String,String>();
			HashMap<String,String> disAttribsForKeys=new HashMap<String,String>();
			String lang="en_US";
			if(!"".equals(eventid) && eventid !=null)
				lang=DBHelper.getLanguageFromDB(eventid);
			
			
			if(isrecurring){
			   String [] keys={"event.reg.ticket.page.Header","event.reg.recurringdates.label"};
				if(!"".equals(eventid) && eventid !=null)
				   disAttribsForKeys=DisplayAttribsDB.getAttribValuesForKeys(eventid, "RegFlowWordings", lang, keys);
			   else
				   disAttribsForKeys=DisplayAttribsDB.getDefaultAttribValuesForKeys("RegFlowWordings", lang, keys);
			}else{
				String [] keys={"event.reg.ticket.page.Header"};
				if(!"".equals(eventid) && eventid !=null)
					disAttribsForKeys=DisplayAttribsDB.getAttribValuesForKeys(eventid,"RegFlowWordings", lang, keys);
				else
					disAttribsForKeys=DisplayAttribsDB.getDefaultAttribValuesForKeys("RegFlowWordings", lang, keys);
			}
			
			if(disAttribsForKeys.containsKey("event.reg.ticket.page.Header"))
				datestktslabels.put("TicketsLabel", disAttribsForKeys.get("event.reg.ticket.page.Header"));
			if(disAttribsForKeys.containsKey("event.reg.recurringdates.label"))
				datestktslabels.put("RecurringDatesLabel", disAttribsForKeys.get("event.reg.recurringdates.label"));
				
			if(isrecurring && datestktslabels.size()==1){
				if("".equals(datestktslabels.get("RecurringDatesLabel")) || datestktslabels.get("RecurringDatesLabel")==null)
					datestktslabels.put("RecurringDatesLabel", "Select a date and time to attend");
			}
			return datestktslabels;
	}
}		
%>