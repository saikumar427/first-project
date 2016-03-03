<%@ page import="java.util.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>
<jsp:include page="/stylesheets/CoreRequestMap.jsp" />
<% 

Authenticate authData=AuthUtil.getAuthData(pageContext);//(Authenticate)session.getAttribute(ContextConstants.AUTH_DATA_OBJ);
String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";
String purpose=request.getParameter("purpose");
String groupid=request.getParameter("groupid");
String grouptype=request.getParameter("grouptype");
String eunitid=request.getParameter("UNITID");
String message="";
String clubname="";
String customloginscreen=DbUtil.getVal("select value  from community_config_settings where clubid=? and key='LOGIN_PAGE_SHOW_EVENTBEE_SIGNUP'", new String [] {request.getParameter("GROUPID")});

String id=request.getParameter("id");
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"listauth.jsp","Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null")+", purpose: "+purpose,"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
if(eunitid==null || "null".equals(eunitid) || "".equals(eunitid.trim())) eunitid="13579";
String url="";

	if("classified".equals(purpose)||"volunteer".equals(purpose)){
		if(groupid==null)
			groupid=request.getParameter("GROUPID");
		if(grouptype==null)
			grouptype=request.getParameter("GROUPTYPE");
			url=appname+"/classifieds/enterclassifieddetails.jsp?GROUPID="+groupid+"&GROUPTYPE="+grouptype+"&purpose="+purpose+"&PS="+request.getParameter("PS");
		if("clubview".equals(request.getParameter("PS")))
		{
			if(!("Yes".equalsIgnoreCase(request.getParameter("ishubmem"))))
			url=appname+"/classifieds/classifiedmessage.jsp?GROUPID="+groupid;
		}
	}else if("editclassified".equals(purpose))
		url=appname+"/classifieds/showmyvolunteer.jsp?classifiedid="+request.getParameter("classifiedid");
	else if("listevt".equals(purpose)){
		HashMap partnerevtmap=(HashMap)session.getAttribute("PARTNER_EVENT_LISTING_ATTRIBS");
		if(partnerevtmap!=null)
			session.removeAttribute("PARTNER_EVENT_LISTING_ATTRIBS");
		HashMap networkevtmap=(HashMap)session.getAttribute("NETWORK_EVENTLIST_ATTRIBS");
		if(networkevtmap!=null)
			session.removeAttribute("NETWORK_EVENTLIST_ATTRIBS");
			
		url=appname+"/mytasks/addevent.jsp?isnew=yes";
		
	}	
	else if("addagent".equals(purpose)){
	  	url=appname+"/mytasks/agentcomm.jsp?&GROUPID="+request.getParameter("GROUPID")+"&isnew=yes&setid="+request.getParameter("setid");
		message="login.header.message";
		
		}
	else if("addsponsor".equals(purpose)){
		url="/portal/sponsorregistrations/registration.jsp?GROUPID="+request.getParameter("GROUPID")+"&sponsorid="+request.getParameter("sponsorid");
		message="login.header.message";
	
	}
		
	else if("createhub".equals(purpose))
		url=appname+"/mytasks/addclub.jsp?isnew=yes&UNITID="+eunitid;
	else if("invitetohub".equals(purpose))
		url=appname+"/mytasks/clubInviteFriends.jsp?invitedid="+request.getParameter("invitedid");
	else if("invitetoevent".equals(purpose))
		url=appname+"/mytasks/eventinvitefriend.jsp?invitedid="+request.getParameter("invitedid");
	else if("eventrsvp".equals(purpose))

	{     
	
	//	String evttype=request.getParameter("evttype");
	//	if (evttype==null) evttype="event";
		url=appname+"/mytasks/eventrsvp.jsp?PS="+request.getParameter("PS")+"&GROUPID="+request.getParameter("GROUPID");
	//	url=appname+"/eventregister/eventrsvp.jsp?"+request.getQueryString();

	}
	else if("guestbook".equals(purpose))
		url=appname+"/guestbook/GBookAuth.jsp?userid="+request.getParameter("userid");
	else if("mycontact".equals(purpose))
		url=appname+"/mytasks/NuserRequestFriend.jsp?tofriendid="+request.getParameter("tofriendid");
	else if("sendsms".equals(purpose)){
		String to=request.getParameter("to");
		to=(to==null || "".equals(to.trim()) || "null".equals(to))?"":"&to="+to;
		 url=appname+"/mytasks/profilemessage.jsp?GROUPID="+request.getParameter("GROUPID")+"&forumid="+request.getParameter("forumid")+"&topicid="+request.getParameter("topicid")+"&msgto="+request.getParameter("msgto")+to+"&totype=Userid&type=Messages";
	}
	
	else if("sendmessage".equals(purpose)){
			String to=request.getParameter("to");
			to=(to==null || "".equals(to.trim()) || "null".equals(to))?"":"&to="+to;
			 url=appname+"/mytasks/sendmessage.jsp?GROUPID="+request.getParameter("GROUPID")+"&forumid="+request.getParameter("forumid")+"&topicid="+request.getParameter("topicid")+"&msgto="+request.getParameter("msgto")+to+"&totype=Userid&type=Messages";
	}
	
	else if("editprofile".equals(purpose))
		url=appname+"/mytasks/mysettings.jsp";
	else if("FORUM_ADD_TOPIC".equals(purpose)){
		String isnew=("yes".equalsIgnoreCase(request.getParameter("isnew")))?"&isnew="+request.getParameter("isnew")+"":"";
		url=PageUtil.appendLinkWithGroup(appname+"/mytasks/entertopicinfo.jsp?forumid="+request.getParameter("forumid")+isnew,(HashMap) request.getAttribute("REQMAP"));
		clubname=DbUtil.getVal("select clubname from clubinfo where clubid=?",new String[]{request.getParameter("GROUPID")});
	}else if("FORUM_REPLY_TOPIC".equals(purpose)){
		url=request.getParameter("redirecturl");
		url=url.replaceAll("~","&");
	}else if("myalerts".equals(purpose)){
		url=appname+"/mytasks/alert.jsp";
	}else if("myguestbook".equals(purpose)){
		url=appname+"/guestbook/GBookManage.jsp";
	}else if("mymessages".equals(purpose)){
		url=appname+"/club/ClubMessagingBeelet.jsp";
	}else if("mynetwork".equals(purpose)){
		url=appname+"/mytasks/Network.jsp";
	}else if("myclubs".equals(purpose)){
		url=appname+"/mytasks/myhubs.jsp";
	}
	else if("postcomment".equals(purpose)){
		url=appname+"/comments/responseToLog.jsp?logid="+request.getParameter("logid")+"&fromuser="+request.getParameter("fromuser");
	}else if("postlog".equals(purpose)){
		url=appname+"/comments/entercommentdetails.jsp";
	}else if("reviewfeedback".equals(purpose)){
		url=appname+"/comments/reviewfeedback.jsp?logid="+request.getParameter("logid")+"&option="+request.getParameter("option");
	}else if("writereview".equals(purpose)){
		url=appname+"/comments/entercommentdetails.jsp?purpose=writereview&logid="+request.getParameter("logid");
	}else if("FORUM_EMAIL_REDIRECT_URL".equals(purpose)){
		url=PageUtil.appendLinkWithGroup(appname+"/discussionforums/logic/showForumTopics.jsp?forumid="+request.getParameter("forumid"),(HashMap)request.getAttribute("REQMAP"));
	}else if("photocomment".equals(purpose)||"membercomment".equals(purpose)){
		url=appname+"/mytasks/responseToLog.jsp?logid="+request.getParameter("logid")+"&fromuser="+request.getParameter("fromuser")+"&position="+request.getParameter("position")+"&purpose="+purpose+((request.getParameter("albumid")!=null)?"&albumid="+request.getParameter("albumid"):"");
	}else if("postphotolog".equals(purpose)){
		url=appname+"/mytasks/enterphotolog.jsp";
	}else if("listservice".equals(purpose)){
		url=appname+"/services/addservice.jsp?isnew=yes";
	}else if("postfeedback".equals(purpose)){
		url=appname+"/services/postfeedback.jsp?GROUPID="+request.getParameter("GROUPID");
	}else if("joinhub".equals(purpose)){
	    url=appname+"/guesttasks/hubjoin.jsp?GROUPID="+request.getParameter("GROUPID");
		message="desimembership.needed.message";
		clubname=DbUtil.getVal("select clubname from clubinfo where clubid=?",new String[]{request.getParameter("GROUPID")});
	}else if("listblog".equals(purpose)){
		url=appname+"/blog/createblog.jsp";
	}else if("createblog".equals(purpose)){
		url=appname+"/eroller/createblog.jsp";

	}else if("memberrenewal".equals(purpose)){
		groupid=request.getParameter("GROUPID");
		url="/portal/guesttasks/renewMembership.jsp?GROUPID="+groupid;
	}else if("uploadphoto".equals(purpose)){
		groupid=request.getParameter("GROUPID");
		url="/portal/mytasks/uploadphotos.jsp?isnew=yes&type=Photos";
	}else if("createalbum".equals(purpose)){
		url="/portal/mytasks/createalbums.jsp?type=Photos&albumid=0&isnew=yes";
	}
	else if("addmyphotos".equals(purpose)){
		groupid=request.getParameter("GROUPID");
		url="/portal/mytasks/myphotos.jsp?isnew=yes&type=Photos";
	}
	else if("createcampaign".equals(purpose)){
		url=appname+"/fundraising/addcampaign.jsp?purpose=createcampaign&GROUPID="+request.getParameter("GROUPID");
				
	}
	else if("joinprogram".equals(purpose)){
		url=appname+"/mytasks/joinpartner.jsp?purpose=joinprogram&UNITID="+eunitid+"&isnew=yes";
	}
	else if("leavepartner".equals(purpose)){
		url=appname+"/ningapp/leavepartnerprog.jsp?purpose=leavepartner&partnerid="+request.getParameter("partnerid");
	}
	
	else if("eventmanage".equals(purpose)){
			url=appname+"/mytasks/eventmanage.jsp?purpose=eventmanage&groupid="+request.getParameter("groupid");
		}
	
	
	
