<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.customattributes.CustomAttributesDB" %>
<%!
public static String eid="";
/*private final static String RESPONSE_QUERY="select question_original as attrib_name,bigresponse as response,c.firstname || ' ' || c.lastname as name,"
				+" c.attendeeid  from  custom_questions_response a,"
				+" custom_questions_response_master b,event_reg_transactions c where" 
				+" a.ref_id=b.ref_id and c.attendeeid=b.profileid and"
				+" b.attribsetid=?"
				+" and question_original in (select attribname  from custom_attribs where attrib_setid=? order by position)";*/
public static class RsvpwhoAttending{
	public static HashMap<String,String> getAtrribNames(String eid,String purpose){
	HashMap<String,String> attribsMap=new HashMap();
	String query="select attrib_id,attribname from custom_attrib_master a,custom_attribs b"+
  " where a.groupid=?::INTEGER and a.attrib_setid=b.attrib_setid and a.purpose=?";
	DBManager db=new DBManager();
	StatusObj sb=db.executeSelectQuery(query, new String[]{eid,purpose});
	if(sb.getStatus()){
		for(int i=0;i<sb.getCount();i++){
			attribsMap.put(db.getValue(i, "attrib_id",""), db.getValue(i, "attribname",""));
		}
	}
	return attribsMap;
}
	public static  String ATTENDEE_QUERY="select question_original as attrib_name,bigresponse as response,a.profilekey as profileid,a.fname || ' ' || a.lname as name"		
		+" from custom_questions_response c,custom_questions_response_master d,profile_base_info a,event_reg_transactions  b where a.eventid=CAST(? AS BIGINT) and c.ref_id=d.ref_id and a.transactionid=b.tid and b.paymentstatus='Completed' and b.eventdate=? and question_original in (select attribname from custom_attribs where attrib_setid=?::INTEGER) order by profileid desc";
	
	private final static String RESPONSE_QUERY="select attribid,bigresponse as response,c.fname || ' ' || c.lname as name,b.profileid from custom_questions_response a,custom_questions_response_master b,event_reg_transactions c where c.eventdate=? and a.ref_id=b.ref_id and b.transactionid=c.tid and b.attribsetid=? and  b.groupid=CAST(? AS BIGINT) and  attribid in (select attrib_id from custom_attribs where attrib_setid=?::INTEGER)";
	
	public static HashMap getResponses(String setid,String eid,String eventdate){
		DBManager dbmanager=new DBManager();
		Vector responses=new Vector();
		StatusObj statobj=null;
		HashMap hm=null;
		/*
		if(!"".equals(eventdate)){
			
			statobj=dbmanager.executeSelectQuery(ATTENDEE_QUERY,new String[]{eid,eventdate,setid});
		}
		else{*/
			//System.out.println("else");
			statobj=dbmanager.executeSelectQuery(RESPONSE_QUERY,new String []{eventdate,setid,eid,setid});
		//}
		
		int count=statobj.getCount();
		System.out.println("setid: "+setid);
		System.out.println("count: "+count);
		if(statobj.getStatus()&&count>0){
		hm=new HashMap();
		for(int k=0;k<count;k++){
			String attendeeid=dbmanager.getValue(k,"profileid","");
			
			HashMap options=(HashMap)hm.get(attendeeid);
			if (options==null)
				options=new HashMap();
			options.put(dbmanager.getValue(k,"attribid","0"),dbmanager.getValue(k,"response",""));
			hm.put(attendeeid,options);
			
		}

		}
	
	return hm;
}

public static Vector getRequiredAtribs(String attrib_setid){

//String ATTENDEELIST_ATTRIBUTES="select attribname from custom_attribs where attrib_setid=? order by position";
//String ATTENDEELIST_ATTRIBUTES="select attribname from attendeelist_attributes where attrib_setid=? order by position";
String ATTENDEELIST_ATTRIBUTES="select attrib_id from attendeelist_attributes where attrib_setid=?::INTEGER and attribname in(select attribname from custom_attribs where attrib_setid=?::INTEGER and attrib_id not in (select attribid from buyer_custom_questions where eventid=?::BIGINT))";
	Vector attribsVector=new Vector();
	DBManager dbmanager=new DBManager();
	HashMap hm = null;
	StatusObj statobj=dbmanager.executeSelectQuery(ATTENDEELIST_ATTRIBUTES,new String [] {attrib_setid,attrib_setid,eid});
	if(statobj.getStatus()){
	        for(int k=0;k<statobj.getCount();k++){
			attribsVector.add(dbmanager.getValue(k,"attrib_id",""));
	}
	}
	 return attribsVector;

	}
}

