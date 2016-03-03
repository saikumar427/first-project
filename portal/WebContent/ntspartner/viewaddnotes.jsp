<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.general.formatting.*" %>
<%!
static String GET_PREVIOUS_NOTES="select to_char(notes_date,'mm/dd/yyyy hh:mi AM') as notesdate,notes from transaction_notes where tid=? order by notes_date desc";
public Vector getPreviousNotesDetails(String tid)
{
	Vector v= new Vector();
	DBManager dbmanager=new DBManager();
	StatusObj stobj=dbmanager.executeSelectQuery(GET_PREVIOUS_NOTES,new String[]{tid});
	if(stobj.getStatus()){
		for(int i=0;i<stobj.getCount();i++){
			HashMap hm=new HashMap();
			String notesdate=dbmanager.getValue(i,"notesdate","");
			hm.put("notesdate",notesdate);
			String notes=(String)dbmanager.getValue(i,"notes","");
			hm.put("notes",notes);
			v.addElement(hm);
			
		}
	}
	return v;
}
%>
<%
String eventid=request.getParameter("eid");
String transactionid=request.getParameter("transactionid");
String cardtype=request.getParameter("cardtype");
Vector prvnotesdetails=getPreviousNotesDetails(transactionid);
String from=request.getParameter("from");
String trackcode=request.getParameter("trackcode");
String secretcode=request.getParameter("secretcode");
String base="oddbase";
String mgrtokenid=request.getParameter("mgrtokenid");

%>
<form name="viewaddnotesform" id="viewaddnotesform" method="POST" action="/ntspartner/viewaddbackend.jsp" >
<input type="hidden" name="eventid" value="<%=eventid%>">
<input type="hidden" name="transactionid" value="<%=transactionid%>"> 
<table class='portaltable' cellpadding="0" cellspacing="0" width="100%">
<tr><td class="subheader" colspan="6" width="10%">Add Notes</td></tr>
<tr><td colspan="6">
<textarea rows="2" cols="65" id="newnote" name="newnote">
</textarea>
</td>
</tr>
<tr>
</tr>
<td colspan="3" align="center">
<input type="button"  id="addnoteok" value="Add" name="addnoteok" onclick="addNoteSubmit('<%=eventid%>','<%=transactionid%>','<%=cardtype%>','<%=secretcode%>','<%=from%>','<%=trackcode%>','<%=mgrtokenid%>')">&nbsp;&nbsp;
<input type="button"  id="addnotecancel" value="Cancel" name="addnotecancel" onClick="hideattendee();">
</td>
</tr>
<tr><td><br></td></tr></table>
<br/>

<table  class='portaltable'  width="100%">

<tr ><td class="subheader" ><b>Previous Notes</b></td></tr>

<tr >
<td class="colheader" >Posted Time</td>
<td class="colheader" >Notes</td>
</tr>
<%
if (prvnotesdetails.size()>0){ 

      for (int i=0;i<prvnotesdetails.size();i++)
       {
          HashMap hm=(HashMap)prvnotesdetails.elementAt(i);
                 if(i%2==0)
	         	  	base="evenbase";
	         	  	else
		base="oddbase";
       %>
          <tr>
          <td  class="<%=base%>" width="30%"><%=(String)hm.get("notesdate")%></td>
          <td  class="<%=base%>" width="70%"><pre><%=(String)hm.get("notes")%></pre></td>
          </tr>
    <%}    //end for()
    }//end if()
    else{
     for (int i=0;i<=2;i++)
       {
         if(i%2==0)
       	base="evenbase";
	else
	base="oddbase";
	%>
     <tr>
              <td  class="<%=base%>" width="30%" height="20"></td>
              <td  class="<%=base%>" width="70%"></td>
          </tr>
    <%}}%>
</table>
</form>