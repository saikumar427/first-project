<%@ page import="java.util.*,com.eventbee.general.*,com.themes.*" %>
<%@ page import="com.eventbee.authentication.*" %>
<%@ include file="/mythemes/mythemesdb.jsp" %>

<%
	String module=request.getParameter("module");
	if(module==null||"".equals(module))
		module="hubspage";
	String userid="";
	Authenticate authData=AuthUtil.getAuthData(pageContext);
	if(authData !=null){
	userid=authData.getUserID();
	}
	Vector v=new Vector();
	getCustomizedThemes(v,userid,module);
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"/hub/mythemes.jsp","user customized themes vector size is :"+v.size(),"userid is: "+userid,null);
%>	
<div class='memberbeelet-header'>My Communities Page Themes</div>

<table cellpadding="5" cellspacing="0"  width="100%">
<%
	if(v.size()>0){
	String base="oddbase";
	for(int i=0;i<v.size();i++){
	if(i%2==0)
	base="evenbase";
	else
	base="oddbase";
	HashMap hm=(HashMap)v.elementAt(i);
	String Themename=GenUtil.getHMvalue(hm,"themename","");
%>
<tr class="<%=base%>"> 
<td class="<%=base%>"><%=GenUtil.getHMvalue(hm,"themename","")%></td>
<td align="right" class="<%=base%>"><a href="/portal/mytasks/mytemplates.jsp?type=hubspage&customthemeid=<%=GenUtil.getHMvalue(hm,"themeid","")%>&title=My Communities Page Themes><%=java.net.URLEncoder.encode(Themename)%>">Theme Templates</a>
<td class="<%=base%>" align='right'><a href="/portal/mytasks/myuserthemes.jsp?module=<%=module%>&themeid=<%=GenUtil.getHMvalue(hm,"themeid","")%>&foract=edit&title=My Communities Page Themes><%=java.net.URLEncoder.encode(Themename)%>" >Edit</a></td>
<td class="<%=base%>" align='right'><a href="javascript:popupwindow('/portal/usertheme/preview.jsp?module=<%=module%>&themeid=<%=GenUtil.getHMvalue(hm,"themeid","")%>&ispreview=yes','preview','400','400');">Preview</a></td>

<%    }
%>
</td>
</tr>
</table>
<%   }
%>
<table cellpadding="5" cellspacing="0"  width="100%">
<form action='/mytasks/myuserthemes.jsp'>
<tr align='center' ><td colspan='2'><input type='submit' name='submit' value='Create Theme'></td></tr>
<input type="hidden" name="module" value="<%=module%>" />
<input type="hidden" name="title"  value="My Communities Page Themes"/>
</form>
</table>
