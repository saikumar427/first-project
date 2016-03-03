<%@ page import="java.io.*, java.util.*,java.sql.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.authentication.*" %>

<%
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"pagecontentprefinal.jsp","Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
     HashMap pagemap=(HashMap)session.getAttribute("PAGE_HASH_NETWORK");
     Authenticate authData=AuthUtil.getAuthData(pageContext);
	if(authData !=null){
	     if(pagemap!=null){
			boolean excepFlag=false;
			String statement=request.getParameter("statement");
			String autoProcess=request.getParameter("autoProcess");
			String processStatement="";
			boolean conterror=false;
			String edittype="";
			processStatement =("text".equals(autoProcess))?GenUtil.textToHtml(statement,true):statement;
			pagemap.put("statement",statement);
			pagemap.put("processStatement",processStatement);
			pagemap.put("autoProcess",autoProcess);
			
			edittype= ("true".equals((String)pagemap.get("exists")))?"edit":"add";	
			response.sendRedirect("/portal/mytasks/nwpagecontentfinal.jsp?type=Snapshot&edittype="+edittype);
		
		}	
	}else{

	response.sendRedirect("/guesttasks/authenticateMessage.jsp");

	}
%>

