<%!
final String themeQuery="select themetype,themecode from user_roller_themes where refid=? and module=?";
HashMap getThemeCodeAndType(String refid){
HashMap hm=new HashMap();
DBManager db=new DBManager();
StatusObj sb=db.executeSelectQuery(themeQuery,new String[]{refid,"event"});
if(sb.getStatus())
{
hm.put("themetype",db.getValue(0,"themetype",""));
hm.put("themecode",db.getValue(0,"themecode",""));
}
return hm;
}
%>
<%
String csscontent=null;
String themetype=null;
String themecode=null;
HashMap themeDetails=getThemeCodeAndType(eid);
if(themeDetails!=null){
themetype=(String)themeDetails.get("themetype");
themecode=(String)themeDetails.get("themecode");
}
if(themeDetails==null || themeDetails.size()==0){
	themetype="DEFAULT";
	themecode="basic";
} 
if("DEFAULT".equals(themetype))
csscontent=DbUtil.getVal("select cssurl  from ebee_roller_def_themes where module =? and themecode=?",new String[]{"event",themecode});
else if("CUSTOM".equals(themetype))
csscontent=DbUtil.getVal("select cssurl  from user_custom_roller_themes where module =? and themecode=? and refid=?",new String[]{"event",themecode,eid});
else
csscontent=DbUtil.getVal("select cssurl  from user_customized_themes where module =? and themeid=? ",new String[]{"event",themecode});
%>
<style type="text/css">
<%=csscontent%>
</style>
