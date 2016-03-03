<%@ page import="com.eventbee.event.*"%>
<%@ page import="com.eventbee.authentication.*"%>
<%@ page import="com.eventbee.survey.*"%>
<%@ page import="com.eventbee.general.formatting.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="java.util.*"%>

<%@ include file='/xfhelpers/xffunc.jsp' %>
<%!
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
%>

<%!
     static String[] states=new String[]{ "CA","AA","AE","AK","AL","AP","AR","AZ","CO","CT","DC","DE","FL","FM","GA","GU","CO","IA","ID","IL","IN","KS","KY" };
     static String[] numbers=new String[]{ " One"," Two"," Three"," Four"," Five"," Six", " Seven", " Eight"," Nine"," Ten"," Eleven"," Tweleve"," Thirteen"," Fourteen" };
  static String[] country=new String[]{ "USA" };

      String ShowAttendeProfile(int i,EventRegisterBean jBean,HashMap hm){
	 HashMap scopemap=jBean.getScopeMap();
	 
         StringBuffer sb=new StringBuffer();
         sb.append(getXfOutput(GenUtil.getHMvalue(scopemap,"event.reg.attendee.label","Attendee")+numbers[i]));
         sb.append("<table class='block'><tr>");
         sb.append("<td width='15%' height='30' class='inputlabel'>First Name *</td><td width='50%' height='30' class='inputvalue'>");
         sb.append(getXfTextBox("/profileData["+(i+1)+"]/firstName",GenUtil.getEncodedXML((jBean.getProfileData())[i].getFirstName()),"20"));
         sb.append("</td></tr>");
         sb.append("<tr><td height='30' class='inputlabel'>Last Name *</td><td height='30' class='inputvalue'>");
         sb.append(getXfTextBox("/profileData["+(i+1)+"]/lastName",GenUtil.getEncodedXML((jBean.getProfileData())[i].getLastName()),"20"));
         sb.append("</td></tr>");
         sb.append("<tr><td height='30' class='inputlabel'>Email *</td><td height='30' class='inputvalue'>");
         sb.append(getXfTextBox("/profileData["+(i+1)+"]/email",GenUtil.getEncodedXML((jBean.getProfileData())[i].getEmail()),"35"));
         sb.append("</td></tr>");
         sb.append("<tr><td height='30' class='inputlabel'>Phone </td><td height='30' class='inputvalue'>");
	 sb.append(getXfTextBox("/profileData["+(i+1)+"]/phone",GenUtil.getEncodedXML((jBean.getProfileData())[i].getPhone()),"20"));
         sb.append("</td></tr>");
	
	/*  if(hm.get("Phone")!=null){
	 sb.append("<tr><td height='30' class='inputlabel'>Phone "+(("Required".equals((String)hm.get("Phone")))?"*":"")+"</td><td height='30' class='inputvalue'>");
         sb.append(getXfTextBox("/profileData["+(i+1)+"]/phone",GenUtil.getEncodedXML((jBean.getProfileData())[i].getPhone()),"20"));
         sb.append("</td></tr>");
	 }
	 if(hm.get("Address")!=null){
	 sb.append("<tr><td height='30' class='inputlabel' valign='top'>Address "+(("Required".equals((String)hm.get("Address")))?"*":"")+"</td><td height='55' class='inputvalue' align='left'><table width='100%' cellpadding='0' cellspacing='0'><tr><td>");
         sb.append(getXfTextBox("/profileData["+(i+1)+"]/street1",GenUtil.getEncodedXML((jBean.getProfileData())[i].getStreet1()),"35"));
	 sb.append("</td></tr><tr><td height='3'></td></tr><tr><td>"+getXfTextBox("/profileData["+(i+1)+"]/street2",GenUtil.getEncodedXML((jBean.getProfileData())[i].getStreet2()),"35"));
         sb.append("</table></td></tr>");
	 }

	 sb.append("<tr><td height='30' class='inputlabel'>City</td><td height='30' class='inputvalue'>");
         sb.append(getXfTextBox("/profileData["+(i+1)+"]/city",GenUtil.getEncodedXML((jBean.getProfileData())[i].getCity()),"35"));
         sb.append("</td></tr>");

	 sb.append("<tr><td height='30' class='inputlabel'>Country</td><td height='30' class='inputvalue'>");

         sb.append(getXfSelectListBox("/profileData["+(i+1)+"]/country",EventbeeStrings.selectCountryCodes(),EventbeeStrings.selectCountrys(),GenUtil.getEncodedXML((jBean.getProfileData())[i].getCountry())   ));
         sb.append("</td></tr>");

	 sb.append("<tr><td height='30' class='inputlabel'>State</td><td height='30' class='inputvalue'>");

	 sb.append(getXfTextBox("/profileData["+(i+1)+"]/state",GenUtil.getEncodedXML((jBean.getProfileData())[i].getState()),"35"));
         sb.append("</td></tr>");

         sb.append("<tr><td height='30' class='inputlabel'>Zip</td><td height='30' class='inputvalue'>");
         sb.append(getXfTextBox("/profileData["+(i+1)+"]/zip",GenUtil.getEncodedXML((jBean.getProfileData())[i].getZip()),"10"));
         sb.append("</td></tr>");
	
	 if(hm.get("Organization")!=null){
	 sb.append("<tr><td height='30' class='inputlabel'>Organization "+(("Required".equals((String)hm.get("Organization")))?"*":"")+"</td><td height='30' class='inputvalue'>");
         sb.append(getXfTextBox("/profileData["+(i+1)+"]/company",GenUtil.getEncodedXML((jBean.getProfileData())[i].getCompany()),"35"));
         sb.append("</td></tr>");
	 }
	 
	 if(hm.get("Comment/Introduction")!=null){
	 sb.append("<tr><td height='30' class='inputlabel'>Comment/Introduction "+(("Required".equals((String)hm.get("Comment/Introduction")))?"*":"")+"</td><td height='30' class='inputvalue'>");
         sb.append(getXfTextArea("/profileData["+(i+1)+"]/comments",GenUtil.getEncodedXML((jBean.getProfileData())[i].getComments()),"10","30"));
         sb.append("</td></tr>");
	 }
	 sb.append("<tr><td height='30' class='inputlabel'>Gender</td><td height='30' class='inputvalue'>");
         sb.append(getXfSelectOneRadio("/profileData["+(i+1)+"]/gender",new String[]{"Male","Female"},new String[]{"Male","Female"},GenUtil.getEncodedXML((jBean.getProfileData())[i].getGender())));
         sb.append("</td></tr>");
         sb.append("<tr><td height='30' class='inputlabel'>Organization</td><td height='30' class='inputvalue'>");
         sb.append(getXfTextBox("/profileData["+(i+1)+"]/company",GenUtil.getEncodedXML((jBean.getProfileData())[i].getCompany()),"35"));
         sb.append("</td></tr>");
         sb.append("<tr><td height='30' class='inputlabel'>"+GenUtil.getHMvalue(scopemap,"event.reg.job.title","Title")+"</td><td height='30' class='inputvalue'>");
         sb.append(getXfTextBox("/profileData["+(i+1)+"]/title",GenUtil.getEncodedXML((jBean.getProfileData())[i].getTitle()),"35"));
         sb.append("</td></tr>");
         sb.append("<tr><td height='30' class='inputlabel'>City</td><td height='30' class='inputvalue'>");
         sb.append(getXfTextBox("/profileData["+(i+1)+"]/city",GenUtil.getEncodedXML((jBean.getProfileData())[i].getCity()),"35"));
         sb.append("</td></tr>");

	 sb.append("<tr><td height='30' class='inputlabel'>Country</td><td height='30' class='inputvalue'>");

         sb.append(getXfSelectListBox("/profileData["+(i+1)+"]/country",EventbeeStrings.selectCountryCodes(),EventbeeStrings.selectCountrys(),GenUtil.getEncodedXML((jBean.getProfileData())[i].getCountry())   ));
         sb.append("</td></tr>");

	 sb.append("<tr><td height='30' class='inputlabel'>State</td><td height='30' class='inputvalue'>");

	 sb.append(getXfTextBox("/profileData["+(i+1)+"]/state",GenUtil.getEncodedXML((jBean.getProfileData())[i].getState()),"35"));
         sb.append("</td></tr>");

         sb.append("<tr><td height='30' class='inputlabel'>Zip</td><td height='30' class='inputvalue'>");
         sb.append(getXfTextBox("/profileData["+(i+1)+"]/zip",GenUtil.getEncodedXML((jBean.getProfileData())[i].getZip()),"10"));
         sb.append("</td></tr>");
	 */
	 
         sb.append("</table>");
         return sb.toString(); 
    }
   String EbeeSignUpDisplay(String title){
	StringBuffer sb=new StringBuffer("");
        sb.append("<table class='block'><tr><xf:td><xf:table><tr><xf:td>");
	sb.append(title);
	sb.append("</td></tr></table></td></tr><tr><xf:td>");
	sb.append(getXfBoolean("/ebeeEnroll", "I want to become Eventbee Member"));
        sb.append("</td></tr><tr><xf:td><xf:table><tr>");
        sb.append("<xf:td>Login Name:</td><xf:td>");
        sb.append(getXfTextBox("/ebeeLoginData/loginName","","15"));
        sb.append("</td></tr>");
        sb.append("<tr><xf:td>Password:</td><xf:td>");
        sb.append(getXfTextBox("/ebeeLoginData/password","","15"));
        sb.append("</td></tr>");
        sb.append("<tr><xf:td>ReTypePassword:</td><xf:td>");
        sb.append(getXfTextBox("/ebeeLoginData/reTypePassword","","15"));
        sb.append("</td></tr></table></td></tr></table>");
        return sb.toString();
 }

