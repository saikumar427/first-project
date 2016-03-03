<%@ page import="java.util.*,com.eventbee.event.*,com.eventbee.general.*,com.eventbee.general.formatting.*" %>

<%!

String GET_SERVICES_BY_LOCATION="select service_name ,serviceid,special_desc from service_master  where lower(region)=? and lower(country)=? order by created_at  desc limit ?";
String GET_SERVICES_BY_COUNTRY="select service_name ,serviceid,special_desc from service_master where lower(country)=? order by created_at  desc limit ?";


Vector getServices(String query,String [] params){

	Vector vec=new Vector();
	HashMap hm=null;
	DBManager dbmanager=new DBManager();
		StatusObj statobj=dbmanager.executeSelectQuery(query,params);
		int recordcount=statobj.getCount();
		if(recordcount>0){
			for(int i=0;i<recordcount;i++){
				hm=new HashMap();
				hm.put("service_name",dbmanager.getValue(i,"service_name",""));
				hm.put("serviceid",dbmanager.getValue(i,"serviceid",""));
				hm.put("special_desc",dbmanager.getValue(i,"special_desc",""));
				vec.add(hm);
			}
		}
	return vec;
}


%>

<%
 int count=5;
 String link="";
 String base="oddbase";
 String location=request.getParameter("lid");
 if(location==null||"".equals(location)||"null".equals(location))location="";
 
 String country=request.getParameter("cid");
 if(country==null||"".equals(country)||"null".equals(country))country="";
  
 if("".equals(location)&&"".equals(country)){
 	country="USA";
 	
	}

 HashMap hm=null;
 Vector result_vec=new Vector();
 if((location!=null&&!"".equals(location)&&!"null".equals(location))&&(country!=null||!"".equals(country)&&!"null".equals(country))){
 
 	location=location.toLowerCase();
	country=country.toLowerCase();

 	result_vec=getServices(GET_SERVICES_BY_LOCATION,new String[]{location,country,Integer.toString(count)});
 
 }
 //if(country!=null&&!"".equals(country)&&"null".equals(location)){
 else{
 	country=country.toLowerCase();
 
 	result_vec=getServices(GET_SERVICES_BY_COUNTRY,new String[]{country,Integer.toString(count)});

	
}


if(result_vec!=null&&result_vec.size()>0){%>


<table border="0" width="100%" cellspacing="0">

<%
	for(int i=0;i<result_vec.size();i++){
		hm=new HashMap();
		
 
		if(i%2==0){
			base="evenbase";
		}else{
			base="oddbase";
		}
		hm=(HashMap)result_vec.elementAt(i);
		
		String groupid=(String)GenUtil.getHMvalue(hm,"serviceid");
		String name=DbUtil.getVal("select getMemberPref(userid||'','pref:myurl','') as name from service_master where userid=(select userid from service_master where serviceid=?)",new String[]{groupid});
		String pattserver=ShortUrlPattern.get(name);
		
		link=pattserver+"/service?GROUPID="+groupid;
		%>
		<tr  class="<%=base%>" width="100%"><td class="<%=base%>"><a HREF="<%=link%>">
		<%=GenUtil.getHMvalue(hm,"service_name","",true)%></a><br/>
		<b>Desihub Member Special: </b> <%=GenUtil.textToHtml(GenUtil.TruncateData(GenUtil.getHMvalue(hm,"special_desc"),100),true)%>
		</td></tr>
	<%}%>
<tr  width="100%" >
	<td align="right" >
	&raquo;&nbsp;<a href="<%=PageUtil.appendLinkWithGroup("/portal/services/services.jsp",(HashMap)request.getAttribute("REQMAP"))%>">All Services</a>&nbsp;&nbsp;&nbsp;
	&raquo;&nbsp;<a href="/portal/auth/listauth.jsp?purpose=listservice">List Service</a>&nbsp;&nbsp;&nbsp;
	&raquo;&nbsp;<a href="/portal/helplinks/ListyourService.jsp">Learn More</a>
	</td>
</tr>	
</table>
<%
}

%>
