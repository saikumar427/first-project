<%// Author: Venkat Reddy
// Version: 0.1 
// File: authenticateUser.jsp
// created: 12/05/2014	
// modified: 13/05/2014 by venkat reddy%>

<%@page trimDirectiveWhitespaces="true"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.eventbee.general.StatusObj"%>
<%@page import="com.eventbee.general.DbUtil"%>
<%@page import="com.eventbee.general.DBManager"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONException"%>
<%@page import="org.json.JSONObject"%>
<%@ page language="java"
	contentType="application/json; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%
	String userId = request.getParameter("user_id");
	String password = request.getParameter("password");
	String userType = request.getParameter("user_type");

	JSONObject responseJSON = new JSONObject();

	if (userId == null || password == null||userType==null) {
		responseJSON.put("status", "fail");
		responseJSON.put("reason", "required parameters missing");
		out.println(responseJSON.toString(2));
		return;
	}

	userType = (userType == null) ? "manager" : userType;

	JSONArray roles = new JSONArray();
	if ("manager".equals(userType)) {
		 if(DbUtil.getVal("select user_id from authentication where login_name=?",new String[]{userId})==null){
			 responseJSON.put("status", "fail");
				responseJSON.put("reason", "wrong credentials");				
		 }
		 else{
			 responseJSON.put("status", "success");
		 }
		 out.println(responseJSON.toString(2));
		 return;

	} else if ("sub-manager".equals(userType)) {
		String authenticateQuery = "select email from sub_managers where userid=? and password=?";

		if (DbUtil.getVal(authenticateQuery, new String[] { userId,password }) == null) {
			responseJSON.put("status", "fail");
			responseJSON.put("reason", "wrong credentials");
			out.println(responseJSON.toString(2));
			return;

		} else {
			responseJSON.put("status", "success");
			String rolesQuery = "select distinct role from sub_manager_roles where userid=?";
			DBManager dbManager = new DBManager();
			StatusObj rolesStatus = dbManager.executeSelectQuery(
					rolesQuery, new String[] { userId });
			if (rolesStatus.getStatus()) {
				ArrayList<String> rolesArray = new ArrayList<String>();
				for (int i = 0; i < rolesStatus.getCount(); i++) {
					rolesArray.add(dbManager.getValue(i, "role", ""));
				}
				responseJSON.put("roles", rolesArray);
			} else {
				responseJSON.put("roles", new JSONArray());
			}
			out.println(responseJSON.toString(2));
		
		}

	}
%>