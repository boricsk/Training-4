report 50054 "BK Testreport 4"
{
    Caption = 'BK Testreport 4';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/rdlc/Rep50054.BKTestreport4.rdlc';
    dataset
    {
        dataitem(Item; Item)
        {
            RequestFilterFields = "No.";
            column(No_Item; "No.") { } // a neveknek célszerű egyedi nevet adni, hogy ne keverd őket itt MezőnévTáblanév formátum van
            column(DescriptionItem; Description) { }

            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                /// kapcsolatok megadására figyelni kell, mert ha nincs kapcsolat a két tábla között akkor ez úgy fog működni, hogy lefut az első dataitem majd utánna
                /// a item ledger, de az összessel. A készlet kiszámolásához nem kell az összes legder entry, csak az adott itemhez tartozóak.
                DataItemLink = "Item No." = field("No."); /// ezzel kapcsoltam össze a item ledger item mezőjét a item tábla No mezőjével. Csak az adott cikk
                                                          /// cikktételeit fogja számításba venni.
                RequestFilterFields = "Entry Type";       /// itt is meg lehet a szűrési feltételeket adni a requestpage-hez      
                column(Entry_TypeILE; "Entry Type") { }
                column(DescriptionILE; Description) { }
                column(QuantityILE; Quantity) { }
                column(Location_CodeILE; "Location Code") { }



                trigger OnPreDataItem()
                begin
                    //Triggerek itt is felvehetőek de ez csak az item ledgerhez fog vonatkozni.
                    "Item Ledger Entry".SetRange("Item No.", Item."No."); // így is megadható a kapcsolat a mezők kötzött
                end;
            }

            trigger OnPreDataItem()
            begin
                /// olyan kódok írhatók ide, amely előkészíti a reort adatait a feldolgozáshoz, pl. szűrés beállítása, az adatok itt még nem érhetőek el
                /// ez ful elősször és csak egyszer
                item.SetRange(Type, Item.Type::Inventory); //olyan itemek, melyek készlet típusúak (nem szolgáltatás.)
            end;

            trigger OnAfterGetRecord()
            begin
                /// Ha lekérünk 1 rekordot akkor ezt az itt lévő kóddal lehet feldolgozni. Itt lehet a számolásokat, összehasonlításokat elvégezni.
                /// az adatok elérhetőek
                /// ez indul az onpredataitem után de annyiszor lesz futtatva, ahány rekord jön a db-ből
                /// 
            end;

            trigger OnPostDataItem()
            begin
                /// az adott tábla feldolgozása végén fut le
                /// az adatok már nem elérhetőek
                /// ez fut utoljára és csak egyszer
            end;
        }
    }


    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
}
