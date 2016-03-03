<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.event.EventInfoDb" %>
<%@ page import="com.eventbee.eventpartner.*" %>

<script language='Javascript' >

function check(){
	var radiobutton=document.sform.BACKGROUND;
	for (j=0;j<radiobutton.length;++j){
		if (radiobutton[j].checked&&radiobutton[j].value=='BACKGROUND_IMAGE'){
			document.sform.BACKGROUND_COLOR.value='';
			return true;
		}
		if (radiobutton[j].checked&&radiobutton[j].value=='BACKGROUND_COLOR'){	
			document.sform.BACKGROUND_IMAGE.value='';
			return true;
		}
	}
}

function SelectAllCategories(){
	var checkAllCatlength=document.sform.CATEGORY.length;
	if(document.sform.ALLCATEGORY.checked==true){
		for(var i = 0; i < checkAllCatlength; i++)
			document.sform.CATEGORY[i].checked = true;
	}
}

function DeSelectAll(){
	var checkAllCatlength=document.sform.CATEGORY.length;
	for(var i = 0; i < checkAllCatlength; i++)
		if(document.sform.CATEGORY[i].checked)
			document.sform.ALLCATEGORY.checked=false;	
}

function SetChecked(categories){

	var catlength=document.sform.CATEGORY.length;
	if(categories=="All"||categories==""){
		document.sform.ALLCATEGORY.checked = true;
		for(var i = 0; i < catlength; i++)
			document.sform.CATEGORY[i].checked = true;
	}
	else{
		var cat=new Array(30);
		cat=categories.split(",");
		for(var j=0;j<cat.length;j++){
			for(var k=0;k<catlength;k++){
				if(document.sform.CATEGORY[k].value==cat[j]){
					document.sform.CATEGORY[k].checked=true;
				}
			}
		}
		
	}
}

</script>

