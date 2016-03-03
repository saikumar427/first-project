	<%@ page import="com.eventbee.general.*" %>

	
	<table border='0' cellpadding='0' cellspacing='0' width=='100%' valign='center'>
	<tr><td colspan='2' height='15'></td></tr>
		<tr><td colspan='2' height='30' align='center'>
			
			
			
			<%
				Object status_code = request.getAttribute("javax.servlet.error.status_code");
				
				Object request_uri = request.getAttribute("javax.servlet.error.request_uri");
				
				Object message = request.getAttribute("javax.servlet.error.message");
				
				if( status_code !=null   ){
				
					String statuscodestr=status_code.toString();
					
					if("404".equals(statuscodestr) ){
						out.println( " Invalid request "+request_uri);					
					}else if("400".equals(statuscodestr) ){
						out.println( " Invalid request "+request_uri);					
					}
					
				}
				
				
				
				
				Object error_type = request.getAttribute("javax.servlet.error.exception_type");
				
				if(error_type !=null){
					Throwable throwable = (Throwable) request.getAttribute("javax.servlet.error.exception");
					EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"invalidrequesthandler.jsp","Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+",time: "+(new java.util.Date()).toString(),null);
					EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, "invalidrequesthandler.jsp", "in service got exception", "\nmessage="+message+"\n"+request_uri, throwable) ;
					out.println("Sorry this request cannot be processed at this time");
				}
				
				
				
				

			
			
			%>
			
			
		</td></tr>
	<tr><td colspan='2' height='15'></td></tr>
	</table>

