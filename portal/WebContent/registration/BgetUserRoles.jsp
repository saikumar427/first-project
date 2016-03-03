<%// Author: Venkat Reddy
// Version: 0.1 
// File: getUserRoles.jsp
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

	JSONObject responseJSON = new JSONObject();

	if (userId == null) {
		responseJSON.put("status", "fail");
		responseJSON.put("reason", "required parameters missing");
		out.println(responseJSON.toString(2));
		return;
	}
	JSONArray roles = new JSONArray();

	responseJSON.put("status", "success");
	String rolesQuery = "select distinct role from sub_manager_roles where userid=?";
	DBManager dbManager = new DBManager();
	StatusObj rolesStatus = dbManager.executeSelectQuery(rolesQuery,
			new String[] { userId });
	if (rolesStatus.getStatus()) {
		ArrayList<String> rolesArray = new ArrayList<String>();
		for (int i = 0; i < rolesStatus.getCount(); i++) {
			rolesArray.add(dbManager.getValue(i, "role", ""));
		}
		responseJSON.put("roles", rolesArray);
	} else {
		responseJSON.put("roles", new JSONArray());
	}
	out.println(responseJSON.toString(1));
%>