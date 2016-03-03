<%

request.setAttribute("leftItems",leftItems);
request.setAttribute("rightItems",rightItems);
request.setAttribute("centerItems",centerItems);
String layout=(String)request.getAttribute("layout");
String leftdivclass="wideleftcolumn";
String rightdivclass="narrowrightcolumn";
if("EE".equals(layout)){
	leftdivclass="equalleftcolumn";
	rightdivclass="equalrightcolumn";
}else if("DEFAULT".equals(layout)){
	leftdivclass="leftcolumn";
	rightdivclass="rightcolumn";
}else if("NARROWWIDE".equals(layout)){
	leftdivclass="narrowleftcolumn";
	rightdivclass="widerightcolumn";
}else if("CUSTOM".equals(layout)){
	leftdivclass="customleftcolumn";
	rightdivclass="customrightcolumn";
}
%>
<tiles:insert definition=".beeletspage" flush="true" >
<tiles:put name="head"         value="/main/tabsheader.jsp" />
<tiles:put name="mytabs"         value="/main/mytabsmenu.jsp" />
<tiles:put name="leftdivid"         value="<%=leftdivclass%>" />
<tiles:put name="rightdivid"         value="<%=rightdivclass%>" />
<tiles:putList name="leftdisplaylist">
		<logic:iterate  id="leftItem" name="leftItems" scope="request" type="com.eventbee.web.presentation.beans.BeeletItem">
			<tiles:add value="<%=leftItem%>"  />
		</logic:iterate>
</tiles:putList>

<tiles:putList name="rightdisplaylist">

<logic:iterate  id="rightItem" name="rightItems" scope="request" type="com.eventbee.web.presentation.beans.BeeletItem">
	<tiles:add value="<%=rightItem%>"  />
</logic:iterate>


</tiles:putList>
</tiles:insert>

