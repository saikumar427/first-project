<%@ page import="com.eventbee.event.DateTime, java.text.*,com.eventbee.editevent.EditEventDB"%>

<%!

public  String[] getTimeZoneForTickets(Calendar cal,String timezone2)
	{
	java.util.Date date = cal.getTime();

	String formatPattern = "MM-dd-yyyy','HH:mm ";
	SimpleDateFormat sdf = new SimpleDateFormat(formatPattern);

	TimeZone T2=new SimpleTimeZone(TimeZone.getTimeZone(timezone2).getRawOffset(),timezone2);



	sdf.setTimeZone(T2);
	String d=sdf.format(date);

	String[] stimes=GenUtil.strToArrayStr(d,",");

	return stimes;
}





public void getTimezones(HashMap hm,String event){
try{
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
       
	String timezoneval=DbUtil.getVal("select value from config where name='event.timezone' and config_id=(select config_id from eventinfo where eventid=?)",new String[]{event});
	System.out.println("timezoneval---"+timezoneval);
	
	String timezone2=DateTime.getTimeZoneVal(timezoneval);
	System.out.println("timezone2---"+timezone2);
	String[] starttimes= getTimeZoneForTickets(scalendar,timezone2);
	String[] endtimes= getTimeZoneForTickets(ecalendar,timezone2);
	

	hm.put("startdate",starttimes[0]);
	hm.put("starttime",starttimes[1]);
	
	hm.put("enddate",endtimes[0]);
	hm.put("endtime",endtimes[1]);
}

catch(Exception e){


}
}
%>