<%@ page import="java.io.*, java.util.*, com.eventbee.looknfeel.LooknFeel" %>
<%@ page import="com.eventbee.authentication.*,com.eventbee.general.*,org.eventbee.sitemap.util.LinksGenerator" %>
<%@ page import="com.eventbee.general.EbeeConstantsF" %>

<%
	String unitid=null;
	//if("/manager".equals(request.getContextPath()) )unitid="13579";
	//else
	//unitid=request.getParameter("UNITID");
	
	//if("13579".equals(unitid))
	session.setAttribute("fromcontext","No");
	//else 	session.setAttribute("fromcontext","Yes");
	
	String serveraddress="",sslserveraddress="";	
	serveraddress=(String)session.getAttribute("HTTP_SERVER_ADDRESS");
	
	String isproxy=request.getParameter("isProxy");			
	
	if("Y".equals(isproxy)){
		session.setAttribute("fromproxy","Yes");
	}
	
	
	if((serveraddress==null)||("".equals(serveraddress)))
	{
		String fromproxy=(String)session.getAttribute("fromproxy");	
		if("Yes".equals(fromproxy))
		{
			serveraddress=LinksGenerator.getServerAddress("13579",1);
			sslserveraddress=LinksGenerator.getServerAddress("13579",2);	
		}else{		
			serveraddress=LinksGenerator.getServerAddress("13579",4);
			sslserveraddress=LinksGenerator.getServerAddress("13579",5);
		}
		session.setAttribute("HTTP_SERVER_ADDRESS",serveraddress); 
		session.setAttribute("HTTPS_SERVER_ADDRESS",sslserveraddress); 
	}

	
	//System.out.println("in auth proxydetector.jsp");
	

%>
