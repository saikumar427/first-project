<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.event.*,com.eventbee.authentication.*"%>
<%@ include file="/eventregister/includemethod.jsp" %>


<%
  String evtname=null;
  String serveraddress="http://"+EbeeConstantsF.get("serveraddress","")+"/";

  request.setAttribute("CustomLNF_Type","EventDetails");
request.setAttribute("CustomLNF_ID",request.getParameter("GROUPID"));
  
   
  if((String)session.getAttribute("evtname")!=null)
  	evtname=(String)session.getAttribute("evtname");
  else if((String)session.getAttribute("evtname")==null)
  	evtname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{request.getParameter("GROUPID")});
  
  String listurl=serveraddress+"event?eid="+request.getParameter("GROUPID");
  String evtlink="<a href='"+listurl+"'>"+evtname+"</a>";
   request.setAttribute("tasktitle",evtlink+" >   Login");
   
   /*###############   Code modified from /register/memberlogin.jsp 29 OCT 2007  ###################*/
   /*
      responce.sendRedirect is not working in included page. (Once page header loaded responce.sendredirect() method 
      is not working.)
   */
   
   String showlogin=null;
   showlogin=DbUtil.getVal("select showlogin from eventinfo where eventid=?",new String []{request.getParameter("GROUPID")});
   Authenticate au=AuthUtil.getAuthData(pageContext);
   if(au!=null){
			HashMap hm=new HashMap();
			hm=getRsvpDetails(request.getParameter("GROUPID"),au.getUserID());
			if(hm==null){
				hm=new HashMap();
				hm.put("userid",au.getUserID());
				hm.put("UNITID","13579");
				hm.put("fname",au.getFirstName());
				hm.put("lname",au.getLastName());
				hm.put("emailid",au.getEmail());
		   }
		   session.setAttribute(request.getParameter("GROUPID")+"_RSVP_EVENT",hm);
		  if("FB".equals(request.getParameter("context"))){
		   		response.sendRedirect("/guesttasks/eventrsvp.jsp?GROUPID="+request.getParameter("GROUPID")+"&isnew=yes&context=FB");
		   		return;
		   }else{ 
	        response.sendRedirect("/guesttasks/eventrsvp.jsp?GROUPID="+request.getParameter("GROUPID")+"&isnew=yes");
	        return;
	        }

      //GenUtil.Redirect(response,"/guesttasks/eventrsvp.jsp?GROUPID="+request.getParameter("GROUPID")+"&isnew=yes");

   }else if("No".equals(showlogin)|| showlogin==null){
		response.sendRedirect("/guesttasks/eventrsvp.jsp?GROUPID="+request.getParameter("GROUPID")+"&login=none&isnew=yes");
		return;
		//GenUtil.Redirect(response,"/guesttasks/eventrsvp.jsp?GROUPID="+request.getParameter("GROUPID")+"&login=none&isnew=yes");

	}else{		


  
  %>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/eventregister/memberlogin.jsp";
	footerpage="/main/eventfootermain.jsp";
%>
	      		
<%@ include file="/templates/taskpagebottom.jsp" %>

<%}%>
	

	