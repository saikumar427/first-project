<%@ page import="com.eventbee.general.*,com.eventbeepartner.partnernetwork.AttendeeListReports" %>
<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.eventbee.authentication.Authenticate,com.customattributes.*"%>
<?xml version="1.0" encoding="UTF-8"?>
<%@ page import="com.eventbee.pdfgen.ReportGenerator" %>

<%!
    String rowdisplay(int count){
		if(count%2==0){
			return " class='oddbase'";
		}else{
			return " class='evenbase'";
	   	}
	}

%>
<%
    String groupid=null;
    String authid=null;
    String role=null;
    String groupname=null;
    String currentdate=null;
   
    Authenticate authData=AuthUtil.getAuthData(pageContext);
    if (authData!=null){
	 authid=authData.getUserID();
	 role=authData.getRoleName();
    }else{
       	 authid=(String)session.getAttribute("transactionid");
    }
    String submitbtn=request.getParameter("submit");
    groupid=request.getParameter("groupid");
    groupname=request.getParameter("GROUPTYPE");
    java.util.Date date=new java.util.Date();
    SimpleDateFormat format=new SimpleDateFormat("MM/dd/yyyy");
    currentdate=format.format(date);
     String selindex=request.getParameter("selindex");
AttendeeListReports reports=new AttendeeListReports();
Vector tv=reports.getAttendeeListInfo(groupid);
String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";

String[] str1=request.getParameterValues("customattrib");



//StringBuffer str=new StringBuffer();
String pageheight=request.getParameter("pageheight");
String pagewidth=request.getParameter("pagewidth");
//String pagewidth="10";
String leftmargin=request.getParameter("leftmargin");
String rightmargin=request.getParameter("rightmargin");
String topmargin=request.getParameter("topmargin");
String bottommargin=request.getParameter("bottommargin");
String colwidth=request.getParameter("colwidth");

//String colwidth="2";
String colheight=request.getParameter("colheight");
String line1fontsize=request.getParameter("line1fontsize");
String line2fontsize=request.getParameter("line2fontsize");
String line1fontfamily=request.getParameter("line1fontfamily");
String line2fontfamily=request.getParameter("line2fontfamily");
pageheight=(pageheight==null)?"11":pageheight;
pagewidth=(pagewidth==null)?"8.5":pagewidth;
leftmargin=(leftmargin==null)?"1":leftmargin;
rightmargin=(rightmargin==null)?"1":rightmargin;
topmargin=(topmargin==null)?"1":topmargin;
bottommargin=(bottommargin==null)?"1":bottommargin;
colwidth=(colwidth==null)?"4":colwidth;
colheight=(colheight==null)?"2":colheight;
line1fontsize=(line1fontsize==null)?"10":line1fontsize;
line2fontsize=(line2fontsize==null)?"9":line2fontsize;
line1fontfamily=(line1fontfamily==null)?"sans-serif":line1fontfamily;
line2fontfamily=(line2fontfamily==null)?"sans-serif":line2fontfamily;
int items=0;
if(tv!=null)
items=tv.size();
int cols=0;
double colwid=0;
int rows=0;
String str=" ";

int balance=0;
double colhigh=0.0;
double height=0.0;
double tabwidth=0.0;
double vermargin=Double.parseDouble(topmargin)+Double.parseDouble(bottommargin);
double hormargin=Double.parseDouble(leftmargin)+Double.parseDouble(rightmargin);

double tabheight=0.0;
int rowsperpage=0;
int pages=0;

try{
 tabwidth=Double.parseDouble(pagewidth)-(double)hormargin;
 colwid=Double.parseDouble(colwidth);
 cols=(int)(tabwidth/colwid);

 tabheight=Double.parseDouble(pageheight)-vermargin;
 colhigh=Double.parseDouble(colheight);

 


 double d=items/cols;
 rows=(int)java.lang.Math.ceil(d);
 double e=tabheight/colhigh;
 double f=java.lang.Math.floor(tabheight/colhigh);
 rowsperpage=(f>e)?((int)f)-1:(int)f;
  pages=(int)rows/rowsperpage;
 balance=items%(rowsperpage*cols);


}
catch(Exception e)
{
System.out.println("Exception ocuured is==="+e);
}
if(rowsperpage>rows)
rowsperpage=rows;

 String custom_setid=CustomAttributesDB.getAttribSetID(request.getParameter("groupid"),"EVENT");


