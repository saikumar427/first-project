<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.eventbee.forum.ForumDB" %>
<%@ page import="java.util.*" %>
<%!
  final static String FILE_NAME="discussionforums/logic/insertDFMessages.jsp";
%>  
<%
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"insertDFMessage.jsp","Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
  	HashMap localParams=new HashMap();
	String message="";
	int res=0;	
        String forthpage="";
	String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";
	String source=request.getParameter("source");  
	   EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,FILE_NAME,"Topic/Message: "+source,EventbeeLogger.LOG_START_PAGE,null);
	   
	   if(validateData(pageContext,localParams)){
	   
	   	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,FILE_NAME,"Topic/Message: "+source,"Exited at ValidateData function",null);
		response.sendRedirect(PageUtil.appendLinkWithGroup(appname+"/mytasks/"+source,localParams));
	   }else if("Edit".equalsIgnoreCase(request.getParameter("submit"))){
	   	response.sendRedirect(PageUtil.appendLinkWithGroup(appname+"/mytasks/entermsginfo.jsp",localParams));
	   }else if("Preview".equalsIgnoreCase(request.getParameter("submit"))){
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,FILE_NAME,"Topic/Message: "+source,"Exited-Priview",null);
		response.sendRedirect(PageUtil.appendLinkWithGroup(appname+"/mytasks/previewmsginfo.jsp",localParams));
	   }else{
	  	String topic=GenUtil.getHMvalue(localParams,"topicid");
		String forum=GenUtil.getHMvalue(localParams,"forumid");
		String msgid=GenUtil.getHMvalue(localParams,"parentid");
		String oldmsgid=GenUtil.getHMvalue(localParams,"oldmsgid");
		String parentThreadid=GenUtil.getHMvalue(localParams,"parentThreadid");	  
		
	  	if("0".equals(msgid)){
			forthpage=appname+"/guesttasks/showForumTopics.jsp?forumid="+forum;
		}else{
		  forthpage=appname+"/guesttasks/showTopicMessages.jsp?forumid="+forum+"&topicid="+topic;
		  if(isValidId(oldmsgid))
			forthpage+="&msgid="+oldmsgid;
		  if(isValidId(parentThreadid))
			forthpage+="&parentThreadid="+parentThreadid;
		}
		res=ForumDB.insertDiscForumMsg(localParams);
		 session.removeAttribute("fmsghash");
		 session.removeAttribute("errorvector");
		 if(res>0) message="Topic/Message posted successfully";
		 EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,FILE_NAME,message,EventbeeLogger.LOG_END_PAGE,null);
		 response.sendRedirect(com.eventbee.general.PageUtil.appendLinkWithGroup(forthpage,localParams));
       }
%>
  <%!
    public boolean isValidId(String id){
	    if(id==null || "null".equals(id) || "".equals(id.trim()))
		    return false;
	    else
		    return true;
    }		
    public boolean validateData(PageContext pctx,HashMap localParams){
    		HttpServletRequest req=(HttpServletRequest) pctx.getRequest();
		HttpSession session=pctx.getSession();
		boolean  flag=false;
		String subject=null,reply=null;
	    	java.util.Vector errorvector=new java.util.Vector();
	
		subject=req.getParameter("subject").trim();
	        reply=req.getParameter("reply");
		
		if(reply==null){
			reply=(String) session.getAttribute("FORUM_REPLY");
			if(reply==null) reply="";
		}else{
			reply=reply.trim();
		}

		if(subject.length()==0){
			flag=true;
			errorvector.add("Subject should not be empty");
		}else if(subject.length()>100){
			flag=true;
			errorvector.add("Subject should not exceed 100 characters");
		}

		if(reply.length()==0){
			flag=true;
			errorvector.add("Message should not be empty");
		}else if(reply.length()>10000){
			flag=true;
			errorvector.add("Message should not exceed 10000 characters");
		}
		localParams.put("subject",subject);
		localParams.put("reply",reply);
	
			localParams.put("postedby", req.getParameter("authid"));
			localParams.put("forumid", req.getParameter("forumid"));
			
			localParams.put("parentid",req.getParameter("parentid"));
			localParams.put("oldmsgid",req.getParameter("oldmsgid"));
			localParams.put("topicid",req.getParameter("topicid"));
			localParams.put("parentThreadid",req.getParameter("parentThreadid"));
			localParams.put("postedbytype", req.getParameter("postedbytype"));
			localParams.put("GROUPID", req.getParameter("GROUPID"));
			localParams.put("UNITID","13579");
			localParams.put("GROUPTYPE", req.getParameter("GROUPTYPE"));
			localParams.put("PS", req.getParameter("PS"));
			localParams.put("evttype",req.getParameter("evttype"));
		
			session.setAttribute("fmsghash",localParams);
			session.setAttribute("errorvector",errorvector);
		return flag;
	}
%>
