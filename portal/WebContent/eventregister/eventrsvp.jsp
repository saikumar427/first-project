<%@ page import="com.eventbee.event.*"%>
<%@ page import="java.util.*" %>
<%@ page import="com.customattributes.*" %>
<%@ page import="com.eventbee.survey.*"%>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.general.*"%>
<%@ page import="com.eventbee.authentication.*,com.eventbee.event.RsvpDB" %>
<%@ include file='/xfhelpers/xffunc.jsp' %>
<script language="javascript" src="/home/js/enterkeypress.js" >
	function dummy(){};
</script>

<%!
String query="select profileoption,required from attendee_profile_options where eventid=?";
    void getProfileOptions(HashMap hm,String eventid,List lst){
	String [] options=new String [0];
     		DBManager dbmanager=new DBManager();
		StatusObj statobj=dbmanager.executeSelectQuery(query,new String []{eventid});
		if(statobj.getStatus()){
			options=new String [statobj.getCount()];
			for(int i=0;i<statobj.getCount();i++){
				options[i]=dbmanager.getValue(i,"profileoption","");
				hm.put(dbmanager.getValue(i,"profileoption",""),dbmanager.getValue(i,"required",""));
				if("Required".equals(dbmanager.getValue(i,"required","")))
				lst.add(dbmanager.getValue(i,"profileoption",""));
			}
		}
	}


String getCustomAttribDisplay(SurveyAttendee surveyatt){
       //System.out.println("surveyatt============="+surveyatt);
        SurveyInfo sinfo=(SurveyInfo)surveyatt.getSurveyObject();
        //System.out.println("sinfo============="+sinfo);
        Vector v=(Vector)surveyatt.getQuestionObject();
        //System.out.println("v============="+v);
	StringBuffer sb=new StringBuffer("");
	if(sinfo!=null){
                
                sb.append(""); 
                String surveybaseref=surveyatt.getRefName();
		String[][] surveyres=surveyatt.getSurveyResponse();
		
		if(surveyres==null)surveyres=new String[v.size()][0];
		Vector vec1=new Vector();
		for(int surveyi=0;surveyi<v.size();surveyi++){
		

			String[] quesres=surveyres[surveyi];
			SurveyQuestion sinfotemp1=(SurveyQuestion)v.elementAt(surveyi);
			String ques=sinfotemp1.getQuestion();
			String qtype=sinfotemp1.getQuestionType();
			String mandatory=sinfotemp1.getMandatoryType();
			HashMap hm1=new HashMap();
			hm1.put("attribnae",ques);
			hm1.put("mandatory",mandatory);
			String length=sinfotemp1.getTextBoxSize();
			ques+=("yes".equalsIgnoreCase(mandatory))?" *":"";
 			int j=surveyi+1;
 			//sb.append("<table >");
			sb.append("<tr>");
			sb.append("<td class='inputlabel' width='45%' height='30'>"+GenUtil.getEncodedXML(ques)+"</td><td width='50%' class='inputvalue'>");
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
			//sb.append("</table>");
			vec1.add(hm1);
			
		}//end for
		
		
		
	
	}//end if sno null
	return sb.toString();
    }





%>


<%!

  String CLASS_NAME="eventrsvp.jsp";

  boolean isRegisteredMember(String eventid,String userid){
        String Query="select attendeekey from eventattendee where eventid=? and authid=?";
        String result=DbUtil.getVal(Query,new String[]{eventid,userid});
	return result!=null;
  }
  boolean isRSVPMember(String eventid,String userid){
        String Query="select attendeekey from rsvpattendee where eventid=? and authid=?";
        String result=DbUtil.getVal(Query,new String[]{eventid,userid});
	return result!=null;
  }
 %>
 <% com.eventbee.campaign.CampaignDB.insertCampaignClickThrough(request.getParameter("eid"),request.getParameter("GROUPID"),"ER");%>
 <%
  request.setAttribute("tasktitle","RSVP ");
  request.setAttribute("tasksubtitle","");
  request.setAttribute("tabtype",request.getParameter("evttype"));
  HashMap urlmap=PageUtil.getPageNameAndUrl(request.getParameter("PS"),request.getParameter("GROUPID"));
	if(urlmap!=null){
	request.setAttribute("NavlinkNames",new String[]{(String)urlmap.get("navlink")});
	request.setAttribute("NavlinkURLs",new String[]{request.getContextPath()+(String)urlmap.get("backurl") });
	}
