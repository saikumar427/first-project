<%@ page import="java.util.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>
<%!
String USERTHEMEQUEY="select COALESCE( "
                             +" (select themecode from user_custom_roller_themes where userid=? and module=?), "
			     +" (select themecode from user_roller_themes where userid=? and module=?), "
			     +" 'sunsets' ) as usertheme";

%>


<jsp:include page="/stylesheets/CoreRequestMap.jsp" />

<%--<jsp:include page='/lifestyle/lifemenu.jsp' />--%>
<%

session.removeAttribute("message");

String rollercontext=(application.getInitParameter("rollercontext")!=null)?application.getInitParameter("rollercontext"):"/roller";

String act=(String)request.getAttribute("act");
String type=(String)request.getAttribute("type");




String userid=(String)request.getAttribute("userid");



String userthemecode=DbUtil.getVal(USERTHEMEQUEY, new String[]{userid,type,userid,type});


boolean dispmaintemplate=true;
boolean displayeditblock=false;
boolean displayconfirm=false;


if("removecss".equals(act) || "removedata".equals(act) ){
	displayconfirm=true;
	dispmaintemplate=false;
}

if("editcss".equals(act) || "editdata".equals(act) ){
	displayeditblock=true;
	dispmaintemplate=false;
}

if(dispmaintemplate ){
%>

<table width='100%'  cellspacing="0" cellpadding="0">


<form name="geturlifestyle" method="post" action="/lifestyle/getTemplate1.jsp" >
<tr class='colheader'>
        <td width="20%">Name</td>
        <td width="70%">Description</td>
        <td width="5%">Edit</td>
        <td width="5%">Remove</td>
    </tr>
<tr class="evenbase"><td >css</td>
            <td>css</td>
            <td class="center">
               <a href="/portal/lifestyle/lifestyle.jsp?<%=request.getAttribute("menuhelper") %>&stype=template&act=editcss"><img src='<%=rollercontext%>/images/Edit16.png' border="0" alt="icon" /></a> 
            </td>
 	
            <td class="center">

               <a href="/portal/lifestyle/lifestyle.jsp?<%=request.getAttribute("menuhelper") %>&stype=template&act=removecss"><img src='<%=rollercontext%>/images/Remove16.gif' border="0" alt="icon" /></a>
            </td></tr>
    
<tr class="oddbase"><td >Template Data</td>
            
            <td>Template Data</td>

            
            <td class="center">
               <a href="/portal/lifestyle/lifestyle.jsp?<%=request.getAttribute("menuhelper") %>&stype=template&act=editdata"><img src='<%=rollercontext%>/images/Edit16.png' border="0" alt="icon" /></a> 
            </td>
 	
            <td class="center">

               <a href="/portal/lifestyle/lifestyle.jsp?<%=request.getAttribute("menuhelper") %>&stype=template&act=removedata"><img src='<%=rollercontext%>/images/Remove16.gif' border="0" alt="icon" /></a>
            </td></tr>

<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>	
</form>
</table>

<%
}
%>


<%
if(displayeditblock ){
String editedcontent="themecontent";
if("editcss".equals(act))editedcontent="css";
// select getThemeData( '12370', 'Snapshot','themecontent' )
%>
		<table width='100%'  cellspacing="0" cellpadding="0">
		<form name="edit" method="post" action="/lifestyle/getlifestyle1.jsp" >
		
		<input type='hidden' name='theme' value='<%=userthemecode %>' />
		<tr><td align='center'>
		<textarea name='editcontent' rows='30' cols='80'><%=DbUtil.getVal("select getThemeDataNewOne( ?, ?,?,? )", new String[]{userid,type,editedcontent,"lifestyle"} ) %></textarea>
		</td></tr>
		<tr><td align='center'>
		<input type='submit' name='submit' value='Submit' />
		</td></tr>
		
		<input type='hidden' name='formname' value="edit" />
		<input type='hidden' name='type' value="<%=type %>" />
		<input type='hidden' name='act' value="<%=act %>" />
		<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>	
		</form>
		
		
		</table>

<%
}
%>


<%
if(displayconfirm ){
%>
<table width='100%'  cellspacing="0" cellpadding="0">
		<form name="edit" method="post" action="/lifestyle/getlifestyle1.jsp" >
		<input type='hidden' name='theme' value='<%=userthemecode %>' />
		<tr><td align='center'>This will remove your customization
		
		</td></tr>
		<tr><td align='center'>
		<input type='submit' name='submit' value='Submit' />
		</td></tr>
		
		<input type='hidden' name='formname' value="remove" />
		<input type='hidden' name='type' value="<%=type %>" />
		<input type='hidden' name='act' value="<%=act %>" />
		<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>	
		</form>
		
		
		</table>
<%
}
%>
