package com.eventbee.event;
import com.eventbee.general.StatusObj;
import com.eventbee.general.*;
import com.eventbee.event.*;
import com.eventbee.authentication.*;
import java.sql.*;
import java.util.*;
import java.lang.String;

public class F2FEventDB{
	
	public static final String AGENTS_INFO_QUERY="select getMemberName(b.userid||'') as name,getMemberPref(d.mgr_id||'','pref:myurl','') as username,b.status,b.agentid,b.userid from group_agent b,group_agent_settings c,eventinfo d where  c.groupid=cast(d.eventid as varchar) and b.settingid=c.settingid and c.groupid=? and purpose='event'";
	
	public static final String EVENT_DETAILS_QUERY="select eventname,eventid,substr(created_at,1,10) as created_at from eventinfo where end_date>now()'";
	
	public static final String ENABLED_EVENTS_QUERY="select CheckIsAgent(settingid,?) as isagent,b.description,a.groupid,a.settingid,b.eventname,getMemberPref(mgr_id||'','pref:myurl','') as username,b.city,b.state,b.country,to_char(b.start_date,'MM/DD/YYYY')as startdate from eventinfo b,group_agent_settings a,config c where c.name='event.enable.agent.settings' and a.groupid=b.eventid and c.value='Yes' and b.config_id=c.config_id";
		  
	public static final String AGENT_SETTINGS_QUERY="select tagline,description,salecommission*100 as salecommission,saleslimit,approvaltype from group_agent_settings where groupid=? and purpose='event'";
	
	public static final String MYF2FINFO_QUERY="select to_char(a.created_at,'MM/DD/YYYY')as created_at ,a.status,a.settingid,a.agentid,b.eventname,b.eventid,getMemberPref(mgr_id||'','pref:myurl','') as username from eventinfo b,group_agent a,group_agent_settings c where a.settingid=c.settingid and b.eventid=c.groupid and userid=?";
	
	
	public static Vector getEventsInfo(Vector v,String groupid,String query){
		DBManager dbmanager=new DBManager();
		StatusObj statobj=dbmanager.executeSelectQuery(query,new String[]{groupid});
		if(statobj.getStatus()){
			String [] columnnames=dbmanager.getColumnNames();
				for(int i=0;i<statobj.getCount();i++){
					HashMap hm=new HashMap();
					for(int j=0;j<columnnames.length;j++){
						hm.put(columnnames[j],dbmanager.getValue(i,columnnames[j],""));
					}
					v.add(hm);
				}	
		}
		return v;
	}
	

	public static Vector getEventDetails(Vector v){
		DBManager dbmanager=new DBManager();
		StatusObj statobj=dbmanager.executeSelectQuery(EVENT_DETAILS_QUERY,new String[]{});
		if(statobj.getStatus()){
			String [] columnnames=dbmanager.getColumnNames();
				for(int i=0;i<statobj.getCount();i++){
					HashMap hm=new HashMap();
					for(int j=0;j<columnnames.length;j++){
						hm.put(columnnames[j],dbmanager.getValue(i,columnnames[j],""));
					}
					v.add(hm);
				}
		}
		return v;
	}

	
	

}
