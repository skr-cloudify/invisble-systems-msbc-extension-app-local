codeunit 50003 "Sales Header Webhook Notifier"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnAfterReleaseSalesDoc', '', false, false)]
    local procedure OnAfterReleaseSalesDoc(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean; LinesWereModified: Boolean)
    begin
        if PreviewMode then
            exit;

        if not (SalesHeader."Document Type" in [SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice]) then
            exit;

        SendSalesHeaderStatusWebhook(
            SalesHeader.SystemId,
            SalesHeader."No.",
            SalesHeader."Document Type",
            SalesHeader.Status::Open,
            SalesHeader.Status::Released
        );
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnAfterReopenSalesDoc', '', false, false)]
    local procedure OnAfterReopenSalesDoc(var SalesHeader: Record "Sales Header")
    begin
        if not (SalesHeader."Document Type" in [SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice]) then
            exit;

        SendSalesHeaderStatusWebhook(
            SalesHeader.SystemId,
            SalesHeader."No.",
            SalesHeader."Document Type",
            SalesHeader.Status::Released,
            SalesHeader.Status::Open
        );
    end;

    procedure SendSalesHeaderStatusWebhook(
        SalesHeaderSystemId: Guid;
        DocumentNo: Code[20];
        DocumentType: Enum "Sales Document Type";
        OldStatus: Enum "Sales Document Status";
        NewStatus: Enum "Sales Document Status"
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

        JsonBody := BuildSalesHeaderStatusJson(
            SalesHeaderSystemId,
            DocumentNo,
            DocumentType,
            OldStatus,
            NewStatus
        );

        Content.WriteFrom(JsonBody);
        Content.GetHeaders(Headers);
        Headers.Clear();
        Headers.Add('Content-Type', 'application/json');

        if not Client.Post(WebhookUrl, Content, ResponseMessage) then
            Message('Sales Header Webhook Error: Failed to send request to %1', WebhookUrl);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure OnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean; InvtPickPutaway: Boolean; var CustLedgerEntry: Record "Cust. Ledger Entry")
    var
        PostedDocNo: Code[20];
    begin
        if not (SalesHeader."Document Type" in [SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice]) then
            exit;

        if SalesInvHdrNo <> '' then
            PostedDocNo := SalesInvHdrNo
        else
            PostedDocNo := SalesShptHdrNo;

        SendSalesHeaderPostWebhook(
            SalesHeader.SystemId,
            SalesHeader."No.",
            SalesHeader."Document Type",
            Format(SalesHeader.Status),
            PostedDocNo
        );
    end;

    local procedure SendSalesHeaderPostWebhook(
        SalesHeaderSystemId: Guid;
        DocumentNo: Code[20];
        DocumentType: Enum "Sales Document Type";
        OldStatus: Text;
        PostedDocumentNo: Code[20]
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

        JsonBody := BuildSalesHeaderPostJson(
            SalesHeaderSystemId,
            DocumentNo,
            DocumentType,
            OldStatus,
            PostedDocumentNo
        );

        Content.WriteFrom(JsonBody);
        Content.GetHeaders(Headers);
        Headers.Clear();
        Headers.Add('Content-Type', 'application/json');

        if not Client.Post(WebhookUrl, Content, ResponseMessage) then
            Message('Sales Header Post Webhook Error: Failed to send request to %1', WebhookUrl);
    end;

    local procedure BuildSalesHeaderStatusJson(
        SalesHeaderSystemId: Guid;
        DocumentNo: Code[20];
        DocumentType: Enum "Sales Document Type";
        OldStatus: Enum "Sales Document Status";
        NewStatus: Enum "Sales Document Status"
    ): Text
    var
        CompanyInfo: Record "Company Information";
        JsonText: TextBuilder;
    begin
        CompanyInfo.Get();

        JsonText.Append('{');
        JsonText.Append('"documentId": "' + DelChr(Format(SalesHeaderSystemId), '=', '{}') + '",');
        JsonText.Append('"documentNo": "' + Format(DocumentNo) + '",');
        JsonText.Append('"documentType": "' + Format(DocumentType) + '",');
        JsonText.Append('"oldStatus": "' + Format(OldStatus) + '",');
        JsonText.Append('"newStatus": "' + Format(NewStatus) + '"');
        JsonText.Append('}');

        exit(JsonText.ToText());
    end;

    local procedure BuildSalesHeaderPostJson(
        SalesHeaderSystemId: Guid;
        DocumentNo: Code[20];
        DocumentType: Enum "Sales Document Type";
        OldStatus: Text;
        PostedDocumentNo: Code[20]
    ): Text
    var
        CompanyInfo: Record "Company Information";
        JsonText: TextBuilder;
    begin
        CompanyInfo.Get();

        JsonText.Append('{');
        JsonText.Append('"systemId": "' + DelChr(Format(SalesHeaderSystemId), '=', '{}') + '",');
        JsonText.Append('"documentNo": "' + Format(DocumentNo) + '",');
        JsonText.Append('"documentType": "' + Format(DocumentType) + '",');
        JsonText.Append('"companyId": "' + DelChr(Format(CompanyInfo.SystemId), '=', '{}') + '",');
        JsonText.Append('"oldStatus": "' + OldStatus + '",');
        JsonText.Append('"newStatus": "Posted",');
        JsonText.Append('"postedDocumentNo": "' + Format(PostedDocumentNo) + '"');
        JsonText.Append('}');

        exit(JsonText.ToText());
    end;
}
