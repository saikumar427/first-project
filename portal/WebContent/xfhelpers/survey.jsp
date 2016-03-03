
<%@ page import="com.eventbee.authentication.*"%>
<%@ page import="com.eventbee.survey.*"%>
<%@ page import="com.eventbee.general.formatting.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="java.util.*"%>

<%@ include file='xffunc.jsp'%>
<%!

	String getSurveyDisplay(SurveyAttendee surveyatt){
                  return  getSurveyDisplay(surveyatt,false,false);
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
		    sb.append("<xf:table class='repeat'>");
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




%>


<%
	if( request.getAttribute("xfsurveyobj")!=null ){
		%>
		<table><tr><td><table><tr><td>
		<%
		out.println( getSurveyDisplay((SurveyAttendee)request.getAttribute("xfsurveyobj"),true,true)  );
		%>
		</table></td></tr></table>
		<%
	}
%>
