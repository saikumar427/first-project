<%@ page import="java.util.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>

<%!
String INSERTTHEMEQ="insert into user_roller_themes (userid,module,themecode) values(?,?,?)";
String DELETETHEMEQ="delete from user_roller_themes where userid=? and module=?";

String CUSTOMCONTENTQ="select userid,themecode,module,content,cssurl from user_custom_roller_themes where userid=? and module=?";
String DELETECUSTOMCONTENT="delete from user_custom_roller_themes where userid=? and module=? ";
String INSERTCUSTOMCONT="insert into user_custom_roller_themes ( userid,themecode,module,content,cssurl) values (?,?,?,?,?)";




public void processContent(HttpServletRequest request,Authenticate authData ){
String type=request.getParameter("type");
String formname=request.getParameter("formname");
String userid=authData.getUserID();
String unitid=authData.getUnitID();
String act=request.getParameter("act");
String themecode=request.getParameter("theme");



DBManager dbmanager=new DBManager();
		StatusObj statobj=dbmanager.executeSelectQuery( CUSTOMCONTENTQ,new String[]{userid,type } );
		int recount=0;
		Map currentrecmap=new HashMap();
		currentrecmap.put("userid",userid);
		currentrecmap.put("module",type);
		currentrecmap.put("themecode",themecode);
		if(statobj !=null && statobj.getStatus() && (recount=statobj.getCount())>0){
			currentrecmap.put("content",  dbmanager.getValue(0,"content",null) );
			currentrecmap.put("cssurl",  dbmanager.getValue(0,"cssurl",null) );
		}
if("edit".equals(formname)){
		

	String editcontent=request.getParameter("editcontent");
	if("editdata".equals(act)){
		currentrecmap.put("content", editcontent );
	
	}else
	if("editcss".equals(act)){
		currentrecmap.put("cssurl",  editcontent );
	
	}
	
	
}//end of edi

if("remove".equals(formname)){
		

	String editcontent=request.getParameter("editcontent");
	if("removedata".equals(act)){
		currentrecmap.put("content", editcontent );
	
	}else
	if("removecss".equals(act)){
		currentrecmap.put("cssurl",  editcontent );
	
	}
	
	
}//end of edi


//System.out.println(currentrecmap);
DbUtil.executeUpdateQuery(DELETECUSTOMCONTENT, new String[]{userid,type    } );
	DbUtil.executeUpdateQuery(INSERTCUSTOMCONT, 
				new String[]{
				(String)currentrecmap.get("userid"),
				(String)currentrecmap.get("themecode"),
				(String)currentrecmap.get("module"),
				(currentrecmap.get("content")!=null)?(String)currentrecmap.get("content"):null,
				(currentrecmap.get("cssurl")!=null)?(String)currentrecmap.get("cssurl"):null
				} );
	




}


%>

<jsp:include page="/auth/authenticate.jsp" />

<jsp:include page="/stylesheets/CoreRequestMap.jsp" />

<%


String type=request.getParameter("type");
String formname=request.getParameter("formname");

Authenticate authData=AuthUtil.getAuthData(pageContext);
String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";
if(authData !=null){
	String userid=authData.getUserID();
	String unitid=authData.getUnitID();
	String act=request.getParameter("act");
	if("edit".equals(formname)){
	
	processContent(request,authData);
		if("editdata".equals(act)){
		response.sendRedirect(     PageUtil.appendLinkWithGroup("Done.jsp?operation=Edit Template", (HashMap)request.getAttribute("REQMAP")    )     );
		}else
		if("editcss".equals(act)){
			response.sendRedirect(     PageUtil.appendLinkWithGroup("Done.jsp?operation=Edit CSS", (HashMap)request.getAttribute("REQMAP")    )     );
		}
	}else
	if("remove".equals(formname)){
		processContent(request,authData);
		if("removedata".equals(act)){
		response.sendRedirect(     PageUtil.appendLinkWithGroup("Done.jsp?operation=Delete Template", (HashMap)request.getAttribute("REQMAP")    )     );
		}else
		if("removecss".equals(act)){
			response.sendRedirect(     PageUtil.appendLinkWithGroup("Done.jsp?operation=Delete CSS", (HashMap)request.getAttribute("REQMAP")    )     );
		}
		
		
	}else{
	String themecode=request.getParameter("theme");
	String currenttheme=request.getParameter("currenttheme");
	
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, "lifestyle/getlifestyle1.jsp", "changing theme", "currentthem="+currenttheme+"selected theme="+request.getParameter("theme"), null);
	
	if(!themecode.equals(currenttheme)){
		StatusObj statobj=DbUtil.executeUpdateQuery(DELETETHEMEQ, new String[]{userid,type    } );
		 statobj=DbUtil.executeUpdateQuery(INSERTTHEMEQ, new String[]{userid,type,themecode    } );
		 //delte the custom content
		 DbUtil.executeUpdateQuery(DELETECUSTOMCONTENT, new String[]{userid,type    } );
	 }
	session.setAttribute("message",EbeeConstantsF.get("lifestyle.theme.update.done"   ,"Theme added successfully"   )     );
	
	response.sendRedirect(     PageUtil.appendLinkWithGroup("Done.jsp?operation=Theme", (HashMap)request.getAttribute("REQMAP")    )     );
	}

%>


<%

}
%>
