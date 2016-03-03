<%@ page import="java.util.*,com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.customconfig.*" %>
<%!
Vector getTagsCount(String evttype){
		DBManager dbmanager=new DBManager();
		StatusObj statobj=null;
		Vector v=new Vector();
		java.text.SimpleDateFormat SDF=new java.text.SimpleDateFormat("yyyy-MM-dd");
		String reqdate=SDF.format(Calendar.getInstance().getTime());
		statobj=dbmanager.executeSelectQuery("select a.tags, count(*) as count from event_tags a,eventinfo b where cast(a.eventid as numeric)=b.eventid and b.status='ACTIVE'  and listType='PBL' and b.country='USA' and type=? and to_date(b.start_date::text,'yyyy-MM-dd')>=to_date(?::text,'yyyy-MM-dd')  group by a.tags order by count(*) desc ",new String [] {evttype,reqdate});
		//statobj=dbmanager.executeSelectQuery("select a.tags, count(*) as count from event_tags a,eventinfo b where a.eventid=b.eventid and  isEventMgrActive(role,''||mgr_id,''||b.unitid)='Yes' and b.status='ACTIVE'  and listType='PBL' and to_date(b.start_date,'yyyy-MM-dd')>=to_date(?,'yyyy-MM-dd')  group by a.tags order by count(*) desc ",new String [] {reqdate});
		if(statobj.getStatus()){
			for(int i=0;i<statobj.getCount();i++){
				HashMap hm=new HashMap();
				hm.put("tags",dbmanager.getValue(i,"tags",""));
				hm.put("count",dbmanager.getValue(i,"count","0"));
				int count=Integer.parseInt(dbmanager.getValue(i,"count","0"));
				if(count>=1){
				v.add(hm);
				}
			}

		}

	return v;

	}
%>
<%

String location=request.getParameter("location");
String eventtype=request.getParameter("evttype");
Vector v=getTagsCount(eventtype);
String linkpath="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com")+"/home/links";
if(v!=null&&v.size()>0){
%>
<%-- out.println(PageUtil.startContentForGuest("Event Tags <a href=\"javascript:popupwindow('"+linkpath+"/eventtabhelp.html','Tags','600','400')\">[?]</a>",request.getParameter("border"),request.getParameter("width"),true,"beelet-header") ); --%>


<table width="100%" border="0" cellpadding="0" cellspacing="0" height="10" class='beelet-header'>
<tr ><td  >
Event Tags <a href="javascript:popupwindow('<%=linkpath%>/eventtabhelp.html','Tags','600','400')">[?]</a></td>
</tr>
</table>


<table width="100%" border="0" cellpadding="0" cellspacing="0">
 <input type="hidden" name="UNITID" value="<%=request.getParameter("UNITID")%>"/>
<!-- <tr><td class='colheader'>Event Tags <a href="javascript:popupwindow('<%=linkpath%>/photostaghelp.html','Tags','600','400')">[?]</a></td></tr>-->
  <tr><td height="30" width='100%' class='evenbase' >
<% 
int size=v.size();
for(int i=0;i<size;i++){
HashMap tagmap=(HashMap)v.get(i);
if(tagmap!=null){

String tstring=GenUtil.getHMvalue(tagmap,"tags","");
String[] tstring1=tstring.split("\\s");
if(tstring1.length<=2){
%>
<a href="/portal/eventdetails/eventcatlist.jsp?evttype=<%=request.getParameter("evttype")%>&UNITID=13579&tag=<%=GenUtil.getHMvalue(tagmap,"tags","")%>&location=USA&category=All"><font class='smallfont'><%=GenUtil.getHMvalue(tagmap,"tags","")%> </font><font class='smallestfont'>(<%=GenUtil.getHMvalue(tagmap,"count","0")%> events)</font></a>

<%}%>
	 <%}%>
<%}%>
  </td>
</tr>
</table>
<%-- out.println(PageUtil.endContent()); --%>
<%}%>
