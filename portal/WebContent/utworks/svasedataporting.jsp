<%@ page import="com.eventbee.customconfig.MemberFeatures" %>
<%@ page import="java.io.*, java.util.*,java.sql.*,com.eventbee.nuser.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.general.formatting.*" %>
<%!
String CLASS_NAME="svasedataporting.jsp";
public void insertClubmember(String clubid,String mgrid){
DBManager dbmanager=new DBManager();

String userid="";
String memberid="";
HashMap hm=null;
String MEMBER_SEQ_ID="select nextval('seq_maillist') as memberid" ;
String query="insert into authentication(acct_status,auth_id,role_id,org_id,unit_id,updated_by,created_by,user_id,login_name,password) values(?,?,?,?,?,?,?,?,?,?)";
String query1="insert into user_profile(phone,first_name,shareprofile,last_name,user_id,email,created_by,updated_by) values(?,?,?,?,?,?,?,?)";
String query2="insert into club_member(member_id,membership_id,isMgr,clubid,userid,pay_next_due_date,start_date,updated_by,created_by,mgr_id,status) values(?,?,?,?,?,?,?,?,?,?,?)";
String query3="insert into member_profile(manager_id,member_id,m_email,userid) values (?,?,?,?)";
try{
StatusObj sb=dbmanager.executeSelectQuery("select * from svasemembers",new String[]{});
if(sb.getStatus()){
for(int i=0;i<sb.getCount();i++){
 userid=DbUtil.getVal("select nextval('seq_userid')",new String[]{});
 memberid=DbUtil.getVal(MEMBER_SEQ_ID,new String[]{});
				
hm=new HashMap();
hm.put("membership_id",dbmanager.getValue(i,"eventbeemembership_id","") );
hm.put("login_name",dbmanager.getValue(i,"login_name","") );
hm.put("svaseuserid",dbmanager.getValue(i,"userid","") );
hm.put("password",dbmanager.getValue(i,"encryptedpwd","") );
hm.put("phoneno",dbmanager.getValue(i,"phoneno","") );
hm.put("zip",dbmanager.getValue(i,"zip","") );
hm.put("state",dbmanager.getValue(i,"state","") );
hm.put("city",dbmanager.getValue(i,"city","") );
hm.put("street",dbmanager.getValue(i,"street","") );
hm.put("email",dbmanager.getValue(i,"email","") );
hm.put("lastname",dbmanager.getValue(i,"lastname","") );
hm.put("firstname",dbmanager.getValue(i,"firstname","") );
hm.put("pay_next_due_date",dbmanager.getValue(i,"pay_next_due_date","") );
hm.put("start_date",dbmanager.getValue(i,"start_date","") );
hm.put("updated_at",dbmanager.getValue(i,"updated_at","") );
hm.put("created_at",dbmanager.getValue(i,"created_at","") );
hm.put("created_by",dbmanager.getValue(i,"created_by","") );
hm.put("updated_by",dbmanager.getValue(i,"updated_by","") );


StatusObj ob=DbUtil.executeUpdateQuery(query, new String[]{"3",userid,"-100","3467","13579","CLUB_UNITMEMBER",(String)hm.get("created_by"),userid,
(String)hm.get("login_name"),(String)hm.get("password")});
try{
StatusObj oba=DbUtil.executeUpdateQuery("update authentication set created_at=(select created_at from svasemembers where userid=?) where user_id=?",new String[]{(String)hm.get("svaseuserid"),userid});
}
catch(Exception e)
{
System.out.println("exception occured while updating authentication---------"+e.getMessage());
}
try{
StatusObj oba1=DbUtil.executeUpdateQuery("update svasemembers set eventbeeuserid=? where userid=?",new String[]{userid,(String)hm.get("svaseuserid")});
}
catch(Exception e)
{
System.out.println("exception occured while updating svasemembers---------"+e.getMessage());
}
StatusObj ob1=DbUtil.executeUpdateQuery(query1,new String[]{(String)hm.get("phoneno"),(String)hm.get("firstname"),"No",(String)hm.get("lastname"),userid,(String)hm.get("email"),(String)hm.get("created_by"),(String)hm.get("updated_by")});
try{
StatusObj obb=DbUtil.executeUpdateQuery("update user_profile set created_at=(select created_at from svasemembers where userid=?)   where user_id=?",new String[]{(String)hm.get("svaseuserid"),userid});
}
catch(Exception e)
{
System.out.println("exception occured while updating user_profile---------"+e.getMessage());
}

StatusObj ob2=DbUtil.executeUpdateQuery(query2,new String[]{memberid,(String)hm.get("membership_id"),"false",clubid,userid,(String)hm.get("pay_next_due_date"),(String)hm.get("start_date"),(String)hm.get("updated_by"),(String)hm.get("created_by"),mgrid,"ACTIVE"});
try{
StatusObj obc=DbUtil.executeUpdateQuery("update club_member set created_at=(select created_at from svasemembers where userid=?)   where userid=? and clubid=?",new String[]{(String)hm.get("svaseuserid"),userid,clubid});
}
catch(Exception e)
{
System.out.println("exception occured while updating club_member---------"+e.getMessage());
}
StatusObj ob4=DbUtil.executeUpdateQuery(query3,new String[]{mgrid,memberid,(String)hm.get("email"),userid});
try{
StatusObj obd=DbUtil.executeUpdateQuery("update member_profile set created_at=(select created_at from svasemembers where userid=?)   where userid=? ",new String[]{(String)hm.get("svaseuserid"),userid});
}
catch(Exception e)
{
System.out.println("exception occured while updating member_profile---------"+e.getMessage());
}

//System.out.println("inserted "+i+"th member -----------------"+i);
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.ERROR, CLASS_NAME, "insertClubmember", "inserted "+i+"th member-------- "+userid, null);

}

}
}
catch(Exception e)
{
System.out.println("exception occured---------"+e.getMessage());
}
System.out.println("members completed--------------");
}





