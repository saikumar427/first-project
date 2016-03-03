<%@ page import="java.util.*" %>
<%@ page import="com.customattributes.*" %>
<%@ page import="com.eventbee.survey.*"%>
<%@ page import="com.eventbee.general.*,java.sql.*,com.eventbee.general.* " %>
<%@ page import="com.eventbee.event.RsvpDB,com.eventbee.event.ticketinfo.*" %>

<%@ include file="rsvpemail.jsp" %>
<%@ page import="org.apache.velocity.*,org.apache.velocity.app.Velocity,org.apache.velocity.context.*,org.apache.velocity.exception.*,org.apache.velocity.app.*" %>

<%!

static String INSERT_RSVP = "insert into rsvpattendee(authid,attendeekey,sourceunitid,"
		 + "eventid,statement,priattendee,shareprofile,comments,company,address,address1,firstname,lastname,email,phone,attendeecount,attendingevent,attendeeid) "
		 + " values(?,?,?,?,?,'Y','Yes',?,?,?,?,?,?,?,?,?,?,?)";
static String UPDATE_RSVP_COUNT="update event_config set rsvp_count=rsvp_count+? where eventid=?";
static String DELETE_RSVP_COUNT="delete from rsvpattendee where eventid=? and authid=?";

	
	public  boolean insertRSVP(HashMap profileMap){
	
	String  []params= new String[]{(String)GenUtil.getHMvalue(profileMap,"userid","0",true),
	                       (String)GenUtil.getHMvalue(profileMap,"userid","0"),
	                      (String)GenUtil.getHMvalue(profileMap,"UNITID","0"),
	                      (String)GenUtil.getHMvalue(profileMap,"GROUPID","0"),
	                      (String)GenUtil.getHMvalue(profileMap,"statement"),
	                      (String)GenUtil.getHMvalue(profileMap,"comment"),
	                      (String)GenUtil.getHMvalue(profileMap,"company"),
	                      (String)GenUtil.getHMvalue(profileMap,"address"),
	                      (String)GenUtil.getHMvalue(profileMap,"address1"),
	                      (String)GenUtil.getHMvalue(profileMap,"fname"),
	                      (String)GenUtil.getHMvalue(profileMap,"lname"),
	                      (String)GenUtil.getHMvalue(profileMap,"emailid"),
	                      (String)GenUtil.getHMvalue(profileMap,"phone"),
	                      (String)GenUtil.getHMvalue(profileMap,"count","1"),
	                      (String)GenUtil.getHMvalue(profileMap,"attending","yes"),
	                      (String)GenUtil.getHMvalue(profileMap,"attendeeid","0")
	                      };
	
	
	boolean rt=false;
	StatusObj sob=DbUtil.executeUpdateQuery(DELETE_RSVP_COUNT,new String[]{(String) profileMap.get("GROUPID"),(String) profileMap.get("userid")});
			
	StatusObj sob1=DbUtil.executeUpdateQuery(INSERT_RSVP,params);
	if(sob1.getStatus()){
	    rt=true;
	     if(sob.getCount()<=0){
	    String  []param={(String)GenUtil.getHMvalue(profileMap,"count","1"),(String) profileMap.get("GROUPID")};
	        
	 StatusObj sob2=DbUtil.executeUpdateQuery(UPDATE_RSVP_COUNT,param);
	}
	
	
	if("yes".equals((String)GenUtil.getHMvalue(profileMap,"attending",""))){
	int r=sendRsvpEmail(profileMap);
	
	}
	}
	
	return rt;
	}
	

	
%>
<%     final  String attendeeid=DbUtil.getVal("select nextval('SEQ_attendeeid')",new String[]{});
	String message=null;
	String statusnum="";
	HashMap hm=new HashMap();
	String eventid=request.getParameter("GROUPID");
	com.eventbee.util.RequestSaver rsv=new com.eventbee.util.RequestSaver(pageContext,eventid+"_RSVP_EVENT","session",true);
	HashMap hmap=(HashMap)session.getAttribute(eventid+"_RSVP_EVENT");
	  hmap.put("attendeeid",attendeeid);
	List optionlst=(List)session.getAttribute(eventid+"_REQUIREDPROFILE_LIST");
	boolean flag=true;
	StatusObj status=null;
	status=EventBeeValidations.isValidStr((String)hmap.get("fname"),"First Name",1000,1);
	if (!(status.getStatus())){
				 hm.put("First Name",status.getErrorMsg());
                   		  flag=false;
			}
	status=EventBeeValidations.isValidStr((String)hmap.get("lname"),"Last Name",1000,1);
	if (!(status.getStatus())){
				 hm.put("Last Name",status.getErrorMsg());
                   		  flag=false;
			}
	status=EventBeeValidations.isValidEmail((String)hmap.get("emailid"),"Email ID");
	if (!(status.getStatus())){
				 hm.put("Email ID",status.getErrorMsg());
                   		  flag=false;
			}
	String attendeecount=(String)hmap.get("count");
	if(optionlst!=null){
		if((!optionlst.contains("Attendee Count"))&&(attendeecount==null||"".equals(attendeecount))) attendeecount="1";
	}
	status=EventBeeValidations.isValidNumber(attendeecount,"Attendee Count","Integer");
			if (!(status.getStatus())){
				 hm.put("Attendee Count",status.getErrorMsg());
                   		  flag=false;
			}
