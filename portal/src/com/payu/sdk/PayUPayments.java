/*
 * Decompiled with CFR 0_110.
 */
package com.payu.sdk;

import com.payu.sdk.PayU;
import com.payu.sdk.constants.Resources;
import com.payu.sdk.exceptions.ConnectionException;
import com.payu.sdk.exceptions.InvalidParametersException;
import com.payu.sdk.exceptions.PayUException;
import com.payu.sdk.exceptions.SDKException;
import com.payu.sdk.helper.HttpClientHelper;
import com.payu.sdk.model.Bank;
import com.payu.sdk.model.PaymentCountry;
import com.payu.sdk.model.PaymentMethodApi;
import com.payu.sdk.model.PaymentMethodComplete;
import com.payu.sdk.model.TransactionResponse;
import com.payu.sdk.model.TransactionType;
import com.payu.sdk.model.response.ResponseCode;
import com.payu.sdk.payments.model.BankListResponse;
import com.payu.sdk.payments.model.PaymentMethodListResponse;
import com.payu.sdk.payments.model.PaymentMethodResponse;
import com.payu.sdk.payments.model.PaymentResponse;
import com.payu.sdk.utils.CommonRequestUtil;
import com.payu.sdk.utils.PaymentMethodMap;
import com.payu.sdk.utils.RequestUtil;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public final class PayUPayments
extends PayU {
    private PayUPayments() {
    }

    public static boolean doPing() throws PayUException, ConnectionException {
        String res = HttpClientHelper.sendRequest(RequestUtil.buildPaymentsPingRequest(), Resources.RequestMethod.POST);
        PaymentResponse response = PaymentResponse.fromXml(res);
        return ResponseCode.SUCCESS.equals((Object)response.getCode());
    }

    public static List<PaymentMethodComplete> getPaymentMethods() throws PayUException, ConnectionException {
        String res = HttpClientHelper.sendRequest(RequestUtil.buildPaymentMethodsListRequest(), Resources.RequestMethod.POST);
        PaymentMethodListResponse response = PaymentMethodListResponse.fromXml(res);
        return response.getPaymentMethods();
    }

    public static PaymentMethodApi getPaymentMethodAvailability(String paymentMethod) throws PayUException, ConnectionException {
        PaymentMethodApi paymentMethodApi = PaymentMethodMap.getInstance().getPaymentMethod(paymentMethod);
        if (paymentMethodApi == null && (paymentMethodApi = PayUPayments.getPaymentMethodAvailabilityFromAPI(paymentMethod)) != null) {
            PaymentMethodMap.getInstance().putPaymentMethod(paymentMethodApi);
        }
        return paymentMethodApi;
    }
    
    public static PaymentMethodApi getCustomPaymentMethodAvailability(String paymentMethod, Map<String, String> parameters) throws PayUException, ConnectionException {
        PaymentMethodApi paymentMethodApi = PaymentMethodMap.getInstance().getPaymentMethod(paymentMethod);
        if (paymentMethodApi == null && (paymentMethodApi = PayUPayments.getCustomPaymentMethodAvailabilityFromAPI(paymentMethod,parameters)) != null) {
            PaymentMethodMap.getInstance().putPaymentMethod(paymentMethodApi);
        }
        return paymentMethodApi;
    }

    protected static PaymentMethodApi getPaymentMethodAvailabilityFromAPI(String paymentMethod) throws PayUException, ConnectionException {
        String res = HttpClientHelper.sendRequest(RequestUtil.buildPaymentMethodAvailability(paymentMethod), Resources.RequestMethod.POST);
        PaymentMethodResponse response = PaymentMethodResponse.fromXml(res);
        return response.getPaymentMethod();
    }
    
    public static PaymentMethodApi getCustomPaymentMethodAvailabilityFromAPI(String paymentMethod,Map<String, String> parameters) throws PayUException, ConnectionException {
        String res = HttpClientHelper.sendRequest(RequestUtil.customBuildPaymentMethodAvailability(paymentMethod,parameters), Resources.RequestMethod.POST);
        PaymentMethodResponse response = PaymentMethodResponse.fromXml(res);
        return response.getPaymentMethod();
    }

    public static List<Bank> getPSEBanks(Map<String, String> parameters) throws PayUException, InvalidParametersException, ConnectionException {
        RequestUtil.validateParameters(parameters, "country");
        PaymentCountry paymentCountry = PaymentCountry.valueOf(parameters.get("country"));
        String res = HttpClientHelper.sendRequest(RequestUtil.buildBankListRequest(paymentCountry), Resources.RequestMethod.POST);
        BankListResponse response = BankListResponse.fromXml(res);
        return response.getBanks();
    }

    public static TransactionResponse doAuthorization(Map<String, String> parameters) throws PayUException, InvalidParametersException, ConnectionException {
        return PayUPayments.doPayment(parameters, TransactionType.AUTHORIZATION);
    }

    public static TransactionResponse doCapture(Map<String, String> parameters) throws PayUException, InvalidParametersException, ConnectionException {
        return PayUPayments.processTransaction(parameters, TransactionType.CAPTURE);
    }

    public static TransactionResponse doAuthorizationAndCapture(Map<String, String> parameters) throws PayUException, InvalidParametersException, ConnectionException {
        return PayUPayments.doPayment(parameters, TransactionType.AUTHORIZATION_AND_CAPTURE, 85000);
    }

    public static TransactionResponse doAuthorizationAndCapture(Map<String, String> parameters, Integer socketTimeOut) throws PayUException, InvalidParametersException, ConnectionException {
        return PayUPayments.doPayment(parameters, TransactionType.AUTHORIZATION_AND_CAPTURE, socketTimeOut);
    }

    public static TransactionResponse doVoid(Map<String, String> parameters) throws PayUException, InvalidParametersException, ConnectionException {
        return PayUPayments.processTransaction(parameters, TransactionType.VOID);
    }

    public static TransactionResponse doRefund(Map<String, String> parameters) throws PayUException, InvalidParametersException, ConnectionException {
        return PayUPayments.processTransaction(parameters, TransactionType.REFUND);
    }

    private static TransactionResponse doPayment(Map<String, String> parameters, TransactionType transactionType) throws PayUException, InvalidParametersException, ConnectionException {
        return PayUPayments.doPayment(parameters, transactionType, 85000);
    }

    private static TransactionResponse doPayment(Map<String, String> parameters, TransactionType transactionType, Integer socketTimeOut) throws PayUException, InvalidParametersException, ConnectionException {
    	String[] required = PayUPayments.getRequiredParameters(parameters);
        RequestUtil.validateParameters(parameters, required);
        String res = HttpClientHelper.sendRequest(RequestUtil.buildPaymentRequest(parameters, transactionType), Resources.RequestMethod.POST, socketTimeOut);
        PaymentResponse response = PaymentResponse.fromXml(res);
        return response.getTransactionResponse();
    }

    private static PaymentMethodApi getPaymentMethodParameter(Map<String, String> parameters, String paramName) throws PayUException, InvalidParametersException, ConnectionException {
        PaymentMethodApi paymentMethod = null;
        String parameter = CommonRequestUtil.getParameter(parameters, paramName);
        if (parameter != null) {
            //paymentMethod = PayUPayments.getPaymentMethodAvailability(parameter);
            paymentMethod = PayUPayments.getCustomPaymentMethodAvailability(parameter,parameters);
        }
        return paymentMethod;
    }

    /*
     * Enabled force condition propagation
     * Lifted jumps to return sites
     */
    private static String[] getRequiredParameters(Map<String, String> parameters) throws PayUException, InvalidParametersException, ConnectionException {
        ArrayList<String> requiredParameters = new ArrayList<String>();
        requiredParameters.add("referenceCode");
        requiredParameters.add("description");
        requiredParameters.add("currency");
        requiredParameters.add("value");
        if (parameters.containsKey("tokenId")) {
            requiredParameters.add("installmentsNumber");
            requiredParameters.add("tokenId");
            return requiredParameters.toArray(new String[requiredParameters.size()]);
        }
        RequestUtil.validateParameters(parameters, "paymentMethod");
        PaymentMethodApi paymentMethod = PayUPayments.getPaymentMethodParameter(parameters, "paymentMethod");
        if (paymentMethod == null) throw new PayUException(SDKException.ErrorCode.API_ERROR, "Unsupported payment method");
       
        if ("BOLETO_BANCARIO".equals(paymentMethod.getName())) {
            requiredParameters.add("payerName");
            requiredParameters.add("payerDNI");
            requiredParameters.add("paymentMethod");
            requiredParameters.add("payerStreet");
            requiredParameters.add("payerStreet2");
            requiredParameters.add("payerCity");
            requiredParameters.add("payerState");
            requiredParameters.add("payerPostalCode");
            return requiredParameters.toArray(new String[requiredParameters.size()]);
        }
        
        if (paymentMethod.getType() == null) return requiredParameters.toArray(new String[requiredParameters.size()]);
        switch (paymentMethod.getType()) {
            case CASH: {
                requiredParameters.add("payerName");
                requiredParameters.add("paymentMethod");
                return requiredParameters.toArray(new String[requiredParameters.size()]);
            }
            case REFERENCED: {
                requiredParameters.add("payerName");
                requiredParameters.add("paymentMethod");
                requiredParameters.add("payerDNI");
                return requiredParameters.toArray(new String[requiredParameters.size()]);
            }
            case PSE: {
                requiredParameters.add("payerName");
                requiredParameters.add("paymentMethod");
                requiredParameters.add("payerDocumentType");
                requiredParameters.add("payerDNI");
                requiredParameters.add("payerEmail");
                requiredParameters.add("payerContactPhone");
                requiredParameters.add("pseFinancialInstitutionCode");
                requiredParameters.add("payerPersonType");
                requiredParameters.add("ipAddress");
                requiredParameters.add("cookie");
                requiredParameters.add("userAgent");
                return requiredParameters.toArray(new String[requiredParameters.size()]);
            }
            case CREDIT_CARD: {
                boolean optionalSecurityCode = parameters.containsKey("processWithoutCvv2") && Boolean.TRUE.toString().equalsIgnoreCase(parameters.get("processWithoutCvv2"));
                requiredParameters.add("payerName");
                requiredParameters.add("paymentMethod");
                requiredParameters.add("installmentsNumber");
                requiredParameters.add("creditCardNumber");
                requiredParameters.add("creditCardExpirationDate");
                if (optionalSecurityCode) return requiredParameters.toArray(new String[requiredParameters.size()]);
                requiredParameters.add("creditCardSecurityCode");
                return requiredParameters.toArray(new String[requiredParameters.size()]);
            }
        }
        throw new PayUException(SDKException.ErrorCode.API_ERROR, "Unsupported payment method");
    }

    private static TransactionResponse processTransaction(Map<String, String> parameters, TransactionType transactionType) throws PayUException, InvalidParametersException, ConnectionException {
        String[] required = new String[]{"orderId", "transactionId"};
        RequestUtil.validateParameters(parameters, required);
        String res = HttpClientHelper.sendRequest(RequestUtil.buildPaymentRequest(parameters, transactionType), Resources.RequestMethod.POST);
        PaymentResponse response = PaymentResponse.fromXml(res);
        return response.getTransactionResponse();
    }

}

