<%@ page import="com.eventbee.general.*,com.eventbee.general.GenUtil" %>
<%@ page import="java.util.*" %>
<%@ page import="org.eventbee.sitemap.util.Presentation" %>
<html title="Email to friend">
<head>
  <title>E-Mail this page to a friend</title>
</head>
<body>
<%
	Presentation presentation=new Presentation(pageContext);
	presentation.includeStyles();
%>
<%
	//String eunitid=request.getParameter("UNITID");
	String purpose=request.getParameter("purpose");
	String id=request.getParameter("id");
	EmailTemplate emailtemplate=new EmailTemplate("13579",purpose);
	HashMap wordmap=(HashMap)session.getAttribute(id+"_"+purpose);
	if(wordmap==null)
	wordmap=new HashMap();
	String temphtml=emailtemplate.getHtmlFormat();
	String  message=" ";
	String appendmessage=" ";
	String subject=emailtemplate.getSubjectFormat();
	if(subject!=null&&!"".equals(subject))
	subject=TemplateConverter.getMessage(wordmap,subject);
	if(temphtml!=null&&temphtml.indexOf("#**personalmessagehtml**#")!=-1){
	message=temphtml.substring( temphtml.indexOf("#**personalmessagehtml**#")+("#**personalmessagehtml**#".length()), temphtml.length());
	if(temphtml.indexOf("<hr />")!=-1)
	message=message.substring(message.indexOf("<hr />")+("<hr />".length() ),message.length() );
	}else
	message=temphtml;
	if(message!=null&&!"".equals(message.trim()))
	appendmessage=TemplateConverter.getMessage(wordmap,message);
	session.setAttribute(id+"_"+purpose+"_EMAILTEMPLATE",emailtemplate);
%>
<SCRIPT LANGUAGE="JavaScript">
function checkName(){
var t1=document.form.fromemail.value;
  if(document.form.toemails.value==''){
  	alert("To email should not be empty");
  	return false;
  }else if(document.form.fromemail.value==''){
  	alert("From email should not be empty");
  	return false;
  }else if((document.form.fromemail.value!='')&&((t1.indexOf('@')==-1)||(t1.indexOf('.')==-1))){
       	alert("From Email Id Format is invalid");
        return false;
  }else{
  	return true;
  }

}
</SCRIPT>


<form action="emailsend.jsp" method="post" name="form" onSubmit="return (checkName())">
  <table cellspacing="0" cellpadding="2" border="0">
  <tr><td class="tasktitle" colspan='2'><b><%= EbeeConstantsF.get(purpose+".title","Email this to friend") %></b></td></tr>
    <tr>
      <td class="inputlabel">To *<br/>(comma separated email IDs)</td>
      <td class="inputvalue">
        <textarea name="toemails" cols="40" rows="4" onfocus="this.value=(this.value==' ')?'':this.value"> </textarea>
      </td>
    </tr>
    <tr>
      <td class="inputlabel">From *<br/>(email ID)</td>
      <td class="inputvalue">
        <input type="text" maxlength="120" name="fromemail" value="" size="40"/>
      </td>
    </tr>
    <tr>
      <td class="inputlabel">Name </td>
      <td class="inputvalue">
        <input type="text" maxlength="120" name="fromname" value="" size="40"/>
        </td>
    </tr>
    <tr>
  	  <td class="inputlabel">Subject </td>
  	   <td class="inputvalue"><input type="text" name="subject" value='<%=(subject==null)?"":subject %>' size="40" /> </td>
  	</tr>
    <tr>
      <td class="inputlabel">Personal Message</td>
      <td class="inputvalue">
        <textarea name="personalmessage" cols="40" rows="10" onfocus="this.value=(this.value==' ')?'':this.value"> </textarea>
      </td>
    </tr>
  <%if(!"".equals(message)){%>
    <tr>
      <td class="inputlabel"><%=EbeeConstantsF.get("application.name","Eventbee")%> Message</td>
      <td class="inputvalue">
        <div align="center"><%=appendmessage%></div>
      </td>
    </tr>
    <%}%>
    <tr>
      <td colspan="2" align="center">
      	<input type="hidden" name="id" value="<%=id%>"/>
	<!--input type="hidden" name="UNITID" value="<%--=eunitid--%>"/-->
        <input type="hidden" name="purpose" value="<%=purpose%>"/>
	<input type="button" name="Submit" value="Cancel" onClick="javascript:window.close();"/>
        <input type="Submit" name="Submit" value="Submit" />
      </td>
    </tr>
  </table>
</form>
</body>
</html>
