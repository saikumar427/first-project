package com.eventbee.general;
import com.eventbee.general.*;
import java.util.*;
import java.sql.*;
public class HitDB{



	static final String Hit_Query="insert into Hit_Track(source,resource,sessionid,access_at,id,userid)"
				+" values(?,?,?,now(),?,?) ";

	static final String Hot_Events_Query="select e.mgr_id,id,count(id),e.evt_level,e.eventname,city,state,country,to_char(start_date,'Month DD, YYYY') as starttime "
			     +" ,getMemberPref(mgr_id||'','pref:myurl','') as username from Hit_track h,eventinfo e "
			     +" where e.eventid=id and resource='Event' and status='ACTIVE' and e.listType='PBL' "
			     +" and e.category like ? "
			     +" and e.unitid='13579' "
			     +" and isEventMgrActive(e.role,''||e.mgr_id,''||e.unitid)='Yes' "
			     +" and e.start_date>=now() "
			     +" group by e.mgr_id,id,eventname,city,state,country,start_date,e.evt_level,e.category order by count desc ";

	static final String Event_Statistics="select e.status,e.evt_level,e.listtype, to_char(e.created_at,'Mon dd, YYYY') as created_at,e.updated_at "
					     +"	from eventinfo e"
					     +" where e.eventid=? ";
	static final String get_count="select count(id) from Hit_Track where id=?";

	static final String Config_Query="select name,value from config where config_id in (select config_id from eventinfo where eventid=CAST(? as INTEGER)) "
					  +" and name in ('event.publish.showinsearch','event.poweredbyEB','event.power.ebee') ";

	static final String Zone_Statistics="select to_char(created_at,'MM/DD/YYYY') as created_at from clubinfo "
						+" where clubid=CAST(? as INTEGER)";
	static final String Zone_config="select name,value from config where config_id in (select config_id from clubinfo where clubid=CAST(? AS INTEGER)) "
					  +" and name in ('club.listateventbee') ";

