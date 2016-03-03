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

String getValFromHM(HashMap hm, String key, String defaultVal){

	if(hm==null) return defaultVal;

	if(hm.get(key)!=null) return GenUtil.getEncodedHTML((String)hm.get(key));

		return defaultVal;

}

%>



<%

HashMap hm=null;
String linkpath ="http://"+EbeeConstantsF.get("serveraddress","www.beeport.com")+"/home/links";

String newtoeventbeemsg="[Optional] Become a member, and auto-fill your information in future event registrations. Eventbee membership is free!";
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

<table cellspacing="0" class="taskbox" width="100%" valign="top" border="0" align='center'>
<tr><td><table width="100%"  cellspacing="0">
<tr class="subheader"><td colspan="7" /><%=newtoeventbeemsg%><br/></td></tr>
<tr><td id='signuperror' class='error' colspan='2'></td></tr>

<tr>
	<td>Bee ID * <BR/> <font class='smallestfont'>(4-20 alphanumeric characters)</font></td>
	
	<td valign='top'><input description="User" length="5"  size='15' type="text" name="name" value="<%=GenUtil.getHMvalue(hm,"name","")%>"/></td>
	<td width='2'/>
	<td>Password * <BR/> <font class='smallestfont'>(4-20 alphanumeric characters)</font></td>
	<td valign='top'><input description="Password" length="5" size='15' type="password" name="profileKey" value="<%=GenUtil.getHMvalue(hm,"profileKey","")%>"/></td>
	<td width='2'/>
	<td valign='top'>Retype Password *</td>
	<td valign='top'>	<input description="Password" length="5" size='15' type="password" name="retypeProfileKey" value="<%=GenUtil.getHMvalue(hm,"retypeProfileKey","")%>"/></td>
</tr>
<tr>
<td>First Name *</td>
<td><input name="firstname" type="textbox" size="15" value="<%=GenUtil.getHMvalue(hm,"firstname","")%>"/></td>
<td width='2'/>
<td>Last Name *</td>
<td><input name="lastname" type="text" size="15"  value="<%=GenUtil.getHMvalue(hm,"lastname","")%>"/></td>
<td width='2'/>
<td>Gender *</td>
<td >
	<input type='radio' name='gender' value='Male' <%=WriteSelectHTML.isRadioChecked("Male",GenUtil.getHMvalue(hm,"gender","",true))%>/ >Male   
	<input type='radio' name='gender' value='Female' <%=WriteSelectHTML.isRadioChecked("Female", GenUtil.getHMvalue(hm,"gender","",true))%>/>Female 

</td>
</tr><tr>
<td>Email *</td>
<td><input name="email" type="text"  value="<%=GenUtil.getHMvalue(hm,"email","",true)%>" size="15" /></td>
<td width='2'/>
<td >Phone *</td>
<td > <input type='text' name='phone' size="15" value='<%=GenUtil.getHMvalue(hm,"phone","",true)%>'> </td>
<td width='2'/>
<td >Category *<br/><font class='smallestfont'>(select category of your focused events)</font></td>
<td ><%=WriteSelectHTML.getSelectHtml(categoryCodestr,categoryNamestr,"category",getValFromHM(hm,"category",""),"-- Select Category --","")%></td>
</tr>

<tr >

<td colspan="8" align='center'>
<input type="checkbox" name="privacylevel" value="low"/> Send me Eventbee communication</td>
</tr>
<input type='hidden' name='shareprofile' value="Yes">


<tr>
<td align="center" colspan="8">
By clicking Sign Up button you agree
to  Eventbee <a href="javascript:popupwindow('<%=linkpath%>/termsofservice.html','Tags','600','400')">Terms of Service</a>

</td>
</tr>
<tr>
<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>	
	<td align="center" colspan="8"><input value="Sign Up" name="submit" type="submit" />
	</td>
</tr>


<input type="hidden" name="task" value="signup" />
<input type="hidden" name="GROUPID" value="<%=request.getParameter("GROUPID")%>" />
</table>

</td></tr></table>





