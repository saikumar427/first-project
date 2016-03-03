package com.eventpageloader;
import com.eventbee.general.StatusObj;
import java.util.HashMap;
import com.eventbee.general.DBManager;
import javax.servlet.http.*;
import com.eventbee.event.DateTime;

public class EventPageContent{
public static String getConfigValue(String key,HttpServletRequest req,String defaultval){
	String value="";
	HashMap hm=(HashMap)req.getAttribute("confighm");
	if(hm==null)
	return defaultval;
	value=(String)hm.get(key);
	return (value==null)?defaultval:value;
}

public static String getEventInfoForKey(String key,HttpServletRequest req,String defaultval){
	String value="";
	HashMap hm=(HashMap)req.getAttribute("eventinfohm");
	if(hm==null)
	return defaultval;
	value=(String)hm.get(key);
	return (value==null)?defaultval:value;
}


public static String getTrackInfoForKey(String key,HttpServletRequest req,String defaultval){
	String value="";
	HashMap hm=(HashMap)req.getAttribute("Trackshm");
	if(hm==null)
	return defaultval;
	value=(String)hm.get(key);
	return (value==null)?defaultval:value;
}



public static HashMap getConfigValuesFromDb(String configid){
	String ConfigQuery="select * from config where config_id=to_number(?,'99999999999999999')";
	DBManager db=new DBManager();
	HashMap confighm=new HashMap();
	StatusObj sb=db.executeSelectQuery(ConfigQuery,new String[]{configid});
	if(sb.getStatus()){
		for(int i=0;i<sb.getCount();i++){
			confighm.put(db.getValue(i,"name",""),db.getValue(i,"value",""));
		}
	}
	return confighm;
}

public static HashMap getEventDetailsFromDb(String eventid){
	DBManager dbmanager=new DBManager();
	HashMap hm=new HashMap();
	String eventinfoquery="select a.*,trim(to_char(a.end_date,'Dy')) ||', '|| to_char(a.end_date,'Mon DD, YYYY') as evt_end_date,"

	                     +"trim(to_char(a.start_date,'Dy')) ||', '|| to_char(a.start_date,'Mon DD, YYYY') as evt_start_date,"
	                     +"to_char(start_date,'yyyy') as start_yy,to_char(start_date,'mm') as start_mm,  "
			                   +" to_char(a.start_date,'dd') as start_dd, "
			     	           +" to_char(to_timestamp(COALESCE(a.starttime,'00'),'HH24:MI'),'HH24') "
			                   +" as start_hh,"+" to_char(to_timestamp(COALESCE(a.starttime,'00'),'HH24:MI'),'MI') "
			                   +" as start_mi,"
			                   +" to_char(a.end_date,'yyyy') as end_yy, "
			                   +" to_char(a.end_date,'mm') as end_mm, "
			                   +" to_char(a.end_date,'dd') as end_dd, "
			                   +" to_char(to_timestamp(COALESCE(a.endtime,'00'),'HH24:MI'),'HH24') "
			                   +" as end_hh,"
			                   +" to_char(to_timestamp(COALESCE(a.endtime,'00'),'HH24:MI'),'MI') "
                                           +" as end_mi,cancel_by "
                                           +"from eventinfo a where a.eventid=to_number(?,'999999999999999')";


	StatusObj statobj=dbmanager.executeSelectQuery(eventinfoquery,new String[]{eventid});
	if(statobj.getStatus()){
	String [] columnnames=dbmanager.getColumnNames();
	for(int i=0;i<statobj.getCount();i++){
	for(int j=0;j<columnnames.length;j++){
	hm.put(columnnames[j],dbmanager.getValue(i,columnnames[j],""));
	hm.put("first_name","");
	hm.put("last_name","");
	hm.put("company","");
	hm.put("/startYear",dbmanager.getValue(i,"start_yy",""));
	hm.put("/startMonth",dbmanager.getValue(i,"start_mm",""));
	hm.put("/startDay",dbmanager.getValue(i,"start_dd",""));
	hm.put("/startYear",dbmanager.getValue(i,"start_yy",""));
	hm.put("/startHour",dbmanager.getValue(i,"start_hh",""));
	hm.put("/startMinute",dbmanager.getValue(i,"start_mi",""));
	hm.put("/endYear",dbmanager.getValue(i,"end_yy",""));
	hm.put("/endMonth",dbmanager.getValue(i,"end_mm",""));
	hm.put("/endDay",dbmanager.getValue(i,"end_dd",""));
	hm.put("/endHour",dbmanager.getValue(i,"end_hh",""));
	hm.put("/endMinute",dbmanager.getValue(i,"end_mi",""));
	hm.put("starttime",DateTime.getTimeAM(dbmanager.getValue(i,"starttime","")));
	hm.put("endtime",DateTime.getTimeAM(dbmanager.getValue(i,"endtime","")));

	}
	}
	}
	return hm;
}


public static HashMap getTrackURLContet(String eventid,String trackcode){

DBManager dbmanager=new DBManager();
	HashMap hm=new HashMap();
	String trackurldata="select * from trackURLs where eventid=? and trackingcode=?";
	StatusObj statobj=dbmanager.executeSelectQuery(trackurldata,new String[]{eventid,trackcode});
	if(statobj.getStatus()){
	String [] columnnames=dbmanager.getColumnNames();
	for(int i=0;i<statobj.getCount();i++){
	for(int j=0;j<columnnames.length;j++){
	hm.put(columnnames[j],dbmanager.getValue(i,columnnames[j],""));
	}
	}
	}
	return hm;

}





}


