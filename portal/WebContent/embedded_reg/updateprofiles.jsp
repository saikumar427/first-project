<%@ page import="org.json.JSONObject"%>
<%@ page import="java.util.*,com.eventbee.general.*"%>
<%@ page import="com.eventregister.*,com.customquestions.*,com.customquestions.beans.*" %>
<%

String tid=request.getParameter("tid");
String eid=request.getParameter("eid");

System.out.println("in updateprofiles");
JSONObject obj=new JSONObject();
RegistrationTiketingManager regTktMgr=new RegistrationTiketingManager();
String isalreadyinserted=DbUtil.getVal("select 'yes' from buyer_base_info where profilestatus is null and transactionid=?",new String[]{tid});
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "updateprofile.jsp.jsp", "checking for   buyer data for ---------"+tid+"----is ----"+isalreadyinserted, "", null);
if(!"yes".equals(isalreadyinserted)){

ProfileActionDB profiledbaction=new ProfileActionDB();
ArrayList buyerAttribs=regTktMgr.getBuyerSpecificAttribs(eid);
boolean status=true;
profiledbaction.clearDBEntries(tid);
ArrayList ticketsList=regTktMgr.getSelectedTickets(tid);
HashMap responseMasterMap=new HashMap();
HashMap ticketspecificAttributeIds=null;
ArrayList ticketlevelbaseProfiles=regTktMgr.getTicketIdsForBaseProfiles(eid);
String custom_setid=request.getParameter("attribsetid");
CustomAttribsDB ticketcustomattribs=new CustomAttribsDB();
CustomAttribSet customattribs=(CustomAttribSet)ticketcustomattribs.getCustomAttribSet(eid,"EVENT" );
CustomAttribute[]  attributeSet=customattribs.getAttributes();
ticketspecificAttributeIds=ticketcustomattribs.getTicketLevelAttributes(eid);
try{
String buyerfname=request.getParameter("q_buyer_fname_1");
String buyerlname=request.getParameter("q_buyer_lname_1");
String buyeremail=request.getParameter("q_buyer_email_1");
String buyerphone=request.getParameter("q_buyer_phone_1");
for(int i=0;i<ticketsList.size();i++){
HashMap hmap=(HashMap)ticketsList.get(i);
String ticketid=(String)hmap.get("selectedTicket");
String tickettype=(String)hmap.get("type");
String count=(String)hmap.get("qty");
String attendeeids[]=DbUtil.getSeqVals("seq_attendeeId",Integer.parseInt(count));
ArrayList attriblist=(ArrayList)ticketspecificAttributeIds.get(ticketid);
for(int index=0;index<Integer.parseInt(count);index++){
String attendeeKey="AK"+EncodeNum.encodeNum(attendeeids[index]).toUpperCase();
HashMap basicProfile=new HashMap();
if(request.getParameter("q_"+ticketid+"_fname_"+(index+1))!=null)
basicProfile.put("fname",request.getParameter("q_"+ticketid+"_fname_"+(index+1)));
else
basicProfile.put("fname",buyerfname);
if(request.getParameter("q_"+ticketid+"_lname_"+(index+1))!=null)
basicProfile.put("lname",request.getParameter("q_"+ticketid+"_lname_"+(index+1)));
else
basicProfile.put("lname",buyerlname);
if(request.getParameter("q_"+ticketid+"_email_"+(index+1))!=null)
basicProfile.put("email",request.getParameter("q_"+ticketid+"_email_"+(index+1)));
else
basicProfile.put("email","");
if(request.getParameter("q_"+ticketid+"_phone_"+(index+1))!=null)
basicProfile.put("phone",request.getParameter("q_"+ticketid+"_phone_"+(index+1)));
else
basicProfile.put("phone","");
basicProfile.put("profileid",attendeeids[index]);
basicProfile.put("profilekey",attendeeKey);
basicProfile.put("eventid",eid);
basicProfile.put("tid",tid);
basicProfile.put("ticketid",ticketid);
basicProfile.put("tickettype",tickettype);
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "updateprofile.jsp", "before Updating  profile data---------"+tid+"--------"+basicProfile, "", null);
profiledbaction.updateBaseProfile(basicProfile);
if(attributeSet!=null&&attributeSet.length>0){
if(attriblist!=null&&attriblist.size()>0){
String responseId=DbUtil.getVal("select nextval('attributes_survey_responseid')",null);
responseMasterMap.put("responseid",responseId);
responseMasterMap.put("tid",tid);
responseMasterMap.put("eventid",eid);
responseMasterMap.put("profileid",attendeeids[index]);
responseMasterMap.put("profilekey",attendeeKey);
responseMasterMap.put("ticketid",ticketid);
responseMasterMap.put("custom_setid",custom_setid);
profiledbaction.InsertResponseMaster(responseMasterMap);
String shortresponse=null;
String bigresponse=null;

for(int j=0;j<attributeSet.length;j++){
CustomAttribute cb=(CustomAttribute)attributeSet[j];
if(attriblist.contains(cb.getAttribId())){
String questionid=cb.getAttribId();
String question=cb.getAttributeName();
String type=cb.getAttributeType();
ArrayList options=cb.getOptions();
if("checkbox".equals(type)||"radio".equals(type)||"select".equals(type)){
String responses[]=request.getParameterValues("q_"+ticketid+"_"+questionid+"_"+(index+1));
String responsesVal[]=profiledbaction.getOptionVal(options,responses);
shortresponse=GenUtil.stringArrayToStr(responses,",");
bigresponse=GenUtil.stringArrayToStr(responsesVal,",");
}
else{
shortresponse=request.getParameter("q_"+ticketid+"_"+questionid+"_"+(index+1));
bigresponse=request.getParameter("q_"+ticketid+"_"+questionid+"_"+(index+1));
}
HashMap respnseMap=new HashMap();
respnseMap.put("question",question);
respnseMap.put("questionid",questionid);
respnseMap.put("shortresponse",shortresponse);
respnseMap.put("bigresponse",bigresponse);
respnseMap.put("responseid",responseId);
profiledbaction.insertResponse(respnseMap);
}
}
}  
}
}
}  
String profileid=DbUtil.getVal("select nextval('SEQ_attendeeid')",new String[]{});
String profilekey="AK"+EncodeNum.encodeNum(profileid).toUpperCase();
HashMap buyerBasInfo=new HashMap();
buyerBasInfo.put("fname",buyerfname);
buyerBasInfo.put("lname",buyerlname);
buyerBasInfo.put("email",buyeremail);
buyerBasInfo.put("phone",buyerphone);
buyerBasInfo.put("profileid",profileid);
buyerBasInfo.put("profilekey",profilekey);
buyerBasInfo.put("tid",tid);
buyerBasInfo.put("eventid",eid);
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "updateprofile.jsp.jsp", "before Updating  buyer data---------"+tid+"--------"+buyerBasInfo, "", null);
profiledbaction.InserBuyerInfo(buyerBasInfo);

