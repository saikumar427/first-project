package com.eventbee.streamer;

import com.eventbee.general.*;
import javax.servlet.http.*;
import java.util.*;

public class StreamingDB {

	private static String CLASS_NAME="StreamingDB.java";

	public static HashMap getEventInfo(String serveraddress,String eventid){

		String GET_EVENT_INFO="select eventid,eventname,getMemberPref(mgr_id||'','pref:myurl','') as username, "
					+" address1,city,state,country,to_char(start_date,'Month DD') as start_date, "
					+" starttime,endtime,to_char(end_date,'Month DD') as end_date "
					+" from eventinfo  where eventid=?";

		 DBManager dbmanager=new DBManager();
		 StatusObj stobj=dbmanager.executeSelectQuery(GET_EVENT_INFO,new String[]{eventid});
		 HashMap hm=new HashMap();
		 Vector v=new Vector();
			 if(stobj.getStatus()){
				for(int i=0;i<stobj.getCount();i++){
					hm.put("eventid",dbmanager.getValue(i,"eventid",""));
					hm.put("eventname",dbmanager.getValue(i,"eventname",""));
					hm.put("username",dbmanager.getValue(i,"username",""));
					hm.put("city",dbmanager.getValue(i,"city",""));
					hm.put("state",dbmanager.getValue(i,"state",""));
					hm.put("country",dbmanager.getValue(i,"country",""));
					hm.put("start_date",dbmanager.getValue(i,"start_date",""));
					hm.put("starttime",dbmanager.getValue(i,"starttime",""));
					hm.put("end_date",dbmanager.getValue(i,"end_date",""));
					hm.put("endtime",dbmanager.getValue(i,"endtime",""));
				}
			}
	 return hm;
	}

	public static HashMap getAgentDetails(String agentid){
		DBManager dbmanager=new DBManager();
		HashMap hm=new HashMap();
		StatusObj statobj=dbmanager.executeSelectQuery("select title,goalamount from group_agent where agentid=? ",new String[]{agentid});
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


	public static Vector getEventList(String serveraddress,HashMap param){
		String query="select a.eventid ,a.eventname,to_char(a.start_date,'MM/DD')as startdate, "
					+"  au.login_name  as username from eventinfo a,authentication au  "
					+"  where a.status='ACTIVE' and a.enddate_est>=now() and a.mgr_id=CAST(au.user_id AS INTEGER) ";

		String retrievecount="10";
		String userid="";
		List paramlist=new ArrayList();
		try{
			if (param!=null){
				retrievecount=(String)param.get("retrievecount");
				userid=(String)param.get("userid");

				if(retrievecount==null)retrievecount="10";
					if("All".equalsIgnoreCase((String)param.get("category"))){
					}else if ((String)param.get("category")!=null){
						  query=query+" and a.category=?";
						  paramlist.add((String)param.get("category"));
					}

					if ((String)param.get("location")!=null){
						String location=(String)param.get("location");
						String country=null;

							if(!"USA".equalsIgnoreCase(location)){
								query=query+" and a.region=?";
								paramlist.add(location);
							}

					}
			}
		    query=query+" and listType='PBL' and a.mgr_id::text='"+userid+"' order by start_date  limit "+retrievecount+" offset 0";
		  	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"StreamingDB.java",null,"in the first Query is---->"+query,null);
		 }catch(Exception e){
		 }
		 DBManager dbmanager=new DBManager();
		 StatusObj stobj=dbmanager.executeSelectQuery(query,(String [])paramlist.toArray(new String [paramlist.size()]));
		 Vector v=new Vector();
		if(stobj.getStatus()){
			for(int i=0;i<stobj.getCount();i++){
				HashMap hm=new HashMap();
				hm.put("startdate",dbmanager.getValue(i,"startdate",""));
				hm.put("eventname","<a target=\"_blank\" href=\""+serveraddress+"member/"+dbmanager.getValue(i,"username","")+"/event?eventid="+dbmanager.getValue(i,"eventid","")+"\">"+dbmanager.getValue(i,"eventname","").replaceAll("'","&apos;")+"</a>");
				v.addElement(hm);
			}
		}
		return v;
	}

