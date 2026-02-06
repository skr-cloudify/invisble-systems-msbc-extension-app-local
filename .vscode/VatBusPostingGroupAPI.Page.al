page 56721 CBEVatBusinessPosting
{
    APIGroup = 'vatBusinessPostingGroups';
    APIPublisher = 'cloudify';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'vatBusinessPostingApiPage';
    DelayedInsert = true;
    EntityName = 'vatBusinessPostingGroups';
    EntitySetName = 'vatBusinessPostingGroupApi';
    PageType = API;
    SourceTable = "VAT Business Posting Group";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'Id';
                }
                field("code"; Rec."Code")
                {
                    Caption = 'Code';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
            }
        }
    }
}