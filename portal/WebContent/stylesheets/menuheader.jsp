
 
<%
	String ENTRYUNITID=(String) session.getAttribute("entryunitid");
	
	if(!"13579".equals(ENTRYUNITID)){
%>
 <link rel="stylesheet" href="http://www.beeport.com/home/index.css"/>
<%}%>

<%
	Authenticate menuauthData=(Authenticate)com.eventbee.general.AuthUtil.getAuthData(pageContext);
	
	if(menuauthData!=null && menuauthData.isActiveAccount()){
	HashMap[] tabs=getMemberTabs(ENTRYUNITID, menuauthData.getUserID());
	
	String tabAlign="left";
%>
 <table border='0' cellpadding='0' cellspacing='0' align='<%=tabAlign%>'>
 <tr>
<%
for(int i=0;i<tabs.length;i++){
	  if(tabs[i]!=null){
	   HashMap tabhm=tabs[i];
	   
	   //getTabURL  method is intoplnf 
%>
   <td width="120" height="25" class='tab4'>
   <a STYLE="text-decoration:none" href='<%=getTabURL((String)tabhm.get("taburl"), request.getParameter("punitid")   )%>'>
   <font size="-2" color="#FFFFFF"><%=tabhm.get("tabname")%></font>
   </a>
   </td>
	<%
	  }else{
	%>
	   <!--td width='60' height='25'></td-->
	<%
	  }
	%> 

<%
 }
%>   
 </tr>
 </table>
<%
}
%>
