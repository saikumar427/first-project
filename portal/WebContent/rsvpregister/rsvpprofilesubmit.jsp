<%@ page import="java.io.*,java.util.*,com.eventbee.general.*,com.eventregister.*,com.customquestions.*,com.customquestions.beans.*,com.eventbee.event.ticketinfo.*" %>
<%@ page import="org.json.JSONObject"%>
<%
RegistrationTiketingManager regtktmgr=new RegistrationTiketingManager();
String eventid=request.getParameter("eventid");
String attribsetid=request.getParameter("attribsetid");
boolean status=true;
String Msg="";
JSONObject obj=new JSONObject();
ProfileActionDB profiledbaction=new ProfileActionDB();
ArrayList attribsList=regtktmgr.getQuestionsFortheSelectedOption(request.getParameter("selectedoption"),eventid);

CustomAttribsDB ticketcustomattribs=new CustomAttribsDB();
CustomAttribSet customattribs=(CustomAttribSet)ticketcustomattribs.getCustomAttribSet(eventid,"EVENT" );
CustomAttribute[]  attributeSet=customattribs.getAttributes();
try{
String firstname=request.getParameter("q_p_fname");
String lastname=request.getParameter("q_p_lname");
String email=request.getParameter("q_p_email");
String phone=request.getParameter("q_p_phone");
String option=request.getParameter("selectedoption");
String rec_event_date=request.getParameter("rsvp_event_date");


Msg="Thank you, your RSVP information is sent to the Event Manager";
String attendeeid=DbUtil.getVal("select nextval('SEQ_attendeeid')",new String[]{});
HashMap rsvpAttendee=new HashMap();
rsvpAttendee.put("fname",firstname);
rsvpAttendee.put("lname",lastname);
rsvpAttendee.put("email",email);
rsvpAttendee.put("emailid",email);
rsvpAttendee.put("phone",phone);
rsvpAttendee.put("attendeeid",attendeeid);
rsvpAttendee.put("eventid",eventid);
rsvpAttendee.put("GROUPID",eventid);
rsvpAttendee.put("attending",option);
profiledbaction.InsertAttendeeInfo(rsvpAttendee);
if(attributeSet!=null&&attributeSet.length>0){
String responseId=DbUtil.getVal("select nextval('attributes_survey_responseid')",null);
HashMap responseMasterMap=new HashMap();
responseMasterMap.put("responseid",responseId);
responseMasterMap.put("tid","0");
responseMasterMap.put("eventid",eventid);
responseMasterMap.put("profileid",attendeeid);
responseMasterMap.put("profilekey","");
responseMasterMap.put("ticketid","0");
responseMasterMap.put("custom_setid",attribsetid);
profiledbaction.InsertResponseMaster(responseMasterMap);
String shortresponse=null;
String bigresponse=null;
for(int j=0;j<attributeSet.length;j++){
CustomAttribute cb=(CustomAttribute)attributeSet[j];
if(attribsList.contains(cb.getAttribId())){
String questionid=cb.getAttribId();
String question=cb.getAttributeName();
String type=cb.getAttributeType();
ArrayList options=cb.getOptions();
if("checkbox".equals(type)||"radio".equals(type)||"select".equals(type)){
String responses[]=request.getParameterValues("q_p_"+questionid);
String responsesVal[]=profiledbaction.getOptionVal(options,responses);
shortresponse=GenUtil.stringArrayToStr(responses,",");
bigresponse=GenUtil.stringArrayToStr(responsesVal,",");
}
else{
shortresponse=request.getParameter("q_p_"+questionid);
bigresponse=request.getParameter("q_p_"+questionid);

}

HashMap userResponse=new HashMap();
userResponse.put("question",question);
userResponse.put("questionid",questionid);
userResponse.put("shortresponse",shortresponse);
userResponse.put("bigresponse",bigresponse);
userResponse.put("responseid",responseId);
profiledbaction.insertResponse(userResponse);

//InsertResponse(responseId,question,shortresponse,questionid,bigresponse);
}
}
}  
}
catch(Exception e){
status=false;
System.out.println("Exception In RSVP PROFILE SUBMISSION"+e.getMessage());
}
if(status){
obj.put("Status","Success");
obj.put("Msg",Msg);
}
else
obj.put("Status","Fail");



out.print(obj.toString());

System.out.println(obj.toString());
%>



