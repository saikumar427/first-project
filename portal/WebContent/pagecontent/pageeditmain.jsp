<%@ page import="java.io.*, java.util.*,java.sql.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>

<script language="JavaScript">
  var i=0;
   function check(field){
	document.form.auto.value=field;
   }
   function setAction(){
   		i=1;	
		document.form.target="_self"
		document.form.action="/portal/pagecontent/pagecontentprefinal.jsp";
		if(_win.name=="foobar")
			_win.close();
   }
   function preview(){
   		i=0;
		document.form.target="foobar"
		document.form.action="/portal/pagecontent/pagecontentpreview.jsp";
		//document.form.args="width=800,height=550,menubar=no,status=no,scrollbars=yes,toolbar=no,directories=no,location=no";
		document.form.args="width=800,height=450,menubar=no,status=no,scrollbars=yes,toolbar=no,directories=no,location=no";
   }
  function checkForm(form){
   
 	  if((form.statement.value==null)||trim(form.statement.value)==''){
  		alert("Content is empty");	
 		return false;
   	}else{
 		if(i==1)
 			return true;
 	      _win = window.open('',form.target,form.args);
 	      _win.moveTo(175,50);
 	       if(typeof(focus)=="function" || typeof(focus)=="object")
 		_win.focus();
 		return true;
 	}
 	
   }
  
  
  function reloaddata(form){
   document.form.target="_self"
   document.form.action='/mytasks/nwpageeditmain.jsp';
   document.form.submit();
  }
  
</script>


<%

HashMap pagemap=new HashMap();
pagemap=(HashMap)session.getAttribute("PAGE_HASH_NETWORK");
if(pagemap!=null){

	
	if(request.getParameter("iseditor")!=null){
		
			pagemap.put("autoProcess",request.getParameter("autoProcess"));
			pagemap.put("statement",request.getParameter("statement"));
	}
 if("".equals(GenUtil.getHMvalue(pagemap,"statement","").trim()))
 request.setAttribute("customtextareacontent","");
 else
 request.setAttribute("customtextareacontent",GenUtil.getHMvalue(pagemap,"statement",""));

%>	
 <form name="form" action="/portal/pagecontent/pagecontentprefinal.jsp?type=Snapshot" method="post"  >
	  <table align="center" width="100%">		
<tr><td width="10%" class="inputlabel">Content Type *</td>			

<td width="15%">
<input type="radio" name="autoProcess" value="text" <%=WriteSelectHTML.isRadioChecked("text",GenUtil.getHMvalue(pagemap,"autoProcess",""))%> onClick="javascript:document.form.iseditor.value='n'; reloaddata(this)" /> Text
<input type="radio" name="autoProcess" value="html" <%=WriteSelectHTML.isRadioChecked("html",GenUtil.getHMvalue(pagemap,"autoProcess",""))%> onClick="javascript:document.form.iseditor.value='n'; reloaddata(this)" /> HTML
<input type="radio" name="autoProcess" value="wysiwyg" <%=WriteSelectHTML.isRadioChecked("wysiwyg",GenUtil.getHMvalue(pagemap,"autoProcess",""))%> onClick="javascript:document.form.iseditor.value='y'; reloaddata(this)" /> WYSIWYG Editor
<input type="submit" name="submit2" align="center" value="Preview" Onclick='javascript:preview()' />
</td></tr>

<tr><td class="inputlabel" colspan="3" height="20">Content</td></tr>
<tr><td class="inputvalue"  colspan="3">
	<%if("wysiwyg".equals(GenUtil.getHMvalue(pagemap,"autoProcess",""))||"y".equals(request.getParameter("iseditor"))     ){%>
	<jsp:include page='../customtextarea.jsp' >
	<jsp:param name='textareaname' value='statement' />
	<jsp:param name='height' value='400' />
	<jsp:param name='width' value='100%' />
	<jsp:param name='Dummy_ph' value='' /></jsp:include>
	<%}else{%>
	<input type="hidden" name="textareatype" value="<%=GenUtil.getHMvalue(pagemap,"autoProcess","")%>" />
	<textarea name="statement" onfocus="this.value=(this.value==' ')?'':this.value" rows='20' cols='82' ><%=GenUtil.getHMvalue(pagemap,"statement","")%></textarea>
	<%}%>
</td></tr>
		 <input type="hidden" name="previewyes" value="y"/>
		 <input type="hidden" name="iseditor" />
		<tr>
			<td align="right">
			<input type='button' name='Back' value='Back' Onclick="javascript:history.back()" />
			</td>	
			<td colspan="2" align="left">
			<%= com.eventbee.general.PageUtil.writeHiddenCore( (HashMap)request.getAttribute("REQMAP") )%>
			<input type="submit" name="submit1" align="center" value="Submit"  Onclick='javascript:setAction()'/>
			</td>
		</tr>
	</table>
	</form>	
<%
	}else{
%>
		<table width="100%"><tr><td>Session Expired</td></tr></table>
<%
	}
%>
