<%@ page import="java.util.*,com.eventbee.event.*,com.eventbee.general.*,com.eventbee.general.formatting.*" %>

<%!
String GET_CLASSIFIEDS_BY_LOCATION="select title,c.classifiedid,premiumlevel,photourl "
	+" from classifieds c,classified_group c1 "
	+" where c.classifiedid=c1.classifiedid and c1.groupid=13579 and purpose='classified' and "
	+" premiumlevel<>'CLASSIFIED_PREMIUM_PLUS_LISTING'"
	+" and status='ACTIVE'  and to_date(expirydate,'yyyy/mm/dd')>to_date(now(),'yyyy/mm/dd') "
	+" and lower(region)=? and lower(country)=? order by postedat desc limit ?";

String GET_FEATURED_CLASSIFIEDS_BY_LOCATION="select title,c.classifiedid,premiumlevel,photourl "
	+" from classifieds c,classified_group c1 "
	+" where c.classifiedid=c1.classifiedid and c1.groupid=13579 and purpose='classified' and "
	+" premiumlevel='CLASSIFIED_PREMIUM_PLUS_LISTING' "
	+" and status='ACTIVE'  and to_date(expirydate,'yyyy/mm/dd')>to_date(now(),'yyyy/mm/dd') "
	+" and lower(region)=? and lower(country)=? order by postedat desc ";

String GET_CLASSIFIEDS_BY_COUNTRY="select title,c.classifiedid,premiumlevel,photourl "
	+" from classifieds c,classified_group c1 "
	+" where c.classifiedid=c1.classifiedid and c1.groupid=13579 and purpose='classified' and "
	+" premiumlevel<>'CLASSIFIED_PREMIUM_PLUS_LISTING'"
	+" and status='ACTIVE'  and to_date(expirydate,'yyyy/mm/dd')>to_date(now(),'yyyy/mm/dd') "
	+" and lower(country)=? order by postedat desc limit ?";

String GET_FEATURED_CLASSIFIEDS_BY_COUNTRY="select title,c.classifiedid,premiumlevel,photourl "
	+" from classifieds c,classified_group c1 "
	+" where c.classifiedid=c1.classifiedid and c1.groupid=13579 and purpose='classified' and "
	+" premiumlevel='CLASSIFIED_PREMIUM_PLUS_LISTING' "
	+" and status='ACTIVE'  and to_date(expirydate,'yyyy/mm/dd')>to_date(now(),'yyyy/mm/dd') "
	+" and lower(country)=? order by postedat desc ";

Vector getClassifieds(String query,String [] params){

	Vector vec=new Vector();
	HashMap hm=null;
	DBManager dbmanager=new DBManager();
		StatusObj statobj=dbmanager.executeSelectQuery(query,params);
		int recordcount=statobj.getCount();
		if(recordcount>0){
			for(int i=0;i<recordcount;i++){
				hm=new HashMap();
				hm.put("title",dbmanager.getValue(i,"title",""));
				hm.put("classifiedid",dbmanager.getValue(i,"classifiedid",""));
				hm.put("premiumlevel",dbmanager.getValue(i,"premiumlevel",""));
				hm.put("photourl",dbmanager.getValue(i,"photourl",""));
				vec.add(hm);
			}
		}
	return vec;
}


%>

<%
HashMap hm=null;
Vector result_vec=new Vector();
Vector featured_vec=null;
int count=0;
String link="";
String base="oddbase";
String location=request.getParameter("lid");
if(location==null||"".equals(location)||"null".equals(location))location="";
String country=request.getParameter("cid");
if(country==null||"".equals(country)||"null".equals(country))country="";



if("".equals(location)&&"".equals(country)){
	country="USA";
	
	}
	
	

