<%@ page import="java.util.*,com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.customconfig.*,com.eventbee.profiles.ProfileDB" %>
<%@ page import='java.net.*,java.io.*' %>
<%
  boolean redirect=false;
if(request.getParameter("logout") !=null){
	
	if (request.getParameter("rollerlogout") ==null){
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"community.jsp","Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+",logout time: "+(new java.util.Date()).toString(),null);
	
	%>
		<jsp:forward page='logout.jsp' />
	<%
	}else{
		redirect=true;
		String rollercontext=(application.getInitParameter("rollercontext")!=null)?application.getInitParameter("rollercontext"):"/roller";
		
		response.sendRedirect(rollercontext+"/roller-ui/logout-redirect.jsp");
		
	
	
	}// end of both roller and desihub logout
}


if(request.getParameter("submit")!=null){
      AuthDB authDB=new AuthDB();
              Authenticate au=authDB.authenticateMember(request.getParameter("name"), request.getParameter("password"),"13579");
		    if(au !=null){
	      	session.setAttribute("authData",au);
			String authid=au.getUserID();
			
			Cookie cookie1 = new Cookie("SESSION_TRACKID",authid+"~"+session.getId()+"~"+(InetAddress.getLocalHost() ).getHostName()+"~"+(new java.util.Date()).toString());
			response.addCookie(cookie1);
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"Community.jsp","SESSION_TRACKID for Authid: "+authid+" is: "+authid+"~"+session.getId()+"~"+(InetAddress.getLocalHost() ).getHostName()+"~"+(new java.util.Date()).toString(),"sessionid: "+session.getId()+",login time: "+(new java.util.Date()).toString(),null);
			
			
			
			if(((String)session.getAttribute(authid+"PROFILEINSERT"))==null){
				HashMap hm=new HashMap();
				hm.put("userid",authid);	
				hm.put("sid",session.getId());
				int logincount=ProfileDB.insertLoginDetails(hm);
				session.setAttribute(authid+"PROFILEINSERT","Y");
			}

		
			String BACK_PAGE=(String)session.getAttribute("BACK_PAGE");
			if(("".equals(BACK_PAGE))||(BACK_PAGE==null)) {%>
			
				<jsp:forward page='/mytasks/myevents.jsp' />
			<%
		}else{
			response.sendRedirect("/portal/networking/redirectnetwork.jsp");
			redirect=true;
		}
}else{
	      	//in valid login
		      request.setAttribute("error",EbeeConstantsF.get("invalidlogin.message","Invalid Login") );
	      %>

		      <jsp:forward page='/guesttasks/communitycontent.jsp' />
			  
			  
			  
			  
<%
}
}
if(!redirect){
	if("home".equals(request.getParameter("FP")  )    ){
		%>
		
		  <jsp:forward page='home.jsp' />
		<%
	}else{ 
	
	%>
		<% if(com.eventbee.general.AuthUtil.getAuthData(pageContext) ==null ) { %>
			<jsp:forward page='/guesttasks/authpagetest.jsp' />
	
		<%}else{%>
			<jsp:forward page='/mytasks/myevents.jsp' />
			
	<%}
	}
}%>
