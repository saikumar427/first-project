<%@ page import="com.eventbee.event.*"%>
<%@ page import="com.eventbee.authentication.*"%>
<%@ page import="com.eventbee.survey.*"%>
<%@ page import="com.eventbee.general.formatting.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="java.util.*"%>

<%@ include file='/xfhelpers/xffunc.jsp' %>
<%!
static String[] numbers=new String[]{ " One"," Two"," Three"," Four"," Five"," Six", " Seven", " Eight"," Nine"," Ten"," Eleven"," Tweleve"," Thirteen"," Fourteen" };
String query="select profileoption,required from attendee_profile_options where eventid=?";
    void getProfileOptions(HashMap hm,String eventid){
	String [] options=new String [0];
     		DBManager dbmanager=new DBManager();
		StatusObj statobj=dbmanager.executeSelectQuery(query,new String []{eventid});
		if(statobj.getStatus()){
			options=new String [statobj.getCount()];
			for(int i=0;i<statobj.getCount();i++){
				options[i]=dbmanager.getValue(i,"profileoption","");
				hm.put(dbmanager.getValue(i,"profileoption",""),dbmanager.getValue(i,"required",""));
			}
			//hm.put("profileoptions",options);

		}
	}
	
String getSurveyDisplay(SurveyAttendee surveyatt,boolean header,boolean block){
        SurveyInfo sinfo=(SurveyInfo)surveyatt.getSurveyObject();
        String surveyname=sinfo.getSurveyName();
        String description=sinfo.getSurveyDesc();
	Vector v=(Vector)surveyatt.getQuestionObject();
	StringBuffer sb=new StringBuffer("");
	if(sinfo!=null){
                if (block) 
                    sb.append("<table class='block'>");
                else
		    sb.append("<table class='repeat'>");
                sb.append(""); 
                if (header){
   		sb.append("<tr><td class='subheader' colspan='2'>"+ GenUtil.getEncodedXML(surveyname) +"</td></tr>");
              	sb.append("<tr><td class='inform' colspan='2'>"+GenUtil.textToHtml(description,true)+"</td></tr>");
               }
		String surveybaseref=surveyatt.getRefName();
		String[][] surveyres=surveyatt.getSurveyResponse();
		
		if(surveyres==null)surveyres=new String[v.size()][0];
		
		for(int surveyi=0;surveyi<v.size();surveyi++){
		       
                   	String[] quesres=surveyres[surveyi];
			SurveyQuestion sinfotemp1=(SurveyQuestion)v.elementAt(surveyi);
			String ques=sinfotemp1.getQuestion();
			String qtype=sinfotemp1.getQuestionType();
			String mandatory=sinfotemp1.getMandatoryType();
			String length=sinfotemp1.getTextBoxSize();
			ques+=("yes".equalsIgnoreCase(mandatory))?" *":"";
 			int j=surveyi+1;
			
			
			
                	sb.append("<tr>");
			sb.append("<td class='inputlabel' width='45%' height='30'>"+GenUtil.getEncodedXML(ques)+"</td><td width='50%'>");
			String ref1="/"+surveybaseref+"/surveyResponse["+j+"]";
			String[] options= sinfotemp1.getOptions();
			String temp="";
			
			if(qtype.equals("textbox")){
        		      sb.append(getXfTextBox(ref1,(quesres.length==1)?quesres[0]:"", ""+length));
			}else if(qtype.equals("multi")){
				String rows=sinfotemp1.getRows();
				String cols=sinfotemp1.getCols();
				sb.append(getXfTextArea(ref1, (quesres.length==1)?quesres[0]:"", rows, cols));  
			}else if(qtype.equals("opt")){
				sb.append(getXfSelectOneRadio(ref1, options, options,(quesres.length==1)?quesres[0]:"" ));
			}else if(qtype.equals("checkbox")){
				sb.append(getXfSelectMany(ref1, options, options,quesres));
			}else if(qtype.equals("dropdown")){
				sb.append(getXfSelectOneCombo(ref1, options, options,(quesres.length==1)?quesres[0]:""));
			}
			else if(qtype.equals("select")){
							sb.append(getXfSelectOneCombo(ref1, options, options,(quesres.length==1)?quesres[0]:""));
						}
			
			
			sb.append("</td></tr>");
		}//end for
		sb.append("</table>");
	}//end if sno null
	return sb.toString();
    }

