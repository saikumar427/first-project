<%@ page import="java.util.*,java.text.*,com.eventbee.general.formatting.*"%>
<%@ page import="com.eventbee.general.*,com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.pdfgen.ReportGenerator"%>
<%!
String heading="class='subheader'";
String rowdisplay(int count){
		if(count%2==0){
			return " class='oddbase'";
		}else{
			return " class='evenbase'";
	   	}
	}






String GET_STATUS="select paymentid from payment_details"
		+" where pay_from_date=? and pay_to_date=?  and unitid=?";


String SALES_SUMMARY="select purpose, membership_name, p.membership_id, unitid, to_number(a.totalamount,'9999.99')-to_number(a.ebeefee,'9999.99') as price,"
		  +" sum(to_number(cardfee,'9999.99')) as pfee,"
		  +" sum(to_number(ebeefee,'9999.99')) as tbfee,"
		  +" getClubMemberCount(''||p.membership_id,?,?,purpose,''||a.totalamount) as qty"
		  +" from transaction a,user_profile c, club_membership_master m, club_member p"
  		  +" where p.clubid=? and  a.unitid=? and a.refid=c.user_id and a.refid=p.userid and m.membership_id=p.membership_id and"
		  +" trandate between ? and ? and"
 		  +" purpose in ('CLUB_MEMBERSHIP','MEMBER_SUBSCRIPTION')"
		  +" group by purpose,term_fee,unitid,membership_name, p.membership_id,a.totalamount,a.ebeefee order by purpose";









Map GetSalesSummary(String query,String [] params,Set mshipidset){
	DBManager dbmanager=new DBManager();
	Map mainHM=new HashMap();
	
	StatusObj statobj=dbmanager.executeSelectQuery(query,params);
	int recordcount=statobj.getCount();
	
	if(statobj.getStatus()){
		

		for(int i=0;i<recordcount;i++){
		HashMap hm=new HashMap();
			String membership_id=dbmanager.getValue(i,"membership_id","");
			
			
			hm.put("membership_name",dbmanager.getValue(i,"membership_name",""));
			hm.put("pfee",dbmanager.getValue(i,"pfee","0"));
			hm.put("tbfee",dbmanager.getValue(i,"tbfee","0"));
			hm.put("price",dbmanager.getValue(i,"price","0"));
			hm.put("qty",dbmanager.getValue(i,"qty","0"));
			hm.put("purpose",dbmanager.getValue(i,"purpose",""));
			hm.put("unitid",dbmanager.getValue(i,"unitid","0"));
			hm.put("total",dbmanager.getValue(i,"total","0"));
			
			ArrayList arrlist=(ArrayList)mainHM.get(membership_id);
			if(arrlist==null){
				arrlist=new ArrayList();
				}
				
			arrlist.add(hm);
			mshipidset.add(membership_id);
			mainHM.put(membership_id,arrlist);
			

		}
	}
	
	return mainHM;
	}

Vector GetDates(Date d,int no_of_months){
	DateFormat DATEFORMAT=new SimpleDateFormat("MM/dd/yyyy");
	Vector vec=new Vector();
	HashMap hmp=null;
	boolean flag=true;
	Date dt1=null,dt2=null;
	GregorianCalendar calendar = new GregorianCalendar();
	calendar.setTime(d);

		for(int i=0;i<no_of_months;i++){
		hmp=new HashMap();
		dt1=new Date(calendar.get(Calendar.YEAR)-1900,(calendar.get(Calendar.MONTH)),calendar.get(Calendar.DATE));
		hmp.put("one",DATEFORMAT.format(dt1));
		int day1=1;

			if(flag)
			{
			day1=15;
			flag=false;
			}
			else{
			flag=true;
			day1=calendar.getActualMaximum(Calendar.DATE);
			}

		calendar.set(Calendar.DATE,day1);
		dt2=new Date(calendar.get(Calendar.YEAR)-1900,(calendar.get(Calendar.MONTH)),calendar.get(Calendar.DATE));
		hmp.put("two",DATEFORMAT.format(dt2));
		calendar.add(Calendar.DATE,1);
		vec.add(hmp);
		}
return vec;
}

