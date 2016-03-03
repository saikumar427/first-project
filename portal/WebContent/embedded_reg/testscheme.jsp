<%
String scheme=request.getHeader("x-forwarded-proto");
String sc1=request.getScheme();
System.out.println("scheme1::"+scheme);
System.out.println("scheme2::"+sc1);

%>
