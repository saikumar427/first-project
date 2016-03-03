<?xml version="1.0" encoding="UTF-8" ?>
<%@ page contentType="text/xml; charset=UTF-8" %>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.eventbee.hub.*" %>
<%@ page import="com.eventbee.pagenating.*" %>
<%@ page import="java.util.*,java.sql.*" %>
<%!

	String FORUMINFOQUERY="select groupid,grouptype,status,forumname,description,( "
				+" select unitid from clubinfo where clubid=a.groupid "
				+" union " 
				+" select unitid from eventinfo where eventid =a.groupid )as unitid, "
				 +" createdat,updatedat  from forum a where forumid=cast(? as numeric) ";
				 
				 
	String FORUMTOPICSQUERY="select  msgid,subject,reply,postedat ,(getMemberName(f.postedby)) as username from forummessages f where forumid=cast(? as numeric) and parentid=0 ";
	
	
	

	public Map getForumInfo(String forumid){
		DBManager dbmanager=new DBManager();
		Map forummap=null;
		StatusObj statobj=dbmanager.executeSelectQuery( FORUMINFOQUERY,new String[]{forumid});
		if(statobj != null){
			forummap=new HashMap();
			int recordcount=statobj.getCount();
			for(int i=0;i<recordcount;i++){
				forummap.put("forumname", dbmanager.getValue(i,"forumname","") );
				forummap.put("description", dbmanager.getValue(i,"description","") );
				forummap.put("unitid", dbmanager.getValue(i,"unitid","135790") );
				forummap.put("groupid", dbmanager.getValue(i,"groupid","-1") );
				forummap.put("grouptype", dbmanager.getValue(i,"grouptype","Prob") );
				forummap.put("status", dbmanager.getValue(i,"status","No") );
				forummap.put("createdat", dbmanager.getValue(i,"createdat",null) );
				forummap.put("updatedat", dbmanager.getValue(i,"updatedat",null) );
			}
			
			
		}
		return forummap;
	
	}
	
	
	public List getForumTopicInfo(String forumid){
		List topics=new ArrayList();
		DBManager dbmanager=new DBManager();
		Map forummap=null;
		StatusObj statobj=dbmanager.executeSelectQuery( FORUMTOPICSQUERY,new String[]{forumid});
		if(statobj != null){
			int recordcount=statobj.getCount();
			for(int i=0;i<recordcount;i++){
			
				Map topicmap=new HashMap();
				topicmap.put("subject", dbmanager.getValue(i,"subject","") );
				topicmap.put("reply", dbmanager.getValue(i,"reply","") );
				Object dbdate=dbmanager.getValueFromRecord(i,"postedat",null) ;
				topicmap.put("postedat",dbdate  );
				topicmap.put("username", dbmanager.getValue(i,"username",null) );
				topicmap.put("msgid", dbmanager.getValue(i,"msgid","-1") );
				
				topics.add(topicmap);
			
			}
			
			
		
		}
		
	
		return topics;
	}
	
	

%>
<%


		String forumid=request.getParameter("forumid");
		try{Integer.parseInt(forumid);}
		catch(Exception e){
			response.sendRedirect("/guesttasks/invalidpage.jsp");
			return;
		}
		Map formminfo=getForumInfo(forumid);
		Map channelinfo=new HashMap();
		channelinfo.put("title", GenUtil.getHMvalue(formminfo, "forumname") );
		String unitid=GenUtil.getHMvalue(formminfo, "unitid");
		String groupid=GenUtil.getHMvalue(formminfo, "groupid");
		String grouptype=GenUtil.getHMvalue(formminfo, "grouptype");
		String PS="Club".equalsIgnoreCase(grouptype)? "clubview":"eventview";
		String channellink="http://"+EbeeConstantsF.get("serveraddress","localhost:8080")+"/portal/mytasks/showForumTopics.jsp?forumid="+forumid+"&amp;GROUPID="+groupid+"&amp;GROUPTYPE="+grouptype+"&amp;PS="+PS;
		channelinfo.put("link",RssFeedManager.getEncodedXML( channellink,"") );
		channelinfo.put("description",GenUtil.getHMvalue(formminfo, "description") );
		
		
		
			
		
			String servername=EbeeConstantsF.get("application.name","Eventbee").trim();
			String serveraddress=EbeeConstantsF.get("serveraddress","www.eventbee.com");
			String imgtitle= "Eventbee".equals(servername)?"Eventbee" :  "Desihub - Frist Indian Social Networking Portal";
			String imgurl="http://"+serveraddress+"/home/images/logo_small.jpg";
			String imglink="http://"+serveraddress;
			
			channelinfo.put("image-title",imgtitle );
			
			channelinfo.put("image-url",imgurl );
			channelinfo.put("image-link",imglink );
		
		
		
		
		
		
		ChannelInterface ci=RssFeedManager.getChannel(channelinfo);
		
		
		List topiclist=getForumTopicInfo( forumid);
		
		
		if(topiclist !=null && (!topiclist.isEmpty()) ){
			for(int i=0;i<topiclist.size();i++){
				Map topicmap=(Map)topiclist.get(i);
				
				Map iteminfo=new HashMap();
				
				iteminfo.put("title", GenUtil.getHMvalue(topicmap, "subject")   );
				
				
				java.util.Date dt=(java.util.Date)topicmap.get( "postedat");
				if(dt !=null)
					iteminfo.put("pubDate",dt  );
					
					
				
				iteminfo.put("author", GenUtil.getHMvalue(topicmap, "username") );
				
				String topiclink="http://"+EbeeConstantsF.get("serveraddress","localhost:8080")+"/portal/discussionforums/logic/showTopicMessages.jsp?forumid="+forumid+"&amp;topicid="+GenUtil.getHMvalue(topicmap, "msgid")+"&amp;GROUPID="+groupid+"&amp;GROUPTYPE="+grouptype+"&amp;PS="+PS;
				iteminfo.put("link",topiclink );
				iteminfo.put("guid",topiclink);
				iteminfo.put("description",GenUtil.getHMvalue(topicmap, "reply") );
				
				ci.createItem(iteminfo);
						
				
				
			}
		}
		
		
		
		out.println(ci.getRssData() );
		
		
		

%>
