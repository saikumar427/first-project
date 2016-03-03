package com.eventbee.editevent;
import com.eventbee.general.EventbeeConnection;
import com.eventbee.general.StatusObj;
import com.eventbee.general.*;
import com.eventbee.event.EventConstants;
import java.sql.*;
import java.util.*;
import java.util.HashMap;

public class EditEventDB {

    final String EVENT_INFO_QUERY =  "select tags,type,descriptiontype,category,code,eventname, description,longitude,latitude, event_type,evt_level,"
				     +"venue,address1,address2,city, state, country,region,config_id,unitid,"
                                     +" email, phone, comments,role,listebee,listtype, "
				     +" to_char(start_date,'yyyy') as start_yy, "
				     +" to_char(start_date,'mm') as start_mm, to_char(created_at,'Month DD, YYYY') as  display_date, "
                                     +" to_char(start_date,'dd') as start_dd, "
+" to_char(to_timestamp('2003-10-10 '||COALESCE(starttime,'00'),'yyyy-dd-mm HH24:MI'),'HH24') "
 				     +" as start_hh,"
+" to_char(to_timestamp('2003-10-10 '||COALESCE(starttime,'00'),'yyyy-dd-mm HH24:MI'),'MI') "
				     +" as start_mi,"
				     +" to_char(end_date,'yyyy') as end_yy, "
				     +" to_char(end_date,'mm') as end_mm, "
                                     +" to_char(end_date,'dd') as end_dd, "
+" to_char(to_timestamp('2003-10-10 '||COALESCE(endtime,'00'),'yyyy-dd-mm HH24:MI'),'HH24') "
 				     +" as end_hh,"
+" to_char(to_timestamp('2003-10-10 '||COALESCE(endtime,'00'),'yyyy-dd-mm HH24:MI'),'MI') "
				     +" as end_mi "
                                     +" from eventinfo where eventid=? ";
final  String GET_EVENT_GROUPS = " select groupid from event_group where eventid=? ";
 final String EVENT_UPDATE_QUERY = " update eventinfo set eventname=?, description=?, category=?,"
                                  +" city=?, state=?, country=?,start_date=?,end_date=?,email=?,"
                                  +" starttime=?,endtime=?,"
                                  +" phone=?,comments=?,address1=?,address2=?,code=? where eventid=?";

final String UPDATE_EVENT_QUERY = " update eventinfo set listtype=?,listebee=?,eventname=?, description=?, category=?,event_type=?,"
                                  +" city=?, state=?, country=?,start_date=?,end_date=?,email=?,"
                                  +" starttime=?,endtime=?,"
                                  +" phone=?,comments=?,address1=?,address2=?,code=? ,updated_by=?,updated_at=now(),type=?,descriptiontype=?,tags=?, venue=?,region=? where eventid=?";


 final String CONFIG_EVENTALL = " select * from config where config_id=(select config_id from "
					+"eventinfo where eventid=?) ";

 final String CONFIG_DELETE = " delete from config  where config_id="
                                    +" (select config_id from eventinfo where eventid=?) "
                                    +" and name=?";

 final String CONFIG_INSERT = " insert into config(config_id, name, value) values ("
				    +"(select config_id from eventinfo where eventid=?),?,?)";

 final String CONFIG_GET = " select value as desc from config "
				  +" where config_id=(select config_id from eventinfo where "
                                  +" eventid=?) and name=?";

 static final String EVENT_CONFIG_VALUES=" select name, value from config "
				  +" where config_id=(select config_id from eventinfo where "
                                  +" eventid=?) ";


 static final String EVT_LEVEL_UPDATE="update eventinfo set evt_level=? where eventid=?";

 static final String EVT_LEVEL_GET="select evt_level from eventinfo where eventid=?";

 static final String EVT_LEVELS="select distinct(evt_level) from eventinfo";

 static final String GET_EVENT_CONFIG="select rsvp_type,rsvp_limit,rsvp_count,(rsvp_limit-rsvp_count) as count from event_config where eventid=?";
 static final String UPDATE_EVENT_CONFIG="update event_config set rsvp_type=?,rsvp_limit=? where eventid=?";
static final String deletequery="delete from event_group where eventid=?";
static final String insertquery="insert into event_group(eventid,groupid) values(?,?) ";

