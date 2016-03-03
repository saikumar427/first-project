<%@ page import="java.util.*,com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.customconfig.*,com.eventbee.event.BeeletController,com.eventbee.editevent.*,com.eventbee.event.*" %>
<jsp:include page="/auth/checkpermission.jsp">
 <jsp:param name="authtype" value="eventmanage"/>
 <jsp:param name='Dummy_ph' value='' /></jsp:include>
 <script language="JavaScript">
 function aaa(){
if (parent.location.href == self.location.href){
document.getElementById('showdonemessages').innerHTML='';
}
}
</script>
<%
	String border="beelettable";
	String gap="5";
	String alignment="center";
	String layoutWidths="EE";
	String[] col_str=new String[]{"",""};
	col_str[0]="configevt,ticketinfo,links";
	//col_str[1]="statistics,evtmgmt,evtmkt,Noticeboard";
	col_str[1]="eventinfo,evtmgmt,evtmkt,f2fsponsor,agentsinfo,Noticeboard";
	String groupid=request.getParameter("GROUPID");
	String unitid=request.getParameter("UNITID");
	String evttype=DbUtil.getVal("select type from eventinfo where eventid=?",new String [] {groupid});
	String evtlevel=null;
	if(groupid !=null){
		HashMap groupinfo=new HashMap();
		groupinfo.put("GROUPID",groupid);
		groupinfo.put("groupid",groupid);

		if(unitid!=null){
			groupinfo.put("UNITID",unitid);
			groupinfo.put("unitid",unitid);
		}
		groupinfo.put("GROUPTYPE","Event");
		groupinfo.put("grouptype","Event");
		groupinfo.put("PS","eventmanage");
		groupinfo.put("evttype",evttype);
		EditEventDB evtDB=new EditEventDB();
		if(evtlevel==null){
			evtlevel=""+evtDB.getEventLevel(Integer.parseInt(groupid));
			groupinfo.put("evtlevel",evtlevel);
		}
		BeeletController bc=new BeeletController();
		bc.setEventConfigs(groupid,evtDB.getConfig(groupid,EventConstants.POWERED_BY),evtlevel);
		groupinfo.put("beeletcontroller",bc);
		session.setAttribute("groupinfo",groupinfo);
		String authid=null;
		Authenticate authData=AuthUtil.getAuthData(pageContext);
		if(authData!=null)authid=authData.getUserID();
		String sessid=(String)session.getId();
		if(session.getAttribute("event_visited_"+groupid) ==null){
			HitDB.insertHit(new String[]{"eventdetails.jsp","Event",sessid,groupid,authid});
			session.setAttribute("event_visited_"+groupid,groupid) ;
		}

	}
	
	List al=new ArrayList();
	for(int i=0;i<col_str.length;i++){
		if(col_str[i]!=null && !("".equals(col_str[i].trim()))){
			al.add(GenUtil.strToArrayStr(col_str[i],","));
		}
	}
	String[] widths=PageUtil.getWidth(layoutWidths);
	HashMap colmap=new HashMap();
	for(int i=0;i<al.size();i++)
		colmap.put("col"+(i+1),(String[])al.get(i));
	for(int i=0;i<widths.length;i++)
		colmap.put("col"+(i+1)+"width",widths[i]);
	HashMap urlmapping= new HashMap();
	//urlmapping.put("statistics","/eventmanage/eventstatistics.jsp");
	urlmapping.put("eventinfo","/eventmanage/mgreventinfoBeelet.jsp");
	urlmapping.put("configevt","/eventmanage/ConfigureEvent.jsp");
	urlmapping.put("Noticeboard","/noticeboard/mgrnotices.jsp");
	urlmapping.put("links","/editevent/links.jsp");
	urlmapping.put("evtmkt","/editevent/evtmkt.jsp");
	//urlmapping.put("f2fsponsor","/f2fsponsor/f2flookforsponsor.jsp");
	urlmapping.put("agentsinfo","/eventbeeticket/agentsinfo.jsp");
	urlmapping.put("evtmgmt","/editevent/evtmgmt.jsp");
	urlmapping.put("ticketinfo","/eventmanage/eventticketinfo.jsp");
	request.setAttribute("tabtype","events");
	request.setAttribute("subtabtype","My Pages");
	
%>
<%@ include file="/stylesheets/portalpage.jsp" %>
