<%@ page import="java.util.*"%>
<%@ page import="com.customattributes.CustomAttributesDB" %>
<%@ page import="com.eventbee.general.*" %>
<%!
public Vector getAttributes(String setid, String eid){
String RESPONSE_QUERY_FOR_ATTRIBUTE="select distinct attrib_name from custom_attrib_response a,custom_attrib_response_master b"
	  			   +" where a.responseid =b.responseid  and b.attrib_setid=? and attrib_name not in (select attribname from attendeelist_attributes where eventid=?)"
	  			   +"  UNION"
				   +" select attribname as attrib_name from custom_attribs where attrib_setid=? and attribname not in (select attribname from attendeelist_attributes where eventid=?)";


	Vector attribsVector=new Vector();
	DBManager dbmanager=new DBManager();
	HashMap hm = null;
	StatusObj statobj=dbmanager.executeSelectQuery(RESPONSE_QUERY_FOR_ATTRIBUTE,new String [] {setid, eid, setid, eid});
	if(statobj.getStatus()){
	        for(int k=0;k<statobj.getCount();k++){
			hm=new HashMap();
			hm.put("attrib_name",dbmanager.getValue(k,"attrib_name",""));
			attribsVector.add(hm);
	}
	}
	 return attribsVector;

	}

Vector getAttendeeAttributes(String eid){
	Vector editattributesvector= new Vector();
	DBManager dbm =new DBManager();
	HashMap editattribs= null;		
	String Query="select attribname from attendeelist_attributes where eventid=?"; 
	StatusObj statobj=dbm.executeSelectQuery(Query,new String[] {eid});
	if(statobj.getStatus())	{
		for(int k=0;k<statobj.getCount();k++){
			editattribs =new HashMap();
			editattribs.put("attrib_name",dbm.getValue(k,"attribname",""));
			editattributesvector.add(editattribs);
		}

	}
	
	return editattributesvector;
}
%>
<%
String eid=request.getParameter("eid");
String custom_setid=CustomAttributesDB.getAttribSetID(eid,"EVENT");	
Vector attibsVector=getAttributes(custom_setid,eid);
Vector attendeeAttributesvector=getAttendeeAttributes(eid);
String attnameDisplay="";
String attendeename=DbUtil.getVal("select 'YES' from attendeelist_attributes where eventid=? and attribname='Attendee Name'",new String[]{eid});
if(attendeename==null) attnameDisplay="Attendee Name";

%>

<form method="post" action="/portal/eventmanage/editattendeeattributes.jsp" name="editattributes" id="editattributes" >
<table align="center"  width="100%">
<input type="hidden" name="eid" value="<%=eid%>">
<tr><td height="10" colspan="4"></td></tr>
<tr><td colspan="4"><b>Select Attributes</b></td>
</tr>
<tr>
<td>

<select name="sel1" size="10" id="sel1" style="width:200px" multiple="multiple">
<%
if(!"".equals(attnameDisplay)){%>
<option value="<%=attnameDisplay%>" ><%=attnameDisplay%></option>
<%}%>

<%
if(attibsVector!=null&&attibsVector.size()>0){
 for(int j=0;j<attibsVector.size();j++){
	  HashMap attribshashmap=(HashMap)attibsVector.elementAt(j);
	  String attrib_name=(String)attribshashmap.get("attrib_name");
	  	  
%>
<option value="<%=attrib_name.replaceAll("\"","&quot;")%>" ><%=attrib_name%></option>
<%}
}%>
</select>
</td>
<td align="center" valign="middle">
<input type="button" value="--&gt;"
 onclick="moveOptions(this.form.sel1, this.form.sel2);" /><br />
<input type="button" value="&lt;--"
 onclick="moveOptions(this.form.sel2, this.form.sel1);" />
</td>
<td>
<%
if(attendeeAttributesvector!=null&&attendeeAttributesvector.size()>0){
%>
<select name="sel2" size="10"  id="sel2" style="width:200px" multiple="multiple">
<%	
 for(int j=0;j<attendeeAttributesvector.size();j++){
	  HashMap attendeeattibshashmap=(HashMap)attendeeAttributesvector.elementAt(j);
	  String attrib_name=(String)attendeeattibshashmap.get("attrib_name");	

	  
%>
<option value="<%=attrib_name.replaceAll("\"","&quot;")%>" ><%=attrib_name%></option>
<%}%>
</select>
</td>
<td class='editlink'><span onclick=moveup(document.editattributes.sel2)><img src='/home/images/up.gif' /></span><br>
<span onclick=movedown(document.editattributes.sel2)><img src='/home/images/dn.gif' /></span>
</td>
</tr>
<%}%>
<tr><td height="10" colspan="4"></td></tr>
<tr><td colspan="4" align="center">
<input type="button"  value="Update" onClick="selectAll('edit');"/>
<input type="button" value="Cancel" onClick="hideattribs();" />
</td>

</table>
</form>