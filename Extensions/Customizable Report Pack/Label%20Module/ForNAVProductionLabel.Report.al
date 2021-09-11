Report 6188662 "ForNAV Production Label"
{
    Caption = 'Production Label';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Args; "ForNAV Label Args.")
        {
            DataItemTableView = sorting("Report ID");
            UseTemporary = true;
            column(ReportForNavId_2; 2)
            {
            }
        }
        dataitem(Label; "Production Order")
        {
            RequestFilterFields = Status, "No.", "Starting Date-Time";
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                PrintLabel;
            end;

            trigger OnPreDataItem()
            begin
                ShowLabelWarning;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(Orientation; Args.Orientation)
                    {
                        ApplicationArea = All;
                        Caption = 'Orientation';
                    }
                    field(OneLabelPerPackage; Args."One Label per Package")
                    {
                        ApplicationArea = All;
                        Caption = 'One Label per Package';
                    }
                    field(DirectPrint; Args."Direct Print")
                    {
                        ApplicationArea = All;
                        Caption = 'Direct Print';
                    }
                    field(ForNavOpenDesigner; Args."Open Designer")
                    {
                        ApplicationArea = All;
                        Caption = 'Design';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        Codeunit.Run(Codeunit::"ForNAV First Time Setup");
        Commit;
    end;

    local procedure PrintLabel()
    var
        CreateLabel: Codeunit "ForNAV Label Mgt.";
    begin
        case Args.Orientation of
            Args.Orientation::Landscape:
                Args."Report ID" := Report::"ForNAV Label Landscape";
            Args.Orientation::Portrait:
                Args."Report ID" := Report::"ForNAV Label Portrait";
        end;
        Args.CreateLabels(Label);
    end;

    local procedure ShowLabelWarning()
    var
        LabelWarning: Codeunit "ForNAV Label Warning";
    begin
        LabelWarning.ShowLabelWarning(Label.Count);
    end;
}

// Copyright (c) 2017-2019 ForNAV ApS - All Rights Reserved
// The intellectual work and technical concepts contained in this file are proprietary to ForNAV.
// Unauthorized reverse engineering, distribution or copying of this file, parts hereof, or derived work, via any medium is strictly prohibited without written permission from ForNAV ApS.
// This source code is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
