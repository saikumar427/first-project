<%@ page import="com.eventbee.general.*,java.util.*" %>
<%!
	String [] navs=new String []{"My Eventbee","My Email Marketing","My Public Pages","My Themes",
							"My Settings","Partner Network"};
		
	String [] subtabs=new String []{"My Console","My Email Marketing","My Public Pages","My Themes",
							"My Settings","Network Ticket Selling"};
	String [] FeatureImage=new String []{"","","","",
							"","/home/images/new.gif"};
	HashMap navmap=new HashMap();
	void getNavMap(){
		String serveraddress="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");
		navmap.put("My Eventbee",serveraddress+"/mytasks/myevents.jsp");
		navmap.put("My Email Marketing",serveraddress+"/mytasks/marketing.jsp");
		navmap.put("My Settings",serveraddress+"/mytasks/mysettings.jsp?isnew=yes");
		navmap.put("My Themes",serveraddress+"/mytasks/mythemes.jsp");
		navmap.put("Partner Network",serveraddress+"/mytasks/networkticketsellingpage.jsp");
		navmap.put("My Public Pages",serveraddress+"/mytasks/publicpages.jsp");
	}
%>

<%
     if(request.getAttribute("CustomLNF_Type")==null){

     
	if(com.eventbee.general.AuthUtil.getAuthData(pageContext) !=null){
		if(navmap.isEmpty()) getNavMap();
		int navslength=navs.length;
%>
		<table width='100%' border='0' cellpadding='0' cellspacing='0'  valign='top' bgcolor='#FFFFFF' >
		<tr> <td  align='left' valign='top'>
<%		
        
		for(int i=0;i<navs.length;i++){
%>			
			
			<table cellpadding='5' cellspacing='0' align='left' border='0'>
			<tr>
			<td valign='center' align='left'><a STYLE='text-decoration:none'  href='<%=navmap.get(navs[i])%>'> 
            <span class='menufont'><%=navs[i]%></span>
            </a></td>
 <%     
			if(!"".equals(FeatureImage[i]))
				out.println("<td align='center'><img src='"+FeatureImage[i]+"'/></td>");
			if(subtabs[i].equals((String)request.getAttribute("mtype")) )
				out.println("<td align='center'><img src='/home/images/pointervertical.gif'/></td>");
			if(i !=navslength-1 )
		  		out.println("<td> &nbsp;|&nbsp;</td>");
%>
		  </tr>
		  </table>
<%
		}
%>
		</td>
		</tr>
		<tr height='2' bgcolor='blue' ><td colspan='20'></td></tr>
		</table>
<%		
     }else{
%>
		<table width='1' border='0' cellpadding='0' cellspacing='0' >
		<tr><td ></td></tr>
		</table>
<%
 	}
 	
 }	
%>


