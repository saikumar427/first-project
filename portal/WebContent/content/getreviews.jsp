<%@ page import="com.eventbee.customconfig.MemberFeatures" %>
<%@ page import="java.io.*, java.util.*,java.sql.*,com.eventbee.nuser.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.general.formatting.*" %>

<%!

String RECENTREVIEWDSQ="select logid,title,rating from log_master where logid in(select refid from feature_location where lower(city)=? "
						+" and feature='review') order by posted_dt desc limit ? ";

void getRecentReviews(String loc,String limit,Set popset)
{
	DBManager dbmanager=new DBManager();
	StatusObj statobj=dbmanager.executeSelectQuery( RECENTREVIEWDSQ,new String[]{loc,limit});
	int recordcounttodata=statobj.getCount();
	if(statobj!=null && statobj.getStatus() && recordcounttodata>0){
	
		for(int i=0;i<recordcounttodata;i++){
			Map popmap=new HashMap();
			popmap.put("logid", dbmanager.getValue(i,"logid","")   );
			popmap.put("title", dbmanager.getValue(i,"title","")   );
			popmap.put("rating", dbmanager.getValue(i,"rating","")   );
			
			popset.add(popmap);
			
		}//end for
	}//end if
}
%>

<%

String imgstr="<img src='/home/images/star.gif'/>";
String rating="";
int no_of_starts=0;
 String location=request.getParameter("lid");
 if(location==null||"".equals(location)||"null".equals(location))location="";
 String country=request.getParameter("cid");
 if(country==null||"".equals(country)||"null".equals(country))country="";
 
	
String loc="";
int count=0;

if("".equals(location)&&"".equals(country))
country="usa";

if((location!=null&&!"".equals(location)&&!"null".equals(location))&&(country!=null||!"".equals(country)&&!"null".equals(country))){
        loc=country+"_"+location;
	loc=loc.toLowerCase();
	}
else{
	loc=country;
	loc=loc.toLowerCase();

	
	}
	
	
	



Set popset=new HashSet();

getRecentReviews(loc,"6",popset);

if(popset.size()<6){
	count=6-popset.size();
	loc="global";
	getRecentReviews(loc,Integer.toString(count),popset);
}

%>

<%if(!popset.isEmpty()){%>

<table width="100%" cellpadding="0" cellspacing="0" class="portaltable" align='left'>
<%

int i=0;
for(Iterator iter=popset.iterator();iter.hasNext();){
	i++;
	no_of_starts=0;
	String htmltdclass=(i%2==0)?"oddbase":"evenbase";
	Map reviewmap=(Map)iter.next();
	rating=GenUtil.getHMvalue(reviewmap,"rating","",true);
			
			 if("worst".equals(rating)) no_of_starts=1;
			 else if("poor".equals(rating)) no_of_starts=2;
			 else if("mediocre".equals(rating)) no_of_starts=3;
			 else if("good".equals(rating)) no_of_starts=4;
			 else if("excellent".equals(rating)) no_of_starts=5;
%>

<tr class='<%=htmltdclass%>'>
<td class='<%=htmltdclass%>'><%for (int x=0;x<no_of_starts;x++){%><%=imgstr%><%}%>  <a href="/portal/comments/logdetails.jsp?logid=<%=GenUtil.getHMvalue(reviewmap,"logid","",true)%>">
<font class='smallfont'><%=GenUtil.TruncateData(GenUtil.getHMvalue(reviewmap,"title","",true),20)%></font></a>
</td>
</tr>

<%
}//end for
%>

<tr  width="100%" >
	<td align="right" >
	&raquo;&nbsp;<a href="<%=PageUtil.appendLinkWithGroup("/portal/comments/logview.jsp",(HashMap)request.getAttribute("REQMAP"))%>">All Reviews</a>&nbsp;&nbsp;&nbsp;
	&raquo;&nbsp;<a href="/portal/auth/listauth.jsp?purpose=postlog">Post Review</a>&nbsp;&nbsp;&nbsp;
	&raquo;&nbsp;<a href="/portal/helplinks/PostyourReview.jsp">Learn More</a>
	</td>
</tr>	
</table>

<%
}//end if
%>

