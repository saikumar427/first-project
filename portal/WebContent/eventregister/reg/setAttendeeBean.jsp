<%@ page import="com.eventbee.event.*"%>
<%@ page import="com.eventbee.authentication.*"%>
<%@ page import="com.eventbee.survey.*"%>
<%@ page import="com.eventbee.general.formatting.*"%>
<%@ page import="com.eventbee.general.*,com.eventbee.eventsponsors.*"%>
<%@ page import="java.util.*"%>
<%
EventRegisterBean jBean= (EventRegisterBean)session.getAttribute("regEventBean");


if(jBean!=null){
	session.setAttribute("regerrors",null);
	
		ProfileData[] pd=jBean.getProfileData();
		
		
		SurveyAttendee[] surveys=jBean.getSurveys();
		String [] surveyresponses[]=null;
		for(int i=0;i<pd.length;i++){
			int j=i+1;
			pd[i].setFirstName(request.getParameter("/profileData["+j+"]/firstName"));
			pd[i].setLastName(request.getParameter("/profileData["+j+"]/lastName"));
			pd[i].setEmail(request.getParameter("/profileData["+j+"]/email"));
			pd[i].setPhone(request.getParameter("/profileData["+j+"]/phone"));
			pd[i].setStreet1(request.getParameter("/profileData["+j+"]/street1"));
			pd[i].setStreet2(request.getParameter("/profileData["+j+"]/street2"));
			pd[i].setCompany(request.getParameter("/profileData["+j+"]/company"));
			pd[i].setComments(request.getParameter("/profileData["+j+"]/comments"));
			
			if(surveys!=null&&surveys.length>0){
				surveyresponses=jBean.getSurveys()[i].getSurveyResponse();
				Vector quesv=(Vector)jBean.getSurveys()[i].getQuestionObject();
				if(quesv!=null){
				for(int a=0;a<surveyresponses.length;a++){
					int b=a+1;
					
					if("checkbox".equals(((SurveyQuestion)quesv.get(a)).getQuestionType()))
					surveyresponses[a]=request.getParameterValues("/surveys["+j+"]/surveyResponse["+b+"]");
					else
					surveyresponses[a]=new String [] {request.getParameter("/surveys["+j+"]/surveyResponse["+b+"]")};
				}
				}
				jBean.getSurveys()[i].setSurveyResponse(surveyresponses);
				
			}
			
			

		}
		session.setAttribute("Custom_"+jBean.getEventId(),"Exists");
		jBean.setProfileData(pd);
	
}
%>
