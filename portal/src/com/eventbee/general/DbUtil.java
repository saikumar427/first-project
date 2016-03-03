package com.eventbee.general;

import java.util.*;
import java.sql.*;

public class  DbUtil{
	static final String  CLASS_NAME="DbUtil";
public static StatusObj executeUpdateQueries(DBQueryObj [] dbqueries){
	Connection con=null;
	Connection forcecon=null;
	StatusObj stob=new StatusObj(false,"",null);
	boolean flag=false;
	if(dbqueries!=null&&dbqueries.length>0){
		try{
			con=EventbeeConnection.getConnection();
			con.setAutoCommit(false);
			for(int i=0;i<dbqueries.length;i++){
				DBQueryObj dbquery=dbqueries[i];
				String query=dbquery.getQuery();
				if(query!=null){
					String [] inputparams=dbquery.getQueryInputs();
					if(dbquery.getForcedCommitStatus()){
							if(!flag){
								forcecon=EventbeeConnection.getConnection();
								flag=true;
							}
							stob=DbUtil.executeUpdateQuery(query,inputparams,forcecon);
							if(!stob.getStatus()){
								EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"DbUtil.executeUpdateQueries(DBQueryObj [] )",query,null);
							}
					}else{

							stob=DbUtil.executeUpdateQuery(query,inputparams,con);
							if(!stob.getStatus()){
								EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"DbUtil.executeUpdateQueries(DBQueryObj [] )",query,null);
							}
					}
				}
			}
			if(!stob.getStatus()){
				con.rollback();
				stob=new StatusObj(false, "rollback",null);
			}else{
				con.commit();
				stob=new StatusObj(true, "success","");
			}
			con.close();
			con=null;
			if(flag){
				forcecon.close();
				forcecon=null;
			}
		}catch(Exception e){
			System.out.println("Exception occured at executeUpdateQueries():" +e.getMessage());
		}
        finally{
		try{
			if(con!=null){
			      if(!stob.getStatus()){
				  con.rollback();
			      }
			      con.close();
			}
			if(forcecon!=null){forcecon.close();forcecon=null;}
		}catch(Exception e){}
	}
	}
	return stob;
}
public static StatusObj executeUpdateQuery(String query,String[] inputparams){

	Connection con=null;
	return executeUpdateQuery(query,inputparams,con);
}
public static StatusObj executeUpdateQuery(String query,String[] inputparams,Connection con){

	boolean conclose=false;
	PreparedStatement pstmt=null;
	int result=0;
	StatusObj statobj=new StatusObj(false,"","0",0);
	try{
		if(con==null){
			con=EventbeeConnection.getConnection();
			conclose=true;
		}
		con.setAutoCommit(false);
		pstmt=con.prepareStatement(query);
		for(int i=0;inputparams!=null && i<inputparams.length;i++){
			pstmt.setString(i+1,inputparams[i]);
		}
		result=pstmt.executeUpdate();
		con.commit();
		pstmt.close();
		pstmt=null;
		statobj.setStatus(true);
	}catch(Exception e){
		try{
		con.rollback();
		}
		catch (Exception ex) {
			System.out.println("Exception occured while rollng back the connection"+ex.getMessage());
		}
		result=0;
		System.out.println("Exception occured at executeUpdateQueryin DbUtil.java class:"+e+" "+query+"\n params: "+Arrays.toString(inputparams));
		statobj.setData(e);
		statobj.setErrorMsg(e.getMessage());
		statobj.setStatus(false);
		try{
		if(pstmt!=null && con!=null){
			con.rollback();
			System.out.println("Connection RollBack");
		}
		}catch (Exception ex) {
			// TODO: handle exception
		}
	}finally{
		try{
			if(pstmt!=null){pstmt.close();pstmt=null;}
			if(conclose){
				if(con!=null){con.close();con=null;}
			}
		}catch(Exception e){}
	}
	statobj.setCount(result);
	return statobj;
}



