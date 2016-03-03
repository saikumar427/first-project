<%@page import="java.util.*" %>
<%@page import="com.eventbee.noticeboard.*"%>
<%@page import="com.eventbee.general.*"%>
<%@page import="com.eventbee.util.RequestSaver"%>
<jsp:include page='/auth/checkpermission.jsp'>
	<jsp:param name='authtype' value='<%=request.getParameter("PS")%>' />
<jsp:param name='Dummy_ph' value='' /></jsp:include>
<%
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"delnotice.jsp","Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
     String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";
     RequestSaver reqsave=new RequestSaver(pageContext);
     Map reqMap=reqsave.getReqMap();
     
     String noticeid[]=request.getParameterValues("noticeid");
     int rcount=0;
     if(noticeid!=null && noticeid.length>0)
	rcount=NoticeboardDB.deleteNotices(noticeid);
	String message=EbeeConstantsF.get("hub.notice.delete.message","Notice is empty");
	
	message=EbeeConstantsF.get("hub.notice.delete.message","rcount Notice(s) deleted");
	                        if(message.indexOf("rcount")!=-1){
	                        message=message.replaceAll("rcount",rcount+"");	
                        }
	
	//String message=rcount + " Notice(s) deleted";
        response.sendRedirect(PageUtil.appendLinkWithGroup(appname+"/mytasks/notice.jsp?message="+message+"&from="+request.getParameter("from")+"&pname="+request.getParameter("pname")+"&source="+request.getParameter("source"),(HashMap)reqMap));

%>
