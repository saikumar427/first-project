<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.event.*" %>
<%@ page import="com.eventbee.creditcard.*" %>
<%@ page import="com.eventbee.general.formatting.*,com.eventbee.general.*" %>

<%@ include file='/xfhelpers/xffunc.jsp' %>
<jsp:include page='/stylesheets/CoreRequestMap.jsp' />

<%
   EventRegisterBean jBean = (EventRegisterBean)session.getAttribute("regEventBean");
     CreditCardModel ccm=(CreditCardModel) jBean.getCard() ;
 
   
%>
<% 
	if("http1".equals(request.getScheme()) ){
	
	System.out.println("in http payment.jsp");
	String encodedurl=response.encodeURL((String)session.getAttribute("HTTPS_SERVER_ADDRESS") +request.getRequestURI()+";jsessionid="+session.getId()+"?"+( (request.getQueryString()!=null && request.getQueryString().length()>1  )? "":("&"+request.getQueryString()   ) ) );
	//out.println(encodedurl);
	response.sendRedirect(PageUtil.appendLinkWithGroup(encodedurl,(HashMap)request.getAttribute("REQMAP")    ) );
		 
	}else{


String event_name=DbUtil.getVal("select eventname from eventinfo where eventid=?", new String [] {request.getParameter("GROUPID")});
String username=DbUtil.getVal("select getMemberPref(mgr_id||'','pref:myurl','') as username from eventinfo where eventid=?", new String [] {request.getParameter("GROUPID")});
 	request.setAttribute("NavlinkNames",new String[]{event_name});
	//request.setAttribute("NavlinkURLs",new String[]{"http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com")+"/portal/eventdetails/eventdetails.jsp"});
//request.setAttribute("NavlinkURLs",new String[]{ShortUrlPattern.get(username)+"/event?eventid="+request.getParameter("GROUPID")});
String participant=jBean.getAgentId();
	
	if (participant!=null)	
	request.setAttribute("NavlinkURLs",new String[]{ShortUrlPattern.get(username)+"/event?eventid="+request.getParameter("GROUPID")+"&participant="+participant});
	else
	request.setAttribute("NavlinkURLs",new String[]{ShortUrlPattern.get(username)+"/event?eventid="+request.getParameter("GROUPID")});

	request.setAttribute("tasktitle","Credit card Information");
	request.setAttribute("tasksubtitle","Payment");
	request.setAttribute("rightcontent","surround-payment.jsp");
	request.setAttribute("tabtype","event");
	
%>


<table width='100%'>

<tr><td>
<%      
	Object obj=(Object)session.getAttribute("regerrors");
	if(obj!=null){
	Vector errorMap=(Vector) obj;
	
	 if(errorMap!=null && errorMap.size()>0){ %>
		<tr><td height='20'></td></tr>
		<tr><td class='error'>
		<%if(errorMap.size()==1){%>
			There is [1] error. Please fix these errors and submit the form again
		<%}else{%>
			There are [<%=errorMap.size()%>] errors. Please fix these errors and submit the form again
		<%}%>
		</td></tr>
		
		<tr><td height='10'></td></tr>
	<%
	for(int i=0;i<errorMap.size();i++){ 
			String errormsg=(String)errorMap.elementAt(i);
			if("US".equals(ccm.getProfiledata().getCountry())){
		          }		
			else if("GB".equals(ccm.getProfiledata().getCountry()))
			{
			if("Zip should not be empty".equals(errormsg)){
			errormsg="Postal Code should not be empty";
			}
			else if("Select State".equals(errormsg)){
			errormsg="County should not be empty";
			}
			else if("City should not be empty".equals(errormsg)){
			errormsg="Town/City should not be empty";
			}
			}
	                else if("CA".equals(ccm.getProfiledata().getCountry())){
	                if("Zip should not be empty".equals(errormsg)){
			errormsg="Postal Code should not be empty";
			}
			else if("Select State".equals(errormsg)){
			errormsg="Province should not be empty";
			}
			}
			else if("AU".equals(ccm.getProfiledata().getCountry())){
			if("Zip should not be empty".equals(errormsg)){
			errormsg="Postcode should not be empty";
			}
			else if("Select State".equals(errormsg)){
			errormsg="State/Territory should not be empty";
			}
			else if("City should not be empty".equals(errormsg)){
			errormsg="Town/City should not be empty";
			}
			}
			else if("AL".equals(ccm.getProfiledata().getCountry())){
			if("Zip should not be empty".equals(errormsg)){
			errormsg="Postal Code should not be empty";
			}
			else if("Select State".equals(errormsg)){
			errormsg="State/Province/Region should not be empty";
			}
			}
			else
			{
			if("Zip should not be empty".equals(errormsg)){
			errormsg="Postal Code should not be empty";
			}
			else if("Select State".equals(errormsg)){
			errormsg="State/Province/Region should not be empty";
			}
			else if("City should not be empty".equals(errormsg)){
			errormsg="City should not be empty";
			}
				
			}
			     
	                     
			                
			                
			                
			                
			                
			
			%>
				<tr><td align='left' class='error'>* <%=errormsg%></td></tr>
		<%}%>
	
</td></tr>
<%}}%>
<script>
function submitform(){
document.form1.elements["cocoon-action-next"].click();
}
function disableSubmit(form1) {	
document.form1.elements["cocoon-action-next"].disabled=true;
		return true;
}

</script>
<script language="javascript" src="/home/js/enterkeypress.js" >
dummy23456=888;
</script>

<form name='form1'   id="form-register-event" view="payment" action="/portal/eventregister/reg/cardpay.jsp;jsessionid=<%=session.getId() %>" onSubmit="disableSubmit(this);return checkform(this)" method="post"   >
<input value="payment" name="cocoon-xmlform-view" type="hidden" />
<%
  if("FB".equals(request.getParameter("context"))){
%>
<input value="FB" name="context" type="hidden" />
<%}%>


<tr><td>

<table>
<tr>
<td>

 <%  
 	request.setAttribute("ccm",jBean.getCard() );
 %>
 
 <jsp:include page='CreditCardScreen.jsp'>
 <jsp:param name='GROUPID' value='<%=request.getParameter("GROUPID")%>' /></jsp:include>

</td>
</tr> 
</table> 
</td></tr>


<tr><td>
<table align="center">
<tr><td align="center">
<%
	out.println(getXFButton("next","Submit","Go to Next Page"));   
%>

  </td>
<td align="center">
<input type="button" value="Previous" onClick="javascript:window.history.back()"/>
</td></tr> 
</table> 

  </td></tr>
  <%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>
  </form>
  </table>
  
  
<%}%>
