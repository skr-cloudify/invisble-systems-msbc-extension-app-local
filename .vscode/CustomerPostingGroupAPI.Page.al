page 54593 CBECustomerPostingApiPage
{
    APIGroup = 'customerPostingGroup';
    APIPublisher = 'cloudify';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'customerPostingApiPage';
    DelayedInsert = true;
    EntityName = 'customerPostingGroup';
    EntitySetName = 'customerPostingGroupApi';
    PageType = API;
    SourceTable = "Customer Posting Group";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(addFeePerLineAccount; Rec."Add. Fee per Line Account")
                {
                    Caption = 'Add. Fee per Line Account';
                }
                field(additionalFeeAccount; Rec."Additional Fee Account")
                {
                    Caption = 'Additional Fee Account';
                }
                field("code"; Rec."Code")
                {
                    Caption = 'Code';
                }
                field(creditCurrApplnRndgAcc; Rec."Credit Curr. Appln. Rndg. Acc.")
                {
                    Caption = 'Credit Curr. Appln. Rndg. Acc.';
                }
                field(creditRoundingAccount; Rec."Credit Rounding Account")
                {
                    Caption = 'Credit Rounding Account';
                }
                field(debitCurrApplnRndgAcc; Rec."Debit Curr. Appln. Rndg. Acc.")
                {
                    Caption = 'Debit Curr. Appln. Rndg. Acc.';
                }
                field(debitRoundingAccount; Rec."Debit Rounding Account")
                {
                    Caption = 'Debit Rounding Account';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(interestAccount; Rec."Interest Account")
                {
                    Caption = 'Interest Account';
                }
                field(invoiceRoundingAccount; Rec."Invoice Rounding Account")
                {
                    Caption = 'Invoice Rounding Account';
                }
                field(paymentDiscCreditAcc; Rec."Payment Disc. Credit Acc.")
                {
                    Caption = 'Payment Disc. Credit Acc.';
                }
                field(paymentDiscDebitAcc; Rec."Payment Disc. Debit Acc.")
                {
                    Caption = 'Payment Disc. Debit Acc.';
                }
                field(paymentToleranceCreditAcc; Rec."Payment Tolerance Credit Acc.")
                {
                    Caption = 'Payment Tolerance Credit Acc.';
                }
                field(paymentToleranceDebitAcc; Rec."Payment Tolerance Debit Acc.")
                {
                    Caption = 'Payment Tolerance Debit Acc.';
                }
                field(receivablesAccount; Rec."Receivables Account")
                {
                    Caption = 'Receivables Account';
                }
                field(serviceChargeAcc; Rec."Service Charge Acc.")
                {
                    Caption = 'Service Charge Acc.';
                }
                field(systemCreatedAt; Rec.SystemCreatedAt)
                {
                    Caption = 'SystemCreatedAt';
                }
                field(systemCreatedBy; Rec.SystemCreatedBy)
                {
                    Caption = 'SystemCreatedBy';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field(systemModifiedAt; Rec.SystemModifiedAt)
                {
                    Caption = 'SystemModifiedAt';
                }
                field(systemModifiedBy; Rec.SystemModifiedBy)
                {
                    Caption = 'SystemModifiedBy';
                }
                field(viewAllAccountsOnLookup; Rec."View All Accounts on Lookup")
                {
                    Caption = 'View All Accounts on Lookup';
                }
            }
        }
    }
}