if((location!=null&&!"".equals(location)&&!"null".equals(location))&&(country!=null||!"".equals(country)&&!"null".equals(country))){
	location=location.toLowerCase();
	country=country.toLowerCase();

	featured_vec=getClassifieds(GET_FEATURED_CLASSIFIEDS_BY_LOCATION,new String[]{location,country});
	if(featured_vec!=null&&featured_vec.size()>0)
	{
		if(featured_vec.size()>=5){
			result_vec=getClassifieds(GET_CLASSIFIEDS_BY_LOCATION,new String[]{location,country,"2"});
			result_vec.addAll(featured_vec); 
		}
		else {
			count=5-featured_vec.size();
			result_vec=getClassifieds(GET_CLASSIFIEDS_BY_LOCATION,new String[]{location,country,Integer.toString(count)});
			result_vec.addAll(featured_vec); 

		}
	}
	else{ 	
		result_vec=getClassifieds(GET_CLASSIFIEDS_BY_LOCATION,new String[]{location,country,"5"});
	}

}
 
  //if("".equals(location)&&country!=null&&!"".equals(country)){
  else{
	country=country.toLowerCase();
 	featured_vec=getClassifieds(GET_FEATURED_CLASSIFIEDS_BY_COUNTRY,new String[]{country});
 	if(featured_vec!=null&&featured_vec.size()>0)
 	{
 		if(featured_vec.size()>=5){
 			result_vec=getClassifieds(GET_CLASSIFIEDS_BY_COUNTRY,new String[]{country,"2"});
 			result_vec.addAll(featured_vec); 
 		}
 		else {
 			count=5-featured_vec.size();
 		 	result_vec=getClassifieds(GET_CLASSIFIEDS_BY_COUNTRY,new String[]{country,Integer.toString(count)});
			result_vec.addAll(featured_vec); 
 		}
 	}
 	else{
 	
 	 	result_vec=getClassifieds(GET_CLASSIFIEDS_BY_COUNTRY,new String[]{country,"5"});
 	}

 }


 
if(result_vec!=null&&result_vec.size()>0){%>

<table border="0" width="100%"   cellspacing="0">

<%
	for(int i=0;i<result_vec.size();i++){
		hm=new HashMap();
		if(i%2==0){
			base="evenbase";
		}else{
			base="oddbase";
		}
		hm=(HashMap)result_vec.elementAt(i);
		link="/portal/classifieds/classifieddisplay.jsp?purpose=classified&classifiedid="+hm.get("classifiedid");

		%>
		<tr class="<%=base%>" width="100%"><td class="<%=base%>" >
		<%if((hm.get("photourl")!=null)&&(!("".equals(hm.get("photourl"))))){%>
		<a href="<%=link%>"><img src="/home/images/camera.gif" width='13' height="11" border='0' alt="Photo Available"/></a>
		<%}%>

		<% if("yes".equals((String)hm.get("premiumlevel"))||"CLASSIFIED_PREMIUM_LISTING".equals((String)hm.get("premiumlevel"))||"CLASSIFIED_PREMIUM_PLUS_LISTING".equals((String)hm.get("premiumlevel"))){%>
		<a href="<%=link%>">
		<%out.println("<b>"+GenUtil.getHMvalue(hm,"title","",true)+"</b>");%></a>

		<%}else{%>
		<a href="<%=link%>">
		<%out.println(GenUtil.getHMvalue(hm,"title","",true));%></a>
		<%}%>

		
		
		</td></tr>
	<%}%>
	
<tr   width="100%" >
	<td align="right" >
	&raquo;&nbsp;<a href="<%=PageUtil.appendLinkWithGroup("/portal/classifieds/classifiedview.jsp?purpose=classified",(HashMap)request.getAttribute("REQMAP"))%>">All Classifieds</a>&nbsp;&nbsp;&nbsp;
	&raquo;&nbsp;<a href="/portal/auth/listauth.jsp?purpose=classified">List Classified</a>&nbsp;&nbsp;&nbsp;
	&raquo;&nbsp;<a href="/portal/helplinks/PostyourClassified.jsp">Learn More</a>
	</td>
</tr>
</table>
<%
}

%>
