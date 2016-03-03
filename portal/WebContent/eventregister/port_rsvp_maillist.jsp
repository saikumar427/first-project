<%@ page import="java.util.*" %>
<%@ page import="com.customattributes.*" %>
<%@ page import="com.eventbee.survey.*"%>
<%@ page import="com.eventbee.general.*,java.sql.*,com.eventbee.general.* " %>

<%!

public Vector getrsvpattendeeInfo(String eventid){

	String GET_RSVP_ATTENDEE_INFO="select firstname,lastname,email from rsvpattendee where eventid=?"; 

		 DBManager dbmanager=new DBManager();
		 StatusObj stobj=dbmanager.executeSelectQuery(GET_RSVP_ATTENDEE_INFO,new String[]{eventid});
		 
		 Vector v=new Vector();
			 if(stobj.getStatus()){
				for(int i=0;i<stobj.getCount();i++){
				    HashMap hm=new HashMap();
					hm.put("firstname",dbmanager.getValue(i,"firstname",""));
					hm.put("lastname",dbmanager.getValue(i,"lastname",""));
					hm.put("email",dbmanager.getValue(i,"email",""));
					v.add(hm);
				}
			}
	 return v;
	}


%>



<%

String eventid=request.getParameter("eventid");
String listid=request.getParameter("listid");
String INSERT_MEMBER="insert into member_profile(member_id,m_lastname,created_at,m_email,m_firstname,manager_id) values(?,?,now(),?,?,?)"	;				  
String INSERT_LIST_MEMBER="insert into mail_list_members(member_id,list_id,status,created_at,created_by) values(?,?,'available',now(),'Auto Subscription')";
String memberid="";

Vector v=new Vector();

v=getrsvpattendeeInfo(eventid);

if(v.size()>0 && v!=null){

	for(int i=0;i<v.size();i++){
		HashMap hmap=(HashMap)v.get(i);
		memberid=DbUtil.getVal("select nextval('seq_maillist') as memberid",new String[]{});
		try{
		StatusObj status1=DbUtil.executeUpdateQuery(INSERT_MEMBER,new String [] {memberid,(String)hmap.get("lastname"),(String)hmap.get("email"),(String)hmap.get("firstname"),"0"});
		StatusObj status2=DbUtil.executeUpdateQuery(INSERT_LIST_MEMBER,new String [] {memberid,listid});
		}catch(Exception e){
		  System.out.println("-------Problem in inserting---------");
		}
		System.out.println("Inserted ---->: "+v.size()+" records");
	}

}



%>

