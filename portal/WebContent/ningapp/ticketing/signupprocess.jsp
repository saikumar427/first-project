<%@ page import="java.util.*,com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.useraccount.*" %>
<%@ page import="com.eventbee.editprofiles.ProfileValidator"%>

<%!
public String passiveSignup(HashMap hm){
String userid="";
AccountDB accDB=new AccountDB();
HashMap seqHm=accDB.getSequenceID("13579");
 if(seqHm!=null){
	hm.put("acctstatus","1");
	hm.put("membershipstatus","Active");
	hm.put("orgid",(String)seqHm.get("orgid"));
	hm.put("unitid",(String)seqHm.get("unitid"));
	hm.put("roleid",(String)seqHm.get("roleid"));
	hm.put("userid",(String)seqHm.get("userid"));
	hm.put("transactionid",(String)seqHm.get("transactionid"));
	hm.put("phone","");
	StatusObj stob=accDB.insertAttendeeData(hm);
	 userid=(String)seqHm.get("userid");
	String INSERTQ="insert into group_partner (partnerid,title,message,userid,url,status,created_at) values (nextval('group_partnerid'),'','',?,'','Active',now())";
	DbUtil.executeUpdateQuery(INSERTQ,new String [] {userid});


  }

return userid;

}
%>

<%
	ProfileValidator pv=new ProfileValidator();
AuthDB adb=new AuthDB();
Authenticate au=null;
String username=request.getParameter("uname");
String fname=request.getParameter("fname");
String lname=request.getParameter("lname");
String password=request.getParameter("password");
String email=request.getParameter("email");
String oid=request.getParameter("oid");
String domain=request.getParameter("domain");
String useragent = request.getHeader("User-Agent");
if(domain==null){
domain=(String)session.getAttribute("domain");
}

HashMap hm=new HashMap();
String str="";
String alreadyexists=DbUtil.getVal("select 'yes' from authentication where login_name=?",new String[]{username});



boolean isError=false;
if("".equals(username)||username==null){
str="Bee Id is Empty";
isError=true;
}else if("yes".equals(alreadyexists)){
str="Bee Id already Exists";
isError=true;
}
else if(username!=null&&username.length()<4)
{
str="Invalid Bee Id";
isError=true;
}else if(!pv.checkNameValidity(username,true)){
str="Invalid Bee Id. Use alphanumeric characters only";
isError=true;
}
else{
hm.put("loginname",username);
hm.put("scrname",username);
}
if(!isError){

if(password==null){

str="Password is Empty";
isError=true;

}
else if(password!=null&&password.length()<4){
str="Invalid Password";
isError=true;
}
else{
hm.put("password",password);
}

}
if(!isError){
 if("".equals(fname)||fname==null){
str="First name Is Empty";
isError=true;
}
else
hm.put("firstname",fname);
}
if(!isError){
if("".equals(lname)||lname==null){
str="Last name Is Empty";
isError=true;
}
else
hm.put("lastname",lname);
}
if(!isError){
StatusObj sb=EventBeeValidations.isValidEmail(email,"Email");
if(!sb.getStatus()){
str=sb.getErrorMsg();
isError=true;
}
else
hm.put("email",email);
}

if(isError){
out.println(str);
}
else{
if(hm!=null&&hm.size()>0){
String ebeeid=passiveSignup(hm);

if(ebeeid!=null){
DbUtil.executeUpdateQuery("insert into  ebee_ning_link(nid,ebeeid,created_at,network,useragent) values(?,?,now(),?,?)",new String[]{oid,ebeeid,domain,useragent});
au=adb.authenicateUserByID(ebeeid);
session.setAttribute("authData",au);
out.println("Success");
}
}}
%>