<%@ page import="java.util.*,java.sql.*,com.eventbee.general.*,com.eventbee.event.DateTime" %>

<%!
/*

This is the utility provided for creating Vcal for Active Events

*/

String SELECTQUERY="select eventid, description, eventname,venue,address1,address2, city, start_date, end_date, starttime, endtime from eventinfo where created_at::text  >'2012-11-15'";
String TIMEZONEQUERY="select a.value, b.eventid from config a, eventinfo b where a.config_id =b.config_id and b.created_at::text  >'2012-11-15' and a.name='event.timezone'";
%>

<%
DBManager dbmanager=new DBManager();
Vector v=new Vector();
StatusObj statobj=dbmanager.executeSelectQuery(SELECTQUERY,null);
if(statobj.getStatus()){
	String [] columnnames=dbmanager.getColumnNames();
	for(int i=0;i<statobj.getCount();i++){
	try{
		HashMap hm=new HashMap();
		hm.put("eventid",dbmanager.getValue(i,"eventid",""));
		hm.put("description",dbmanager.getValue(i,"description",""));
		hm.put("eventname",dbmanager.getValue(i,"eventname",""));
		hm.put("city",dbmanager.getValue(i,"city",""));
		hm.put("venue",dbmanager.getValue(i,"venue",""));
		hm.put("address1",dbmanager.getValue(i,"address1",""));
		hm.put("address2",dbmanager.getValue(i,"address2",""));
		hm.put("start_date",dbmanager.getValue(i,"start_date",""));
		hm.put("end_date",dbmanager.getValue(i,"end_date",""));
		String edate=dbmanager.getValue(i,"start_date","");
			
		hm.put("startYear",edate.substring(0,4));
		hm.put("startMonth",edate.substring(5,7));
		hm.put("startDay",edate.substring(8));
		
		edate=dbmanager.getValue(i,"end_date","");
		hm.put("endYear",edate.substring(0,4));
		hm.put("endMonth",edate.substring(5,7));
		hm.put("endDay",edate.substring(8));
		
		edate=dbmanager.getValue(i,"starttime","");		
		int startHour=Integer.parseInt(edate.substring(0,2));
		
		hm.put("startMinute",edate.substring(3));
		hm.put("startoffSet", "AM");
		hm.put("endoffSet", "AM");
		if(startHour>12) {
			startHour=startHour-12;
			hm.put("startoffSet", "PM");
		}
		hm.put("startHour",""+startHour);
		edate=dbmanager.getValue(i,"endtime","");
		int endHour=Integer.parseInt(edate.substring(0,2));
		hm.put("endMinute",edate.substring(3));
		
		if(endHour>12) {
			endHour=startHour-12;
			hm.put("endoffSet", "PM");
		}
		hm.put("endHour",""+endHour);
		
		//out.println("HM is : "+hm);
		v.add(hm);
		}catch(Exception e){out.println("Failed****==="+e.getMessage());}
	}
}

HashMap timezones=new HashMap();
statobj=dbmanager.executeSelectQuery(TIMEZONEQUERY,null);
if(statobj.getStatus()){
	String [] columnnames=dbmanager.getColumnNames();
	for(int i=0;i<statobj.getCount();i++){
		timezones.put(dbmanager.getValue(i,"eventid",""),dbmanager.getValue(i,"value",""));
	}
}
//out.println("HM is : "+timezones);		
if(v.size()>0){
	for(int i=0;i<v.size();i++){
	try{
		HashMap hm=(HashMap)v.get(i);

String location=GenUtil.getCSVData(new String[]{(String)hm.get("venue"),(String)hm.get("address1"),(String)hm.get("address2"),(String)hm.get("city"),(String)hm.get("state"),(String)hm.get("country")});

HashMap vcal=new HashMap();
vcal.put(VCal.ID,(String)hm.get("eventid"));
vcal.put(VCal.PURPOSE,"event");
vcal.put(VCal.DESCRIPTION,(String)hm.get("description"));
vcal.put(VCal.NAME,(String)hm.get("eventname"));
vcal.put(VCal.LOCATION,location);
DateTime starttime=new DateTime((String)hm.get("startYear"),(String)hm.get("startMonth"),(String)hm.get("startDay"),(String)hm.get("startHour"),(String)hm.get("startMinute"),(String)hm.get("startoffSet"));
DateTime endtime=new DateTime((String)hm.get("endYear"),(String)hm.get("endMonth"),(String)hm.get("endDay"),(String)hm.get("endHour"),(String)hm.get("endMinute"),(String)hm.get("offSet"));
vcal.put(VCal.STARTTIME,starttime.getDateTimeForVCal(DateTime.getTimeZoneVal((String)timezones.get((String)hm.get("eventid")))));
vcal.put(VCal.ENDTIME,endtime.getDateTimeForVCal(DateTime.getTimeZoneVal((String)timezones.get((String)hm.get("eventid")))));
VCal.createFile(vcal);
}catch(Exception e){out.println("Failed****==="+e.getMessage());}
	}
	out.println("No. of Events****==="+v.size());
}
%>