%>


<table align="center" width="100%" border="0">
<%
Authenticate authData=AuthUtil.getAuthData(pageContext);

//(Authenticate)session.getAttribute(ContextConstants.AUTH_DATA_OBJ);
HashMap grouphm=(HashMap) request.getAttribute("REQMAP");
List lst=new ArrayList();
//String userid=authData.getUserID();
//String eventid=(String) grouphm.get("GROUPID");
String eventid=request.getParameter("GROUPID");
HashMap hm=new HashMap();
getProfileOptions(hm,eventid,lst);
session.setAttribute(request.getParameter("GROUPID")+"_REQUIREDPROFILE_LIST",lst);
//HashMap alreadyAttendee=RsvpDB.getAttendeeInfo(eventid,userid);
HashMap alreadyRsvp=null;
%>
<%

if("yes".equals(request.getParameter("isnew"))){
	session.removeAttribute(request.getParameter("GROUPID")+"_rsvp_errors");
	session.removeAttribute(request.getParameter("GROUPID")+"_rsvp_customerrors");
	session.removeAttribute(request.getParameter("GROUPID")+"_RSVP_EVENT");
}

Object obj=(Object)session.getAttribute(request.getParameter("GROUPID")+"_rsvp_errors");
Object obj1=(Object)session.getAttribute(request.getParameter("GROUPID")+"_rsvp_customerrors");
out.println(GenUtil.displayErrMsgs("<tr><td class='error' align='left' cellpadding='5'>",obj,"</td></tr>" ));
out.println(GenUtil.displayErrMsgs("<tr><td class='error' align='left' cellpadding='5'>",obj1,"</td></tr>" ));
session.removeAttribute(eventid+"_rsvp_customerrors");
//HashMap profileMap=(HashMap)session.getAttribute(request.getParameter("GROUPID")+"_RSVP_EVENT");
//if(profileMap==null)profileMap=new HashMap();
HashMap profileMap=new HashMap();

//if("yes".equals(request.getParameter("iserror")))
profileMap=(HashMap)session.getAttribute(request.getParameter("GROUPID")+"_RSVP_EVENT");



if(profileMap==null)profileMap=new HashMap();
%>
<table  cellspacing="0" cellpadding='5' >
<form method="post" action="/portal/eventregister/insertrsvp.jsp">
<input type="hidden" value='<%=request.getParameter("GROUPID")%>' name='GROUPID'/>
<input type="hidden" value='<%=request.getParameter("GROUPTYPE")%>' name='evttype'/>
<tr>
 <td width="30%" class="inputlabel">Attending</td>
 <td class="inputvalue">
 <table>
 <tr><td><input type="radio" name="attending" value="yes" <%=("yes".equals(GenUtil.getHMvalue(profileMap,"attending","yes")))?"checked='cheked'":""%> />Yes</td>
<td><input type="radio" name="attending" value="notsure" <%=("notsure".equals(GenUtil.getHMvalue(profileMap,"attending","yes")))?"checked='cheked'":""%> />Not Sure</td>
<td><input type="radio" name="attending" value="no" <%=("no".equals(GenUtil.getHMvalue(profileMap,"attending","yes")))?"checked='cheked'":""%> />No</td>
</tr></table></td>
</tr>



<tr>
 <td width="30%" class="inputlabel">First Name *</td>
 <td class="inputvalue"><input type="text" name="fname" value="<%=GenUtil.getHMvalue(profileMap,"fname","",true)%>"/></td>
</tr>
<tr>
 <td width="30%" class="inputlabel">Last Name *</td>
 <td class="inputvalue"><input type="text" name="lname" value="<%=GenUtil.getHMvalue(profileMap,"lname","",true)%>"/></td>