int getMonths(GregorianCalendar gc1, GregorianCalendar gc2) {

      int elapsed = 0;

      gc1.clear(Calendar.MILLISECOND);
      gc1.clear(Calendar.SECOND);
      gc1.clear(Calendar.MINUTE);
      gc1.clear(Calendar.HOUR_OF_DAY);
      gc1.clear(Calendar.DATE);

      gc2.clear(Calendar.MILLISECOND);
      gc2.clear(Calendar.SECOND);
      gc2.clear(Calendar.MINUTE);
      gc2.clear(Calendar.HOUR_OF_DAY);
      gc2.clear(Calendar.DATE);

      while ( gc1.before(gc2) ) {
         gc1.add(Calendar.MONTH, 1);
         elapsed++;
      }
      return elapsed;
   }

boolean getData(String sdate,String edate,Map saleshm,Vector v2,Set mshipidset,ReportGenerator report, StringBuffer content,double [] totals){


boolean flag=false;
//String sdate="";
//String edate="";
double totalbfee=0.00;
double totalpfee=0.00;
double total=0.00;
double totsale=0.00;

double totbfee=0.00;
double totpfee=0.00;
double totalsales=0.00;
double totalsales1=0.00;
double beefee=0.00;
double beefee1=0.00;
double unittot=0.00;
double unittot1=0.00;
double net=0.00;
double net1=0.00;
boolean showeventname=true;

if(mshipidset!=null&&mshipidset.size()>0){

	Iterator iter=mshipidset.iterator();
	
	if(saleshm!=null&&saleshm.size()>0){
	report.startRow(content,"class='evenbase'");
	
	report.fillColumn(content,null,sdate);
	
	report.fillColumn(content,null,edate);
	//report.fillColumn(content,null,"");
	//report.fillColumn(content,null,"");
	report.fillColumn(content,null,"");
	report.fillColumn(content,null,"");
	report.fillColumn(content,null,"");
	report.fillColumn(content,null,"");
	report.fillColumn(content,null,"");
	report.fillColumn(content,null,"");
	report.fillColumn(content,null,"");
         report.endRow(content);

	
        
	
		for(int p=0;iter.hasNext();p++){

			ArrayList arrlist=(ArrayList)saleshm.get((String)iter.next());
			if(arrlist!=null&&arrlist.size()>0){
				int count=arrlist.size();
				String qty="0";
				
				
																
				for(int i=0;i<count;i++){
				
					HashMap hm=(HashMap)arrlist.get(i);
					
					qty=(String)hm.get("qty");
				
                                         
					if(Integer.parseInt(qty)>0 && Double.parseDouble((String)hm.get("price"))>0 ){
						flag=true;
						
		                                report.startRow(content,"class='oddbase'");
		                                report.fillColumn(content,null,"");
						report.fillColumn(content,null,"");
						if("CLUB_MEMBERSHIP".equals((String)hm.get("purpose"))){
						       report.fillColumn(content,null,"Sign up:"+GenUtil.AllXMLEncode((String)hm.get("membership_name")));
							
						}else{
						
						     
						      report.fillColumn(content,null,"Renewal:"+GenUtil.AllXMLEncode((String)hm.get("membership_name")));
							
							
						}
						//report.fillColumn(content,null,(CurrencyFormat.getCurrencyFormat("",(String)hm.get("price"),true)));

						beefee1=Double.parseDouble((String)hm.get("tbfee"))/Integer.parseInt(qty);
						unittot1=beefee1+Double.parseDouble((String)hm.get("price"));
						totalsales1=unittot1*Integer.parseInt(qty);
						net1=totalsales1-Double.parseDouble((String)hm.get("tbfee"))-Double.parseDouble((String)hm.get("pfee"));

						//report.fillColumn(content,null,(CurrencyFormat.getCurrencyFormat("",beefee1+"",true)));
						report.fillColumn(content,null,(CurrencyFormat.getCurrencyFormat("",unittot1+"",true)));
						report.fillColumn(content,null,qty);
						report.fillColumn(content,null,(CurrencyFormat.getCurrencyFormat("",totalsales1+"",true)));
						report.fillColumn(content,null,(CurrencyFormat.getCurrencyFormat("",(String)hm.get("tbfee"),true)));
						report.fillColumn(content,null,(CurrencyFormat.getCurrencyFormat("",(String)hm.get("pfee"),true)));
						report.fillColumn(content,null,(CurrencyFormat.getCurrencyFormat("",net1+"",true)));
						report.endRow(content); 
						
						totsale=totsale+totalsales1;
						//System.out.println("totsale=========="+totsale);
						totalbfee=totalbfee+Double.parseDouble((String)hm.get("tbfee"));
						totalpfee=totalpfee+Double.parseDouble((String)hm.get("pfee"));
						total=total+net1;
                                   
					}
				}//for arrlist
			}//if arrlsit
		}// for p=0
	} //if saleshm
}//if mshipidset
String eventid="";
/*if(v2!=null&&v2.size()>0){
for(int q=0;q<v2.size();q++){
HashMap mp2=(HashMap)v2.elementAt(q);
String ref_id=(String)mp2.get("eventid");
if(!eventid.equals(ref_id)){
	sb.append("<tr class='evenbase'><td></td><td></td>");
	sb.append("<td><b>"+GenUtil.AllXMLEncode((String)mp2.get("eventname"))+"</b></td>");
	sb.append("<td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>");
	sb.append("<tr class='evenbase'><td></td><td></td>");
	sb.append("<td>("+(String)mp2.get("startdate")+")</td>");
	sb.append("<td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>");
	showeventname=false;
}
if(Integer.parseInt((String)mp2.get("qty"))>0 && Double.parseDouble((String)mp2.get("ticket_price"))>0 ){
flag=true;
	sb.append("<tr class='evenbase'><td></td><td></td>");
	sb.append("<td>- "+GenUtil.AllXMLEncode((String)mp2.get("ticket_name"))+"</td>");
	sb.append("<td>"+(CurrencyFormat.getCurrencyFormat("",(String)mp2.get("ticket_price"),true))+"</td>");
	sb.append("<td>"+(CurrencyFormat.getCurrencyFormat("",(String)mp2.get("bfee"),true))+"</td>");
	unittot=Double.parseDouble((String)mp2.get("bfee"))+Double.parseDouble((String)mp2.get("ticket_price"));
	totalsales=unittot*Integer.parseInt((String)mp2.get("qty"));
	totbfee=Integer.parseInt((String)mp2.get("qty"))*Double.parseDouble((String)mp2.get("bfee"));
	totpfee=Integer.parseInt((String)mp2.get("qty"))*Double.parseDouble((String)mp2.get("pfee"));
	net=totalsales-totbfee-totpfee;
	sb.append("<td>"+(CurrencyFormat.getCurrencyFormat("",unittot+"",true)));
	sb.append("<td>"+(String)mp2.get("qty")+"</td>");
	sb.append("<td>"+(CurrencyFormat.getCurrencyFormat("",totalsales+"",true)));
	sb.append("<td>"+(CurrencyFormat.getCurrencyFormat("",totbfee+"",true))+"</td>");
	sb.append("<td>"+(CurrencyFormat.getCurrencyFormat("",totpfee+"",true))+"</td>");
	sb.append("<td>"+(CurrencyFormat.getCurrencyFormat("", net+"",true))+"</td><td></td></tr>");

	totsale=totsale+totalsales;
	totalbfee=totalbfee+totbfee;
	totalpfee=totalpfee+totpfee;
	total=total+net;
	}
	eventid=ref_id;

}//for
}//v2
*/

if(totsale>0||totalbfee>0||totalpfee>0||total>0){
report.startRow(content,"class='oddbase'");
		
	report.fillColumn(content,null,"Total");
	report.fillColumn(content,null,"");
	//report.fillColumn(content,null,"");
	//report.fillColumn(content,null,"");
	report.fillColumn(content,null,"");
	report.fillColumn(content,null,"");
	report.fillColumn(content,null,"");
	report.fillColumn(content,null,(CurrencyFormat.getCurrencyFormat("$",totsale+"",true)));
	report.fillColumn(content,null,(CurrencyFormat.getCurrencyFormat("$",totalbfee+"",true)));
	report.fillColumn(content,null,(CurrencyFormat.getCurrencyFormat("$",totalpfee+"",true)));
	report.fillColumn(content,null,(CurrencyFormat.getCurrencyFormat("$",total+"",true)));
	report.endRow(content);	  
						
	totals[0]=totsale+totals[0];
	totals[1]=totalbfee+totals[1];
	totals[2]=totalpfee+totals[2];
	totals[3]=total+totals[3];
}
return flag;
}

