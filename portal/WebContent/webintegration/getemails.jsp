<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.eventbee.invitedemails.InvitedEmailDB"%>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbeepartner.partnernetwork.PartnerLinks"%>

<%
	PartnerLinks pl=new PartnerLinks(); 
	String toid= request.getParameter("emailsString");
	String message=request.getParameter("message");
	String[] chxbox=request.getParameterValues("chxbox");
	
	if(chxbox!=null)
	{
	    chxbox=request.getParameterValues("chxbox");	
	try
		{
	     for(int i=0; i<chxbox.length ; i++)
			 {		 
				toid=toid+","+chxbox[i];
				toid=GenUtil.traverseString(toid.trim()," ","");
				toid=GenUtil.traverseString(toid,",,",",");	
			 }
		}
	catch(Exception e)
		{
			System.out.println("error occured::::::::::"+e.getMessage());
		}	
	}
	
	String emails[]=GenUtil.strToArrayStr(toid,",");
	String userid="";
	Authenticate authData=AuthUtil.getAuthData(pageContext);
	if(authData!=null){
		userid= authData.getUserID();
	}
	
	String email=DbUtil.getVal("select email from user_profile where user_id=?",new String[]{userid});
	pl.SendEmail(emails,email,message);
		
	
out.print("<data>success</data>");

%>

