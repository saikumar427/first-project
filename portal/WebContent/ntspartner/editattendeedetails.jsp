<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.customattributes.*" %>
<%@ page import="com.eventbee.survey.*"%>
<%@ include file='/xfhelpers/xffunc.jsp' %>
<%!
String base="oddbase";

private String getCustomAttribDisplay(SurveyAttendee surveyatt, HashMap attendeeinfo){
	SurveyInfo sinfo=(SurveyInfo)surveyatt.getSurveyObject();
	Vector v=(Vector)surveyatt.getQuestionObject();
	StringBuffer sb=new StringBuffer("");
	if(sinfo!=null){
		sb.append(""); 
		String surveybaseref=surveyatt.getRefName();
		Vector vec1=new Vector();		
		for(int surveyi=0;surveyi<v.size();surveyi++){	
			if(surveyi%2==0)
			base="evenbase";
			else
			base="oddbase";
			SurveyQuestion sinfotemp1=(SurveyQuestion)v.elementAt(surveyi);
			String ques=sinfotemp1.getQuestion();
			String qtype=sinfotemp1.getQuestionType();			
			String quesres=(String)attendeeinfo.get(ques);
			if(quesres==null) quesres="";			
			String mandatory=sinfotemp1.getMandatoryType();
			HashMap hm1=new HashMap();
			hm1.put("attribnae",ques);
			hm1.put("mandatory",mandatory);
			String length=sinfotemp1.getTextBoxSize();
			ques+=("yes".equalsIgnoreCase(mandatory))?" *":"";
			int j=surveyi+1;
			sb.append("<tr>");
			sb.append("<td class='"+base+"'><b>"+GenUtil.getEncodedXML(ques)+":</b></td><td class='"+base+"'>");
			String ref1="/"+surveybaseref+"/surveyResponse["+j+"]";
			String[] options= sinfotemp1.getOptions();
			String temp="";
			if(qtype.equals("textbox")){
			sb.append(getXfTextBox(ref1,quesres, ""+length));
			}else if(qtype.equals("multi")){
			String rows=sinfotemp1.getRows();
			String cols=sinfotemp1.getCols();
			sb.append(getXfTextArea(ref1, quesres, rows, cols));  
			}else if(qtype.equals("opt")){
			sb.append(getXfSelectOneRadio(ref1, options, options,quesres));
			}else if(qtype.equals("checkbox")){
			sb.append(getXfSelectMany(ref1, options, options, GenUtil.strToArrayStr(quesres, "##")));
			}
			else if(qtype.equals("dropdown")){
			sb.append(getXfSelectOneCombo(ref1, options, options,quesres));
			}
			else if(qtype.equals("select")){
			sb.append(getXfSelectOneCombo(ref1, options, options,quesres));
			}
			sb.append("</td></tr>");
			vec1.add(hm1);
		}//end for
	}//end if sinfo null
	return sb.toString();
} //end getCustomAttribDisplay()
     

public static HashMap getAttendeeInfo(String transactionid,String eventid, String attendeekey){
	     HashMap hm=null;
             Vector v=null;
             DBManager dbm=new DBManager();
	     StatusObj statobj;
	     String GET_ATTENDEE_INFO = "select firstname,lastname,email,phone,company,city,state,country,zip,gender,attendeekey,authid from eventattendee where transactionid=? and eventid=? and attendeekey=? ";
	     statobj=dbm.executeSelectQuery(GET_ATTENDEE_INFO,new String[]{transactionid,eventid,attendeekey});
	  	  if(statobj.getStatus()){
	  			hm=new HashMap();
				hm.put("firstname", dbm.getValue(0,"firstname",""));
				hm.put("lastname", dbm.getValue(0,"lastname",""));
				hm.put("email", dbm.getValue(0,"email",""));
			        hm.put("phone", dbm.getValue(0,"phone",""));
				hm.put("company",dbm.getValue(0,"company",""));
				hm.put("city",dbm.getValue(0,"city",""));
				hm.put("state",dbm.getValue(0,"state",""));
				hm.put("country",dbm.getValue(0,"country",""));
				hm.put("zip",dbm.getValue(0,"zip",""));
				hm.put("gender",dbm.getValue(0,"gender",""));
				hm.put("attendeekey",dbm.getValue(0,"attendeekey",""));
				hm.put("userid", dbm.getValue(0,"authid",""));
			  			
	  		        } //end if
	  		return hm;

		
    } //end getAttendeeInfo()
 
    public static void fillAttendeeResponse(HashMap attinfomap, String attendeekey){
    	       DBManager dbm=new DBManager();
	       StatusObj statobj;
  	       String custoattribresponsequery="select attrib_name,response   from  custom_attrib_response a,custom_attrib_response_master b where a.responseid=b.responseid and b.userid=?";
               statobj=dbm.executeSelectQuery(custoattribresponsequery,new String[]{attendeekey});
               if(statobj.getStatus()){               
                  for(int i=0;i<statobj.getCount();i++){
    		  	attinfomap.put(dbm.getValue(i,"attrib_name",""), dbm.getValue(i,"response",""));
    		  } //end for
    		}   //end if   	

    } //end fillAttendeeResponse()
     String encode(String city,String state,String country){
            if(city==null || "".equals(city))  return ""; 
            return city+","+state+","+country;
   } //end encode()
 %>

