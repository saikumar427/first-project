<%@ page import="java.util.*"%>
<%@ page import="com.customattributes.CustomAttributesDB" %>
<%@ page import="com.eventbee.general.*" %>
<%!
public Vector getAttributes(String setid){
String RESPONSE_QUERY_FOR_ATTRIBUTE="select distinct attrib_name from custom_attrib_response a,custom_attrib_response_master b"
	  			   +" where a.responseid =b.responseid  and b.attrib_setid=?"
	  			   +"  UNION"
	  			   +" select attribname as attrib_name from custom_attribs where attrib_setid=?";

	Vector attribsVector=new Vector();
	DBManager dbmanager=new DBManager();
	HashMap hm = null;
	StatusObj statobj=dbmanager.executeSelectQuery(RESPONSE_QUERY_FOR_ATTRIBUTE,new String [] {setid,setid});
	if(statobj.getStatus()){
	        for(int k=0;k<statobj.getCount();k++){
			hm=new HashMap();
			hm.put("attrib_name",dbmanager.getValue(k,"attrib_name",""));
			attribsVector.add(hm);
	}
	}
	 return attribsVector;

	}
%>
<%
String eid=request.getParameter("eid");
String custom_setid=CustomAttributesDB.getAttribSetID(eid,"EVENT");	
Vector attibsVector=getAttributes(custom_setid);
%>
<form method="post" action="/portal/eventmanage/insertattendeeattributes.jsp" name="addattribs" id="addattribs" >
<table align="center"  width="100%">
<input type="hidden" name="eid" value="<%=eid%>">
<tr><td height="10" colspan="4"></td></tr>

<%
if(attibsVector!=null&&attibsVector.size()>0){
%>

<tr><td colspan="4"><b>Select Attributes</b></td>
</tr>
<tr>
<td><select name="sel1" size="10" id="sel1" style="width:200px" multiple="multiple">
<%	
 for(int j=0;j<attibsVector.size();j++){
	  HashMap attribshashmap=(HashMap)attibsVector.elementAt(j);
	  String attrib_name=(String)attribshashmap.get("attrib_name");
	  
%>
<option value="<%=attrib_name.replaceAll("\"","&quot;")%>" ><%=attrib_name%></option>
<%}%>
</select>
</td>
<td align="center" valign="middle">
<input type="button" value="-->"
 onclick="moveOptions(this.form.sel1, this.form.sel2);" /><br />
<input type="button" value="<--"
 onclick="moveOptions(this.form.sel2, this.form.sel1);" />
</td>
<td><select name="sel2" size="10"  id="sel2" style="width:200px" multiple="multiple">
<option value="Attendee Name" >Attendee Name</option>
</select>
</td>
<td class='editlink'><span onclick=moveup(document.addattribs.sel2)><img src='/home/images/up.gif' /></span><br>
<span onclick=movedown(document.addattribs.sel2)><img src='/home/images/dn.gif' /></span>
</td>

</tr>

<tr><td height="10" colspan="4"></td></tr>
<tr><td colspan="4" align="center">
<input type="button"  value="OK" onClick="selectAll('insert');"/>
<input type="button" value="Cancel" onClick="hideattribs();" />
</td></tr>
<%}else{%>
<tr><td height="10" colspan="4" align="center"> There are no attributes for this event.</td></tr>
<tr><td colspan="4" align="center">
<input type="button" value="Cancel" onClick="hideattribs();" />
</td></tr>
<%}%>
</table>
</form>