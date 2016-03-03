 package com.eventbee.event;

 import java.util.*;
 import com.eventbee.general.*;
 import com.eventbee.noticeboard.NoticeboardDB;
 
 public class EventsContent{

	 public static final String GET_SPONSOR_ATTRIBUTES="select attrib_name,attrib_value from mgr_sponsor_attributes where sponsorid=(select sponsorid from mgr_sponsor_settings where refid=?)";

	 public static final String GETSPONSOR_REQUEST_INFO_QUERY="select getMemberMainPhoto(a.userid||'') as photourl,getMemberName(a.userid||'') as name,getMemberPref(a.userid||'','pref:myurl','') as loginname,b.attrib_value as sponsormessage,a.transactionid from  user_sponsor_requests a,user_sponsor_attributes b where a.requestid=b.requestid and a.requestid=?";


	 public static final String VIEW_ATTENDEE_QUERY="select 'Userid' as totype,a.attendeekey,a.attendeeid,a.firstname || ' ' || a.lastname as name,b.login_name as login_name ,"
  		+" a.statement,a.comments,'Y' as priattendee,a.authid,cast(a.authid as text) as msgto, "
		+" a.username,a.eventid,a.shareprofile, k.photourl,b.unit_id from authentication b,eventattendee a, user_profile k "
		+" where a.eventid=? and a.authid=b.auth_id and b.user_id=k.user_id "
		+" union "
		+" select 'Transactionid' as totype,a.attendeekey,a.attendeeid ,a.firstname || ' ' || a.lastname as name,'yy' as login_name, "
		+" a.statement,a.comments,a.priattendee,a.authid as authid,a.transactionid as msgto,username,a.eventid,a.shareprofile,'' as photourl, '0' as unit_id "
		+" from eventattendee a where a.authid='0' and a.eventid=? order by attendeeid desc";

	 public static final String VIEW_RSVP_QUERY="select getMemberPref(authid||'','pref:myurl','') as  loginname,phone,comments,address,address1,firstname,lastname,email,company,attendeecount,attendingevent   from rsvpattendee where eventid=? ";

	 public static final String GETALLAGENTS_QUERY="select agentid,getMemberName(userid||'') as username,getMemberPref(userid||'','pref:myurl','') as loginname from group_agent where status='Active' and customised='Yes' and settingid=(select settingid from group_agent_settings where groupid=? and purpose='event')";

	 public static final String GETAGENTINFO_QUERY="select agentid,getMemberName(userid||'') as username,getMemberPref(userid||'','pref:myurl','') as loginname,goalamount,showsales,title,message,userid,getMemberMainPhoto(userid||'') as photourl from group_agent where status='Active' and customised='Yes' and agentid=? ";


	 public static final String GETSPONSOR_REQUEST_INFO_NAMES_QUERY="select getMemberName(b.userid||'') as name,getMemberPref(c.mgr_id||'','pref:myurl','') as username, b.requestid from user_sponsor_requests b,eventinfo c,mgr_sponsor_settings a where c.eventid=? and c.eventid=a.refid and b.sponsorid=a.sponsorid and b.status is null";

	 public static final String AGENT_SETTINGS_QUERY="select header,showagents,saleslimit,settingid,tagline from group_agent_settings where groupid=?";

	 public static HashMap getSponsorRequestdetails(String refid){
		HashMap hm=new HashMap();

		DBManager dbmanager=new DBManager();
		StatusObj statobj=dbmanager.executeSelectQuery(GET_SPONSOR_ATTRIBUTES,new String[]{refid});
		if(statobj.getStatus()){
					for(int i=0;i<statobj.getCount();i++){
						hm.put(dbmanager.getValue(i,"attrib_name",""),dbmanager.getValue(i,"attrib_value",""));
				       }

			}
		return hm;
	 }


	 public static Vector getSponsorRequestInfo(Vector v,String requestid){

		DBManager dbmanager=new DBManager();
		StatusObj statobj=dbmanager.executeSelectQuery(GETSPONSOR_REQUEST_INFO_QUERY,new String[]{requestid});
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



	public static Vector getAttendeeList(String groupid)
	{
	DBManager dbmanager=new DBManager();
	StatusObj stobj=dbmanager.executeSelectQuery(VIEW_ATTENDEE_QUERY,new String[]{groupid,groupid});
	Vector v=null;
		if(stobj.getStatus()){
		v=new Vector();
			for(int i=0;i<stobj.getCount();i++){
				HashMap hm=new HashMap();
				hm.put("totype",dbmanager.getValue(i,"totype",""));
				hm.put("attendeekey",dbmanager.getValue(i,"attendeekey","") );
				hm.put("attendeeid",dbmanager.getValue(i,"attendeeid","") );
				hm.put("name",dbmanager.getValue(i,"name","") );
				hm.put("login_name",dbmanager.getValue(i,"login_name",""));
				hm.put("comments",dbmanager.getValue(i,"statement","") );
				hm.put("priattendee",dbmanager.getValue(i,"priattendee","") );
				hm.put("authid",dbmanager.getValue(i,"authid","") );
				hm.put("msgto",dbmanager.getValue(i,"msgto",""));
				hm.put("username",dbmanager.getValue(i,"username","") );
				hm.put("eventid",dbmanager.getValue(i,"eventid","") );
				hm.put("shareprofile",dbmanager.getValue(i,"shareprofile","") );
				hm.put("photourl",dbmanager.getValue(i,"photourl",""));
				hm.put("unit_id",dbmanager.getValue(i,"unit_id","") );
				hm.put("comments",dbmanager.getValue(i,"comments","") );




				v.addElement(hm);
			}
		}
		return v;
	}


	public static Vector getRSVPList(String eventid,HashMap countmap)
	{

		 Vector v=new Vector();
		 Vector v1=new Vector();
		Vector v2=new Vector();
		Vector v3=new Vector();
		int yes=0;
		int notsure=0;
		int no=0;
		DBManager dbmanager=new DBManager();
		StatusObj statobj=dbmanager.executeSelectQuery(VIEW_RSVP_QUERY,new String []{eventid});
		if(statobj.getStatus()){
			for(int i=0;i<statobj.getCount();i++){
				HashMap hm=new HashMap();
				hm.put("phone",dbmanager.getValue(i,"phone",""));
				hm.put("comments",GenUtil.textToHtml(dbmanager.getValue(i,"comments","")));
				hm.put("address",dbmanager.getValue(i,"address",""));
				hm.put("address1",dbmanager.getValue(i,"address1",""));
				hm.put("firstname",dbmanager.getValue(i,"firstname",""));
				hm.put("lastname",dbmanager.getValue(i,"lastname",""));
				hm.put("email",dbmanager.getValue(i,"email",""));
				hm.put("loginname",dbmanager.getValue(i,"loginname",""));
				hm.put("name",dbmanager.getValue(i,"firstname","")+" "+dbmanager.getValue(i,"lastname",""));
				hm.put("attendeecount",dbmanager.getValue(i,"attendeecount","1"));
				hm.put("attendingevent",dbmanager.getValue(i,"attendingevent","yes"));
				if("yes".equals(dbmanager.getValue(i,"attendingevent","yes"))){
				try{
				yes=yes+Integer.parseInt(dbmanager.getValue(i,"attendeecount","1"));
				}catch(Exception e){yes=yes+1;}
				v1.add(hm);
				}
				else if("notsure".equals(dbmanager.getValue(i,"attendingevent","yes"))){
				try{
				notsure=notsure+Integer.parseInt(dbmanager.getValue(i,"attendeecount","1"));
				}catch(Exception e){notsure=notsure+1;}
				v2.add(hm);
				}else if("no".equals(dbmanager.getValue(i,"attendingevent","yes"))){
				try{
				no=no+Integer.parseInt(dbmanager.getValue(i,"attendeecount","1"));
				}catch(Exception e){no=no+1;}
				v3.add(hm);
				}

		}
	}
	countmap.put("yes",yes+"");
	countmap.put("notsure",notsure+"");
	countmap.put("no",no+"");
	v.add(v1);
	v.add(v2);
	v.add(v3);
		return v;
	}



	public static Vector getAllNotices(String groupid){
		DBManager dbmanager=new DBManager(); 
		StatusObj stobj=dbmanager.executeSelectQuery(NoticeboardDB.GET_NOTICES_QUERY,new String[]{groupid});
		Vector v=null;
			if(stobj.getStatus()){
			v=new Vector();
				for(int i=0;i<stobj.getCount();i++){
					HashMap notice=new HashMap();
					notice.put("notice",GenUtil.textToHtml(dbmanager.getValue(i,"notice","")));
					notice.put("noticetype",dbmanager.getValue(i,"noticetype","") );
					notice.put("postedDate",dbmanager.getValue(i,"postedat1","") );
					notice.put("postedat1",dbmanager.getValue(i,"postedat1","") );
					notice.put("noticeid",dbmanager.getValue(i,"noticeid",""));
					v.addElement(notice);
				}
			}
			return v;
	}



	public static Vector getAllAgents(String groupid){
		DBManager dbmanager=new DBManager();
		StatusObj stobj=dbmanager.executeSelectQuery(GETALLAGENTS_QUERY,new String[]{groupid});
		Vector v=null;
			if(stobj.getStatus()){
			v=new Vector();
				for(int i=0;i<stobj.getCount();i++){
					HashMap agents=new HashMap();
					agents.put("username",dbmanager.getValue(i,"username",""));
					agents.put("agentid",dbmanager.getValue(i,"agentid","") );
					agents.put("loginname",dbmanager.getValue(i,"loginname","") );
					v.addElement(agents);
				}
			}
			return v;
	}




	public static Map getAgentInfo(String agentid){
		DBManager dbmanager=new DBManager();
		StatusObj stobj=dbmanager.executeSelectQuery(GETAGENTINFO_QUERY,new String[]{agentid});
		Map agents=null;
			if(stobj.getStatus()){
				agents=new HashMap();
				agents.put("username",dbmanager.getValue(0,"username",""));
				agents.put("agentid",dbmanager.getValue(0,"agentid","") );
				agents.put("loginname",dbmanager.getValue(0,"loginname","") );
				agents.put("goalamount",dbmanager.getValue(0,"goalamount",""));
				agents.put("showsales",dbmanager.getValue(0,"showsales","") );
				agents.put("title",dbmanager.getValue(0,"title","") );
				agents.put("message",dbmanager.getValue(0,"message",""));
				agents.put("userid",dbmanager.getValue(0,"userid","") );
				agents.put("photourl",dbmanager.getValue(0,"photourl",null) );
			}
			return agents;
	}


	public static Vector getSponsorRequestInfoNames(Vector vect,String groupid){
		DBManager dbmanager=new DBManager();


		StatusObj statobj=dbmanager.executeSelectQuery(GETSPONSOR_REQUEST_INFO_NAMES_QUERY,new String[]{groupid});
		if(statobj.getStatus()){
			String [] columnnames=dbmanager.getColumnNames();
				for(int i=0;i<statobj.getCount();i++){
					HashMap hm=new HashMap();
					for(int j=0;j<columnnames.length;j++){
						hm.put(columnnames[j],dbmanager.getValue(i,columnnames[j],""));
					}
					vect.add(hm);
				}
		}
		return vect;
	}


	public static Vector getAgentSettings(Vector vect,String groupid){
		DBManager dbmanager=new DBManager();


		StatusObj statobj=dbmanager.executeSelectQuery(AGENT_SETTINGS_QUERY,new String[]{groupid});
		if(statobj.getStatus()){
			String [] columnnames=dbmanager.getColumnNames();
				for(int i=0;i<statobj.getCount();i++){
					HashMap hm=new HashMap();
					for(int j=0;j<columnnames.length;j++){
						hm.put(columnnames[j],dbmanager.getValue(i,columnnames[j],""));
					}
					vect.add(hm);
				}
		}
		return vect;
	}

	public static String getConfigVal(HashMap confighm, String key, String defaultval){
		String val=(String)confighm.get(key);
		 if(val==null)
			return defaultval;
		 else
			return val;
    }




 }
