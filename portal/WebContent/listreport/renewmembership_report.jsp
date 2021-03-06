<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.EventbeeConnection"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.authentication.*"%>
<%@ page import="com.eventbee.pdfgen.ReportGenerator"%>
<%@ page import="com.eventbee.event.ticketinfo.AttendeeInfoDB"%>
<%@ page import="com.eventbee.general.GenUtil"%>
<%@ page import="org.eventbee.sitemap.util.Presentation" %>
<%!

    String rowdisplay(int count){
    		if(count%2==0){
    			return " class='oddbase'";
    		}else{
    			return " class='evenbase'";
    	   	}
    	}


 static final String GET_MEMBERSHIP_TILLDATE="select a.transactionid,first_name,last_name, "
                        +" to_char(trandate,'mm/dd/yyyy') as trandate1,membership_name,totalamount as price,mgrfee,ebeefee,cardfee "
 +" from transaction a,user_profile c ,club_membership_master m,club_member p "
 +" where p.clubid=? and a.unitid=?   and a.refid=c.user_id and a.refid=p.userid and m.membership_id=p.membership_id and "
 +"purpose='MEMBER_SUBSCRIPTION' and to_date(trandate,'yyyy-MM-dd') < to_date(now(),'yyyy-MM-dd')+1 "
 +"order by trandate desc";

static final String GET_MEMBERSHIP_BETWEENDATES="select a.transactionid,first_name,last_name,"
+" to_char(trandate,'mm/dd/yyyy') as trandate1,membership_name,totalamount as price,mgrfee,ebeefee,cardfee"
+" from transaction a,user_profile b,club_membership_master m,club_member p "
+" where  p.clubid=? and a.unitid=? and a.refid=b.user_id and a.refid=p.userid and m.membership_id=p.membership_id "
+" and purpose='MEMBER_SUBSCRIPTION' and trandate between to_date(?,'mm-dd-yyyy') "
+" and to_date(?,'mm-dd-yyyy') order by trandate desc";  

static final String[] queries =new String[]{GET_MEMBERSHIP_TILLDATE,GET_MEMBERSHIP_BETWEENDATES} ;

         Vector getClubMembership(String clubid,String unitid,int selectedvalue, HttpServletRequest req){
	 System.out.println(unitid);
             Connection con=null;
             Vector tv=null;
             HashMap traninfo=null;
             java.sql.PreparedStatement pstmt=null;
             ResultSet rs=null;
             
	try{
		con=EventbeeConnection.getConnection();
		pstmt=con.prepareStatement(queries[selectedvalue-1]);
		pstmt.setString(1,clubid);
		pstmt.setString(2,unitid);
                if(selectedvalue==2){
			String startdate=req.getParameter("startMonth")+"-"
					+ req.getParameter("startDay")+"-"
					+ req.getParameter("startYear");
			String enddate=req.getParameter("endMonth")+"-"
					+req.getParameter("endDay")+"-"
					+req.getParameter("endYear");
					
			 pstmt.setString(3,startdate);
			 pstmt.setString(4,enddate+" 23:59");
		}
                rs=pstmt.executeQuery();
		if(rs.next()){
			tv=new Vector();
                do{

			traninfo=new HashMap();
                        traninfo.put("transactionid", rs.getString("transactionid"));
			traninfo.put("trandate", rs.getString("trandate1"));
			traninfo.put("firstname", rs.getString("first_name"));
        	       	traninfo.put("lastname", rs.getString("last_name"));
                        traninfo.put("membershipname", rs.getString("membership_name"));
                        String name=rs.getString("first_name")+" "+rs.getString("last_name");
                        String totamt=rs.getString("price");
			String ebeefee=rs.getString("ebeefee");
			String mgrfee=rs.getString("mgrfee");
			double memfee=Double.parseDouble(totamt)-Double.parseDouble(ebeefee);
			if(memfee<0)
			memfee=0.0;
			traninfo.put("name",name);
			traninfo.put("membershipfee",memfee+"");
			traninfo.put("ebeefee", ebeefee);
			traninfo.put("totamt", totamt);
			traninfo.put("cardfee",rs.getString("cardfee"));
			traninfo.put("mgrfee",mgrfee);
			double netfee=Double.parseDouble(totamt)-Double.parseDouble(mgrfee);
			if(netfee<0)
			netfee=0.0;
			traninfo.put("netfee",netfee+"");
        	       	
		    tv.add(traninfo);
                                
                }while(rs.next());
		}
		rs.close();
		pstmt.close();
		pstmt=null;
	}catch(Exception e){
       	System.out.println("There is an error in Membership_report:"+ e.getMessage());
		traninfo=null;
	}
	finally{
		try{
			if (pstmt!=null) pstmt.close();
                        if(con!=null) con.close();
		}catch(Exception e){}
	}
	return tv;
    }
    
 
