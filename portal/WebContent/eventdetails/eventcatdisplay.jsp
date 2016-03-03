<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.general.formatting.EventbeeStrings" %>
<%@ page import="com.eventbee.general.DBManager" %>
<%@ page import="com.eventbee.general.StatusObj" %>
<%@ page import="com.eventbee.general.GenUtil" %>

<%!
public HashMap getCountList(String country,String location,String evttype)
{

	List paramlist=new ArrayList();

	String query ="select category,count(*) from eventinfo where status='ACTIVE' and listType='PBL' and to_date(start_date::text,'yyyy-MM-dd')>=to_date(now()::text,'yyyy-MM-dd')";
	
	         	if(location==null||"USA".equals(location)){
						query=query+" and country='USA'";
						
					}else if(location!=null&&!"USA".equals(location)){
					query=query+" and region=?";
						paramlist.add(location);
					}
					if(evttype!=null){
					query=query+" and type=?";
						paramlist.add(evttype);
					}
				query=query+" group by category";
				
					
	
	
	DBManager dbmanager=new DBManager();

	StatusObj statobj1=dbmanager.executeSelectQuery(query,(String [])paramlist.toArray(new String [paramlist.size()]));
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

	String location=request.getParameter("lid");
	String country=request.getParameter("cid");
	if (location==null)
	country="USA";
	
	//String ebeecategory[]=EventbeeStrings.getCategoryNames();
	  String ebeecategory[]={"Arts","Associations","Books","Business","Career","Community","Corporate","Education","Entertainment","Entrepreneur","Family","Festivals","Food","Games","Health","Movies","Music","Non-Profit","Politics","Religion","Schools","Social","Sports","Technology","Travel","Other"};	
	String count=""; 
	String eventtype=request.getParameter("evttype");
	//if(location==null) location="austin";
	HashMap cntmap=getCountList(country,location,eventtype);
	for(int i=0;i<ebeecategory.length;i++){
		count=(String)GenUtil.getHMvalue(cntmap,ebeecategory[i],"0");
	if(i%2==0){%>
	<tr>
<%}

	if(location!=null&&!"USA".equals(location)){
	
%>
    <td valign='top' class='oddbase'>&diams;&nbsp;
	<a href="/portal/eventdetails/eventcatlist.jsp?category=<%=ebeecategory[i]%>&location=<%=location%>&evttype=<%=eventtype%>&UNITID=13579">
	<b><%=ebeecategory[i]%><b>
	</a> <font class='smallestfont'> (<%=count%>) </font>
	</td>


 <%	}else if(location==null||"USA".equals(location)){%>
 
  	<td valign='top' class='oddbase'>&diams;&nbsp;
	<a href="/portal/eventdetails/eventcatlist.jsp?category=<%=ebeecategory[i]%>&location=<%=country%>&evttype=<%=eventtype%>&UNITID=13579">
	<b><%=ebeecategory[i]%></b>
	</a> <font class='smallestfont'> (<%=count%>) </font>
	</td>
 


 <%} 
 
 
 
 
 }
%>
	</table>	
	
		




