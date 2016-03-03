<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="java.lang.*" %>
<%!
HashMap getForums(String groupid,StringBuffer sb,HashMap urlhm,String link ){
String query=" select forumid,forumname,owner,description,status, to_char(updatedat,'Mon dd,yyyy') as updatedat1 , "
+" to_char(createdat,'Mon dd,yyyy') as createdat1  from forum "
+" where groupid=CAST(? as INTEGER) and status not in ('No') ";
HashMap hmap=null;
DBManager dbmanager=new DBManager();
StatusObj statobj=dbmanager.executeSelectQuery(query,new String []{groupid});
if(statobj.getStatus()){
	hmap=new HashMap();
	int recordcount=statobj.getCount();
	for(int i=0;i<recordcount;i++){
		if(i==0)
		sb.append("forum"+i);
		else
		sb.append(",forum"+i);
		HashMap hm=new HashMap();
		String forumid=dbmanager.getValue(i,"forumid","");
		hm.put("forumid",forumid);
		hm.put("forumname",dbmanager.getValue(i,"forumname",""));
		hm.put("owner",dbmanager.getValue(i,"owner",""));
		hm.put("description",dbmanager.getValue(i,"description",""));
		hm.put("status",dbmanager.getValue(i,"status",""));
		hm.put("updatedat1",dbmanager.getValue(i,"updatedat1",""));
		hm.put("createdat1",dbmanager.getValue(i,"createdat1",""));
		hmap.put(forumid,hm);
		urlhm.put("forum"+i,link+"forumid="+forumid);
	}
}
return hmap;
}
HashMap getForumtopics(String groupid){
HashMap hmap=null;
String query=" select getReplyCount(f.msgid||'') as no_of_replies,f.forumid,a.unit_id,ur.role_name, "
		+" (u.first_name || ' ' || u.last_name) as name,u.photourl,u.user_id, "
 		+" f.reply,f.subject,f.parentid,f.msgid, "
 		+" to_char(f.postedat,'Month DD YYYY HH:MI AM') as postedat "
 		+" from forummessages f,user_profile u ,user_role ur,authentication a,forum f1 "
 		+" where u.user_id=f.postedby  and f.forumid=f1.forumid and f1.status not in ('No') "
		+" and f1.groupid=? and  parentid=0 and a.user_id=u.user_id and "
 		+" ur.role_id in (a.role_id) order by msgid desc ";
DBManager dbmanager=new DBManager();
StatusObj statobj=dbmanager.executeSelectQuery(query,new String []{groupid});
if(statobj.getStatus()){
hmap=new HashMap();
Vector v=null;
	int recordcount=statobj.getCount();
	for(int i=0;i<recordcount;i++){
	HashMap hm=new HashMap();
	String forumid=dbmanager.getValue(i,"forumid","");
	hm.put("unitid",dbmanager.getValue(i,"unit_id",""));
	hm.put("role_name",dbmanager.getValue(i,"role_name",""));
	hm.put("username",dbmanager.getValue(i,"name",""));
	hm.put("photourl",dbmanager.getValue(i,"photourl",""));
	hm.put("description",dbmanager.getValue(i,"reply",""));
	hm.put("topicname",dbmanager.getValue(i,"subject",""));
	hm.put("parentid",dbmanager.getValue(i,"parentid",""));
	hm.put("msgid",dbmanager.getValue(i,"msgid",""));
	hm.put("postedat",dbmanager.getValue(i,"postedat",""));
	hm.put("no_of_replies",dbmanager.getValue(i,"no_of_replies",""));
	hm.put("userid",dbmanager.getValue(i,"user_id",""));
	v=(Vector)hmap.get(forumid);
	if(v==null)
	v=new Vector();
	v.add(hm);
	hmap.put(forumid,v);
	}
}
return hmap;
}
%>