%>



<% 
 EventRegisterBean jBean = (EventRegisterBean)session.getAttribute("regEventBean");
String event_name=DbUtil.getVal("select eventname from eventinfo where eventid=?", new String [] {request.getParameter("GROUPID")});
String username=DbUtil.getVal("select getMemberPref(mgr_id||'','pref:myurl','') as username from eventinfo where eventid=?", new String [] {request.getParameter("GROUPID")});
 	request.setAttribute("NavlinkNames",new String[]{event_name});
	//request.setAttribute("NavlinkURLs",new String[]{"/portal/eventdetails/eventdetails.jsp"});
	String participant=jBean.getAgentId();
	
	if (participant!=null)	
	request.setAttribute("NavlinkURLs",new String[]{ShortUrlPattern.get(username)+"/event?eventid="+request.getParameter("GROUPID")+"&participant="+participant});
	else
	request.setAttribute("NavlinkURLs",new String[]{ShortUrlPattern.get(username)+"/event?eventid="+request.getParameter("GROUPID")});
	
	request.setAttribute("tasktitle","Event Registration: Attendee Information");
	request.setAttribute("tasksubtitle","Step 2 of 3");
	request.setAttribute("tabtype","event");
	
	
	
%>


<%
%>


<% com.eventbee.campaign.CampaignDB.insertCampaignClickThrough(request.getParameter("eid"),request.getParameter("GROUPID"),"ER");%>
<script>
function submitform(){
document.form1.elements["cocoon-action-next"].click();
}

