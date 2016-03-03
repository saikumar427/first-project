package com.eventbee.f2f;
import com.eventbee.general.StatusObj;
import com.eventbee.general.*;
import com.eventbee.event.*;
import com.eventbee.authentication.*;
import java.sql.*;
import java.util.*;
import java.lang.String;
import com.eventbee.context.ContextConstants;
import com.eventbee.general.formatting.*;


public class F2FEventDB{

	//public static final String NOT_ENABLED="select to_char(b.created_at,'MM/DD/YYYY')as created_at ,a.status,a.settingid,a.agentid,b.eventname,b.eventid,getMemberPref(mgr_id||'','pref:myurl','') as username,c.settingid,a.customised,c.salecommission from eventinfo b,group_agent a,group_agent_settings c where a.settingid=c.settingid and b.eventid=c.groupid  and userid=? and c.enableparticipant='No' order by b.created_at desc";

	public static final String NOT_ENABLED="select to_char(b.created_at,'MM/DD/YYYY')as created_at ,a.status,a.settingid,a.agentid,b.eventname,b.eventid,c.settingid,a.customised,c.salecommission,au.login_name as username"
						+" from eventinfo b,group_agent a,group_agent_settings c,authentication au where a.settingid=c.settingid and b.eventid=c.groupid and b.mgr_id=au.user_id and listtype='PBL' and userid=? and c.enableparticipant='No' "
						+" order by b.created_at desc limit ? offset ?";

	public static final String AGENTS_INFO_QUERY="select getMemberName(b.userid||'') as name,getMemberPref(d.mgr_id||'','pref:myurl','') as username,b.status,b.agentid,b.userid from group_agent b,group_agent_settings c,eventinfo d where  c.groupid=cast(d.eventid as varchar) and b.settingid=c.settingid and c.groupid=? and purpose='event' and c.enableparticipant='Yes' and b.customised='Yes'";

	public static final String EVENT_DETAILS_QUERY="select eventname,eventid,substr(created_at,1,10) as created_at from eventinfo where end_date>now()'";

	public static final String ENABLED_EVENTS_QUERY="select CheckIsAgent(settingid,?) as isagent,b.description,a.groupid,a.settingid,b.eventname,getMemberPref(mgr_id||'','pref:myurl','') as username,b.city,b.state,b.country,to_char(b.start_date,'MM/DD/YYYY')as startdate from eventinfo b,group_agent_settings a where a.groupid=b.eventid and a.enablenetworkticketing='Yes'";

	public static final String AGENT_SETTINGS_QUERY="select tagline,description,salecommission*100 as salecommission,saleslimit,approvaltype from group_agent_settings where groupid=? and purpose='event'";

	public static final String MYF2FINFO_QUERY="select to_char(b.created_at,'MM/DD/YYYY')as created_at ,a.status,a.settingid,a.agentid,b.eventname,b.eventid,au.login_name as username,c.settingid,a.customised,c.salecommission from eventinfo b,group_agent a,group_agent_settings c,authentication au where a.settingid=c.settingid and b.eventid=c.groupid  and userid=? and b.mgr_id=au.user_id and listtype='PBL' and c.enableparticipant='Yes' order by b.created_at desc";

	public static final String INSERT_AGENT_SETTINGS="insert into group_agent_settings (settingid,tagline,description,salecommission,saleslimit,approvaltype,terms_conditions,header,showagents,groupid,purpose,created_dt,commtype,enableparticipant,enablenetworkticketing) values((nextval('group_agent_settingid')),?,?,?,?,'Yes',?,?,?,?,?,now(),'$',?,'Yes')";

	public static final String UPDATE_AGENT_SETTINGS="update group_agent_settings set  tagline=?,description=?,salecommission=?,saleslimit=?,terms_conditions=?,header=?,showagents=?,purpose=?,enableparticipant=?,enablenetworkticketing='Yes' where settingid=?";

	//public static final String UPDATE_CONFIG="update config set value=? where config_id=? and name='event.enable.agent.settings'";

	public static final String UPDATE_STATUS="update group_agent set status=? where agentid=?";

	public static final String getVal_Query="select settingid from group_agent_settings where groupid=?";

	//public static final String getStatus_Query="select a.value from config a,eventinfo b where a.config_id=b.config_id and eventid=? and a.name='event.enable.agent.settings'";
	public static final String getStatus_Query="select enablenetworkticketing from group_agent_settings where groupid=?";

	public static final String status_Query="select status from group_agent where agentid=?";

	public static final String getSetIDVal_Query="select settingid from group_agent_settings where groupid=? and purpose='event'";

	public static final String getAgentId_Query="select agentid from group_agent where settingid=? and userid=? ";

	public static final String getStatusVal_Query="select approvaltype from group_agent_settings where settingid=?";

	public static final String configIdVal_Query="select config_id from eventinfo where eventid=?";

