package com.eventbee.classifieds;

import java.util.*;
import com.eventbee.general.*;
import java.sql.*;

public class ClassifiedDB{

public static final String CLASSIFIED_TYPES=" select code,name from classified_types where unitid=? and purpose=?";
public static final String CLASSIFIED_GET=" select substring(location from 1 for 10) as location,c.state,c.country,c.title,c.posted_role,desctype, "
		+" u.first_name||' '||u.last_name as name, "
		+" c.classifiedid,substring(classified from 1 for 15) as classified,classifiedtype, "
		+" c.groupid,grouptype,to_char(postedat,'Month dd, yyyy') as postedat1,to_char(postedat,'dd-mm-yy') "
		+" as postedat2,owner from classifieds c,user_profile u,classified_group c1 where c.classifiedid=c1.classifiedid and "
		 +" c.status='ACTIVE' and to_date(expirydate,'yyyy/mm/dd')>to_date(now(),'yyyy/mm/dd') and c1.groupid=CAST(? AS INTEGER) "
		+" and purpose=? and c.owner=u.user_id order by postedat desc ";
public static final String CLASSIFIED_GET_CLUB=" select substring(location from 1 for 10) as location,c.state,c.country,c.title,c.posted_role,desctype, "
		+" u.first_name||' '||u.last_name as name, "
		+" c.classifiedid,substring(classified from 1 for 15) as classified,classifiedtype, "
		+" c.groupid,grouptype,to_char(postedat,'Month dd, yyyy') as postedat1,to_char(postedat,'dd-mm-yy') "
		+" as postedat2,owner from classifieds c,user_profile u,classified_group c1 where c.classifiedid=c1.classifiedid and c1.groupid=CAST(? AS INTEGER) "
		+" and purpose=? and c.owner=u.user_id order by postedat desc ";
public static final String CLASSIFIED_GET_CLUBVIEW=" select purpose,substring(location from 1 for 10) as location,c.state,c.country,c.title,c.posted_role,desctype, "
		+" u.first_name||' '||u.last_name as name, "
		+" c.classifiedid,substring(classified from 1 for 15) as classified,classifiedtype, "
		+" c.groupid,grouptype,to_char(postedat,'Month dd, yyyy') as postedat1,to_char(postedat,'dd-mm-yy') "
		+" as postedat2,owner from classifieds c,user_profile u,classified_group c1 where c.classifiedid=c1.classifiedid  and c1.groupid=? "
		+" and  c.owner=u.user_id order by postedat desc ";
public static final String GET_CLUBS_NOT_LISTED=" select distinct c.classifiedid,title,to_char(postedat,'Month dd, yyyy') as postedat1 from classifieds c, "
		+" classified_group g where c.classifiedid=g.classifiedid  and owner=? and purpose=? "
		+" and c.classifiedid not in(select g.classifiedid from classifieds c, "
		+" classified_group g where c.classifiedid=g.classifiedid "
		+" and owner=? and purpose=? and g.groupid=?) ";

public static final String InsertClassified="insert into classifieds(classifiedid,classified,"
		+" classifiedtype,groupid,grouptype,owner,postedat,title,location,state,country,posted_role,desctype,purpose,expirydate,status) "
		+" values(?,?,?,?,?,?,current_timestamp,?,?,?,?,?,?,?,to_date(now(),'yyyy/mm/dd')+30,'ACTIVE')";

public static final String DeleteClassified="delete from classifieds where classifiedid=? and owner=?";

public static final String DeleteClassifiedgroup="delete from classified_group where classifiedid=? and groupid=?";

public static final String UpdateClassified="update classifieds set classified=?,title=?,"
		+" location=?,classifiedtype=?,state=?,country=?,desctype=? where classifiedid=?";

public static final String ClassifiedInfo="select owner,purpose,groupid,grouptype,classifiedtype,classified,posted_role,desctype, "
 +" location,title,country,state,to_char(postedat,'Month dd, yyyy') as postedat1,desctype,photourl,phototype,albumid from classifieds where classifiedid=?";

public static final String MY_CLASSIFIED_GET="select substring(location from 1 for 10) as location,state,country,title,posted_role,desctype, "
    	+" classifiedid,substring(classified from 1 for 15) as classified,classifiedtype, "
    	+" groupid,grouptype,to_char(postedat,'dd Mon') as postedat1,to_char(postedat,'Month dd, yyyy') as postedat2,owner from classifieds "
    	+" where owner=? and purpose=? order by postedat desc";
public static final String GET_CLASSIFIED_CONFIG=" select distinct c.clubid,clubname from clubinfo c,club_member c1,config c2 where c.config_id=c2.config_id "
					+" and ((getHubMemberStatus(c.clubid||'',userid)='HUBMGR' and getManagerConfigvalue(c.config_id||'',?)='Yes') "
					+" or (getHubMemberStatus(c.clubid||'',userid)='HUBMEMBER' and getMemberConfigvalue(c.config_id||'',?)='Yes')) "
					+" and c.clubid=c1.clubid and userid=? ";
public static final String INSERT_CLASSIFIED_CLUB=" insert into classified_group(classifiedid,groupid) values(?,?) ";
public static final String DELETE_CLASSIFIED_GROUP="delete from classified_group where classifiedid=?";
public static final String GET_CLASSIFIED_GROUP="select groupid from classified_group where classifiedid=?";

public static final String GET_CLASSIFIED_OWNER="select owner from classifieds where classifiedid=?";
public static final String GET_USER_STATE_COUNTRY="select state,country from user_profile where user_id=?";

public static final String PREMIUM_CLASSIFIEDS="select classified,c.classifiedid,c.groupid,desctype,country,posted_role,title,owner,classifiedtype,state,location,"
		+" trim(to_char(postedat,'dd Mon')) as postedat1, "
		+" to_char(cast(cast(postedat as text) as time),'HH12:MI AM') as ampm,photourl,premiumlevel, "
		+" case when posted_role='Member' then getMemberName(text(owner)) else 'Manager' end as user_name "
		+" from classifieds c,classified_group c1 where c.classifiedid=c1.classifiedid and c1.groupid=? and purpose=? "
		+" and status='ACTIVE' and to_date(expirydate,'yyyy/mm/dd')>to_date(now(),'yyyy/mm/dd') and premiumlevel in ('yes','CLASSIFIED_PREMIUM_PLUS_LISTING') order by postedat desc";

public static final String GET_CLASSIFIED_TITLE="select classifiedid,title from classifieds where owner=? ";

static HashMap getMap(DBManager dbmanager,int position,String [] columnnames)
{
	HashMap classified=new HashMap();
	for(int i=0;i<columnnames.length;i++){
		classified.put(columnnames[i],dbmanager.getValue(position,columnnames[i],""));
		classified.put("postedat",dbmanager.getValue(position,"postedat1",""));
		classified.put("expirydate",dbmanager.getValue(position,"expirydate1",""));
	}
return classified;
}


public static Vector getAllClassifieds(String groupid){
	Vector v=new Vector();
		DBManager dbmanager=new DBManager();
		StatusObj statobj=dbmanager.executeSelectQuery(CLASSIFIED_GET_CLUBVIEW,new String []{groupid});
		if(statobj.getStatus()){
			String [] columnnames=dbmanager.getColumnNames();
			for(int i=0;i<statobj.getCount();i++){
					v.addElement(getMap(dbmanager,i,columnnames));
				}
		}
	return v;
}


public static Vector getAllClassifieds(String groupid,String purpose){
	return getAllClassifieds( groupid, purpose, CLASSIFIED_GET_CLUB,null);
}


public static Vector getAllClassifieds(String groupid,String purpose,String unitid){
	if("13579".equals(unitid))
	return getAllClassifieds( groupid, purpose, CLASSIFIED_GET,unitid);
	else
	return getAllClassifieds( groupid, purpose, CLASSIFIED_GET_CLUB,unitid);
}


public static Vector getAllClassifieds(String groupid,String purpose,String query,String unitid){
	Vector v=new Vector();
	DBManager dbmanager=new DBManager();
	StatusObj statobj=dbmanager.executeSelectQuery(query,new String []{groupid,purpose});
	if(statobj.getStatus()){
	String [] columnnames=dbmanager.getColumnNames();
		for(int i=0;i<statobj.getCount();i++){
			 v.addElement(getMap(dbmanager,i,columnnames));
	 	   }
	}
return v;
}

public static HashMap getClubsForClassifieds(String userid,String purpose)
{
   	HashMap hm=null;
   	DBManager dbmanager=new DBManager();
	StatusObj statobj=dbmanager.executeSelectQuery(GET_CLASSIFIED_CONFIG,new String[]{purpose,purpose,userid});
	int recordcount=statobj.getCount();
	if(recordcount>0)
	hm=new HashMap();
	for(int i=0;i<recordcount;i++){
		hm.put(dbmanager.getValue(i,"clubid",""),dbmanager.getValue(i,"clubname",""));
	}
	  return hm;
   }

public static HashMap getClassifiedInfo(String classifiedid)
{
	HashMap hm=new HashMap();
	DBManager dbmanager=new DBManager();
	StatusObj statobj=dbmanager.executeSelectQuery(ClassifiedInfo,new String []{classifiedid});
	if(statobj.getStatus()){
	String [] columnnames=dbmanager.getColumnNames();
			hm=getMap(dbmanager,0,columnnames);
			List ls=DbUtil.getValues(GET_CLASSIFIED_GROUP,new String []{classifiedid});
			hm.put("groupids",ls);
	}
	return hm;
}

public static int updateClassifieds(HashMap insertMap)
{
	ArrayList dbquery=new ArrayList(0);
	if(insertMap!=null){
		int size=2;
		String [] groupids=(String [])insertMap.get("groupids");
		if(groupids!=null)
		size=size+groupids.length;
		dbquery=new ArrayList(size);
		String [] str=new String[] {(String)insertMap.get("classified"),(String)insertMap.get("title"),(String)insertMap.get("location"),(String)insertMap.get("classifiedtype"),(String)insertMap.get("state"),(String)insertMap.get("country"),(String)insertMap.get("desctype"),(String)insertMap.get("classifiedid")};
		dbquery.add(new DBQueryObj(UpdateClassified,str));
		dbquery.add(new DBQueryObj(DELETE_CLASSIFIED_GROUP,new String[] {(String)insertMap.get("classifiedid")}));
		if(groupids!=null){
			for(int i=0;i<groupids.length;i++){
				dbquery.add(new DBQueryObj(INSERT_CLASSIFIED_CLUB,new String [] {(String)insertMap.get("classifiedid"),groupids[i]}));
			}
		}
	}
	StatusObj statobj=DbUtil.executeUpdateQueries((DBQueryObj [])dbquery.toArray(new DBQueryObj [dbquery.size()]));
	int res=0;
	if(statobj.getStatus())
	res=1;
	return res;
}

public static int deleteFromClassifieds(String classfiedids[],String groupid)
{
StatusObj statobj=new StatusObj(false,"",null);
ArrayList dbquery=null;
	if(classfiedids!=null){
		dbquery=new ArrayList(classfiedids.length);
		for(int i=0;i<classfiedids.length;i++){
  			dbquery.add(new DBQueryObj(DeleteClassifiedgroup,new String [] {classfiedids[i],groupid}));
		}
	 }
	 if(dbquery!=null&&dbquery.size()>0)
	  	statobj=DbUtil.executeUpdateQueries((DBQueryObj [])dbquery.toArray(new DBQueryObj [dbquery.size()]));
  	int res=0;
	if(statobj.getStatus())
	res=classfiedids.length;
	return res;
}
public static int deleteClassifieds(String classfiedids[],String userid)
{
	StatusObj statobj=new StatusObj(false,"",null);
	ArrayList dbquery=null;
	if(classfiedids!=null){
		dbquery=new ArrayList(2*classfiedids.length);
		for(int i=0;i<classfiedids.length;i++){
  			dbquery.add(new DBQueryObj(DELETE_CLASSIFIED_GROUP,new String [] {classfiedids[i]}));
			dbquery.add(new DBQueryObj(DeleteClassified,new String [] {classfiedids[i],userid}));
		}
	 }
	if(dbquery!=null&&dbquery.size()>0)
	  	statobj=DbUtil.executeUpdateQueries((DBQueryObj [])dbquery.toArray(new DBQueryObj [dbquery.size()]));
	int res=0;
	if(statobj.getStatus())
	res=classfiedids.length;
	return res;
}

public static int insertClassifieds(HashMap insertMap)
{
	String classifiedid="0";
	StatusObj statobj=new StatusObj(false,"",null);
	ArrayList dbquery=null;
	if(insertMap!=null){
		String [] groupids=(String [])insertMap.get("groupids");
		int size=1;
		if(groupids!=null)
		size=size+groupids.length;
		dbquery=new ArrayList(size);
		classifiedid=DbUtil.getVal("select nextval('seq_classified')",new String[]{});
		String [] str=new String[] {classifiedid,(String)insertMap.get("classified"),(String)insertMap.get("classifiedtype"),(String)insertMap.get("GROUPID"),(String)insertMap.get("GROUPTYPE"),(String)insertMap.get("owner"),(String)insertMap.get("title"),(String)insertMap.get("location"),(String)insertMap.get("state"),(String)insertMap.get("country"),(String)insertMap.get("posted_role"),(String)insertMap.get("desctype"),(String)insertMap.get("purpose")};
		dbquery.add(new DBQueryObj(InsertClassified,str));
		if(groupids!=null){
		for(int i=0;i<groupids.length;i++){
			dbquery.add(new DBQueryObj(INSERT_CLASSIFIED_CLUB,new String [] {classifiedid,groupids[i]}));
		}
		}
	}
	if(dbquery!=null&&dbquery.size()>0)
	  	statobj=DbUtil.executeUpdateQueries((DBQueryObj [])dbquery.toArray(new DBQueryObj [dbquery.size()]));
	int res=0;
	if(statobj.getStatus())
	res=Integer.parseInt(classifiedid);
	return res;
}
public static Vector getMyClassifieds(String authid){
return getMyClassifieds(authid,null);
}
public static Vector getMyClassifieds(String authid,String purpose){
return getMyClassifieds(authid,purpose,null);
}
public static Vector getMyClassifieds(String authid,String purpose,String unitid){

String query="select substring(c.location from 1 for 10) as location,c.state,c.country,c.title,c.posted_role,c.desctype, "
    	+" c.classifiedid,substring(c.classified from 1 for 15) as classified,c.classifiedtype, "
    	+" c.groupid,c.grouptype,to_char(c.postedat,'dd Mon') as postedat1,to_char(c.postedat,'Month dd, yyyy') as postedat2,c.owner,to_char(c.expirydate,'dd Mon') as expirydate1, to_char(c.expirydate,'Month dd, yyyy') as expirydate2,premiumlevel,photourl from classifieds c";
	if(purpose!=null)
	query=query+" where c.owner=?  and c.purpose=? order by postedat desc ";
	else if(unitid!=null&&"13579".equals(unitid.trim()))
	query=query+" ,classified_group cg where c.classifiedid=cg.classifiedid and to_date(expirydate,'yyyy/mm/dd')>to_date(now(),'yyyy/mm/dd') and status='ACTIVE' and c.owner=? and cg.groupid='13579' order by postedat desc";
	else
	query=query+" where c.owner=?  order by postedat desc";
	 	Vector v=new Vector();
		DBManager dbmanager=new DBManager();
		StatusObj statobj=null;
		String [] st=new String [] {authid};
		if(purpose!=null)
		st=new String [] {authid,purpose};
		return getClassifiedsVector(query,st);
}

public static Vector getClassifieds(HashMap params){

		String query="select classified,c.classifiedid,c.groupid,desctype,country,posted_role,title,owner,classifiedtype,state,location,"
		+" trim(to_char(postedat,'dd Mon')) as postedat1, "
		+" to_char(cast(cast(postedat as text) as time),'HH12:MI AM') as ampm,photourl,premiumlevel, "
		+" case when posted_role='Member' then getMemberName(text(owner)) else 'Manager' end as user_name "
		+" from classifieds c,classified_group c1 where c.classifiedid=c1.classifiedid and c1.groupid=? and purpose=? "
		+" and status='ACTIVE' and to_date(expirydate,'yyyy/mm/dd')>to_date(now(),'yyyy/mm/dd') ";
		String startfrom=GenUtil.getHMvalue(params,"startfrom","0");
		String no_of_records=GenUtil.getHMvalue(params,"no_of_records","0");
		List queryParams=new ArrayList();
		query=buildQuery(query,params,queryParams);
		query=query+" order by postedat desc limit "+no_of_records+" offset "+startfrom;

			return getClassifiedsVector(query,(String [])queryParams.toArray(new String [queryParams.size()]));
}
public static String buildQuery(String query,HashMap params,List queryParams){
	String keyword=GenUtil.getHMvalue(params,"keyword");
	String type=GenUtil.getHMvalue(params,"type");
	String location=GenUtil.getHMvalue(params,"location");
	String groupid=GenUtil.getHMvalue(params,"groupid");
	String purpose=GenUtil.getHMvalue(params,"purpose");
	String country=GenUtil.getHMvalue(params,"country");
	int reqdate=Integer.parseInt(GenUtil.getHMvalue(params,"reqdate","5"));

		queryParams.add(groupid);
		queryParams.add(purpose);

			if (!"".equals(keyword)){
				query=query+" and lower(title) like ? ";
				queryParams.add("%"+keyword.toLowerCase()+"%");
			}
			if (!"".equals(type) && !"All".equalsIgnoreCase(type)){
				query=query+" and classifiedtype=? ";
				queryParams.add(type);

			}
			if (!"".equals(location) && !"All".equalsIgnoreCase(location)){
				query=query+" and state=? ";
				queryParams.add(location);

			}

			if (!"".equals(country) && !"All".equalsIgnoreCase(country)){
				query=query+" and country=? ";
				queryParams.add(country);
			}
			query=query+" and to_date(postedat,'yyyy/mm/dd') > to_date(now(),'yyyy/mm/dd')-"+reqdate;
		return query;
	}
	public static  int getRecordCount(HashMap params){
	String query="select count(*) from classifieds c,classified_group c1 where c.classifiedid=c1.classifiedid and c1.groupid=? and purpose=? "
		+" and status='ACTIVE' and to_date(expirydate,'yyyy/mm/dd')>to_date(now(),'yyyy/mm/dd') ";
	List queryParams=new ArrayList();
	query=buildQuery(query,params,queryParams);
	String count=DbUtil.getVal(query,(String [])queryParams.toArray(new String[queryParams.size()]));
	return Integer.parseInt(count);
	}


public static int enableClassifieds(String configid,HashMap hm)
{
StatusObj statobj=new StatusObj(false,"",null);
ArrayList dbquery=null;
int rs=0;
String deletequery="delete from config where config_id=? and name=? ";
String insertquery="insert into config(config_id,name,value) values(?,?,?)";
if(hm!=null){
	dbquery=new ArrayList();
	Set set=hm.entrySet();
	for( Iterator iter=set.iterator();iter.hasNext();){
		Map.Entry me=(Map.Entry)iter.next();
			if(me.getKey()!=null){
				dbquery.add(new DBQueryObj(deletequery,new String [] {configid,me.getKey().toString()}));
				if(me.getValue()!=null)
				dbquery.add(new DBQueryObj(insertquery,new String [] {configid,me.getKey().toString(),me.getValue().toString()}));
			}
	}
}
	if(dbquery!=null&&dbquery.size()>0)
	  	statobj=DbUtil.executeUpdateQueries((DBQueryObj [])dbquery.toArray(new DBQueryObj [dbquery.size()]));
	if(statobj.getStatus())
	rs=1;
return rs;
}

public static Vector getClubsForClassifiedsToBeListed(String userid,String purpose,String groupid)
   {
   	HashMap hm=null;
	Vector v=null;
   	DBManager dbmanager=new DBManager();
	StatusObj statobj=dbmanager.executeSelectQuery(GET_CLUBS_NOT_LISTED,new String[]{userid,purpose,userid,purpose,groupid});
	int recordcount=statobj.getCount();
	if(recordcount>0)
	v=new Vector();
	for(int i=0;i<recordcount;i++){
	hm=new HashMap();
		hm.put("classifiedid",dbmanager.getValue(i,"classifiedid",""));
		hm.put("title",dbmanager.getValue(i,"title",""));
		hm.put("postedat",dbmanager.getValue(i,"postedat1",""));
		v.add(hm);
	}
	return v;
   }
public static  int insertClassifiedGroup(String groupid,String classifiedid)
{
	DBQueryObj [] dbquery=new DBQueryObj [2];
	DBQueryObj dbobj1=new DBQueryObj();
	dbobj1.setQuery(DeleteClassifiedgroup);
	dbobj1.setQueryInputs(new String[] {classifiedid,groupid});
	DBQueryObj dbobj2=new DBQueryObj();
	dbobj2.setQuery(INSERT_CLASSIFIED_CLUB);
	dbobj2.setQueryInputs(new String[] {classifiedid,groupid});
	StatusObj statobj=DbUtil.executeUpdateQueries(dbquery);
	int res=0;
	if(statobj.getStatus())
	res=0;
	return res;
}



public static HashMap getClassifiedTypes(String [] inputparams){
HashMap hm=null;
String appname=EbeeConstantsF.get("application.name","Eventbee");
String [] names=com.eventbee.general.formatting.EventbeeStrings.getRequiredPurposeTypes(inputparams[1],appname);
String [] codes=com.eventbee.general.formatting.EventbeeStrings.getRequiredPurposeTypes(inputparams[1],appname);
if(!("13579".equals(inputparams[0])))
hm=getUnitClassifiedTypes(inputparams);
if(hm==null){
hm=new HashMap();
hm.put("names",names);
hm.put("codes",codes);
}
return hm;
}



public static HashMap getUnitClassifiedTypes(String [] inputparams){
 	DBManager dbmanager=new DBManager();
	StatusObj statobj=dbmanager.executeSelectQuery(CLASSIFIED_TYPES,inputparams);
	int recordcount=statobj.getCount();
	ArrayList typenames=new ArrayList();
	ArrayList typecodes=new ArrayList();
	HashMap hm=null;
	String code="";
	String name="";
	if(statobj.getStatus()){
	for(int i=0;i<recordcount;i++){
	code=dbmanager.getValue(i,"code","");
	name=dbmanager.getValue(i,"name","");
	typenames.add(name);
	typecodes.add(code);
	}
 	String [] names=(String [])typenames.toArray(new String[typenames.size()]);
	String [] codes=(String [])typecodes.toArray(new String[typecodes.size()]);
	hm=new HashMap();
	hm.put("names",names);
	hm.put("codes",codes);
	}
	return hm;
}

public static HashMap getStateCountry(String authid){
 	DBManager dbmanager=new DBManager();
	HashMap hm=new HashMap();
	StatusObj dbobj=dbmanager.executeSelectQuery(GET_USER_STATE_COUNTRY,new String[]{authid});
	if(dbobj.getCount()>0){
		hm.put("state",dbmanager.getValue(0,"state",""));
		hm.put("country",dbmanager.getValue(0,"country",""));
	}
	return hm;
}

public static Vector getPremiumClassifieds(String unitid,String purpose){
return getClassifiedsVector(PREMIUM_CLASSIFIEDS,new String [] {unitid,purpose});
}

private static Vector getClassifiedsVector(String query,String [] st){
DBManager dbmanager=new DBManager();
		StatusObj statobj=null;
		Vector v=new Vector();
		statobj=dbmanager.executeSelectQuery(query,st);
			if(statobj.getStatus()){
			String [] columnnames=dbmanager.getColumnNames();
				for(int i=0;i<statobj.getCount();i++){
					HashMap classifiedMap=getMap(dbmanager,i,columnnames);
					classifiedMap.put("location",GenUtil.getCSVData(new String[]{dbmanager.getValue(i,"location",""),dbmanager.getValue(i,"state",""),dbmanager.getValue(i,"country","")}));
    		                           v.addElement(classifiedMap);
				}
	 	   	}
return v;
}

}



