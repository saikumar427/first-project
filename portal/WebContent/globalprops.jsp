<%@page import="com.eventbee.layout.DBHelper"%>
<%@page import="java.util.HashMap"%>
<%!
   private HashMap<String,String> props=new HashMap<String,String>();

	public String getPropValue(String key,String eid){
		String lang=DBHelper.getLanguageFromDB(eid);
		String prop=props.get(key+"_"+lang);
		prop = prop == null ? (props.get(key+"_en_US") == null ? "" : props.get(key+"_en_US") ) : prop;
		return prop;
	}
%>

<%

/*eventhandler.jsp*/
props.put("evh.footer.lnk_en_US", "Powered by Eventbee - Your online registration and event ticketing solution. For more information, visit ");


/*CreditCardScreen.jsp*/
props.put("ccs.note_en_US", "NOTE: CC processing is done by Eventbee. Eventbee appears on your credit card statement");
props.put("ccs.card.type_en_US", "Card Type");
props.put("ccs.card.nmbr_en_US", "Card Number");
props.put("ccs.cvv.nmbr_en_US", "CVV Code");
props.put("ccs.exp_en_US", "Expiration Month/Year");
props.put("ccs.cc.address_en_US", "Credit Card Billing Address");
props.put("ccs.card.holder_en_US", "Cardholder");
props.put("ccs.fname_en_US", "First Name");
props.put("ccs.lname_en_US", "Last Name");
props.put("ccs.country_en_US", "Country");
props.put("ccs.street_en_US", "Street");
props.put("ccs.apt_en_US", "Apt/Suite");
props.put("ccs.city_en_US", "City");
props.put("ccs.state_en_US", "State/Province");
props.put("ccs.zip_en_US", "Zip/Postal Code");


/*continueoptions.jsp*/
props.put("co.nopayment.first_en_US", "If you have closed payment processing window without completing the payment process, ");
props.put("co.nopayment.second_en_US", "click here to continue the process, ");
props.put("co.payment.first_en_US", "If you have completed payment processing successfully,");
props.put("co.payment.second_en_US", "click here to reach confirmation page");

/*fbpopupshare.jsp*/
props.put("fbpopshre.nts.enable_en_US", "Publish to Facebook. Earn Bee Credits if your <br>friends buy tickets through your published link!");
props.put("fbpopshre.nts.disable_en_US", "Publish to Facebook. Let your friends know that you are attending this event!");

/*done.jsp*/
props.put("done.print_en_US", "Print");
props.put("done.payment.not.received.first_en_US", "We haven't received payment confirmation from credit card processing company. Some times it may take few minutes to get the confirmation.<p>A confirmation email with Transaction ID <b>");
props.put("done.payment.not.received.second_en_US", "</b> will be sent to your mail as soon as we get confirmation.");
props.put("done.payment.not.received.note_en_US", "NOTE: If you do not find confirmation email in your Inbox, please do check your Bulk folder, and update your spam filter settings to allow Eventbee emails.");
props.put("done.back_en_US", "Back to Tickets page");

/*checkavailability.jsp*/
props.put("ca.tkt.not.avail_en_US", "Tickets you have selected are currently not available");
props.put("ca.timeout.first_en_US", "You have exceeded the time limit and your reservation has been released.");
props.put("ca.timeout.second_en_US", "The purpose of this time limit is to ensure that registration is available to as many people as possible.");
props.put("ca.timeout.third_en_US", "We apologize for the inconvenience.");
props.put("ca.back_en_US", "Click Here Go To Tickets Page");		
props.put("ca.seats.not.available_en_US", "Few of the seats you are trying to book are currently on hold or already soldout.");

/*socialshare.jsp*/
props.put("ss.share_en_US", "Share");
props.put("ss.tweet_en_US", "Tweet");
props.put("ss.email_en_US", "Email");

