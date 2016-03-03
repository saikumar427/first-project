<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.customthemes.UserCustomThemeDB" %>

<script language='Javascript' >

function check(){

var radiobutton=document.sform.BACKGROUND;

for (j=0;j<radiobutton.length;++ j)
{
if (radiobutton[j].checked&&radiobutton[j].value=='BACKGROUND_IMAGE')
{	

document.sform.BACKGROUND_COLOR.value='';
return true;
}
if (radiobutton[j].checked&&radiobutton[j].value=='BACKGROUND_COLOR')
{	

document.sform.BACKGROUND_IMAGE.value='';
return true;
}
}
}
</script>

<script language='Javascript'>
var _win;

function setAction(){
if(_win)
_win.close();

document.sform.target="_self"
document.sform.action='/themes/insertAttributes';
}
function preview(){

document.sform.target="foobar"
document.sform.action="/portal/usertheme/preview.jsp";
document.sform.args="width=400,height=400,menubar=no,status=no,scrollbars=yes,toolbar=no,directories=no,location=no";
}
function checkForm(form){
var themename=document.sform.THEME_NAME.value;
if(themename==''||themename==' '){
alert('Theme Name is empty');
return false;
}else{

if(form.action=='/themes/insertAttributes')
return true;
_win = window.open('',form.target,form.args);
_win.moveTo(175,50);
if(typeof(focus)=="function" || typeof(focus)=="object")
_win.focus();
return true;
}
}

</script>
<SCRIPT language=Javascript 
src="/home/js/ColorPicker.js"></SCRIPT>

<SCRIPT language=JavaScript>

var cp = new ColorPicker('window'); // Popup window
var cp2 = new ColorPicker(); // DIV style
var cp3 = new ColorPicker(); // DIV style
var cp4 = new ColorPicker(); // DIV style
var cp5 = new ColorPicker(); // DIV style
</SCRIPT>
<%
String fonttype []={"Verdana, sans-serif","Ariel","Times New Roman","Comic Sans MF","Courier New","Georgia"};

String [] fontsize={"6px","7px","8px","9px","10px",
		    "11px","12px","13px","14px","15px","16px","17px","18px","19px","20px",
		    "21px","22px","23px","24px","25px","26px","27px","28px","29px","30px",
		    "31px","32px","33px","34px","35px","36px","37px","38px","39px","40px",
		    "41px","42px","43px","44px","45px","46px","47px","48px","49px","50px",
		    "51px","52px","53px","54px","55px","56px","57px","58px","59px","60px",
};
String authid=null,unitid=null;
Authenticate authData=AuthUtil.getAuthData(pageContext);
if(authData!=null)authid=authData.getUserID();
Map attribmap=null;
String module=request.getParameter("module");
String foract=request.getParameter("foract");
String streamid=GenUtil.getHMvalue(attribmap,"streamid","");
%>

<form name="sform" action="/themes/insertAttributes" method="POST" onSubmit="return(checkForm(this))">
<input type="hidden" name="title"  value='<%=request.getParameter("title")%>'/>
<input type="hidden" name="foract" value="<%=foract%>">
<table width='100%' cellspacing='0' cellpadding='5'>


<%
	if(foract!=null&&"edit".equals(foract)){

	String themeid=request.getParameter("themeid");

%>

<tr><td  colspan='2'><font color='red'>Warning: Any customization you have made to the theme by editing CSS/HTML 
templates will be lost.</font></td></tr>
<tr height='10'></tr>

<input type='hidden' name='act' value='edit'/>
<input type='hidden' name='themeid' value='<%=themeid%>'/>

<%

	attribmap=(HashMap)UserCustomThemeDB.getStremingAttributes(authid,module,themeid);
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"usertheme.jsp","","attribmap isssss "+attribmap,null);
       }


	if(streamid!=null&&!"".equals(streamid))
	out.println("<input type='hidden' name='streamid' value='"+streamid+"' />");
%>
<%= com.eventbee.general.PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP"))%>


<tr>
<td class='inputlabel' width='30%'>Theme Name *</td>
<td class='inputvalue'>
<input type="text" name="THEME_NAME"  size='65' value="<%=GenUtil.getHMvalue(attribmap,"THEME_NAME","")%>" />
</td>
</tr>

<tr>
<td class='inputlabel' valign="top" width='30%'>
Background
</td>
<td class='inputvalue'>
<table width='100%'>
<tr>
<td  width='15%'><input type='radio' name='BACKGROUND' value='BACKGROUND_COLOR' <%=WriteSelectHTML.isRadioChecked("BACKGROUND_COLOR",GenUtil.getHMvalue(attribmap,"BACKGROUND","BACKGROUND_COLOR"))%> /> Color</td>
<td>
<input type="text" name="BACKGROUND_COLOR" value="<%=GenUtil.getHMvalue(attribmap,"BACKGROUND_COLOR","#FFFFFF")%>"  size='8'/><a href="" name=pick2 id=pick2 
onclick="cp2.select(sform.BACKGROUND_COLOR,'pick2');return false; " style='text-decoration:none'> 
<image border='0' src="/home/images/button.bgcolor.gif"/></a><SCRIPT language=JavaScript>cp.writeDiv()</SCRIPT>
</td>

</tr>
<tr>
<td colspan='2'>or</td>
</tr>



