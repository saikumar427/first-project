<%@ page import="org.json.*,java.util.*,com.eventbee.general.*,com.eventregister.*,com.customquestions.*,com.customquestions.beans.*,com.event.dbhelpers.*" %>
<%@ page language="java" contentType="text/html" pageEncoding="UTF-8"%>
<%!
static String  serveraddress="http://"+EbeeConstantsF.get("serveraddress","");

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

String query="select attribid from subgroupattribs where groupid=CAST(? AS BIGINT) and subgroupid=CAST(? AS INTEGER)";
ArrayList attribsList=new ArrayList();
DBManager db=new DBManager();
StatusObj sb=db.executeSelectQuery(query,new String[]{eventid,option});
if(sb.getStatus()){
for(int i=0;i<sb.getCount();i++){
attribsList.add(db.getValue(i,"attribid",""));
}
}
return attribsList;
}


ArrayList getQuestionsFortransactionlevel(String eventid){
	
	String query="select attribid from buyer_custom_questions where eventid=CAST(? AS BIGINT)";
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

String getResponselevelQuestionisrequired(String eventid,String contextid,String attribid){
	
	String isrequired=DbUtil.getVal("select isrequired from base_profile_questions where groupid=CAST(? AS BIGINT) and contextid=CAST(? AS INTEGER) and attribid=?",new String[]{eventid,contextid,attribid});
	
	return isrequired;

}
void fillCustomQuestions(HashMap profilePageLabels, CustomAttribute[] attributeSet,ArrayList customQuestions,JSONArray questionsarray,JSONObject ProfileObject,String pattern){
	try{
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
				attributesObj.put("ErrorMsg",GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.error.message","Required"));
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
			
			ProfileObject.put(pattern+cb.getAttribId(),attributesObj);
			}
		}
	}
}

	}
	catch(Exception e){
	
	}
}
%>

<%!

Boolean checkstatus(String sure,String notsure,String selectedOption,String eventid,String rsvpdate){
	
	if("yes".equals(selectedOption)){
		HashMap completedcount=new HashMap();
		int limit=0;
		int count=0;
		completedcount=getcompletedcount(eventid);
		limit=Integer.parseInt(completedcount.get("rsvplimitallowed").toString());
		if("null".equals(rsvpdate) || "".equals(rsvpdate)){
			
			count=Integer.parseInt(completedcount.get("attendeecount").toString());
		}
		else{
			count=getrecurringrsvpcount(eventid,rsvpdate);
		}

		if(limit == 0){
			limit=100000000;
		}
		if(count<limit){
			
			int availablecount=limit-count;
			
			int selectedcount=Integer.parseInt(sure)+Integer.parseInt(notsure);
		
			if(selectedcount>availablecount){
				return false;
			}
			else{
				return true;
			}
		}
		else{
			return false;
		}
	}
	else{
		return true;
	}
}

HashMap getcompletedcount(String eventid){
		String rsvplimitallowed=DbUtil.getVal("select totallimit from rsvp_settings where eventid=?",new String[]{eventid});
		
		if(rsvplimitallowed == null){
			rsvplimitallowed = "0";
		}
		String surecomcount=DbUtil.getVal("select sum(yescount) from rsvp_transactions where eventid=?",new String[]{eventid});
		if(surecomcount == null){
			surecomcount = "0";
		}
		String notsurecomcount=DbUtil.getVal("select sum(notsurecount) from rsvp_transactions where eventid=?",new String[]{eventid});
		if(notsurecomcount == null){
			notsurecomcount = "0";
		}
		
		int attendeecount=Integer.parseInt(surecomcount)+Integer.parseInt(notsurecomcount);
		
		HashMap count=new HashMap();
		count.put("attendeecount",attendeecount);
		count.put("rsvplimitallowed",rsvplimitallowed);
		return count;
}

int getrecurringrsvpcount(String eventid,String rsvpdate){
	String sure=DbUtil.getVal("select sum(yescount) from rsvp_transactions where eventid=? and tid in(select tid from event_reg_transactions where eventid=? and eventdate=?)",new String[]{eventid,eventid,rsvpdate});
	if(sure == null){
		sure= "0";
	}
	String notsure=DbUtil.getVal("select sum(notsurecount) from rsvp_transactions where eventid=? and tid in(select tid from event_reg_transactions where eventid=? and eventdate=?)",new String[]{eventid,eventid,rsvpdate});
	if(notsure == null){
		notsure= "0";
	}
	int count=Integer.parseInt(sure)+Integer.parseInt(notsure);

	return count;
}

public JSONObject getAttendeeHiddenObject(String id){
		JSONObject obj=new JSONObject();
		try{
		obj.put("Id",id);
		obj.put("textboxsize","30");
		obj.put("lblText","");
		obj.put("txtValue","");
		obj.put("type","text");
		obj.put("Required","N");
		obj.put("ErrorMsg","Required");
		obj.put("StarColor","red");
		}
		catch(Exception e){
		System.out.println(e);
		}
		
		return obj;
		}%>


<%

