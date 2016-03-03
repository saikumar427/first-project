<%@ page import="java.util.*,com.customattributes.*,com.eventbee.general.*" %>


<html>
<head>


</head>
 <body >
<div id="forpopup" onblur="hidePopUp();cancelTheBubble(event);return false;" >
	
	<a href="#" onclick="changeType('text',new Array('10'));hidePopUp();cancelTheBubble(event);return false;">Text</a><br/>
	<a href="#" onclick="changeType('textarea',new Array('10','70'));hidePopUp();cancelTheBubble(event);return false;" >Multiline Text</a><br/>
	<a href="#" onclick="changeType('radio',new Array('',''));hidePopUp();cancelTheBubble(event);return false;">Radio Button</a><br/>
	<a href="#" onclick="changeType('dropdown',new Array('',''));hidePopUp();cancelTheBubble(event);return false;">Drop Down</a><br/>
	<a href="#" onclick="changeType('checkbox',new Array(''));hidePopUp();cancelTheBubble(event);return false;">Check Box</a>
</div>	
</body>
</html>



<%
String eventid=request.getParameter("GROUPID");
int position=1;
try{
position=Integer.parseInt(request.getParameter("position"));
}catch(Exception e){
}
String purpose=request.getParameter("purpose");
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"customnew.jsp","Purpose is  "+purpose,"",null);
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"customnew.jsp","groupid is  "+eventid,"",null);
Vector customattribs=null;
String attrib_set_id=null;
attrib_set_id=DbUtil.getVal("select attrib_setid from custom_attrib_master where purpose=? and groupid=? ",new String[]{purpose,eventid});
String purpose1=(String)session.getAttribute("purpose");
if("AUTOFILL".equals(purpose1)){
customattribs=(Vector)session.getAttribute(eventid+"CustomAttributes");}
else{

customattribs=(Vector)session.getAttribute(eventid+"_AJAX_EDITPWD");
}
if(customattribs!=null&&!"AUTOFILL".equals(purpose1)){
	attrib_set_id=(String)session.getAttribute("AJAX_SETID_"+eventid);
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"customnew.jsp","attrib_set_id from session is   "+attrib_set_id,"",null);

}

else {
	
CustomAttributes []	customattribs1=CustomAttributesDB.getCustomAttributes(eventid,purpose);
	for(int k=0;k<customattribs1.length;k++){
	if(customattribs==null)
		customattribs=new Vector();
	customattribs.add(customattribs1[k]);
	}
	session.setAttribute(eventid+"_AJAX_EDITPWD",customattribs);
	if(attrib_set_id==null||"".equals(attrib_set_id)){
		attrib_set_id=DbUtil.getVal("select nextval('attrib_set_id') as setid ",null);
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"customnew.jsp","attrib_set_id new seq is   "+attrib_set_id,"",null);
		
	}
	
}

EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"customnew.jsp","attrib_set_id finallyyyyyyyyyyyyyy is   "+attrib_set_id,"",null);
if(customattribs==null)
	customattribs=new Vector();

if("AUTOFILL".equals(purpose1)&&(customattribs!=null)){

session.setAttribute("AJAX_SETID_"+eventid,attrib_set_id);
}

%>
<input type="hidden" name="ATTRIB_SET_ID" value="<%=attrib_set_id%>" />
<div id="showattributes">
</div>
<div id="attriberrors">
</div>
<div id="dynaattrib_1">
</div>
<div id="addAtribute">
	<input type='button' name='button' value='Add Registration Form Field' onclick="document.getElementById('attriberrors').innerHTML='';document.getElementById('attriberrors').style.display='block';AddOneAttrib('Attribute Name','Optional','text',new Array('10'));"/>
</div>