props.put("ss.to_en_US", "To");
props.put("ss.comma.seperate_en_US", "Enter emails with comma separated");
props.put("ss.ur.email_en_US", "Your Email");
props.put("ss.ur.name_en_US", "Your Name");
props.put("ss.sub_en_US", "Subject");
props.put("ss.msg_en_US", "Message");
props.put("ss.enter.crct_en_US", "Enter Correct Code");
props.put("ss.enter.below_en_US", "Enter the code as shown below");
props.put("ss.refer.lnk_en_US", "Your referral link");
props.put("ss.send_en_US", "Send");
props.put("ss.cancel_en_US", "Cancel");
props.put("ss.share.purchase_en_US", "Share your purchase");

/*rsvp confirmation*/
props.put("rsvp.other.info_en_US", "Other Information");
props.put("rsvp.back.evnt_en_US", "Back to Event page");

/*rsvpoptions.jsp*/
props.put("rsvp.sel.date_en_US", "--Select Date--");

/*waitlist.jsp */
props.put("wl.tkt.name_en_US", "Ticket Name");
props.put("wl.qty_en_US", "Quantity");
props.put("wl.name_en_US", "Name");
props.put("wl.email_en_US", "Email");
props.put("wl.phone_en_US", "Phone");
props.put("wl.msg.mgr_en_US", "Message to manager");
props.put("wl.submit_en_US", "Submit");
props.put("wl.cancel_en_US", "Cancel");
props.put("wl.require_en_US", "Required");

/*paymentsection.jsp */
props.put("ps.proc.fee.msg_en_US","Processing Fee is not applicable to this payment method");

/*emailsend.jsp*/
props.put("email.sent.to.msg_en_US","Email sent to");
props.put("email.sent.to.msg2_en_US","recepient(s)");
props.put("email.invi.limit.msg_en_US","Please limit to 10 email invitations");
props.put("no.email.sent.to.msg_en_US","No Email sent to  recepient(s)");

props.put("buy.btn.lbl_en_US","Buy Tickets");
props.put("reg.btn.lbl_en_US","Register");

//priority registration
props.put("pri.reg.invalid.errmsg_en_US","Invalid code or passcode");
props.put("pri.reg.limit.reg.single.errmsg_en_US","This code is already used");
props.put("pri.reg.limit.reg.mul.errmsg_en_US","This code reached maximum usage");
props.put("pri.reg.limit.reg.errmsg_en_US","Limited registrations are over");

/*BuyerPage login */
props.put("byer.lgt.fb.lgin.reged.fb.acct_en_US","Sorry! Your Facebook login doesn't match with the Facebook login used to register for this event.");
props.put("byer.there.problm.try.latr_en_US","There is a problem. Please try back later");
props.put("byer.ur.pg.crntly.unavble_en_US","Your page is currently unavailable");
props.put("byer.aces.tkn.sent.success_en_US","Access Token sent successfully");
props.put("byer.fb.lgn.nt.mtch.wth.reg_en_US","Sorry! Your Facebook login doesn't match with the Facebook login used to register for this event.");
props.put("byer.invld.access.tken_en_US","Invalid Access Token");
props.put("byer.to.vst.byr.page_en_US","To visit buyer page");
props.put("byer.eml.byr.access.tkn_en_US","Email me buyer page Access Token");
props.put("byer.lgn.wth.fb_en_US","Login with my Facebook");
props.put("byer.access.tkn.snt.mail_en_US","Access Token is sent to email");
props.put("byer.access.tkn_en_US","Access Token");
props.put("byer.u.hv.regd.wth.fb.acc_en_US","You have registered for this event with your Facebook login.");
props.put("byer.access.tkn.expired_en_US","Access Token is expired");
props.put("byer.resend.btn_en_US","Resend");
props.put("byer.continue.btn_en_US","Continue");
props.put("byer.or.lbl_en_US","OR");

/*eventhandler.jsp*/
props.put("evh.footer.lnk_es_CO", "Desarrollado por Eventbee - Tu plataforma online para el registro y venta de tiquetes de eventos. Para más información, visita");

/*CreditCardScreen.jsp*/

