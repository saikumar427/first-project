<%@ page import="java.util.*,com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.customconfig.*" %>
<%!
	public String getParam(String val,String defval){
		if(val==null || "".equals(val.trim()))
			return defval;
		else
			return val;
	}
%>
<%
	String border="beelettable";
	String gap="5";
	String alignment="center";
	String layoutWidths="WN";
	String[] col_str=new String[]{"",""};
	col_str[0]="featuredlifestyle,popularlifestyles,recentposts,hotentries,ContentBeelet1D,ContentBeelet1E";
	col_str[1]="emaillifestyle,search,recentphotos,recentalbums,contentbeelet,gcontentbeelet,ContentBeelet2D,ContentBeelet2E";
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
	//String UNITID=getParam(request.getParameter("UNITID"),"13579");
	///request.setAttribute("UNITID",UNITID);
	/*String type=request.getParameter("type");
	if(type==null) type="international";
	*/
	
	urlmapping.put("popularlifestyles",       "/lifestyle/popularlifestyles.jsp");
	urlmapping.put("recentphotos","/photogallery/recentphotos.jsp");
	urlmapping.put("recentalbums","/photogallery/recentalbums.jsp");
	urlmapping.put("featuredlifestyle","/customconfig/logic/CustomContentBeelet.jsp?guestpage=y&portletid=FEATURED_LIFESTYLE&forgroup=13579&customborder=portalback");
	urlmapping.put("recentposts","/lifestyle/rollerlisting.jsp?forcont=recentposts");
	urlmapping.put("hotentries","/lifestyle/rollerlisting.jsp?forcont=hotentries");
	//urlmapping.put("search","/lifestyle/rollerlisting.jsp?UNITID="+UNITID+"&forcont=search");
	urlmapping.put("search","/lifestyle/searchblog.jsp");
	urlmapping.put("emaillifestyle","/lifestyle/emaillifestyle.jsp");
	urlmapping.put("contentbeelet","/customconfig/logic/CustomContentBeelet.jsp?guestpage=y&portletid=AD_LIFESTYLE_MAIN&forgroup=13579&customborder=portalback");
	urlmapping.put("gcontentbeelet","/customconfig/logic/CustomContentBeelet.jsp?guestpage=y&portletid=G_AD_LIFESTYLE_MAIN&forgroup=13579&customborder=portalback");
	//1st column content beelets
	urlmapping.put("ContentBeelet1D","/customconfig/logic/CustomContentBeelet.jsp?guestpage=y&portletid=EBEE_GUEST_LIFESTYLE_C1D&forgroup=13579&customborder=portalback");
	urlmapping.put("ContentBeelet1E","/customconfig/logic/CustomContentBeelet.jsp?guestpage=y&portletid=EBEE_GUEST_LIFESTYLE_C2D&forgroup=13579&customborder=portalback");
	////2st column content beelets
	urlmapping.put("ContentBeelet2D","/customconfig/logic/CustomContentBeelet.jsp?guestpage=y&portletid=EBEE_GUEST_LIFESTYLE_C2D&forgroup=13579&customborder=portalback");
	urlmapping.put("ContentBeelet2E","/customconfig/logic/CustomContentBeelet.jsp?guestpage=y&portletid=EBEE_GUEST_LIFESTYLE_C2E&forgroup=13579&customborder=portalback");
	
	
	request.setAttribute("tabtype","lifestyles");
%>
<%@ include file="/stylesheets/portalpage.jsp" %>
