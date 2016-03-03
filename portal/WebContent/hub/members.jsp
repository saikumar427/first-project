<%@ page import="java.io.*, java.util.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.*" %>
<%!
	String CLASS_NAME="MEMBERS.jsp";
	String DELTEHUBMEM="delete from club_member where userid=? and clubid=?";
	String ACTIVATEMEM="update club_member set status='ACTIVE' where userid=? and clubid=?";
	
	void deleteHubMembers(String[] memberids,String groupid){
		java.sql.Connection con=null;
		java.sql.PreparedStatement pstmt=null;
	    if(memberids !=null){
		    try{
			    con=EventbeeConnection.getWriteConnection("hubs");
			    pstmt=con.prepareStatement(DELTEHUBMEM);
			    for(int i=0;i<memberids.length;i++){
				    pstmt.setString(1,memberids[i]);
				    pstmt.setString(2,groupid);
				    try{
					    pstmt.executeUpdate();
				    }catch(Exception edxd){
					    EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, CLASS_NAME, "deletehubMembers(String[] memberids)", edxd.getMessage(), edxd ) ;
				    }
			    }
			    pstmt.close();
			    pstmt=null;
			con.close();
			con=null;
		    }catch(Exception e){
			    	EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, CLASS_NAME, "deletehubMembers(String[] memberids)", e.getMessage(), e ) ;
		}
		finally{
			try{
				if (pstmt!=null) pstmt.close();

				if(con!=null) con.close();
			}catch(Exception e){}
		}//end of finally
		}
	 }

	 
	 void deleteHubMember(String userid, String groupid,String mgrid, String message){
	 	
	 StatusObj statobj=DbUtil.executeUpdateQuery(DELTEHUBMEM, new String[]{userid,groupid} );
	 
	 	HashMap insertMap=new HashMap();
		String msgid=com.eventbee.messages.MessageDB.getMsgID();
		insertMap.put("msgid",msgid);
		insertMap.put("msgfrom",mgrid);
		insertMap.put("groupid",groupid);
		insertMap.put("grouptype","Club");
		insertMap.put("msgsubject",message);
		insertMap.put("msgtype","sms");
		com.eventbee.messages.MessageDB.insertSMS_Message(insertMap);
		com.eventbee.messages.MessageDB.insertSMS_MessageInfo(msgid,userid,null);
	 
	 	return;
	 
	 }
	 
	 
	 void activateHubMember(String userid, String groupid,String mgrid,String message){
	 	
	 	StatusObj statobj=DbUtil.executeUpdateQuery(ACTIVATEMEM, new String[]{userid,groupid} );
	 
		HashMap insertMap=new HashMap();
		String msgid=com.eventbee.messages.MessageDB.getMsgID();
		insertMap.put("msgid",msgid);
		insertMap.put("msgfrom",mgrid);
		insertMap.put("groupid",groupid);
		insertMap.put("grouptype","Club");
		insertMap.put("msgsubject",message);
		insertMap.put("msgtype","sms");
		com.eventbee.messages.MessageDB.insertSMS_Message(insertMap);
		com.eventbee.messages.MessageDB.insertSMS_MessageInfo(msgid,userid,null);
	 
	 
	 	return;
	 
	 }
	 

%>



<%
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"members.jsp","Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
	String userid=null,unitid="";
	unitid=request.getParameter("UNITID");
	String groupid=request.getParameter("GROUPID");
	String formname=request.getParameter("formname");
	String clubname=request.getParameter("clubname");
	
	
	HashMap reqmap=(HashMap)request.getAttribute("REQMAP");
		if(reqmap==null){
			reqmap=new HashMap();
			reqmap.put("GROUPID",groupid);
			reqmap.put("UNITID","13579");
		}
	
	if("deleteactivemembers".equals(formname)){
		String[] delarr=request.getParameterValues("del1");
		deleteHubMembers(delarr,groupid);
		//String message="Members deleted";
		String message=EbeeConstantsF.get("hub.members.deleted","Members deleted");
		//response.sendRedirect(PageUtil.appendLinkWithGroup("/portal/mytasks/hubmembers.jsp?message="+message,reqmap ));
		
	   GenUtil.Redirect(response,"/portal/mytasks/managemembers.jsp?GROUPID="+request.getParameter("GROUPID"));
	}else if("deletepassivemembers".equals(formname)){
		String[] delarr=request.getParameterValues("del2");
		deleteHubMembers(delarr,groupid);
		//String message="Members deleted";
		String message=EbeeConstantsF.get("hub.members.deleted","Members deleted");
		//response.sendRedirect(PageUtil.appendLinkWithGroup("/portal/mytasks/hubmembers.jsp?message="+message,reqmap ));
		
	   GenUtil.Redirect(response,"/portal/mytasks/managemembers.jsp?GROUPID="+request.getParameter("GROUPID"));
	
	
	
	
	}else if("appdec".equals(formname)){
		String memuserid=request.getParameter("memuserid");
		String email=request.getParameter("email");
		String purpose=request.getParameter("purpose");
			
		String message="";
		HashMap hubinfohash=com.eventbee.hub.hubDB.getHubInfo(request.getParameter("GROUPID"),null);
		
		
		
		String mgr_id=GenUtil.getHMvalue(hubinfohash,"mgr_id","000");
		if("approve".equalsIgnoreCase(purpose) ){
			activateHubMember( memuserid,  groupid, mgr_id,request.getParameter("personalmessage"));
			message="Member approved";
		}else{
			deleteHubMember( memuserid, groupid,mgr_id,request.getParameter("personalmessage"));
			message="Member declined";
		}
		
		response.sendRedirect(PageUtil.appendLinkWithGroup("/portal/mytasks/hubdone.jsp?GROUPID="+request.getParameter("GROUPID")+"&message="+message,reqmap ));
		%>
		<%
		
	}else
	if( "approve".equalsIgnoreCase(formname) || "decline".equalsIgnoreCase(formname) ){
	


GenUtil.Redirect(response,"/portal/mytasks/appdec.jsp");


}else{

GenUtil.Redirect(response,"/portal/mytasks/managemembers.jsp?GROUPID="+request.getParameter("GROUPID"));
	




}%>
