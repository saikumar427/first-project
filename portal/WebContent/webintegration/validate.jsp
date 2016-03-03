<%@ page import="java.util.*,com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.eventbee.customconfig.*,com.eventbee.profiles.ProfileDB" %>
<%@ page import='java.net.*,java.io.*' %>
<%  
  boolean redirect=false;
	 AuthDB authDB=new AuthDB();
     Authenticate au=authDB.authenticateMember(request.getParameter("uname"),request.getParameter("upassword"),"13579");
				  //System.out.println("au is::::::::::"+au);

	      if(au !=null){
	    	session.setAttribute("authData",au);
			out.print("authenticated");
		  }
		  else
		  out.print("failure");
		  
		  
 %>
			