str= str + "<fo:root xmlns:fo='http://www.w3.org/1999/XSL/Format'>"
+"<fo:layout-master-set>"
+"<fo:simple-page-master page-width='"+pagewidth+"' page-height='"+pageheight+"in' master-name='PageMaster'  margin-top='"+topmargin+"in' margin-bottom='"+bottommargin+"in' margin-left='"+leftmargin+"in' margin-right='"+rightmargin+"in' >"
+"<fo:region-body margin='"+leftmargin+" "+rightmargin+""+topmargin+""+bottommargin+" '/>"
+"<fo:region-after display-align='after' extent='10mm'/>"
+"</fo:simple-page-master>"
+"</fo:layout-master-set>";
int attendeeindex=0;
for(int m=0;m<=pages;m++){

str=str+"<fo:page-sequence format='1' initial-page-number='1' force-page-count='no-force' master-reference='PageMaster'>"
+"<fo:static-content flow-name='xsl-region-after'>"
+"<fo:block font-size='9pt' text-align='right'>"
//+"<fo:page-number/>"
+"</fo:block>"
+"</fo:static-content>"
+"<fo:flow line-height='15pt' font-size='12pt' flow-name='xsl-region-body'>"
+"<fo:block>"
+"<fo:block font-weight='bold' color='red' font-size='10pt' text-align='center'>"
+"</fo:block>"
+"<fo:block border-after-width='1pt' border-after-style='solid' font-weight='bold' text-align='right' font-size='10pt'  space-after='1em'>"
+"</fo:block>"
+"<fo:block text-align='center' font-weight='bold' color='red' font-size='10pt' font-family='"+line1fontfamily+"' space-after='1em' />"
+"<fo:table padding-start='15pt' space-after='20pt' table-layout='fixed'  >"

+"<fo:table-column number-columns-repeated='"+cols+"'  column-width='"+colwid+"in'       column-number='1'  />"
+"<fo:table-body>";
if(tv!=null)
{

if(m<pages){

for(int j=0;j<rowsperpage;j++){
str=str + "<fo:table-row font-weight='bold'    height='"+colheight+"in'   >";




for(int i=0;i<cols;i++){

int p=cols*j+i;

HashMap attendeedata=(HashMap)tv.elementAt(attendeeindex++);



str=str + "<fo:table-cell  width='"+colwid+"in' padding='2pt'  text-align='center'  display-align='center' border-width='1pt' border-color='black'   border-style='solid'><fo:table  width='"+colwid+"in' padding-start='15pt' space-after='20pt' table-layout='fixed'  ><fo:table-column number-columns-repeated='1'  column-width='100%'       column-number='1'  /><fo:table-body><fo:table-row font-weight='bold'      ><fo:table-cell  width='100%' padding='2pt'  text-align='center'  display-align='center' border-width='0pt' border-color='black'   border-style='solid'><fo:block font-family='"+line1fontfamily+"'   font-size='"+line1fontsize+"pt'>"+GenUtil.AllXMLEncode((String)attendeedata.get("name"))+"</fo:block></fo:table-cell></fo:table-row>";

	String tid=(String)attendeedata.get("transactionid");
	HashMap attribhm=null;
	HashMap mainhm=CustomAttributesDB.getResponses(custom_setid);
    


if (mainhm!=null && tid!=null){		
		attribhm=(HashMap)mainhm.get(tid);
		
		if(str1!=null){
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"registrationlist.jsp","attribhm is:"+attribhm,"",null);
		if(attribhm!=null&&attribhm.size()>0){
		for(int q=0;q<str1.length;q++){
			String val=(String)attribhm.get(str1[q]);
			if(val==null)val="";
			if(val.indexOf("##")>0)
				val=val.replaceAll("##",", ");
				//str=str+" "+GenUtil.AllXMLEncode(val);

str=str + "<fo:table-row font-weight='bold'><fo:table-cell  width='"+colwid+"in' padding='2pt'  text-align='center'  display-align='center' border-width='0pt' border-color='black'   border-style='solid'><fo:block font-family='"+line2fontfamily+"'   font-size='"+line2fontsize+"pt' text-align='center'>"+GenUtil.AllXMLEncode(val)+"</fo:block></fo:table-cell></fo:table-row>";

		}
		}


		else{
		for(int q=0;q<str1.length;q++){
		str=str+"";	
			
		}
		}

                }
		}
	

str= str +"</fo:table-body>"
+"</fo:table>";

str=str+ "</fo:table-cell>";
}

str= str + "</fo:table-row>";
}

}
if(m==pages){
boolean moreItemsExist=true;
while(moreItemsExist){
str=str + "<fo:table-row font-weight='bold'  font-size='30pt'  height='"+colheight+"in'  >";



for(int i=0;i<cols;i++){

if(tv.size()>attendeeindex){

	HashMap attendeedata=(HashMap)tv.elementAt(attendeeindex++);
	
	String tid=(String)attendeedata.get("transactionid");
	HashMap attribhm=null;
	HashMap mainhm=CustomAttributesDB.getResponses(custom_setid);
    str=str + "<fo:table-cell  width='"+colwid+"in' padding='2pt'  text-align='center'  display-align='center' border-width='1pt' border-color='black'   border-style='solid'><fo:table  width='"+colwid+"in' padding-start='15pt' space-after='20pt' table-layout='fixed'  ><fo:table-column number-columns-repeated='1'  column-width='100%'       column-number='1'  /><fo:table-body><fo:table-row font-weight='bold'      ><fo:table-cell  width='100%' padding='2pt'  text-align='center'  display-align='center' border-width='0pt' border-color='black'   border-style='solid'><fo:block font-family='"+line1fontfamily+"'   font-size='"+line1fontsize+"pt'>"+GenUtil.AllXMLEncode((String)attendeedata.get("name"))+"</fo:block></fo:table-cell></fo:table-row>";
	
	if (mainhm!=null && tid!=null){		
		attribhm=(HashMap)mainhm.get(tid);
		if(str1!=null){
		
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"registrationlist.jsp","attribhm is:"+attribhm,"",null);
		if(attribhm!=null&&attribhm.size()>0){
		for(int p=0;p<str1.length;p++){
			String val=(String)attribhm.get(str1[p]);
			if(val==null)val="";
			if(val.indexOf("##")>0)
				val=val.replaceAll("##",", ");
				
				
	str=str + "<fo:table-row font-weight='bold'><fo:table-cell  width='"+colwid+"in' padding='2pt'  text-align='center'  display-align='center' border-width='0pt' border-color='black'   border-style='solid'><fo:block font-family='"+line2fontfamily+"'   font-size='"+line2fontsize+"pt' text-align='center'>"+GenUtil.AllXMLEncode(val)+"</fo:block></fo:table-cell></fo:table-row>";
		}
		}
		else{
		for(int p=0;p<str1.length;p++){
		str=str+"";	
		}
		}
                }
		}
	
	
str= str +"</fo:table-body>"
+"</fo:table>";
str=str + "</fo:table-cell>";
}
else{
	moreItemsExist=false;
}
}
str= str + "</fo:table-row>";
}}
}

else{

str=str + "<fo:table-row font-weight='bold'><fo:table-cell  width='"+colwid+"in' padding='2pt'  text-align='center'  display-align='center' border-width='0pt' border-color='black'   border-style='solid'><fo:block font-family='"+line2fontfamily+"'   font-size='"+line2fontsize+"pt' text-align='center'>No Attendees Registered</fo:block></fo:table-cell></fo:table-row>";


}

str= str +"</fo:table-body>"
+"</fo:table>"
+"</fo:block>"
+"</fo:flow>"
+"</fo:page-sequence>";
}
str=str+"</fo:root>";








request.setAttribute("REPORTSCONTENT",str);

%>
<jsp:forward page='/pdfreport1'/> 			  
			  
			  
			  
			  
			  
			  
			  
			  
			  
			  
			  
			  
			  

