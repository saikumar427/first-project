<%@ page import="com.eventbee.general.*" %>

<style>
.smallestfont { font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; font-weight: lighter; color: #666666}

</style>

<%
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");
StringBuffer sb=new StringBuffer();



       if(request.getAttribute("CUSTOM_FOOTER")!=null && !"".equals(request.getAttribute("CUSTOM_FOOTER"))){%>
		<div  id='footer' >
		<%=(String)request.getAttribute("CUSTOM_FOOTER")%>
		</div>

	<%}else{
		sb.append("<div>");
		sb.append("<table align='center' cellpadding='0' id='footer'>");
	  	sb.append("<tr>");
	    sb.append("<td  align='left' >");
	    sb.append("<a href='"+serveraddress+"'><img src='/home/images/poweredby.jpg' border='0'/></a></td>");
	    sb.append("<td align='left' >");
	    sb.append("<span class='smallestfont'>Powered"
	        		+" by Eventbee - Your Membership Management, Event Management and Community Building solution."
					+" <br/>For more information, please call "
					+"(408) 310 6768, or send email to support at eventbee.com</span>");
		sb.append("</td></tr>");
		sb.append("</table>");
		sb.append("</div>");
		
		request.setAttribute("BASICEVENTFOOTER",sb.toString());
	}
	
	
%>	
	

