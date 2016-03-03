<%@ page import="java.io.*, java.util.*,java.sql.*,com.eventbee.general.EventbeeConnection" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.useraccount.*" %>
<%@ page import="com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.context.ContextConstants" %>





<%

EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"pagecontentmain.jsp","Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
	String userid=null;
	Authenticate authData=AuthUtil.getAuthData(pageContext);//(Authenticate)session.getAttribute("authData");		
		userid=authData.getUserID();		
		HashMap pagemap=new HashMap();
			String statement=DbUtil.getVal("select statement from user_profile where user_id=? ",new String[]{userid});
			String contenttype=DbUtil.getVal("select autoprocess from user_profile where user_id=?",new String[]{userid});
			String prostmt=DbUtil.getVal("select process_statement from user_profile where user_id=?",new String[]{userid});
				pagemap.put("statement",statement);
				pagemap.put("autoProcess",contenttype);	
				pagemap.put("processStatement",prostmt);
			  	if(!(("".equals((String)pagemap.get("statement")))||(pagemap.get("statement")==null))){			
					pagemap.put("exists","true");							
				}else{
					
					String useragent = request.getHeader("User-Agent");
					String user = useragent.toLowerCase();
					if(user.indexOf("msie") != -1 || user.indexOf("netscape6") != -1 || user.indexOf("firefox") != -1) {
					pagemap.put("autoProcess","wysiwyg");
					}else
						pagemap.put("autoProcess","text");
					pagemap.put("statement"," ");
					//	response.sendRedirect("/portal/pagecontent/pageeditmain.jsp?type=Snapshot");
					  GenUtil.Redirect(response,"/portal/mytasks/nwpageeditmain.jsp?type=Snapshot");
				
					
				}
				session.setAttribute("PAGE_HASH_NETWORK",pagemap);
			
		
		
%>


<%
request.setAttribute("mtype","My Public Pages");
request.setAttribute("tasktitle"," My  Network Page > Description");

%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/pagecontent/pagecontentmain.jsp";
	%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	

	
		

	
	