<%@ page import="java.io.*,java.util.*,com.eventbee.general.*,com.eventregister.*,com.customquestions.*,com.customquestions.beans.*" %>
<%@ page import="org.apache.velocity .*,org.apache.velocity.app.Velocity,org.apache.velocity.context.*,org.apache.velocity.exception.*,org.apache.velocity.app.*" %>
<%@ page import="org.json.*,com.event.dbhelpers.*"%>
<%@ page language="java" contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.eventbee.layout.DBHelper" %>
<%@ page import="com.event.i18n.dbmanager.ConfirmationPageDAO" %>
<%@ include file='/globalprops.jsp' %>

<%!
HashMap getfieldMap(String field){
	HashMap map=new HashMap();
	map.put("qId",field);
	return map;
}

Vector getAttendeeObject(){
	Vector v=new Vector();
	List list=new ArrayList();
	list.add("fname");
	list.add("lname");
	list.add("email");
	list.add("phone");
	for(int i=0;i<list.size();i++){
		HashMap hm=getfieldMap((String)list.get(i));
		v.add(hm);
	}
	return v;
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

ArrayList getQuestionsFortheTransactionlevel(String eventid){
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




Vector gettransactionprofile(String eventid,CustomAttribute[] attributeSet){
	Vector questions=new Vector();
	ArrayList ticketspecificAttributeIds=null;
	Vector p=getAttendeeObject();
	questions.addAll(p);
if(attributeSet!=null&&attributeSet.length>0){
	ticketspecificAttributeIds=getQuestionsFortheTransactionlevel(eventid);
	if(ticketspecificAttributeIds!=null)
	{
		if(attributeSet!=null&&attributeSet.length>0){
			
			for(int k=0;k<attributeSet.length;k++){
			boolean noattribs=false;
			ArrayList al=null;
			HashMap customMap=new HashMap();
			CustomAttribute cb=(CustomAttribute)attributeSet[k];
			customMap.put("qType",cb.getAttributeType());
			customMap.put("qId",cb.getAttribId());
			System.out.println("ticketspecificAttributeIds--"+ticketspecificAttributeIds);
			if((ticketspecificAttributeIds!=null&&ticketspecificAttributeIds.contains(cb.getAttribId()))){
			questions.add(customMap);
    	  }
		}
		}
	  }
	}
	return questions;
}


Vector getattendprofile(String eventid,String selectedOption,CustomAttribute[] attributeSet, VelocityContext context,HashMap profilePageLabels){
	Vector questions=new Vector();
	ArrayList ticketspecificAttributeIds=null;
	String option="101";
	if("notsure".equals(selectedOption)){
		option="102";
	}
	Vector p=getAttendeeObject();
	questions.addAll(p);

if(attributeSet!=null&&attributeSet.length>0){
	ticketspecificAttributeIds=getQuestionsFortheSelectedOption(option,eventid);
	if(ticketspecificAttributeIds!=null)
	{
		if(attributeSet!=null&&attributeSet.length>0){
			
			for(int k=0;k<attributeSet.length;k++){
				
				boolean noattribs=false;
				ArrayList al=null;
				HashMap customMap=new HashMap();
				CustomAttribute cb=(CustomAttribute)attributeSet[k];
				customMap.put("qType",cb.getAttributeType());
				customMap.put("qId",cb.getAttribId());
				System.out.println("ticketspecificAttributeIds--"+ticketspecificAttributeIds);
				if((ticketspecificAttributeIds!=null&&ticketspecificAttributeIds.contains(cb.getAttribId()))){
					questions.add(customMap);
    			}
			}
		}
	 }
}
	
return questions;
}
String getpromotionsection(String eventid,HashMap profilePageLabels){
String promotionsection=DbUtil.getVal("Select value from config where name='show.ebee.promotions' and config_id=(select config_id from eventinfo where eventid=CAST(? AS BIGINT))",new String[]{eventid});
if("No".equals(promotionsection))
{
	promotionsection=null;
}
else
{
	promotionsection="<span class='toggle'><input type='checkbox' id='enablepromotion' name='enablepromotion' value=''  checked/></span> "+GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.promotions.message","I would like to receive promotions and discounts from Eventbee and its partners");
}
return promotionsection;
}
%>
<%

String rsvp_event_date=request.getParameter("rsvp_event_date");
String selectedOption=request.getParameter("option");
String eventid=request.getParameter("eventid");
String sure=request.getParameter("sure");
String notsure=request.getParameter("notsure");
String trackcode=request.getParameter("trackcode");
HashMap attribMap=new HashMap();
HashMap sureattribMap=new HashMap();
HashMap notsureattribMap=new HashMap();
String arribsetid=null;
	CustomAttribsDB ticketcustomattribs=new CustomAttribsDB();
	

CustomAttribSet customattribs=(CustomAttribSet)ticketcustomattribs.getCustomAttribSet(eventid,"EVENT" );
CustomAttribute[]  attributeSet=customattribs.getAttributes();
arribsetid=customattribs.getAttribSetid();
String lang=DBHelper.getLanguageFromDB(eventid);
if(lang==null || "lang".equals(lang)) lang="en_US";
HashMap profilePageLabels=DisplayAttribsDB.getDisplayAttribs(eventid,"RSVPFlowWordings",lang);
VelocityContext context = new VelocityContext();
try{

Vector questions=gettransactionprofile(eventid,attributeSet);
attribMap.put("customProfile",questions);

Vector surequestions=getattendprofile(eventid,"yes",attributeSet,context,profilePageLabels);
sureattribMap.put("SurecustomProfile",surequestions);

Vector notsurequestions=getattendprofile(eventid,"notsure",attributeSet,context,profilePageLabels);
notsureattribMap.put("NotSurecustomProfile",notsurequestions);


}
catch(Exception e){
System.out.println("getprofiles----"+e.getMessage());
}

String rsvpsuspended=DbUtil.getVal("select status from eventinfo where eventid=CAST(? AS BIGINT)",new String[]{eventid});

String rsvpprofileForm="<form name='rsvpprofile', id='rsvpprofile' action='/rsvpregister/rsvprecprofilesubmit.jsp' method='post' ><input type='hidden' name='attribsetid' value='"+arribsetid+"' /><input type='hidden' name='eventid' value='"+eventid+"' /><input type='hidden' name='selectedoption' id='selectedOption' value='"+selectedOption+"' /><input type='hidden' name='rsvp_event_date' value='"+rsvp_event_date+"' /><input type='hidden' name='sure' value='"+sure+"' /><input type='hidden' name='notsure' value='"+notsure+"' /><input type='hidden' name='trackcode' id='trackcode' value='"+trackcode+"'><input type='hidden' name='rsvpsuspended' id='rsvpsuspended' value='"+rsvpsuspended+"' />";
String rsvpprofileFormclose="";
if("mobile".equals(request.getParameter("regtype"))){
rsvpprofileFormclose="<center><input type='button' name='submit' id='submit' value='"+GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.submitbutton.label","Submit")+"' onclick='validateRsvpProfiles();' /></center></form>";

}
else
rsvpprofileFormclose="<input type='button' name='submit' id='submit' value='"+GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.submitbutton.label","Submit")+"' onclick='validateRsvpProfiles();' /></form>";
String promotionsection=getpromotionsection(eventid,profilePageLabels);
String promotionsectionheader=GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.promotions.title.label","Promotions");

/* String template=DbUtil.getVal("select content from custom_reg_flow_templates where eventid=CAST(? AS BIGINT) and  purpose=?",new String[]{eventid,"rsvp_page"});

if(template == null){
	template=DbUtil.getVal("select content from default_reg_flow_templates where lang=? and  purpose=?",new String[]{lang,"rsvp_page"});
} */
String template=null;
try{
	HashMap<String, String> hm= new HashMap<String,String>();
	hm.put("purpose", "rsvp_page");
	ConfirmationPageDAO pageDao=new ConfirmationPageDAO();
	//String lang=DBHelper.getLanguageFromDB(eventid);
	template=(String)pageDao.getData(hm, lang, eventid).get("content");
	
}catch(Exception e){
	System.out.println("Exception in getVelocityTemplate"+e.getMessage());
}
String registrantdetails="";
ArrayList chk=null;
chk=getQuestionsFortheTransactionlevel(eventid);

int chk1 =chk.size();
if(chk1 != 0){
	if("104549894".equals(eventid))//Eventbee Kindle Fire Promotion eventid
		registrantdetails="Your events & shipping information";
	else
		registrantdetails=getPropValue("rsvp.other.info",eventid);
}
if(Integer.parseInt(sure) ==0 && Integer.parseInt(notsure) ==0)
registrantdetails="";
if("no".equals(selectedOption)){
//registrantdetails=GenUtil.getHMvalue(profilePageLabels,"event.reg.response.notattending.label","Not Attending")+" Profile";
//registrantdetails="Profile";
registrantdetails=GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.registrantinfo.label","Not Attending Profile");
}

context.put("sureProfileLabel",GenUtil.getHMvalue(profilePageLabels,"event.reg.sure.profile.label","Profile"));
context.put("notSureProfileLabel",GenUtil.getHMvalue(profilePageLabels,"event.reg.notsure.profile.label","Profile"));
context.put("SureProfile",sureattribMap);
context.put("NotSureProfile",notsureattribMap);
context.put("profileObject",attribMap);
context.put("rsvpprofileForm",rsvpprofileForm);
context.put("rsvpprofileFormclose",rsvpprofileFormclose);
context.put("sure",sure);
context.put("notsure",notsure);
context.put("profileInfo",registrantdetails);
context.put("promotionSection",promotionsection);
context.put("promotionSectionLabel",promotionsectionheader);
context.put("notSureAttendLabel",GenUtil.getHMvalue(profilePageLabels,"event.reg.response.notsuretoattend.label","Not Sure"));
context.put("attendingLabel",GenUtil.getHMvalue(profilePageLabels,"event.reg.response.attending.label","Attending"));
String option="false";
if("no".equals(selectedOption))
option = "true";
context.put("option",option);
String more = request.getParameter("more");
context.put("more",more);
VelocityEngine ve= new VelocityEngine(); 
try{
ve.init();
boolean abletopares=ve.evaluate(context,out,"ebeetemplate", template);
}
catch(Exception exp){
out.println("---"+exp.getMessage());
}  

%>