	public static HashMap getForumList(String serveraddress,HashMap param,String groupid){
		String retrievecount="5";
		if (param!=null){
			retrievecount=(String)param.get("retrievecount");
			if(retrievecount==null)retrievecount="5";
		 }
	   	HashMap mainhm=new HashMap();
	   	DBManager dbmanager=new DBManager();
		String forumid =null;
		String Query1="select forumid from forum where groupid=? order by forumid desc limit 2";
		StatusObj statobj1=dbmanager.executeSelectQuery(Query1,new String[]{groupid});
	 	ArrayList list1 = new ArrayList();
		if(statobj1.getStatus()){
		String [] columnname=dbmanager.getColumnNames();
			for(int i=0;i<statobj1.getCount();i++)
			{
				forumid=dbmanager.getValue(i,columnname[0],"");
				list1.add(i,forumid);
			}
		}
		 else{
			return null;
	 	}
		 for (int j = 0; j < list1.size() ; j++)
		 {
		    forumid =(String)list1.get(j);
			String query="select  a.subject,a.msgid,a.postedby,a.forumid,a.topicid,b.grouptype,getMemberName(a.postedby) as name,a.parentid,b.forumname  from forummessages a , forum b where b.forumid=?  and a.forumid=b.forumid and a.parentid=0  order by a.postedat desc limit "+retrievecount+" offset 0";
			StatusObj stobj=dbmanager.executeSelectQuery(query,new String []{forumid});
			ArrayList list2 = new ArrayList();
			if(stobj.getStatus())
			{
				for(int k=0;k<stobj.getCount();k++)
				{
					HashMap hm=new HashMap();
					hm.put("subject",dbmanager.getValue(k,"subject",""));
					hm.put("msgid",dbmanager.getValue(k,"msgid",""));
					hm.put("postedby",dbmanager.getValue(k,"postedby",""));
					hm.put("forumname",dbmanager.getValue(k,"forumname",""));
					hm.put("name",dbmanager.getValue(k,"name",""));
					hm.put("grouptype",dbmanager.getValue(k,"grouptype",""));
					hm.put("parentid",dbmanager.getValue(k,"parentid",""));
					hm.put("topicid",dbmanager.getValue(k,"topicid",""));
					hm.put("forumid",dbmanager.getValue(k,"forumid",""));
					list2.add(hm);
				}
			}
		    mainhm.put(forumid,list2);
		}
		return mainhm;
	}

