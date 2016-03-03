<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.general.formatting.*" %>	
<%@ page import="java.util.*,com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>


<%
HashMap hm=null;

String newtoeventbeemsg=EbeeConstantsF.get("newtoeventbee.headermsg","New to Eventbee? Sign Up Now to become a member, it's FREE!");



if(!"yes".equals(request.getParameter("isnew"))){

	hm=(HashMap)session.getAttribute("USER_SIGN_HASH");
	
	
}else{
  session.removeAttribute("USER_SIGN_HASH");
  

   
    

 	
	
	
	Vector userdatavec=new Vector();
	String fbfirstname="";
	String fblastname="";
	String fbgender="";
	
	
	if(userdatavec.size()>0){
	hm=new HashMap();
	for(int i=0;i<userdatavec.size();i++){
	HashMap userdatahm=(HashMap)userdatavec.get(i);
	
	  
      hm.put("firstname",GenUtil.getHMvalue(userdatahm,"first_name",""));
	  hm.put("lastname",GenUtil.getHMvalue(userdatahm,"last_name",""));
	  hm.put("gender",GenUtil.getHMvalue(userdatahm,"sex",""));
	
	}

	}
  
    
  }
%>



<table class='gadget' cellspacing="0"  width="95%" valign="top" border="0" style="border: 1px solid #ddddff" align="center">
<tr><td align="center" colspna="2"><b>New to Eventbee? Sign Up Now to become a member, it's FREE!</b></td></tr>
<tr ><td>

<form name='loginform' method="POST"  action="/ningapp/ticketing/signupprocess.jsp" >
<table width="100%" class='gadget'>
<tr><td colspan="2"  id="signuperrormsg"/></tr>
<tr><td  width="36%" >Bee ID *<br><font class="smallestfont">(4-20 alphanumeric characters)</font></td>
<td ><input description="User" length="10" type="text" name="name"  id="name" value="<%=GenUtil.getHMvalue(hm,"name","")%>"/></td>
</tr>
<tr><td  width="36%"  >Password *<br><font class="smallestfont">(4-20 alphanumeric characters)</font></td>
<td >	<input description="Password" length="10" type="password" name="profileKey"   id="profileKey"  value="<%=GenUtil.getHMvalue(hm,"profileKey","")%>"/></td>
</tr>


<tr>
<td  width="36%"  >First Name *</td>
<td ><input name="firstname" type="textbox"   id="fname" value="<%=GenUtil.getHMvalue(hm,"firstname","")%>"/></td>
</tr>
<tr>
<td  width="36%" >Last Name *</td>
<td ><input name="lastname" type="textbox"   id="lname" value="<%=GenUtil.getHMvalue(hm,"lastname","")%>"/></td>
</tr>

<tr>
<td  width="36%"  >Email *</td>
<td ><input name="email" type="textbox"  id="email" value="<%=GenUtil.getHMvalue(hm,"email","")%>" /></td>
</tr>
<input  type='hidden' name='shareprofile' value="Yes">
<tr>
<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>	
<td align="center" valign="top" colspan="2"><input class="button" value="Continue" name="submit" type="button" onClick="ningsignup('<%=oid%>');" />
</td>
</tr>

<input type="hidden" name="task" value="signup" />
</table>
</form>

</td></tr></table>





