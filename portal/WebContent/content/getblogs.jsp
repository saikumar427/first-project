<%@ page import="com.eventbee.customconfig.MemberFeatures" %>
<%@ page import="java.io.*, java.util.*,java.sql.*,com.eventbee.nuser.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.general.formatting.*,javax.naming.*" %>

<%!
String CLASS_NAME="getblogs.jsp";
java.sql.Connection getRollerConnection() throws Exception{
	Context ctx = new InitialContext();
	javax.sql.DataSource ds = (javax.sql.DataSource)ctx.lookup("java:/RollerDb");
	java.sql.Connection con = ds.getConnection();
	return con;
}//end of getconnection

String GET_BLOGIDS="select refid from feature_location where feature='blog' and lower(city)=? limit ?";

 
void getBlogIds(String query,String loc,String limit,Set popset){
	
		DBManager dbmanager=new DBManager();
			StatusObj statobj=dbmanager.executeSelectQuery( query,new String[]{loc,limit});
			int recordcounttodata=statobj.getCount();
			if(statobj!=null && statobj.getStatus() && recordcounttodata>0){
					for(int i=0;i<recordcounttodata;i++){
						popset.add(dbmanager.getValue(i,"refid",""));
					}
		
			}
}

HashMap getBlogDetails(String query){
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"getBlogDetails(String query,String [] params)","blogs",null);
		HashMap hm=new HashMap();
		try{
			java.sql.Connection rolercon=getRollerConnection();
			java.sql.Statement rollpstmt=rolercon.createStatement();
			java.sql.ResultSet rs= rollpstmt.executeQuery(query);

			if(rs.next()){

					hm.put("text",rs.getString("text"));
					hm.put("userid",rs.getString("userid"));
					hm.put("uname",rs.getString("uname"));
					hm.put("fullname",rs.getString("fullname"));
					hm.put("title",rs.getString("title"));
					hm.put("anchor",rs.getString("anchor"));
					hm.put("pubtime",rs.getString("pubtime"));
					hm.put("weblogid",rs.getString("weblogid"));
					hm.put("publishtime",rs.getString("publishtime"));
					
			} 
			rs.close();
			rollpstmt.close();
			rolercon.close();

		}catch(Exception exp){
					 EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR,CLASS_NAME, "getBlogDetails(String query)", exp.getMessage(), exp);
					 System.out.println(exp.getMessage());
			}
			return hm;
}



%>
<%
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","http://www.desihub.com");
String imagedis=EbeeConstantsF.get("thumbnail.photo.image.webpath","")+"/";

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

else {
	loc=country;
	loc=loc.toLowerCase();
	
     }
	
	
Set popset=new HashSet();

getBlogIds(GET_BLOGIDS,loc,"5",popset);

if(popset.size()<5){
	count=5-popset.size();
	loc="global";
	getBlogIds(GET_BLOGIDS,loc,Integer.toString(count),popset);
}

%>





<%if(!popset.isEmpty()){%>
<table width="100%" cellpadding="0" cellspacing="0" class="portaltable">

<%
String eventbeeurl="http://"+EbeeConstantsF.get("ebeeserveraddress","http://192.168.0.177:8080");
int i=0;
for(Iterator iter=popset.iterator();iter.hasNext();){
i++;
String htmltdclass=(i%2==0)?"oddbase":"evenbase";


String refid=(String)iter.next();

/*String ALLWEBLOGS="select a.title as title,a.text as text,a.id as weblogid,a.anchor as anchor ,a.pubtime,a.pubtime as publishtime,b.userid as " 
		+" userid,c.username as uname,c.fullname as fullname from weblogentry a,website b,rolleruser c "
		+" where a.websiteid=b.id and b.userid=c.id and a.id='"+refid+"' order by a.pubtime desc";
*/
String ALLWEBLOGS="select a.title as title,a.text as text,a.id as weblogid,a.anchor as anchor ,"
		+" DATE_FORMAT(a.pubtime,'%Y%m%d') as pubtime,DATE_FORMAT(a.pubtime,'%b %D, %Y %h:%i %p') as publishtime,b.userid as " 
		+" userid,c.username as uname,c.fullname as fullname from weblogentry a,website b,rolleruser c "
		+" where a.websiteid=b.id and b.userid=c.id and a.id='"+refid+"' order by a.pubtime desc";

HashMap blogmap=getBlogDetails(ALLWEBLOGS);
if(blogmap!=null&&!blogmap.isEmpty()){

 String blink=eventbeeurl+"/blogs/"+"page/"+blogmap.get("uname")+"/"+blogmap.get("pubtime")+"#"+blogmap.get("anchor");
 //  String blink=eventbeeurl+"/blogs/"+"page/"+blogmap.get("uname");
  String text=GenUtil.getHMvalue(blogmap,"text");
  text=(text.length()>50)?text.substring(0,49)+"....":text;
%>


<tr class='<%=htmltdclass%>'>
<td class='<%=htmltdclass%>' align='left'><a href="<%=blink%>"><%=text%></a></td></tr>
<tr class='<%=htmltdclass%>'><td class='<%=htmltdclass%>' align='center'>Posted by <%=(String)blogmap.get("fullname")%> on <%=(String)blogmap.get("publishtime")%></td>
</tr>


<%
}
}//end for
%>

</table>
<%
}//end if
%>



