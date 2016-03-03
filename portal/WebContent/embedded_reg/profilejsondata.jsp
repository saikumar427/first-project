<%@ page import="java.util.*,com.eventregister.*,com.customquestions.*,com.customquestions.beans.*" %>
<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%

String tid=request.getParameter("tid");
String eid=request.getParameter("eid");
ProfilePageDisplay profile=new ProfilePageDisplay();
String profileObj=profile.getProfilesJson(tid,eid);
out.println(profileObj);
RegistrationTiketingManager regtktmgr=new RegistrationTiketingManager();
regtktmgr.setEventRegTempAction(eid,tid,"profile page");

%>