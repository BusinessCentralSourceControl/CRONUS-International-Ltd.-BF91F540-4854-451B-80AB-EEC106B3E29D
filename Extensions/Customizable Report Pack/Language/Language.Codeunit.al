codeunit 6189180 "ForNAV Language Mgt."
{
    SingleInstance = true;

    local procedure GetLocalOrParentTranslation(LanguageID: Integer; keyPostFix: Text): Text;
    var
        Language: Codeunit Language;
        ParentLanguageID: Integer;
    begin
        if (LanguageID <> 0) and (TranslationDictionary.Count > 0) then begin
            if TranslationDictionary.ContainsKey(Format(LanguageID) + keyPostFix) then
                exit(TranslationDictionary.Get(Format(LanguageID) + keyPostFix));

            ParentLanguageID := Language.GetParentLanguageId(LanguageID);
            case ParentLanguageID of
                6:
                    ParentLanguageID := 1030; // DAN
                10:
                    ParentLanguageID := 1034; // ESP
                7:
                    ParentLanguageID := 1031; // DEU
                22:
                    ParentLanguageID := 2070; // PTG
                9:
                    ParentLanguageID := 1033; // ENU
                11:
                    ParentLanguageID := 1035; // FRA
                19:
                    ParentLanguageID := 1043; // NLD
                else
                    ParentLanguageID := LanguageID;
            end;
            if ParentLanguageID <> LanguageID then begin
                if TranslationDictionary.ContainsKey(Format(ParentLanguageID) + keyPostFix) then
                    exit(TranslationDictionary.Get(Format(ParentLanguageID) + keyPostFix));
            end;
        end;
        exit('');
    end;

    procedure HasTranslations(): Boolean
    begin
        if not Initialized then
            CreateTranslationDictionary;
        exit(TranslationDictionary.Count <> 0);
    end;

    procedure GetTranslation(LanguageID: Integer; Value: Text): Text
    var
        Tab: Char;
    begin
        Tab := 9;
        if not Initialized then
            CreateTranslationDictionary;
        exit(GetLocalOrParentTranslation(LanguageID, '' + Tab + '0' + Tab + '0' + Tab + '0' + Tab + Value));
    end;

    procedure GetTranslation(LanguageID: Integer; TableNo: Integer; FieldNo: Integer): Text
    var
        Tab: Char;
    begin
        Tab := 9;
        if not Initialized then
            CreateTranslationDictionary;

        exit(GetLocalOrParentTranslation(LanguageID, '' + Tab + '0' + Tab + Format(TableNo) + Tab + Format(FieldNo) + Tab + ''));
    end;

    procedure GetTranslation(LanguageID: Integer; ReportID: Integer; TableNo: Integer; FieldNo: Integer) Value: Text
    var
        Tab: Char;
        Translation: Text;
    begin
        Tab := 9;
        if not Initialized then
            CreateTranslationDictionary;

        Translation := GetLocalOrParentTranslation(LanguageID, Tab + Format(ReportID) + Tab + Format(TableNo) + Tab + Format(FieldNo) + Tab + '');
        if Translation <> '' then
            exit(Translation);
        exit(GetTranslation(LanguageID, TableNo, FieldNo));
    end;

    local procedure GetTranslationKey(var Translation: Record "ForNAV Language Setup") DictionaryKey: Text
    var
        Value: Text;
        Tab: Char;
    begin
        if Translation."Report ID" + Translation."Table No." + Translation."Field No." = 0 then
            Value := Translation."Translate From";
        Tab := 9;
        DictionaryKey := Format(Translation."Windows Language ID") + Tab +
            Format(Translation."Report ID") + Tab +
            Format(Translation."Table No.") + Tab +
            Format(Translation."Field No.") + Tab +
            Value;

    end;


    procedure ResetTranslations()
    begin
        Initialized := false;
    end;

    procedure GetTranslations(var Value: Dictionary of [Text, Text])
    begin
        if not Initialized then
            CreateTranslationDictionary;
        Value := TranslationDictionary;
    end;

    local procedure CreateTranslationDictionary()
    var
        Translation: Record "ForNAV Language Setup";
        SoftHyphen: Text;
    begin
        Clear(TranslationDictionary);
        SoftHyphen := GetSoftHyphen();
        if Translation.IsEmpty then
            exit;
        Translation.FindSet;
        repeat
            TranslationDictionary.Add(GetTranslationKey(Translation), Translation."Translate To".Replace('~', SoftHyphen));
        until Translation.Next = 0;
        Initialized := true;
    end;

    local procedure GetSoftHyphen() SoftHyphenChar: Text
    begin
        SoftHyphenChar[1] := 173;
    end;

    var
        TranslationDictionary: Dictionary of [Text, Text];
        Initialized: Boolean;

    trigger OnRun()
    begin
        if not Initialized then
            CreateTranslationDictionary();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Global Triggers", 'OnDatabaseInsert', '', false, false)]
    procedure OnDatabaseInsert(RecRef: RecordRef)
    begin
        ResetTranslations();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Global Triggers", 'OnDatabaseModify', '', false, false)]
    procedure OnDatabaseModify(RecRef: RecordRef)
    begin
        ResetTranslations();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Global Triggers", 'OnDatabaseDelete', '', false, false)]
    procedure OnDatabaseDelete(RecRef: RecordRef)
    begin
        ResetTranslations();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Global Triggers", 'OnDatabaseRename', '', false, false)]
    procedure OnDatabaseRename(RecRef: RecordRef)
    begin
        ResetTranslations();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Global Triggers", 'GetDatabaseTableTriggerSetup', '', false, false)]
    procedure GetDatabaseTableTriggerSetup(TableId: Integer; VAR OnDatabaseInsert: Boolean; VAR OnDatabaseModify: Boolean; VAR OnDatabaseDelete: Boolean; VAR OnDatabaseRename: Boolean)
    begin
        if TableId = Database::"ForNAV Language Setup" then begin
            OnDatabaseDelete := true;
            OnDatabaseInsert := true;
            OnDatabaseModify := true;
            OnDatabaseRename := true;
        end;
    end;
}

// Copyright (c) 2017-2021 ForNAV ApS - All Rights Reserved
// The intellectual work and technical concepts contained in this file are proprietary to ForNAV.
// Unauthorized reverse engineering, distribution or copying of this file, parts hereof, or derived work, via any medium is strictly prohibited without written permission from ForNAV ApS.
// This source code is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
