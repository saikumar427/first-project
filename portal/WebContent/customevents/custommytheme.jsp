<%@ page import="java.util.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>
<%!
String USERTHEMEQUEY="select COALESCE( "
                             +" (select themecode from user_custom_roller_themes where userid=? and module=? and refid=?), "
			     +" (select themecode from user_roller_themes where userid=? and module=? and refid=?), "
			     +" 'sunsets' ) as usertheme";

%>

<jsp:include page="/stylesheets/CoreRequestMap.jsp" />
<% 
request.setAttribute("linktohighlight","pagecontent");
	request.setAttribute("tabtype","community");
	request.setAttribute("subtabtype","My Pages");
%>

<jsp:include page="/stylesheets/TabSetter.jsp">
<jsp:param name='DEFTAB' value='community'/>
<jsp:param name='Dummy_ph' value='' /></jsp:include>

<%
request.setAttribute("type","event");
String rollercontext=(application.getInitParameter("rollercontext")!=null)?application.getInitParameter("rollercontext"):"/roller";
String act=request.getParameter("act");
String type=(String)request.getAttribute("type");

String userid="";
Authenticate authData=AuthUtil.getAuthData(pageContext);
if(authData !=null){
userid=authData.getUserID();

}
request.setAttribute("userid",userid);
String userthemecode=DbUtil.getVal(USERTHEMEQUEY, new String[]{userid,"event",request.getParameter("GROUPID"),userid,"event",request.getParameter("GROUPID")});


boolean dispmaintemplate=true;
boolean displayeditblock=false;
boolean displayconfirm=false;
boolean displayeditcssblock=false;
boolean displayeditdatablock=false;
if ("editcss".equals(act))
displayeditcssblock=true;
if ("editdata".equals(act))
displayeditdatablock=true;




if(dispmaintemplate ){
%>
<%--

if("removecss".equals(act) || "removedata".equals(act) ){
	displayconfirm=true;
	dispmaintemplate=false;
}

if("editcss".equals(act) || "editdata".equals(act) ){
	displayeditblock=true;
	dispmaintemplate=false;
}
--%>

<table width='100%'  cellspacing="0" cellpadding="0">



<form name="geturllifestyle" method="post"  action="/mytasks/savetheme.jsp">
		
<tr class='colheader'>
        <td width="20%">Name</td>
        <td width="70%">Description</td>
        <td width="5%">Edit</td>
        <!--td width="5%" Remove--><!--/td-->
    </tr>
<tr class="evenbase"><td >CSS</td>
            <td>Theme CSS style sheet</td>
            <td class="center">
               <a href="/portal/mytasks/custommytheme.jsp?type=<%=request.getAttribute("type")%>&evtname=<%=request.getParameter("evtname")%>&stype=template&act=editcss&GROUPID=<%=request.getParameter("GROUPID")%>&themeid=<%=request.getParameter("themeid")%>"><img src='/home/images/Edit16.png' border="0" alt="icon" /></a>
            </td>
 	
            <td class="center">

             <%--  <a href="/portal/mytasks/custommytheme.jsp?type=<%=request.getAttribute("type")%>&stype=template&act=removecss&evtname=<%=request.getParameter("evtname")%>&GROUPID=<%=request.getParameter("GROUPID")%>&themeid=<%=request.getParameter("themeid")%>"><img src='/home/images/Remove16.gif' border="0" alt="icon" /></a>--%>
            </td></tr>
    
<tr class="oddbase"><td >HTML</td>
            
            <td>Theme HTML data</td>

            
            <td class="center">
               <a href="/portal/mytasks/custommytheme.jsp?type=<%=request.getAttribute("type")%>&stype=template&act=editdata&evtname=<%=request.getParameter("evtname")%>&GROUPID=<%=request.getParameter("GROUPID")%>&themeid=<%=request.getParameter("themeid")%>"><img src='/home/images/Edit16.png' border="0" alt="icon" /></a>
            </td>
 	
            <td class="center">

     <%--          <a href="/portal/mytasks/custommytheme.jsp?type=<%=request.getAttribute("type")%>&stype=template&act=removedata&GROUPID=<%=request.getParameter("GROUPID")%>&themeid=<%=request.getParameter("themeid")%>"><img src='<%=rollercontext%>/images/Remove16.gif' border="0" alt="icon" /></a>--%>
            </td></tr>
	    <%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>	
</form>
</table>

<%
}
%>


<%
if(displayeditcssblock ){
String editedcontent="themecontent";
if("editcss".equals(act))editedcontent="css";
%>
		<table width='100%'  cellspacing="0" cellpadding="0">
		
		<!--a href="/portal/customevents/customthemetemplate.jsp?type=<%=request.getAttribute("type")%>&stype=template&act=editcss&GROUPID=<%=request.getParameter("GROUPID")%>"><img src='<%=rollercontext%>/images/Edit16.png' border="0" alt="icon" /></a-->
		
		
		<form name="edit" method="post" action="/customevents/themecontroller.jsp">
		<input type='hidden' name='frompage' value='eventpages' />
		<input type='hidden' name='evtname' value='<%=request.getParameter("evtname") %>'  />	
		<input type='hidden' name='theme' value='<%=userthemecode %>' />
		<tr><td align='center'>
		<textarea name='editcontent' rows='30' cols='80'><%=DbUtil.getVal("select cssurl from user_customized_themes where themeid=?", new String[]{request.getParameter("themeid")})%></textarea>

		</td></tr>
		<tr><td align='center'>
		<input type='submit' name='submit' value='Submit' />
		</td></tr>
		
		<input type='hidden' name='formname' value="mytheme" />
		<input type='hidden' name='type' value="<%=type %>" />
		<input type='hidden' name='act' value="<%=act %>" />
		<input type="hidden" name="themeid" value="<%=request.getParameter("themeid")%>"/>
		<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>	
		</form>

		
		</table>

<%
}
%>

<%
if(displayeditdatablock ){
String editedcontent="themecontent";
if("editdata".equals(act))editedcontent="editdata";
%>
		<table width='100%'  cellspacing="0" cellpadding="0">
		<form name="edit" method="post" action="/customevents/themecontroller.jsp">
		<input type='hidden' name='frompage' value='eventpages' />
		<input type='hidden' name='evtname' value='<%=request.getParameter("evtname") %>'  />	
		<input type='hidden' name='theme' value='<%=userthemecode %>' />
		<tr><td align='center'>
		<textarea name='editcontent' rows='30' cols='80'><%=DbUtil.getVal("select content from user_customized_themes where themeid=?", new String[]{request.getParameter("themeid")})%></textarea>

		</td></tr>
		<tr><td align='center'>
		<input type='submit' name='submit' value='Submit' />
		</td></tr>
		
		<input type='hidden' name='formname' value="mytheme" />
		<input type='hidden' name='type' value="<%=type %>" />
		<input type='hidden' name='act' value="<%=act %>" />
		<input type="hidden" name="themeid" value="<%=request.getParameter("themeid")%>"/>
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
		<form name="edit" method="post" action="/customevents/themecontroller.jsp" >
		<input type='hidden' name='frompage' value='eventpages' />
		<input type='hidden' name='theme' value='<%=userthemecode %>' />
		<input type='hidden' name='evtname' value='<%=request.getParameter("evtname") %>'  />	
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
