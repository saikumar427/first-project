<script>
<!--
function generatePdf(ext){

document.report1.action = '/portal/listreport/reports.jsp?type=Community';
document.report1.submit();
return true;

}
function generateExcel(ext){
                              
document.report.action = '/portal/listreport/communityreport.jsp';
document.report.submit();
return true;


}

</script>

<%

String custom_setid=CustomAttributesDB.getAttribSetID(clubid,"CLUB_MEMBER_SIGNUP_PAGE");
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"custom_setid is-------------===========:"+custom_setid,"",null);

session.setAttribute("custom_setid",custom_setid);
List list=CustomAttributesDB.getAttributes(custom_setid);
int cols=list.size();
cols=7+cols;
String strparams="";
%>

<form name="report1" method="post" action="/portal/listreport/communityreport.jsp">
<div STYLE=" height: 500px; width: 840px; font-size: 12px; overflow: auto;">

<table border='0' align='center' width="100%" cols="<%=cols%>">
<tbody>
<input type="hidden" name="unitid" value="<%=unitid%>"/>
<input type="hidden" name="custom_setid" value="<%=custom_setid%>"/>
<input type="hidden" name="UNITID" value="13579"/>
<input type="hidden" name="GROUPID" value="<%=clubid%>"/>
<input type="hidden" name="membopt" value="<%=selec%>"/>
<%if("mship".equals(selec)){
	strparams+="&amp;mshipid="+mshipid;
%>
	<input type="hidden" name="mshipid" value="<%=mshipid%>"/>
<%} if("str".equals(selec)){
	strparams+="&amp;name="+name;
%>
	<input type="hidden" name="name" value="<%=name%>"/>
<%} if("email".equals(selec)){
	strparams+="&amp;email="+email;
%>
	<input type="hidden" name="email" value="<%=email%>"/>
<%} if("dates".equals(selec)){
	strparams+="&amp;dateopt="+dateopt;
%>
	<input type="hidden" name="dateopt" value="<%=dateopt%>"/>
<%  	if("after".equals(dateopt)){
		strparams+="&amp;montha="+montha+"&amp;daya="+daya+"&amp;yeara="+yeara;
%>
		<input type="hidden" name="montha" value="<%=montha%>"/>
		<input type="hidden" name="daya" value="<%=daya%>"/>
		<input type="hidden" name="yeara" value="<%=yeara%>"/>

<%	}else
	if("before".equals(dateopt)){
		strparams+="&amp;monthb="+monthb+"&amp;dayb="+dayb+"&amp;yearb="+yearb;
	%>
		<input type="hidden" name="monthb" value="<%=monthb%>"/>
		<input type="hidden" name="dayb" value="<%=dayb%>"/>
		<input type="hidden" name="yearb" value="<%=yearb%>"/>
	<%}else
	if("betw".equals(dateopt)){
		strparams+="&amp;month1="+month1+"&amp;day1="+day1+"&amp;year1="+year1+"&amp;month2="+month2+"&amp;day2="+day2+"&amp;year2="+year2;
	%>
		<input type="hidden" name="month1" value="<%=month1%>"/>
		<input type="hidden" name="day1" value="<%=day1%>"/>
		<input type="hidden" name="year1" value="<%=year1%>"/>
		<input type="hidden" name="month2" value="<%=month2%>"/>
		<input type="hidden" name="day2" value="<%=day2%>"/>
		<input type="hidden" name="year2" value="<%=year2%>"/>
	<%}
} if("status".equals(selec)){
	strparams+="&amp;statusid="+statusid;
%>
	<input type="hidden" name="statusid" value="<%=statusid%>"/>
<%} if("subscription".equals(selec)){
	strparams+="&amp;duechoice="+duechoice;
%>
	<input type="hidden" name="duechoice" value="<%=duechoice%>"/>
	<%if("within".equals(duechoice)){
		strparams+="&amp;subscrdays="+subscrdays;
	%>
	<input type="hidden" name="subscrdays" value="<%=subscrdays%>"/>
	<%}else{
		strparams+="&amp;subscrdaysmore="+subscrdaysmore;
	%>
	<input type="hidden" name="subscrdaysmore" value="<%=subscrdaysmore%>"/>

<%}}%>

<%

