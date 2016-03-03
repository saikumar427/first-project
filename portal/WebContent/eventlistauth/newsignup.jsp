<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.general.formatting.*" %>	
<%@ page import="java.util.*,com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>


<%!	       
       String showErrorMsg(Object errormsg){
        	StringBuffer sb=new StringBuffer();
        	String emsg=(String)errormsg;
        	if(emsg!=null){
        		if(emsg.indexOf("Desi ID")>-1)
				emsg=emsg.replaceAll("Desi ID","Bee ID");
	   		sb.append("<tr>");
	   		sb.append("<td valign='top' colspan='2' class='error'>");
	   		sb.append(emsg);
	   		sb.append("</td>");
	   		sb.append("</tr>");
       		}
		return sb.toString();
	}  
	 
%>



<%

HashMap hm=null;
String linkpath ="http://"+EbeeConstantsF.get("serveraddress","www.beeport.com")+"/home/links";

String newtoeventbeemsg="New to Eventbee? Please enter your information to become a member";
List categoryCode=DbUtil.getValues("select code from categories where purpose=? order by displayname",new String[]{"Community"});
List categoryName=DbUtil.getValues("select displayname from categories where purpose=? order by displayname",new String[]{"Community"});
		
		categoryCode.add("Other");
		categoryName.add("Other");
		
		String categoryCodestr[]=(String[])categoryCode.toArray(new String[0]);
      String categoryNamestr[]=(String[])categoryName.toArray(new String[0]);



if(!"yes".equals(request.getParameter("isnew"))){

	hm=(HashMap)session.getAttribute("USER_SIGN_HASH");
}else
  session.removeAttribute("USER_SIGN_HASH");
%>



<table cellspacing="0" class="block" width="100%" valign="top" border="0">
<tr class='evenbase'><td><table width="100%" class="block" cellspacing="2">
<form name='signupform' method="POST"  action="/portal/eventlistauth/processevtauth.jsp" onsubmit="return checklistselection('signup','1');">

<tr><td colspan="2"  /></tr>



<%if("y".equals(request.getParameter("showerr"))){%>
<%=showErrorMsg(hm.get("generalError"))%>
<%=showErrorMsg(hm.get("loginnameExist"))%>
<%=showErrorMsg(hm.get("loginLength"))%>
<%=showErrorMsg(hm.get("pwdMatch"))%>
<%=showErrorMsg(hm.get("pwdLength"))%>   
<%=showErrorMsg(hm.get("firstnameError"))%>   
<%=showErrorMsg(hm.get("lastnameError"))%>
<%=showErrorMsg(hm.get("emailError"))%>
<%=showErrorMsg(hm.get("phoneError"))%>
<%=showErrorMsg(hm.get("categoryError"))%>
<%=showErrorMsg(hm.get("genderError"))%>
<%=showErrorMsg(hm.get("showMemberError"))%>
<%=showErrorMsg(hm.get("invalid_id"))%><%

hm.remove("generalError");
hm.remove("loginnameExist");
hm.remove("loginLength");
hm.remove("pwdMatch");
hm.remove("pwdLength");
hm.remove("firstnameError");
hm.remove("lastnameError");
hm.remove("emailError");
hm.remove("phoneError");
hm.remove("categoryError");

hm.remove("genderError");
hm.remove("showMemberError");
hm.remove("invalid_id");



}%>
<tr class="subheader"><td colspan="2" /><%=newtoeventbeemsg%><br/><br/></td></tr>
<tr><td id='signselectionerror' class='error' colspan='2'></td></tr>

<tr>
	<td class="inputlabel" width="36%"  height="30">Bee ID * <BR/> <font class='smallestfont'>(4-20 alphanumeric characters)</font></td>
	<td class="inputvalue"><input description="User" length="10" type="text" name="name" value="<%=GenUtil.getHMvalue(hm,"name","")%>"/></td>
</tr>

<tr>
	<td class="inputlabel" width="36%"  height="30">Password * <BR/> <font class='smallestfont'>(4-20 alphanumeric characters)</font></td>
	<td class="inputvalue">	<input description="Password" length="10" type="password" name="profileKey" value="<%=GenUtil.getHMvalue(hm,"profileKey","")%>"/></td>
</tr>

<tr>
	<td class="inputlabel" width="36%"  height="30">Retype Password *</td>
	<td class="inputvalue">	<input description="Password" length="10" type="password" name="retypeProfileKey" value="<%=GenUtil.getHMvalue(hm,"retypeProfileKey","")%>"/></td>
</tr>

<tr>
<td class="inputlabel" width="36%"  height="30" >First Name *</td>
<td class="inputvalue"><input name="firstname" type="textbox"  value="<%=GenUtil.getHMvalue(hm,"firstname","")%>"/></td>
</tr>
<tr>
<td class="inputlabel" width="36%"  height="30">Last Name *</td>
<td class="inputvalue"><input name="lastname" type="textbox"   value="<%=GenUtil.getHMvalue(hm,"lastname","")%>"/></td>
</tr>
<tr>
<td class="inputlabel" width="36%"  height="30">Gender *</td>
<td class="inputvalue">
	<input name="gender" type="radio"  value="Male" <%=WriteSelectHTML.isRadioChecked("Male",GenUtil.getHMvalue(hm,"gender",""))%>/>Male
	<input name="gender" type="radio"  value="Female" <%=WriteSelectHTML.isRadioChecked("Female",GenUtil.getHMvalue(hm,"gender",""))%>/>Female
</td>
</tr>
<tr>
<td class="inputlabel" width="36%"  height="30"/>Email *</td>
<td class="inputvalue"><input name="email" type="textbox"  value="<%=GenUtil.getHMvalue(hm,"email","")%>" size="35" /></td>
</tr>

<tr>
<td class="inputlabel" width="36%"  height="30"/>Phone *</td>
<td class="inputvalue"><input name="phone" type="textbox"  value="<%=GenUtil.getHMvalue(hm,"phone","")%>" /></td>
</tr>


<tr>
<td class="inputlabel" width="36%"  height="30"/>Category *<br/><font class='smallestfont'>(select category of your focused events)</font></td>
<td class="inputvalue"><%=WriteSelectHTML.getSelectHtml(categoryCodestr,categoryNamestr,"category",GenUtil.getHMvalue(hm,"category","",true),"-- Select Category --","")%></td>
</tr>





<tr>
<td class="inputlabel" width="36%"  height="30"/>Privacy Settings</td>
<td class="inputvalue">
<input type="checkbox" name="privacylevel" value="low"/> Send me Eventbee communication</td>
</tr>
<input type='hidden' name='shareprofile' value="Yes">


<tr>
<td align="left" colspan="2">
By clicking Continue button you agree
to  Eventbee <a href="javascript:popupwindow('<%=linkpath%>/termsofservice.html','Tags','600','400')">Terms of Service</a>

</td>
</tr>
<tr>
<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>	
	<td align="center" colspan="2"><input value="Continue" name="submit" type="submit" />
	<input type="button"  value="Cancel" onClick="javascript:window.history.back()"/>
	</td>
</tr>



<tr>
	<td colspan="2" width="10" height="10" />
</tr>
<input type="hidden" name="task" value="signup" />
<input type="hidden" name="GROUPID" value="<%=request.getParameter("GROUPID")%>" />
</form>
</table>

</td></tr></table>





