<%@page import="com.eventbee.authentication.*,java.util.*" %>
<%@ page import="com.eventbee.customconfig.MemberFeatures" %>
<%@ page import="java.io.*, java.util.*,java.sql.*,com.eventbee.nuser.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>

<%!

/*String POPULARLIFESTYLSQ=
" select userid,count(*) as count ,pref_value,getMemberName(a.userid) as name from profilevisitors a, member_preference b " 
+" where a.userid=b.user_id  and user_id in " 
+" (select userid from profilevisitors  group by userid having count(*)>1  order by count(*) desc limit ?) "
+" and b.pref_name ='pref:myurl' group by userid, pref_value,name order by count desc "; 
*/

String POPULARLIFESTYLSQ=
" select userid,count(*) as count ,pref_value,getMemberName(a.userid) as name from profilevisitors a, member_preference b " 
+" where a.userid=b.user_id and visitedtime>to_date(now()::text,'yyyy/mm/dd')-1  and user_id in " 
+" (select userid from profilevisitors where visitedtime>to_date(now()::text,'yyyy/mm/dd')-1 group by userid having count(*)>1  order by count(*) desc limit ?) "
+" and b.pref_name ='pref:myurl' group by userid, pref_value,name order by count desc "; 



List getPopularLifeStyles(String limit){
List poplist=new ArrayList();
	DBManager dbmanager=new DBManager();
	StatusObj statobj=dbmanager.executeSelectQuery( POPULARLIFESTYLSQ,new String[]{limit});
	int recordcounttodata=statobj.getCount();
	if(statobj!=null && statobj.getStatus() && recordcounttodata>0){
	
		for(int i=0;i<recordcounttodata;i++){
			Map popmap=new HashMap();
			popmap.put("userid", dbmanager.getValue(i,"userid","")   );
			popmap.put("count", dbmanager.getValue(i,"count","")   );
			popmap.put("name", dbmanager.getValue(i,"name","")   );
			popmap.put("scrname", dbmanager.getValue(i,"pref_value","")   );
			
			
			poplist.add(popmap);
		}//end for
	
	}//end if

return poplist;

}


%>



<%
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","http://www.eventbee.com");


List poplist=getPopularLifeStyles( "5");




%>



<%

if(request.getParameter("frompagebuilder") !=null)
out.println(PageUtil.startContentForGuest("Popular Lifestyles",request.getParameter("border"),request.getParameter("width"),true,"beelet-header") );
%>

<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center" class="portalback">

<%if(!poplist.isEmpty()){%>

<%

int i=0;
for(Iterator iter=poplist.iterator();iter.hasNext();){
i++;
String htmltdclass=(i%2==0)?"oddbase":"evenbase";
Map popmap=(Map)iter.next();
%>

<tr class1='<%=htmltdclass %>'>

<td align='left' valign='center' class='<%=htmltdclass %>'>
<div>
 <a href="<%=ShortUrlPattern.get((String)popmap.get("scrname")) %>/network"><%=popmap.get("name") %></a>
 
<span class='smallfont' >
[<a href="<%=ShortUrlPattern.get((String)popmap.get("scrname")) %>/network">Network</a> |
<a href="<%=ShortUrlPattern.get((String)popmap.get("scrname")) %>/blog">Blog</a> |
<a href="<%=ShortUrlPattern.get((String)popmap.get("scrname")) %>/photos">Photos</a>] 
  
</span>
<div>

</td>

</tr>
<%
}//end for
%>



<%
}//end if
%>
<!--
<first name last name>
Network | Blog | Photos

<first name last name>
Network | Blog | Photos

-->



</table>
<%
if(request.getParameter("frompagebuilder") !=null)
		out.println(PageUtil.endContent());
%>
