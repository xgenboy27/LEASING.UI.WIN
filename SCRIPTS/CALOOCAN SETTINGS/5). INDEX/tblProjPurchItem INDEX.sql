USE [LEASINGDB]
---[tblProjPurchItem]---

CREATE INDEX [IdxtblProjPurchItem_RecId]
    ON [dbo].[tblProjPurchItem] ([RecId]);
CREATE INDEX [IdxtblProjPurchItem_PurchItemID]
    ON [dbo].[tblProjPurchItem] ([PurchItemID]);
CREATE INDEX [IdxtblProjPurchItem_ProjectId]
    ON [dbo].[tblProjPurchItem] ([ProjectId]);
CREATE INDEX [IdxtblProjPurchItem_Descriptions]
    ON [dbo].[tblProjPurchItem] ([Descriptions]);
CREATE INDEX [IdxtblProjPurchItem_DatePurchase]
    ON [dbo].[tblProjPurchItem] ([DatePurchase]);
CREATE INDEX [IdxtblProjPurchItem_UnitAmount]
    ON [dbo].[tblProjPurchItem] ([UnitAmount]);
CREATE INDEX [IdxtblProjPurchItem_Amount]
    ON [dbo].[tblProjPurchItem] ([Amount]);
CREATE INDEX [IdxtblProjPurchItem_EncodedBy]
    ON [dbo].[tblProjPurchItem] ([EncodedBy]);
CREATE INDEX [IdxtblProjPurchItem_EncodedDate]
    ON [dbo].[tblProjPurchItem] ([EncodedDate]);
CREATE INDEX [IdxtblProjPurchItem_LastChangedBy]
    ON [dbo].[tblProjPurchItem] ([LastChangedBy]);
CREATE INDEX [IdxtblProjPurchItem_LastChangedDate]
    ON [dbo].[tblProjPurchItem] ([LastChangedDate]);
CREATE INDEX [IdxtblProjPurchItem_IsActive]
    ON [dbo].[tblProjPurchItem] ([IsActive]);
CREATE INDEX [IdxtblProjPurchItem_TotalAmount]
    ON [dbo].[tblProjPurchItem] ([TotalAmount]);
CREATE INDEX [IdxtblProjPurchItem_UnitNumber]
    ON [dbo].[tblProjPurchItem] ([UnitNumber]);
CREATE INDEX [IdxtblProjPurchItem_UnitID]
    ON [dbo].[tblProjPurchItem] ([UnitID]);