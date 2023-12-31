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
    public partial class frmPaymentMode : Form
    {
        PaymentContext PaymentContext = new PaymentContext();
        public bool IsProceed = false;
        public string CompanyORNo { get; set; }
        public string CompanyPRNo { get; set; }
        public string BankAccountName { get; set; }
        public string BankAccountNumber { get; set; }
        public string BankName { get; set; }
        public string SerialNo { get; set; }
        public string PaymentRemarks { get; set; }
        public string REF { get; set; }
        public string ModeType { get; set; }

        public bool IsOR { get; set; } = false;
        public frmPaymentMode()
        {
            InitializeComponent();
        }
        private string _strPaymentmMode;
        public string strPaymentmMode
        {
            get
            {
                return _strPaymentmMode;
            }
            set
            {
                _strPaymentmMode = value;
                switch (_strPaymentmMode)
                {
                    case "CASH":

                        txtCompanyORNo.Enabled = true;
                        txtPRNo.Enabled = true;
                        txtReferrence.Enabled = false;
                        ddlbankName.Enabled = false;
                        txtBankAccountName.Enabled = false;
                        txtBankAccountNo.Enabled = false;
                        txtSerialNo.Enabled = false;
                        ddlbankName.Text = string.Empty;
                        ddlbankName.SelectedIndex = -1;

                        break;
                    case "BANK":
                        txtCompanyORNo.Enabled = true;
                        txtPRNo.Enabled = true;
                        txtReferrence.Enabled = true;
                        ddlbankName.Enabled = true;
                        txtBankAccountName.Enabled = true;
                        txtBankAccountNo.Enabled = true;
                        txtSerialNo.Enabled = false;

                        break;
                    case "PDC":
                        txtCompanyORNo.Enabled = true;
                        txtPRNo.Enabled = true;
                        txtReferrence.Enabled = false;
                        ddlbankName.Enabled = true;
                        txtBankAccountName.Enabled = true;
                        txtBankAccountNo.Enabled = true;
                        txtSerialNo.Enabled = true;

                        break;

                    default:
                        break;
                }
            }
        }

        private void ClearFields()
        {
            txtCompanyORNo.Text = string.Empty;
            txtPRNo.Text = string.Empty;
            txtReferrence.Text = string.Empty;
            ddlbankName.Text = string.Empty;
            ddlbankName.SelectedIndex = 0;
            txtBankAccountName.Text = string.Empty;
            txtBankAccountNo.Text = string.Empty;
            txtSerialNo.Text = string.Empty;
        }
        private void M_GetSelectPaymentMode()
        {

            ddlSelectMode.DataSource = null;
            using (DataSet dt = PaymentContext.GetSelectPaymentMode())
            {
                if (dt != null && dt.Tables.Count > 0 && dt.Tables[0].Rows.Count > 0)
                {
                    ddlSelectMode.DisplayMember = "Mode";
                    ddlSelectMode.ValueMember = "ModeType";
                    ddlSelectMode.DataSource = dt.Tables[0];
                }
            }
        }
        private void M_GetSelectBanknName()
        {

            ddlbankName.DataSource = null;
            using (DataSet dt = PaymentContext.GetSelectBankName())
            {
                if (dt != null && dt.Tables.Count > 0 && dt.Tables[0].Rows.Count > 0)
                {
                    ddlbankName.DisplayMember = "BankName";
                    ddlbankName.ValueMember = "BankName";
                    ddlbankName.DataSource = dt.Tables[0];
                }
            }
        }

        private bool IsValid()
        {
            if (string.IsNullOrEmpty(txtCompanyORNo.Text.Trim()) && IsOR == false)
            {
                MessageBox.Show("Please Provide OR Number or PR Number", "System Message", MessageBoxButtons.OK, MessageBoxIcon.Information);
                return false;
            }
            if (!string.IsNullOrEmpty(txtCompanyORNo.Text.Trim()))
            {
                if (M_CheckOrNumber())
                {
                    MessageBox.Show("This OR Number: " + txtCompanyORNo.Text.Trim() + " is already exist!", "System Message", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    return false;
                }          
            }
            if (!string.IsNullOrEmpty(txtPRNo.Text.Trim()))
            {
                if (M_CheckPRNumber())
                {
                    MessageBox.Show("This PR Number: " + txtPRNo.Text.Trim() + " is already exist!", "System Message", MessageBoxButtons.OK, MessageBoxIcon.Information);
                    return false;
                }
            }

            return true;
        }
        private bool M_CheckOrNumber()
        {
           
            bool IsExist = false;
            using (DataSet dt = PaymentContext.GetCheckOrNumber(txtCompanyORNo.Text.Trim()))
            {
                if (dt != null && dt.Tables.Count > 0 && dt.Tables[0].Rows.Count > 0)
                {

                    IsExist = Convert.ToBoolean(dt.Tables[0].Rows[0]["IsExist"]);
                }
                else
                {
                    IsExist = false;
                }
            }
            return IsExist;
        }
        private bool M_CheckPRNumber()
        {
           
            bool IsExist = false;
            using (DataSet dt = PaymentContext.GetCheckPRNumber(txtPRNo.Text.Trim()))
            {
                if (dt != null && dt.Tables.Count > 0 && dt.Tables[0].Rows.Count > 0)
                {

                    IsExist = Convert.ToBoolean(dt.Tables[0].Rows[0]["IsExist"]);
                }
                else
                {
                    IsExist = false;
                }
            }
            return IsExist;
        }

        private void frmPaymentMode_Load(object sender, EventArgs e)
        {
            ClearFields();
            M_GetSelectPaymentMode();
            M_GetSelectBanknName();
            ddlbankName.Text = string.Empty;
            ddlbankName.SelectedIndex = -1;
        }

        private void ddlSelectMode_SelectedIndexChanged(object sender, Telerik.WinControls.UI.Data.PositionChangedEventArgs e)
        {         
            strPaymentmMode = Convert.ToString(ddlSelectMode.SelectedValue);
        }

        private void btnOk_Click(object sender, EventArgs e)
        {

            if (IsValid())
            {
                IsProceed = true;
                if (ddlSelectMode.SelectedIndex > 0)
                {
                    ModeType = Convert.ToString(ddlSelectMode.SelectedValue);
                }
                CompanyORNo = txtCompanyORNo.Text;
                CompanyPRNo = txtPRNo.Text;
                BankAccountName = txtBankAccountName.Text;
                BankAccountNumber = txtBankAccountNo.Text;
                BankName = ddlbankName.Text;
                SerialNo = txtSerialNo.Text;
                PaymentRemarks = txtRemarks.Text;
                REF = txtReferrence.Text;
                this.Close();
            }
        }

        private void txtPRNo_TextChanged(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(txtPRNo.Text))
            {
                IsOR = true;
            }
            else
            {
                IsOR = false;
            }
        }
    }
}
