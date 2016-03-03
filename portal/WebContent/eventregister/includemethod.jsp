<%!
public static HashMap getRsvpDetails(String groupid,String userid){
DBManager dbmanager=new DBManager();
StatusObj stobj=dbmanager.executeSelectQuery("SELECT attendingevent,email,firstname,lastname,attendeecount,comments,phone,company,address,address1 from rsvpattendee where authid=? and eventid=? ",new String[]{userid,groupid});
HashMap agents=null;
if(stobj.getStatus()){
	agents=new HashMap();
		for(int i=0;i<stobj.getCount();i++){
			
			agents.put("emailid",dbmanager.getValue(i,"email",""));
			agents.put("fname",dbmanager.getValue(i,"firstname","") );
			agents.put("lname",dbmanager.getValue(i,"lastname","") );
			agents.put("count",dbmanager.getValue(i,"attendeecount","") );
			agents.put("comments",dbmanager.getValue(i,"comments",""));
			agents.put("phone",dbmanager.getValue(i,"phone","") );
			agents.put("company",dbmanager.getValue(i,"company","") );
			agents.put("address",dbmanager.getValue(i,"address","") );
			agents.put("address1",dbmanager.getValue(i,"address1","") );
			agents.put("attending",dbmanager.getValue(i,"attendingevent","") );
			agents.put("userid",userid );
		}
	}
	System.out.println("agents: "+agents);
	return agents;
  }
%>