</tr>
<tr>
 <td width="30%" class="inputlabel">Email ID *</td>
 <td class="inputvalue"><input type="text" name="emailid" value="<%=GenUtil.getHMvalue(profileMap,"emailid","",true)%>"/></td>
</tr>

<%if(hm.get("Attendee Count")!=null){%>
<tr>
 <td width="30%" class="inputlabel">Attendee Count <%=("Required".equals((String)hm.get("Attendee Count")))?"*":""%></td>
 <td class="inputvalue"><input type="text" name="count" value="<%=GenUtil.getHMvalue(profileMap,"count","",true)%>"/></td>
</tr>
<%}else{%>
<input type="hidden" name="count" value="1"/>
<%}%>
<%if(hm.get("Phone")!=null){%>
<tr>
 <td width="30%" class="inputlabel">Phone <%=(("Required".equals((String)hm.get("Phone")))?"*":"")%></td>
 <td class="inputvalue"><input type="text" name="phone" value="<%=GenUtil.getHMvalue(profileMap,"phone","",true)%>"/></td>
</tr>
<%}%>
<%if(hm.get("Organization")!=null){%>
<tr>
 <td width="30%" class="inputlabel">Organization <%=(("Required".equals((String)hm.get("Organization")))?"*":"")%></td>
 <td class="inputvalue"><input type="text" name="company" value="<%=GenUtil.getHMvalue(profileMap,"company","",true)%>"/></td>
</tr>
<%}%>
<%if(hm.get("Address")!=null){%>
<tr>
 <td width="30%" class="inputlabel">Address <%=(("Required".equals((String)hm.get("Address")))?"*":"")%></td>
 <td>
 <table><tr>
 <td class="inputvalue"><input type="text" name="address" value="<%=GenUtil.getHMvalue(profileMap,"address","",true)%>"/></td>
</tr>
<tr>
 <td class="inputvalue"><input type="text" name="address1" value="<%=GenUtil.getHMvalue(profileMap,"address1","",true)%>"/></td>
</tr>
</table></td></tr>
<%}%>
<%if(hm.get("Comment/Introduction")!=null){%>
<tr>
 <td width="30%" class="inputlabel">Comment/Introduction <%=(("Required".equals((String)hm.get("Comment/Introduction")))?"*":"")%></td>
 <td class="inputvalue"><textarea name="comment" rows="5" cols="40" onfocus="this.value=(this.value==' ')?'':this.value"><%=GenUtil.getHMvalue(profileMap,"comment","",true)%></textarea></td>
</tr>
<%}%>

 
 	<%=PageUtil.writeHiddenCore(grouphm)%>
 	
 	
 	<%
 	
 	CustomAttributes[] attribs=CustomAttributesDB.getCustomAttributes(eventid,"EVENT");
 	
 	
 	
 	Vector vec=CustomAttributesDB.getSurveyQuestions(attribs);
	SurveyAttendee  m_surveys=new SurveyAttendee();
	SurveyAttendee  m_surveysold=(SurveyAttendee)session.getAttribute("Custom");
	
        if(m_surveysold!=null){
        //System.out.println("m_surveysold--oldddddddd---"+m_surveysold);
        m_surveys=(SurveyAttendee)session.getAttribute("Custom");
	}
	if(session.getAttribute("Custom")!=null){
		session.removeAttribute("Custom");
	}
	else{
	
	m_surveys=new CustomAttributeSurvey();
	m_surveys.setGroupId(eventid);
	m_surveys.setSurvey(eventid,"EVENT","surveys");
        }
        
       // System.out.println("m_surveys-----"+m_surveys);
	out.println(getCustomAttribDisplay(m_surveys));
        
%>
 	<tr><td></td><td class="inputvalue">
 		<input type="submit" name="submit" value="Submit"/>
 		<input type="button" name="Back" value="Cancel" onclick="javascript:history.back();"/>

 	
 	</td></tr>

    <tr height="150"><td></td></tr>
</form>
<%
//}
%>
</table>
