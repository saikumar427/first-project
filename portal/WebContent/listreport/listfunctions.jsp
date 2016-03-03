<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.eventbee.authentication.Authenticate"%>
<%!
	Vector getAttendeeListInfo(String groupid){
	return getAttendeeListInfo(groupid, "", "","");
	}

        Vector getAttendeeListInfo(String groupid,String selindex, String paramValue,String sortby){
        String desc="";
      	if("fn_az".equals(sortby)) {
      	sortby="fn";    
      	}
      	if("fn_za".equals(sortby)) {
        sortby="fn";       
   	desc="desc";
   	}
	if("ln_az".equals(sortby)) {
        sortby="ln";
        }
        if("ln_za".equals(sortby)) {
        sortby="ln";
        desc="desc";
        }
        if("bookdate_new".equals(sortby)) {
	      	sortby="bookdate"; 
	      	desc="desc";
      	}
      	if("bookdate_old".equals(sortby)) {
      	sortby="bookdate";      	
      	}
  

        Vector tv=null;
        HashMap traninfo=null;
        DBManager dbmanager=new DBManager();
        String GET_ATTENDEELIST_INFO="";
        if("2".equals(selindex)){
       		    
	GET_ATTENDEELIST_INFO="select UPPER(firstname) as fn,firstname,UPPER(lastname) as ln,lastname,email, phone,state,max(bookdate) as bookdate,city,country, "
			    +" address1,address2,comments,transactiontype,statement,priattendee,authid,attendeeid,attendeekey,a.transactionid,username,company, "
			    +" bookingsource from eventattendee a, attendeeticket b where a.eventid=? and  a.transactionid=b.transactionid and bookingsource='online' "
			    +" group by fn,ln, "
			    +" firstname,lastname,email, phone,state,city,country,address1,address2,comments,transactiontype, "
			    +" statement,priattendee,authid,attendeeid,attendeekey,a.transactionid,username,company,  bookingsource order by "+sortby+" "+desc+"";
        }
        else if("3".equals(selindex)){
        GET_ATTENDEELIST_INFO="select UPPER(firstname) as fn,firstname,UPPER(lastname) as ln,lastname,email, phone,state,max(bookdate) as bookdate,city,country, "
			    +" address1,address2,comments,transactiontype,statement,priattendee,authid,attendeeid,attendeekey,a.transactionid,username,company, "
			    +" bookingsource from eventattendee a, attendeeticket b where a.eventid=? and  a.transactionid=b.transactionid and bookingsource='Manager' "
			    +" group by fn,ln, "
			    +" firstname,lastname,email, phone,state,city,country,address1,address2,comments,transactiontype, "
			    +" statement,priattendee,authid,attendeeid,attendeekey,a.transactionid,username,company,  bookingsource order by "+sortby+" "+desc+"";


        }else if("4".equals(selindex)){	   
      GET_ATTENDEELIST_INFO="select UPPER(firstname) as fn,firstname,UPPER(lastname) as ln,lastname,email, phone,state,max(bookdate) as bookdate,city,country, "
			    +" address1,address2,comments,transactiontype,statement,priattendee,authid,attendeeid,attendeekey,a.transactionid,username,company, "
			    +" bookingsource from eventattendee a, attendeeticket b where a.eventid=? and  a.transactionid=b.transactionid and b.ticketid="+paramValue+" "
			    +" group by fn,ln, "
			    +" firstname,lastname,email, phone,state,city,country,address1,address2,comments,transactiontype, "
			    +" statement,priattendee,authid,attendeeid,attendeekey,a.transactionid,username,company,  bookingsource order by "+sortby+" "+desc+"";


        }else if("1".equals(selindex)){	    
       GET_ATTENDEELIST_INFO="select UPPER(firstname) as fn,firstname,UPPER(lastname) as ln,lastname,email, phone,state,max(bookdate) as bookdate,city,country, "
       			    +" address1,address2,comments,transactiontype,statement,priattendee,authid,attendeeid,attendeekey,a.transactionid,username,company, "
       			    +" bookingsource from eventattendee a, attendeeticket b where a.eventid=? and  a.transactionid=b.transactionid  "
       			    +" group by fn,ln, "
       			    +" firstname,lastname,email, phone,state,city,country,address1,address2,comments,transactiontype, "
       			    +" statement,priattendee,authid,attendeeid,attendeekey,a.transactionid,username,company,  bookingsource order by "+sortby+" "+desc+"";

        }else { 
        GET_ATTENDEELIST_INFO="select distinct firstname || ' ' || lastname  as name,firstname,lastname,email, "
			     +" phone,state,to_char(bookdate,'mm/dd/yyyy') as bookdate,city,country,address1,address2,comments,transactiontype, "
			     +" statement,priattendee,authid,attendeeid,attendeekey,a.transactionid,username,company, "
			     +" bookingsource from eventattendee a, attendeeticket b where a.eventid=? and "
			     +" a.transactionid=b.transactionid order by attendeeid desc";
        }
        
      StatusObj stobj=dbmanager.executeSelectQuery(GET_ATTENDEELIST_INFO,new String[]{groupid});
	         
	        if(stobj.getStatus()){
	                tv=new Vector();
	       		for(int i=0;i<stobj.getCount();i++){
	       		      traninfo=new HashMap();
	       			traninfo.put("firstname",dbmanager.getValue(i,"firstname",""));
				traninfo.put("lastname",dbmanager.getValue(i,"lastname","") );
	       			traninfo.put("name",dbmanager.getValue(i,"name",""));
	       			traninfo.put("company",dbmanager.getValue(i,"company","") );
	       			traninfo.put("city",dbmanager.getValue(i,"city","") );
	       			traninfo.put("attendeeid",dbmanager.getValue(i,"attendeeid","") );
	       			traninfo.put("email",dbmanager.getValue(i,"email",""));
	       			traninfo.put("phone",dbmanager.getValue(i,"phone","") );
	       			traninfo.put("authid",dbmanager.getValue(i,"authid","") );
	       			traninfo.put("address1",dbmanager.getValue(i,"address1","") );
	       			traninfo.put("address2",dbmanager.getValue(i,"address2","") );
	       			traninfo.put("country",dbmanager.getValue(i,"country","") );
	       			traninfo.put("state",dbmanager.getValue(i,"country","") );
	       			traninfo.put("username",dbmanager.getValue(i,"state","") );
	       			traninfo.put("comments",dbmanager.getValue(i,"comments","") );
				traninfo.put("transactionid",dbmanager.getValue(i,"transactionid","") );
				traninfo.put("bookingsource",dbmanager.getValue(i,"bookingsource","") );
	       			traninfo.put("attendeekey",dbmanager.getValue(i,"attendeekey","") );
	       			traninfo.put("transactiontype",dbmanager.getValue(i,"transactiontype","") );
	       			tv.addElement(traninfo);
	       				                  
	       	                 
	       		}
	}
                       
		       
               
	return tv;
    }
    
    
 HashMap getEventDetails(String groupid){
 String query="select eventname,venue,start_date ,end_date,address1,address2,venue,country,city from eventinfo where eventid=?";
 ArrayList addressList=new ArrayList();
 DBManager dbmanager=new DBManager();
		HashMap hm=new HashMap();
		StatusObj stobj=dbmanager.executeSelectQuery(query,new String[]{groupid});
		if(stobj.getStatus()){
			hm.put("eventname",dbmanager.getValue(0,"eventname",""));
			hm.put("startdate",dbmanager.getValue(0,"start_date",""));
			hm.put("enddate",dbmanager.getValue(0,"end_date",""));
			hm.put("address1",dbmanager.getValue(0,"address1",""));
			hm.put("address2",dbmanager.getValue(0,"address2",""));
			hm.put("venue",dbmanager.getValue(0,"venue",""));
			hm.put("city",dbmanager.getValue(0,"city",""));
			hm.put("country",dbmanager.getValue(0,"country",""));
			String address2=GenUtil.getHMvalue(hm,"address2","");
			String address1=GenUtil.getHMvalue(hm,"address1","");
			String address=GenUtil.getCSVData(new String[]{GenUtil.getHMvalue(hm,"city",null),GenUtil.getHMvalue(hm,"state",null),GenUtil.getHMvalue(hm,"country",null)});
			
			if(hm.get("venue")!=null)
			addressList.add(GenUtil.AllXMLEncode((String)hm.get("venue")));
			if(address1!=null&&(address1.trim()).length()>0)
			addressList.add(GenUtil.AllXMLEncode(address1));
			if(address2!=null&&(address2.trim()).length()>0)
			addressList.add(GenUtil.AllXMLEncode(address2));
			if(address!=null&&(address.trim()).length()>0)
                        addressList.add(address);
                        
                        hm.put("address",addressList);
			
		}
		return hm;
	}
	   
  
%>