StatusObj d=DbUtil.executeUpdateQuery("update event_reg_transactions set fname=?,lname=?,email=?,phone=? where tid=?",new String[]{buyerfname,buyerlname,buyeremail,buyerphone,tid});

EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "updateprofile.jsp.jsp", " Updating  buyer data--in event_reg_transaction-------"+tid+"--------"+d.getStatus(), "", null);

if(attributeSet!=null&&attributeSet.length>0&&buyerAttribs!=null&&buyerAttribs.size()>0){
String responseId=DbUtil.getVal("select nextval('attributes_survey_responseid')",null);
HashMap buyerResponsemaster=new HashMap();
buyerResponsemaster.put("responseid",responseId);
buyerResponsemaster.put("ticketid","0");
buyerResponsemaster.put("profileid",profileid);
buyerResponsemaster.put("eventid",eid);
buyerResponsemaster.put("profilekey",profilekey);
buyerResponsemaster.put("profileid",profileid);
buyerResponsemaster.put("tid",tid);
buyerResponsemaster.put("custom_setid",custom_setid);
profiledbaction.InsertResponseMaster(buyerResponsemaster);
String bigresponse=null;
String shortresponse=null;
for(int j=0;j<attributeSet.length;j++){
CustomAttribute cb=(CustomAttribute)attributeSet[j];
if(buyerAttribs.contains(cb.getAttribId())){
String questionid=cb.getAttribId();
String question=cb.getAttributeName();
String type=cb.getAttributeType();
ArrayList options=cb.getOptions();
if("checkbox".equals(type)||"radio".equals(type)||"select".equals(type)){
String responses[]=request.getParameterValues("q_buyer_"+questionid+"_1");
String responsesVal[]=profiledbaction.getOptionVal(options,responses);
shortresponse=GenUtil.stringArrayToStr(responses,",");
bigresponse=GenUtil.stringArrayToStr(responsesVal,",");
}
else{
shortresponse=request.getParameter("q_buyer_"+questionid+"_1");
bigresponse=request.getParameter("q_buyer_"+questionid+"_1");
}
HashMap buyerResponse=new HashMap();
buyerResponse.put("question",question);
buyerResponse.put("questionid",questionid);
buyerResponse.put("shortresponse",shortresponse);
buyerResponse.put("bigresponse",bigresponse);
buyerResponse.put("responseid",responseId);

profiledbaction.insertResponse(buyerResponse);
}
}
}  
}
catch(Exception e){
status=false;
System.out.println("Exception In  PROFILE SUBMISSION"+e.getMessage());
}
if(status)
obj.put("status","Success");
else
obj.put("status","fail");
out.print(obj.toString());
}
else
{
obj.put("status","Success");
}
out.print(obj.toString());

%>