	/*
	public static final String Insert_Config_Query="insert into config (config_id,name,value) values(?,'event.enable.agent.settings',?)";

	public static final String Delete_Config_Query="delete from config where config_id=? and name='event.enable.agent.settings'";

	public static final String configid_Query="select value from config where name='event.enable.agent.settings' and config_id=(select config_id from eventinfo where eventid=?)";
	*/

	public static final String agentid_query="select agentid from group_agent where userid=? and settingid=?";

	public static final String TERMSCONDQ="select terms_conditions from group_agent_settings where groupid=?";

	public static final String agentinfoq="select title,message,goalamount,showsales from group_agent where agentid=?";

	public static final String ISAGENT_QUERY="select CheckIsAgent(settingid,?) as isagent from eventinfo b,group_agent_settings a where a.groupid=b.eventid and a.enablenetworkticketing='Yes' and groupid=?";

	public static final String INSERT_AGENT_DETAILS="insert into group_agent (agentid,title,message,userid,settingid,showsales,goalamount,customised,status,created_at) values (?,?,?,?,?,?,?,'Yes',?,now())";

	public static final String UPDATEQ="update group_agent set  title=?,message=?,goalamount=?,showsales=?,customised=? where settingid=?";

	public static final String GET_MGR_DETAILS="select tagline,description,salecommission,saleslimit from group_agent_settings where groupid=?";

    public static final String DELETE_AGENT_DETAILS="delete from group_agent where agentid=? and settingid=?";
	public static StatusObj updateAgentSettings(HashMap hm){
		StatusObj status=null;
		status=DbUtil.executeUpdateQuery(UPDATE_AGENT_SETTINGS,new String [] {GenUtil.getHMvalue(hm,"tagline",""),GenUtil.getHMvalue(hm,"description",""),GenUtil.getHMvalue(hm,"salecommission",""),GenUtil.getHMvalue(hm,"saleslimit",""),GenUtil.getHMvalue(hm,"terms_conditions",""),GenUtil.getHMvalue(hm,"header",""),GenUtil.getHMvalue(hm,"showagents",""),GenUtil.getHMvalue(hm,"event",""),GenUtil.getHMvalue(hm,"enableparticipant",""),GenUtil.getHMvalue(hm,"setid","")});
		return status;
	}
	public static StatusObj insertAgentDetails(HashMap hm){
		StatusObj status=null;
        String partnerid=DbUtil.getVal("select partnerid from group_partner where userid=?",new String[]{GenUtil.getHMvalue(hm,"userid","")});
		DbUtil.executeUpdateQuery(DELETE_AGENT_DETAILS,new String [] {partnerid,GenUtil.getHMvalue(hm,"settingid","")});
		status=DbUtil.executeUpdateQuery(INSERT_AGENT_DETAILS,new String [] {partnerid,GenUtil.getHMvalue(hm,"title",""),GenUtil.getHMvalue(hm,"message",""),GenUtil.getHMvalue(hm,"userid",""),GenUtil.getHMvalue(hm,"settingid",""),GenUtil.getHMvalue(hm,"showsales",""),GenUtil.getHMvalue(hm,"goalamount",""),GenUtil.getHMvalue(hm,"statusv","")});
		return status;
	}
	public static StatusObj updateAgentDetails(HashMap hm){
		StatusObj status=null;
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"F2FEventDB.java","null","Hash map val----> :"+hm,null);
		status=DbUtil.executeUpdateQuery(UPDATEQ,new String [] {GenUtil.getHMvalue(hm,"title",""),GenUtil.getHMvalue(hm,"message",""),GenUtil.getHMvalue(hm,"goalamount",""),GenUtil.getHMvalue(hm,"showsales",""),GenUtil.getHMvalue(hm,"customised",""),GenUtil.getHMvalue(hm,"setid","")});
		return status;
	}

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

