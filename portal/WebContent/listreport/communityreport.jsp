<%@ page import="java.util.*,java.io.*,javax.servlet.http.*,com.eventbee.event.ticketinfo.AttendeeInfoDB,com.eventbee.general.GenUtil,com.eventbee.general.*,com.eventbee.clubs.*,com.customattributes.*"%>
<%@ include file="filterspecialcharacters.jsp" %>

<%


response.setContentType("application/vnd.ms-excel");  
response.setHeader("Content-disposition","attachment; filename=communityreports.xls");  
	
String CLASSNAME="excelreport.jsp";
String type="";
String userid="";
String firstname="";
String email="";
String	mshipid="";
String startdate="";
String duedate="";
String accstatus="";
String custattrib="";
String clubid="";
String custom_setid=request.getParameter("custom_setid");
clubid=request.getParameter("GROUPID");
List list=CustomAttributesDB.getAttributes(custom_setid);
String membertype=DbUtil.getVal("select value from community_config_settings where key='MEMBER_ACCOUNT_TYPE' and clubid=? ",new String [] {clubid});
List memlist=(List)session.getAttribute("memlist");
out = pageContext.getOut();
String header="Name "+'\t'+"Email"+'\t';
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASSNAME,null,"list.size()  value is---list.size()list.size()list.size()-------"+list.size(),null);
if(list!=null&&list.size()>0){
					for(int p=0;p<list.size();p++){
							header =header+list.get(p)+"\t";
					}
}
header=header+"Membership Type "+'\t'+"Join Date "+'\t'+"Due Date "+'\t'+"Status ";
out.println(header);
String memdata="";
            if(memlist.size()>0 )
            {
               Map mshipmap=(Map)session.getAttribute("mshipmap");
						for(int i=0;i<memlist.size();i++){
							ClubMemberProfile cmp =(ClubMemberProfile) memlist.get(i);
							userid=cmp.getUserId();
							cmp =(ClubMemberProfile) memlist.get(i);
							Map mp=new HashMap();
							String [] mshipids=(String [])mshipmap.get("memids");
							String [] mshipnames=(String [])mshipmap.get("memnames");
							for(int k=0;k<mshipids.length;k++)
									mp.put(mshipids[k],mshipnames[k]);
					firstname= cmp.getFirstName();
					email=cmp.getEmail();
					mshipid=(String)mp.get(cmp.getMemberShipId());
					startdate=cmp.getStartDate();
					duedate=cmp.getDueDate();
					if("EXCLUSIVE".equals(membertype)&&"3".equals(cmp.getStatus())){
					accstatus="Active";}
					else
					
					
					accstatus=(String) MemAccountStatus.typeval.get(cmp.getStatus());
					
					if(list!=null&&list.size()>0){
							HashMap mainhm=CustomAttributesDB.getCommunityResponses(custom_setid);
							HashMap attribhm=null;
							if(mainhm!=null&&mainhm.size()>0){
								
									attribhm=(HashMap)mainhm.get(userid);
									custattrib=custattrib.trim();
									if(attribhm!=null&&attribhm.size()>0){ 
									
									custattrib="";
											for(int p=0;p<list.size();p++){
													
													String val=(String)attribhm.get(list.get(p));
													
													if(val==null||"".equals(val))
													{
													val=" ";
													}
													val=filterSpecialCharacters(val);
													custattrib+=val+"\t";
													}
									}
									else{
											for(int l=0;l<list.size();l++){
											                 
													custattrib+=""+"\t";
													
											}
									}
							}
						}
			out.println(firstname+'\t'+email+'\t'+custattrib+mshipid+'\t'+startdate+'\t'+duedate+'\t'+accstatus);
			
            }
}			
	
%>

