<%@ page import="java.util.*,com.eventbee.general.*,com.eventbee.authentication.*,com.eventbee.useraccount.*"%>

<%!
String GetLoginName(String name){
int count=1;
String uname="";
boolean isalreadyexist=true;
 while(isalreadyexist){
	uname=name+"_"+count;
	String exists=DbUtil.getVal("select 'yes' from authentication  where login_name=?",new String[]{uname});
	if("yes".equals(exists))
	isalreadyexist=true;
	else
	isalreadyexist=false;
	count++;
 }
 return uname;

}

String passiveSignup(HashMap hm){
String userid="";
AccountDB accDB=new AccountDB();
HashMap seqHm=accDB.getSequenceID("13579");
 if(seqHm!=null){
	hm.put("acctstatus","1");
	hm.put("email","");
	hm.put("membershipstatus","NING_PASSIVE");
	hm.put("orgid",(String)seqHm.get("orgid"));
	hm.put("unitid",(String)seqHm.get("unitid"));
	hm.put("roleid",(String)seqHm.get("roleid"));
	hm.put("userid",(String)seqHm.get("userid"));
	hm.put("transactionid",(String)seqHm.get("transactionid"));
	hm.put("phone","");	 
	String password=EncodeNum.encodeNum((String)seqHm.get("userid")).toUpperCase();
	hm.put("password",password);
	StatusObj stob=accDB.insertAttendeeData(hm);
	 userid=(String)seqHm.get("userid");
	String INSERTQ="insert into group_partner (partnerid,title,message,userid,url,status,created_at) values (nextval('group_partnerid'),'','',?,'','Active',now())";
	DbUtil.executeUpdateQuery(INSERTQ,new String [] {userid});


  }

return userid;

}



%>


<%


String ninguserid=request.getParameter("oid");
String owner=request.getParameter("owner");
session.setAttribute("owner",owner);

AuthDB adb=new AuthDB();
Authenticate au=null;
Authenticate authData=(Authenticate)com.eventbee.general.AuthUtil.getAuthData(pageContext);
String ebeeid=DbUtil.getVal("select ebeeid from ebee_ning_link where nid=?",new String[]{ninguserid});
if(ebeeid==null){
String firstname=request.getParameter("fname");	
String lastname=request.getParameter("lname");
String username="";
String login_name=firstname+lastname;
String userid=DbUtil.getVal("select user_id from authentication  where login_name like ?",new String[]{login_name+"%"});
if(userid!=null)
username=GetLoginName(login_name);
else
username=login_name;
HashMap hm=new HashMap();
hm.put("loginname",username);
hm.put("scrname",username);
hm.put("firstname",firstname);
hm.put("lastname",lastname);
ebeeid=passiveSignup(hm);
DbUtil.executeUpdateQuery("insert into  ebee_ning_link(nid,ebeeid,created_at) values(?,?,now())",new String[]{ninguserid,ebeeid});
au=adb.authenicateUserByID(userid);
}
else{
au=adb.authenicateUserByID(ebeeid);
 }
 session.setAttribute("authData",au);	
 session.setAttribute("ning_oid",ninguserid);

 response.sendRedirect("/portal/ningapp/profileearningspage.jsp");
%>