// public static  String VIEW_RSVP_QUERY="select firstname,lastname,attendeecount,attendingevent,attendeeid as atendeeKey   from rsvpattendee where eventid=? ";
public static  String VIEW_RSVP_QUERY_rec="select fname,lname,profileid as atendeeKey,ticketid as attendingevent from profile_base_info where eventid=CAST(? AS BIGINT) and transactionid IN (select tid from event_reg_transactions where eventdate=? and eventid=?)";
 public static  String VIEW_RSVP_QUERY="select fname,lname,profileid as atendeeKey,ticketid as attendingevent from profile_base_info where eventid=?::BIGINT order by profileid";
public static  String count_select_query="select count(tid) from transaction_tickets where ticketid=?::BIGINT and eventid=?";
public static class RsvpAttendeeList{
public static Vector getRSVPList(String eventid,HashMap countmap,String eventdate)
{
eid=eventid;
	Vector v=new Vector();
	Vector v1=new Vector();
	Vector v2=new Vector();
	Vector v3=new Vector();
	HashMap attribsHm=null;
	String custom_setid=DbUtil.getVal("select attrib_setid from custom_attrib_master where groupid=?::INTEGER and purpose =?",new String[]{eventid,"EVENT"});	
	
	
	
	Vector requiredList=RsvpwhoAttending.getRequiredAtribs(custom_setid);
	if(requiredList!=null&&requiredList.size()>0)
		attribsHm=RsvpwhoAttending.getResponses(custom_setid,eventid,eventdate); 
	HashMap<String,String> attribNames=RsvpwhoAttending.getAtrribNames(eventid,"EVENT");
	HashMap responseHm=null;
	int yes=0;
	int notsure=0;
	int no=0;
	String name=null;
	String surecount="",notsurecount="",notattendingcount="";
	DBManager dbmanager=new DBManager();
	
	StatusObj statobj=null;
	if(!"".equals(eventdate)){
		statobj=dbmanager.executeSelectQuery(VIEW_RSVP_QUERY_rec,new String[]{eventid,eventdate,eventid});
	}
	else{
		statobj=dbmanager.executeSelectQuery(VIEW_RSVP_QUERY,new String[]{eventid});
	}
	if(statobj.getStatus()){
		for(int i=0;i<statobj.getCount();i++){
		
			responseHm=null;
			name=dbmanager.getValue(i,"fname","")+" "+dbmanager.getValue(i,"lname","");
			if(attribsHm!=null&& attribsHm.get(dbmanager.getValue(i,"atendeeKey",""))!=null){
				responseHm=(HashMap)attribsHm.get(dbmanager.getValue(i,"atendeeKey",""));
			}
			
			HashMap hm=new HashMap();
			String otherAttribs=name+"<br/><table>";
			if(requiredList!=null&&requiredList.size()>0){
				for(int p=0;p<requiredList.size();p++){
					String attid=(String)requiredList.get(p);
					String attribname=attribNames.get(attid);
					String response=null;
					if(responseHm!=null)
						response=(String)responseHm.get(attid);
						if(response==null)
							response="";
						if("0".equals(attid)){
							otherAttribs="";
							response=name+"<br/><table>";
						}
						else{
							if(response!=null && !"".equals(response.trim())){
								String temp=response.toLowerCase();
								if((temp.startsWith("http://"))||(temp.startsWith("https://"))){
									temp="<a href='"+response+"' target='_blank'>"+response+"</a><br/>";
								}
								if(temp.indexOf("<")==-1){
									temp="<pre style='padding:0px;margin:0px; white-space: pre-wrap; white-space: -moz-pre-wrap !important; white-space: -pre-wrap; white-space: -o-pre-wrap; word-wrap: break-word;'>"+temp+"</pre>";
								}
								//response=attribname+":&nbsp;<pre >"+temp+"</pre><br/>";
								response="<tr><td valign='top'>"+attribname+":&nbsp;</td><td valign='top'>"+temp+"</td></tr>";
							}
						}
						otherAttribs+=response;
						}
				}

				hm.put("name",otherAttribs+"</table>");
				hm.put("attendeecount",dbmanager.getValue(i,"attendeecount","1"));
				hm.put("attendingevent",dbmanager.getValue(i,"attendingevent","yes"));
				if("101".equals(dbmanager.getValue(i,"attendingevent","yes"))){
					try{
						yes=yes+Integer.parseInt(surecount);
						
					}catch(Exception e){yes=yes+1;}
				v1.add(hm);
				}
				else if("102".equals(dbmanager.getValue(i,"attendingevent","notsure"))){
					try{
						notsure=notsure+Integer.parseInt(notsurecount);
												
					}catch(Exception e){notsure=notsure+1;}
				v2.add(hm);
				}else if("no".equals(dbmanager.getValue(i,"attendingevent","no"))){
					try{
						no=no+Integer.parseInt(notattendingcount);
					}catch(Exception e){no=no+1;}
				v3.add(hm);
			}
		}
	}
	countmap.put("yes",yes+"");
	countmap.put("notsure",notsure+"");
	countmap.put("no",no+"");
	v.add(v1);
	v.add(v2);
	v.add(v3);
	
	return v;
	
}
}
%>