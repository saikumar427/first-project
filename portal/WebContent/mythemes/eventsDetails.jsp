<%@ page import="java.util.*,com.eventbee.general.*,com.themes.*" %>
<%@ page import="com.eventbee.authentication.*" %>
<%@ include file="/mythemes/mythemesdb.jsp" %>



<%!           

               String CLASS_NAME="mythemes/eventDetails.jsp";
		void getCustomPosterData(Vector v,String userid){

		DBManager dbmanager=new DBManager();
		String query="select a.themetype,a.themecode,a.refid,b.eventname,getMemberPref(b.mgr_id||'','pref:myurl','') as username,getDetailsPageThemeName(a.themetype,'event',a.themecode) as customthemename  from user_roller_themes a,eventinfo b where a.userid=? and a.module='event' and a.refid=b.eventid union select 'CUSTOM' as  themetype,c.themecode,c.refid,d.eventname,getMemberPref(d.mgr_id||'','pref:myurl','') as username,getDetailsPageThemeName('CUSTOM','event',c.themecode) as customthemename from user_custom_roller_themes c,eventinfo d where c.userid=? and c.module='event' and c.refid=d.eventid";
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
		String themeid="";
		String userid="";
		String module=request.getParameter("module");
		if(module==null||"".equals(module))
			module="event";

		Authenticate authData=AuthUtil.getAuthData(pageContext);
		if(authData !=null){
			userid=authData.getUserID();

		}
		Vector v=new Vector();
		//getCustomPosterData(v,userid);
		
%>
<div class='memberbeelet-header'>My Event Details Page Themes</div>

<table cellpadding="5" cellspacing="0"  width="100%">
<input type="hidden" name="module" value="<%=module%>"/>

<%                //if(v.size()>0){

		String base="oddbase";
		for(int i=0;i<v.size();i++){
		if(i%2==0)
			base="evenbase";
		else
			base="oddbase";
		HashMap hm=(HashMap)v.elementAt(i);
		String themetype=GenUtil.getHMvalue(hm,"themetype","");
		String themecode=GenUtil.getHMvalue(hm,"customthemename","");
		}
		Vector v1=new Vector();
		getCustomizedThemes(v1,userid,module);
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME, "null", "mythemes Details are------ "+v1, null);
		

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
<td class="<%=base%>"><%=GenUtil.TruncateData(GenUtil.getHMvalue(hm,"themename",""),19)%></td>
<td align="right" class="<%=base%>"><a href="/portal/mytasks/mytemplates.jsp?type=event&customthemeid=<%=GenUtil.getHMvalue(hm,"themeid","")%>&title=My EventDetails Page Themes > <%=java.net.URLEncoder.encode(Themename)%>">Theme Templates</a>
<td class="<%=base%>" align='right'><a href="/portal/mytasks/myuserthemes.jsp?module=<%=module%>&themeid=<%=GenUtil.getHMvalue(hm,"themeid","")%>&foract=edit&title=My EventDetails Page Themes > <%=java.net.URLEncoder.encode(Themename)%>" >Edit</a></td>
<td class="<%=base%>" align='right'><a href="javascript:popupwindow('/portal/usertheme/preview.jsp?module=<%=module%>&themeid=<%=GenUtil.getHMvalue(hm,"themeid","")%>&ispreview=yes','preview','400','400');">Preview</a></td>
<%                }
%>
</tr>
</table>
<%                }
%>

<table cellpadding="5" cellspacing="0"  width="100%">
<form action='/mytasks/myuserthemes.jsp'>
<tr align='center' ><td colspan='2' class="evenbase"><input type='submit' name='submit' value='Create Theme'></td></tr>
<input type="hidden" name="module" value="<%=module%>"/>
<input type="hidden" name="themeid" value="<%=themeid%>"/>
<input type="hidden" name="title"  value="My EventDetails Page Themes"/>
</form>


</table>
<%            
%>


