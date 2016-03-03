package com.eventbee.event;
import com.eventbee.general.StatusObj;
import com.eventbee.general.DbUtil;
import com.eventbee.general.*;
import com.eventbee.event.eventlevel.*;
import java.util.*;
public class EventInfoDb{
final static String EVENT_LOCATION_QUERY="select countryname,countrycode,statename,statecode,disposition from country_states where statecode||'~'||countrycode in (select distinct state||'~'||country from eventinfo) "
+" union "
+" select countryname,countrycode,'' as statename,'' as statecode,disposition from country_states where countrycode in (select country from eventinfo) and statecode is null  order by disposition ";
final static String ZONE_LOCATION_QUERY="select countryname,countrycode,statename,statecode,disposition from country_states where statecode||'~'||countrycode in (select distinct state||'~'||country from clubinfo) "
+" union "
+" select countryname,countrycode,'' as statename,'' as statecode,disposition from country_states where countrycode in (select country from clubinfo) and statecode is null  order by disposition ";
final static String MEMBER_LOCATION_QUERY=" select countryname,countrycode,statename,statecode,disposition from country_states where statecode||'~'||countrycode in (select distinct state||'~'||country from user_profile b,authentication a where a.user_id=b.user_id  and a.unit_id=?) "
 +" union "
 +" select countryname,countrycode,'' as statename,'' as statecode,disposition from country_states where countrycode in (select country from user_profile b,authentication a where a.user_id=b.user_id  and a.unit_id=?) and statecode is null  order by disposition ";

final static String CLASSIFIED_LOCATION_QUERY=" select countryname,countrycode,statename,statecode,disposition from country_states where statecode||'~'||countrycode in (select distinct state||'~'||country from classifieds c,classified_group c1 where c.classifiedid=c1.classifiedid and c1.groupid=? and purpose=? ) "
 +" union "
 +" select countryname,countrycode,'' as statename,'' as statecode,disposition from country_states where countrycode in (select country from classifieds c,classified_group c1 where c.classifiedid=c1.classifiedid and c1.groupid=? and purpose=?) and statecode is null  order by disposition ";

 final static  String GET_EVENTMEMBER_CLUBS=" select distinct c.clubid,clubname,c1.updated_by,c.config_id from clubinfo c "
					+" ,club_member c1,config c2 where c.config_id=c2.config_id "
					+" and (getHubMemberStatus(c.clubid||'',userid)='HUBMGR' "
					+" or (getHubMemberStatus(c.clubid||'',userid)='HUBMEMBER' "
					+" and getMemberEventConfigvalue(c.config_id||'')='Yes'))  "
					+" and c.clubid=c1.clubid and userid=? ";
final static String GET_CLUB_EVENTS="select a.unitid,a.eventid ,a.eventname,a.evt_level as evtlevel,a.address1,a.address2,"
	+" a.start_date+cast(cast(a.starttime as text) as time) as stdatess,a.start_date as sdate, "
	+" to_char(a.start_date+cast(cast(a.starttime as text) as time),'HH12:MI AM') as ampm,"
 	+" a.description,a.city,a.state,a.country,trim(to_char(a.start_date,'Day')) ||', '|| to_char(a.start_date,'Month DD, YYYY') as start_date,"
 	+" to_char(a.end_date,'MM-DD-YY') as end_date,a.event_type, a.mgr_id, "
 	+" getMemberName(''||mgr_id) as user_name,getMemberPref(mgr_id||'','pref:myurl','') as username"
	+"  from eventinfo a,event_group e  "
 	+"  where a.eventid=e.eventid and a.status='ACTIVE' "
	+"  and  e.groupid=CAST(? AS INTEGER) ";
public static HashMap getClubsForEvents(String userid)
{
   	HashMap hm=new HashMap();
   	DBManager dbmanager=new DBManager();
	StatusObj statobj=dbmanager.executeSelectQuery(GET_EVENTMEMBER_CLUBS,new String[]{userid});
	int recordcount=statobj.getCount();
	for(int i=0;i<recordcount;i++){
		hm.put(dbmanager.getValue(i,"clubid",""),dbmanager.getValue(i,"clubname",""));
	}
	  return hm;
}