public static String[] getSeqVals(String seqname, int noofvals) throws Exception{
	String[] vals=new String[noofvals];
	int lstseqid=0;
	String query= "select setval('"+seqname+"',nextval('"+seqname+"')+? ) as lastid";
	Connection con=null;
	java.sql.PreparedStatement pstmt=null;
	try{
		con=EventbeeConnection.getConnection();
		pstmt=con.prepareStatement(query);
		pstmt.setInt(1,noofvals-1);
		ResultSet rs=pstmt.executeQuery();
		if(rs.next()){

			lstseqid=rs.getInt("lastid");
		}
		pstmt.close();
		pstmt=null;
		con.close();
		con=null;

	}catch(Exception e){
		EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR,CLASS_NAME, "DbUtil.getSeqVals(seqname,noovals)", e.getMessage(), e);
	}finally{
		try{
			if(pstmt!=null){pstmt.close();pstmt=null;}
			if(con!=null){con.close();con=null;}

		}catch(Exception e){}
	}

	for(int i=noofvals-1;i>=0;i--){
		vals[i]=""+lstseqid;
		lstseqid--;
	}

	return vals;
}
public static List getValues(String Query){
	Connection con=null;
	return getValues(Query,null,con);
}
public static List getValues(String Query,String[] inputparams){
	Connection con=null;
	return getValues(Query,inputparams,con);
}

public static List getValues(String Query,String[] inputparams,Connection con){
		List AL=new ArrayList();

		java.sql.PreparedStatement pstmt=null;
		java.sql.ResultSet rs=null;
		boolean conclose=false;
		try{
			if(con==null){
				con=EventbeeConnection.getReadConnection();
				conclose=true;
			}
			pstmt=con.prepareStatement(Query);
			for(int i=0;inputparams!=null && i<inputparams.length;i++){
				pstmt.setString(i+1,inputparams[i]);
			}
			rs=pstmt.executeQuery();
			while(rs.next()){
				AL.add(rs.getString(1));
			}
		}catch(Exception e){
			System.out.println("Exception Occured at beeadmin/admin/getMemberPhotoNames:"+e);
			AL=null;
		}finally{
			try{
				if(pstmt!=null){pstmt.close();pstmt=null;}
				if(conclose){
					if(con!=null){con.close();con=null;}
				}
			}catch(Exception ef){}
		}
	   return AL;
}
public static String getVal(String query,String[] params){
			Connection con=null;
			java.sql.PreparedStatement pstmt=null;
			String maxval=null;
			try{
					con=EventbeeConnection.getReadConnection("agenda");
					pstmt=con.prepareStatement(query);
					if(params != null){
						for(int i=0;i<params.length;i++){
							pstmt.setString(i+1,params[i]);
						}

					}
					ResultSet rs=pstmt.executeQuery();
					if(rs.next()){
						maxval=rs.getString(1);
					}
					pstmt.close();
					pstmt=null;
					con.close();
					con=null;
			}catch(Exception e){
				try{
					pstmt=con.prepareStatement("abort");
					pstmt.executeQuery();
					System.out.println("aborted");
					}
					catch(Exception iex){
					}
				EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR,CLASS_NAME, "DbUtil.getVal("+query+")", e.getMessage(), e);
				System.out.println("Exception occured at getVal DbUtil.java class:"+e+" "+query+"\n params: "+Arrays.toString(params));
			}
			finally{
				try{
					if (pstmt!=null) pstmt.close();
					if(con!=null) con.close();
				}catch(Exception e){}
			}
			return maxval;
}

