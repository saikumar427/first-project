<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.eventbee.noticeboard.NoticeboardDB" %>
<%
	HashMap hm=(HashMap)session.getAttribute("groupinfo");
	Vector v=null;
	if(hm!=null){
		v=NoticeboardDB.getAllNotices((String)hm.get("groupid"));
	}
	if((v!=null)&&(v.size()>0)){	
		out.println(PageUtil.startContent("Noticeboard",request.getParameter("border"),request.getParameter("width"),true) );
%>
		<table cellpadding="0" cellspacing="0" width="100%" >     
<%
 		String base="oddbase";
        	for (int j=0;j<v.size();j++){
                	HashMap notice=(HashMap)v.elementAt(j);
 			base=(j%2==0)?"evenbase":"oddbase";
%>
			<tr class='<%=base%>'>
			<td class='data' width="20%" align="left" ><%=notice.get("noticetype")%></td>
			<td class='data'  align="left" ><%=notice.get("postedat1")%></td>
			</tr>
			<tr class='<%=base%>'>
			<td class='data'  align="left" ></td>
			<td class='data'  align="left" >
			 <%=GenUtil.textToHtml((String)notice.get("notice"))%>
			</td>
			</tr>
<%		
		}   		
%>
 		</table>
<%
		out.println(PageUtil.endContent());
	}
%>
