<%@ page import="java.util.*,java.sql.*,com.eventbee.general.*,com.eventbee.event.EventDB,com.eventbee.event.*" %>
<%@ page import="com.eventbee.hub.hubDB" %>
<%@ page import="com.eventbee.pagenating.*" %>
<%!

 private String stripHTMLTags( String message ) {
    StringBuffer returnMessage = new StringBuffer(message);
    int startPosition = message.indexOf("&lt;"); // encountered the first opening brace
    int endPosition = message.indexOf(">"); // encountered the first closing braces
    while( startPosition != -1 ) {
      returnMessage.delete( startPosition, endPosition+1 ); // remove the tag
      startPosition = (returnMessage.toString()).indexOf("&lt;"); // look for the next opening brace
      endPosition = (returnMessage.toString()).indexOf(">"); // look for the next closing brace
    }
    return returnMessage.toString();
  }

 Vector getHubs(HashMap params,String query1,List queryParams){
	String query="select clubid from clubinfo where unitid=CAST(? AS INTEGER) and status in ('ACTIVE') ";
	String startfrom=GenUtil.getHMvalue(params,"startfrom","0");
	String no_of_records=GenUtil.getHMvalue(params,"no_of_records","0");
	query=query+query1;
	query+=" order by created_at desc limit "+no_of_records+" offset "+startfrom;

	Vector v=hubDB.getHubs(query,(String[])queryParams.toArray(new String[0]));
		return v;
	}
	String buildQuery(HashMap params,List queryParams){
	String query="";
	
	String keyword=GenUtil.getHMvalue(params,"keyword").toLowerCase();
		String type=GenUtil.getHMvalue(params,"type");
		String location=GenUtil.getHMvalue(params,"location");
		String unitid=GenUtil.getHMvalue(params,"unitid","13579");
		String country=GenUtil.getHMvalue(params,"country");
		
		int reqdate=5;
		try{
			reqdate=Integer.parseInt(GenUtil.getHMvalue(params,"reqdate"));
		}catch(Exception e){
			reqdate=5;
			
		}
		queryParams.add(unitid);
		if (!"".equals(keyword)&&keyword!=null){
			query=query+" and lower(clubname) like ? ";
			queryParams.add(keyword);
		}
		if (!"".equals(type) && !"All".equalsIgnoreCase(type)){
			query=query+" and category=? ";
			queryParams.add(type);
		}
	/*	if (!"".equals(location) && !"All".equalsIgnoreCase(location)&&!"null".equals(location)){
			query=query+" and lower(region)=? ";
			queryParams.add(location.toLowerCase());
		}
		if (!"".equals(country) && !"All".equalsIgnoreCase(country)){
			query=query+" and lower(country)=? ";
			queryParams.add(country.toLowerCase());
		} */
		String count=EbeeConstantsF.get("show.hubs.allowable.membercount","0");
		if(reqdate > 0)
		query=query+" and to_date(created_at::text,'yyyy/mm/dd') > to_date(now()::text,'yyyy/mm/dd')-"+reqdate ;
		query=query+" and  getMembersCount(text(clubid))::integer>"+count;
		
		return query;
	}
	
	int getRecordCount(HashMap params,String query1,List queryParams){
	String query=" select count(*) from clubinfo where unitid=? and status in ('ACTIVE') ";
	query=query+query1;
	String count=DbUtil.getVal(query,(String [])queryParams.toArray(new String[queryParams.size()]));
	return Integer.parseInt(count);
	}