 public static String updateEventConfig(HashMap hm,Connection con){
	 return updateEventConfig((String)hm.get("rsvp_type"),(String)hm.get("rsvp_limit"),(String)hm.get("eventid"),con);
 }
 public static String updateEventConfig(String rsvp_type,String rsvp_limit,String eventid){
	 Connection con=null;
	 return updateEventConfig(rsvp_type,rsvp_limit,eventid,con);
 }

 public static String updateEventConfig(String rsvp_type,String rsvp_limit,String eventid,Connection con){
	 boolean conclose=false;
	 java.sql.PreparedStatement pstmt=null;
	 int res=0;
	 try{
		 if(con==null){
			 con=EventbeeConnection.getReadConnection("event");
			 conclose=true;
		 }
		 pstmt=con.prepareStatement(UPDATE_EVENT_CONFIG);
		 pstmt.setString(1,rsvp_type);
		 pstmt.setString(2,rsvp_limit);
		 pstmt.setString(3,eventid);
                 res=pstmt.executeUpdate();
               	pstmt.close();
	 }catch(Exception e){
		 System.out.println("Error EditEventDB/updateEventConfig()"+e);
		 res=0;
	 }finally{
		 try{
			 if(conclose){
				 if(con!=null) {con.close();con=null;}
			 }
			 if(pstmt!=null){pstmt.close();pstmt=null;}
		 }catch(Exception ef){}
	 }

   return ""+res;
 }
 public static HashMap getEventConfig(String eventid){
	 HashMap hm=null;
	 return getEventConfig(eventid,hm);
 }
 public static HashMap getEventConfig(String eventid,HashMap hm){
	 Connection con=null;
	 return getEventConfig(eventid,hm,con);
 }
 public static HashMap getEventConfig(String eventid,HashMap hm, Connection con){
	 boolean conclose=false;
	 java.sql.PreparedStatement pstmt=null;
	 if(hm==null) hm=new HashMap();
	 try{
		 if(con==null){
			 con=EventbeeConnection.getReadConnection("event");
			 conclose=true;
		 }
		 pstmt=con.prepareStatement(GET_EVENT_CONFIG);
		 pstmt.setString(1,eventid);
                ResultSet rs=pstmt.executeQuery();
                if(rs.next()){
				hm.put("rsvp_type",rs.getString("rsvp_type"));
				hm.put("rsvp_limit",rs.getString("rsvp_limit"));
				hm.put("rsvp_count",rs.getString("rsvp_count"));
				hm.put("count",rs.getString("count"));
		}
		rs=null;
		pstmt.close();
	 }catch(Exception e){
		 System.out.println("Error EditEventDB/getEventConfig()"+e);
		 hm=null;
	 }finally{
		 try{
			 if(conclose){
				 if(con!=null) {con.close();con=null;}
			 }
			 if(pstmt!=null){pstmt.close();pstmt=null;}
		 }catch(Exception ef){}
	 }

   return hm;
 }
 public HashMap getEventInfo(String eventid){
	 Connection con=null;
	 return getEventInfo(eventid,con);
 }
 public HashMap getEventInfo(String eventid,Connection con){
	boolean conclose=false;
        HashMap hm=null;
	java.sql.PreparedStatement pstmt=null;
	try{
	Vector v=null;
		if(con==null){
			con=EventbeeConnection.getReadConnection("event");
			conclose=true;
		}
		pstmt=con.prepareStatement(EVENT_INFO_QUERY);
                pstmt.setString(1,eventid);
                ResultSet rs=pstmt.executeQuery();
                if(rs.next()){
				hm=new HashMap();
				hm.put("/evttype",rs.getString("type"));
				hm.put("display_date",rs.getString("display_date"));
				hm.put("/eventName",rs.getString("eventname"));
				hm.put("/code",rs.getString("code"));
				hm.put("/role",rs.getString("role"));
				hm.put("/description",rs.getString("description"));
				hm.put("descriptiontype",rs.getString("descriptiontype"));
				hm.put("/category",rs.getString("category"));
				hm.put("/type",rs.getString("event_type"));
                hm.put("/venue",rs.getString("venue"));
				hm.put("/address1",rs.getString("address1"));
				hm.put("/address2",rs.getString("address2"));
				hm.put("/city",rs.getString("city"));
				hm.put("/state",rs.getString("state"));
				hm.put("/country",rs.getString("country"));
				hm.put("/region",rs.getString("region"));
				hm.put("/contactEmail",rs.getString("email"));
				hm.put("/contactPhone",rs.getString("phone"));
				hm.put("/comments",rs.getString("comments"));
                hm.put("/startYear",rs.getString("start_yy"));
				hm.put("/startMonth",rs.getString("start_mm"));
				hm.put("/startDay",rs.getString("start_dd"));
				hm.put("/startHour",rs.getString("start_hh"));
				hm.put("/startMinute",rs.getString("start_mi"));
				hm.put("/endYear",rs.getString("end_yy"));
				hm.put("/endMonth",rs.getString("end_mm"));
				hm.put("/endDay",rs.getString("end_dd"));
				hm.put("/endHour",rs.getString("end_hh"));
				hm.put("/endMinute",rs.getString("end_mi"));
		        hm.put("/configID",rs.getString("config_id"));
				hm.put("listatebee",rs.getString("listebee"));
				hm.put("listtype",rs.getString("listtype"));
				hm.put("eventunitid",rs.getString("unitid"));
				hm.put("evt_level",rs.getString("evt_level"));
				hm.put("longitude",rs.getString("longitude"));
				hm.put("latitude",rs.getString("latitude"));
				hm.put("eventid",eventid);
				hm.put("tags",rs.getString("tags"));
			}
		rs.close();
		pstmt.close();
		pstmt=null;

		getEventConfig(eventid,hm,con);
		if(hm==null) { throw new Exception();}
		hm.put("/search","no");
//		HashMap confighm=new HashMap();
		pstmt=con.prepareStatement(CONFIG_EVENTALL);
		pstmt.setString(1,eventid);
		rs=pstmt.executeQuery();
		while(rs.next()){
			hm.put(rs.getString("name"),rs.getString("value"));
                }
		rs.close();
		pstmt.close();
		pstmt=null;
		pstmt=con.prepareStatement(GET_EVENT_GROUPS);
			pstmt.setString(1,eventid);
			rs=pstmt.executeQuery();
			v=new Vector();
				while(rs.next()){
					v.add(rs.getString("groupid"));
				}
			if(v!=null&&v.size()>0)
			{
			String [] str= new String[v.size()];
			for(int i=0;i<v.size();i++)
			str[i]=(String)v.elementAt(i);
			hm.put("/groupids",str);
			}

			rs.close();
			pstmt.close();
			pstmt=null;

		hm.put("/timezone",(String)hm.get(EventConstants.TIMEZONE));
		hm.put("/search",(String)hm.get(EventConstants.SHOW_INSEARCH));
		hm.put("listatebee",(String)hm.get(EventConstants.SHOW_INSEARCH));
               	hm.put("/urlmap",(String)hm.get(EventConstants.EVENT_URLMAP));


	}catch(Exception e){
		System.out.println("Error in getEventInfo()"+e.getMessage());
		hm=null;
	}
	finally{
		try{
			if (pstmt!=null) pstmt.close();
			if(conclose){
				if(con!=null){ con.close();con=null;}
			}
		}catch(Exception e){}
	}
	return hm;
    }