 public static HashMap getClassifiedLocations(String groupid,String purpose)
{
String [] inputparams=new String[]{groupid,purpose,groupid,purpose};
return getLocations(CLASSIFIED_LOCATION_QUERY,inputparams);
}
public static HashMap getMemberLocations(String unitid)
{
String [] inputparams=new String[]{unitid,unitid};
return getLocations(MEMBER_LOCATION_QUERY,inputparams);
}
public static HashMap getEventLocations()
{
String [] inputparams=new String[]{};
return getLocations(EVENT_LOCATION_QUERY,inputparams);
}
public static HashMap getClubLocations()
{
String [] inputparams=new String[]{};
return getLocations(ZONE_LOCATION_QUERY,inputparams);
}
public static HashMap getLocations(String query,String [] inputparams){
 	DBManager dbmanager=new DBManager();
	StatusObj statobj=dbmanager.executeSelectQuery(query,inputparams);
	int recordcount=statobj.getCount();
	ArrayList Locations1=new ArrayList();
	ArrayList LocationVals1=new ArrayList();
	String countrycode="";
	String statename="";
	String statecode="";
	String countryname="";
	String country="";
		for(int i=0;i<recordcount;i++){


		statecode=dbmanager.getValue(i,"statecode","");
		countrycode=dbmanager.getValue(i,"countrycode","");
		countryname=dbmanager.getValue(i,"countryname","");
		statename=dbmanager.getValue(i,"statename","");
		if(country.equals(countryname))
		{
		}
		else
		{
		country=countryname;
		Locations1.add("---"+countryname+"---");
		LocationVals1.add("All~"+countrycode);
		}
		if("".equals(statecode))
		{}
		else
		{
		Locations1.add(statename);
		LocationVals1.add(statecode+"~"+countrycode);
		}
		}
		String [] Locations=new String[Locations1.size()];
		String [] LocationVals=new String[LocationVals1.size()];
		for(int i=0;i<Locations.length;i++)
		{
		Locations[i]=(String)Locations1.get(i);
		LocationVals[i]=(String)LocationVals1.get(i);
		}


	HashMap hm=new HashMap();
	hm.put("Locations",Locations);
	hm.put("LocationVals",LocationVals);
	return hm;
}
public static HashMap getEvents(int maxcount,Vector sdorder,HashMap param){

 String query="select a.unitid,a.eventid ,a.eventname,a.evt_level as evtlevel,a.address1,a.address2,"
	+" a.start_date+cast(cast(a.starttime as text) as time) as stdatess,a.start_date as sdate, "
	+" to_char(a.start_date+cast(cast(a.starttime as text) as time),'HH12:MI AM') as ampm,"
 	+" a.description,a.city,a.state,a.country,trim(to_char(a.start_date,'Day')) ||', '|| to_char(a.start_date,'Month DD, YYYY') as start_date,"
 	+" to_char(a.end_date,'MM-DD-YY') as end_date,a.event_type, a.mgr_id,a.photourl,a.premiumlevel, "
 	+" getMemberName(''||mgr_id) as user_name,getEventTicketCount(''||a.eventid) as tcount"
	+"  ,getMemberPref(mgr_id||'','pref:myurl','') as username from eventinfo a  "
 	+"  where a.status='ACTIVE' "
	+" and listType='PBL' "
	+"  and  a.unitid=CAST(? AS INTEGER)  ";
 	HashMap sdevents=new HashMap();
	getMemMap(maxcount,param,query,sdevents,sdorder);


	 return sdevents;
 }

 public static void getMemMap(int maxcount,HashMap param,String query,HashMap sdevents,Vector sdorder)
 {
 ArrayList paramlist=new ArrayList();

 paramlist.add((String)param.get("unitid"));

 getEventMap(maxcount,param,query,sdevents,paramlist,sdorder);
 }

 public static void getMgrMap(int maxcount,HashMap param,String query,HashMap sdevents,Vector sdorder)
 {
 ArrayList paramlist=new ArrayList();
  getEventMap(maxcount,param,query,sdevents,paramlist,sdorder);
 }



