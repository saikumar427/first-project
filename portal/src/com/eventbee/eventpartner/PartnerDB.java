package com.eventbee.eventpartner;

import com.eventbee.general.*;
import javax.servlet.http.*;
import java.util.*;

public class PartnerDB {

	private static String CLASS_NAME="PartnerDB.java";
	final static String [] attributes={"TITLE","NO_OF_ITEMS","STREAMERSIZE","BACKGROUND","BORDERCOLOR",
										 "LINKCOLOR","BIGGER_TEXT_COLOR","BIGGER_FONT_TYPE",
										 "BIGGER_FONT_SIZE","MEDIUM_TEXT_COLOR","MEDIUM_FONT_TYPE",
										 "MEDIUM_FONT_SIZE","SMALL_TEXT_COLOR",
										 "SMALL_FONT_TYPE","SMALL_FONT_SIZE","DISPLAYEBEELINK"};


	public static HashMap getPartnerDetails(String userid){
		DBManager dbmanager=new DBManager();
		HashMap hm=new HashMap();
		String partnerinfoq="select partnerid,status from group_partner where status='Active' and userid=?";
		StatusObj statobj=dbmanager.executeSelectQuery(partnerinfoq,new String[]{userid});
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

	public static Vector getEnabledGroupTicket(){
		DBManager dbmanager=new DBManager();
		Vector v=new Vector();
		final String SELECTQUERY="select b.eventid from config a,eventinfo b where a.config_id=b.config_id and a.value='Yes' and a.name='event.enable.agent.settings' and b.status='ACTIVE'";
		StatusObj statobj=dbmanager.executeSelectQuery(SELECTQUERY,null);
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

	public static Vector getGroupTicketInfo(String userid,String groupid){
		DBManager dbmanager=new DBManager();
		Vector v=new Vector();

		final String GROUP_TICKET_QUERY="select CheckIsAgent(settingid,?) as isagent,a.settingid,a.saleslimit,a.approvaltype from eventinfo b,group_agent_settings a,config c where c.name='event.enable.agent.settings' and a.groupid=b.eventid and c.value='Yes' and b.config_id=c.config_id and b.status='ACTIVE' and groupid=?";
		StatusObj statobj=dbmanager.executeSelectQuery(GROUP_TICKET_QUERY,new String[]{userid,groupid});
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

	public static Map getStreamingAttributes(String userid,String refid){
		Map hm=new HashMap();
		String query="select streamid,stream_attribute,attrib_value from streaming_attributes where streamid=(select streamid from streaming_details where userid=CAST(? as INTEGER) and refid=? and purpose='partnerstreamer')";
		DBManager dbmanager=new DBManager();
		StatusObj statobj=dbmanager.executeSelectQuery(query,new String []{userid,refid});
		int recordcount=statobj.getCount();
		if(recordcount>0){
			for(int i=0;i<recordcount;i++){
				hm.put(dbmanager.getValue(i,"stream_attribute",""),dbmanager.getValue(i,"attrib_value",""));
			}
			hm.put("streamid",dbmanager.getValue(0,"streamid",""));
		}
		return hm;
	}

public static Map getStreamingAttributes(String refid){
		Map hm=new HashMap();
		String query="select streamid,stream_attribute,attrib_value from streaming_attributes where streamid=(select streamid from streaming_details where refid=? and purpose='partnerstreamer')";
		DBManager dbmanager=new DBManager();
		StatusObj statobj=dbmanager.executeSelectQuery(query,new String []{refid});
		int recordcount=statobj.getCount();
		if(recordcount>0){
			for(int i=0;i<recordcount;i++){
				hm.put(dbmanager.getValue(i,"stream_attribute",""),dbmanager.getValue(i,"attrib_value",""));
			}
			hm.put("streamid",dbmanager.getValue(0,"streamid",""));
		}
		return hm;
	}
	public static void insertAttributes(HttpServletRequest req,String streamid){
		StatusObj statobj=null;
		List dbquery=new ArrayList();
		String allCategories=null;
		String cat=null;
		String query="insert into streaming_attributes(streamid,stream_attribute,attrib_value) values(?,?,?)";
		dbquery.add(new DBQueryObj("delete from streaming_attributes where streamid=?",new String [] {streamid}));
		for(int i=0;i<attributes.length;i++){
		String attribute=req.getParameter(attributes[i]);

			if("BACKGROUND_COLOR".equals(attribute))
				attribute=req.getParameter("BACKGROUND_COLOR");
			else if("BACKGROUND_IMAGE".equals(attribute))
				attribute=req.getParameter("BACKGROUND_IMAGE");

			dbquery.add(new DBQueryObj(query,new String [] {streamid,attributes[i],attribute}));
		}
		cat=req.getParameter("ALLCATEGORY");
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"PartnerDB.java",null,"cat isssssss---->"+cat,null);
		if(cat!=null) 	{
			cat="All";
		}else {
				String categories[]=req.getParameterValues("CATEGORY");
				cat=GenUtil.stringArrayToStr(categories,",");
				EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"PartnerDB.java",null,"cat isssssss---->"+cat,null);
				if("".equals(cat.trim()))
					cat="All";
			}
		dbquery.add(new DBQueryObj(query,new String [] {streamid,"CATEGORY",cat}));

		if(dbquery!=null&&dbquery.size()>0)
			statobj=DbUtil.executeUpdateQueries((DBQueryObj [])dbquery.toArray(new DBQueryObj [dbquery.size()]));
	}
	public static String insertAttributes(String userid,String purpose,String refid){
		Map hm=null;
		String query="insert into streaming_details(streamid,userid,purpose,refid) values(?,?,?,?)";
		String streamid=DbUtil.getVal("select nextval('streaming_id')",null);

		StatusObj statobj=DbUtil.executeUpdateQuery(query,new String[]{streamid,userid,purpose,refid});
		return streamid;
	}

	public static Vector getPartnerInfo(){
		DBManager dbmanager=new DBManager();
		Vector v=new Vector();
		String partnerinfoq="select partnerid,userid,title,message,terms_conditions from group_partner where status='Active'";
		StatusObj statobj=dbmanager.executeSelectQuery(partnerinfoq,null);
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

	public static HashMap getPartnerInformation(String partnerid){
		DBManager dbmanager=new DBManager();
		String query="select title,message,url from group_partner where partnerid =?";
		StatusObj statobj=dbmanager.executeSelectQuery(query, new String[]{partnerid});
		HashMap partnermap=new HashMap();
		 if(statobj.getStatus()){
			 String [] columnnames=dbmanager.getColumnNames();
			for(int i=0;i<statobj.getCount();i++){
				for(int j=0;j<columnnames.length;j++){
					partnermap.put(columnnames[j],dbmanager.getValue(i,columnnames[j],""));
				}
			}

		 }
		 return partnermap;
	}
}