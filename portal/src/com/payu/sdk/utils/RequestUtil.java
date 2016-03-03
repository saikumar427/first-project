/*
 * Decompiled with CFR 0_110.
 */
package com.payu.sdk.utils;

import com.payu.sdk.PayU;
import com.payu.sdk.exceptions.InvalidParametersException;
import com.payu.sdk.exceptions.PayUException;
import com.payu.sdk.exceptions.SDKException;
import com.payu.sdk.helper.SignatureHelper;
import com.payu.sdk.model.AdditionalValue;
import com.payu.sdk.model.Address;
import com.payu.sdk.model.BankListInformation;
import com.payu.sdk.model.Buyer;
import com.payu.sdk.model.CreditCard;
import com.payu.sdk.model.CreditCardToken;
import com.payu.sdk.model.CreditCardTokenInformation;
import com.payu.sdk.model.Currency;
import com.payu.sdk.model.DocumentType;
import com.payu.sdk.model.ExtraParemeterNames;
import com.payu.sdk.model.Language;
import com.payu.sdk.model.Merchant;
import com.payu.sdk.model.Order;
import com.payu.sdk.model.Payer;
import com.payu.sdk.model.PaymentCountry;
import com.payu.sdk.model.PaymentMethod;
import com.payu.sdk.model.Person;
import com.payu.sdk.model.PersonType;
import com.payu.sdk.model.RemoveCreditCardToken;
import com.payu.sdk.model.Transaction;
import com.payu.sdk.model.TransactionSource;
import com.payu.sdk.model.TransactionType;
import com.payu.sdk.model.request.Command;
import com.payu.sdk.model.request.CommandRequest;
import com.payu.sdk.model.request.Request;
import com.payu.sdk.payments.model.CreditCardTokenListRequest;
import com.payu.sdk.payments.model.CreditCardTokenRequest;
import com.payu.sdk.payments.model.PaymentMethodRequest;
import com.payu.sdk.payments.model.PaymentRequest;
import com.payu.sdk.payments.model.RemoveCreditCardTokenRequest;
import com.payu.sdk.reporting.model.ReportingRequest;
import com.payu.sdk.utils.CommonRequestUtil;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;