 public static void getEventMap(int maxcount,HashMap param,String query,HashMap sdevents,ArrayList paramlist,Vector sdorder)
 {
  int count=0;

 	java.sql.Connection con=null;
 	java.sql.PreparedStatement pstmt=null;

 	java.sql.ResultSet rs=null;

	if (param!=null){
             if("All".equals((String)param.get("category"))){

 	    }else if ((String)param.get("category")!=null){
                  query=query+" and a.category=?";
 		 paramlist.add((String)param.get("category"));
 	   }
         if ((String)param.get("keyword")!=null){
                 query=query+" and lower(a.eventname) like ?";
 		paramlist.add("%"+((String)param.get("keyword")).toLowerCase() +"%");
            }
        	if("All".equals((String)param.get("type"))){
           }else if ((String)param.get("type")!=null){
                 query=query+" and a.event_type=?";
 		paramlist.add((String)param.get("type"));
            }
         if ((String)param.get("location")!=null){
                 query=query+" and a.state=?";
 		paramlist.add((String)param.get("location"));
            }
	     if ((String)param.get("country")!=null){
                 query=query+" and a.country=?";
 		paramlist.add((String)param.get("country"));
            }
         if ((String)param.get("startdate")!=null){
            query=query+" and to_date(a.start_date::TEXT,'yyyy-MM-dd')>=to_date(?,'yyyy-MM-dd')";
 	   paramlist.add((String)param.get("startdate"));
           }
	   if ((String)param.get("evttype")!=null){
            query=query+" and type=?";
 	   paramlist.add((String)param.get("evttype"));
           }
	   if ((String)param.get("tags")!=null){
	   //System.out.println("tags: "+(String)param.get("tags"));
            query=query+" and lower(tags) like '%"+((String)param.get("tags")).toLowerCase()+"%' ";
 	 //  paramlist.add((String)param.get("tags"));
           }
         }
	 query=query+" order by stdatess";

	try{

 		con=EventbeeConnection.getConnection();
		pstmt=con.prepareStatement(query);
		for (int i=0;i<paramlist.size();i++){
		  pstmt.setString(i+1,(String)paramlist.get(i));

		}


			rs=pstmt.executeQuery();



			while(rs.next()&& (maxcount==-1 || count<maxcount)){
				count++;
				String startdate=rs.getString("start_date");
				Vector sdevent=(Vector)sdevents.get(startdate);
				if(sdevent==null){
					sdevent=new Vector();
					sdorder.add(startdate);
				}
				HashMap event=new HashMap();

 				event.put("name",rs.getString("eventname"));
 				event.put("evtlevel",rs.getString("evtlevel"));
 				event.put("description", rs.getString("description"));
 				event.put("address1",rs.getString("address1"));
 				event.put("address2",rs.getString("address2"));
				String locval=GenUtil.getCSVData(new String[]{rs.getString("city"),rs.getString("state"),rs.getString("country")});
 				event.put("location",locval);
				event.put("startdate",startdate);
				event.put("sdate",rs.getString("sdate"));
				event.put("eventid",rs.getString("eventid"));
 				event.put("userid",rs.getString("mgr_id"));
 				event.put("photourl",rs.getString("photourl"));
				event.put("tcount",rs.getString("tcount"));
				event.put("premiumlevel",rs.getString("premiumlevel"));
				event.put("username",rs.getString("username"));

				String name=rs.getString("user_name");
				event.put("user_name",name);
				event.put("eventtime",rs.getString("ampm"));
				sdevent.add(event);
				sdevents.put(startdate,sdevent);
		}
		rs.close();
		pstmt.close();
		pstmt=null;
		con.close();
	}catch(Exception e){
               // EventbeeLogger.logException("com.eventbee.exception",EventbeeLogger.INFO,FILE_NAME,"getFeaturedEvents()","Exception in getFeaturedEvents():",e);
	       System.out.println("exception in"+e.getMessage());

	}finally{
		try{
			if(pstmt!=null)
				pstmt.close();
			if(con!=null)
				con.close();
		}catch(Exception ex){}
	}

	if(!(sdevents.size()>0)){
		sdevents=null;
	}

 }
 public static Vector getClubNames(String [] groups)
	{
	String query="select clubname from clubinfo where clubid=?";
	java.sql.Connection con=null;
 	java.sql.PreparedStatement pstmt=null;
	java.sql.ResultSet rs=null;
	Vector v=new Vector();
	try{
 		con=EventbeeConnection.getConnection();
		pstmt=con.prepareStatement(query);
		for(int i=0;i<groups.length;i++)
		{
		pstmt.setString(1,groups[i]);
		rs=pstmt.executeQuery();
		if(rs.next())
		v.add(rs.getString("clubname"));
		}
		rs.close();
		pstmt.close();
		pstmt=null;
		con.close();
		}
		catch(Exception e){
                //EventbeeLogger.logException("com.eventbee.exception",EventbeeLogger.INFO,FILE_NAME,"getClubNames(String [])","Exception in getFeaturedEvents():",e);
	       System.out.println("exception in"+e.getMessage());

	}finally{
		try{
			if(pstmt!=null)
				pstmt.close();
			if(con!=null)
				con.close();
		}catch(Exception ex){}
	}
	return v;

	}

public static	HashMap getHubEventMap(String groupid,Vector sdorder)
{
int count=0;
java.sql.Connection con=null;
java.sql.PreparedStatement pstmt=null;
java.sql.ResultSet rs=null;
HashMap eventsmap=new HashMap();
try{

 		con=EventbeeConnection.getConnection();
		pstmt=con.prepareStatement(GET_CLUB_EVENTS);
		pstmt.setString(1,groupid);
		rs=pstmt.executeQuery();
		while(rs.next()){
				count++;
				String startdate=rs.getString("start_date");
				Vector sdevent=(Vector)eventsmap.get(startdate);
				if(sdevent==null){
					sdevent=new Vector();
					sdorder.add(startdate);
				}
				HashMap event=new HashMap();

 				event.put("name",rs.getString("eventname"));
 				event.put("evtlevel",rs.getString("evtlevel"));
 				event.put("description", rs.getString("description"));
 				event.put("address1",rs.getString("address1"));
 				event.put("address2",rs.getString("address2"));
				String locval=GenUtil.getCSVData(new String[]{rs.getString("city"),rs.getString("state"),rs.getString("country")});
 				event.put("location",locval);
				event.put("startdate",startdate);
				event.put("sdate",rs.getString("sdate"));
				event.put("eventid",rs.getString("eventid"));
 				event.put("userid",rs.getString("mgr_id"));

				String name=rs.getString("user_name");
				event.put("user_name",name);
				event.put("eventtime",rs.getString("ampm"));
				sdevent.add(event);
				eventsmap.put(startdate,sdevent);
				eventsmap.put("count",count+"");
		}
		rs.close();
		pstmt.close();
		pstmt=null;
		con.close();
	}catch(Exception e){
                   System.out.println("exception in"+e.getMessage());

	}finally{
		try{
			if(pstmt!=null)
				pstmt.close();
			if(con!=null)
				con.close();
		}catch(Exception ex){}
	}

	return eventsmap;

 }
public static Vector getAllEventsForClub(String groupid)
{
String query=" select eventname,a.eventid,getMemberName(mgr_id) as membername,mgr_id  from eventinfo a, "
		+" event_group b where a.eventid=b.eventid and b.groupid=? ";
		Vector evtvect=new Vector();
DBManager dbmanager=new DBManager();
	StatusObj statobj=dbmanager.executeSelectQuery(query,new String[]{groupid});
	int recordcount=statobj.getCount();
	String eventname="";
	String eventid="";
	String membername="";
	String mgr_id="";
	for(int i=0;i<recordcount;i++){
		HashMap hm=new HashMap();
		 eventname=dbmanager.getValue(i,"eventname","");
		 eventid=dbmanager.getValue(i,"eventid","");
		 membername=dbmanager.getValue(i,"membername","");
		 mgr_id=dbmanager.getValue(i,"mgr_id","");
		hm.put("eventname",eventname);
		hm.put("eventid",eventid);
		hm.put("membername",membername);
		hm.put("mgr_id",mgr_id);
		evtvect.add(hm);
}
return evtvect;
}

public static int deleteFromeventsgroup(String eventids[],String groupid)
	{
	String deleteevent="delete from event_group where eventid=? and groupid=?";
		java.sql.Connection con=null;
java.sql.PreparedStatement pstmt=null;
		int res=0;
		try
		{
			con=EventbeeConnection.getReadConnection();
			pstmt=con.prepareStatement(deleteevent);
			for(int i=0;i<eventids.length;i++)
			{
				pstmt.setString(1,eventids[i]);
				pstmt.setString(2,groupid);
				res+=pstmt.executeUpdate();
			}
			pstmt.close();
			pstmt=null;
			con.close();
			con=null;
		}
		catch(Exception e){
		System.out.println(e.getMessage());
	//EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR,"ClassifiedDB", "DeleteClassifieds(String classfiedids[])", e.getMessage(), e);
		}
		finally{
			try{
				if(pstmt!=null)
					pstmt.close();
				if(con!=null)
					con.close();
			}catch(Exception ex){}
		}
		return res;
	}