	public static Vector getEventPartnerList(String serveraddress,HashMap param){
		Vector mainvec=new Vector();
		DBManager dbmanager=new DBManager();
		HashMap eventidhmap=new HashMap();

	/*	String query="select a.eventid ,a.eventname,to_char(a.start_date,'MM/DD')as startdate, "
					+"  au.login_name as username,ga.agentid from eventinfo a,partner_listing p,authentication au,group_agent ga,group_agent_settings gs "
					+"  where a.status='ACTIVE' and a.eventid=p.refid and au.user_id=ga.userid and ga.settingid=gs.settingid and a.eventid=gs.groupid and au.user_id=a.mgr_id";

		*/

		String query="select a.eventid ,a.eventname,to_char(a.start_date,'MM/DD')as startdate,"+
					 "au.login_name as username,ga.agentid from eventinfo a,partner_listing p," +
					 "authentication au,group_agent ga,group_partner gp,group_agent_settings gs "+
					 "where a.status='ACTIVE' and  CAST(au.user_id AS INTEGER)=a.mgr_id and p.partnerid=gp.partnerid"+ 
				"	and ga.userid=gp.userid and CAST(p.refid AS INTEGER)=a.eventid and gs.settingid=ga.settingid and "+ 
					 "a.eventid=CAST(gs.groupid AS INTEGER)  and a.listtype='PBL'";

		List paramlist=new ArrayList();
		try{
			if (param!=null){

				if ((String)param.get("partnerid")!=null){
					 query=query+" and p.partnerid=?";
					 paramlist.add((String)param.get("partnerid"));
				}

			}
			query=query+" and p.enddate>=now() order by p.created_at desc ";

		 }catch(Exception e){
		 }
		StatusObj stobj=dbmanager.executeSelectQuery(query,(String [])paramlist.toArray(new String [paramlist.size()]));
		Vector v=new Vector();
		if(stobj.getStatus()){
			for(int i=0;i<stobj.getCount();i++){
				HashMap hm=new HashMap();
				eventidhmap.put(dbmanager.getValue(i,"eventid",""),"");
				hm.put("startdate",dbmanager.getValue(i,"startdate",""));
				hm.put("eventname","<a target=\"_blank\" href=\""+serveraddress+"member/"+dbmanager.getValue(i,"username","")+"/event?eventid="+dbmanager.getValue(i,"eventid","")+"&participant="+dbmanager.getValue(i,"agentid","")+"\">"+dbmanager.getValue(i,"eventname","").replaceAll("'","&#39;")+"</a>");

				hm.put("eventurl",serveraddress+"member/"+dbmanager.getValue(i,"username","")+"/event?eventid="+dbmanager.getValue(i,"eventid",""));
				hm.put("name",dbmanager.getValue(i,"eventname",""));

				v.addElement(hm);
			}
		}















/*
		String Query1="select a.eventid,a.eventname, to_char(a.start_date,'MM/DD')as startdate, "
		+" d.login_name  as username,c.agentid from eventinfo a, "
		+" group_agent_settings b, group_agent c,authentication d where b.settingid=c.settingid  and a.eventid=b.groupid "
		+" and a.mgr_id=d.user_id and b.salecommission > 0 and a.status='ACTIVE'";

*/
		String Query1="select distinct a.eventid,a.eventname, to_char(a.start_date,'MM/DD')as startdate,  "
				+" d.login_name  as username,c.agentid,p.networkcommission from eventinfo a, "
				+" price p,group_agent_settings b, group_agent c,authentication d "
				+" where(a.eventid,p.networkcommission ) in (select evt_id,max(networkcommission)"
				+" from price where networkcommission is not null group by evt_id "
				+" order by max(networkcommission) desc ) and b.settingid=c.settingid and "
				+" a.eventid=CAST(b.groupid AS INTEGER) and a.mgr_id=CAST(d.user_id AS INTEGER) and a.status='ACTIVE' "
				+" and a.listtype='PBL' and a.end_date>=now() " ;


		List paramslst=new ArrayList();
		String retrievecount="10";
		try{
		if (param!=null){
			retrievecount=(String)param.get("retrievecount");
			if(retrievecount==null)retrievecount="10";
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"StreamingDB.java",null,"userid----->"+(String)param.get("userid"),null);
			if ((String)param.get("userid")!=null){
				 Query1=Query1+" and c.userid=?";
				 paramslst.add((String)param.get("userid"));
			}
			if("All".equalsIgnoreCase((String)param.get("category"))){
			}else if ((String)param.get("category")!=null){
				String catlist=(String)param.get("category");
				String[] cats=GenUtil.strToArrayStr(catlist, ",");

				catlist="'A'";
				for(int i=0;i<cats.length;i++){
					EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"StreamingDB.java",null,"cat11111----->"+cats[i],null);
					catlist+=",'"+cats[i]+"'";
				}
				EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"StreamingDB.java",null,"catlist----->"+catlist,null);
				 Query1=Query1+" and a.category in ("+catlist+")";

			}
		}
		 EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"StreamingDB.java",null,"retrievecount----->"+retrievecount,null);
		 Query1=Query1+" order by p.networkcommission desc,startdate limit "+retrievecount+" offset 0";
		 EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"StreamingDB.java",null,"Query1----->"+Query1,null);
		}catch(Exception e){
		}
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"StreamingDB.java",null,"paramslstsize----->"+paramslst.size(),null);
		StatusObj statobj1=dbmanager.executeSelectQuery(Query1,(String [])paramslst.toArray(new String [paramslst.size()]));
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"StreamingDB.java",null,"statusobj1 isss======>"+statobj1.getStatus(),null);
		Vector v1=new Vector();

		if(statobj1.getStatus()){
			String [] columnname=dbmanager.getColumnNames();
			for(int i=0;i<statobj1.getCount();i++){
				HashMap hm1=new HashMap();
					if(eventidhmap.get(dbmanager.getValue(i,"eventid",""))==null){
						hm1.put("startdate",dbmanager.getValue(i,"startdate",""));
						hm1.put("eventname","<a target=\"_blank\" href=\""+serveraddress+"member/"+dbmanager.getValue(i,"username","")+"/event?eventid="+dbmanager.getValue(i,"eventid","")+"&participant="+dbmanager.getValue(i,"agentid","")+"\">"+dbmanager.getValue(i,"eventname","").replaceAll("'","&#39;")+"</a>");
						v1.addElement(hm1);
					}
				EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"StreamingDB.java",null,"in the first vector issss issss"+v1,null);
			}
		}







		mainvec.addElement(v);
		mainvec.addElement(v1);

		return mainvec;
	}

}