String getCustomAttribDisplay(SurveyAttendee surveyatt){
        //SurveyInfo sinfo=(SurveyInfo)surveyatt.getSurveyObject();
        Vector v=(Vector)surveyatt.getQuestionObject();
	StringBuffer sb=new StringBuffer("");
	
	
	if(v!=null){
                
                sb.append(""); 
                String surveybaseref=surveyatt.getRefName();
		String[][] surveyres=surveyatt.getSurveyResponse();
		
		if(surveyres==null){
		surveyres=new String[v.size()][0];
		}
		else{
		
		}
		
		for(int surveyi=0;surveyi<v.size();surveyi++){
		try{
		String[] quesres=surveyres[surveyi];
			
		SurveyQuestion sinfotemp1=(SurveyQuestion)v.elementAt(surveyi);
			String ques=sinfotemp1.getQuestion();
			String qtype=sinfotemp1.getQuestionType();
			String mandatory=sinfotemp1.getMandatoryType();
			String length=sinfotemp1.getTextBoxSize();
			ques+=("yes".equalsIgnoreCase(mandatory))?" *":"";
 			int j=surveyi+1;
			sb.append("<tr>");
			sb.append("<td class='inputlabel' width='45%' height='30'>"+GenUtil.getEncodedXML(ques)+"</td><td width='50%' class='inputvalue'>");
			String ref1="/"+surveybaseref+"/surveyResponse["+j+"]";
			String[] options= sinfotemp1.getOptions();
			String temp="";
			String s="";
			if(quesres!=null&&quesres.length>0&&quesres[0]!=null)
			s=quesres[0].replaceAll("'","&apos;");
						
			
			if(qtype.equals("textbox")){
        		      sb.append(getXfTextBox(ref1,(quesres.length==1)?s:"", ""+length));
			}else if(qtype.equals("multi")){
				String rows=sinfotemp1.getRows();
				String cols=sinfotemp1.getCols();
				sb.append(getXfTextArea(ref1, (quesres.length==1)?quesres[0]:"", rows, cols));  
			}else if(qtype.equals("opt")){
				sb.append(getXfSelectOneRadio(ref1, options, options,(quesres.length==1)?quesres[0]:"" ));
			}else if(qtype.equals("checkbox")){
				sb.append(getXfSelectMany(ref1, options, options,quesres));
			}else if(qtype.equals("dropdown")){
				sb.append(getXfSelectOneCombo(ref1, options, options,(quesres.length==1)?quesres[0]:""));
			}
			else if(qtype.equals("select")){
				sb.append(getXfSelectOneCombo(ref1, options, options,(quesres.length==1)?quesres[0]:""));
			}
			sb.append("</td></tr>");
		}
		
		catch(Exception e){
		System.out.println("Exception occred is"+surveyi);
		}
		
		}//end for
		
	}//end if sno null
	return sb.toString();
    }
 
 
String ShowAttendeProfile(int i,EventRegisterBean jBean,HashMap hm){
	 HashMap scopemap=jBean.getScopeMap();
	 StringBuffer sb=new StringBuffer();
	 sb.append("<tr><td width='45%' height='30' class='inputlabel'>First Name *</td><td width='50%' height='30' class='inputvalue'>");
	 sb.append(getXfTextBox("/profileData["+(i+1)+"]/firstName",GenUtil.getEncodedXML((jBean.getProfileData())[i].getFirstName()),"20"));
	 sb.append("</td></tr>");
	 sb.append("<tr><td height='30' class='inputlabel'>Last Name *</td><td height='30' class='inputvalue'>");
	 sb.append(getXfTextBox("/profileData["+(i+1)+"]/lastName",GenUtil.getEncodedXML((jBean.getProfileData())[i].getLastName()),"20"));
	 sb.append("</td></tr>");
	 sb.append("<tr><td height='30' class='inputlabel'>Email *</td><td height='30' class='inputvalue'>");
	 sb.append(getXfTextBox("/profileData["+(i+1)+"]/email",GenUtil.getEncodedXML((jBean.getProfileData())[i].getEmail()),"20"));
	 sb.append("</td></tr>");
	 sb.append("<tr><td height='30' class='inputlabel'>Phone *</td><td height='30' class='inputvalue'>");
	 sb.append(getXfTextBox("/profileData["+(i+1)+"]/phone",GenUtil.getEncodedXML((jBean.getProfileData())[i].getPhone()),"20"));
	 sb.append("</td></tr>");
	 return sb.toString(); 
}

%>





<form name='attendeeinfo' id="attendeeinfo" onSubmit="return checkform(this);" method="post"  view="personalInfo" action="/portal/eventregister/reg/validateProfile.jsp"> 
<table width='100%' >


<%


	
    EventRegisterBean jBean = (EventRegisterBean)session.getAttribute("regEventBean");
    HashMap profilemap=new HashMap();
   getProfileOptions(profilemap,jBean.getEventId());
    
    List lst=new ArrayList();
   Set e =profilemap.entrySet();
	for (Iterator i = e.iterator(); i.hasNext();){
 		Map.Entry entry =(Map.Entry)i.next();
		if((entry.getValue()!=null )||("Required".equals(((String)entry.getValue()).trim())))
		lst.add(entry.getKey());
	}

    ProfileData[] pd=jBean.getProfileData();
     jBean.setRequiredProfileOptions(lst);
    jBean.setContextUnitid("13579"); 
    
    SurveyAttendee[] m_surveys=new SurveyAttendee[pd.length];
    
   
    	
   
          
      try{
      for(int i=0;i<pd.length;i++){
    if(pd.length>1){
    	        
    		 out.print("<tr><td width='15%' height='30'>");
    		 if(i<14)
    		 out.print(getXfOutput(GenUtil.getHMvalue(jBean.getScopeMap(),"event.reg.attendee.label","Attendee")+numbers[i]));
    		 else
    		 out.print(getXfOutput(GenUtil.getHMvalue(jBean.getScopeMap(),"event.reg.attendee.label","Attendee")+(i+1)));
    		 out.print(":</td></tr>");
 	 }
 	 out.print("<tr><td><table>");
 	 out.print(ShowAttendeProfile(i,jBean,profilemap));
	if(session.getAttribute("Custom_"+jBean.getEventId())!=null){
	m_surveys=jBean.getSurveys();
	}else{
	m_surveys[i]=new CustomAttributeSurvey();
	m_surveys[i].setGroupId(jBean.getEventId());
	m_surveys[i].setSurvey(jBean.getEventId(),"EVENT","surveys["+(i+1)+"]");
	}
	
	
	//if(m_surveys[i].getSurveyObject()!=null)
	out.println( getCustomAttribDisplay(m_surveys[i])  );
	out.print("</table>");
	out.print("</td></tr>");
	}//end for
	jBean.setSurveys(m_surveys);
	if((jBean.getSurvey())!=null)
		if((jBean.getSurvey().getSurveyObject())!=null)
			out.println( getSurveyDisplay(jBean.getSurvey(),true,true)  );
		}
		
		
		catch(Exception e1){
		
		}



%>


</table>   
</form>
 
    
     
