<%@ page import="java.util.*,com.eventbee.general.*,com.themes.*" %>
<%@ page import="com.eventbee.authentication.*" %>
<%@ include file="/mythemes/mythemesdb.jsp" %>

<%!
void getCustomPosterData(Vector v,String userid){
	DBManager dbmanager=new DBManager();
	String query="select a.themetype,a.themecode,a.refid,b.clubname,getMemberPref(b.mgr_id||'','pref:myurl','') as username,getDetailsPageThemeName(a.themetype,'hubpage',a.themecode) as customthemename  from user_roller_themes a,clubinfo b where a.userid=? and a.module='hubpage' and a.refid=b.clubid union select 'CUSTOM' as  themetype,c.themecode,c.refid,d.clubname,getMemberPref(d.mgr_id||'','pref:myurl','') as username,getDetailsPageThemeName('CUSTOM','hubpage',c.themecode) as customthemename from user_custom_roller_themes c,clubinfo d where c.userid=? and c.module='hubpage' and c.refid=d.clubid";


	StatusObj statobj=dbmanager.executeSelectQuery(query,new String[]{userid,userid});
	if(statobj.getStatus()){
	String [] columnnames=dbmanager.getColumnNames();
	for(int i=0;i<statobj.getCount();i++){
	HashMap hm=new HashMap();
	for(int j=0;j<columnnames.length;j++){
	hm.put(columnnames[j],dbmanager.getValue(i,columnnames[j],""));
	}
	v.add(hm);
	}
       }
       }
%>

<%
String CLASS_NAME="mythemes/community.jsp";
String userid="";
Authenticate authData=AuthUtil.getAuthData(pageContext);
if(authData !=null){
	userid=authData.getUserID();
}
String themeid="";
String module=request.getParameter("module");
Vector v=new Vector();
//getCustomPosterData(v,userid);

%>
<div class='memberbeelet-header'>My Community Page Themes</div>

<table cellpadding="5" cellspacing="0"  width="100%">

<%
//if(v.size()>0){

String base="oddbase";
for(int i=0;i<v.size();i++){
if(i%2==0)
	base="evenbase";
  else
	base="oddbase";
HashMap hm=(HashMap)v.elementAt(i);
String themetype=GenUtil.getHMvalue(hm,"themetype","");
String themecode=GenUtil.getHMvalue(hm,"customthemename","");
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME, "null", "themetype------ "+themetype, null);
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME, "null", "themecode------ "+themecode, null);
}
Vector v1=new Vector();

getCustomizedThemes(v1,userid,module);

if(v1.size()>0){

base="oddbase";
for(int i=0;i<v1.size();i++){
if(i%2==0)
	base="evenbase";
else
	base="oddbase";
HashMap hm=(HashMap)v1.elementAt(i);
 themeid=GenUtil.getHMvalue(hm,"themeid","");
String Themename=GenUtil.TruncateData(GenUtil.getHMvalue(hm,"themename",""),19);
%>
<tr class="<%=base%>"> 
<td class="<%=base%>"><%= GenUtil.TruncateData(GenUtil.getHMvalue(hm,"themename",""),19)%></td>
<td align="right"class="<%=base%>"><a href="/portal/mytasks/mytemplates.jsp?type=hubpage&customthemeid=<%=GenUtil.getHMvalue(hm,"themeid","")%>&title=My Community Page Themes > <%=java.net.URLEncoder.encode(Themename)%>">Theme Templates</a>
<td class="<%=base%>"align='right'><a href="/portal/mytasks/myuserthemes.jsp?module=<%=module%>&themeid=<%=GenUtil.getHMvalue(hm,"themeid","")%>&foract=edit&title=My Community PageThemes > <%=java.net.URLEncoder.encode(Themename)%>">Edit</a></td>
<td class="<%=base%>"align='right'><a href="javascript:popupwindow('/portal/usertheme/preview.jsp?module=<%=module%>&themeid=<%=GenUtil.getHMvalue(hm,"themeid","")%>&ispreview=yes','preview','400','400');">Preview</a></td>
<%}%>
</tr>
</table>
<%
}
%>
<table cellpadding="5" cellspacing="0"  width="100%">
<form action='/mytasks/myuserthemes.jsp'>
<tr align='center' ><td colspan='2' class="evenbase"><input type='submit' name='submit' value='Create Theme'></td></tr>
<input type="hidden" name="module" value="<%=module%>"/>
<input type="hidden" name="themeid" value="<%=themeid%>"/>
<input type="hidden" name="title"  value="My Community Page Themes"/>
</form>
</table>