if(optionlst!=null){
	 	if(optionlst.contains("Phone")){
			 if(!EventBeeValidations.checkPhoneValidity(GenUtil.getHMvalue(hmap,"Phone",""))){
				hm.put("Phone ","Phone number  for Profile need to be 10 digits");
			}
		}
		if(optionlst.contains("Address")){
			status=EventBeeValidations.isValidStr((String)hmap.get("address")+(String)hmap.get("address1"),"Address",1000,1);
			if (!(status.getStatus())){
				 hm.put("address",status.getErrorMsg());
                   		  flag=false;
			}
		}
/*		if(optionlst.contains("Attendee Count")){
			status=EventBeeValidations.isValidNumber((String)hmap.get("count"),"Attendee Count","Integer",0);
			if (!(status.getStatus())){
				 hm.put("Attendee Count",status.getErrorMsg());
                   		  flag=false;
			}
		}*/
		if(optionlst.contains("Organization")){
			status=EventBeeValidations.isValidStr((String)hmap.get("company"),"Organization",1000,1);
			if (!(status.getStatus())){
				 hm.put("Organization",status.getErrorMsg());
                   		  flag=false;
			}
		}
		if(optionlst.contains("Comment/Introduction")){
			status=EventBeeValidations.isValidStr((String)hmap.get("comment"),"Comment/Introduction",1000,1);
			if (!(status.getStatus())){
				 hm.put("Comment",status.getErrorMsg());
                   		  flag=false;
			}
		}
	}
		String custom_setid=null;
		custom_setid=CustomAttributesDB.getAttribSetID(eventid,"EVENT");
		if(custom_setid!=null){
		SurveyAttendee  surveys=new SurveyAttendee();
		       	surveys=new CustomAttributeSurvey();
			surveys.setGroupId(eventid);
			surveys.setSurvey(eventid,"EVENT","surveys");
	                 
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
		}}
		}
		surveys.setSurveyResponse(surveyresponses);
                session.setAttribute("Custom",surveys);

		HashMap hm1=new HashMap();
		surveys.validateSurvey(hm1);
		if(hm1.size()>0){
		flag=false;
		session.setAttribute(eventid+"_rsvp_customerrors",hm1);
		}
		else
		{
		
		CustomAttributesDB.setResponseToDB( quesv, surveyresponses,attendeeid,setid,resid);
		}
		}
		}
		if(!flag){
		      
			session.setAttribute(eventid+"_rsvp_errors",hm);
			response.sendRedirect("/portal/guesttasks/eventrsvp.jsp?iserror=yes&GROUPID="+request.getParameter("GROUPID"));

		}else{
			
			boolean rt=insertRSVP(hmap);
		     
			if(rt){
				String MEMBER_SEQ_ID="select nextval('seq_maillist') as memberid" ;
				String memberid=DbUtil.getVal(MEMBER_SEQ_ID,new String[]{});
				String listid=DbUtil.getVal("select value from config where name='event.maillist.id' and config_id=(select config_id from eventinfo where eventid=?)", new String []{request.getParameter("GROUPID")});
				
				
				/*String INSERT_MEMBER="insert into member_profile(manager_id,member_id,m_firstname,m_lastname,m_email,m_phone,m_company  ,m_jobtype  ,m_place"
									  +"  ,m_age  ,m_gender  ,m_email_type) 	values (?,?,?,?,?,?,?,?,?,?,?,?)";*/
				 String INSERT_MEMBER="insert into member_profile(member_id,m_lastname,created_at,m_email,m_firstname,manager_id,m_email_type) values(?,?,now(),?,?,?,?)"	;				  
			     StatusObj status1=DbUtil.executeUpdateQuery(INSERT_MEMBER,new String [] {memberid,(String)hmap.get("lname"),(String)hmap.get("emailid"),(String)hmap.get("fname"),"0","html"});
			     
			     String INSERT_LIST_MEMBER="insert into mail_list_members(member_id,list_id,status,created_at,created_by) values(?,?,'available',now(),'Auto Subscription')";
			     StatusObj status2=DbUtil.executeUpdateQuery(INSERT_LIST_MEMBER,new String [] {memberid,listid});
			     
			}
		
			session.setAttribute(eventid+"_rsvp_errors",null);
			if(rt){  
			       if("yes".equals(hmap.get("attending")))
			       statusnum="1";
			       else if("no".equals(hmap.get("attending")))
			       statusnum="2";
			       else
			       statusnum="3";
				//message=EbeeConstantsF.get("taskpage.rsvp.done","You are added to RSVP Attendee list.");
				
				
				}
			else{
			statusnum="-1";	
			message=EbeeConstantsF.get("taskpage.rsvp.error","Your request cannot process at this time");
			}
			hm=null;
			response.sendRedirect("/portal/guesttasks/donersvp.jsp?status="+statusnum+"&GROUPID="+request.getParameter("GROUPID"));
		}
%>

