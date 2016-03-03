<%@ page import="java.util.*,com.customattributes.*,com.eventbee.general.*" %>
<%

String attriboption="";
String eventid=request.getParameter("GROUPID");
String moveupid=request.getParameter("moveupid");
String movedownid=request.getParameter("movedownid");
String removeid=request.getParameter("removeid");
Vector customattribs=null;
String purpose=(String)session.getAttribute("purpose");
String base="";
if("AUTOFILL".equals(purpose)){
customattribs=(Vector)session.getAttribute(eventid+"CustomAttributes");
}
else{

 customattribs=(Vector)session.getAttribute(eventid+"_AJAX_EDITPWD");
 }
if(customattribs!=null){
	try{    
		int id=Integer.parseInt(removeid);
		
		if(id>-1&&id<customattribs.size())	customattribs.remove(id);
		}
		catch(Exception e){
			}
try{    
		int id=Integer.parseInt(moveupid);
		
		if(id>0&&id<customattribs.size()){
		Object j=(Object)customattribs.elementAt(id-1);	
         customattribs.setElementAt(customattribs.elementAt(id),id-1);
         customattribs.setElementAt(j,id);
			}
		}catch(Exception e){
			}
			try{    
		int id=Integer.parseInt(movedownid);
		
		if(id>-1&&id<customattribs.size()){
		Object j=(Object)customattribs.elementAt(id+1);	
         customattribs.setElementAt(customattribs.elementAt(id),id+1);
         customattribs.setElementAt(j,id);
			}
		}catch(Exception e){
			}
	}
	

StringBuffer sb=new StringBuffer();
%>

<script>
<%
if (customattribs!=null){
%>
var attribs = new Array();
<%
sb.append("<table width='100%'>");
	for(int k=0;k<customattribs.size();k++){
		base=(k%2==0)?"oddbase":"evenbase";
	CustomAttributes cb=(CustomAttributes)customattribs.get(k);
		String CUSTOM_ATTRIB_NAME=cb.getAttributeName();
		String CUSTOM_ATTRIB_NAME1=CUSTOM_ATTRIB_NAME;
		if(CUSTOM_ATTRIB_NAME1.indexOf("'")>-1){
			CUSTOM_ATTRIB_NAME1=CUSTOM_ATTRIB_NAME1.replaceAll("'","\\\\\'");


		}
		if(CUSTOM_ATTRIB_NAME1.indexOf("\"")>-1){
			CUSTOM_ATTRIB_NAME1=CUSTOM_ATTRIB_NAME1.replaceAll("\"","\\\\\'");
			


		}


		
		String CUSTOM_ATTRIB_ISREQUIRED=cb.getIsRequired();
		String CUSTOM_ATTRIB_TYPE=cb.getAttributeType();
		String CUSTOM_ATTRIB_TEXTBOXSIZE=cb.getTextBoxSize();
		String CUSTOM_ATTRIB_ROWS=cb.getRows();
		String CUSTOM_ATTRIB_COLS=cb.getCols();
		String [] CUSTOM_ATTRIB_OPTIONS=cb.getOptions();
		if("select".equals(CUSTOM_ATTRIB_TYPE))CUSTOM_ATTRIB_TYPE="dropdown";
		sb.append("<tr class='"+base+"'><td width='40%'>");
		if(k==0){
		sb.append("<img src='/home/images/up.gif'/>&nbsp;");
				}
		    else{
				sb.append("<span onClick=moveupAttribute('"+k+"')><img src='/home/images/up.gif'/></span>&nbsp;");
				}
				if(k==customattribs.size()-1){
					sb.append("<img src='/home/images/dn.gif'/>&nbsp;&nbsp;");
				}
		  else{
				sb.append("<span class='editlink' onClick=movedownAttribute('"+k+"')><img src='/home/images/dn.gif'/></span>&nbsp;&nbsp;");
	      }
		
		
		sb.append(CUSTOM_ATTRIB_NAME+"</td><td width='15%'><div class='editlink' onClick=\"AddOneAttrib('"+CUSTOM_ATTRIB_NAME1+"','"+CUSTOM_ATTRIB_ISREQUIRED+"','"+CUSTOM_ATTRIB_TYPE+"',Array(");
		if("text".equals(CUSTOM_ATTRIB_TYPE)){
		sb.append("'"+CUSTOM_ATTRIB_TEXTBOXSIZE+"'");
		}else if("textarea".equals(CUSTOM_ATTRIB_TYPE)){
			sb.append("'"+CUSTOM_ATTRIB_ROWS+"'");
			sb.append(",");
			sb.append("'"+CUSTOM_ATTRIB_COLS+"'");
		}else{
			if(CUSTOM_ATTRIB_OPTIONS!=null&&CUSTOM_ATTRIB_OPTIONS.length>0){
			  
				for(int p=0;p<CUSTOM_ATTRIB_OPTIONS.length;p++){
					if(p>0)sb.append(",");
					attriboption=CUSTOM_ATTRIB_OPTIONS[p].replaceAll("'","\\\\\'");
					attriboption=attriboption.replaceAll("\"","\\\\\'");
					
					sb.append("'"+attriboption+"'");
					
				}
			}
		}	
		sb.append("));setEditAttributes('"+k+"');\" >Edit</div></td>");
		sb.append("<td width='15%'><div class='editlink' onClick=deleteAttribute('"+k+"')>Delete</div></td></tr>");
		
	}
sb.append("<input id='EDIT_ATTRIBUTE_ID' type='hidden' name='EDIT_ATTRIBUTE_ID' />");
sb.append("</table>");
}
%>
	</script>
<%out.println(sb.toString());
%>

