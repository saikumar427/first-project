<%@ page import="java.io.*,java.util.*,com.eventbee.general.*,com.eventregister.*,com.customquestions.*,com.customquestions.beans.*" %>
<%@ page import="org.apache.velocity .*,org.apache.velocity.app.Velocity,org.apache.velocity.context.*,org.apache.velocity.exception.*,org.apache.velocity.app.*" %>
<%@ page import="org.json.*,com.event.dbhelpers.*"%>
<%@ page language="java" contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.eventbee.layout.DBHelper" %>

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

ArrayList getQuestionsFortheTransactionlevel(String eventid){
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

String rsvp_event_date=request.getParameter("rsvp_event_date");
String selectedOption=request.getParameter("option");
String eventid=request.getParameter("eventid");
String sure=request.getParameter("sure");
String notsure=request.getParameter("notsure");
String arribsetid=null;
CustomAttribsDB ticketcustomattribs=new CustomAttribsDB();
ArrayList ticketspecificAttributeIds=null;
HashMap attribMap=new HashMap();
String lang=DBHelper.getLanguageFromDB(eventid);
if(lang==null || "".equals(lang)) lang="en_US";
HashMap profilePageLabels=DisplayAttribsDB.getDisplayAttribs(eventid,"RSVPFlowWordings",lang);
try{
Vector questions=new Vector();
CustomAttribSet customattribs=(CustomAttribSet)ticketcustomattribs.getCustomAttribSet(eventid,"EVENT" );
CustomAttribute[]  attributeSet=customattribs.getAttributes();
arribsetid=customattribs.getAttribSetid();
Vector p=getAttendeeObject();
questions.addAll(p);
//for(int i=1;i<=Integer.parseInt(sure);i++){
	//System.out.println("inside for loop of sure value of i:"+i);
if(attributeSet!=null&&attributeSet.length>0){
	ticketspecificAttributeIds=getQuestionsFortheSelectedOption(selectedOption,eventid);
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
 // }
attribMap.put("customProfile",questions);


}
catch(Exception e){
System.out.println("getprofiles----"+e.getMessage());
}


String rsvpprofileForm="<form name='rsvpprofile', id='rsvpprofile' action='/rsvpregister/rsvprecprofilesubmit.jsp' mathod='post' ><input type='hidden' name='attribsetid' value='"+arribsetid+"' /><input type='hidden' name='eventid' value='"+eventid+"' /><input type='hidden' name='selectedoption' value='"+selectedOption+"' /><input type='hidden' name='rsvp_event_date' value='"+rsvp_event_date+"' />";
String rsvpprofileFormclose="<input type='button' name='submit' value='"+GenUtil.getHMvalue(profilePageLabels,"event.reg.continue.label","Continue")+"' onclick='validateRsvpProfiles();' /></form>";
//String template=DbUtil.getVal("select content from reg_flow_templates where purpose=?",new String[]{"rsvpPage"});
//String lang=DBHelper.getLanguageFromDB(eventid);
String template=DbUtil.getVal("select content from default_reg_flow_templates where purpose=? and lang=?",new String[]{"rsvpPage",lang});
VelocityContext context = new VelocityContext();
context.put("profileObject",attribMap);
context.put("rsvpprofileForm",rsvpprofileForm);
context.put("rsvpprofileFormclose",rsvpprofileFormclose);
VelocityEngine ve= new VelocityEngine(); 
try{
ve.init();
boolean abletopares=ve.evaluate(context,out,"ebeetemplate", template);
}
catch(Exception exp){
out.println("---"+exp.getMessage());
}  

%>