 public static HashMap getPremiumEvents(int maxcount,Vector sdorder,HashMap param){

 String query="select a.unitid,a.eventid ,a.eventname,a.evt_level as evtlevel,a.address1,a.address2,"
	+" a.start_date+cast(cast(a.starttime as text) as time) as stdatess,a.start_date as sdate, "
	+" to_char(a.start_date+cast(cast(a.starttime as text) as time),'HH12:MI AM') as ampm,"
 	+" a.description,a.city,a.state,a.country,trim(to_char(a.start_date,'Day')) ||', '|| to_char(a.start_date,'Month DD, YYYY') as start_date,"
 	+" to_char(a.end_date,'MM-DD-YY') as end_date,a.event_type, a.mgr_id, "
 	+" getMemberName(''||mgr_id) as user_name,getEventTicketCount(''||a.eventid) as tcount,premiumlevel,photourl "
	+"  ,getMemberPref(mgr_id||'','pref:myurl','') as username from eventinfo a  "
 	+"  where a.status='ACTIVE' "
	+"  and a.listType='PBL' "
	+"  and  premiumlevel in ('EVENT_PREMIUM_LISTING','EVENT_FEATURED_LISTING','EVENT_CUSTOM_LISTING') and a.unitid=? ";

 	HashMap sdevents=new HashMap();
	getMemMap(maxcount,param,query,sdevents,sdorder);


	 return sdevents;
 }