%>

<%
String groupid=request.getParameter("groupid");


EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"sales_reports.jsp","Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
String unitid=null;
    Authenticate authData=AuthUtil.getAuthData(pageContext);
		if (authData!=null){
			unitid=authData.getUnitID();
		}
	if(unitid==null)
	unitid=request.getParameter("unitid");

Set mshipidset=new TreeSet();
String submitbtn=request.getParameter("submit");
String startMonth="",endMonth="",startYear="",endYear="",mons="";
DateFormat DATEFORMAT=new SimpleDateFormat("MM/dd/yyyy");
Vector v=new Vector();
Date dt1=null,dt2=null;
String startdate="",enddate="";
String selindex=request.getParameter("selindex");
int selectedvalue=0;
if (selindex!=null)
selectedvalue=Integer.parseInt(selindex);

java.util.Date dt=new java.util.Date();
GregorianCalendar calendar = new GregorianCalendar();
GregorianCalendar calendar1 = new GregorianCalendar();
GregorianCalendar cal = new GregorianCalendar();
cal.setTime(dt);
int reqmons=0;

if(selectedvalue==1){
	calendar.set(Calendar.DATE,1);
	calendar.set(Calendar.MONTH,0);
	calendar.set(Calendar.YEAR,2005);
	dt1=new Date(calendar.get(Calendar.YEAR)-1900,(calendar.get(Calendar.MONTH)),calendar.get(Calendar.DATE));
	calendar1.setTime(dt);
	reqmons=getMonths(calendar,calendar1);
	reqmons=reqmons*2;
	if(calendar1.get(Calendar.DATE)<=15)
	reqmons=reqmons-2;
	else if(calendar1.get(Calendar.DATE)>15)
	reqmons=reqmons-1;
	v=GetDates(dt1,reqmons);


}



