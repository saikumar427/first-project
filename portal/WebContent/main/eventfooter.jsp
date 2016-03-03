<%@ page import="com.eventbee.general.*" %>
<%@ include file="../getresourcespath.jsp" %>

<%
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");
/* String footerwidth="840";
	if("FB".equals(request.getParameter("context")) ){
		footerwidth="777";
	}
	
	
	
if("ning".equals((String)session.getAttribute("platform"))){

footerwidth="500";
} */
	
StringBuffer sb=new StringBuffer();



       if(request.getAttribute("CUSTOM_FOOTER")!=null && !"".equals(request.getAttribute("CUSTOM_FOOTER"))){%>
		<div  id='footer' >
		<%=(String)request.getAttribute("CUSTOM_FOOTER")%>
		</div>

	<%}
	
		
	
	
	else{
	
	  if("ning".equals((String)session.getAttribute("platform"))){
  %>
	   <%@ include file='/ningapp/ticketing/footer.jsp'%>
	 
	   
	 <%  }
        else{
	
	
	
		sb.append("<div  id='footer' >");
		sb.append("<table align='center' cellpadding='5'>");
	  	sb.append("<tr>");
	    if("FB".equals(request.getParameter("context")) ){
	    	    sb.append("<td align='left' valign='middle' width='10%'>");

	    sb.append("<img src='"+resourceaddress+"/home/images/poweredby.jpg' border='0'/></td>");
	    sb.append("<td align='left' valign='middle'>");
	    	    sb.append("<p><span class='small'>Powered"
	    	        		+" by Eventbee - Your Online Registration, Event Promotion and Membership Management"
	    					+"<br/>solution. For more information "
	    					+"send an email to support at eventbee.com</span></p>");
		
	    }else{
	    	    sb.append("<td align='left' valign='middle'>");

	    sb.append("<a href='"+serveraddress+"'><img src='"+resourceaddress+"/home/images/poweredby.jpg' border='0'/></a></td>");
	      sb.append("<td align='left' valign='middle'>");
	    	    sb.append("<span class='small'>Powered"
	    	        		+" by Eventbee - Your Online Registration, Membership Management and Event <br/>Promotion"
	    					+" solution. For more information, "
	    					+"send an email to support at eventbee.com</span>");
		
	    }
	    sb.append("</td></tr>");
		sb.append("</table>");
		sb.append("</div>");
		}
		request.setAttribute("BASICEVENTFOOTER",sb.toString());
	}
	
	
	
	
	
	
%>	
	

