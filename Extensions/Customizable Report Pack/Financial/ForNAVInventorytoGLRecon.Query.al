Query 6188711 "ForNAV Inventory to G/L Recon."
{
    DataAccessIntent = ReadOnly;

    elements
    {
        dataitem(Item; Item)
        {
            column(No; "No.")
            {
            }
            filter(Date_Filter; "Date Filter")
            {
            }
            dataitem(Value_Entry; "Value Entry")
            {
                DataItemLink = "Item No." = Item."No.", "Posting Date" = Item."Date Filter", "Location Code" = Item."Location Filter", "Variant Code" = Item."Variant Filter";
                column(Variant_Code; "Variant Code")
                {
                }
                column(Location_Code; "Location Code")
                {
                }
                filter(Item_Ledger_Entry_No; "Item Ledger Entry No.")
                {
                    ColumnFilter = Item_Ledger_Entry_No = filter(<> 0);
                }
                filter(Valued_Quantity; "Valued Quantity")
                {
                    ColumnFilter = Valued_Quantity = filter(< 0);
                }
                column(Sum_Cost_Amount_Expected; "Cost Amount (Expected)")
                {
                    Method = Sum;
                }
                column(Sum_Cost_Amount_Expected_ACY; "Cost Amount (Expected) (ACY)")
                {
                    Method = Sum;
                }
                column(Sum_Expected_Cost_Posted_to_GL; "Expected Cost Posted to G/L")
                {
                    Method = Sum;
                }
                column(Sum_Exp_Cost_Posted_to_GL_ACY; "Exp. Cost Posted to G/L (ACY)")
                {
                    Method = Sum;
                }
                column(Sum_Valued_Quantity; "Valued Quantity")
                {
                    Method = Sum;
                }
                column(Sum_Invoiced_Quantity; "Invoiced Quantity")
                {
                    Method = Sum;
                }
                column(Sum_Cost_Amount_Actual; "Cost Amount (Actual)")
                {
                    Method = Sum;
                }
                column(Sum_Cost_Amount_Actual_ACY; "Cost Amount (Actual) (ACY)")
                {
                    Method = Sum;
                }
                column(Sum_Cost_Posted_to_G_L; "Cost Posted to G/L")
                {
                    Method = Sum;
                }
                column(Sum_Cost_Posted_to_G_L_ACY; "Cost Posted to G/L (ACY)")
                {
                    Method = Sum;
                }
            }
        }
    }
}

// Copyright (c) 2017-2021 ForNAV ApS - All Rights Reserved
// The intellectual work and technical concepts contained in this file are proprietary to ForNAV.
// Unauthorized reverse engineering, distribution or copying of this file, parts hereof, or derived work, via any medium is strictly prohibited without written permission from ForNAV ApS.
// This source code is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