 public static HashMap getFeaturedEvents(int maxcount,Vector sdorder,HashMap param){

 String query="select a.unitid,a.eventid ,a.eventname,a.evt_level as evtlevel,a.address1,a.address2,"
	+" a.start_date+cast(cast(a.starttime as text) as time) as stdatess,a.start_date as sdate, "
	+" to_char(a.start_date+cast(cast(a.starttime as text) as time),'HH12:MI AM') as ampm,"
 	+" a.description,a.city,a.state,a.country,trim(to_char(a.start_date,'Day')) ||', '|| to_char(a.start_date,'Month DD, YYYY') as start_date,"
 	+" to_char(a.end_date,'MM-DD-YY') as end_date,a.event_type, a.mgr_id, "
 	+" getMemberName(''||mgr_id) as user_name,getEventTicketCount(''||a.eventid) as tcount,premiumlevel,photourl "
	+"  ,getMemberPref(mgr_id||'','pref:myurl','') as username from eventinfo a  "
 	+"  where a.status='ACTIVE' "
	+"  and a.listType='PBL' "
	+"  and  premiumlevel in ('EVENT_FEATURED_LISTING','EVENT_CUSTOM_LISTING') and a.unitid=? ";

 	HashMap sdevents=new HashMap();
	getMemMap(maxcount,param,query,sdevents,sdorder);


	 return sdevents;
 }
public static void deleteTicket(String [] ticketids){
	java.sql.Connection con=null;
	java.sql.PreparedStatement pstmt=null;
	int rcount=0;
		try{
			con=EventbeeConnection.getReadConnection("event");
			pstmt=con.prepareStatement("update price set status='d' where price_id=?");
			if(ticketids!=null){
			for(int i=0;i<ticketids.length;i++)
			{
			pstmt.setString(1,ticketids[i]);
			rcount=pstmt.executeUpdate();
			}}
			pstmt.close();
			pstmt=null;
			con.close();
		}catch(Exception e){
                        System.out.println(" error in deleteTicket(String [])"+e.getMessage());
		}finally{
			try{
				if (pstmt!=null) pstmt.close();
				if (con!=null) 	 con.close();
			}catch(Exception ex){}
		}
}
 public static HashMap getMap(DBManager dbmanager,int position,String [] columnnames)
{
	HashMap map=new HashMap();
	for(int i=0;i<columnnames.length;i++){
		map.put(columnnames[i],dbmanager.getValue(position,columnnames[i],""));
	}
return map;
}
 public static HashMap getNewEventMap(HashMap param,Vector sdorder){
	ArrayList paramlist=new ArrayList();
	HashMap sdevents=new HashMap();
 	String query="select a.unitid,a.eventid ,a.eventname,a.evt_level as 	evtlevel,a.address1,a.address2,"
	+" a.start_date+cast(cast(a.starttime as text) as time) as stdatess,a.start_date as sdate, "
	+" to_char(a.start_date+cast(cast(a.starttime as text) as time),'HH12:MI AM') as ampm,"
 	+" a.description,a.city,a.state,a.country,trim(to_char(a.start_date,'Day')) ||', '|| to_char(a.start_date,'Month DD, YYYY') as start_date,"
 	+" to_char(a.end_date,'MM-DD-YY') as end_date,a.event_type, a.mgr_id,a.photourl,a.premiumlevel, "
 	+" getMemberName(''||mgr_id) as user_name,getEventTicketCount(''||a.eventid) as tcount"
	+"  ,b.login_name as username from eventinfo a,authentication b "
 	+"  where a.status='ACTIVE' and a.mgr_id=b.user_id::INTEGER"
	+" and listType='PBL' ";
 	try{
	if (param!=null){
             if("All".equals((String)param.get("category"))){

 	    }else if ((String)param.get("category")!=null){
                  query=query+" and a.category=?";
 		 paramlist.add((String)param.get("category"));
 	   }
         if (param.get("keywords")!=null){
		String [] keywords=(String [])param.get("keywords");
		if(keywords.length>0){
		query=query+" and (";
		for( int k=0;k<keywords.length;k++){
			if(k>0)
			query=query+" or ";
                	query=query+" lower(a.eventname) like ?";
			paramlist.add("%"+(keywords[k].toLowerCase() +"%"));
		}
		query=query+" ) ";
		}
            }
        	if("All".equals((String)param.get("type"))){
           }else if ((String)param.get("type")!=null){
                 query=query+" and a.event_type=?";
 		paramlist.add((String)param.get("type"));
            }
         if ((String)param.get("location")!=null&&!"null".equals((String)param.get("location"))&&!"USA".equals((String)param.get("location"))){
		                  query=query+" and (lower(a.region)=?) ";

	                 EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, "EventInfoDb ", "location loop--->", "query value in location loop isss--->="+query, null);

 		paramlist.add(((String)param.get("location")).toLowerCase());
	}
	if((String[])param.get("states")!=null){
		String[] states=(String[])param.get("states");
		if(states.length>0){
                 query=query+" and (";
		for (int k=0;k<states.length;k++)
		{
			if(k>0)
			query=query+" or ";
			query=query+" state = ? ";
			paramlist.add(states[k]);
		}
		query=query+" ) ";
		}
	}
	     if((String)param.get("location")==null||"USA".equals((String)param.get("location"))){


                 query=query+" and a.country='USA'";
                 EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, "EventInfoDb ", "country loop--->", "query value in country loop isss--->="+query, null);
 		//paramlist.add((String)param.get("country"));
            }
         if ((String)param.get("startdate")!=null){
            query=query+" and to_date(a.start_date::TEXT,'yyyy-MM-dd')>=to_date(?,'yyyy-MM-dd')";
 	   paramlist.add((String)param.get("startdate"));
           }
	   if ((String)param.get("evttype")!=null){
            query=query+" and type=?";
 	   paramlist.add((String)param.get("evttype"));
           }
	   if ((String)param.get("tags")!=null&&!"null".equals((String)param.get("tags"))){
	      query=query+" and lower(tags) like '%"+((String)param.get("tags")).toLowerCase()+"%' ";
 	     }
         }
	 query=query+" order by stdatess";
    EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, "EventInfoDb ", "query--->", "final query isss--->="+query, null);

	DBManager dbmanager=new DBManager();
	StatusObj statobj=dbmanager.executeSelectQuery(query,(String [])paramlist.toArray(new String[paramlist.size()]));
	int recordcount=statobj.getCount();
	if(recordcount>0)
	for(int i=0;i<recordcount;i++){
		String startdate=dbmanager.getValue(i,"start_date","");
		Vector sdevent=(Vector)sdevents.get(startdate);
		if(sdevent==null){
			sdevent=new Vector();
			sdorder.add(startdate);
		}
				HashMap event=getMap(dbmanager,i,dbmanager.getColumnNames());
 				event.put("name",dbmanager.getValue(i,"eventname",""));
 				String locval=GenUtil.getCSVData(new String[]{dbmanager.getValue(i,"region",""),dbmanager.getValue(i,"state",""),dbmanager.getValue(i,"country","")});
 				event.put("location",locval);
 				event.put("userid",dbmanager.getValue(i,"mgr_id",""));
				event.put("eventtime",dbmanager.getValue(i,"ampm",""));
				sdevent.add(event);
				sdevents.put(startdate,sdevent);
		}

	}catch(Exception e){
               System.out.println("exception in"+e.getMessage());

	}
	if(!(sdevents.size()>0)){
		sdevents=null;
	}
return sdevents;
 }

}