<%
String mgrtokenid=request.getParameter("mgrtokenid");
String eid=request.getParameter("eid");
String transactionid=request.getParameter("key");
String attendeekey=request.getParameter("attendeekey");
String platform=request.getParameter("platform");
String tokenid=request.getParameter("tokenid");
String cardtype=request.getParameter("cardtype");
String from=request.getParameter("from");
String trackcode=request.getParameter("trackcode");
String secretcode=request.getParameter("secretcode");
HashMap attendeeinfo=getAttendeeInfo(transactionid,eid,attendeekey);
if (attendeeinfo!=null){ 
fillAttendeeResponse(attendeeinfo, attendeekey);
%>
<form name="editattendeedetails" id="editattendeedetails" method="post" action="/portal/ntspartner/updateattendeedetails.jsp" >
<table class='portaltable' cellpadding="0" cellspacing="0" width="100%">
<input type="hidden" name="transactionid" value="<%=transactionid%>">
<input type="hidden" name="eid" value="<%=eid%>">
<input type="hidden" name="attendeekey" value="<%=attendeekey%>">
<tr>
	<td  colspan="2" align="center" id="updatemsg">
	</td>
</tr>
<tr>
	<td  colspan="2" class="oddbase">
	</td>
</tr>
<tr>
	<td class="evenbase"><b>First Name:</b> </td><td class="evenbase"><input type="text" id="firstname" name="firstname" value="<%=GenUtil.XMLEncode((String)attendeeinfo.get("firstname"))%>">
	</td>
</tr>
<tr>
	<td class="oddbase"><b>Last Name:</b> </td><td class="oddbase"><input type="text" id="lastname" name="lastname" value="<%=GenUtil.XMLEncode((String)attendeeinfo.get("lastname"))%>">
	</td>
</tr>
<tr>
	<td class="evenbase"><b>Email:</b></td> <td class="evenbase"> <input type="text" id="email" name="email" value="<%=GenUtil.XMLEncode((String)attendeeinfo.get("email"))%>" 
	</td>
</tr>
<% 
String phone=(String)attendeeinfo.get("phone");
if("null".equals(phone))phone="";
%>	<tr>
		<td class="oddbase"><b>Phone:</b> </td><td class="oddbase"><input type="text" name="phone" id="phone" value="<%=phone%>">
		</td>
	</tr>
<%if ((String)attendeeinfo.get("company")!=null){} %>
<% if(!("".equals((String)attendeeinfo.get("city")))){%>
<tr>
	<td class="evenbase"><b>City:</b>
	</td>
	<td class="evenbase"><input type="text" id="city" value="<%=GenUtil.XMLEncode((String)attendeeinfo.get("city"))%>">
	</td>
</tr>
<% }if(!("".equals((String)attendeeinfo.get("state")))){%>
<tr>
	<td class="oddbase">
	<b>State:</b>
	</td>
	<td class="oddbase"><input type="text" id="state" name="state" value="<%=(String)attendeeinfo.get("state")%>">
	</td>
</tr>
<% }if(!("".equals((String)attendeeinfo.get("country")))){%>
<tr>
	<td><b>Country:</b>
	</td>
	<td>
	<input type="text" id="country" name="country" value="<%=(String)attendeeinfo.get("country")%>">
	</td>
</tr>
<% }if(!("".equals((String)attendeeinfo.get("zip")))){%>
<tr>
	<td class="evenbase"> <b>Zip:</b>
	</td>
	<td class="evenbase"> <input type="text" id="zip" name="zip" value="<%=(String) attendeeinfo.get("zip")%>">
	</td>
</tr>
<%}
} //end if(attendeeinfo!=null)
%>
<%
	CustomAttributes[] attribs=CustomAttributesDB.getCustomAttributes(eid,"EVENT");
	SurveyAttendee  m_surveys=new SurveyAttendee();
	m_surveys=new CustomAttributeSurvey();
	m_surveys.setGroupId(eid);
	m_surveys.setSurvey(eid,"EVENT","surveys");
	String custom = getCustomAttribDisplay(m_surveys, attendeeinfo);
	out.println(custom);

		
%>
<tr>
	<td colspan="2" height="5">
	</td>
</tr>
<tr>
	<td >
	</td>
	<td >
	<input type="button" value="Update" onClick="updateAttendeeDetails('<%=transactionid%>','<%=tokenid%>','<%=platform%>','<%=cardtype%>',<%=eid%>,'<%=secretcode%>','<%=from%>','<%=trackcode%>','<%=mgrtokenid%>')"> 
	
	<input type="button" value="Close" onClick="hideattendee();"> 
	</td>
	
</tr>		
</table>
</form>