	public static StatusObj insertHit(String[] inputparams){
		StatusObj stob=DbUtil.executeUpdateQuery(Hit_Query,inputparams);
		return stob;
	}
	public static String getCount(String id){
		Connection con=null;
		return getCount(id,con);
	}
	public static String getCount(String id,Connection con){
		PreparedStatement pstmt=null;
		String count="0";
		ResultSet rs=null;
		boolean conclose=false;

		try{
			if(con==null){
				con=EventbeeConnection.getReadConnection();
				conclose=true;
			}
			pstmt=con.prepareStatement(get_count);
			pstmt.setString(1,id);
			rs=pstmt.executeQuery();
			if(rs.next()){
				count=rs.getString("count");
			}
			pstmt.close();
			rs=null;
		}catch(Exception e){
			System.out.println("Exception Occured at getCount in HitDB.java:"+e);
			count=null;
		}finally{
			try{
				if(pstmt!=null){pstmt.close();pstmt=null;}
				if(conclose){
					if(con!=null){ con.close();con=null;}
				}
			}catch(Exception ee){}
		}
	return count;
	}
	public static Vector getHotEvents(int eventscount){
		Connection con=null;
		return getHotEvents(eventscount,"%",con);
	}
	public static Vector getHotEvents(int eventscount,String categeory){
		Connection con=null;
		return getHotEvents(eventscount,categeory,con);
	}
	public static Vector getHotEvents(int eventscount,String categeory,Connection con){
		PreparedStatement pstmt=null;
		Vector v=new Vector();
		ResultSet rs=null;
		boolean conclose=false;
		int i=0;
		try{
			if(con==null){
				con=EventbeeConnection.getReadConnection();
				conclose=true;
			}
			pstmt=con.prepareStatement(Hot_Events_Query);

			if(categeory==null || "".equals(categeory.trim()) || "All".equalsIgnoreCase(categeory.trim()))
				categeory="%";
			else
				categeory=categeory.trim();

			pstmt.setString(1,categeory);
			rs=pstmt.executeQuery();
			while(rs.next()){
				if(i<eventscount){
					HashMap hm=new HashMap();
					hm.put("eventid",rs.getString("id"));
					hm.put("count",rs.getString("count"));
					hm.put("eventname",rs.getString("eventname"));
					String location=rs.getString("city");
					if(("".equals(rs.getString("state")))||(rs.getString("state"))==null)
				{
				}
				else{
				location=location+", "+rs.getString("state");
				}
 				if(("".equals(rs.getString("country")))||(rs.getString("country"))==null)
				{
				}
				else{
				location=location+", "+rs.getString("country");
				}
				hm.put("location",location);
					hm.put("city",rs.getString("city"));
					hm.put("state",rs.getString("state"));
					hm.put("country",rs.getString("country"));
					hm.put("starttime",rs.getString("starttime"));
					hm.put("evtlevel",rs.getString("evt_level"));
					v.add(hm);
					i++;
				}
				else
			 	   break;
			}
			pstmt.close();
			rs=null;
		}catch(Exception e){
			System.out.println("Exception Occured at gethotevents in HitDB.java:"+e);
			v=null;
		}finally{
			try{
				if(pstmt!=null){pstmt.close();pstmt=null;}
				if(conclose){
					if(con!=null){ con.close();con=null;}
				}
			}catch(Exception ee){}
		}
	return v;
	}
	public static HashMap getEventStatistics(String eventid){
		Connection con=null;
		return getEventStatistics(eventid,con);
	}
	public static HashMap getEventStatistics(String eventid,Connection con){
		PreparedStatement pstmt=null;
		HashMap hm=new HashMap();
		ResultSet rs=null;
		boolean conclose=false;

		try{
			if(con==null){
				con=EventbeeConnection.getReadConnection();
				conclose=true;
			}
			pstmt=con.prepareStatement(Event_Statistics);
			pstmt.setString(1,eventid);
			rs=pstmt.executeQuery();
			if(rs.next()){
				hm.put("count",getCount(eventid,con));
				hm.put("created_at",rs.getString("created_at"));
				hm.put("updated_at",rs.getString("updated_at"));
				hm.put("evt_level",rs.getString("evt_level"));
				hm.put("listtype",rs.getString("listtype"));
				hm.put("status",rs.getString("status"));
				hm.put("configvalues",getConfigValues(eventid));
			}
			pstmt.close();
			rs=null;
		}catch(Exception e){
			System.out.println("Exception Occured at getEventStatistics in HitDB.java:"+e);
			hm=null;
		}finally{
			try{
				if(pstmt!=null){pstmt.close();pstmt=null;}
				if(conclose){
					if(con!=null){ con.close();con=null;}
				}
			}catch(Exception ee){}
		}
	return hm;
	}
	public static HashMap getZoneStatistics(String clubid){
		Connection con=null;
		return getZoneStatistics(clubid,con);
	}
	public static HashMap getZoneStatistics(String clubid,Connection con){
		PreparedStatement pstmt=null;
		HashMap hm=new HashMap();
		ResultSet rs=null;
		boolean conclose=false;

		try{
			if(con==null){
				con=EventbeeConnection.getReadConnection();
				conclose=true;
			}
			pstmt=con.prepareStatement(Zone_Statistics);
			pstmt.setString(1,clubid);
			rs=pstmt.executeQuery();
			if(rs.next()){
				hm.put("count",getCount(clubid,con));
				hm.put("created_at",rs.getString("created_at"));
				hm.put("configvalues",getConfigValues(clubid,Zone_config,con));
			}
			pstmt.close();
			rs=null;
		}catch(Exception e){
			System.out.println("Exception Occured at getZoneStatistics in HitDB.java:"+e);
			hm=null;
		}finally{
			try{
				if(pstmt!=null){pstmt.close();pstmt=null;}
				if(conclose){
					if(con!=null){ con.close();con=null;}
				}
			}catch(Exception ee){}
		}
	return hm;
	}
	public static HashMap getConfigValues(String id){
		Connection con=null;
		return getConfigValues(id,Config_Query,con);
	}
	public static HashMap getConfigValues(String id,String Query){
		Connection con=null;
		return getConfigValues(id,Query,con);
	}
	public static HashMap getConfigValues(String id,String Query,Connection con){
		PreparedStatement pstmt=null;
		HashMap hm=new HashMap();
		ResultSet rs=null;
		boolean conclose=false;

		try{
			if(con==null){
				con=EventbeeConnection.getReadConnection();
				conclose=true;
			}
			pstmt=con.prepareStatement(Query);
			pstmt.setString(1,id);
			rs=pstmt.executeQuery();
			while(rs.next()){
				hm.put(rs.getString("name"),rs.getString("value"));
			}
			pstmt.close();
			rs=null;
		}catch(Exception e){
			System.out.println("Exception Occured at getConfigValues in HitDB.java:"+e);
			hm=null;
		}finally{
			try{
				if(pstmt!=null){pstmt.close();pstmt=null;}
				if(conclose){
					if(con!=null){ con.close();con=null;}
				}
			}catch(Exception ee){}
		}
	return hm;
	}

}
