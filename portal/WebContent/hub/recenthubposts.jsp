<%@ page import="java.util.*,com.eventbee.general.*" %>
<%!
String RECENT_HUBPOSTINGS="select getMemberName(c.postedby) as name,pref_value,user_id as userid, clubid,clubname,msgid,postedby,reply,postedat,subject,c.forumid from clubinfo a,forum b,forummessages c,member_preference d where parentid='0' and d.pref_name ='pref:myurl' and c.postedby=d.user_id and a.clubid=b.groupid and b.forumid=c.forumid order by postedat desc limit 5 ";


Vector getRecentHubPostings(){

	DBManager dbmanager=new DBManager();
	StatusObj statobj=dbmanager.executeSelectQuery(RECENT_HUBPOSTINGS,null);
	int recordcount=0;
	Vector v=new Vector();
	if(statobj !=null && statobj.getStatus() && (recordcount=statobj.getCount())>0){
		for(int i=0;i<recordcount;i++){
		HashMap hm=new HashMap();
			hm.put("name",dbmanager.getValue(i,"name",""));
			hm.put("clubid",dbmanager.getValue(i,"clubid","0"));
			hm.put("clubname",dbmanager.getValue(i,"clubname",""));
			hm.put("msgid",dbmanager.getValue(i,"msgid","0"));
			hm.put("postedat",dbmanager.getValueFromRecord(i,"postedat",""));			
			hm.put("postedby",dbmanager.getValue(i,"postedby","0"));
			hm.put("reply",dbmanager.getValue(i,"reply",""));
			hm.put("subject",dbmanager.getValue(i,"subject",""));	
			hm.put("forumid",dbmanager.getValue(i,"forumid",""));	
			hm.put("scrname",dbmanager.getValue(i,"pref_value",""));	
			hm.put("userid",dbmanager.getValue(i,"userid",""));
			v.add(hm);
		}

	}
	return v;
}



%>

<%
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","http://www.desihub.com");
String imgsrc="";
 String query="";
String query1="";
int count1=0,count3=0,count4=0;
String rpoints=null;
int redeempts=0;
int totalpts=0;
String count="",count2="";

Vector msgvec=getRecentHubPostings();


%>
<table border="0" width="100%" align="center" cellspacing="0" class="innerbeelet" cellpadding="5">
<div class='beelet-header'>Recent Community Postings</div>

 <%
 String styl="";
 if(msgvec!=null&&msgvec.size()>0){
 HashMap msgMap=new HashMap();
 count1=0;count3=0;count4=0; totalpts=0;
 for(int i=0;i<msgvec.size();i++){
 if(i%2==0)
 styl="evenbase";
 else
 styl="oddbase";
 msgMap=(HashMap)msgvec.elementAt(i);
 

%>
<tr class='<%=styl%>'><td><a href="<%=serveraddress %>/guesttasks/showTopicMessages.jsp?forumid=<%=GenUtil.getHMvalue(msgMap,"forumid")%>&topicid=<%=GenUtil.getHMvalue(msgMap,"msgid")%>&GROUPID=<%=GenUtil.getHMvalue(msgMap,"clubid")%>&GROUPTYPE=Club&PS=clubview"><%=GenUtil.textToHtml(GenUtil.TruncateData(GenUtil.getHMvalue(msgMap,"subject"),45),true)%></td></tr>
<tr class='<%=styl%>'><td><font class='smallestfont'>Posted by</font> <a href="<%=ShortUrlPattern.get((String)GenUtil.getHMvalue(msgMap,"scrname"))%>/network"><%=GenUtil.textToHtml(GenUtil.TruncateData(GenUtil.getHMvalue(msgMap,"name"),25),true)%></a>
<font class='smallestfont'>

in</font> <a href="<%=serveraddress %>/portal/hub/clubview.jsp?GROUPID=<%=GenUtil.getHMvalue(msgMap,"clubid")%>&UNITID=13579"><%=GenUtil.textToHtml(GenUtil.TruncateData(GenUtil.getHMvalue(msgMap,"clubname"),35),true)%></a></td></tr>
<%
}
}else{out.println("<tr><td>No postings</td></tr>");}
%>
</table>


