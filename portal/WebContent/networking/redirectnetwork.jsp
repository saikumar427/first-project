<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.general.GenUtil" %>

<%
   String url="";
   HashMap datahash=(HashMap)session.getAttribute("REDIRECT_HASH");
   url=(String)datahash.get("redirecturl");
   session.removeAttribute("REDIRECT_HASH");  
   session.removeAttribute("BACK_PAGE");
   response.sendRedirect(url);
%>
