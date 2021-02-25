table 50101 "CSD Seminar"
// CSD1.00 - 2018-01-01 - D. E. Veloper 
// Chapter 5 - Lab 2-2 
{
    Caption = 'Seminar';
    fields
    {
        field(10; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = AccountData;
            trigger OnValidate();
            begin
                if "No." <> xRec."No." then begin
                    SeminarSetup.GET;
                    NoSeriesMgt.TestManual(SeminarSetup."Seminar Nos.");
                    "No. Series" := '';
                end;
            end;
        }
        field(20; Name; Text[50])
        {
            Caption = 'Name';
            DataClassification = AccountData;
            trigger OnValidate();
            begin
                if ("Search Name" = UpperCase(xRec.Name)) or ("Search Name" = '') then "Search Name" := Name;
            end;

        }
        field(30; "Seminar Duration"; Decimal)
        {
            Caption = 'Seminar Duration';
            DecimalPlaces = 0 : 1;
            DataClassification = AccountData;
        }
        field(40; "Minimum Participants"; Integer)
        {
            Caption = 'Minimum Participants';
            DataClassification = AccountData;
        }
        field(50; "Maximum Participants"; Integer)
        {
            Caption = 'Maximum Participants';
            DataClassification = AccountData;
        }
        field(60; "Search Name"; Code[50])
        {
            Caption = 'Search Name';
            DataClassification = AccountData;
        }
        field(70; Blocked; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = AccountData;
        }
        field(80; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
            DataClassification = AccountData;
        }
        field(90; Comment; Boolean)
        {
            Caption = 'Comment';
            Editable = false;
            //FieldClass=FlowField; 
            //CalcFormula=exist("Seminar Comment Line" 
            //where("Table Name"= const("Seminar"), 
            // "No."=Field("No."))); 
        }
        field(100; "Seminar Price"; Decimal)
        {
            Caption = 'Seminar Price';
            AutoFormatType = 1;
            DataClassification = AccountData;
        }
        field(110; "Gen. Prod. Posting Group"; code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
            DataClassification = AccountData;
            trigger OnValidate();
            begin
                if (xRec."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group") then begin
                    if GenProdPostingGroup.ValidateVatProdPostingGroup(GenProdPostingGroup, "Gen. Prod. Posting Group") then
                        Validate("VAT Prod. Posting Group", GenProdPostingGroup."Def. VAT Prod. Posting Group");
                end;
            end;
        }
        field(120; "VAT Prod. Posting Group"; code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
            DataClassification = AccountData;
        }
        field(130; "No. Series"; Code[10])
        {
            Editable = false;
            Caption = 'No. Series';
            TableRelation = "No. Series";
            DataClassification = AccountData;
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    var
        SeminarSetup: Record "CSD Seminar Setup";
        //CommentLine : record "CSD Seminar Comment Line"; 
        Seminar: Record "CSD Seminar";
        GenProdPostingGroup: Record "Gen. Product Posting Group";
        NoSeriesMgt: Codeunit NoSeriesManagement;

    trigger OnInsert();
    begin
        if "No." = '' then begin
            SeminarSetup.get;
            SeminarSetup.TestField("Seminar Nos.");
            NoSeriesMgt.InitSeries(SeminarSetup."Seminar Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        end;
    end;

    trigger OnModify();
    begin
        "Last Date Modified" := Today;
    end;

    trigger OnRename();
    begin
        "Last Date Modified" := Today;
    end;

    trigger OnDelete();
    begin
        //CommentLine.Reset; 
        //CommentLine.SetRange("Table Name", 
        //CommentLine."Table Name"::Seminar);
        //CommentLine.SetRange("No.","No."); 
        // CommentLine.DeleteAll; 
    end;

    procedure AssistEdit(): Boolean

    begin
        Seminar := Rec;
        SeminarSetup.get;
        SeminarSetup.TestField("Seminar Nos.");
        if NoSeriesMgt.SelectSeries(SeminarSetup."Seminar Nos.", xRec."No. Series", Seminar."No. Series") then begin
            NoSeriesMgt.SetSeries(seminar."No.");
            Rec := Seminar;
            exit(true);
        end;
    end;


}