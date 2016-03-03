<%@ page import="com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.general.formatting.*"%>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="java.util.*,java.sql.*" %>
<%@ page import="com.eventbee.event.BeeletController" %>
<%@ page import="com.eventbee.forum.ForumDB" %>
<%@ page import="com.eventbee.clubmember.*" %>
<%@ page import="com.eventbee.event.ticketinfo.EventTicketDB" %>

<%! 
     
    String generateLinkName(String viewrole,String viewunitid,String sendrole,String sendunitid,String appname){

	String linkpath="/"+appname+"/editprofiles/networkuserprofile.jsp";
	
    		
     HashMap getForumInfo(String forumid){
       Connection con=null;	
       PreparedStatement pstmt=null;
       ResultSet rs=null;
       boolean conclose=false;	
	HashMap foruminfo=new HashMap();
       String GET_FORUM_INFO="select status,forumname,description,"
				+" to_char(createdat,'Month DD YYYY HH:MI AM') as createdat, "
			+" to_char(updatedat,'Month, DD YYYY HH:MI AM')as updatedat "
			+" from forum where forumid=?";

       try{
		 if(con==null){
			 con=EventbeeConnection.getReadConnection("forums");
			 conclose=true;
		 }
		 pstmt=con.prepareStatement(GET_FORUM_INFO);
  		 pstmt.setString(1,forumid);
		 rs=pstmt.executeQuery();
		 if(rs.next()){
			foruminfo.put("status",rs.getString("status"));
			foruminfo.put("forumname",rs.getString("forumname"));	
			foruminfo.put("createdat",rs.getString("createdat"));
			foruminfo.put("updatedat",rs.getString("updatedat"));
			foruminfo.put("description",rs.getString("description"));
		}
		rs=null;
		pstmt.close();
	}catch(Exception e){
		System.out.println("Exception Occured at showForumTopics.jsp at getForumInfo"+e);
		foruminfo=null;	
	}finally{
		try{
			if(pstmt!=null){pstmt.close();pstmt=null;}
			if(conclose){
				if(con!=null){con.close();con=null;}
			}
		}catch(Exception ex){}
	}
	return foruminfo;

     }	
	
      Vector getForumTopics(String forumid){

       Connection con=null;
       PreparedStatement pstmt=null;
       ResultSet rs=null;
       Vector v=new Vector();
       String GET_FORUM_TOPICS="select a.unit_id,ur.role_name,"
			+"(u.first_name || ' ' || u.last_name) as name,u.photourl,u.user_id, "
			+" f.reply,f.subject,f.parentid,f.msgid,"
			+" to_char(f.postedat,'Month DD YYYY HH:MI AM') as postedat "
			+" from forummessages f,user_profile u ,user_role ur,authentication a "
			+" where u.user_id=f.postedby  and forumid=? and  parentid=0 and a.user_id=u.user_id and " 
			+" ur.role_id in (a.role_id) order by msgid desc";
       try{
		 con=EventbeeConnection.getReadConnection("forums");
		 pstmt=con.prepareStatement(GET_FORUM_TOPICS);
  		 pstmt.setString(1,forumid);
		 rs=pstmt.executeQuery();
		 while(rs.next()){
			HashMap hm=new HashMap();
			hm.put("role_name",rs.getString("role_name"));
			hm.put("topicname",rs.getString("subject"));
			hm.put("description",rs.getString("reply"));
			hm.put("postedat",rs.getString("postedat"));
			hm.put("userid",rs.getString("user_id"));
			hm.put("unitid",rs.getString("unit_id"));
			hm.put("username",rs.getString("name"));
			hm.put("photourl",rs.getString("photourl"));
			hm.put("msgid",rs.getString("msgid"));
			getTopicStats(hm,con);
			v.add(hm);	
		}
		rs=null;
		pstmt.close();
	}catch(Exception e){
		System.out.println("Exception Occured at showForumTopics.jsp at getForumTopics"+e);
		v=null;
	}finally{
		try{
			if(pstmt!=null){pstmt.close();pstmt=null;}
			if(con!=null) {con.close();con=null;}
		}catch(Exception ex){}
	}
	return v;
    }
    HashMap getTopicStats(HashMap statmap,Connection con){

       PreparedStatement pstmt=null;
       ResultSet rs=null;
       boolean conclose=false;	
     String GET_FORUM_TOPIC_STAT="select count(*),to_char(max(postedat),'MM/DD/YYYY HH:MI AM')" 
				   +" as postedat from forummessages where topicid=?";
       try{
		 if(con==null){
			 con=EventbeeConnection.getReadConnection("forums");
			 conclose=true;
		 }
		 pstmt=con.prepareStatement(GET_FORUM_TOPIC_STAT);
  		 pstmt.setString(1,(String)statmap.get("msgid"));
		 rs=pstmt.executeQuery();
		 if(rs.next()){
			statmap.put("count_posts",rs.getString("count"));
			statmap.put("lastpostedat",rs.getString("postedat"));
		}
		rs=null;
		pstmt.close();
	}catch(Exception e){
		System.out.println("Exception Occured at showForumTopics.jsp at getTopicStats"+e);
	}finally{
		try{
			if(pstmt!=null){pstmt.close();pstmt=null;}
			if(conclose){
				if(con!=null){con.close();con=null;}
			}
		}catch(Exception ex){}
	}
	return statmap;
    }	
%>

<%
	String beeletdisplay="OK";
	String role=null,groupid=null,authid=null,grouptype=null,unitid=null;
	String entryunitid=(String)session.getAttribute("entryunitid");
	String appname=null;
	Authenticate authData=AuthUtil.getAuthData(pageContext);//(Authenticate)session.getAttribute("authData");
	if (authData!=null){
		 authid=authData.getUserID();
		 role=authData.getRoleName();
		 unitid=authData.getUnitID();
	}else{
		 role="Member";
		 authid=(String)session.getAttribute("transactionid");
		 unitid=(String)session.getAttribute("entryunitid");
	}
	if("Manager".equalsIgnoreCase(role.trim()))
		appname="manager";
	else
		appname="portal";
		
	HashMap grouphm=(HashMap)session.getAttribute("groupinfo");
			
	if(grouphm==null){
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"groupinfo HM is null at discussionforum", "generate mod", EventbeeLogger.LOG_END_PAGE, null);
	}else{
		groupid=(String)grouphm.get("groupid");

		grouptype=(String)grouphm.get("grouptype");
	}

