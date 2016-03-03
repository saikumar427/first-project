<%	
Vector attendee=null;
HashMap customattribs=null;
HashMap hm1=jBean.getTransactionInfo();
if(hm1!=null){			
attendee=(Vector)hm1.get("AttendeeDetails");
customattribs=(HashMap)hm1.get("CustomAttribs");
}
String [] surveyresponses[]=null;
if(attendee!=null&&attendee.size()>0){
if(jBean!=null){
jBean.initProfile(attendee.size());
}
ProfileData[] pd=jBean.getProfileData();

pd=jBean.getProfileData();
SurveyAttendee[] surveys=jBean.getSurveys();

for(int i=0;i<pd.length;i++){
{
HashMap pm=(HashMap)attendee.elementAt(i);
HashMap responsemap=null;

if(pm!=null){
String attendeekey=(String)pm.get("attendeekey");
if(customattribs!=null){
responsemap=(HashMap)customattribs.get(attendeekey);
}

String phone=(String)pm.get("phone");
if(phone==null||"null".equals(phone))
phone="";
pd[i].setFirstName((String)pm.get("firstname"));
pd[i].setLastName((String)pm.get("lastname"));
pd[i].setEmail((String)pm.get("email"));
pd[i].setPhone(phone);
}
if(surveys!=null&&surveys.length>0){
surveyresponses=jBean.getSurveys()[i].getSurveyResponse();
Vector quesv=(Vector)jBean.getSurveys()[i].getQuestionObject();
if(quesv!=null){
for(int surveyi=0;surveyi<quesv.size();surveyi++){
SurveyQuestion sinfotemp1=(SurveyQuestion)quesv.elementAt(surveyi);
String ques=sinfotemp1.getQuestion();
String qtype=sinfotemp1.getQuestionType();
if(responsemap!=null)
if("checkbox".equals(qtype)){
String answers=(String)responsemap.get(ques);
String []answersarray=GenUtil.strToArrayStr(answers,"##");
surveyresponses[surveyi]=answersarray;
}
else
surveyresponses[surveyi]=new String []{(String)responsemap.get(ques)};
}
}
jBean.getSurveys()[i].setSurveyResponse(surveyresponses);
}
}
}
session.setAttribute("Custom_"+jBean.getEventId(),surveys);
jBean.setProfileData(pd);
}
%>