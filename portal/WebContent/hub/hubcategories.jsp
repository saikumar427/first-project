<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.general.formatting.EventbeeStrings" %>
<%@ page import="com.eventbee.general.DBManager" %>
<%@ page import="com.eventbee.general.StatusObj" %>
<%@ page import="com.eventbee.general.GenUtil" %>

<%!
public HashMap getCountList()
{

	List paramlist=new ArrayList();
	String count=EbeeConstantsF.get("show.hubs.allowable.membercount","0");
	//String query ="select category,count(*) from clubinfo where status='ACTIVE' "
	//+"and to_date(created_at,'yyyy/mm/dd') > to_date(now(),'yyyy/mm/dd')-1825" 
	//+"group by category";
	
	//query=query+" and  getMembersCount(text(clubid))>"+count;	  
	
	String query="select category, count(*) from clubinfo where clubid in(select clubid from club_member"
				+" group by clubid having count(*)>?) and status='ACTIVE' and to_date(created_at::text,'yyyy/mm/dd') > to_date(now()::text,'yyyy/mm/dd')-1825"
				+" group by category";
	       				
	DBManager dbmanager=new DBManager();

	StatusObj statobj1=dbmanager.executeSelectQuery(query,new String[] {count});
	HashMap hm=new HashMap();
	if(statobj1.getStatus())
	{
		for(int i=0;i<statobj1.getCount();i++)
		{
			hm.put(dbmanager.getValue(i,"category",""),dbmanager.getValue(i,"count",""));
		}
	}
    return hm;
}
%>




	<table cellpadding="0" cellspacing="0" border="0" width="100%">
<%
	
	  String categoryCodestr[]=(String[])categoryCode.toArray(new String[0]);
      String categoryNamestr[]=(String[])categoryName.toArray(new String[0]);
      	///categoryNamestr[]=categoryNamestr.remove(0);
		//categoryCodestr[]=categoryCodestr.remove(0);
	String count=""; 
	HashMap cntmap=getCountList();
	for(int i=1;i<categoryCodestr.length;i++){
		count=(String)GenUtil.getHMvalue(cntmap,categoryNamestr[i],"0");
		
	if(i%2==1){%>
	<tr>
<%}
%>

  
    <td valign='top' class='oddbase'>&diams;&nbsp;
	<a href="/portal/hub/hublisting.jsp?type=<%=categoryNamestr[i]%>&UNITID=13579">
	<b><%=categoryCodestr[i]%></b>
	</a> <font class='smallestfont'> (<%=count%>) </font>
	</td>

<%if(i%2==0){%>
	</tr>
<%}
 

	
 }
%>
	</table>	
	





