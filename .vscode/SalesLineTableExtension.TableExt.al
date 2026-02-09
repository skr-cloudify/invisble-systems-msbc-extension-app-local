tableextension 50002 "Sales Line Change Webhook" extends "Sales Line"
{
    trigger OnAfterModify()
    var
        SalesHeader: Record "Sales Header";
        SalesLineWebhookNotifier: Codeunit "Sales Line Webhook Notifier";
    begin
        if Rec."Document Type" <> Rec."Document Type"::Order then
            exit;

        if HasRelevantChanges() then begin
            SalesHeader.Get(Rec."Document Type", Rec."Document No.");
            SalesLineWebhookNotifier.SendSalesLineChangeWebhook(
                SalesHeader.SystemId,
                Rec.SystemId,
                Rec."Document No.",
                Rec."Line No.",
                xRec."Planned Shipment Date",
                Rec."Planned Shipment Date",
                xRec."Shipment Date",
                Rec."Shipment Date"
            );
        end;
    end;

    local procedure HasRelevantChanges(): Boolean
    begin
        if xRec."Planned Shipment Date" <> Rec."Planned Shipment Date" then
            exit(true);
        if xRec."Shipment Date" <> Rec."Shipment Date" then
            exit(true);
        exit(false);
    end;
}