public void insertForummessages(String clubid){
HashMap hm1=null;
DBManager dbmanager1=new DBManager();
System.out.println("forums started----dfdfgdgfg----------");
String fquery="select * from svaseforummessages order by msgid";
String fquery1="insert into forummessages(msgid,forumid,parentid,topicid,postedby,reply,subject) values(?,?,?,?,?,?,?)";
StatusObj sb1=dbmanager1.executeSelectQuery(fquery,new String[]{});
if(sb1.getStatus()){
for(int i=0;i<sb1.getCount();i++){
String msgid=DbUtil.getVal("select nextval('seq_topic')",new String[]{});
hm1=new HashMap();
hm1.put("forumid",dbmanager1.getValue(i,"forumid","") );
hm1.put("topicid",dbmanager1.getValue(i,"topicid","") );
hm1.put("svasemsgid",dbmanager1.getValue(i,"msgid","") );
hm1.put("parentid",dbmanager1.getValue(i,"parentid","") );
hm1.put("postedat",dbmanager1.getValue(i,"postedat","") );
hm1.put("subject",dbmanager1.getValue(i,"subject","") );		
hm1.put("reply",dbmanager1.getValue(i,"reply","") );
hm1.put("postedby",dbmanager1.getValue(i,"postedby","") );


StatusObj fob=DbUtil.executeUpdateQuery(fquery1, new String[]{msgid,(String)hm1.get("forumid"),
(String)hm1.get("parentid"),(String)hm1.get("topicid"),(String)hm1.get("postedby"),(String)hm1.get("reply"),(String)hm1.get("subject")});
try{
StatusObj foba=DbUtil.executeUpdateQuery("update forummessages set postedat=(select postedat from svaseforummessages where msgid=?) where msgid=?",new String[]{(String)hm1.get("svasemsgid"),msgid});
}
catch(Exception e)
{
System.out.println("exception occured while updating forummessages---------"+e.getMessage());

}
try{
StatusObj fobb=DbUtil.executeUpdateQuery("update svaseforummessages set eventbeemsgid=? where msgid=?",new String[]{msgid,(String)hm1.get("svasemsgid")});
}
catch(Exception e)
{
System.out.println("exception occured while updating svaseforummessages---------"+e.getMessage());
}
try{
StatusObj fobc=DbUtil.executeUpdateQuery("update forummessages set postedby=(select eventbeeuserid from svasemembers  where userid=?) where postedby=?",new String[]{(String)hm1.get("postedby"),(String)hm1.get("postedby")});
}
catch(Exception e)
{
System.out.println("exception occured while updating forummessages---------"+e.getMessage());
}
try{
StatusObj fobd=DbUtil.executeUpdateQuery("update svaseforummessages set eventbeemsgid=? where msgid=?",new String[]{msgid,(String)hm1.get("svasemsgid")});
}
catch(Exception e)
{
System.out.println("exception occured while updating svaseforummessages---------"+e.getMessage());
}

EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.ERROR, CLASS_NAME, "insertForummessages", "the "+i+"th message record inserted-------- "+msgid, null);

//System.out.println("inserted "+i+"th forum record ---111111111111111111--------------"+i);
}
}
}





public void  updateforummessages()
{
HashMap hm1=null;
DBManager dbmanager2=new DBManager();
System.out.println("topics started--------------");
StatusObj sb2=dbmanager2.executeSelectQuery("select topicid,parentid  from forummessages ",new String[]{});
if(sb2.getStatus()){
for(int i=0;i<sb2.getCount();i++){
hm1=new HashMap();
hm1.put("topicid",dbmanager2.getValue(i,"topicid","") );
hm1.put("parentid",dbmanager2.getValue(i,"parentid","") );

try{
 String topicid=(String)hm1.get("topicid");
 int k=Integer.parseInt(topicid);
  if(k!=0){
StatusObj fobe=DbUtil.executeUpdateQuery("update forummessages set topicid=(select eventbeemsgid from svaseforummessages where msgid=?) where topicid=? and forumid=7",new String[]{(String)hm1.get("topicid"),(String)hm1.get("topicid")});
}}

catch(Exception e)
{
System.out.println("exception occured while updating forummessages topicid---------"+e.getMessage());
}

try{
 String parentid=(String)hm1.get("parentid");
 int v=Integer.parseInt(parentid);
 if(v!=0)
{
StatusObj fobf=DbUtil.executeUpdateQuery("update forummessages set parentid=(select eventbeemsgid from svaseforummessages where msgid=?) where parentid=? and forumid=7",new String[]{(String)hm1.get("parentid"),(String)hm1.get("parentid")});
}}
catch(Exception e)
{
System.out.println("exception occured while updating forummessages parentid---------"+e.getMessage());
}

EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.ERROR, CLASS_NAME, "updateforummessages", "the"+i+"th topic updated -------- "+(String)hm1.get("topicid"), null);
	
}
}
}
%>

<%
String clubid=request.getParameter("GROUPID");
String mgrid=request.getParameter("mgrid");
if((clubid!=null && !"".equals(clubid)) && (mgrid!=null && !"".equals(mgrid))){
	insertClubmember(clubid,mgrid);
	insertForummessages(clubid);
	updateforummessages();
	out.print("Inserted Succesfully.");
	
}else{

    out.println("Invalid clubid and mgrid");
}
%>