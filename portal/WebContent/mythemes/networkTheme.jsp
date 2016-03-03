<%@ page import="java.util.*,com.eventbee.general.*,com.themes.*" %>
<%@ page import="com.eventbee.authentication.*" %>
<%@ include file="/mythemes/mythemesdb.jsp" %>

<%
	String module=request.getParameter("module");
	if(module==null||"".equals(module))
	module="network";
	String userid="";
	Authenticate authData=AuthUtil.getAuthData(pageContext);
	if(authData !=null){
	userid=authData.getUserID();
	}

	Vector v=new Vector();
	getCustomizedThemes(v,userid,module);
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"/customevents/mythemes.jsp","user customized themes vector size is :"+v.size(),"userid is: "+userid,null);
	String eventspagetheme=getPublicPageThemeName(userid,module);

%>
<div class='memberbeelet-header'>My Network Page Themes</div>
<table cellpadding="5" cellspacing="0"  width="100%" class="evenbase">
<%
	if(v.size()>0){
	String base="oddbase";
	for(int i=0;i<v.size();i++){
	if(i%2==0)
	base="evenbase";
	else
	base="oddbase";
	HashMap hm=(HashMap)v.elementAt(i);
	String Themename=GenUtil.TruncateData(GenUtil.getHMvalue(hm,"themename",""),19);
%>
<tr class="<%=base%>"> 
<td class="<%=base%>"><%=GenUtil.TruncateData(GenUtil.getHMvalue(hm,"themename",""),19)%></td>
<td align="right" class="<%=base%>"><a href="/portal/mytasks/mytemplates.jsp?type=network&customthemeid=<%=GenUtil.getHMvalue(hm,"themeid","")%>&title=My Network Page Themes > <%=java.net.URLEncoder.encode(Themename)%>">Theme Templates</a>
<td class="<%=base%>" align='right'><a href="/portal/mytasks/myuserthemes.jsp?themeid=<%=GenUtil.getHMvalue(hm,"themeid","")%>&foract=edit&module=<%=module%>&title=My Network Page Themes > <%=java.net.URLEncoder.encode(Themename)%>" >Edit</a></td>
<td class="<%=base%>" align='right'><a href="javascript:popupwindow('/portal/usertheme/preview.jsp?themeid=<%=GenUtil.getHMvalue(hm,"themeid","")%>&module=<%=module%>&ispreview=yes','preview','400','400');">Preview</a></td>
<%
}
%>
</td>
</tr>
</table>
<%}%>
<table cellpadding="5" cellspacing="0"  width="100%">
<form action='/mytasks/myuserthemes.jsp'>
<tr align='center' ><td colspan='2' class="evenbase"><input type='submit' name='submit' value='Create Theme'></td></tr>
<input type="hidden" name="module" value="<%=module%>">
<input type="hidden" name="title"  value="My Network Page Themes"/>
</form>
</table>