</script>
<script language="javascript" src="/home/js/enterkeypress.js" >
dummy23456=888;
</script>

<table width='100%' >
<form name='form1' onSubmit="return checkform(this)" method="post" id="form-register-event" view="personalInfo" action="/portal/eventregister/reg/validateProfile.jsp">
  	<input value="personalInfo" name="cocoon-xmlform-view" type="hidden" />

<tr><td>
<%
Object obj=(Object)session.getAttribute("regerrors");
out.println(GenUtil.displayErrMsgs("<tr><td class='error' align='center'>",obj,"</td></tr>" ));
%>
</td></tr>

<tr><td>
 

<%
   
    HashMap profilemap=new HashMap();
    getProfileOptions(profilemap,jBean.getEventId());
    List lst=new ArrayList();
    Set e =profilemap.entrySet();
	for (Iterator i = e.iterator(); i.hasNext();){
 		Map.Entry entry =(Map.Entry)i.next();
		if((entry.getValue()!=null )&& ("Required".equals(((String)entry.getValue()).trim())))
		//if(entry.getValue()!=null )
		lst.add(entry.getKey());
	}


    ProfileData[] pd=jBean.getProfileData();
    jBean.setRequiredProfileOptions(lst);
    boolean notLogin=(jBean.getUserId()==null);

    String fromcontext=(String)session.getAttribute("fromcontext");
    boolean ebeecontext=("No".equals(fromcontext));
    jBean.setContextUnitid((String)session.getAttribute("entryunitid"));
    boolean showebeesignup=(!(jBean.getClubExist()) && ebeecontext && notLogin);
 %>

 <%  
  for(int i=0;i<pd.length;i++){
        out.println(ShowAttendeProfile(i,jBean,profilemap));


			if(   ((jBean.getSurveys()[i]))!=null )
				if(((jBean.getSurveys()[i]).getSurveyObject())!=null)
				request.setAttribute("xfsurveyobj",jBean.getSurveys()[i] );
				%>

				<jsp:include page='/xfhelpers/survey.jsp' />

				<%
				request.removeAttribute("xfsurveyobj");
	       

       }//end for

	if((jBean.getSurvey())!=null)
	if((jBean.getSurvey().getSurveyObject())!=null)
	request.setAttribute("xfsurveyobj",jBean.getSurvey() );
	%>
	
	<jsp:include page='/xfhelpers/survey.jsp' />
	
	<%
	request.removeAttribute("xfsurveyobj");
	
	%>
</td></tr>
<tr><td align='center'>
<input type='submit' name='submit' value='Continue' class='button' />
<input type='submit' name='submit' value='Back' class='button' />
<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>
</td></tr>

    </form>
</table>    
    
     