else if(selectedvalue==2){
	startMonth=request.getParameter("startMonth");
	int startmonth1=Integer.parseInt(startMonth);
	startYear=request.getParameter("startYear");
	int startyear1=Integer.parseInt(startYear);

	endMonth=request.getParameter("endMonth");
	int endmonth1=Integer.parseInt(endMonth);
	endYear=request.getParameter("endYear");
	int endyear1=Integer.parseInt(endYear);

	calendar.set(Calendar.DATE,1);
	calendar.set(Calendar.MONTH,startmonth1-1);
	calendar.set(Calendar.YEAR,startyear1);
	dt1=new Date(calendar.get(Calendar.YEAR)-1900,(calendar.get(Calendar.MONTH)),calendar.get(Calendar.DATE));

	calendar1.set(Calendar.DATE,1);
	calendar1.set(Calendar.MONTH,endmonth1-1);
	calendar1.set(Calendar.YEAR,endyear1);
	dt2=new Date(calendar1.get(Calendar.YEAR)-1900,(calendar1.get(Calendar.MONTH)),calendar1.get(Calendar.DATE));

	if (calendar.after(calendar1)){
		if(calendar.after(cal)||(calendar.get(Calendar.MONTH)==cal.get(Calendar.MONTH))){
			reqmons=getMonths(calendar1,cal)+1;
			reqmons=reqmons*2;
				if(cal.get(Calendar.DATE)<=15)
				reqmons=reqmons-4;
				else if(cal.get(Calendar.DATE)>15)
				reqmons=reqmons-3;

			v=GetDates(dt2,reqmons);

		}
		else{
			reqmons=getMonths(calendar1,calendar)+1;
			reqmons=reqmons*2;

			v=GetDates(dt2,reqmons);
		}
	}
	else{
		if(calendar1.after(cal) || (calendar1.get(Calendar.MONTH)==cal.get(Calendar.MONTH) )   ){
			reqmons=getMonths(calendar,cal)+1;
			reqmons=reqmons*2;
				if(cal.get(Calendar.DATE)<=15)
				reqmons=reqmons-4;
				else if(cal.get(Calendar.DATE)>15)
				reqmons=reqmons-3;

				v=GetDates(dt1,reqmons);
		}
		else{
			reqmons=getMonths(calendar,calendar1)+1;
			reqmons=reqmons*2;

			v=GetDates(dt1,reqmons);
		}
	}
}