String clublogo="none";
if("13579".equals(EbeeConstantsF.get("defaultunitid","13579")))
clublogo=DbUtil.getVal("select clublogo from clubinfo where clubid=?",new String [] {groupid});
else
if("13578".equals(EbeeConstantsF.get("defaultunitid","13579")))
clublogo=DbUtil.getVal("select unit_code from org_unit where unit_id=(select unitid from clubinfo where clubid= ?)",new String [] {groupid} );


	boolean isbeeletdisplay=true;
	HashMap forums=null;
	//if("13579".equals(EbeeConstantsF.get("defaultunitid","13579"))) isbeeletdisplay=false;
	
	String forumid=null;
    	if(isbeeletdisplay){
	  	beeletdisplay="Yes";
		session.setAttribute("Rolename",role);
		forums=ForumDB.getMemberForumInfo(groupid);
		if(forums!=null){
		  boolean displayforums=false;
		  if("Club".equalsIgnoreCase(grouptype) )displayforums=true;
		  else
		  if("Event".equalsIgnoreCase(grouptype)){
			  String eventPowered=EventTicketDB.getEventConfig(groupid, "event.power.ebee");
			 if( "Yes".equals(eventPowered)  )displayforums=true;
			 else
			 if(new ClubDB().isClubExists(entryunitid) )displayforums=true;

		  }
		    if(displayforums){
		  	Set set=forums.entrySet();
			for(Iterator i=set.iterator();i.hasNext();){
				Map.Entry entry=(Map.Entry)i.next();
				forumid=(String)entry.getKey();
			}
		}
	      }
	}
 	boolean cont=true;
	try{
		if(Integer.parseInt(forumid)<=0){
			throw new Exception();
		}
	}catch(Exception eno){
		System.out.println("Exception occured at converting forum no:"+eno);
		cont=false;
	}
	String imagepath=null;
	HashMap hmParent=new HashMap();




if(forums!=null){
if(cont){
if(forums.size()==1){
HashMap foruminfo=getForumInfo(forumid);
String fstatus=GenUtil.getHMvalue(foruminfo,"status");
if(!"Suspend".equalsIgnoreCase(fstatus)){
%>
<%@ include file="singleforum.jsp"%>
<% }}else{ %>
<%@ include file="multipleforumdisplay.jsp"%>
<%}%>

<% } }%>