<script>
function setAction(){
	var catlength=document.sform.CATEGORY.length;
	var flag=1;
	for(i=0;i<catlength;i++){
		if(document.sform.CATEGORY[i].checked==true){
			flag=0;
			break;
		}

	}
	if(flag==1){
		alert("Check atleast one Category");
		return false;
	}

	document.sform.target="_self"
	document.sform.action="/portal/ntspartner/insertAttributes.jsp";
	return true;
   }
 function preview(){
		document.sform.target="foobar"
		document.sform.action="/portal/ntspartner/preview.jsp";
		document.sform.args="width=550,height=450,menubar=no,status=no,scrollbars=yes,toolbar=no,directories=no,location=no";
   }
    function checkForm(form){
   		if(form.action=='/portal/ntspartner/insertAttributes.jsp')
			return true;
	      _win = window.open('',form.target,form.args);
	      _win.moveTo(175,50);
	       if(typeof(focus)=="function" || typeof(focus)=="object")
		_win.focus();
		return true;
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
var cp6 = new ColorPicker(); // DIV style
var cp7 = new ColorPicker(); // DIV style

</SCRIPT>

<%
String [] countarr={"1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20"};
String fonttype []={"Ariel","Times New Roman","Comic Sans MS","Courier New","Georgia","Verdana","Arial, Helvetica, Sans-serif"};

String [] fontsize={"6px","7px","8px","9px","10px",
		    "11px","12px","13px","14px","15px","16px","17px","18px","19px","20px",
		    "21px","22px","23px","24px","25px","26px","27px","28px","29px","30px",
		    "31px","32px","33px","34px","35px","36px","37px","38px","39px","40px",
		    "41px","42px","43px","44px","45px","46px","47px","48px","49px","50px",
		    "51px","52px","53px","54px","55px","56px","57px","58px","59px","60px",
		};
String ebeecategory[]=new String[]{"Arts","Associations","Books","Business","Career","Community","Corporate","Education","Entertainment","Entrepreneur","Family","Festivals","Food","Games","Health","Movies","Music","Non-Profit","Politics","Religion","Schools","Social","Sports","Technology","Travel","Other"};	
String authid=null,unitid=null,fromcontext=null,foroperation="edit";
Authenticate authData=AuthUtil.getAuthData(pageContext);
if(authData!=null)authid=authData.getUserID();
String partnerid=request.getParameter("partnerid");
Map attribmap=PartnerDB.getStreamingAttributes(authid,partnerid);
if(attribmap==null||attribmap.size()==0)
foroperation="add";
request.setAttribute("subtabtype","Eventbee Partner Network");
String streamid=GenUtil.getHMvalue(attribmap,"streamid","");
String bg=GenUtil.getHMvalue(attribmap,"BACKGROUND","");
String platform = request.getParameter("platform");
String bgradio=null;
if(bg!=null){
  if(bg.startsWith("http"))  
  	bgradio="BACKGROUND_IMAGE";
  else
        bgradio="BACKGROUND_COLOR";
  }
else
  bgradio="BACKGROUND_COLOR";
 String categories=GenUtil.getHMvalue(attribmap,"CATEGORY","");
 
%>


<form name="sform" action="/portal/ntspartner/insertAttributes.jsp" method="POST" onSubmit="return(checkForm(this))">
<body onload="check();SetChecked('<%=categories%>');">
<table width='100%' cellspacing='0' cellpadding='0'>
<input type="hidden" name="platform" value="<%=platform%>">
<%
	if(streamid!=null&&!"".equals(streamid))
	out.println("<input type='hidden' name='streamid' value='"+streamid+"' />");
%>
<input type='hidden' name='foroperation' value='<%=foroperation%>' />
<%= com.eventbee.general.PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP"))%>

	<tr>
		<td class='inputlabel' width='30%'>Title</td>
		<td class='inputvalue'>
			<input type="text" name="TITLE"  size='40' value="<%=GenUtil.getHMvalue(attribmap,"TITLE","")%>" />
		</td>
	</tr>
	<tr>
		<td class='inputlabel' width='30%'>
			Events Count
		</td>
		<td class='inputvalue'>
			<%=WriteSelectHTML.getSelectHtml(countarr,countarr,"NO_OF_ITEMS",GenUtil.getHMvalue(attribmap,"NO_OF_ITEMS","5"),null,null )%>
		</td>
	</tr>
	<tr>
		<td class='inputlabel' width='30%'>
			Events Category
		</td>
		<td class='inputvalue'>
		<input type='checkbox'  name='ALLCATEGORY' value='allcategory' onClick='SelectAllCategories()'/>All
		</td>
	</tr>
	<tr>
	<tr>
	<td class='inputlabel' width='30%'>
	</td><td class='inputvalue'><table><tr>
	<%
		int p=0;
		for(int j=0;j<ebeecategory.length;j++){
		p++;
	%>
		<td>
			<input type='checkbox'  name='CATEGORY' value='<%=ebeecategory[j]%>' onClick='DeSelectAll()'/><%=ebeecategory[j]%>
		</td>
	<%
		if(p%3==0)
		{
	%>
		</tr><tr>
	<%
		}
	}%>
		</tr></table></td>
		
</tr>
	<%--	<td class='inputvalue'>
			<%=WriteSelectHTML.getSelectHtml(category,category_values,"CATEGORY",GenUtil.getHMvalue(attribmap,"CATEGORY","ALL"),null,null)%>
		</td>
		--%>
	</tr>
	
	<tr>
		<td class='inputlabel' width='30%'>Streamer Width</td>
		<td class='inputvalue'>
			<input type="text" name="STREAMERSIZE"  size='5' value="<%=GenUtil.getHMvalue(attribmap,"STREAMERSIZE","250")%>" /> pixels
		</td>
	</tr>
	<tr>
	
	<tr><td  class='inputlabel' width='30%'>Background </td>
	<td class='inputvalue'>
	<table width='100%'>
	    <tr>
		<td  width='15%'><input type='radio' name='BACKGROUND' value='BACKGROUND_COLOR' <%=WriteSelectHTML.isRadioChecked("BACKGROUND_COLOR",bgradio)%> /> Color</td>
		<td>
			<input type="text" name="BACKGROUND_COLOR" value="<%=GenUtil.getHMvalue(attribmap,"BACKGROUND","#dce8ff")%>"  size='8'/><a href="" name=pick2 id=pick2 
			onclick="cp2.select(sform.BACKGROUND_COLOR,'pick2');return false; " style='text-decoration:none'> 
			<image border='0' src="/home/images/button.bgcolor.gif"/></a><SCRIPT language=JavaScript>cp.writeDiv()</SCRIPT>
		</td>

	    </tr>
	    <tr>
		<td colspan='2'>or</td>
	    </tr>
	    <tr>
		<td  width='15%'><input type='radio' name='BACKGROUND' value='BACKGROUND_IMAGE' <%=WriteSelectHTML.isRadioChecked("BACKGROUND_IMAGE",bgradio)%> /> Image</td>
		<td>
			<input type="text" name="BACKGROUND_IMAGE" value="<%=GenUtil.getHMvalue(attribmap,"BACKGROUND","")%>" size='45'/>
			<a href="javascript:popupwindow('/portal/photogallery/getphoto.jsp?UNITID=13579&from=usertheme','Map','600','400');" STYLE="text-decoration: none">
			<image border='0' src="/home/images/image.gif"/></a>
		</td>
	    </tr>
	</table>

	</td></tr>
		<tr>
		        <td class='inputlabel' width='30%'>	Border	</td>
			<td class='inputvalue'>
				<input type="text" name="BORDERCOLOR" value="<%=GenUtil.getHMvalue(attribmap,"BORDERCOLOR","#000000")%>" size='8'/><a href="" name=pick3 id=pick3 
				onclick="cp3.select(sform.BORDERCOLOR,'pick3');return false; " style='text-decoration:none'> 
				<image border='0' src="/home/images/button.bgcolor.gif"/></a>	  <SCRIPT language=JavaScript>cp.writeDiv()</SCRIPT>
			</td>
		</tr>
		<tr><td class='inputlabel' width='30%'>	Links </td>
		<td class='inputvalue'>
			<input type="text" name="LINKCOLOR" value="<%=GenUtil.getHMvalue(attribmap,"LINKCOLOR","#0000FF")%>" size='8'/>	<a href="" name=pick4 id=pick4 
			onclick="cp4.select(sform.LINKCOLOR,'pick4');return false; " style='text-decoration:none'> 
			<image border='0' src="/home/images/button.bgcolor.gif"/></a><SCRIPT language=JavaScript>cp.writeDiv()</SCRIPT>
		</td></tr>
		<tr><td class='inputlabel' width='30%'>Large Text<br/>
			<font class='smallfont'>(This text style is applied to headers)</font>
		    </td>
	            <td class='inputvalue'>
			<table width='100%'>
				<tr><td  width='15%'>Color</td>
				    <td>
					<input type="text" name="BIGGER_TEXT_COLOR" value="<%=GenUtil.getHMvalue(attribmap,"BIGGER_TEXT_COLOR","#000000")%>" size='8'/><a href="" name=pick5 id=pick5 
					onclick="cp5.select(sform.BIGGER_TEXT_COLOR,'pick5');return false; " style='text-decoration:none'> 
					<image border='0' src="/home/images/button.bgcolor.gif"/></a>	  <SCRIPT language=JavaScript>cp.writeDiv()</SCRIPT>
				    </td>
				</tr>
				<tr>
				     <td width='15%'>Font Type</td>
		        	     <td><%=WriteSelectHTML.getSelectHtml(fonttype,fonttype,"BIGGER_FONT_TYPE",GenUtil.getHMvalue(attribmap,"BIGGER_FONT_TYPE","ACTIVE"),"Verdana","Verdana")%></td>
				</tr>
				<tr>
				     <td width='15%'>Font Size</td>
		       		     <td><%=WriteSelectHTML.getSelectHtml(fontsize,fontsize,"BIGGER_FONT_SIZE",GenUtil.getHMvalue(attribmap,"BIGGER_FONT_SIZE","ACTIVE"),"15px","15px")%></td>
				</tr>
			</table>
		     </td>
		</tr>
		<tr>
		     <td class='inputlabel' width='30%'>Medium Text<br/>
			<font class='smallfont'>(This text style is applied to content)</font>
		     </td>
		     <td class='inputvalue'>
			   <table width='100%'>
				<tr>
				    <td  width='15%'>Color</td>
				    <td>
					<input type="text" name="MEDIUM_TEXT_COLOR" value="<%=GenUtil.getHMvalue(attribmap,"MEDIUM_TEXT_COLOR","#000000")%>" size='8'/><a href="" name=pick6 id=pick6 
					onclick="cp6.select(sform.MEDIUM_TEXT_COLOR,'pick6');return false; " style='text-decoration:none'> 
					<image border='0' src="/home/images/button.bgcolor.gif"/></a>	  <SCRIPT language=JavaScript>cp.writeDiv()</SCRIPT>
				    </td>
				 </tr>
				 <tr>
				     <td width='15%'>Font Type</td>
				     <td><%=WriteSelectHTML.getSelectHtml(fonttype,fonttype,"MEDIUM_FONT_TYPE",GenUtil.getHMvalue(attribmap,"MEDIUM_FONT_TYPE","ACTIVE"),"Verdana","Verdana")%></td>
				  </tr>
				  <tr>
				      <td width='15%'>Font Size</td>
				      <td><%=WriteSelectHTML.getSelectHtml(fontsize,fontsize,"MEDIUM_FONT_SIZE",GenUtil.getHMvalue(attribmap,"MEDIUM_FONT_SIZE","ACTIVE"),"11px","11px")%></td>
				  </tr>
			  </table>
		     </td>
		</tr>
		<tr>
		     <td class='inputlabel' width='30%'>Small Text<br/>
			<font class='smallfont'>(This text style is applied to Eventbee links)</font>
		     </td>
		     <td class='inputvalue'>
		           <table width='100%'>
				<tr>
				     <td  width='15%'>Color</td>
				     <td>
				          <input type="text" name="SMALL_TEXT_COLOR" value="<%=GenUtil.getHMvalue(attribmap,"SMALL_TEXT_COLOR","#696969")%>" size='8'/><a href="" name=pick7 id=pick7 
				          onclick="cp7.select(sform.SMALL_TEXT_COLOR,'pick7');return false; " style='text-decoration:none'> 
					  <image border='0' src="/home/images/button.bgcolor.gif"/></a>	  <SCRIPT language=JavaScript>cp.writeDiv()</SCRIPT>
				     </td>
				</tr>
				<tr>
			             <td width='15%'>Font Type</td>
				     <td><%=WriteSelectHTML.getSelectHtml(fonttype,fonttype,"SMALL_FONT_TYPE",GenUtil.getHMvalue(attribmap,"SMALL_FONT_TYPE","ACTIVE"),"Verdana","Verdana")%></td>
				</tr>
				<tr>
				     <td width='15%'>Font Size</td>
				     <td><%=WriteSelectHTML.getSelectHtml(fontsize,fontsize,"SMALL_FONT_SIZE",GenUtil.getHMvalue(attribmap,"SMALL_FONT_SIZE","ACTIVE"),"9px","9px")%></td>
				</tr>
			   </table>
		     </td>
		</tr>

	<tr>
		<td class='inputlabel' width='30%'>Display Eventbee link? </td>
		<td class='inputvalue'>
			<input type="radio" name='DISPLAYEBEELINK' value="yes" <%=("yes".equals(GenUtil.getHMvalue(attribmap,"DISPLAYEBEELINK","yes")))?"checked='checked'":""%> >Yes
			<input type="radio" name='DISPLAYEBEELINK' value="no" <%=("no".equals(GenUtil.getHMvalue(attribmap,"DISPLAYEBEELINK","yes")))?"checked='checked'":""%> >No 
		</td>
	</tr>
	<tr><td colsapn='2' height='5'><br/><br/></td></tr>
	<tr><td colspan='2' align='center'>
		<input type="submit" name="submit" value="Preview" Onclick='javascript:check();javascript:preview();'/>
		<input type="submit" name="submit" value="Get Code" Onclick='javascript:check();return setAction();'/>
		<input type="button" name="bbb" value="Cancel" onClick="javascript:history.back()"/>
	   </td>
	</tr>
<input type='hidden' name ='GROUPID' value='<%=request.getParameter("GROUPID")%>'>
<input type='hidden' name ='participant'value='<%=request.getParameter("participant")%>'>
<input type='hidden' name ='partnerid'value='<%=request.getParameter("partnerid")%>'>
</table>
</form>

