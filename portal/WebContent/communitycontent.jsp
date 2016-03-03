<%@ page import="java.util.*,com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.customconfig.*" %>
<%
	String border="beelettable";
	String gap="5";
	String alignment="left";
	String layoutWidths="EE";
	String[] col_str=new String[]{"",""};
	col_str[0]="ContentBeelet1,ContentBeelet1b,ContentBeelet1c";
	col_str[1]="Login";
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
	urlmapping.put("ContentBeelet1","/customconfig/logic/CustomContentBeelet.jsp?portletid=EBEE_LOGIN_C1&forgroup=13579&customborder=portalback");
	urlmapping.put("ContentBeelet1b","/customconfig/logic/CustomContentBeelet.jsp?portletid=EBEE_LOGIN_C1B&forgroup=13579&customborder=portalback");
	urlmapping.put("ContentBeelet1c","/customconfig/logic/CustomContentBeelet.jsp?portletid=EBEE_LOGIN_C1C&forgroup=13579&customborder=portalback");
	
	//urlmapping.put("Login","login.jsp");
	urlmapping.put("Login","/hub/login.jsp");
	request.setAttribute("tabtype","community");
	
%>
<%@ include file="/stylesheets/portalpage.jsp" %>