%>

<%
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"renewmembership_report.jsp","Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
    String groupid=null;
    String unitid=null;
    String groupname=null;
    String currentdate=null;
    String selindex=null;
    int selectedvalue=0;

    Vector tv=null;
    String submitbtn=request.getParameter("submit");
   unitid=request.getParameter("unitid");
	 groupid=request.getParameter("groupid");
	    groupname=request.getParameter("groupname");
    selindex=request.getParameter("selindex"); 
    java.util.Date date=new java.util.Date();	
    SimpleDateFormat format=new SimpleDateFormat("MM/dd/yyyy");
    currentdate=format.format(date);
     if (selindex!=null)
          selectedvalue=Integer.parseInt(selindex);
	  tv=getClubMembership(groupid,unitid,selectedvalue,request);
%>

<%
HashMap pmap=new HashMap();
String rtype=request.getParameter("rtype");
if(rtype==null)rtype="html";
rtype=rtype.trim();
ReportGenerator report=ReportGenerator.getReportGenerator(rtype);
StringBuffer content= new StringBuffer();
report.startContent(content,"");
String Style="class='colheader'";
report.startTable(content,null,"9");
if (tv!=null&&tv.size()>0){
		report.startRow(content,Style);
		report.fillColumn(content,null,"Date");
		
		report.fillColumn(content,null,"Transaction ID");
		report.fillColumn(content,null,"Name");
		report.fillColumn(content,null,"Type");
		
		report.fillColumn(content,null,"Fee ($)");
		
		report.fillColumn(content,null,"Eventbee Fee ($)");
		
		//report.fillColumn(content,null,"Total ($)");
		
		report.fillColumn(content,null,"Processing Fee ($)");
		
		report.fillColumn(content,null,"Net ($)");
		
		report.endRow(content);
double total=0.00;
for(int i=0;i<tv.size();i++){
HashMap hmt=(HashMap)tv.elementAt(i);
total=total+Double.parseDouble((String)hmt.get("netfee"));
             report.startRow(content,rowdisplay(i));
			  report.fillColumn(content,null,GenUtil.AllXMLEncode((String)hmt.get("trandate")));
			  report.fillColumn(content,null,GenUtil.AllXMLEncode((String)hmt.get("transactionid")));
			  report.fillColumn(content,null,GenUtil.AllXMLEncode((String)hmt.get("name")));
			  report.fillColumn(content,null,GenUtil.AllXMLEncode((String)hmt.get("membershipname")));
			  report.fillColumn(content,null,CurrencyFormat.getCurrencyFormat("",(String)hmt.get("membershipfee"), true));
			  report.fillColumn(content,null,CurrencyFormat.getCurrencyFormat("",(String)hmt.get("ebeefee"), true));
			  //report.fillColumn(content,null,CurrencyFormat.getCurrencyFormat("",(String)hmt.get("totamt"), true));
			  report.fillColumn(content,null,CurrencyFormat.getCurrencyFormat("",(String)hmt.get("cardfee"), true));
			  report.fillColumn(content,null,CurrencyFormat.getCurrencyFormat("",(String)hmt.get("netfee"), true));
			  
			  
		report.endRow(content);	  
		}
		 String amount=String.valueOf(total);
		report.startRow(content,null);
		report.fillColumn(content,null,"Total");
		report.fillColumn(content,null,"");
		report.fillColumn(content,null,"");
		report.fillColumn(content,null,"");
		report.fillColumn(content,null,"");
		report.fillColumn(content,null,"");
		report.fillColumn(content,null,"");
		
		report.fillColumn(content,null,CurrencyFormat.getCurrencyFormat("$", amount, true));
		report.endRow(content);


}
else{
report.startRow(content,null);
report.fillColumn(content,null,"No renewals");
report.endRow(content);
}
report.endTable(content);
report.endContent(content);
request.setAttribute("REPORTSCONTENT",content.toString());

%>
<%if("html".equals(rtype)){
request.setAttribute("subtabtype","My Pages");
%>

<%@ include file="renewmemberreport.jsp" %>
<%}
else if("excel".equals(rtype))
{
%>
<jsp:forward page="renewexcel_report.jsp"/>
<%}
else{
%>
<jsp:forward page='/pdfreport1' /> 
<%}%>


.