String sure = request.getParameter("sureattend");
String notsure = request.getParameter("notsureattend");
String eventid=request.getParameter("eventid");
String selectedOption=request.getParameter("option");
String rsvpdate=request.getParameter("rsvp_event_date");

Boolean rsvpstatus=checkstatus(sure,notsure,selectedOption,eventid,rsvpdate);
JSONObject ProfileObject=new JSONObject();
if(rsvpstatus==false){
ProfileObject.put("Available","NO");
}
else{
ProfilePageDisplay profiledisplay=new ProfilePageDisplay();

ProfileObject.put("Available","YES");
JSONObject SureProfile=new JSONObject();
JSONObject NotSureProfile=new JSONObject();
JSONArray questionsarray=new  JSONArray();
JSONArray surequestionsarray=new  JSONArray();
JSONArray notsurequestionsarray=new  JSONArray();

HashMap profilePageLabels=DisplayAttribsDB.getAttribValues(eventid,"RSVPFlowWordings");
profiledisplay.setProfilePageLabels(profilePageLabels);
HashMap hmap=profiledisplay.getAttribsForTickets("0",eventid);
questionsarray.put("fname");
	questionsarray.put("lname");
	questionsarray.put("email");

if("yes".equals(selectedOption)){
	
	ProfileObject.put("p_fname",getAttendeeHiddenObject("fname"));
	ProfileObject.put("p_lname",getAttendeeHiddenObject("lname"));
	ProfileObject.put("p_email",getAttendeeHiddenObject("email"));
	
	
}
else{
	String phonerequired=null;
	if(hmap!=null&&hmap.size()>0)
		phonerequired=(String)hmap.get("phone");

	ProfileObject.put("p_fname",profiledisplay.getRSVPAttendeeObject(GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.fname.label","First Name"),"fname","Y"));
	ProfileObject.put("p_lname",profiledisplay.getRSVPAttendeeObject(GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.lname.label","Last Name"),"lname","Y"));
	ProfileObject.put("p_email",profiledisplay.getRSVPAttendeeObject(GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.email.label","Email"),"email","Y"));
	if(phonerequired!=null){
		questionsarray.put("phone");
		ProfileObject.put("p_phone",profiledisplay.getRSVPAttendeeObject(GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.phone.label","Phone"),"phone",phonerequired));
	}
	
}
ProfileObject.put("questions",questionsarray);
if(Integer.parseInt(sure)>0){
	
surequestionsarray.put("fname");
surequestionsarray.put("lname");
surequestionsarray.put("email");

ProfileObject.put("s_fname",profiledisplay.getRSVPAttendeeObject(GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.fname.label","First Name"),"fname","Y"));
ProfileObject.put("s_lname",profiledisplay.getRSVPAttendeeObject(GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.lname.label","Last Name"),"lname","Y"));
ProfileObject.put("s_email",profiledisplay.getRSVPAttendeeObject(GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.email.label","Email"),"email","Y"));


ProfileObject.put("surequestions",surequestionsarray);
}

if(Integer.parseInt(notsure)>0){
notsurequestionsarray.put("fname");
notsurequestionsarray.put("lname");
notsurequestionsarray.put("email");
ProfileObject.put("ns_fname",profiledisplay.getRSVPAttendeeObject(GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.fname.label","First Name"),"fname","Y"));
ProfileObject.put("ns_lname",profiledisplay.getRSVPAttendeeObject(GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.lname.label","Last Name"),"lname","Y"));
ProfileObject.put("ns_email",profiledisplay.getRSVPAttendeeObject(GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.email.label","Email"),"email","Y"));
ProfileObject.put("notsurequestions",notsurequestionsarray);
}


CustomAttribsDB ticketcustomattribs=new CustomAttribsDB();
CustomAttribSet customattribs=(CustomAttribSet)ticketcustomattribs.getCustomAttribSet(eventid,"EVENT" );
CustomAttribute[]  attributeSet=customattribs.getAttributes();


//ArrayList customQuestions=getQuestionsFortheSelectedOption(selectedOption,eventid);
ArrayList customQuestions=getQuestionsFortransactionlevel(eventid);
fillCustomQuestions(profilePageLabels,attributeSet,customQuestions,questionsarray,ProfileObject,"p_");

ArrayList customsureQuestions=getQuestionsFortheSelectedOption("101",eventid);
fillCustomQuestions(profilePageLabels,attributeSet,customsureQuestions,surequestionsarray,ProfileObject,"s_");

ArrayList customnotsureQuestions=getQuestionsFortheSelectedOption("102",eventid);
fillCustomQuestions(profilePageLabels,attributeSet,customnotsureQuestions,notsurequestionsarray,ProfileObject,"ns_");



}
try{
String showsharepopup=DbUtil.getVal("select value from config where name='event.confirmationpage.fbsharepopup.show' and config_id=(select config_id from eventinfo where eventid=CAST(? AS BIGINT))",new String[]{eventid});
ProfileObject.put("showsharepopup",showsharepopup);
}catch(Exception e){}

ProfileObject.put("serveraddress",serveraddress);

out.println(ProfileObject.toString());
//System.out.println(ProfileObject.toString());


%>