props.put("ccs.note_es_CO", "NOTA: El proceso de tarjeta de crédito se realizó a través de Eventbee. Eventbee aparecerá en el extracto bancario de su tarjeta de crédito");
props.put("ccs.card.type_es_CO", "Tipo de Tarjeta");
props.put("ccs.card.nmbr_es_CO", "Número de Tarjeta");
props.put("ccs.cvv_es_CO", "Código de Seguridad");
props.put("ccs.exp_es_CO", "Fecha de Expiración Mes/Año");
props.put("ccs.cc.address_es_CO", "Dirección Tarjeta de Crédito");
props.put("ccs.card.holder_es_CO", "Titular");
props.put("ccs.fname_es_CO", "Nombre");
props.put("ccs.lname_es_CO", "Apellido");
props.put("ccs.country_es_CO", "País");
props.put("ccs.street_es_CO", "Calle");
props.put("ccs.apt_es_CO", "Apt/Suite");
props.put("ccs.city_es_CO", "Ciudad");
props.put("ccs.state_es_CO", "Departamento");
props.put("ccs.zip_es_CO", "Código Postal");


/*continueoptions.jsp*/

props.put("co.nopayment.first_es_CO", "Si has cerrado la ventana del proceso de pago sin completar el proceso, ");
props.put("co.nopayment.second_es_CO", "haz clic aquí para continuar el proceso, ");
props.put("co.payment.first_es_CO", "Si has completado el proceso de pago exitosamente,");
props.put("co.payment.second_es_CO", "haz clic aquí para dirigirte a la página de confirmación");


/*fbpopupshare.jsp*/

props.put("fbpopshre.nts.enable_es_CO", "Publica en Facebook. ¡Gana Bee Credits si tus amigos compran tiquetes por medio del link de tu publicación!");
props.put("fbpopshre.nts.disable_es_CO", "Publica en Facebook. Permite que tus amigos sepan a qué evento estas asistiendo");



/*done.jsp*/

props.put("done.print_es_CO", "Imprimir");
props.put("done.payment.not.received.first_es_CO", "No hemos recibido la confirmación de pago de la compañía encargada del procesamiento de la tarjeta de crédito. Este proceso por lo general toma algunos minutos para efectuarse. <p>Un correo de confirmación con el Número de Transacción</p>");
props.put("done.payment.not.received.second_es_CO", "</b> será enviado a su correo tan pronto como se realice la confirmación");
props.put("done.payment.not.received.note_es_CO", "NOTA: Si no encuentra el correo de confirmación en su bandeja de entrada, por favor revise su carpeta de Correos No Deseados y actualice los ajustes de filtros de Spam para permitir los correo de Eventbee.");
props.put("done.back_es_CO", "Volver a la Página de Tiquetes");


/*checkavailability.jsp*/

props.put("ca.tkt.not.avail_es_CO", "Los tiquetes que ha seleccionado recientemente no se encuentran disponibles");
props.put("ca.timeout.first_es_CO", "Usted ha excedido el tiempo límite y su reserva ha sido liberada");
props.put("ca.timeout.second_es_CO", "El propósito de este tiempo límite es permitir que el registro se encuentre disponible para la mayor cantidad de personas");
props.put("ca.timeout.third_es_CO", "Pedimos disculpas por las molestias ocasionadas");
props.put("ca.back_es_CO", "Haga clic aquí para ir a la Página de Tiquetes");
props.put("ca.seats.not.available_es_CO", "Algunos de estos asientos están siendo reservados o ya fueron vendidos");



/*socialshare.jsp*/

props.put("ss.share_es_CO", "Compartir");
props.put("ss.tweet_es_CO", "Compartir en Twitter");
props.put("ss.email_es_CO", "Enviar por Correo");
props.put("ss.to_es_CO", "To");
props.put("ss.comma.seperate_es_CO", "Ingrese los correos separados por comas");
props.put("ss.ur.email_es_CO", "Su Correo");
props.put("ss.ur.name_es_CO", "Su Nombre");
props.put("ss.sub_es_CO", "Asunto");
props.put("ss.msg_es_CO", "Mensaje");
props.put("ss.enter.crct_es_CO", "Ingrese el Código Correcto");
props.put("ss.enter.below_es_CO", "Ingrese el código mostrado a continuación");
props.put("ss.refer.lnk_es_CO", "Su enlace de referencia");
props.put("ss.send_es_CO", "Enviar");
props.put("ss.cancel_es_CO", "Cancelar");
props.put("ss.share.purchase_es_CO", "Compartir tu compra");


