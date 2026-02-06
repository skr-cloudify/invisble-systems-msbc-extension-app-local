codeunit 50001 "Customer Webhook Notifier"
{
    procedure SendCustomerChangeWebhook(
        CustomerSystemId: Guid;
        CustomerNo: Code[20];
        OldCreditLimit: Decimal;
        NewCreditLimit: Decimal;
        OldPaymentTermsCode: Code[10];
        NewPaymentTermsCode: Code[10];
        OldBlocked: Enum "Customer Blocked";
        NewBlocked: Enum "Customer Blocked"
    )
    var
        Client: HttpClient;
        Content: HttpContent;
        Headers: HttpHeaders;
        ResponseMessage: HttpResponseMessage;
        JsonBody: Text;
        WebhookUrl: Text;
    begin
        WebhookUrl := 'https://webhook.site/2abe51c1-047a-4cbe-9dcb-7dc00ac7911d';

        JsonBody := BuildCustomerChangeJson(
            CustomerSystemId,
            CustomerNo,
            OldCreditLimit,
            NewCreditLimit,
            OldPaymentTermsCode,
            NewPaymentTermsCode,
            OldBlocked,
            NewBlocked
        );

        Content.WriteFrom(JsonBody);
        Content.GetHeaders(Headers);
        Headers.Clear();
        Headers.Add('Content-Type', 'application/json');

        if not Client.Post(WebhookUrl, Content, ResponseMessage) then
            Message('Customer Webhook Error: Failed to send request to %1', WebhookUrl);
    end;

    local procedure BuildCustomerChangeJson(
        CustomerSystemId: Guid;
        CustomerNo: Code[20];
        OldCreditLimit: Decimal;
        NewCreditLimit: Decimal;
        OldPaymentTermsCode: Code[10];
        NewPaymentTermsCode: Code[10];
        OldBlocked: Enum "Customer Blocked";
        NewBlocked: Enum "Customer Blocked"
    ): Text
    var
        CompanyInfo: Record "Company Information";
        JsonText: TextBuilder;
    begin
        CompanyInfo.Get();

        JsonText.Append('{');
        JsonText.Append('"customerId": "' + DelChr(Format(CustomerSystemId), '=', '{}') + '",');
        JsonText.Append('"customerNo": "' + Format(CustomerNo) + '",');
        JsonText.Append('"companyId": "' + DelChr(Format(CompanyInfo.SystemId), '=', '{}') + '",');
        JsonText.Append('"oldCreditLimit": ' + Format(OldCreditLimit, 0, 9) + ',');
        JsonText.Append('"newCreditLimit": ' + Format(NewCreditLimit, 0, 9) + ',');
        JsonText.Append('"oldPaymentTermsCode": "' + Format(OldPaymentTermsCode) + '",');
        JsonText.Append('"newPaymentTermsCode": "' + Format(NewPaymentTermsCode) + '",');
        JsonText.Append('"oldBlocked": "' + Format(OldBlocked) + '",');
        JsonText.Append('"newBlocked": "' + Format(NewBlocked) + '"');
        JsonText.Append('}');

        exit(JsonText.ToText());
    end;
}
