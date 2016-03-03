<%@ page import="java.util.*,com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.customconfig.*" %>
<jsp:include page="/auth/authenticate.jsp" />
<%
//String unitid=request.getParameter("UNITID");
String groupid=request.getParameter("GROUPID");
String grouptype=request.getParameter("GROUPTYPE");

	String border="beelettable";
	String gap="5";
	String alignment="left";
	String layoutWidths="WN";
	String[] col_str=new String[]{"",""};
	col_str[0]="lifestylepromo,HomeContentBeelet1,invitefriends,requestsfromfriend,infolifestyle,SMS,HomeContentBeelet2";
	col_str[1]="MemStatistics,MyMainPhoto,MemberDirectoryBeelet,BeeIdMembersBeelet";
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
		HashMap datahash=new HashMap();
		String BACK_PAGE_URL=request.getContextPath()+"/club/myhome.jsp";
		datahash.put("BACK_PAGE","My Home");
		datahash.put("redirecturl",BACK_PAGE_URL);
		session.setAttribute("REDIRECT_HASH",datahash);

	HashMap urlmapping= new HashMap();
	urlmapping.put("lifestylepromo","/lifestyle/lifestylepromo.jsp");
	urlmapping.put("infolifestyle","/lifestyle/infolifestyle.jsp");
	urlmapping.put("requestsfromfriend","/lifestyle/requestsfromfriend.jsp");
	urlmapping.put("invitefriends","/nuser/friendslist.jsp");
	urlmapping.put("HomeContentBeelet1","/customconfig/logic/CustomContentBeelet.jsp?portletid=EBEE_HOME_C1&forgroup=13579");

	urlmapping.put("SMS","/club/ClubMessagingBeelet.jsp");
	urlmapping.put("HomeContentBeelet2","/customconfig/logic/CustomContentBeelet.jsp?portletid=EBEE_HOME_C2&forgroup=13579");
	//if(!"Eventbee".equals(EbeeConstantsF.get("application.name","Eventbee")))
	//urlmapping.put("MemStatistics","/club/MemStatistics.jsp");
	urlmapping.put("MyMainPhoto","/photoupload/mymainphoto.jsp");
	urlmapping.put("MemberDirectoryBeelet","/club/MemberDirectoryBeelet.jsp");
	urlmapping.put("BeeIdMembersBeelet","/lifestyle/newestlifestylebeelet.jsp");


	request.setAttribute("tabtype","community");
	request.setAttribute("subtabtype","mynetwork");

%>
<table  valign="top" align="<%=alignment%>" border="0" cellPadding="0" cellSpacing="0"  height="450" class="portalback">
<%@ include file="/stylesheets/IncludePortalPage.jsp" %>
</table>
