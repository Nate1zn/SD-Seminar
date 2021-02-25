pageextension 50101 "CSD ResourceListExt" extends "Resource List"
// CSD1.00 - 2018-01-01 - D. E. Veloper 
// Chapter 5 - Lab 1-3 
// Changed property on the Type field 
// Added new fields: 
// - Internal/External 
// - Maximum Participants 
// Added code to OnOpenPage trigger 
{
    layout
    {
        modify(Type)
        {
            Visible = ShowType;
        }
        addafter(Type)
        {
            field("CSD Resource Type"; rec."CSD Resource Type")
            {
                ApplicationArea = All;
            }
            field("CSD Maximum Participants"; rec."CSD Maximum Participants")
            {
                Visible = ShowMaxField;
                ApplicationArea = All;
            }
        }
    }
    trigger OnOpenPage();
    begin
        ShowType := (rec.GetFilter(Type) = '');
        ShowMaxField := (rec.GetFilter(Type) = format(rec.Type::machine));
    end;

    var
        [InDataSet]
        ShowType: Boolean;

        [InDataSet]
        ShowMaxField: Boolean;
}
