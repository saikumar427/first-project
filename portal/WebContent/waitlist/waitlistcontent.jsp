<%@ include file='/globalprops.jsp' %>
<%
String eid=request.getParameter("eid");
String tktName=request.getParameter("tktname");
String tktId=request.getParameter("tktid");
String tktcount=request.getParameter("tktcount");
int waittktcount=0;
try{
waittktcount=Integer.parseInt(tktcount);
}catch(Exception e){
	waittktcount=0;
	System.out.println("Exception ocuured waitlistcontent:"+waittktcount);
}
StringBuffer sb=new StringBuffer();
sb.append("<img src='/home/images/images/close.png' id='ebeecreditsclose' class='imgclose' style='margin-top:-35px;margin-right:-36px;cursor:pointer;' onclick='javascript:waitClose();'>");
sb.append("<input type='hidden' value='"+tktId+"' id='waittktid'>");
sb.append("<input type='hidden' value='"+tktName+"' id='waittktname'>");
sb.append("<div id='waitsuccess' style=\"display:none;font-size: 12px; background-color: rgb(232, 247, 237); border: 1px solid rgb(48, 182, 97); padding: 8px; border-radius: 3px; color: #333;margin: 4px;\"> <span id=\"notifymsg\"></span>");
sb.append("</div>");
sb.append("<table width='100%'><tr><td width='100%' cellspacing='0 cellpadding='0'>");
sb.append("<tr><td width='55%'><b>"+getPropValue("wl.tkt.name",eid)+"</b></td><td width='20%' align='right'><b>"+getPropValue("wl.qty",eid)+"</b></td></tr>");
sb.append("</table>");
sb.append("<table width='100%'><tr><td width='100%' cellspacing='0 cellpadding='0'>");
sb.append("<tr><td>"+tktName+"</td><td>");
sb.append("<select id='waitqty'>");
for(int i=1;i<=waittktcount;i++)
sb.append("<option value='"+i+"'>"+i+"</option>");	
sb.append("</select></td></tr>");
sb.append("<tr><td><div style='height:4px'></td></tr>");
sb.append("</table>");
sb.append("<div style='border-bottom: 1px solid gray;margin-bottom: 8px;'></div>");
sb.append("<table width='100%'><tr><td width='100%' cellspacing='0 cellpadding='0'>");
sb.append("<tr><td>"+getPropValue("wl.name",eid)+" *<span id='waitnameerror' style='color:red;display:none'>"+getPropValue("wl.require",eid)+"</span></td><td><input type='text' size='30' id='waitname'></td></tr>");
sb.append("<tr><td><div style='height:5px'></td></tr>");
sb.append("<tr><td>"+getPropValue("wl.email",eid)+" *<span id='waitemailerror'style='color:red;display:none'>"+getPropValue("wl.require",eid)+"</span></td><td><input type='text' size='30' id='waitemail'></td></tr>");
sb.append("<tr><td><div style='height:5px'></td></tr>");
sb.append("<tr><td>"+getPropValue("wl.phone",eid)+"</td><td><input type='text' size='30' id='waitphone'></td></tr>");
sb.append("<tr><td>"+getPropValue("wl.msg.mgr",eid)+"</td><td><textarea cols='22' rows='5' id='waitnotes'></textarea></td></tr>");
sb.append("<tr><td><div style='height:10px'></td></tr>");
sb.append("</table>");
sb.append("<div align='center' id='waitsubmitdiv'><input type='button' value='"+getPropValue("wl.submit",eid)+"' onclick='javascript:waitSubmit();' id='submitbtn'>&nbsp;<input type='button' value='"+getPropValue("wl.cancel",eid)+"' onclick='javascript:waitClose();'> </div>");
sb.append("<div align='center' id='waitloadingdiv' style='display:none'><img src='/home/images/ajax-loader.gif'></img></div>");
out.println(sb.toString());
%>