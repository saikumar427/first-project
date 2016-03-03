<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.general.*" %>
<%!
String formname="loginform";
%>
<%@ include file='/xfhelpers/xffunc.jsp' %>


 <% 
 String event_name=DbUtil.getVal("select eventname from eventinfo where eventid=?", new String [] {request.getParameter("GROUPID")});

String username=DbUtil.getVal("select getMemberPref(mgr_id||'','pref:myurl','') as username from eventinfo where eventid=?", new String [] {request.getParameter("GROUPID")});

 	request.setAttribute("NavlinkNames",new String[]{event_name});
	//request.setAttribute("NavlinkURLs",new String[]{"/portal/eventdetails/eventdetails.jsp"});
	request.setAttribute("NavlinkURLs",new String[]{ShortUrlPattern.get(username)+"/event?eventid="+request.getParameter("GROUPID")});

	request.setAttribute("tasktitle","Event Registration : Member Login");
	request.setAttribute("tasksubtitle","Step 2 of 3");
	request.setAttribute("tabtype","event");
	
	
	
%>

<script>
function submitform(){
document.loginform.elements["cocoon-action-next"].click();
}

</script>
<script language="javascript" src="/home/js/enterkeypress.js" >
dummy23456=888;

</script>

<table width='100%'>
 <form name='loginform' onSubmit="return checkform(this)" method="post" id="form-register-event" view="eventbeelogin" action="/portal/eventregister/reg/validateLogin.jsp">
  	<input value="eventbeelogin" name="cocoon-xmlform-view" type="hidden" />

 <tr><td>
 <%
Object obj=(Object)session.getAttribute("regerrors");
out.println(GenUtil.displayErrMsgs("<tr><td class='error' align='center'>",obj,"</td></tr>" ));
%>
</td></tr> 

<%
 Map reqMap=(Map)session.getAttribute("reg_eventbeelogin");
%>


<tr><td>
 
 
  <table>

       <tr>

            <td class="inform">
		 <%
		out.println(getXfSelectOneRadio("/selectedLogin", new String[]{""},new String[]{""},reqMap));

        %> </td><td> If you have <%=EbeeConstantsF.get("application.name","Eventbee")%> account, enter your account information to auto-fill your profile form



           </td>

       </tr>

  </table>
</td></tr>
<tr><td>
<table>
  
  

	<tr>
	<td>



       </td>
       <td>
       <%=EbeeConstantsF.get("login.label","Bee ID")%> <%=(getXfTextBox("/ebeeLoginData/loginName","","10",reqMap))%></td>
<script language="JavaScript">
<!--


document.loginform.elements[2].focus();

//-->
</script>
      <td>
      Password
      <%=(getXfPassWord("/ebeeLoginData/password","","10", reqMap))%>

       </td>

 </tr>

  <tr><td>

        <% 
	
	out.println(getXfSelectOneRadio("/selectedLogin", new String[]{"none"},new String[]{""},reqMap));

        %>

       </td><td>I do not have <%=EbeeConstantsF.get("application.name","Eventbee")%> account</td><td></td>

  </tr>

</table>
</td></tr>
<tr><td align='center'>

<%

	  out.println(getXFButton("next","Continue","Go to Next Page"));
  out.println(getXFButton("prev","Back","Go to Prev page"));



%>
</td></tr>
<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>
</form>
</table>

