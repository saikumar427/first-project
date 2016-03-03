<%@ page import="java.util.*,com.customattributes.*,com.eventbee.general.*" %>
<%!
Vector validateCustomAttributes(CustomAttributes customattribs){
	Vector v=new Vector();
	if(customattribs.getAttributeName()==null||"".equals(customattribs.getAttributeName())||"Attribute Name".equals(customattribs.getAttributeName()))
		v.add("Attribute Name is Empty");
	String fieldtype=customattribs.getAttributeType();
	if("text".equals(fieldtype)){
		if(customattribs.getTextBoxSize()==null||"".equals(customattribs.getTextBoxSize())){
			v.add("Enter value for textbox size");
		}else{
			try{
				Integer.parseInt(customattribs.getTextBoxSize());
			}catch(Exception e){
				v.add("Enter valid value for textbox size");
			}
		}
	}else if("textarea".equals(fieldtype)){
		if(customattribs.getRows()==null||"".equals(customattribs.getRows())){
			v.add("Enter Number of rows for textarea");
		}else{
			try{
				Integer.parseInt(customattribs.getRows());
			}catch(Exception e){
				v.add("Enter valid Number of rows for textarea");
			}
		}
		if(customattribs.getCols()==null||"".equals(customattribs.getCols())){
			v.add("Enter Number of columns for textarea");
		}else{
			try{
				Integer.parseInt(customattribs.getCols());
			}catch(Exception e){
				v.add("Enter valid Number of columns for textarea");
			}
		}
	}else{
		String [] options=customattribs.getOptions();
		for(int i=0;i<options.length;i++){
		
			if(options[i]==null||"".equals(options[i])||"Attribute Name".equals(options[i])){
				v.add("Attribute option is Empty");
				break;
			}
			
		}
	}
	return v;
}
%>
<%

String eventid=request.getParameter("GROUPID");
String ATTRIB_SET_ID=request.getParameter("ATTRIB_SET_ID");
com.eventbee.util.RequestSaver rsv=new com.eventbee.util.RequestSaver(pageContext,eventid+"_TICKET_POWERED_HASH","session",true);
int editid=-1;
Vector attributes=null;

 attributes=(Vector)session.getAttribute(eventid+"_AJAX_EDITPWD");

if(attributes==null)attributes=new Vector();
StringBuffer sb=new StringBuffer();
CustomAttributes customattribs=new CustomAttributes();
String attribname=request.getParameter("AJAXCUSTOMFIELD_1");
String requiredoption=request.getParameter("AJAXCUSTOMFIELD_1_OPTIONREQUIRED");
String fieldtype=request.getParameter("AJAXCUSTOMFIELD_1_TYPE");
if("dropdown".equals(fieldtype))fieldtype="select";
Enumeration parameters=request.getParameterNames();
Set oset=new TreeSet(new CompareCustomAttributes());
String [] fieldAttribs=new String[0];

customattribs.setAttributeName(attribname);
customattribs.setAttributeType(fieldtype);
customattribs.setIsRequired(requiredoption);
String tbsize="0";
String rows="0";
String cols="0";
while (parameters.hasMoreElements()) {
String parameter=(String)parameters.nextElement();

	if("radio".equals(fieldtype)||"checkbox".equals(fieldtype)||"select".equals(fieldtype)){
		if(parameter.startsWith("AJAXCUSTOMFIELD_1_"+fieldtype)){
			int optindex=parameter.lastIndexOf("_");
			if(optindex!=-1){
				String ind=parameter.substring(optindex+1);
				oset.add(ind);
			}
		}
		
	}else if("text".equals(fieldtype)){
		tbsize=request.getParameter("AJAXCUSTOMFIELD_1_TEXTBOXSIZE");
		if (tbsize==null||"".equals(tbsize))tbsize="10";
	}
	else if("textarea".equals(fieldtype)){
		rows=request.getParameter("AJAXCUSTOMFIELD_1_ROWS");
		cols=request.getParameter("AJAXCUSTOMFIELD_1_COLS");
		if (rows==null||"".equals(rows))rows="10";
		if (cols==null||"".equals(cols))cols="70";
		
	}
	Object[] setarr=oset.toArray();
	fieldAttribs=new String[setarr.length];
	for(int i=0;i<setarr.length;i++){
		fieldAttribs[i]=request.getParameter("AJAXCUSTOMFIELD_1_"+fieldtype+"_"+setarr[i]);
	}
	customattribs.setRows(rows);
	customattribs.setCols(cols);
	customattribs.setTextBoxSize(tbsize);
	customattribs.setOptions(fieldAttribs);
}
Vector v=validateCustomAttributes(customattribs);
if(v.size()>0){
	sb.append("<table>");
	for(int i=0;i<v.size();i++){
		sb.append("<tr><td class='error'>"+v.get(i)+"</td></tr>");
	}
	sb.append("</table>");
	session.setAttribute(eventid+"_CUSTOM_ATTRIBUTES_ERRORS",v);
}else{
sb=new StringBuffer("ATTRIB_ERROR");
session.setAttribute(eventid+"_CUSTOM_ATTRIBUTES_ERRORS",null);
if("yes".equals(request.getParameter("EDITING_ATTRIBUTE"))){
	try{
		editid=Integer.parseInt(request.getParameter("EDIT_ATTRIBUTE_ID"));
	}catch(Exception e){
	}
	
	if(editid!=-1){
		attributes.remove(editid);
		attributes.add(editid,customattribs);
	}
}else{
	attributes.add(customattribs);
}
session.setAttribute(eventid+"CustomAttributes",attributes);
session.setAttribute(eventid+"_AJAX_EDITPWD",attributes);
}
session.setAttribute("AJAX_SETID_"+eventid,ATTRIB_SET_ID);
out.println(sb.toString());
	
%>
