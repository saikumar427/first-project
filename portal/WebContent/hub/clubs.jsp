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
	col_str[0]="clublisting";
	col_str[1]="listclub,clubimg";
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
	String UNITID=getParam(request.getParameter("UNITID"),"13579");
	request.setAttribute("UNITID",UNITID);
	urlmapping.put("clublisting","/hub/clubtypes.jsp");
	urlmapping.put("listclub","/hub/listclub.jsp");
	urlmapping.put("clubimg","/hub/listhubimg.jsp");
	request.setAttribute("tabtype","club");
%>
<%@ include file="/stylesheets/portalpage.jsp" %>