Collections.reverse(v);




		
		
		
		Vector v1=new Vector();
		Vector v2=new Vector();
		HashMap mp=null,hm=null,mp2=null;
		String displaypurpose="";
		String paymentid="";
		boolean showeventname=true;
		String sdate="";
		String edate="";
		double totalbfee=0.00;
		double totalpfee=0.00;
		double total=0.00;
		double totsale=0.00;
		double totalsales=0.00;
		double totalsales1=0.00;
		double beefee=0.00;
		double beefee1=0.00;
		double unittot=0.00;
		double unittot1=0.00;
		double net=0.00;
		double net1=0.00;
		double [] totals=new double [4];
		boolean showgrandtotal=false;
		
		HashMap pmap=new HashMap();
		String rtype=request.getParameter("rtype");
		
		if(rtype==null)rtype="html";
		rtype=rtype.trim();
		ReportGenerator report=ReportGenerator.getReportGenerator(rtype);
		StringBuffer content= new StringBuffer();
		report.startContent(content,"");
		String Style="class='colheader'";
		
                report.startTable(content,null,"11");
		
		
			if(v!=null&&v.size()>0){
			
			report.startRow(content,Style);
					report.fillColumn(content,null,"Start Date");
					
					report.fillColumn(content,null,"End Date");
					report.fillColumn(content,null,"Item");
					//report.fillColumn(content,null,"Unit Price ($)");
					
					//report.fillColumn(content,null,"Eventbee Fee ($)");
					
					report.fillColumn(content,null,"Unit Total ($)");
					
					report.fillColumn(content,null,"Quantity Sold");
					
					report.fillColumn(content,null,"Total Sales");
					
					report.fillColumn(content,null,"Total Eventbee Fee");
					
					report.fillColumn(content,null,"Total Processing Fee ($)");
					report.fillColumn(content,null,"Net ($)");
					
					
		report.endRow(content);
			
			
				for(int k=0;k<v.size();k++){
				 totalbfee=0.00;
				 totalpfee=0.00;
				 total=0.00;
				 totsale=0.00;
		
				mp=(HashMap)v.elementAt(k);
				
				sdate=GenUtil.getHMvalue(mp,"one","");
				//edate=GenUtil.getHMvalue(mp,"two","")+" 23:59";
				edate=GenUtil.getHMvalue(mp,"two","");
						
				//v1=GetSalesSummary(SALES_SUMMARY,new String []{sdate,edate,unitid,sdate,edate},mshipidset);
								
				Map saleshm=GetSalesSummary(SALES_SUMMARY,new String []{sdate,edate,groupid,unitid,sdate,edate+" 23:59"},mshipidset);
				
				
				
				//v2=GetEventSalesSummary(EVENT_SALES_SUMMARY,new String[]{sdate,edate,unitid});
				paymentid=DbUtil.getVal(GET_STATUS,new String[]{sdate,edate,unitid});
				
				boolean isdatafilled=getData( sdate,edate,saleshm, v2,mshipidset,report,content,totals);
				
				//System.out.println("isdatafilled---------------"+isdatafilled);
				if(isdatafilled){
		showgrandtotal=true;
		
		
		}}
		if(showgrandtotal){
		report.startRow(content,Style);
		report.fillColumn(content,null,"Grand Total");
		report.fillColumn(content,null,"");
		//	report.fillColumn(content,null,"");
		//	report.fillColumn(content,null,"");
	report.fillColumn(content,null,"");
	report.fillColumn(content,null,"");
	report.fillColumn(content,null,"");			
	
	report.fillColumn(content,null,CurrencyFormat.getCurrencyFormat("$",totals[0]+"",true));
	report.fillColumn(content,null,CurrencyFormat.getCurrencyFormat("$",totals[1]+"",true));
	report.fillColumn(content,null,CurrencyFormat.getCurrencyFormat("$",totals[2]+"",true));
	report.fillColumn(content,null,CurrencyFormat.getCurrencyFormat("$",totals[3]+"",true));
	report.endRow(content);
                }}
                                             
                else{
		report.startRow(content,null);
		report.fillColumn(content,null,"No Sales In This Month");
		report.endRow(content);
		}
		report.endTable(content);
                report.endContent(content);


request.setAttribute("REPORTSCONTENT",content.toString());

if("html".equals(rtype)){
String currentdate=DATEFORMAT.format(dt);
%>

<%@ include file="salesreportinclude.jsp" %>

<%}
else if("excel".equals(rtype))
{

%>
<jsp:forward page="salesexcelreports.jsp"/>
<%}
else{%>
<jsp:forward page='/pdfreport1' /> 
<%}%>

</page1>












