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
using Telerik.WinControls;

namespace LEASING.UI.APP.Forms
{
    public partial class ViewContractQuickInquiry : Form
    {
        ClientContext ClientContext = new ClientContext();
        ComputationContext ComputationContext = new ComputationContext();
        PaymentContext PaymentContext = new PaymentContext();
        UnitContext UnitContext = new UnitContext();
        InquiryContext InquiryContext = new InquiryContext();
        public ViewContractQuickInquiry()
        {
            InitializeComponent();
        }
        int ComputationRecid { get; set; }
        string ClientId { get; set; }
        private void ClearFields()
        {
            pictureBox1.Visible = false;
            lblPaymentFlag.Visible = false;

            pictureBox2.Visible = false;
            lblContractSignedFlag.Visible = false;

            pictureBox3.Visible = false;
            lblMoveInFlag.Visible = false;

            pictureBox4.Visible = false;
            lblMoveOutFlag.Visible = false;

            pictureBox5.Visible = false;
            lblTerminateFlag.Visible = false;

            pictureBox6.Visible = false;
            lblContractClosedflag.Visible = false;


            txtContractDate.Text = string.Empty;
            txtClientName.Text = string.Empty;
            txtStartDate.Text = string.Empty;
            txtFinishDate.Text = string.Empty;
            txtTotalPay.Text = string.Empty;

            lblUnitNo.Text = string.Empty;
            lblProjectName.Text = string.Empty;
            lblType.Text = string.Empty;
            lblFloorType.Text = string.Empty;
            lblBaseRental.Text = string.Empty;

            dgvLedgerList.DataSource = null;
            dgvLedgerList.Rows.Clear();
            txtMonthlyRental.Text = string.Empty;
        }
        private void frmContractInquiry_Load(object sender, EventArgs e)
        {
            Functions.EventCapturefrmName(this);
            //this.WindowState = FormWindowState.Maximized;
            pictureBox1.Image = Properties.Resources.tick_64;

            pictureBox2.Image = Properties.Resources.tick_64;
            pictureBox3.Image = Properties.Resources.tick_64;
            pictureBox4.Image = Properties.Resources.tick_64;
            pictureBox5.Image = Properties.Resources.tick_64;
            pictureBox6.Image = Properties.Resources.tick_64;

            pictureBox1.Visible = false;
            lblPaymentFlag.Visible = false;

            pictureBox2.Visible = false;
            lblContractSignedFlag.Visible = false;

            pictureBox3.Visible = false;
            lblMoveInFlag.Visible = false;

            pictureBox4.Visible = false;
            lblMoveOutFlag.Visible = false;

            pictureBox5.Visible = false;
            lblTerminateFlag.Visible = false;

            pictureBox6.Visible = false;
            lblContractClosedflag.Visible = false;


        }
        private void M_GetContractDetailsInquiry()
        {
            txtContractDate.Text = string.Empty;
            txtClientName.Text = string.Empty;
            txtStartDate.Text = string.Empty;
            txtFinishDate.Text = string.Empty;
            txtTotalPay.Text = string.Empty;

            lblUnitNo.Text = string.Empty;
            lblProjectName.Text = string.Empty;
            lblType.Text = string.Empty;
            lblFloorType.Text = string.Empty;
            lblBaseRental.Text = string.Empty;
            txtMonthlyRental.Text = string.Empty;

            try
            {


                using (DataSet dt = InquiryContext.GetQuickContractDetailsInquiry(txtContractId.Text))
                {
                    if (dt != null && dt.Tables.Count > 0 && dt.Tables[0].Rows.Count > 0)
                    {
                        ComputationRecid = Convert.ToInt32(dt.Tables[0].Rows[0]["RecId"]);
                        ClientId = Convert.ToString(dt.Tables[0].Rows[0]["ClientID"]);
                        txtContractDate.Text = Convert.ToString(dt.Tables[0].Rows[0]["TransactionDate"]);
                        txtClientName.Text = Convert.ToString(dt.Tables[0].Rows[0]["InquiringClient"]);
                        txtStartDate.Text = Convert.ToString(dt.Tables[0].Rows[0]["StatDate"]);
                        txtFinishDate.Text = Convert.ToString(dt.Tables[0].Rows[0]["FinishDate"]);
                        txtMonthlyRental.Text = Convert.ToString(dt.Tables[0].Rows[0]["TotalRent"]);
                        txtTotalPay.Text = Convert.ToString(dt.Tables[0].Rows[0]["TotalPayAMount"]);

                        pictureBox1.Visible = Convert.ToBoolean(dt.Tables[0].Rows[0]["PaymentStatus"]);
                        lblPaymentFlag.Visible = Convert.ToBoolean(dt.Tables[0].Rows[0]["PaymentStatus"]);

                        if (Convert.ToBoolean(dt.Tables[0].Rows[0]["IsDeclineUnit"]) == false)
                        {
                            if (!Convert.ToBoolean(dt.Tables[0].Rows[0]["PaymentStatus"]))
                            {
                                radLabel2.Text = "Contract Pending - Waiting for the Generation of Ledger Transaction.";
                                radLabel2.BackColor = Color.Red;
                                radLabel2.ForeColor = Color.White;
                            }
                            else
                            {
                                radLabel2.Text = "";
                                radLabel2.BackColor = Color.White;
                                radLabel2.ForeColor = Color.Black;
                            }
                        }
                        else
                        {
                            radLabel2.Text = Convert.ToString(dt.Tables[0].Rows[0]["DeclineUnitlabel"]);
                            radLabel2.BackColor = Color.Red;
                            radLabel2.ForeColor = Color.White;

                        }


                        pictureBox2.Visible = Convert.ToBoolean(dt.Tables[0].Rows[0]["ContractSignStatus"]);
                        lblContractSignedFlag.Visible = Convert.ToBoolean(dt.Tables[0].Rows[0]["ContractSignStatus"]);

                        pictureBox3.Visible = Convert.ToBoolean(dt.Tables[0].Rows[0]["MoveinStatus"]);
                        lblMoveInFlag.Visible = Convert.ToBoolean(dt.Tables[0].Rows[0]["MoveinStatus"]);

                        pictureBox4.Visible = Convert.ToBoolean(dt.Tables[0].Rows[0]["MoveOutStatus"]);
                        lblMoveOutFlag.Visible = Convert.ToBoolean(dt.Tables[0].Rows[0]["MoveOutStatus"]);

                        pictureBox5.Visible = Convert.ToBoolean(dt.Tables[0].Rows[0]["TerminationStatus"]);
                        lblTerminateFlag.Visible = Convert.ToBoolean(dt.Tables[0].Rows[0]["TerminationStatus"]);

                        pictureBox6.Visible = Convert.ToBoolean(dt.Tables[0].Rows[0]["ContractStatus"]);
                        lblContractClosedflag.Visible = Convert.ToBoolean(dt.Tables[0].Rows[0]["ContractStatus"]);





                        lblUnitNo.Text = Convert.ToString(dt.Tables[0].Rows[0]["UnitNo"]);
                        lblProjectName.Text = Convert.ToString(dt.Tables[0].Rows[0]["ProjectName"]);
                        //lblType.Text = Convert.ToString(dt.Tables[0].Rows[0]["TotalPayAMount"]);
                        lblFloorType.Text = Convert.ToString(dt.Tables[0].Rows[0]["FloorType"]);
                        lblBaseRental.Text = Convert.ToString(dt.Tables[0].Rows[0]["Rental"]);
                    }
                }
            }
            catch (Exception ex)
            {
                Functions.LogError("M_GetContractDetailsInquiry()", this.Text, ex.ToString(), DateTime.Now, this);
                Functions.ErrorShow("M_GetContractDetailsInquiry()", ex.ToString());
            }
        }
        private void M_GetLedgerList()
        {
            try
            {
                dgvLedgerList.DataSource = null;
                using (DataSet dt = ComputationContext.GetQuickLedgerListInquiry(ComputationRecid, ClientId))
                {
                    if (dt != null && dt.Tables.Count > 0 && dt.Tables[0].Rows.Count > 0)
                    {
                        dgvLedgerList.DataSource = dt.Tables[0];
                    }
                }
            }
            catch (Exception ex)
            {
                Functions.LogError("M_GetLedgerList()", this.Text, ex.ToString(), DateTime.Now, this);
                Functions.ErrorShow("M_GetLedgerList()", ex.ToString());
            }
        }
        private void txtContractId_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.KeyCode == Keys.Enter)
            {
                M_GetContractDetailsInquiry();
                M_GetLedgerList();
            }
        }
        private void dgvLedgerList_CellFormatting(object sender, Telerik.WinControls.UI.CellFormattingEventArgs e)
        {
            if (!string.IsNullOrEmpty(Convert.ToString(this.dgvLedgerList.Rows[e.RowIndex].Cells["PaymentStatus"].Value)))
            {
                if (Convert.ToString(this.dgvLedgerList.Rows[e.RowIndex].Cells["PaymentStatus"].Value) == "PAID")
                {
                    e.CellElement.ForeColor = Color.White;
                    //e.CellElement.Font = new Font("Tahoma", 7f, FontStyle.Bold);
                    e.CellElement.DrawFill = true;
                    e.CellElement.GradientStyle = GradientStyles.Solid;
                    e.CellElement.BackColor = Color.Green;
                }
                else if (Convert.ToString(this.dgvLedgerList.Rows[e.RowIndex].Cells["PaymentStatus"].Value) == "PENDING")
                {
                    e.CellElement.ForeColor = Color.Black;
                    e.CellElement.DrawFill = true;
                    e.CellElement.GradientStyle = GradientStyles.Solid;
                    e.CellElement.BackColor = Color.Yellow;
                }
                else if (Convert.ToString(this.dgvLedgerList.Rows[e.RowIndex].Cells["PaymentStatus"].Value) == "DUE")
                {
                    e.CellElement.ForeColor = Color.White;
                    e.CellElement.DrawFill = true;
                    e.CellElement.GradientStyle = GradientStyles.Solid;
                    e.CellElement.BackColor = Color.OrangeRed;
                }
                else if (Convert.ToString(this.dgvLedgerList.Rows[e.RowIndex].Cells["PaymentStatus"].Value) == "HOLD")
                {
                    e.CellElement.ForeColor = Color.White;
                    e.CellElement.DrawFill = true;
                    e.CellElement.GradientStyle = GradientStyles.Solid;
                    e.CellElement.BackColor = Color.Red;
                }
                else if (Convert.ToString(this.dgvLedgerList.Rows[e.RowIndex].Cells["PaymentStatus"].Value) == "DECLINED")
                {
                    e.CellElement.ForeColor = Color.White;
                    e.CellElement.DrawFill = true;
                    e.CellElement.GradientStyle = GradientStyles.Solid;
                    e.CellElement.BackColor = Color.Red;
                }
            }
        }
        private void txtContractId_TextChanged(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtContractId.Text))
            {
                ClearFields();
            }
        }

        private void btnAdvanceSearch_Click(object sender, EventArgs e)
        {
            ContractQuickInquiryAdvanceSearchBrowse fmrAdvSearch = new ContractQuickInquiryAdvanceSearchBrowse();
            fmrAdvSearch.ShowDialog();
            if (fmrAdvSearch.IsProceed)
            {
                this.txtContractId.Text = string.Empty;
                this.txtContractId.Text = fmrAdvSearch.ContractID;
                M_GetContractDetailsInquiry();
                M_GetLedgerList();
            }
        }
    }
}
