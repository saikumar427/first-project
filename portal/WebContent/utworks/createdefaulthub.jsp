
<%@ page import="java.util.*,com.eventbee.general.*,com.eventbee.hub.hubDB" %>

<%!
String PORTAL_USERS_QUERY="select up.first_name,up.user_id,a.login_name"
		+"  from user_profile up,authentication a where  a.acct_status=1 and role_id=-100 and a.user_id=up.user_id";

String CLASS_NAME="utiltools/createdefaulthub.jsp";

String defaultcategory=EbeeConstantsF.get("default.community.category","Other");


List getMembersList(){

	int recordcount=0;
	DBManager dbmanager=new DBManager();
	StatusObj statobj=dbmanager.executeSelectQuery( PORTAL_USERS_QUERY,null);
	List userlist =new ArrayList();
	
	if(statobj !=null && statobj.getStatus()){
		List clublogoList=DbUtil.getValues("select clublogo from clubinfo ",null);
		recordcount=statobj.getCount();
		for(int i=0;i<recordcount;i++){
			String clublogo=dbmanager.getValue(i,"login_name","").trim()+"community";		
			if(!clublogoList.contains(clublogo) ){
				Map usermap=new HashMap();
				usermap.put("firstname", dbmanager.getValue(i,"first_name",""));
				usermap.put("userid", dbmanager.getValue(i,"user_id",""));
				usermap.put("loginname", dbmanager.getValue(i,"login_name","").trim());
				usermap.put("category", defaultcategory);
				userlist.add(usermap);
			}
			
		}
	
	}
	return userlist;
	
}
String USER_DETAILS="select b.clubname,user_id from user_profile a,clubinfo b where a.user_id=b.mgr_id and clubid=?";
Map getUserDetails(String clubid){
	Map usermap=new HashMap();
	DBManager dbmanager=new DBManager();
	StatusObj statobj=dbmanager.executeSelectQuery(USER_DETAILS,new String[]{clubid});
	if(statobj !=null && statobj.getStatus()){
			usermap.put("clubname", dbmanager.getValue(0,"clubname",""));
			usermap.put("userid", dbmanager.getValue(0,"user_id",""));
			usermap.put("groupid", clubid);
	}
return usermap;
}

void createMailListsForExistingHubs(Map hm){
	String clubname=GenUtil.getHMvalue(hm,"clubname","");
	String groupid=GenUtil.getHMvalue(hm,"groupid","");
			
	for(int l=0;l<2;l++){
			String listname="";
			if(!"".equals(clubname))
				clubname=" - "+clubname;
			if(l==0) listname="Active Members"+clubname;
			else listname="Passive Members"+clubname;
			
			StatusObj stobinsert=DbUtil.executeUpdateQuery("insert into mail_list(list_id,list_desc,unit_id,role,list_name,manager_id,created_at)values(nextval('seq_list'),?,?,?,?,?,now())", new String []{"Hub maillist",groupid,"MGR",listname,GenUtil.getHMvalue(hm,"userid")});
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO,CLASS_NAME,"createMailLists","hub inserting stobinsert is :"+stobinsert.getStatus(),null);
			
	}

}
		
%>

<%
List clubidList=DbUtil.getValues("select clubid from clubinfo where clubid not in(select unit_id from mail_list)",null);
if(clubidList!=null&&clubidList.size()>0){	
	for(int i=0;i<clubidList.size();i++){
		if(clubidList.get(i)!=null){
			String listclubid=(String)clubidList.get(i);
			Map usermap=getUserDetails(listclubid);
			if(usermap.size()>0)
			createMailListsForExistingHubs(usermap);
		}
	}
}


List membersList=getMembersList();

int totaluser=0;
	totaluser=membersList.size();
	out.println("totaluser============="+totaluser);
	for(int i=0;i<totaluser;i++){
		HashMap hm =(HashMap)membersList.get(i);
		try{
			String groupid=hubDB.addSignUpHub(hm);
			out.println("groupid============="+groupid);			
			out.println("<br/>");
		}
		catch(Exception ex)
		{
			EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR,CLASS_NAME,"service()","Exception in ex1 block"+ex.getMessage(),null);

		}
	}


%>
