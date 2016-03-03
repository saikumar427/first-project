<%@ page import="com.eventbee.general.*,java.util.*" %>
<%@ page import="com.customattributes.*" %>
<%@ page import="com.eventbee.survey.*"%>

<%!
String updateattendeequery="update  eventattendee set firstname=?,lastname=?,email=?,phone=?,company=?,city=?,state=?,country=?,zip=? where transactionid=? and eventid=? and attendeekey=?";
String DELETE_RESPONSE=" delete from custom_attrib_response where responseid  in (select responseid from custom_attrib_response_master where userid=?) ";
String DELETE_RESPONSE_MASTER=" delete from custom_attrib_response_master where responseid !=? and userid=?";
public  void deleteResponseFromDB(String responseid,String userid){
			DBQueryObj [] queries=new DBQueryObj [2];
			queries[0]=new DBQueryObj(DELETE_RESPONSE,new String [] {userid});
			queries[1]=new DBQueryObj(DELETE_RESPONSE_MASTER,new String [] {responseid,userid});
			StatusObj statobj=DbUtil.executeUpdateQueries(queries);
	}
%>
<%
String eid=request.getParameter("eid");
String transactionid=request.getParameter("transactionid");
String attendeekey=request.getParameter("attendeekey");
String firstname=request.getParameter("firstname");
String lastname=request.getParameter("lastname");
String email=request.getParameter("email");
String phone=request.getParameter("phone");
if(phone==null) phone="";
String company=request.getParameter("company");
if(company==null) company="";
String city=request.getParameter("city");
if(city==null) city="";
String state=request.getParameter("state");
if(state==null) state="";
String country=request.getParameter("country");
if(country==null) country="";
String zip=request.getParameter("zip");
if(zip==null) zip="";

StatusObj statobj=DbUtil.executeUpdateQuery(updateattendeequery, new String[]{firstname,lastname,email,phone,company,city,state,country,zip,transactionid,eid,attendeekey} );
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.ERROR,"updateattendeedetails.jsp---","updating attendeedetails====="+statobj.getStatus(),"",null);

%>
<%
String custom_setid=CustomAttributesDB.getAttribSetID(eid,"EVENT");			
	if(custom_setid!=null){
	SurveyAttendee  surveys=new SurveyAttendee();
	surveys=new CustomAttributeSurvey();
	surveys.setGroupId(eid);
	surveys.setSurvey(eid,"EVENT","surveys");
	String [] surveyresponses[]=null;
	if(surveys!=null){
	String answer=null;
	surveyresponses=surveys.getSurveyResponse();
	Vector quesv=(Vector)surveys.getQuestionObject();
	String setid=surveys.getSurveyId();
	String resid=CustomAttributesDB.getResponseId();
	if(quesv!=null&&quesv.size()>0){
	for(int a=0;a<surveyresponses.length;a++){
		int b=a+1;
		if("checkbox".equals(((SurveyQuestion)quesv.get(a)).getQuestionType()))
		surveyresponses[a]=request.getParameterValues("/surveys/surveyResponse["+b+"]");
		else{
		answer=request.getParameter("/surveys/surveyResponse["+b+"]");
		if(answer==null)
		answer="";
		surveyresponses[a]=new String [] {answer};
	} //end else
	} //end for
	} //end if(quesv!=null&&quesv.size()>0)
	surveys.setSurveyResponse(surveyresponses);
	HashMap hm1=new HashMap();
	surveys.validateSurvey(hm1);
	if(hm1.size()>0){

		Set keyset = hm1.keySet();
		Iterator iter = keyset.iterator();
		while(iter.hasNext()){
			String key = iter.next().toString();
			String value = hm1.get(key).toString();
%><data><%=value%></data>
<%
			return;
		} //end while()
	} //end if()
	else
	{
	deleteResponseFromDB(resid,attendeekey);
	CustomAttributesDB.setResponseToDB( quesv, surveyresponses,attendeekey,setid,resid);
	} //end else
	} //end if(surveys!=null)
	} //end if(custom_setid!=null)
%>
<data>Success</data>