public final class RequestUtil
extends CommonRequestUtil {
    private static final String ENCODING = "UTF-8".toString();
    private static final String APPENDER = "&";
    private static final String EQUALS = "=";

    private RequestUtil() {
    }

    public static PaymentRequest buildPaymentsPingRequest() {
        PaymentRequest request = RequestUtil.buildDefaultPaymentRequest();
        request.setCommand(Command.PING);
        return request;
    }

    public static ReportingRequest buildReportingPingRequest() {
        ReportingRequest request = RequestUtil.buildDefaultReportingRequest();
        request.setCommand(Command.PING);
        return request;
    }

    public static Request buildBankListRequest(PaymentCountry paymentCountry) {
        PaymentRequest request = RequestUtil.buildDefaultPaymentRequest();
        request.setCommand(Command.GET_BANKS_LIST);
        request.setBankListInformation(new BankListInformation(PaymentMethod.PSE, paymentCountry));
        return request;
    }

    public static Request buildPaymentRequest(Map<String, String> parameters, TransactionType transactionType) throws InvalidParametersException {
    	PaymentRequest request = RequestUtil.buildDefaultPaymentRequest();
        String apiKey = RequestUtil.getParameter(parameters, "apiKey");
        String apiLogin = RequestUtil.getParameter(parameters, "apiLogin");
        String language = RequestUtil.getParameter(parameters, "language");
        request.setLanguage(Enum.valueOf(Language.class, language));
    	request.getMerchant().setApiKey(apiKey);
    	request.getMerchant().setApiLogin(apiLogin);
    	
        request.setCommand(Command.SUBMIT_TRANSACTION);
        request.setTransaction(RequestUtil.buildTransaction(parameters, transactionType));
        return request;
    }

    public static Request buildPaymentMethodsListRequest() {
        PaymentRequest request = RequestUtil.buildDefaultPaymentRequest();
        request.setCommand(Command.GET_PAYMENT_METHODS);
        return request;
    }

    public static Request buildPaymentMethodAvailability(String paymentMethod) {
        PaymentMethodRequest request = new PaymentMethodRequest();
        request = (PaymentMethodRequest)RequestUtil.buildDefaultRequest(request);
        request.setTest(PayU.isTest);
        request.setCommand(Command.GET_PAYMENT_METHOD_AVAILABILITY);
        request.setPaymentMethod(paymentMethod);
        return request;
    }
    
    public static Request customBuildPaymentMethodAvailability(String paymentMethod,Map<String, String> parameters) {
        PaymentMethodRequest request = new PaymentMethodRequest();
        request = (PaymentMethodRequest)RequestUtil.buildDefaultRequest(request);
        String apiKey = RequestUtil.getParameter(parameters, "apiKey");
        String apiLogin = RequestUtil.getParameter(parameters, "apiLogin");
        String language = RequestUtil.getParameter(parameters, "language");
        request.setLanguage(Enum.valueOf(Language.class, language));
    	request.getMerchant().setApiKey(apiKey);
    	request.getMerchant().setApiLogin(apiLogin);
        
        request.setTest(PayU.isTest);
        request.setCommand(Command.GET_PAYMENT_METHOD_AVAILABILITY);
        request.setPaymentMethod(paymentMethod);
        return request;
    }

    public static ReportingRequest buildOrderReportingDetails(Map<String, String> parameters) throws InvalidParametersException {
        ReportingRequest request = RequestUtil.buildDefaultReportingRequest();
        request.setCommand(Command.ORDER_DETAIL);
        Integer orderId = RequestUtil.getIntegerParameter(parameters, "orderId");
        HashMap<String, Object> details = new HashMap<String, Object>();
        details.put("orderId", orderId);
        request.setDetails(details);
        return request;
    }

    public static ReportingRequest buildOrderReportingByReferenceCode(Map<String, String> parameters) {
        ReportingRequest request = RequestUtil.buildDefaultReportingRequest();
        request.setCommand(Command.ORDER_DETAIL_BY_REFERENCE_CODE);
        request.setDetails(new HashMap<String, Object>(parameters));
        return request;
    }

    public static ReportingRequest buildTransactionResponse(Map<String, String> parameters) {
        ReportingRequest request = RequestUtil.buildDefaultReportingRequest();
        request.setCommand(Command.TRANSACTION_RESPONSE_DETAIL);
        request.setDetails(new HashMap<String, Object>(parameters));
        return request;
    }

    public static Request buildCreateTokenRequest(Map<String, String> parameters) throws InvalidParametersException {
        String nameOnCard = RequestUtil.getParameter(parameters, "payerName");
        String payerId = RequestUtil.getParameter(parameters, "payerId");
        String dni = RequestUtil.getParameter(parameters, "payerDNI");
        String creditCardNumber = RequestUtil.getParameter(parameters, "creditCardNumber");
        String expirationDate = RequestUtil.getParameter(parameters, "creditCardExpirationDate");
        PaymentMethod paymentMethod = (PaymentMethod)((Object)RequestUtil.getEnumValueParameter(PaymentMethod.class, parameters, "paymentMethod"));
        CreditCardTokenRequest request = new CreditCardTokenRequest();
        request = (CreditCardTokenRequest)RequestUtil.buildDefaultRequest(request);
        request.setCommand(Command.CREATE_TOKEN);
        request.setCreditCardToken(RequestUtil.buildCreditCardToken(nameOnCard, payerId, dni, paymentMethod, creditCardNumber, expirationDate));
        return request;
    }

    public static Request buildGetCreditCardTokensRequest(Map<String, String> parameters) throws InvalidParametersException {
        String payerId = RequestUtil.getParameter(parameters, "payerId");
        String tokenId = RequestUtil.getParameter(parameters, "tokenId");
        String strStartDate = RequestUtil.getParameter(parameters, "startDate");
        String strEndDate = RequestUtil.getParameter(parameters, "endDate");
        RequestUtil.validateDateParameter(strStartDate, "startDate", "yyyy-MM-dd'T'HH:mm:ss");
        RequestUtil.validateDateParameter(strEndDate, "endDate", "yyyy-MM-dd'T'HH:mm:ss");
        CreditCardTokenListRequest request = new CreditCardTokenListRequest();
        request = (CreditCardTokenListRequest)RequestUtil.buildDefaultRequest(request);
        request.setCommand(Command.GET_TOKENS);
        CreditCardTokenInformation information = new CreditCardTokenInformation();
        information.setPayerId(payerId);
        information.setTokenId(tokenId);
        information.setStartDate(strStartDate);
        information.setEndDate(strEndDate);
        request.setCreditCardTokenInformation(information);
        return request;
    }

    public static Request buildRemoveTokenRequest(Map<String, String> parameters) {
        String payerId = RequestUtil.getParameter(parameters, "payerId");
        String tokenId = RequestUtil.getParameter(parameters, "tokenId");
        RemoveCreditCardTokenRequest request = new RemoveCreditCardTokenRequest();
        request = (RemoveCreditCardTokenRequest)RequestUtil.buildDefaultRequest(request);
        request.setCommand(Command.REMOVE_TOKEN);
        RemoveCreditCardToken remove = new RemoveCreditCardToken();
        remove.setPayerId(payerId);
        remove.setCreditCardTokenId(tokenId);
        request.setRemoveCreditCardToken(remove);
        return request;
    }

    private static Request buildDefaultRequest(CommandRequest request) {
        request.setMerchant(RequestUtil.buildMerchant());
        request.setLanguage(PayU.language);
        return request;
    }

    private static PaymentRequest buildDefaultPaymentRequest() {
        PaymentRequest request = new PaymentRequest();
        request = (PaymentRequest)RequestUtil.buildDefaultRequest(request);
        request.setTest(PayU.isTest);
        return request;
    }

    private static ReportingRequest buildDefaultReportingRequest() {
        ReportingRequest request = new ReportingRequest();
        request = (ReportingRequest)RequestUtil.buildDefaultRequest(request);
        request.setTest(PayU.isTest);
        return request;
    }

    private static CreditCard buildCreditCard(String name, String creditCardNumber, String expirationDate, Boolean processWithoutCvv2, String securityCode) {
        if (creditCardNumber != null || processWithoutCvv2 != null || securityCode != null) {
            CreditCard creditCard = new CreditCard();
            creditCard.setName(name);
            creditCard.setNumber(creditCardNumber);
            creditCard.setExpirationDate(expirationDate);
            creditCard.setProcessWithoutCvv2(processWithoutCvv2);
            creditCard.setSecurityCode(securityCode);
            return creditCard;
        }
        return null;
    }

    private static CreditCardToken buildCreditCardToken(String nameOnCard, String payerId, String payerIdentificationNumber, PaymentMethod paymentMethod, String creditCardNumber, String expirationDate) {
        CreditCardToken creditCardToken = new CreditCardToken();
        creditCardToken.setName(nameOnCard);
        creditCardToken.setPayerId(payerId);
        creditCardToken.setIdentificationNumber(payerIdentificationNumber);
        creditCardToken.setPaymentMethod(paymentMethod);
        creditCardToken.setExpirationDate(expirationDate);
        creditCardToken.setNumber(creditCardNumber);
        return creditCardToken;
    }

    private static void buildCreditCardTransaction(Transaction transaction, String nameOnCard, String creditCardNumber, String expirationDate, Boolean processWithoutCvv2, String securityCode, Integer installments, Boolean createCreditCardToken) throws InvalidParametersException {
        transaction.setCreditCard(RequestUtil.buildCreditCard(nameOnCard, creditCardNumber, expirationDate, processWithoutCvv2, securityCode));
        if (installments != null) {
            transaction.addExtraParameter(ExtraParemeterNames.INSTALLMENTS_NUMBER.name(), installments.toString());
        }
        transaction.setCreateCreditCardToken(createCreditCardToken);
    }

    private static Merchant buildMerchant() {
        Merchant merchant = new Merchant();
        merchant.setApiKey(PayU.apiKey);
        merchant.setApiLogin(PayU.apiLogin);
        return merchant;
    }

    private static Order buildOrder(Integer accountId, Currency txCurrency, BigDecimal txValue, BigDecimal taxValue, BigDecimal taxReturnBase, String description, String referenceCode, String notifyUrl) {
        Order order = new Order();
        order.setAccountId(accountId);
        order.setDescription(description);
        order.setLanguage(PayU.language);
        order.setReferenceCode(referenceCode);
        order.setNotifyUrl(notifyUrl);
        order.setAdditionalValues(RequestUtil.buildAdditionalValues(txCurrency, txValue, taxValue, taxReturnBase));
        return order;
    }
    
    //for merchant language
    private static Order buildOrder(Integer accountId, Currency txCurrency, BigDecimal txValue, BigDecimal taxValue, BigDecimal taxReturnBase, String description, String referenceCode, String notifyUrl, String language) {
        Order order = new Order();
        order.setAccountId(accountId);
        order.setDescription(description);
        order.setLanguage(Enum.valueOf(Language.class, language));
        order.setReferenceCode(referenceCode);
        order.setNotifyUrl(notifyUrl);
        order.setAdditionalValues(RequestUtil.buildAdditionalValues(txCurrency, txValue, taxValue, taxReturnBase));
        return order;
    }

    private static Buyer buildBuyer(Map<String, String> parameters) {
        String buyerId = RequestUtil.getParameter(parameters, "buyerId");
        String buyerEmail = RequestUtil.getParameter(parameters, "buyerEmail");
        String buyerName = RequestUtil.getParameter(parameters, "buyerName");
        String buyerCNPJ = RequestUtil.getParameter(parameters, "buyerCNPJ");
        String buyerContactPhone = RequestUtil.getParameter(parameters, "buyerContactPhone");
        String buyerDniNumber = RequestUtil.getParameter(parameters, "buyerDNI");
        String buyerCity = RequestUtil.getParameter(parameters, "buyerCity");
        String buyerCountry = RequestUtil.getParameter(parameters, "buyerCountry");
        String buyerPhone = RequestUtil.getParameter(parameters, "buyerPhone");
        String buyerPostalCode = RequestUtil.getParameter(parameters, "buyerPostalCode");
        String buyerState = RequestUtil.getParameter(parameters, "buyerState");
        String buyerStreet = RequestUtil.getParameter(parameters, "buyerStreet");
        String buyerStreet2 = RequestUtil.getParameter(parameters, "buyerStreet2");
        String buyerStreet3 = RequestUtil.getParameter(parameters, "buyerStreet3");
        Buyer buyer = new Buyer();
        RequestUtil.buildPerson(buyer, buyerId, buyerEmail, buyerName, buyerCNPJ, buyerContactPhone, buyerDniNumber, buyerCity, buyerCountry, buyerPhone, buyerPostalCode, buyerState, buyerStreet, buyerStreet2, buyerStreet3);
        return buyer;
    }

    private static Payer buildPayer(Map<String, String> parameters) throws InvalidParametersException {
        String payerId = RequestUtil.getParameter(parameters, "payerId");
        String payerEmail = RequestUtil.getParameter(parameters, "payerEmail");
        String payerName = RequestUtil.getParameter(parameters, "payerName");
        String payerCNPJ = RequestUtil.getParameter(parameters, "payerCNPJ");
        String payerContactPhone = RequestUtil.getParameter(parameters, "payerContactPhone");
        String payerDniNumber = RequestUtil.getParameter(parameters, "payerDNI");
        String payerCity = RequestUtil.getParameter(parameters, "payerCity");
        String payerCountry = RequestUtil.getParameter(parameters, "payerCountry");
        String payerPhone = RequestUtil.getParameter(parameters, "payerPhone");
        String payerPostalCode = RequestUtil.getParameter(parameters, "payerPostalCode");
        String payerState = RequestUtil.getParameter(parameters, "payerState");
        String payerStreet = RequestUtil.getParameter(parameters, "payerStreet");
        String payerStreet2 = RequestUtil.getParameter(parameters, "payerStreet2");
        String payerStreet3 = RequestUtil.getParameter(parameters, "payerStreet3");
        String payerBusinessName = RequestUtil.getParameter(parameters, "payerBusinessName");
        PersonType payerType = (PersonType)((Object)RequestUtil.getEnumValueParameter(PersonType.class, parameters, "payerPersonType"));
        String payerBirthdate = RequestUtil.getParameter(parameters, "birthdate");
        if (payerBirthdate != null && !payerBirthdate.isEmpty()) {
            RequestUtil.validateDateParameter(payerBirthdate, "birthdate", "yyyy-MM-dd", false);
        }
        Payer payer = new Payer();
        RequestUtil.buildPerson(payer, payerId, payerEmail, payerName, payerCNPJ, payerContactPhone, payerDniNumber, payerCity, payerCountry, payerPhone, payerPostalCode, payerState, payerStreet, payerStreet2, payerStreet3);
        payer.setBusinessName(payerBusinessName);
        payer.setPayerType(payerType);
        payer.setBirthdate(payerBirthdate);
        return payer;
    }

    private static void buildPerson(Person person, String personId, String email, String name, String CNPJ, String contactPhone, String dniNumber, String city, String country, String phone, String postalCode, String state, String street, String street2, String street3) {
        person.setMerchantPersonId(personId);
        person.setEmailAddress(email);
        person.setFullName(name);
        person.setCNPJ(CNPJ);
        person.setContactPhone(contactPhone);
        person.setDniNumber(dniNumber);
        Address address = new Address();
        address.setCity(city);
        address.setCountry(country);
        address.setPhone(phone);
        address.setPostalCode(postalCode);
        address.setState(state);
        address.setLine1(street);
        address.setLine2(street2);
        address.setLine3(street3);
        person.setAddress(address);
    }

    private static Transaction buildTransaction(Map<String, String> parameters, TransactionType transactionType) throws InvalidParametersException {
        String payerName = RequestUtil.getParameter(parameters, "payerName");
        Integer orderId = RequestUtil.getIntegerParameter(parameters, "orderId");
        Integer accountId = RequestUtil.getIntegerParameter(parameters, "accountId");
        String orderReference = RequestUtil.getParameter(parameters, "referenceCode");
        String orderDescription = RequestUtil.getParameter(parameters, "description");
        String orderNotifyUrl = RequestUtil.getParameter(parameters, "notifyUrl");
        String creditCardNumber = RequestUtil.getParameter(parameters, "creditCardNumber");
        String creditCardExpirationDate = RequestUtil.getParameter(parameters, "creditCardExpirationDate");
        Boolean processWithoutCvv2 = RequestUtil.getBooleanParameter(parameters, "processWithoutCvv2");
        String securityCode = RequestUtil.getParameter(parameters, "creditCardSecurityCode");
        Boolean createCreditCardToken = RequestUtil.getBooleanParameter(parameters, "createCreditCardToken");
        String parentTransactionId = RequestUtil.getParameter(parameters, "transactionId");
        String expirationDate = RequestUtil.getParameter(parameters, "expirationDate");
        String cookie = RequestUtil.getParameter(parameters, "cookie");
        PaymentCountry paymentCountry = (PaymentCountry)((Object)RequestUtil.getEnumValueParameter(PaymentCountry.class, parameters, "country"));
        PaymentMethod paymentMethod = CommonRequestUtil.getPaymentMethodParameter(parameters, "paymentMethod");
        String reason = RequestUtil.getParameter(parameters, "reason");
        Currency txCurrency = (Currency)((Object)RequestUtil.getEnumValueParameter(Currency.class, parameters, "currency"));
        BigDecimal txValue = RequestUtil.getBigDecimalParameter(parameters, "value");
        Integer installments = RequestUtil.getIntegerParameter(parameters, "installmentsNumber");
        BigDecimal taxValue = RequestUtil.getBigDecimalParameter(parameters, "taxValue");
        BigDecimal taxReturnBase = RequestUtil.getBigDecimalParameter(parameters, "taxDevolutionBase");
        String ipAddress = RequestUtil.getParameter(parameters, "ipAddress");
        String userAgent = RequestUtil.getParameter(parameters, "userAgent");
        String deviceSessionId = RequestUtil.getParameter(parameters, "deviceSessionId");
        String responseUrlPage = RequestUtil.getParameter(parameters, "responseUrl");
        String tokenId = RequestUtil.getParameter(parameters, "tokenId");
        Transaction transaction = new Transaction();
        transaction.setType(transactionType);
        String language = RequestUtil.getParameter(parameters, "language");
        if (responseUrlPage != null) {
            RequestUtil.addResponseUrlPage(transaction, responseUrlPage);
        }
        if (TransactionType.AUTHORIZATION_AND_CAPTURE.equals((Object)transactionType) || TransactionType.AUTHORIZATION.equals((Object)transactionType)) {
            transaction.setPaymentCountry(paymentCountry);
            if (orderId == null) {
                String signature = RequestUtil.getParameter(parameters, "signature");
                //String merchantId = PayU.merchantId;
                String merchantId = RequestUtil.getParameter(parameters, "merchantId");
                String apiKey = RequestUtil.getParameter(parameters, "apiKey");
                Order order = RequestUtil.buildOrder(accountId, txCurrency, txValue, taxValue, taxReturnBase, orderDescription, orderReference, orderNotifyUrl,language);
                if (signature == null && merchantId != null) {
                    signature = SignatureHelper.buildSignature(order, Integer.parseInt(merchantId), apiKey, "###.00", "md5");
                }
                order.setSignature(signature);
                transaction.setOrder(order);
            } else {
                Order order = new Order();
                order.setId(orderId);
                transaction.setOrder(order);
            }
            transaction.getOrder().setBuyer(RequestUtil.buildBuyer(parameters));
            transaction.setCookie(cookie);
            transaction.setUserAgent(userAgent);
            transaction.setIpAddress(ipAddress);
            transaction.setDeviceSessionId(deviceSessionId);
            if (PaymentMethod.PSE.equals((Object)paymentMethod)) {
                RequestUtil.addPSEExtraParameters(transaction, parameters);
            }
            transaction.setSource(TransactionSource.PAYU_SDK);
            if (creditCardNumber != null || tokenId != null) {
                RequestUtil.buildCreditCardTransaction(transaction, payerName, creditCardNumber, creditCardExpirationDate, processWithoutCvv2, securityCode, installments, createCreditCardToken);
            }
            if (expirationDate != null) {
                Date expDate = RequestUtil.validateDateParameter(expirationDate, "expirationDate", "yyyy-MM-dd'T'HH:mm:ss");
                transaction.setExpirationDate(expDate);
            }
            transaction.setCreditCardTokenId(tokenId);
            String paramPaymentMethod = RequestUtil.getParameter(parameters, "paymentMethod");
            transaction.setPaymentMethod(paramPaymentMethod);
            transaction.setPayer(RequestUtil.buildPayer(parameters));
        } else if (TransactionType.VOID.equals((Object)transactionType) || TransactionType.REFUND.equals((Object)transactionType) || TransactionType.CAPTURE.equals((Object)transactionType)) {
            transaction.setParentTransactionId(parentTransactionId);
            Order order = new Order();
            order.setId(orderId);
            order.setReferenceCode(orderReference);
            order.setDescription(orderDescription);
            //order.setLanguage(PayU.language);
            order.setLanguage(Enum.valueOf(Language.class, language));
            transaction.setAdditionalValues(RequestUtil.buildAdditionalValues(txCurrency, txValue, taxValue, taxReturnBase));
            transaction.setOrder(order);
            transaction.setReason(reason);
        }
        return transaction;
    }

    private static void addPSEExtraParameters(Transaction transaction, Map<String, String> parameters) throws InvalidParametersException {
        String pseReference1 = RequestUtil.getParameter(parameters, "ipAddress");
        String pseReference2 = ((DocumentType)((Object)RequestUtil.getEnumValueParameter(DocumentType.class, parameters, "payerDocumentType"))).name();
        String pseReference3 = RequestUtil.getParameter(parameters, "payerDNI");
        PersonType pseUserType = (PersonType)((Object)RequestUtil.getEnumValueParameter(PersonType.class, parameters, "payerPersonType"));
        String pseFinancialInstitutionCode = RequestUtil.getParameter(parameters, "pseFinancialInstitutionCode");
        String pseFinancialInstitutionName = RequestUtil.getParameter(parameters, "pseFinancialInstitutionName");
        if (pseFinancialInstitutionCode != null) {
            transaction.addExtraParameter(ExtraParemeterNames.FINANCIAL_INSTITUTION_CODE.name(), pseFinancialInstitutionCode);
        }
        if (pseFinancialInstitutionName != null) {
            transaction.addExtraParameter(ExtraParemeterNames.FINANCIAL_INSTITUTION_NAME.name(), pseFinancialInstitutionName);
        }
        if (pseUserType != null) {
            transaction.addExtraParameter(ExtraParemeterNames.USER_TYPE.name(), pseUserType.getPseCode());
        }
        if (pseReference1 != null) {
            transaction.addExtraParameter(ExtraParemeterNames.PSE_REFERENCE1.name(), pseReference1);
        }
        if (pseReference2 != null) {
            transaction.addExtraParameter(ExtraParemeterNames.PSE_REFERENCE2.name(), pseReference2);
        }
        if (pseReference3 != null) {
            transaction.addExtraParameter(ExtraParemeterNames.PSE_REFERENCE3.name(), pseReference3);
        }
    }

    public static String mapToString(Map<String, String> map) throws PayUException {
        StringBuilder stringBuilder = new StringBuilder();
        if (map != null && !map.isEmpty()) {
            for (Map.Entry<String, String> entry : map.entrySet()) {
                String key = entry.getKey();
                String value = entry.getValue();
                if (value == null) continue;
                if (stringBuilder.length() > 0) {
                    stringBuilder.append("&");
                }
                try {
                    stringBuilder.append(key != null ? URLEncoder.encode(key, ENCODING) : "");
                    stringBuilder.append("=");
                    stringBuilder.append(URLEncoder.encode(value, ENCODING));
                    continue;
                }
                catch (UnsupportedEncodingException e) {
                    throw new PayUException(SDKException.ErrorCode.INVALID_PARAMETERS, "can not encode the url");
                }
            }
        }
        return stringBuilder.toString();
    }

    private static void addResponseUrlPage(Transaction transaction, String responseUrl) throws InvalidParametersException {
        transaction.addExtraParameter(ExtraParemeterNames.RESPONSE_URL.name(), responseUrl);
    }
}