  public int updateEventInfo(HashMap hm) {
	  	try{
	  		String eid=(String) hm.get("eventid");
	  		Integer.parseInt(eid);
	  	}catch (Exception e) {
			// TODO: handle exception
	  		return 0;
		}
		Connection con = null;
		int rcount = 0;
		java.sql.PreparedStatement pstmt = null;
		java.sql.PreparedStatement pstmt1 = null;
		try {
			con = EventbeeConnection.getWriteConnection("event");
			String startdate = (String) hm.get("/startYear") + "-"
					+ (String) hm.get("/startMonth") + "-"
					+ (String) hm.get("/startDay");
			String enddate = (String) hm.get("/endYear") + "-"
					+ (String) hm.get("/endMonth") + "-"
					+ (String) hm.get("/endDay");
			String starttime = (String) hm.get("/startHour") + ":"
					+ (String) hm.get("/startMinute");
			String endtime = (String) hm.get("/endHour") + ":"
					+ (String) hm.get("/endMinute");

			pstmt = con.prepareStatement(UPDATE_EVENT_QUERY);
			pstmt.setString(1, (String) hm.get("listtype"));
			pstmt.setString(2, (String) hm.get("listatebee"));
			pstmt.setString(3, (String) hm.get("/eventName"));
			if ("wysiwyg".equals((String) hm.get("descriptiontype")))
				pstmt.setString(4, (String) hm.get("fckdescription"));
			else
				pstmt.setString(4, (String) hm.get("fckdescription1"));
			pstmt.setString(5, (String) hm.get("/category"));
			pstmt.setString(6, (String) hm.get("/type"));

			pstmt.setString(7, (String) hm.get("/city"));
			pstmt.setString(8, (String) hm.get("/state"));
			pstmt.setString(9, (String) hm.get("/country"));
			pstmt.setString(10, startdate);
			pstmt.setString(11, enddate);
			pstmt.setString(12, (String) hm.get("/contactEmail"));
			pstmt.setString(13, starttime);
			pstmt.setString(14, endtime);
			pstmt.setString(15, (String) hm.get("/contactPhone"));
			pstmt.setString(16, (String) hm.get("/comments"));
			pstmt.setString(17, (String) hm.get("/address1"));
			pstmt.setString(18, (String) hm.get("/address2"));
			pstmt.setString(19, (String) hm.get("UPDATEEVTCODE"));
			pstmt.setString(20, (String) hm.get("source"));
			pstmt.setString(21, (String) hm.get("/evttype"));
			pstmt.setString(22, (String) hm.get("descriptiontype"));
			pstmt.setString(23, (String) hm.get("tags"));
			pstmt.setString(24, (String) hm.get("/venue"));
			pstmt.setString(25, (String) hm.get("/region"));
			pstmt.setString(26, (String) hm.get("eventid"));

			rcount = pstmt.executeUpdate();
			pstmt.close();
			pstmt = null;
			pstmt = con.prepareStatement(deletequery);
			pstmt.setString(1, (String) hm.get("eventid"));
			pstmt.executeUpdate();
			pstmt.close();
			pstmt = null;
			pstmt = con.prepareStatement(insertquery);
			String[] str = GenUtil.getStringArray(hm.get("groupids"));
			if (str != null) {
				for (int i = 0; i < str.length; i++) {
					pstmt.setString(1, (String) hm.get("eventid"));
					pstmt.setString(2, str[i]);
					rcount = pstmt.executeUpdate();
				}
			}
			pstmt.close();
			pstmt = null;

			updateEventConfig(hm, con);

			HashMap confighm = new HashMap();
			confighm.put(EventConstants.TIMEZONE, (String) hm.get("/timezone"));
			confighm.put(EventConstants.SHOW_INSEARCH, (String) hm
					.get("listatebee"));
			confighm.put(EventConstants.EVENT_URLMAP, (String) hm
					.get("/urlmap"));

			Set e = confighm.entrySet();
			for (Iterator i = e.iterator(); i.hasNext();) {
				Map.Entry entry = (Map.Entry) i.next();
				// rcount=updateConfig((String)hm.get("eventid"),(String)entry.getKey(),(String)entry.getValue(),con);
				updateConfig((String) hm.get("eventid"), (String) entry
						.getKey(), (String) entry.getValue(), con);
			}

			con.close();
			con = null;
		} catch (Exception e) {
			System.out.println("Error in updateEventInfo()" + e.getMessage());
		} finally {
			try {
				if (pstmt != null)
					pstmt.close();
				if (pstmt1 != null)
					pstmt1.close();
				if (con != null)
					con.close();
			} catch (Exception e) {
			}
		}
		return rcount;
	}

