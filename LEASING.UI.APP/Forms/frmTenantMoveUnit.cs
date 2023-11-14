﻿using LEASING.UI.APP.Context;
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
    public partial class frmTenantMoveUnit : Form
    {
        PaymentContext PaymentContext = new PaymentContext();
        public frmTenantMoveUnit()
        {
            InitializeComponent();
        }
        private void M_GetForMoveInUnitList()
        {
            dgvList.DataSource = null;
            using (DataSet dt = PaymentContext.GetForMoveInUnitList())
            {
                if (dt != null && dt.Tables.Count > 0 && dt.Tables[0].Rows.Count > 0)
                {
                    dgvList.DataSource = dt.Tables[0];
                }
            }
        }

        private void frmTenantMoveUnit_Load(object sender, EventArgs e)
        {
            M_GetForMoveInUnitList();
        }

        private void btnRefresh_Click(object sender, EventArgs e)
        {
            M_GetForMoveInUnitList();
        }
    }
}