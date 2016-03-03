<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.general.formatting.*" %>	
<!-- <%!
	String showErrorMsg(Object errormsg){
	StringBuffer sb=new StringBuffer();
	String emsg=(String)errormsg;
	if(emsg!=null){
	if(emsg.indexOf("Desi ID")>-1)
	emsg=emsg.replaceAll("Desi ID","Bee ID");
	sb.append("<tr>");
	sb.append("<td valign='top' colspan='2' class='error' >");
	sb.append(emsg);
	sb.append("</td>");
	sb.append("</tr>");
	}
	return sb.toString();
	}  
%> -->
<%
	String groupid=request.getParameter("groupid");
	String clubname="";
	clubname=DbUtil.getVal("select clubname from clubinfo where clubid=?",new String[]{groupid});
	List categoryCode=DbUtil.getValues("select code from categories where purpose=? order by displayname",new String[]{"Community"});
	List categoryName=DbUtil.getValues("select displayname from categories where purpose=? order by displayname",new String[]{"Community"});
	categoryCode.add("Other");
	categoryName.add("Other");
	String categoryCodestr[]=(String[])categoryCode.toArray(new String[0]);
	String categoryNamestr[]=(String[])categoryName.toArray(new String[0]);

	HashMap hm=null;
	if(!"yes".equals(request.getParameter("isnew")))
	{
		hm=(HashMap)session.getAttribute("USER_SIGN_HASH");
	}
%>
	<form id="newsignup" name="validatesignup" method="POST" action="/portal/webintegration/validatesignup.jsp" onSubmit="signuponsubmit('<%=request.getParameter("groupid")%>'); return false;">
	<table cellspacing="0" class="inputvalue" width="100%" valign="top" border="0">
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
	<%=showErrorMsg(hm.get("invalid_id"))%>
	<%
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
	}
	String applname=EbeeConstantsF.get("application.name","Eventbee");
	String messg="Join as Active Member (Eventbee membership is required. Active Members can post messages in Community forums)";
	%>
<br>
<tr><td colspan="2"  /></tr>
<tr>
	<td class="inputlabel" width="36%"  height="30">Bee ID *</td>
	<td class="inputvalue"><input description="User" length="10" type="text" name="name" value="<%=GenUtil.getHMvalue(hm,"name","")%>"/></td>
</tr>
<tr>
	<td class="inputlabel" width="36%"  height="30">Password *</td>
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
	<td class="inputvalue"><input name="gender" type="radio" value="Male" <%=WriteSelectHTML.isRadioChecked("Male",GenUtil.getHMvalue(hm,"gender",""))%>/>Male
	<input name="gender" type="radio"  value="Female" <%=WriteSelectHTML.isRadioChecked("Female",GenUtil.getHMvalue(hm,"gender",""))%>/>Female
</td>
</tr>
<tr>
	<td class="inputlabel" width="36%"  height="30"/>Email *</td>
	<td class="inputvalue"><input name="email" type="textbox" value="<%=GenUtil.getHMvalue(hm,"email","")%>" size="35"/></td>
</tr>
<tr>
	<td class="inputlabel" width="36%"  height="30"/>Phone *</td>
	<td class="inputvalue"><input name="phone" type="textbox"  value="<%=GenUtil.getHMvalue(hm,"phone","")%>"/></td>
</tr>
<tr>
	<td class="inputlabel" width="36%"  height="30"/>Category *<br/><font class='smallestfont'>(select category of your focused events)</font></td>
	<td class="inputvalue"> <%=WriteSelectHTML.getSelectHtml(categoryCodestr,categoryNamestr,"category",GenUtil.getHMvalue(hm,"category","",true),"-- Select Category --","")%></td>
</tr>

<input type='hidden' name='shareprofile' value="Yes">
<br>
<tr>
	<td align="left" colspan="2">By clicking Sign Up button you agree to  Eventbee 
	<a href='/home/links/termsofservice.html' target='_blank'>Terms of Service</a></td>
</tr>
<br>
<tr>
<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>	
<td colspan="8" align="center"><input type='submit' name='submit' value='Sign Up'/>
<input type="button" name="bbb" value="Cancel" onClick="signuppartner('/portal/webintegration/authpage.jsp?groupid=<%=groupid%>')"/></td>
</tr>
</table>
</form>
</td></tr></table>