public static void main(String args[]) throws Exception{
	String Query="insert into temp(sno,sname,class) values(?,?,?)";

	StatusObj statobj=executeUpdateQuery(Query,new String[]{"12","Uday","BCA"});

}
public static StatusObj setKeyValues(String query,String query1,String id,Map insertMap){
	return 	setKeyValues(query,query1,id,insertMap,null);
}
public static StatusObj setKeyValues(String query,String query1,String id,Map insertMap,Connection con){

	boolean conclose=false;
	PreparedStatement pstmt=null;
	PreparedStatement pstmt1=null;
	ResultSet rs=null;
	int count=0;
	StatusObj statobj=new StatusObj(false,"","0",0);
	if(insertMap==null || insertMap.isEmpty()) return statobj;
	try{
		if(con==null){
			con=EventbeeConnection.getConnection();
			conclose=true;
		}
		con.setAutoCommit(false);
		pstmt=con.prepareStatement(query);
		pstmt.setString(1,id);
		if(query1!=null && !"".equals(query1.trim())){
			pstmt1=con.prepareStatement(query1);
			pstmt1.setString(1,id);
		}

		Set e=insertMap.entrySet();
		for (Iterator i = e.iterator(); i.hasNext();){
			  Map.Entry entry =(Map.Entry)i.next();
			  pstmt.setString(2,(String)entry.getKey());
			  pstmt.setString(3,(String)entry.getValue());
			  if(pstmt1!=null){
				  pstmt1.setString(2,(String)entry.getKey());
				  pstmt1.executeUpdate();
			  }
			  count+=pstmt.executeUpdate();
		}
		if(count>0){
			statobj.setData(insertMap);
			statobj.setStatus(false);
			statobj.setCount(count);
		}else{
			statobj.setCount(0);
		}
		con.commit();
	}catch(Exception e){
		System.out.println("Exception occured at setKeyValues() DbUtil.java class:"+e);
		statobj.setData(e);
		statobj.setErrorMsg(e.getMessage());
		statobj.setStatus(true);
		statobj.setCount(0);
		try{
			con.rollback();
		}catch(Exception e1){System.out.println("Roll back Exception in DbUtil.setKeyValues() :"+e1);}
	}finally{
		try{
			if(pstmt!=null){pstmt.close();pstmt=null;}
			if(pstmt1!=null){pstmt1.close();pstmt1=null;}
			if(conclose){
				if(con!=null){con.close();con=null;}
			}
		}catch(Exception e){}
	}
	return statobj;
}
public static StatusObj getKeyValues(String query,String[] inputParams){
	Connection con=null;
	return getKeyValues(query,inputParams,con);
}

public static StatusObj getKeyValues(String query,String[] inputparams,Connection con){

	boolean conclose=false;
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	Map hm=new HashMap();
	int count=0;
	StatusObj statobj=new StatusObj(false,"","0",0);
	try{
		if(con==null){
			con=EventbeeConnection.getConnection();
			conclose=true;
		}
		pstmt=con.prepareStatement(query);
		for(int i=0;inputparams!=null && i<inputparams.length;i++){
			pstmt.setString(i+1,inputparams[i]);
		}
		rs=pstmt.executeQuery();
		/*if(rs.next()){
			ResultSetMetaData rsmd=rs.getMetaData();
			int colcount=rsmd.getColumnCount();
			do{

			}while(rs.next());
		}*/
		while(rs.next()){
			hm.put(rs.getString(1),rs.getString(2));
			count++;
		}
		if(count>0){
			statobj.setData(hm);
			statobj.setStatus(false);
			statobj.setCount(count);
		}else{
			statobj.setCount(0);
		}
		pstmt.close();
		pstmt=null;
	}catch(Exception e){
		try{
			pstmt=con.prepareStatement("abort");
			pstmt.executeQuery();
			System.out.println("aborted");
			}
			catch(Exception iex){
			}
		System.out.println("Exception occured at getKeyValues() DbUtil.java class:"+e);
		statobj.setData(e);
		statobj.setErrorMsg(e.getMessage());
		statobj.setStatus(true);
		statobj.setCount(0);
	}finally{
		try{
			if(pstmt!=null){pstmt.close();pstmt=null;}
			if(conclose){
				if(con!=null){con.close();con=null;}
			}
		}catch(Exception e){}
	}
	return statobj;
}

}

