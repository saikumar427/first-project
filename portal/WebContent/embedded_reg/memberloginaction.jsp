<%@ page import="com.eventbee.general.*,com.eventregister.MemberTicketsDB"%>
<%@ page import="org.json.*"%>
<%
JSONObject obj=new JSONObject();
String groupid=request.getParameter("GROUPID");
String clubid=request.getParameter("clubid");
String loginname=request.getParameter("username");
String Status=null;
String password=request.getParameter("password");
String userid=null;
String validmem=null;
loginname=(loginname==null)?"":loginname;
password=(password==null)?"":password;
if(loginname!=null && !"".equals(loginname) && password!=null && !"".equals(password)){ 
//userid=MemberTicketsDB.authenticateCOmmunityUser(loginname,password);
String authquery="select userid from authentication a,club_member b where a.login_name=? and a.password=? and a.user_id=b.userid and b.clubid=CAST(? AS INTEGER) and a.acct_status in('1','3','6')";
//validmem=DbUtil.getVal("select 'yes' from club_member where userid=? and clubid =CAST(? as INTEGER) and status='ACTIVE'",new String[]{userid,clubid});
 userid=DbUtil.getVal(authquery,new String[]{loginname,new StringEncrypter(StringEncrypter.DES_ENCRYPTION_SCHEME).encrypt(password),clubid});
if(userid!=null && !"".equals(userid)){
Status= "Success";
obj.put("status",Status);
obj.put("userid",userid);
}
else{
Status= "Failed";
obj.put("status",Status);
}
}
else{
Status= "Failed";
obj.put("status",Status);
}
out.println(obj.toString());
%>
 