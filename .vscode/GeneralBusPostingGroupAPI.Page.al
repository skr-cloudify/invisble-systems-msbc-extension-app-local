page 55033 CBEGeneralBusinessPosting
{
    APIGroup = 'generalBusinessPostingGroup';
    APIPublisher = 'cloudify';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'generalBusinessPostingApiPage';
    DelayedInsert = true;
    EntityName = 'generalBusinessPostingGroup';
    EntitySetName = 'generalBusinessPostingGroupApi';
    PageType = API;
    SourceTable = "General Posting Setup";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(genBusPostingGroup; Rec."Gen. Bus. Posting Group")
                {
                    Caption = 'Gen. Bus. Posting Group';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
            }
        }
    }
}