if(url.indexOf("?")<0)
	url=url+"?ttt="+(new java.util.Date()).getTime();
else
	url=url+"&ttt="+(new java.util.Date()).getTime();

if (authData!=null){
	response.sendRedirect(url);
	return;
}else if(authData==null&&"yes".equals(id)){

		HashMap hm=new HashMap();
		hm.put("redirecturl",url);
		session.setAttribute("BACK_PAGE",purpose);
		session.setAttribute("REDIRECT_HASH",hm);
		
		if("N".equals(customloginscreen)){
		    request.setAttribute("BACK_PAGE",purpose);
	
	    %>
      	<jsp:forward page='/guesttasks/custompersonalInfo.jsp' >
		<jsp:param name='isnew' value='yes' />
		<jsp:param name='entryunitid' value='13579' />
		<jsp:param name='UNITID' value='13579' />
		<jsp:param name='clubname' value='<%=clubname%>' />
		
		
		
		</jsp:forward>
		
		<%}else{%>
		
		<jsp:forward page='/guesttasks/checkhubauthentication.jsp' >
		<jsp:param name='isnew' value='yes' />
		<jsp:param name='message' value="<%=message%>"/>
		<jsp:param name='clubname' value='<%=clubname%>' />
		</jsp:forward>

<%}
}else{
	HashMap hm=new HashMap();
	hm.put("redirecturl",url);
	session.setAttribute("REDIRECT_HASH",hm);
		
		if("N".equals(customloginscreen)){
		request.setAttribute("BACK_PAGE",purpose);
	
	%>
	<jsp:forward page='/guesttasks/customhublogin.jsp' >
		<jsp:param name='isnew' value='yes' />
		<jsp:param name='clubname' value='<%=clubname%>' />
		<jsp:param name='msgto' value='<%=request.getParameter("msgto")%>' />
		
		</jsp:forward>
		
		<%}else{
			session.setAttribute("BACK_PAGE",purpose);
		%>
			
			<jsp:forward page='/guesttasks/checkauthentication.jsp' />
			
			
	   
<%          }  
}
%>






