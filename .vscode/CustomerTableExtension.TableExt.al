tableextension 50001 "Customer Change Webhook" extends Customer
{
    trigger OnAfterModify()
    var
        CustomerWebhookNotifier: Codeunit "Customer Webhook Notifier";
    begin
        if HasRelevantChanges() then
            CustomerWebhookNotifier.SendCustomerChangeWebhook(
                Rec.SystemId,
                Rec."No.",
                xRec."Credit Limit (LCY)",
                Rec."Credit Limit (LCY)",
                xRec."Payment Terms Code",
                Rec."Payment Terms Code",
                xRec.Blocked,
                Rec.Blocked
            );
    end;

    local procedure HasRelevantChanges(): Boolean
    begin
        if xRec."Credit Limit (LCY)" <> Rec."Credit Limit (LCY)" then
            exit(true);
        if xRec."Payment Terms Code" <> Rec."Payment Terms Code" then
            exit(true);
        if xRec.Blocked <> Rec.Blocked then
            exit(true);
        exit(false);
    end;
}