%>
<%
		int pageIndex=1;
		int no_of_records=15;
	try{
		pageIndex=Integer.parseInt(request.getParameter(".pageIndex"));
	}catch(Exception e){pageIndex=1;}
	String UNITID=request.getParameter("UNITID");
		
	int reqdate=365*5;
	if(keyword!=null){
		if(!keyword.startsWith("%")) keyword="%"+keyword;
		if(!keyword.endsWith("%")) keyword+="%";
		keyword=keyword.toLowerCase();
	}
	HashMap param=new HashMap();
	param.put("keyword",keyword);
	param.put("type",type);
	//param.put("location",location);
	//param.put("country",country);
	param.put("reqdate",reqdate+"");
	param.put("startfrom",(((pageIndex-1)*no_of_records))+"");
	param.put("no_of_records",no_of_records+"");
	boolean displayhubs=false;
	boolean pageNatingException=false;
	List queryparam=new ArrayList();
	String query=buildQuery(param,queryparam);
	Vector hubVect =getHubs(param,query,queryparam);
	int totalrecords=getRecordCount(param,query,queryparam);

 	pageNating pageNav=new pageNating();
	if(hubVect!=null&& hubVect.size()>0){
		
		contenturl="/portal/hub/clubslisting.jsp?x=y";
		if(country!=null&&!"".equals(country)&&!"null".equals(country))
		contenturl=contenturl+"&country="+country;
		if(location!=null&&!"".equals(location)&&!"null".equals(location))
		contenturl=contenturl+"&location="+location;
		if(reqkeyword!=null&&!"".equals(reqkeyword)&&!"null".equals(reqkeyword))
		contenturl=contenturl+"&keyword="+reqkeyword;
		if(reqtype!=null&&!"".equals(reqtype)&&!"null".equals(reqtype))
		contenturl=contenturl+"&type="+reqtype;

		try{
		
		pageNav.setLink(PageUtil.appendLinkWithGroup(contenturl,(HashMap)request.getAttribute("REQMAP")));

		pageNav.getPagenatingElements(0,pageIndex,no_of_records,totalrecords,hubVect.size());
			displayhubs=true;
			pageNav.setNo_Of_PageIndex(10);
		}catch(Exception e){
			
			displayhubs=false;pageNatingException=true;
		}
	}
	
%>
<html>
<body>
<table border="0" width="100%" align="center" cellspacing="0" class='innerbeelet' cellpadding='0'>

<% if(displayhubs){%>

<%
		String base="oddbase";
		for(int k=0;k<hubVect.size();k++){
			if(k%2==0){
				base="evenbase";
			}else{
				base="oddbase";
			}
			 HashMap hubMap=(HashMap) hubVect.get(k);
%>
			
				<tr width="100%" class="<%=base%>">
					<td colspan="2" height="5"></td>
				</tr>
				<tr class='<%=base%>'>
					<td width='2%'></td>
					<td ><a href='/hub/clubview.jsp?GROUPID=<%=GenUtil.getHMvalue(hubMap,"clubid")%>'><%=GenUtil.getHMvalue(hubMap,"clubname","",true)%></a><!-- - moderator--> 
				</td>
				</tr>	
					<tr class='<%=base%>'>
					<td width='2%'></td>
					<td ><%=GenUtil.TruncateData(stripHTMLTags(GenUtil.getHMvalue(hubMap,"description")),45)%></td>
				</tr>
				<tr width="100%" class="<%=base%>">
					<td colspan="2" height="5"></td>
				</tr>
			
		<%}%>
<tr class='colheader'>
		<td  colspan='2' align='center'>
			<table border='0' cellpadding='2' cellspacing='0' width='100%'>
				<tr>
					<td width='2%'/>
					<td width='30%' align='left'><%=pageNav.showRecordPosition()%></td>
					<td align='right'> <%=pageNav.getPageNavigatorWithPageIndexs("contenttab")%></td>
				</tr>
				<tr><td colspan='3' height='5'/></tr>
			</table>
		</td>
</tr>		
<%}else{%>
	<% if(pageNatingException){%>
	<tr width="100%" >
		<td colspan="2" height="3" align='center'>Invalid PageIndex </td>
	</tr>
	<%}else{%>
	<tr width="100%" >
		<td colspan="2" height="3" align='center'><%=EventbeeStrings.getDisplayName("no.communities","No Communities")%></td>
	</tr>
	<%}%>
<%}%>
</table>
</body>
</html>