if(memlist!=null&&!memlist.isEmpty()){

%>

<tr class='colheader'><td >Name</td><td >Email</td>

<%
	if(list!=null&&list.size()>0){
		for(int p=0;p<list.size();p++){%>

	<td><%=list.get(p)%></td>
	<%
	}

}
%>

<td >Membership Type</td><td >Join Date</td><td >Due Date</td><td >Status</td><td>Edit</td>
</tr>

<%
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","http://www.desihub.com");
String labclass="";
String userid="";

for(int i=0;i<memlist.size();i++){

ClubMemberProfile cmp =(ClubMemberProfile) memlist.get(i);
userid=cmp.getUserId();
cmp =(ClubMemberProfile) memlist.get(i);
if(i%2==0){
labclass="oddbase";
}else{
labclass="evenbase";
}

Map mp=new HashMap();
String [] mshipids=(String [])mshipmap.get("memids");
String [] mshipnames=(String [])mshipmap.get("memnames");
for(int k=0;k<mshipids.length;k++)
mp.put(mshipids[k],mshipnames[k]);
String membername="";
String editlink="";
String memberstatus=GenUtil.getEncodedXML( cmp.getMembershipStatus());
if("INDIRECT".equals(memberstatus))
     	memberstatus="Passive";
else
	memberstatus="Active";

if("Passive".equals(memberstatus)){
        membername=GenUtil.getEncodedXML( cmp.getFirstName());
        editlink="<a href='/mytasks/editpassivemem.jsp?GROUPID="+clubid+"&amp;userid="+userid+"&amp;membopt="+selec+strparams+"'>Edit</a>"; 
}
else{
	membername=GenUtil.getEncodedXML( cmp.getFirstName());
	//membername="<a href='"+serveraddress+"/member/"+GenUtil.getEncodedXML( cmp.getLoginName())+"'>"+GenUtil.getEncodedXML( cmp.getFirstName())+"</a>";
}

%>
<tr class="<%=labclass %>">

<td><%=membername%></td>

<td ><a href='mailto:<%=  GenUtil.getEncodedXML(cmp.getEmail()) %>'><%= GenUtil.getEncodedXML( cmp.getEmail()) %></a></td>

<%--td><%=memberstatus%></td--%>

<%

if(list!=null&&list.size()>0){
	HashMap mainhm=CustomAttributesDB.getCommunityResponses(custom_setid);
	
	HashMap attribhm=null;
	if(mainhm!=null&&mainhm.size()>0){

			attribhm=(HashMap)mainhm.get(userid);
			if(attribhm!=null&&attribhm.size()>0){
				for(int p=0;p<list.size();p++){
					String val=(String)attribhm.get(list.get(p));
					
					if(val==null)val="";

					if(val.indexOf("##")>0)
						val=val.replaceAll("##",", ");
				%>
					
				<td><%=val%></td>
					
				<%}

			}
			else{
				for(int l=0;l<list.size();l++){

				%>

				<td></td>

				<%}
			}
	}
	
}


%>
<td ><%
out.println(GenUtil.getEncodedXML( (String)mp.get(cmp.getMemberShipId()) ));
%></td>
<td ><%= GenUtil.getEncodedXML( cmp.getStartDate() )%></td>
<%
String duedate=cmp.getDueDate();
%>
<td ><%=duedate%></td>
<%
String membertype=DbUtil.getVal("select value from community_config_settings where key='MEMBER_ACCOUNT_TYPE' and clubid=? ",new String [] {clubid});


String memactstatus="";
//(String) MemAccountStatus.typeval.get(cmp.getStatus());

if("EXCLUSIVE".equals(membertype)&&"3".equals(cmp.getStatus())){
memactstatus="Active";
}
else
memactstatus=(String) MemAccountStatus.typeval.get(cmp.getStatus());;


%>
<td ><%=memactstatus%></td>
<td ><a href="/portal/mytasks/ClubUpdMemScreen.jsp?GROUPID=<%=clubid%>&amp;UNITID=13579&amp;memberid=<%=cmp.getMemberId() %>">Edit</a></td>
<%--td ><%=editlink%></td--%>

</tr>
<%
}//for
if (submitbtn==null){ 
%>

 <tr><td align="center" colspan="10">       
       <input type="submit" name="submit"  onClick="javascript:generatePdf('.pdf');" value="Export to PDF"/>
       <input type="submit" name="submit" onClick="javascript:generateExcel('.xsl');" value="Export to Excel"/></td>
  </tr>
  <%}}else{%>
<tr><td align="center" class="inform">No Members. </td></tr>
<tr><td align="center" colspan="7"><input type="button" name="bbbb"  value="Cancel" onClick="javascript:history.back()"/> </td></tr>

<%
}
%>


  </tbody>
  </table>
  </div>
  </form>