/*rsvp confirmation*/
props.put("rsvp.other.info_es_CO", "Información Adicional");
props.put("rsvp.back.evnt_es_CO", "Regresar a la Página del Evento");

/*rsvpoptions.jsp*/
props.put("rsvp.sel.date_es_CO", "--Seleccionar Fecha--");

/*waitlist.jsp */
props.put("wl.tkt.name_es_CO", "Nombre del Tiquete");
props.put("wl.qty_es_CO", "Cantidad");
props.put("wl.name_es_CO", "Nombre");
props.put("wl.email_es_CO", "Correo");
props.put("wl.phone_es_CO", "Teléfono");
props.put("wl.msg.mgr_es_CO", "Escribir al Administrador");
props.put("wl.submit_es_CO", "Enviar");
props.put("wl.cancel_es_CO", "Cancelar");
props.put("wl.require_es_CO", "Requerido");

/*paymentsection.jsp */
props.put("ps.proc.fee.msg_es_CO","Cuota de procesamiento no es aplicable a este método de pago");

/*emailsend.jsp*/
props.put("email.sent.to.msg_es_CO","Correo electrónico enviado a");
props.put("email.sent.to.msg2_es_CO","recepient(s)");
props.put("email.invi.limit.msg_es_CO","Por favor, limite de 10 invitaciones por correo electrónico");
props.put("no.email.sent.to.msg_es_CO","Sin correo electrónico enviado a recepient(s)");

props.put("buy.btn.lbl_es_CO","Comprar Tiquetes");
props.put("reg.btn.lbl_es_CO","Registro");

//priority registration
props.put("pri.reg.invalid.errmsg_es_CO","Código no válido o código de acceso");
props.put("pri.reg.limit.reg.single.errmsg_es_CO","Este código se utiliza ya");
props.put("pri.reg.limit.reg.mul.errmsg_es_CO","Este código alcanzó el máximo uso");
props.put("pri.reg.limit.reg.errmsg_es_CO","Inscripciones limitadas son más de");
		
/*BuyerPage login */		
props.put("byer.u.hv.regd.wth.fb.acc_es_CO","Te has registrado para este evento con tu cuenta de Facebook");
props.put("byer.access.tkn_es_CO","Señal de acceso");
props.put("byer.access.tkn.snt.mail_es_CO","Señal de Acceso enviada a esta dirección de correo electrónico");
props.put("byer.lgn.wth.fb_es_CO","Iniciar sesión con mi cuenta de Facebook");
props.put("byer.eml.byr.access.tkn_es_CO","Mandarme por correo electrónico la Señal de Acceso de la página del comprador");
props.put("byer.to.vst.byr.page_es_CO","Para visitar la página del comprador");
props.put("byer.invld.access.tken_es_CO","Señal de Acceso Inválida");
props.put("byer.fb.lgn.nt.mtch.wth.reg_es_CO","Lo sentimos! Tu información de inicio de sesión de Facebook no coincide con la información de Facebook proporcionada para el registro de este evento.");
props.put("byer.aces.tkn.sent.success_es_CO","Señal de Acceso enviada exitosamente");
props.put("byer.there.problm.try.latr_es_CO","Hay un problema. Por favor inténtalo de nuevo más tarde");
props.put("byer.lgt.fb.lgin.reged.fb.acct_es_CO","Lo sentimos! Tu información de inicio de sesión de Facebook no coincide con la información de Facebook proporcionada para el registro de este evento.");
props.put("byer.ur.pg.crntly.unavble_es_CO","Tu página no está disponible en estos momentos");
props.put("byer.access.tkn.expired_es_CO","Token de acceso ha caducado");
props.put("byer.resend.btn_es_CO","Reenviar");
props.put("byer.continue.btn_es_CO","Continuar");
props.put("byer.or.lbl_es_CO","O");
%>