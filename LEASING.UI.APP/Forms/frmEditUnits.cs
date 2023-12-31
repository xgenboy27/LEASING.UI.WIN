﻿using LEASING.UI.APP.Context;
using LEASING.UI.APP.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace LEASING.UI.APP.Forms
{
    public partial class frmEditUnits : Form
    {
        ProjectContext ProjectContext = new ProjectContext();
        FloorTypeContext FloorTypeContext = new FloorTypeContext();
        UnitContext UnitContext = new UnitContext();
        public int Recid { get; set; }
        public bool IsProceed = false;
        public bool isResidential = false;
        public frmEditUnits()
        {
            InitializeComponent();
        }



        private string _strUnitFormMode;
        public string strUnitFormMode
        {
            get
            {
                return _strUnitFormMode;
            }
            set
            {
                _strUnitFormMode = value;
                switch (_strUnitFormMode)
                {
                    case "EDIT":
                        btnUndo.Enabled = true;
                        btnSave.Enabled = true;
                        btnEdit.Enabled = false;
                        EnableFields();
                        break;
                    case "READ":
                        btnUndo.Enabled = false;
                        btnSave.Enabled = false;
                        btnEdit.Enabled = true;
                        DisEnableFields();
                        break;

                    default:
                        break;
                }
            }
        }

        public class UnitStatus
        {
            public string UnitStatusName { get; set; }
        }

        List<UnitStatus> UnitStatusList = new List<UnitStatus>()
        {
            new UnitStatus { UnitStatusName = "--SELECT--"},
            new UnitStatus { UnitStatusName = "VACANT"},
            //new UnitStatus { UnitStatusName = "RESERVED"},
            //new UnitStatus { UnitStatusName = "OCCUPIED"},
             new UnitStatus { UnitStatusName = "NOT AVAILABLE"}
        };


        private void M_GetUnitStatus()
        {

            ddlUnitStatus.DataSource = null;
            if (UnitStatusList.Count() > 0)
            {
                ddlUnitStatus.DisplayMember = "UnitStatusName";
                ddlUnitStatus.ValueMember = "UnitStatusName";
                ddlUnitStatus.DataSource = UnitStatusList;
            }
        }

        private void M_GetUnitById()
        {

            using (DataSet dt = UnitContext.GetUnitById(Recid))
            {
                if (dt != null && dt.Tables.Count > 0 && dt.Tables[0].Rows.Count > 0)
                {
                    ddlProject.SelectedValue = Convert.ToInt32(dt.Tables[0].Rows[0]["ProjectId"]);
                    ddlUnitStatus.SelectedText = Convert.ToString(dt.Tables[0].Rows[0]["UnitStatus"]);
                    txtIsParking.Text = Convert.ToString(dt.Tables[0].Rows[0]["UnitDescription"]);
                    txtAreSql.Text = Convert.ToString(dt.Tables[0].Rows[0]["AreaSqm"]);
                    ddlFloorType.SelectedText = Convert.ToString(dt.Tables[0].Rows[0]["FloorType"]);
                    txtDetailsOfProperty.Text = Convert.ToString(dt.Tables[0].Rows[0]["DetailsofProperty"]);
                    txtUnitNumber.Text = Convert.ToString(dt.Tables[0].Rows[0]["UnitNo"]);
                    txtFloorNumber.Text = Convert.ToString(dt.Tables[0].Rows[0]["FloorNo"]);
                    txtAreRateSqm.Text = Convert.ToString(dt.Tables[0].Rows[0]["AreaRateSqm"]);
                    txtBaseRental.Text = Convert.ToString(dt.Tables[0].Rows[0]["BaseRental"]);
                    txtUnitSequence.Text = Convert.ToString(dt.Tables[0].Rows[0]["UnitSequence"]);

                }
            }
        }
        private bool IsUnitValid()
        {
            if (ddlProject.SelectedText == "--SELECT--")
            {
                MessageBox.Show("Project  cannot be empty !", "System Message", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                return false;
            }
            if (isResidential)
            {
                if (ddlFloorType.SelectedText == "--SELECT--")
                {
                    MessageBox.Show("Floor Type cannot be empty !", "System Message", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                    return false;
                }
            }

            return true;
        }

        private void EnableFields()
        {

            ddlProject.Enabled = true;
            ddlUnitStatus.Enabled = true;

            txtAreSql.Enabled = true;
            ddlFloorType.Enabled = true;
            txtDetailsOfProperty.Enabled = true;
            txtType.Enabled = true;
            txtUnitNumber.Enabled = true;
            txtFloorNumber.Enabled = true;
            txtAreRateSqm.Enabled = true;
            txtBaseRental.Enabled = true;
            txtUnitSequence.Enabled = true;
            txtIsParking.Enabled = true;
            //dgvUnitList.Enabled = true;




        }

        private void ClearFields()
        {

            ddlProject.SelectedIndex = 0;
            ddlUnitStatus.SelectedIndex = 0;

            txtAreSql.Text = string.Empty;
            ddlFloorType.SelectedIndex = 0;
            txtDetailsOfProperty.Text = string.Empty;
            txtType.Text = string.Empty;
            txtUnitNumber.Text = string.Empty;
            txtFloorNumber.Text = string.Empty;
            txtAreRateSqm.Text = string.Empty;
            txtBaseRental.Text = string.Empty;
            txtUnitSequence.Text = string.Empty;
            txtIsParking.Text = string.Empty;

        }

        private void DisEnableFields()
        {

            ddlProject.Enabled = false;
            ddlUnitStatus.Enabled = false;

            txtAreSql.Enabled = false;
            ddlFloorType.Enabled = false;
            txtDetailsOfProperty.Enabled = false;
            txtType.Enabled = false;
            txtUnitNumber.Enabled = false;
            txtFloorNumber.Enabled = false;
            txtAreRateSqm.Enabled = false;
            txtBaseRental.Enabled = false;
            txtUnitSequence.Enabled = false;
            txtIsParking.Enabled = false;
            //dgvUnitList.Enabled = false;
        }

        private void M_SelectProject()
        {

            ddlProject.DataSource = null;
            using (DataSet dt = ProjectContext.GetSelectProject())
            {
                if (dt != null && dt.Tables.Count > 0 && dt.Tables[0].Rows.Count > 0)
                {
                    ddlProject.DisplayMember = "ProjectName";
                    ddlProject.ValueMember = "RecId";
                    ddlProject.DataSource = dt.Tables[0];
                }
            }
        }

        private void M_SelectFloortypes()
        {

            ddlFloorType.DataSource = null;
            using (DataSet dt = FloorTypeContext.GetSelectFloortypes())
            {
                if (dt != null && dt.Tables.Count > 0 && dt.Tables[0].Rows.Count > 0)
                {
                    ddlFloorType.DisplayMember = "FloorTypesDescription";
                    ddlFloorType.ValueMember = "RecId";
                    ddlFloorType.DataSource = dt.Tables[0];
                }
            }
        }

        private void frmEditUnits_Load(object sender, EventArgs e)
        {
            strUnitFormMode = "READ";
            this.Text = string.Empty;
            ddlFloorType.Visible = false;
            lblFloorType.Visible = false;
            //lblUnitStatus.Visible = false;
            //ddlUnitStatus.Visible = false;
            M_GetUnitStatus();
            M_SelectProject();
            M_SelectFloortypes();
            M_GetUnitById();
            if (ddlUnitStatus.Text == "RESERVED")
            {

                btnUndo.Visible = false;
                btnSave.Visible = false;
                btnEdit.Visible = false;
            }
            else
            {
                btnUndo.Visible = true;
                btnSave.Visible = true;
                btnEdit.Visible = true;
            }
            this.Text = "UNIT # ( " + txtUnitNumber.Text + " )-" + ddlUnitStatus.Text;
        }

        private void btnEdit_Click(object sender, EventArgs e)
        {
            strUnitFormMode = "EDIT";
        }
        private void M_SaveUnit()
        {
            UnitModel dto = new UnitModel();
            dto.UnitId = Recid;
            //dto.UnitDescription = unitDescription.Text;
            dto.FloorNo = txtFloorNumber.Text == string.Empty ? 0 : Convert.ToInt32(txtFloorNumber.Text);
            dto.AreaSqm = txtAreSql.Text == string.Empty ? 0 : decimal.Parse(txtAreSql.Text);
            dto.AreaRateSqm = txtAreRateSqm.Text == string.Empty ? 0 : decimal.Parse(txtAreRateSqm.Text);
            dto.FloorType = ddlFloorType.Text;
            dto.BaseRental = txtBaseRental.Text == string.Empty ? 0 : decimal.Parse(txtBaseRental.Text);
            dto.UnitStatus = ddlUnitStatus.Text;
            dto.DetailsofProperty = txtDetailsOfProperty.Text;
            dto.UnitNo = txtUnitNumber.Text;
            dto.UnitSequence = txtUnitSequence.Text == string.Empty ? 0 : Convert.ToInt32(txtUnitSequence.Text);
            dto.LastchangedBy = 1;

            dto.Message_Code = UnitContext.EditUnit(dto);
            if (dto.Message_Code.Equals("SUCCESS"))
            {
                MessageBox.Show("Unit has been updated successfully !", "System Message", MessageBoxButtons.OK, MessageBoxIcon.Information);
                strUnitFormMode = "READ";
                IsProceed = true;
                M_GetUnitById();

            }
            else
            {
                MessageBox.Show(dto.Message_Code, "System Message", MessageBoxButtons.OK, MessageBoxIcon.Information);
                strUnitFormMode = "READ";
            }
        }
        private void btnSave_Click(object sender, EventArgs e)
        {
            if (strUnitFormMode == "EDIT")
            {
                if (Recid > 0)
                {
                    if (IsUnitValid())
                    {
                        if (MessageBox.Show("Are you sure you want to update the following Unit?", "System Message", MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button2) == DialogResult.Yes)
                        {
                            M_SaveUnit();
                        }
                    }
                }
            }
        }

        private void btnUndo_Click(object sender, EventArgs e)
        {
            strUnitFormMode = "READ";
        }
        private void M_GetProjectTypeById()
        {
            isResidential = false;
            txtType.Text = string.Empty;

            using (DataSet dt = ProjectContext.GetProjectTypeById(Convert.ToInt32(ddlProject.SelectedValue)))
            {
                if (dt != null && dt.Tables.Count > 0 && dt.Tables[0].Rows.Count > 0)
                {

                    string Projecttype = Convert.ToString(dt.Tables[0].Rows[0]["ProjectType"]);
                    txtType.Text = Convert.ToString(dt.Tables[0].Rows[0]["ProjectType"]);
                    if (Projecttype == "RESIDENTIAL")
                    {
                        isResidential = true;
                    }
                }
            }
        }

        private void ddlProject_SelectedIndexChanged(object sender, Telerik.WinControls.UI.Data.PositionChangedEventArgs e)
        {
            if (ddlProject.SelectedIndex > 0)
            {
                M_GetProjectTypeById();
                if (isResidential)
                {
                    ddlFloorType.Visible = true;
                    lblFloorType.Visible = true;
                    M_SelectFloortypes();
                }

                else
                {
                    ddlFloorType.Visible = false;
                    lblFloorType.Visible = false;
                }
            }
            else if (ddlProject.SelectedIndex == 0)
            {
                ddlFloorType.Visible = false;
                lblFloorType.Visible = false;
                txtType.Text = string.Empty;
                ddlFloorType.SelectedIndex = 0;
                isResidential = false;
            }
        }

        private void txtAreSql_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!Regex.IsMatch(Convert.ToString(e.KeyChar), "[0-9.\b]"))
                e.Handled = true;
        }

        private void txtFloorNumber_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!Regex.IsMatch(Convert.ToString(e.KeyChar), "[0-9\b]"))
                e.Handled = true;
        }

        private void txtAreRateSqm_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!Regex.IsMatch(Convert.ToString(e.KeyChar), "[0-9.\b]"))
                e.Handled = true;
        }

        private void txtBaseRental_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!Regex.IsMatch(Convert.ToString(e.KeyChar), "[0-9.\b]"))
                e.Handled = true;
        }

        private void txtUnitSequence_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!Regex.IsMatch(Convert.ToString(e.KeyChar), "[0-9\b]"))
                e.Handled = true;
        }

        private void btnPuchaseItemList_Click(object sender, EventArgs e)
        {

        }
    }
}
