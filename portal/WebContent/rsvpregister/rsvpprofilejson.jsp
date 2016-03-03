<%@ page import="org.json.*,java.util.*,com.eventbee.general.*,com.eventregister.*,com.customquestions.*,com.customquestions.beans.*,com.event.dbhelpers.*" %>
<%@ page language="java" contentType="text/html" pageEncoding="UTF-8"%>


<%!
JSONObject getAttendeeObject(String question,String id){
JSONObject obj=new JSONObject();
try{
obj.put("Id",id);
obj.put("textboxsize","30");
obj.put("lblText",question);
obj.put("txtValue","");
obj.put("type","text");
obj.put("Required","Y");
obj.put("ErrorMsg","Required");
obj.put("StarColor","red");
}
catch(Exception e){
}

return obj;
}

ArrayList getQuestionsFortheSelectedOption(String option,String eventid){
String query="select attrib_id from rsvp_attribs where eventid=? and rsvp_status=?";
ArrayList attribsList=new ArrayList();
DBManager db=new DBManager();
StatusObj sb=db.executeSelectQuery(query,new String[]{eventid,option});
if(sb.getStatus()){
for(int i=0;i<sb.getCount();i++){
attribsList.add(db.getValue(i,"attrib_id",""));
}
}
return attribsList;
}


ArrayList getQuestionsFortransactionlevel(String eventid){
	
	String query="select attribid from buyer_custom_questions where eventid=?";
	ArrayList attribsList=new ArrayList();
	DBManager db=new DBManager();
	StatusObj sb=db.executeSelectQuery(query,new String[]{eventid});
	if(sb.getStatus()){
		for(int i=0;i<sb.getCount();i++){
			attribsList.add(db.getValue(i,"attribid",""));
		}
	}
	
	return attribsList;


}

%>




<%

String selectedOption=request.getParameter("option");
ProfilePageDisplay profiledisplay=new ProfilePageDisplay();
String eventid=request.getParameter("eventid");
JSONObject ProfileObject=new JSONObject();
JSONArray questionsarray=new  JSONArray();
HashMap profilePageLabels=DisplayAttribsDB.getAttribValues(eventid,"RSVPFlowWordings");
HashMap hmap=profiledisplay.getAttribsForTickets("0",eventid);
String phonerequired=null;
if(hmap!=null&&hmap.size()>0)
	phonerequired=(String)hmap.get("phone");
questionsarray.put("fname");
questionsarray.put("lname");
questionsarray.put("email");
ProfileObject.put("p_fname",profiledisplay.getAttendeeObject(GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.fname.label","First Name"),"fname","Y"));
ProfileObject.put("p_lname",profiledisplay.getAttendeeObject(GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.lname.label","Last Name"),"lname","Y"));
ProfileObject.put("p_email",profiledisplay.getAttendeeObject(GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.email.label","Email"),"email","Y"));
if(phonerequired!=null){
	questionsarray.put("phone");
	ProfileObject.put("p_phone",profiledisplay.getAttendeeObject(GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.phone.label","Phone"),"phone",phonerequired));
}

CustomAttribsDB ticketcustomattribs=new CustomAttribsDB();
CustomAttribSet customattribs=(CustomAttribSet)ticketcustomattribs.getCustomAttribSet(eventid,"EVENT" );
CustomAttribute[]  attributeSet=customattribs.getAttributes();
//ArrayList customQuestions=getQuestionsFortheSelectedOption(selectedOption,eventid);
ArrayList customQuestions=getQuestionsFortransactionlevel(eventid);
if(attributeSet!=null&&attributeSet.length>0){
	if(customQuestions!=null&&customQuestions.size()>0){
		for(int k=0;k<attributeSet.length;k++){
		  CustomAttribute cb=(CustomAttribute)attributeSet[k];

		  JSONObject attributesObj=new JSONObject();
		  if(customQuestions.contains(cb.getAttribId())){
			attributesObj.put("qType",cb.getAttributeType());
			attributesObj.put("qId",cb.getAttribId());
			attributesObj.put("lblText",cb.getAttributeName());
			attributesObj.put("type",cb.getAttributeType());
			attributesObj.put("Required","Required".equals(cb.getisRequired())?"Y":"N");
			attributesObj.put("ErrorMsg","Required");
			attributesObj.put("StarColor","red");
			attributesObj.put("Id",cb.getAttribId());
			String attrib_setid=cb.getAttribSetId();
			if("text".equals(cb.getAttributeType()))
				attributesObj.put("textboxsize",cb.getTextboxSize());
			else if("textarea".equals(cb.getAttributeType())){
				attributesObj.put("rows",cb.getRows());
				attributesObj.put("cols",cb.getCols());
			}
		  else{
			ArrayList  customattribOptions=cb.getOptions();
			if(customattribOptions!=null&&customattribOptions.size()>0){
				JSONArray optionsArrayObj=new JSONArray();
				for(int p=0;p<customattribOptions.size();p++){
					AttribOption option=(AttribOption)customattribOptions.get(p);
					JSONObject optionObj=new JSONObject();

					optionObj.put("Display",option.getOptionValue());
					optionObj.put("Value",option.getOptionid());
					optionsArrayObj.put(optionObj);
				}
				if("select".equals(cb.getAttributeType()))
					attributesObj.put("Validate","N");

				attributesObj.put("Options",optionsArrayObj);
			}
		}
		questionsarray.put(cb.getAttribId());
		ProfileObject.put("p_"+cb.getAttribId(),attributesObj);
			}
		}
	}
}
ProfileObject.put("questions",questionsarray);

out.println(ProfileObject.toString());

System.out.println(ProfileObject.toString());
%>