/*
	public static StatusObj updateConfig(HashMap hm){

		StatusObj status=null;
		status=DbUtil.executeUpdateQuery(UPDATE_CONFIG,new String [] {GenUtil.getHMvalue(hm,"value",""),GenUtil.getHMvalue(hm,"config_id","")});
		return status;
	}
*/
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

	public static StatusObj insertAgentSettings(HashMap hm){
			StatusObj status=null;
			status=DbUtil.executeUpdateQuery(INSERT_AGENT_SETTINGS,new String [] {GenUtil.getHMvalue(hm,"tagline",""),GenUtil.getHMvalue(hm,"description",""),GenUtil.getHMvalue(hm,"salecommission",""),GenUtil.getHMvalue(hm,"saleslimit",""),GenUtil.getHMvalue(hm,"terms_conditions",""),GenUtil.getHMvalue(hm,"header",""),GenUtil.getHMvalue(hm,"showagents",""),GenUtil.getHMvalue(hm,"groupid",""),GenUtil.getHMvalue(hm,"event",""),GenUtil.getHMvalue(hm,"enableparticipant","")});
			return status;
		}

	public static StatusObj updateStatus(String query,HashMap hm){
		StatusObj status=null;
		status=DbUtil.executeUpdateQuery(query,new String [] {GenUtil.getHMvalue(hm,"status",""),GenUtil.getHMvalue(hm,"agentid","")});
		return status;
	}


	public static String getVal(String query,String value){
		String val=DbUtil.getVal(query, new String[]{value});
		return val;
	}

	public static String getVal(String query,String setid,String groupid){
		String val=DbUtil.getVal(query, new String[]{setid,groupid});
		return val;
	}

	public static StatusObj getAgentDetails(String query,String agentid){
		StatusObj status=null;
		DBManager dbmanager=new DBManager();

		status=dbmanager.executeSelectQuery(query, new String[]{agentid});
		return status;
	}
	public static StatusObj updateConfig(String query,String config_id){
		StatusObj status=null;
		status=DbUtil.executeUpdateQuery(query, new String[]{config_id});
		return status;
	}
	public static StatusObj updateConfig(String query,String config_id,String eveenable){
		StatusObj status=null;
		status=DbUtil.executeUpdateQuery(query, new String[]{config_id,eveenable});
		return status;
	}
	public static void getCustomAgentData(Vector v,String groupid){
		DBManager dbmanager=new DBManager();
		String SELECTQ=null;
		String commisstype=DbUtil.getVal("select commtype from group_agent_settings where groupid=?",new String[]{groupid});
		if("%".equals(commisstype))
			SELECTQ="select tagline,description,salecommission*100 as salecommission,saleslimit,approvaltype,commtype from group_agent_settings where groupid=? and purpose='event' ";
		else
			SELECTQ="select tagline,description,salecommission as salecommission,saleslimit,approvaltype,commtype from group_agent_settings where groupid=? and purpose='event' ";

		StatusObj statobj=dbmanager.executeSelectQuery(SELECTQ,new String[]{groupid});
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
	}

	public static void getCustomPosterData(Vector v,String userid){
		DBManager dbmanager=new DBManager();
		String SELECTQ="select CheckIsAgent(settingid,?) as isagent,b.description,a.groupid,a.settingid,b.eventname, "
				+" login_name as username,b.city,b.state,b.country,to_char(b.start_date,'MM/DD/YYYY')as startdate from eventinfo b,group_agent_settings a,authentication d"
				  +" where d.user_id=mgr_id and  a.groupid=b.eventid and a.enablenetworkticketing='Yes' and b.status='ACTIVE'";
		StatusObj statobj=dbmanager.executeSelectQuery(SELECTQ,new String[]{userid});
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
	}

	public static HashMap getCommType(HashMap taskmap,String groupidq,String groupid){
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"F2FEventDB.java","   In getCommType()   ","groupid is------> :"+groupid,null);
		DBManager dbmanager=new DBManager();
		StatusObj statobj=dbmanager.executeSelectQuery(groupidq, new String[]{groupid});
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"F2FEventDB.java","In getCommType()   ","statobj is------> :"+statobj.getStatus(),null);
		if(statobj.getStatus()){
			String [] columnnames=dbmanager.getColumnNames();
			for(int i=0;i<statobj.getCount();i++){
				for(int j=0;j<columnnames.length;j++){
					taskmap.put(columnnames[j],dbmanager.getValue(i,columnnames[j],""));
				}
				taskmap.put("salecommission",dbmanager.getValue(i,"salescomm",""));
			}
		}
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"F2FEventDB.java","   In getCommType()   ","taskmap is------> :"+taskmap,null);
		return taskmap;
	}

	public static HashMap getAgentInformation(HashMap agentmap,String agentinfoquery,String agentid,String settingid){
		DBManager dbmanager=new DBManager();
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"F2FEventDB.java","   In getAgentInformation(agentmap,agentinfoquery,agentid)   ","agentid is------> :"+agentid,null);
		StatusObj statobj=dbmanager.executeSelectQuery(agentinfoquery, new String[]{agentid,settingid});
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"F2FEventDB.java","null","statobj is------> :"+statobj.getStatus(),null);
		if(statobj.getStatus()){
			String [] columnnames=dbmanager.getColumnNames();
			for(int i=0;i<statobj.getCount();i++){
				for(int j=0;j<columnnames.length;j++){
					agentmap.put(columnnames[j],dbmanager.getValue(i,columnnames[j],""));
				}
			}
		}
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"F2FEventDB.java","null","agentmap is---->  :"+agentmap,null);
		return agentmap;
	}

	 public static HashMap getEvtMgrDetails(String groupid){
		HashMap hm=new HashMap();
		DBManager dbmanager=new DBManager();
		StatusObj statobj=dbmanager.executeSelectQuery(GET_MGR_DETAILS,new String[]{groupid});
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



	public static Vector getnotenabledEventsInfo(Vector v,String query,String groupid,String no_records,String starts_from){
	 		DBManager dbmanager=new DBManager();
	 		StatusObj statobj=dbmanager.executeSelectQuery(query,new String[]{groupid,no_records,starts_from});
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
