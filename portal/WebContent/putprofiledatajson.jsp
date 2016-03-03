<%@ page import="java.util.*,org.json.JSONArray,org.json.JSONObject"%>
<%@ page import="com.event.dbhelpers.*,com.eventbee.general.*"%>
<%@ page import="java.sql.Connection,java.sql.PreparedStatement"%>
<%!
public String[] getSeqs(int p_count){
	String[] l_seqs=new String[p_count];
	//for(int si=0;si<p_count;si++) l_seqs[si]=""+si;
	try{
		l_seqs=DbUtil.getSeqVals("attributes_survey_responseid",p_count);
	}catch(Exception e){}
	return l_seqs;
}
public  StatusObj executeBatchQueries(String[] queries, ArrayList<String[]>[] paramsets){
	JSONArray batchqueries=new JSONArray();
	Connection con=null;
	StatusObj stob=new StatusObj(true, "","");		
	PreparedStatement pstmt=null;
	try{
		con=EventbeeConnection.getConnection();
		con.setAutoCommit(false);
		for(int k=0;k<queries.length;k++){
			ArrayList<String[]> params=	paramsets[k];
			JSONArray records=new JSONArray();
			if(params.size()>0){
				pstmt=con.prepareStatement(queries[k]);	
				for(int i=0;i<params.size();i++){
					String[] inputparams=params.get(i);
					pstmt.clearParameters();
					JSONArray record=new JSONArray();
					for(int j=0; j<inputparams.length;j++) {
						pstmt.setString(j+1,inputparams[j]);
						record.put(inputparams[j]);
					}
					records.put(record);
					pstmt.addBatch();		
				}
			}
			JSONObject q=new JSONObject();
			q.put("query", queries[k]);
			q.put("records", records);
			batchqueries.put(q);
			if(params.size()==0) continue;
			try{
				pstmt.executeBatch();
				pstmt.clearBatch();
				pstmt.close();
			}catch(Exception e){ 
				System.out.println("Exception while proseesing batch"+e.getMessage());
				((JSONObject)batchqueries.get(k)).put("emsg",e.getMessage());
				con.rollback();
				stob.setStatus(false);	
				break;
			}
		}
		if(stob.getStatus()) con.commit();
		stob.setData(batchqueries);
	}catch(Exception e){
		System.out.println("Exception occured at executeUpdateQueries():" +e.getMessage());
		if(con!=null) try{con.rollback();}catch(Exception ex){}
		stob.setStatus(false);
	}
	finally{
		try{
			if(con!=null){con.close();con=null;pstmt=null;}				
		}catch(Exception e){System.out.println("Exception while processing llast level "+e.getMessage());}
	}
	return stob;
}
%>
<%
String data=request.getParameter("data");
String eid=request.getParameter("eid");
String status="initializing data";
try{
	JSONObject obj=new JSONObject(data);
	status="getting tid";
	String tid=(String)obj.get("tid");
	status="getting attrib_setid";
	String attrib_setid=(String)obj.get("attrib_setid");
	String U_BBP_query="update buyer_base_info set fname=?, lname=?, email=?, phone=? where transactionid=?";
	String U_TBP_query="update profile_base_info set fname=coalesce(?, fname), lname=coalesce(?, lname), email=coalesce(?, email), phone=coalesce(?, phone) where profilekey=?";
	String D_CQR_query="delete from custom_questions_response where ref_id in (SELECT ref_id from custom_questions_response_master where transactionid=? and profilekey=?)";
	String D_CQRM_query="delete from custom_questions_response_master where transactionid=? and profilekey=?";
	String I_CQRM_query="insert into custom_questions_response_master (attribsetid,profilekey, created, transactionid,ref_id,subgroupid,groupid,profileid ) values(?,?,now(), ?,CAST(? AS BIGINT),CAST(? AS BIGINT),CAST(? AS BIGINT),CAST(? AS BIGINT))";
	String I_CQR_query="insert into custom_questions_response (attribid, ref_id , lastupdated , bigresponse , shortresponse) values(CAST(? AS INTEGER),?, now(), ?,?)";
	ArrayList<String[]> U_BBP_records = new ArrayList<String[]>();
	ArrayList<String[]> U_TBP_records = new ArrayList<String[]>();
	ArrayList<String[]> D_CQR_records = new ArrayList<String[]>();
	ArrayList<String[]> D_CQRM_records = new ArrayList<String[]>();
	ArrayList<String[]> I_CQRM_records = new ArrayList<String[]>();
	ArrayList<String[]> I_CQR_records = new ArrayList<String[]>();
	if(!obj.isNull("buyer")){
		JSONObject buyer=(JSONObject)obj.get("buyer");
		JSONArray br=(JSONArray)buyer.get("responses");
		String pk=(String)buyer.get("k");
		String fname=(String)buyer.get("fname");
		String lname=(String)buyer.get("lname");
		String email=(String)buyer.get("email");
		String pid=(String)buyer.get("profileid");
		String phone= (buyer.isNull("phone"))?"":(String)buyer.get("phone");
		status="updating buyer profile";
		U_BBP_records.add(new String[]{fname, lname, email, phone, tid});
		D_CQR_records.add(new String[]{tid, pk});
		if(br.length()==0){
			D_CQRM_records.add(new String[]{tid, pk});
		}else{
			status="getting ref_id";
			String buyer_profile_ref_id=DbUtil.getVal("SELECT ref_id from custom_questions_response_master where transactionid=? and profilekey=?", new String[]{tid, pk});
			if(buyer_profile_ref_id==null){
				status="getting seq";
				buyer_profile_ref_id=(getSeqs(1))[0];
				I_CQRM_records.add(new String[]{attrib_setid, pk, tid, buyer_profile_ref_id, "0",eid, pid});
			}
			for(int i=0;i<br.length();i++){
				JSONObject res=(JSONObject)br.get(i);
				status="getting qid: "+i;
				String qid=(String)res.get("id");
				qid=qid.replace("q","");
				String bigr=(String)res.get("l");
				String smallr=(String)res.get("v");
				I_CQR_records.add(new String[]{qid, buyer_profile_ref_id, bigr, smallr});
			}
		}
	}
	status="getting tprofiles";
	JSONArray profiles= (JSONArray)obj.get("tprofiles");
	status="getting tprofiles count";
	int count=profiles.length();
	if(count>0){
		status="getting seqs";
		String[] seqs=getSeqs(count);
		for(int j=0;j<profiles.length();j++){
			JSONObject profile = (JSONObject)profiles.get(j);
			status="getting profilekey: "+j;
			String t_pk=(String)profile.get("k");
			String t_pid=(String)profile.get("profileid");
			String t_fname=profile.isNull("fname")?null:(profile.get("fname")).toString();
			String t_lname=profile.isNull("lname")?null:(profile.get("lname")).toString();
			String t_email=profile.isNull("email")?null:(profile.get("email")).toString();
			String t_phone=profile.isNull("phone")?null:(profile.get("phone")).toString();
			U_TBP_records.add(new String[]{t_fname,t_lname,t_email,t_phone,t_pk});
			D_CQR_records.add(new String[]{tid, t_pk});
			D_CQRM_records.add(new String[]{tid, t_pk});
			JSONArray responses=(JSONArray)profile.get("responses");
			if(responses.length()>0){
				I_CQRM_records.add(new String[]{attrib_setid, t_pk, tid, seqs[j],(String)profile.get("tktid") ,eid, t_pid});
			}
			for(int k=0;k<responses.length();k++){
				JSONObject t_res=(JSONObject)responses.get(k);
				status="getting t qid: "+k;
				String qid=(String)t_res.get("id");
				qid=qid.replace("q","");
				String bigr=(String)t_res.get("l");
				String smallr=(String)t_res.get("v");
				I_CQR_records.add(new String[]{qid, ""+seqs[j], bigr, smallr});
			}
		}
	}
	String[] dbqueries = new String[]{U_BBP_query, U_TBP_query, D_CQR_query, D_CQRM_query, I_CQRM_query, I_CQR_query};
	ArrayList<String[]>[] paramset = new ArrayList[]{U_BBP_records, U_TBP_records,D_CQR_records, D_CQRM_records, I_CQRM_records, I_CQR_records};
	status="executing batch: ";
	JSONObject resp=new JSONObject();
	resp.put("status", "success");
	StatusObj sb=executeBatchQueries(dbqueries, paramset);
	
	JSONArray retdata=(JSONArray)sb.getData();
	
	if(sb.getStatus()) {
		
		resp.put("querydata", retdata);
	}else{
		resp.put("status", "fail");
		if(retdata!=null) resp.put("querydata", retdata);
	}
	out.println(resp.toString());
}catch(Exception e){
	out.println("{\"status\":\"fail\", \"process\":\""+status +"\"}");
}
%>

