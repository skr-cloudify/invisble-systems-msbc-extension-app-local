codeunit 50002 "Sales Line Webhook Notifier"
{
    procedure SendSalesLineChangeWebhook(
        SalesOrderSystemId: Guid;
        SalesLineSystemId: Guid;
        DocumentNo: Code[20];
        LineNo: Integer;
        OldPlannedShipmentDate: Date;
        NewPlannedShipmentDate: Date;
        OldShipmentDate: Date;
        NewShipmentDate: Date
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

        JsonBody := BuildSalesLineChangeJson(
            SalesOrderSystemId,
            SalesLineSystemId,
            DocumentNo,
            LineNo,
            OldPlannedShipmentDate,
            NewPlannedShipmentDate,
            OldShipmentDate,
            NewShipmentDate
        );

        Content.WriteFrom(JsonBody);
        Content.GetHeaders(Headers);
        Headers.Clear();
        Headers.Add('Content-Type', 'application/json');

        if not Client.Post(WebhookUrl, Content, ResponseMessage) then
            Message('Sales Line Webhook Error: Failed to send request to %1', WebhookUrl);
    end;

    local procedure BuildSalesLineChangeJson(
        SalesOrderSystemId: Guid;
        SalesLineSystemId: Guid;
        DocumentNo: Code[20];
        LineNo: Integer;
        OldPlannedShipmentDate: Date;
        NewPlannedShipmentDate: Date;
        OldShipmentDate: Date;
        NewShipmentDate: Date
    ): Text
    var
        CompanyInfo: Record "Company Information";
        JsonText: TextBuilder;
    begin
        CompanyInfo.Get();

        JsonText.Append('{');
        JsonText.Append('"salesOrderId": "' + DelChr(Format(SalesOrderSystemId), '=', '{}') + '",');
        JsonText.Append('"salesLineId": "' + DelChr(Format(SalesLineSystemId), '=', '{}') + '",');
        JsonText.Append('"documentNo": "' + Format(DocumentNo) + '",');
        JsonText.Append('"oldPlannedShipmentDate": "' + Format(OldPlannedShipmentDate, 0, 9) + '",');
        JsonText.Append('"newPlannedShipmentDate": "' + Format(NewPlannedShipmentDate, 0, 9) + '",');
        JsonText.Append('"oldShipmentDate": "' + Format(OldShipmentDate, 0, 9) + '",');
        JsonText.Append('"newShipmentDate": "' + Format(NewShipmentDate, 0, 9) + '"');
        JsonText.Append('}');

        exit(JsonText.ToText());
    end;
}