	public String getPoweredBy(String eventid){
		String poweredby="";
		Connection con=null;
		java.sql.PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			con=EventbeeConnection.getReadConnection("event");
			pstmt=con.prepareStatement(CONFIG_GET);
			pstmt.setString(1,eventid);
			pstmt.setString(2,EventConstants.POWERED_BY);
			rs=pstmt.executeQuery();
        	        if (rs.next()){
        	         	poweredby=rs.getString("desc");
        	        }
			rs.close();
			pstmt.close();
			pstmt=null;
		}catch(Exception e){
			System.out.println("Error in getPoweredBy()"+e.getMessage());
		}
		finally{
			try{
				if (pstmt!=null) pstmt.close();
				if(con!=null) con.close();
			}catch(Exception e){}
		}
		return poweredby;
	}

	public HashMap getTicketDesc(String eventid){
		HashMap hm=new HashMap();
		Connection con=null;
		ResultSet rs=null;
		java.sql.PreparedStatement pstmt=null;
		try{
			con=EventbeeConnection.getReadConnection("event");

			HashMap confighm=new HashMap();
			pstmt=con.prepareStatement(CONFIG_EVENTALL);
			pstmt.setString(1,eventid);
			rs=pstmt.executeQuery();
			while(rs.next()){
				confighm.put(rs.getString("name"),rs.getString("value"));
        	        }
			rs.close();
			pstmt.close();
			pstmt=null;

 			hm.put("memberdesc",(String)confighm.get(EventConstants.MEMBER_TICKET_STATEMENT));
			hm.put("publicdesc",(String)confighm.get(EventConstants.PUBLIC_TICKET_STATEMENT));
        	       	hm.put("optionaldesc",(String)confighm.get(EventConstants.OPTIONAL_TICKET_STATEMENT));
			hm.put("eventbeedesc",(String)confighm.get(EventConstants.EVENTBEE_TICKET_STATEMENT));
        	       	hm.put("refunddesc",(String)confighm.get(EventConstants.REFUND_POLICY));
        	       	hm.put("bookingtype",(String)confighm.get(EventConstants.ADMISSION_TYPE));
		}catch(Exception e){
			System.out.println("Error in getTicketDesc()"+e.getMessage());
		}
		finally{
			try{
				if (pstmt!=null) pstmt.close();
				if(con!=null) con.close();
			}catch(Exception e){}
		}
		return hm;
	}

	public String getConfig(String eventid,String desctype){
		String desc="";
		Connection con=null;
		ResultSet rs=null;
		java.sql.PreparedStatement pstmt=null;
		try{
			con=EventbeeConnection.getReadConnection("event");
			pstmt=con.prepareStatement(CONFIG_GET);
			pstmt.setString(1,eventid);
			pstmt.setString(2,desctype);
			rs=pstmt.executeQuery();
        	        if (rs.next()){
        	         	desc=rs.getString("desc");
        	        }
			rs.close();
			pstmt.close();
			pstmt=null;

		}catch(Exception e){
			System.out.println("Error in getConfig()"+e.getMessage());
			//desc=null;
		}
		finally{
			try{
				if (pstmt!=null) pstmt.close();
				if(con!=null) con.close();
			}catch(Exception e){}
		}
		return desc;
	}

	public static HashMap getConfig(String eventid){
	 	DBManager dbmanager=new DBManager();
		StatusObj statobj=dbmanager.executeSelectQuery(EVENT_CONFIG_VALUES,new String []{eventid});
		HashMap map=new HashMap();
		if(statobj.getStatus()){
			String [] columnnames=dbmanager.getColumnNames();
			for(int i=0;i<statobj.getCount();i++){
				for(int j=0;j<columnnames.length;j++){
					map.put(columnnames[j],dbmanager.getValue(i,columnnames[j],""));
				}
			}
		}
		return map;
	}




      public int updateConfig(String eventid,String desctype,String desc,Connection con){
		int rcount=0;
		java.sql.PreparedStatement pstmt=null;
		try{
			if(con==null)
			con=EventbeeConnection.getReadConnection("event");

			pstmt=con.prepareStatement(CONFIG_DELETE);
			pstmt.setString(1,eventid);
			pstmt.setString(2,desctype);
			rcount=pstmt.executeUpdate();
			pstmt.close();
			pstmt=null;
			pstmt=con.prepareStatement(CONFIG_INSERT);
			pstmt.setString(1,eventid);
			pstmt.setString(2,desctype);
			pstmt.setString(3,desc);
			rcount=pstmt.executeUpdate();
			pstmt.close();
			pstmt=null;

		}catch(Exception e){
			System.out.println("Error in updateConfig()"+e.getMessage());
		}finally{
			try{
				if (pstmt!=null) pstmt.close();
			}catch(Exception e){}
		}
		return rcount;
	}

	public int updateConfig(String eventid,String desctype,String desc){
		Connection con=null;
		int rcount=0;
		java.sql.PreparedStatement pstmt=null;
		try{
			con=EventbeeConnection.getWriteConnection("event");

			pstmt=con.prepareStatement(CONFIG_DELETE);
			pstmt.setString(1,eventid);
			pstmt.setString(2,desctype);
			rcount=pstmt.executeUpdate();
			pstmt.close();
			pstmt=null;
			pstmt=con.prepareStatement(CONFIG_INSERT);
			pstmt.setString(1,eventid);
			pstmt.setString(2,desctype);
			pstmt.setString(3,desc);
			rcount=pstmt.executeUpdate();
			pstmt.close();
			pstmt=null;

		}catch(Exception e){
			System.out.println("Error in updateConfig()"+e.getMessage());
		}
		finally{
			try{
				if (pstmt!=null) pstmt.close();
				if(con!=null) con.close();
			}catch(Exception e){}
		}
		return rcount;
	}


  public int getEventLevel(int eventid){
	Connection con=null;
	int evtLevel=0;
	java.sql.PreparedStatement pstmt=null;
	try{
		con=EventbeeConnection.getReadConnection("event");
		pstmt=con.prepareStatement(EVT_LEVEL_GET);
                pstmt.setInt(1,eventid);
                ResultSet rs=pstmt.executeQuery();
                if(rs.next()){
			evtLevel=rs.getInt("evt_level");
		}
		rs.close();
		pstmt.close();
		pstmt=null;
	}catch(Exception e){
		System.out.println("Error in getEventLevel()"+e.getMessage());
	}
	finally{
		try{
			if (pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}
	return evtLevel;
    }

 public Vector getLevels(){
	Connection con=null;
	Vector v=new Vector();
	java.sql.PreparedStatement pstmt=null;
	try{
		con=EventbeeConnection.getReadConnection("event");
		pstmt=con.prepareStatement(EVT_LEVELS);
	        ResultSet rs=pstmt.executeQuery();
                while(rs.next()){
			String s=rs.getInt("evt_level")+"";
			v.add(s);
		}
		rs.close();
		pstmt.close();
		pstmt=null;
	}catch(Exception e){
		System.out.println("Error in getLevels()"+e.getMessage());
	}
	finally{
		try{
			if (pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}
	return v;
    }

 public StatusObj upgradeEvtLevel(int evtid,int evtlevel){
	int rcount=0;
	Connection con=null;
	java.sql.PreparedStatement pstmt=null;
	StatusObj statusObj=null;
	try{

 		 con=EventbeeConnection.getWriteConnection("event");
      	         pstmt=con.prepareStatement(EVT_LEVEL_UPDATE);
		 pstmt.setInt(1,evtlevel);
		 pstmt.setInt(2,evtid);
		 rcount=pstmt.executeUpdate();

		pstmt.close();
		pstmt=null;
		if(rcount==1){
			statusObj=new StatusObj(true, "success", null);
		}else{
			statusObj=new StatusObj(false, "No matching record found",null);
		}
	}catch(Exception e){
		System.out.println("Error in updateSprProfileEntry:" +e.getMessage());
		statusObj=new StatusObj(false,e.getMessage(),null);
	}
        finally{
		try{
			if(pstmt!=null) pstmt.close();
			con.close();
		}catch(Exception e){
			statusObj=new StatusObj(false, e.getMessage(),null);
		}
	}
	return statusObj;
   }

}
