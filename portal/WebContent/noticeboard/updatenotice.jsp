<%@page import="java.util.*" %>
<%@page import="com.eventbee.noticeboard.*"%>
<%@page import="com.eventbee.general.*"%>
<jsp:include page='/auth/checkpermission.jsp'>
	<jsp:param name='authtype' value='noticeupdate' />
<jsp:param name='Dummy_ph' value='' /></jsp:include>
<%
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"updatenotice.jsp","Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
        String message="";
	String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";
	HashMap localParams=new HashMap();
	if(validateData(request,session,localParams)){
	  response.sendRedirect(PageUtil.appendLinkWithGroup(appname+"/noticeboard/shownoticeinfo.jsp",localParams));
	 }else{
          int rset=NoticeboardDB.updateNotice(request.getParameter("noticeid"), request.getParameter("notice"));
	  message=EbeeConstantsF.get("hub.notice.update.message","Successfully updated");
	  //message="Successfully updated";
	  session.removeAttribute("noticehash");
	  session.removeAttribute("noticeerrorvector");
	  response.sendRedirect(PageUtil.appendLinkWithGroup(appname+"/noticeboard/notice.jsp?message="+message,localParams));
	} 
%>
<%!
    public boolean validateData(HttpServletRequest req, HttpSession session,HashMap noticehash){
	boolean  flag=false;
	String notice=null;
	String noticetype=null;

    	Vector errorvector=new Vector();
	if(noticehash==null) noticehash=new HashMap();

	notice=req.getParameter("notice").trim();
	noticetype=req.getParameter("noticetype");
	
        noticehash.put("notice",req.getParameter("notice"));
        noticehash.put("noticetype",noticetype);
	noticehash.put("noticeid",req.getParameter("noticeid"));
	noticehash.put("GROUPID",req.getParameter("GROUPID"));
	noticehash.put("GROUPTYPE",req.getParameter("GROUPTYPE"));
	//noticehash.put("UNITID",req.getParameter("UNITID"));
	noticehash.put("PS",req.getParameter("PS"));

		if(notice.length()==0){
			flag=true;
			errorvector.add("Notice is empty");
		}else if(notice.length()>1000){
			flag=true;
			errorvector.add("Notice exceeded 1000 characters");
		}
	session.setAttribute("noticehash",noticehash);
	session.setAttribute("noticeerrorvector",errorvector);
	 return flag;
	}
%>
