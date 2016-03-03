<%@ page import="com.event.dbhelpers.*,com.eventregister.*,com.eventbee.general.*"%>
<%@ page import="java.util.*,com.eventbee.general.DbUtil,java.util.ArrayList,org.json.*"%>

<%
String eid=request.getParameter("eid");
String eventdate=request.getParameter("eventdate");
String tid=request.getParameter("tid");
String all_seats="";
String selected_seats=request.getParameter("selected_seats");

String allsectionids=request.getParameter("all_section_ids");

String check=request.getParameter("check");if(check==null)check="";
String[] sectionids=allsectionids.split("_");
String seating_temp="";
String booked_seats="";
StatusObj booked_status=null;
StatusObj temp_status=null;
DBManager db=new DBManager();
DBManager dbt=new DBManager();
JSONObject obj=new JSONObject();
obj=(JSONObject)new JSONTokener(selected_seats).nextValue();

for(int i=0;i<sectionids.length;i++){
	JSONArray seatindexarray=new JSONArray();
	try{
		seatindexarray=obj.getJSONArray(sectionids[i]);
		//System.out.println("seatindexarray"+seatindexarray+""+all_seats);
		all_seats=all_seats+seatindexarray.join(",");
		//if(i<sectionids.length-1){
		//	all_seats=all_seats+",";
		//}
	}catch(Exception e){}	
	
}
String selseat[]=all_seats.split(",");
JSONObject jsonobj=new JSONObject();

if(!"".equals(all_seats)){
all_seats=all_seats.replace('"','\'');






 if(!"".equals(tid)){
seating_temp="select * from event_reg_block_seats_temp where eventid=? and transactionid!=? and seatindex in ("+all_seats+")";
booked_seats="select * from seat_booking_status where eventid=cast(? as numeric)  and tid!=? and seatindex in ("+all_seats+")";
}
else{
seating_temp="select * from event_reg_block_seats_temp where eventid=? and seatindex in ("+all_seats+")";
booked_seats="select * from seat_booking_status where eventid=cast(? as numeric)  and seatindex in ("+all_seats+")";
}



if(!"".equals(eventdate)||!" ".equals(eventdate)){
	if(!"".equals(tid)){
		seating_temp="select * from event_reg_block_seats_temp where eventid=? and transactionid!=? and eventdate=? and seatindex in ("+all_seats+")";
		booked_seats="select * from seat_booking_status where eventid=cast(? as numeric)  and tid!=? and eventdate=? and seatindex in ("+all_seats+")";
		booked_status=db.executeSelectQuery(booked_seats,new String[]{eid,tid,eventdate});
		temp_status=dbt.executeSelectQuery(seating_temp,new String[]{eid,tid,eventdate});
	}
	else{
			seating_temp="select * from event_reg_block_seats_temp where eventid=? and eventdate=? and seatindex in ("+all_seats+")";
			booked_seats="select * from seat_booking_status where eventid=cast(? as numeric) and eventdate=? and seatindex in ("+all_seats+")";
			booked_status=db.executeSelectQuery(booked_seats,new String[]{eid,eventdate});
			temp_status=dbt.executeSelectQuery(seating_temp,new String[]{eid,eventdate});

	}
}

else{
if(!"".equals(tid)){
 booked_status=db.executeSelectQuery(booked_seats,new String[]{eid,tid});
 temp_status=dbt.executeSelectQuery(seating_temp,new String[]{eid,tid});
 }
 else{
	booked_status=db.executeSelectQuery(booked_seats,new String[]{eid});
 temp_status=dbt.executeSelectQuery(seating_temp,new String[]{eid});

 }
 }
 

if(temp_status.getStatus() || booked_status.getStatus()){
jsonobj.put("status","Failed");
}
else{
jsonobj.put("status","success");
}
}
else{
jsonobj.put("status","success");
}


 if("level2".equals(check))
 { boolean break_flag=true;
          HashMap timeseat= new HashMap();
		  try{  
		   DBManager dbm=new DBManager();
		   StatusObj booked_statusinner=null;
		    String timequery="";
		   if(!"".equals(eventdate)||!" ".equals(eventdate)){
		    timequery="select seatindex from event_reg_block_seats_temp where transactionid not in(?) and blocked_at<(select  blocked_at from  event_reg_block_seats_temp where transactionid=? order by blocked_at desc limit 1) and eventid=? and eventdate=?";
		    booked_statusinner=dbm.executeSelectQuery(timequery,new String[]{tid.trim(),tid.trim(),eid,eventdate});
		    }
		   else
		    {
		   timequery="select seatindex from event_reg_block_seats_temp where transactionid not in(?) and blocked_at<(select  blocked_at from  event_reg_block_seats_temp where transactionid =? order by blocked_at desc limit 1) and eventid=?";
		   booked_statusinner=dbm.executeSelectQuery(timequery,new String[]{tid.trim(),tid.trim(),eid});
		    }
		System.out.println("satatus: "+booked_statusinner.getStatus()+" checseatinnercount "+booked_statusinner.getCount());
		   if(booked_statusinner.getStatus())
		  {
		    for(int i=0;i<booked_statusinner.getCount();i++)
		    {
			timeseat.put(dbm.getValue(i,"seatindex",""),"yes");
			}
		  }	
		 
		  if(booked_status.getCount()==0) 
		  { System.out.println("checking seat:"+booked_status.getCount());
		    	for(int j=0;j<selseat.length && break_flag;j++)
				{  String seatindex=selseat[j];
				   seatindex=seatindex.replaceAll("\"", "");
				   System.out.println("index:"+j+"seatindex:"+seatindex+"tid:"+tid);	
				   if(timeseat.containsKey(seatindex))
			       { System.out.println("failed");
					 jsonobj.put("status","Failed"); 
				String	 res=DbUtil.getVal("select array_agg( 'eventid='||eventid ||' ticketid='||ticketid||' tid='||transactionid||' seatindex='||seatindex||' eventdate='||eventdate||' time='||blocked_at ) ::text"+
							  " as response  from event_reg_block_seats_temp  where eventid=? and transactionid=?", new String[]{eid,tid});

					 System.out.println("seat on hold profile level"+res);
					 
					 DbUtil.executeUpdateQuery("delete from event_reg_block_seats_temp where transactionid=? ",new String[]{tid});
					 DbUtil.executeUpdateQuery("delete from event_reg_locked_tickets where tid=?",new String[]{tid});
					 break_flag=false;		  
				   }	
				}
				if(!break_flag)
				{
				 System.out.println("seact check status success in profile level");
				 jsonobj.put("status","Failed");
				}	
				
				else
				{ System.out.println("sucess at profile level seat checking");
				jsonobj.put("status","success");
				}
		 }
    	 else
		  {
		  jsonobj.put("status","Failed");
		  }
  }catch(Exception e){System.out.println(" Errror in checkseatstatus.jsp level2 checking :"+e.getMessage());
   jsonobj.put("status","success");
 }
 
}




jsonobj.put("tid",tid);
out.println(jsonobj.toString());
%>