
<%@ page import="java.util.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.event.*"%>

<%!
Vector getTransactionIds(String email,String groupid){
Vector vec=new Vector();
DBManager dbmanager=new DBManager();

StatusObj sb=dbmanager.executeSelectQuery("select distinct transactionid from eventattendee where priattendee='Y' and email=? and eventid=?",new String[]{email,groupid});

if(sb.getStatus()){

for(int k=0;k<sb.getCount();k++){
HashMap hm=new HashMap();
hm.put("transactionid",dbmanager.getValue(k,"transactionid",""));
			
vec.add(hm);
}
}

return vec;
}

void sendEmail(Vector v,String email,String eventname){



String htmlmessage="";

htmlmessage="Hi,";

if(v.size()>1)
htmlmessage=htmlmessage+"<br/><br/>Following Transaction IDs belong to your event registration:<br/><br/>";
else
htmlmessage=htmlmessage+"<br/><br/>Following Transaction ID belong to your event registration:<br/><br/>";


if(v!=null&&v.size()>0){

for(int i=0;i<v.size();i++){
HashMap hm1=(HashMap)v.elementAt(i);

String transactionid=(String)hm1.get("transactionid");


htmlmessage=htmlmessage+"Transaction ID: "+transactionid+"<br/>";

}

htmlmessage=htmlmessage+"<br/>Thanks,<br/>EventbeeTeam";

}
EmailObj emailobj=EventbeeMail.getEmailObj();
emailobj.setFrom("support@eventbee.com");
emailobj.setTo(email);
emailobj.setSubject("Your Transaction ID for "+eventname);
emailobj.setHtmlMessage(htmlmessage);
EventbeeMail.sendHtmlMailPlain(emailobj);


}
%>










<%
Vector v=null;
String email=request.getParameter("email");
String groupid=request.getParameter("GROUPID");


String eventname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{groupid});

v=getTransactionIds(email,groupid);
if(v!=null&&v.size()>0){
sendEmail(v,email,eventname);
out.println("Success");

}
else
out.println("Invalid");

%>