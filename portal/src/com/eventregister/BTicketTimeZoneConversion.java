package com.eventregister;
import java.text.SimpleDateFormat;
import java.util.*;
import com.eventbee.general.*;
import com.eventbee.event.DateTime;
import com.eventbee.editevent.EditEventDB;

public class BTicketTimeZoneConversion{

public  void getTimezones(HashMap hm,String timezone){
String formatPattern = "MMM d, yyyy','hh:mm aaa";
    String sd=(String)hm.get("startDay");
	String ed=(String)hm.get("endDay");
	String sm=(String)hm.get("startMonth");
	String em=(String)hm.get("endMonth");
	String starttime =(String)hm.get("starttime");
	String endtime=(String)hm.get("endtime");
	String ey=(String)hm.get("endYear");
	String sy=(String)hm.get("startYear");
	String[] stimes=GenUtil.strToArrayStr(starttime,":");
	String[] etimes=GenUtil.strToArrayStr(endtime,":");
	String sh=stimes[0];
	String eh=etimes[0];
	String emin=etimes[1];
	String smin=stimes[1];
	String timezone1=EbeeConstantsF.get("Server.time.zone","SystemV/EST5");
	TimeZone T1=new SimpleTimeZone(TimeZone.getTimeZone(timezone1).getRawOffset(), timezone1);
	Calendar scalendar = Calendar.getInstance(T1);
	scalendar.set(Integer.parseInt(sy),
	Integer.parseInt(sm)-1,
	Integer.parseInt(sd),
	Integer.parseInt(sh),
	Integer.parseInt(smin));
	Calendar ecalendar = Calendar.getInstance(T1);
	ecalendar.set(Integer.parseInt(ey),
	Integer.parseInt(em)-1,
	Integer.parseInt(ed),
	Integer.parseInt(eh),
	Integer.parseInt(emin));
	/*EditEventDB evtDB=new EditEventDB();
	BTicketsDB ticketdb=new BTicketsDB();
	HashMap configMap=ticketdb.getConfigValuesFromDb(eventid);
	String timezone=GenUtil.getHMvalue(configMap,"event.timezone","");*/
	String timezone2=DateTime.getTimeZoneVal(timezone);
	String[] starttimes= getTimeZoneForTicketsDisplay(scalendar,timezone2,formatPattern);
	String[] endtimes=getTimeZoneForTicketsDisplay(ecalendar,timezone2,formatPattern);
	hm.put("start_date",starttimes[0]);
	hm.put("starttime",starttimes[2]);
	hm.put("end_date",endtimes[0]);
	hm.put("endtime",endtimes[2]);
}
public  String[] getTimeZoneForTicketsDisplay(Calendar cal,String timezone2,String formatPattern){
Date date = cal.getTime();
SimpleDateFormat sdf = new SimpleDateFormat(formatPattern);
TimeZone T2=new SimpleTimeZone(TimeZone.getTimeZone(timezone2).getRawOffset(),timezone2);
sdf.setTimeZone(T2);
String d=sdf.format(date);
String[] stimes=GenUtil.strToArrayStr(d,",");
return stimes;
}

}