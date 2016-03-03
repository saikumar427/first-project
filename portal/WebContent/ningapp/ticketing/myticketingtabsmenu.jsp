<%@ page import="com.eventbee.authentication.*,com.eventbee.general.*,java.util.*" %>
<%@ page import="com.eventbee.customconfig.MemberFeatures,com.eventbee.listmanagement.*" %>

<%!
String getSelectedMenu(String rmik, String tab){
String ret="";
if(rmik !=null){
ret=rmik.equals(tab)?"id='ebeemenuhighlightlink'":ret;
}
return ret;
}

%>



<%

String tabtype=(String)request.getAttribute("stype");
									

String tabclass="desitabcont mytab2";

String type=request.getParameter("type");

String [] mymenutabs={};
String [] mymenutabnames={};
String [] mymenutablinks={};

String [] mysubmenus={};
String [] mysubmenulinks={};
String mtype=(String)request.getAttribute("mtype");
String stype=(String)request.getAttribute("stype");
String ltype=(String)request.getAttribute("ltype");
String showtabs=(String)request.getAttribute("showtabs");
String GROUPID=request.getParameter("GROUPID");


if("Events".equalsIgnoreCase(mtype )  ){
 mymenutabs=new String[]{"Events"};
 mymenutabnames=new String[]{"Events"};
 mymenutablinks=new String[]{"/ningapp/eventstab"};

}




%>




<table height='10'><tr><td></td></tr></table>

<%
if(mymenutabs.length>0){

if(tabtype==null||"null".equals(tabtype))
tabtype=mymenutabs[0];

%>
<table width='100%'  cellspacing="0" cellpadding="0"  >
<tr>
 <td   align='left'  >
<%
	for(int i=0;i<mymenutabs.length;i++){
	    if(tabtype.equals(mymenutabs[i]))
		tabclass="desitabcont mytab1";
		else
		tabclass="desitabcont mytab2";
	
%>
	
	<span class="<%=tabclass %>" ><a href="<%=mymenutablinks[i]%>">
	<%=mymenutabnames[i] %></a></span>
<%
	}//end for
%>
					


</td></tr>
<tr class='tabhighlightcolor' id='ebeemenu'>
<td   height="20" align='left' id='linkstd'>
<%
	for(int i=0;i<mysubmenus.length;i++){
	
%>
	
	<span  <%=getSelectedMenu(mysubmenus[i],ltype) %>>	
	<a href='<%=mysubmenulinks[i]%>'><%=mysubmenus[i]%></a>
	<%if(i<mysubmenus.length-1){%>&nbsp;|&nbsp;<%}%>
	</span>
<%
	}//end for
%>
</td>	
</tr>
<div id="gap" height='10'></div>
<tr><td id='updatemembers'></td></tr>
</table>
<%}%>





