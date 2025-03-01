﻿using LEASING.UI.APP.Common;
using LEASING.UI.APP.Context;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace LEASING.UI.APP.Forms
{
    public partial class ClosedContractBrowse : Form
    {
       private PaymentContext _payment;
        public ClosedContractBrowse()
        {
            _payment = new PaymentContext();
            InitializeComponent();
        }
        private void M_GetClosedContracts()
        {
            try
            {
                dgvList.DataSource = null;
                using (DataSet dt = _payment.GetClosedContracts())
                {
                    if (dt != null && dt.Tables.Count > 0 && dt.Tables[0].Rows.Count > 0)
                    {
                        dgvList.DataSource = dt.Tables[0];
                    }
                }
            }
            catch (Exception ex)
            {
                Functions.LogError("M_GetClosedContracts()", this.Text, ex.ToString(), DateTime.Now, this);
                Functions.ErrorShow("M_GetClosedContracts()", ex.ToString());
            }
        }
        private void frmClosedContracts_Load(object sender, EventArgs e)
        {
            Functions.EventCapturefrmName(this);
            M_GetClosedContracts();
        }
        private void dgvList_CellClick(object sender, Telerik.WinControls.UI.GridViewCellEventArgs e)
        {
            if (e.RowIndex >= 0)
            {
                if (this.dgvList.Columns[e.ColumnIndex].Name == "ColViewFile")
                {
                    ClientContactSignedDocumentsReferenceBrowse forms = new ClientContactSignedDocumentsReferenceBrowse();
                    forms.ClientID = Convert.ToString(dgvList.CurrentRow.Cells["ClientID"].Value);                
                    forms.ReferenceID = Convert.ToString(dgvList.CurrentRow.Cells["RefId"].Value);
                    forms.ShowDialog();                 
                }
                else if (this.dgvList.Columns[e.ColumnIndex].Name == "ColView")
                {
                    ViewContractUnitInfo forms = new ViewContractUnitInfo();
                    forms.Recid = Convert.ToInt32(dgvList.CurrentRow.Cells["RecId"].Value);
                    forms.ShowDialog();
                }
                else if (this.dgvList.Columns[e.ColumnIndex].Name == "ColLedger")
                {
                    ClientCloseContractInfo forms = new ClientCloseContractInfo();
                    forms.ComputationRecid = Convert.ToInt32(dgvList.CurrentRow.Cells["RecId"].Value);
                    forms.ClientId  = Convert.ToString(dgvList.CurrentRow.Cells["ClientID"].Value);
                    forms.ShowDialog();
                }          
            }
        }
    }
}
