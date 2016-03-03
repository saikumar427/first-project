<%@ page import="com.eventbee.general.*"%>
<%@ page import="java.util.HashMap,java.util.ArrayList"%>
<%@ page import="java.util.*,com.customattributes.*"%>
<%!
public class ProfileManager{
void deleteAttendeeInfo(String tid){
StatusObj sb=DbUtil.executeUpdateQuery("delete from custom_attrib_response where responseid in(select responseid from custom_attrib_response_master where userid in (select attendeeKey from event_attendee_info where tid=?))",new String[]{tid});
StatusObj sb1=DbUtil.executeUpdateQuery("delete from custom_attrib_response_master where userid in (select attendeeKey from event_attendee_info where tid=?)",new String[]{tid});
StatusObj sb2=DbUtil.executeUpdateQuery("delete from event_attendee_info where tid=?",new String[]{tid});
}

void InsertAttendeeInfo(HashMap attendeeMap){
String query="insert into event_attendee_info(fname,lname,tid,attendeekey,attendeeid,eventid,phone,email,priattendee,authid) values(?,?,?,?,?,?,?,?,?,?)";
DbUtil.executeUpdateQuery(query,new String[]{(String)attendeeMap.get("fname"),(String)attendeeMap.get("lname"),(String)attendeeMap.get("tid"),(String)attendeeMap.get("attendeekey"),(String)attendeeMap.get("attendeeid"),(String)attendeeMap.get("eventid"),(String)attendeeMap.get("phone"),(String)attendeeMap.get("email"),(String)attendeeMap.get("priattendee"),(String)attendeeMap.get("authid")});
}
void InsertResponseMaster(String custom_setid,String responseId,String userid){
String INSERT_RESPONSE_MASTER="insert into custom_attrib_response_master(userid,attrib_setid,responseid,response_dt) values (?,?,?,now())";
DbUtil.executeUpdateQuery(INSERT_RESPONSE_MASTER,new String[]{userid,custom_setid,responseId});
}
void InsertResponse(String responseid,String attrib_name,String qresponse){
String query="insert into custom_attrib_response(responseid,attrib_name,response) values (?,?,?)";
DbUtil.executeUpdateQuery(query,new String[]{responseid,attrib_name,qresponse});
}
public boolean insertAttendeeProfile(HttpServletRequest req){
String qresponse="";
String eventid=req.getParameter("eid");
String tid=req.getParameter("tid");
String profileCount=req.getParameter("currentcount");
String custom_setid=req.getParameter("attribsetid");
try{
String attendeeids[]=DbUtil.getSeqVals("seq_attendeeId",Integer.parseInt(profileCount));
CustomAttributes [] customattribs=CustomAttributesDB.getCustomAttributes(eventid,"EVENT");
deleteAttendeeInfo(tid);
for(int i=0;i<Integer.parseInt(profileCount);i++){
HashMap attendeeMap=new HashMap();
String firstname=req.getParameter("P"+(i+1)+"fname");
String lastname=req.getParameter("P"+(i+1)+"lname");
String email=req.getParameter("P"+(i+1)+"email");
String phone=req.getParameter("P"+(i+1)+"phone");
String attendeeKey="AK"+EncodeNum.encodeNum(attendeeids[i]).toUpperCase();
attendeeMap.put("tid",tid);
attendeeMap.put("attendeeid",attendeeids[i]);
attendeeMap.put("priattendee",(i==0)?"Y":"N");
attendeeMap.put("attendeekey",attendeeKey);
attendeeMap.put("eventid",eventid);
attendeeMap.put("fname",firstname);
attendeeMap.put("lname",lastname);
attendeeMap.put("phone",phone);
attendeeMap.put("email",email);
attendeeMap.put("authid","0");
InsertAttendeeInfo(attendeeMap);
if(customattribs!=null&&customattribs.length>0){
String responseId=DbUtil.getVal("select nextval('attributes_survey_responseid')",null);
InsertResponseMaster(custom_setid,responseId,attendeeKey);
for(int j=0;j<customattribs.length;j++){
CustomAttributes cb=(CustomAttributes)customattribs[j];
String question=cb.getAttributeName();
String type=cb.getAttributeType();
if("checkbox".equals(type)){
String responses[]=req.getParameterValues("P"+(i+1)+"Q"+(j+1));
qresponse=GenUtil.stringArrayToStr(responses,",");
}
else{
qresponse=req.getParameter("P"+(i+1)+"Q"+(j+1));
}
InsertResponse(responseId,question,qresponse);
}
}  
}
}catch(Exception ex){
return false;
}
return true;
}
}
%>