<tr>
<td  width='15%'><input type='radio' name='BACKGROUND' value='BACKGROUND_IMAGE' <%=WriteSelectHTML.isRadioChecked("BACKGROUND_IMAGE",GenUtil.getHMvalue(attribmap,"BACKGROUND",""))%> /> Image</td>
<td>
<input type="text" name="BACKGROUND_IMAGE" value="<%=GenUtil.getHMvalue(attribmap,"BACKGROUND_IMAGE","")%>" size='45'/>
<a href="javascript:popupwindow('/portal/photogallery/getphoto.jsp?UNITID=13579&from=usertheme','Map','600','400');" STYLE="text-decoration: none">
<image border='0' src="/home/images/image.gif"/></a>

</td>

</tr>

</table>
</td>
</tr>





<tr>
<td class='inputlabel' width='30%' valign="top" >
Large Text<br/>
<font class='smallfont'>(This text style is applied to Event headers)</font>
</td>
<td class='inputvalue'>
<table width='100%'>
<tr>
<td  width='15%'>Color</td>
<td>
<input type="text" name="BIGGER_TEXT_COLOR" value="<%=GenUtil.getHMvalue(attribmap,"BIGGER_TEXT_COLOR","#000000")%>" size='8'/><a href="" name=pick3 id=pick3 
onclick="cp3.select(sform.BIGGER_TEXT_COLOR,'pick3');return false; " style='text-decoration:none'> 
<image border='0' src="/home/images/button.bgcolor.gif"/></a>	  <SCRIPT language=JavaScript>cp.writeDiv()</SCRIPT>
</td>
</tr>

<tr>
<td width='15%'>Font Type</td>
<td><%=WriteSelectHTML.getSelectHtml(fonttype,fonttype,"BIGGER_FONT_TYPE",GenUtil.getHMvalue(attribmap,"BIGGER_FONT_TYPE","ACTIVE"),null,null)%></td>
</tr>
<tr>
<td width='15%'>Font Size</td>
<td><%=WriteSelectHTML.getSelectHtml(fontsize,fontsize,"BIGGER_FONT_SIZE",GenUtil.getHMvalue(attribmap,"BIGGER_FONT_SIZE","ACTIVE"),"26px","26px")%></td>
</tr>



</table>
</td>
</tr>

<tr>
<td class='inputlabel' valign="top"  width='30%'>
Medium Text<br/>
<font class='smallfont'>(This text style is applied to Column headers)</font>
</td>
<td class='inputvalue'>
<table width='100%'>
<tr>
<td  width='15%'>Color</td>
<td>
<input type="text" name="MEDIUM_TEXT_COLOR" value="<%=GenUtil.getHMvalue(attribmap,"MEDIUM_TEXT_COLOR","#000000")%>" size='8'/><a href="" name=pick4 id=pick4 
onclick="cp4.select(sform.MEDIUM_TEXT_COLOR,'pick4');return false; " style='text-decoration:none'> 
<image border='0' src="/home/images/button.bgcolor.gif"/></a>	  <SCRIPT language=JavaScript>cp.writeDiv()</SCRIPT>
</td>
</tr>

<tr>
<td width='15%'>Font Type</td>
<td><%=WriteSelectHTML.getSelectHtml(fonttype,fonttype,"MEDIUM_FONT_TYPE",GenUtil.getHMvalue(attribmap,"MEDIUM_FONT_TYPE","ACTIVE"),null,null)%></td>
</tr>
<tr>
<td width='15%'>Font Size</td>
<td><%=WriteSelectHTML.getSelectHtml(fontsize,fontsize,"MEDIUM_FONT_SIZE",GenUtil.getHMvalue(attribmap,"MEDIUM_FONT_SIZE","ACTIVE"),"20px","20px")%></td>
</tr>



</table>
</td>
</tr>



<tr>
<td class='inputlabel' valign="top"  width='30%'>
Small Text<br/>
<font class='smallfont'>(This text style is applied to all other content)</font>
</td>
<td class='inputvalue'>
<table width='100%'>
<tr>
<td  width='15%'>Color</td>
<td>
<input type="text" name="SMALL_TEXT_COLOR" value="<%=GenUtil.getHMvalue(attribmap,"SMALL_TEXT_COLOR","#000000")%>" size='8'/><a href="" name=pick5 id=pick5 
onclick="cp5.select(sform.SMALL_TEXT_COLOR,'pick5');return false; " style='text-decoration:none'> 
<image border='0' src="/home/images/button.bgcolor.gif"/></a>	  <SCRIPT language=JavaScript>cp.writeDiv()</SCRIPT>
</td>
</tr>

<tr>
<td width='15%'>Font Type</td>
<td><%=WriteSelectHTML.getSelectHtml(fonttype,fonttype,"SMALL_FONT_TYPE",GenUtil.getHMvalue(attribmap,"SMALL_FONT_TYPE","ACTIVE"),null,null)%></td>
</tr>
<tr>
<td width='15%'>Font Size</td>
<td><%=WriteSelectHTML.getSelectHtml(fontsize,fontsize,"SMALL_FONT_SIZE",GenUtil.getHMvalue(attribmap,"SMALL_FONT_SIZE","ACTIVE"),"15px","15px")%></td>
</tr>



</table>
</td>
</tr>

<tr>
<td colspan='2' align='center'>

<input type="submit" name="submit" value="Submit" Onclick='javascript:check();javascript:setAction();'/>
<input type="submit" name="submit1" value="Preview" Onclick='javascript:check();javascript:preview();'/>
<input type="button" name="bbb" value="Cancel" onClick="javascript:history.back()"/>
<input type="hidden" name="module" value='<%=module%>'/>
</td>
</tr>
</table>
</form>
