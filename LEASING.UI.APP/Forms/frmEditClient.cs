﻿using LEASING.UI.APP.Common;
using LEASING.UI.APP.Context;
using LEASING.UI.APP.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace LEASING.UI.APP.Forms
{
    public partial class frmEditClient : Form
    {


        ClientContext ClientContext = new ClientContext();
        public bool IsContractSigned { get; set; } = false;
        public string ReferenceId { get; set; } = string.Empty;
        private string _strClientFormMode;
        public string strClientFormMode
        {
            get
            {
                return _strClientFormMode;
            }
            set
            {
                _strClientFormMode = value;
                switch (_strClientFormMode)
                {
                    case "EDIT":
                        btnUndo.Enabled = true;
                        btnSave.Enabled = true;
                        btnNewProject.Enabled = false;
                        EnabledFields();


                        break;
                    case "READ":
                        btnUndo.Enabled = false;
                        btnSave.Enabled = false;
                        btnNewProject.Enabled = true;
                        DisabledFields();


                        break;

                    case "IsContractSigned":
                        btnUndo.Enabled = false;
                        btnSave.Enabled = false;
                        btnNewProject.Enabled = false;
                        DisabledFields();
                        btnUploadFile.Enabled = true;

                        break;
                    default:
                        break;
                }
            }
        }

        private void EnabledFields()
        {
            ddlClientType.Enabled = true;
            txtname.Enabled = true;
            txtage.Enabled = true;
            txtpostaladdress.Enabled = true;
            dtpdob.Enabled = true;
            ddlgender.Enabled = true;
            txttelno.Enabled = true;
            txtnationality.Enabled = true;
            txtoccupation.Enabled = true;
            txtannualincome.Enabled = true;
            txtnameofemployer.Enabled = true;
            txtaddresstelephoneno.Enabled = true;
            txtspousename.Enabled = true;
            txtnameofchildren.Enabled = true;
            txttotalnoofperson.Enabled = true;
            txtnameofmaid.Enabled = true;
            txtnameofdriver.Enabled = true;
            txtnoofvisitorperday.Enabled = true;
            btnUploadFile.Enabled = true;

            txtClienID.Enabled = true;
            txtClienID.ReadOnly = true;
        }
        private void DisabledFields()
        {
            ddlClientType.Enabled = false;
            txtname.Enabled = false;
            txtage.Enabled = false;
            txtpostaladdress.Enabled = false;
            dtpdob.Enabled = false;
            ddlgender.Enabled = false;
            txttelno.Enabled = false;
            txtnationality.Enabled = false;
            txtoccupation.Enabled = false;
            txtannualincome.Enabled = false;
            txtnameofemployer.Enabled = false;
            txtaddresstelephoneno.Enabled = false;
            txtspousename.Enabled = false;
            txtnameofchildren.Enabled = false;
            txttotalnoofperson.Enabled = false;
            txtnameofmaid.Enabled = false;
            txtnameofdriver.Enabled = false;
            txtnoofvisitorperday.Enabled = false;
            btnUploadFile.Enabled = false;

            txtClienID.Enabled = false;
            txtClienID.ReadOnly = true;
        }

        public string ClientID { get; set; }
        public bool IsProceed = false;
        public frmEditClient()
        {
            InitializeComponent();
        }

        private void M_GetClientFileList()
        {
            dgvFileList.DataSource = null;
            using (DataSet dt = ClientContext.GetGetFilesByClient(ClientID))
            {
                if (dt != null && dt.Tables.Count > 0 && dt.Tables[0].Rows.Count > 0)
                {
                    dgvFileList.AutoGenerateColumns = false;
                    dgvFileList.DataSource = dt.Tables[0];
                }
            }
        }

        private void M_GetClientById()
        {

            using (DataSet dt = ClientContext.GetClientById(ClientID))
            {
                if (dt != null && dt.Tables.Count > 0 && dt.Tables[0].Rows.Count > 0)
                {
                    ddlClientType.Text = Convert.ToString(dt.Tables[0].Rows[0]["ClientType"]);
                    txtname.Text = Convert.ToString(dt.Tables[0].Rows[0]["ClientName"]);
                    txtage.Text = Convert.ToString(dt.Tables[0].Rows[0]["Age"]);
                    txtpostaladdress.Text = Convert.ToString(dt.Tables[0].Rows[0]["PostalAddress"]);
                    dtpdob.Value = Convert.ToDateTime(dt.Tables[0].Rows[0]["DateOfBirth"]);
                    ddlgender.Text = Convert.ToString(dt.Tables[0].Rows[0]["Gender"]);
                    txttelno.Text = Convert.ToString(dt.Tables[0].Rows[0]["TelNumber"]);
                    txtnationality.Text = Convert.ToString(dt.Tables[0].Rows[0]["Nationality"]);
                    txtoccupation.Text = Convert.ToString(dt.Tables[0].Rows[0]["Occupation"]);
                    txtannualincome.Text = Convert.ToString(dt.Tables[0].Rows[0]["AnnualIncome"]);
                    txtnameofemployer.Text = Convert.ToString(dt.Tables[0].Rows[0]["EmployerName"]);
                    txtaddresstelephoneno.Text = Convert.ToString(dt.Tables[0].Rows[0]["EmployerAddress"]);
                    txtspousename.Text = Convert.ToString(dt.Tables[0].Rows[0]["SpouseName"]);
                    txtnameofchildren.Text = Convert.ToString(dt.Tables[0].Rows[0]["ChildrenNames"]);
                    txttotalnoofperson.Text = Convert.ToString(dt.Tables[0].Rows[0]["TotalPersons"]);
                    txtnameofmaid.Text = Convert.ToString(dt.Tables[0].Rows[0]["MaidName"]);
                    txtnoofvisitorperday.Text = Convert.ToString(dt.Tables[0].Rows[0]["VisitorsPerDay"]);
                    txtnameofdriver.Text = Convert.ToString(dt.Tables[0].Rows[0]["DriverName"]);
                }
            }
        }

        private void M_GetReferenceByClientID()
        {
            dgvList.DataSource = null;
            using (DataSet dt = ClientContext.GetReferenceByClientID(ClientID))
            {
                if (dt != null && dt.Tables.Count > 0 && dt.Tables[0].Rows.Count > 0)
                {
                    dgvList.DataSource = dt.Tables[0];
                }
            }
        }

        private void btnUploadFile_Click(object sender, EventArgs e)
        {

            try
            {
                string folderPath = string.Empty;
                OpenFileDialog openFileDialog = new OpenFileDialog();
                openFileDialog.Multiselect = true;

                if (openFileDialog.ShowDialog() == DialogResult.OK)
                {
                    string[] filePaths = openFileDialog.FileNames;
                    string sClientID = ClientID.Trim();

                    if (!string.IsNullOrWhiteSpace(sClientID) && filePaths.Length > 0)
                    {
                        foreach (string filePath in filePaths)
                        {

                            frmUploadFile frmUploadFile = new frmUploadFile();

                            frmUploadFile.txtClientID.Text = sClientID;
                            frmUploadFile.IsContractSigned = IsContractSigned;
                            string fileName = Path.GetFileName(filePath);
                            
                                                     
                            //string folderName = Path.GetFileNameWithoutExtension(filePath);                                                
                           
                            //frmUploadFile.sFilePath = folderPath;
                            frmUploadFile.ShowDialog();
                            if (frmUploadFile.IsProceed)
                            {
                                if (!string.IsNullOrEmpty(frmUploadFile.ReferenceId))
                                {
                                    folderPath = Path.Combine(Config.baseFolderPath, sClientID, frmUploadFile.ReferenceId);
                                    ReferenceId = frmUploadFile.ReferenceId;
                                }
                                else
                                {
                                    folderPath = Path.Combine(Config.baseFolderPath, sClientID);
                                }
                                string destFilePath = Path.Combine(folderPath, fileName);

                                if (string.IsNullOrEmpty(ReferenceId))
                                {
                                    ReferenceId = frmUploadFile.ReferenceId;
                                }
                                if (!Directory.Exists(folderPath))
                                {
                                    Directory.CreateDirectory(folderPath);

                                    string destinationFilePath = Path.Combine(folderPath, fileName);
                                    File.Copy(filePath, destinationFilePath);

                                    string result = ClientContext.SaveFileInDatabase(sClientID, destinationFilePath, frmUploadFile.txtfilename.Text, fileName, frmUploadFile.txtnotes.Text, ReferenceId, IsContractSigned);
                                    if (result.Equals("SUCCESS"))
                                    {

                                        MessageBox.Show("Files attached successfully!", "System Message", MessageBoxButtons.OK, MessageBoxIcon.Information);
                                        M_GetClientFileList();

                                    }

                                }
                                else if (Directory.Exists(folderPath))
                                {
                                    string destinationFilePath = Path.Combine(folderPath, fileName);
                                    if (File.Exists(destinationFilePath))
                                    {
                                        if (MessageBox.Show("File Already Exists would you like to replace the file?", "System Message", MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button2) == DialogResult.Yes)
                                        {
                                            File.Delete(destinationFilePath);
                                            ClientContext.DeleteFileFromDatabase(destinationFilePath);
                                        }


                                    }
                                    //Directory.Delete(folderPath);
                                    //Directory.CreateDirectory(folderPath);


                                    File.Copy(filePath, destinationFilePath);

                                    string result = ClientContext.SaveFileInDatabase(sClientID, destinationFilePath, frmUploadFile.txtfilename.Text, fileName, frmUploadFile.txtnotes.Text, ReferenceId, IsContractSigned);
                                    if (result.Equals("SUCCESS"))
                                    {
                                        MessageBox.Show("Files attached successfully!", "System Message", MessageBoxButtons.OK, MessageBoxIcon.Information);
                                        M_GetClientFileList();

                                    }


                                }

                            }
                        }
                    }
                    else
                    {
                        MessageBox.Show("Please enter a client name and select at least one file.");
                    }
                }
            }
            catch (Exception ex)
            {

                // Log the exception


                // Log the error into the stored procedure
                Functions.LogErrorIntoStoredProcedure("sp_SaveFile" + "Upload File", "EDIT Client", ex.Message, DateTime.Now, this);

                // Optionally, show a message box to the user
                MessageBox.Show("An error occurred : " + ex.ToString() + " Please check the log table details.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }

        }

        private void frmEditClient_Load(object sender, EventArgs e)
        {
            if (IsContractSigned)
            {
                strClientFormMode = "IsContractSigned";
            }
            else
            {
                strClientFormMode = "READ";
            }

            txtClienID.Text = ClientID;
            M_GetClientById();
            M_GetClientFileList();
            M_GetReferenceByClientID();
        }


        private void dgvFileList_CellClick(object sender, Telerik.WinControls.UI.GridViewCellEventArgs e)
        {
            if (e.RowIndex >= 0)
            {
                if (this.dgvFileList.Columns[e.ColumnIndex].Name == "ColView")
                {
                    /*add dataset to select the file path if reference is empty*/
                    // forms.ClientID = Convert.ToString(dgvFileList.CurrentRow.Cells["ClientID"].Value);
                    ClientContext.GetViewFileById(ClientID.Trim(), Config.baseFolderPath, Convert.ToInt32(dgvFileList.CurrentRow.Cells["Id"].Value));
                }
                else if (this.dgvFileList.Columns[e.ColumnIndex].Name == "ColDelete")
                {

                    if (!string.IsNullOrWhiteSpace(ClientID))
                    {

                        DialogResult result = MessageBox.Show("Are you sure you want to delete all files for this client?", "Confirmation", MessageBoxButtons.YesNo);

                        if (result == DialogResult.Yes)
                        {
                            string sfilepath = Convert.ToString(dgvFileList.CurrentRow.Cells["FilePath"].Value);
                            if (File.Exists(sfilepath))
                            {
                                File.Delete(sfilepath);
                            }

                            ClientContext.DeleteFileFromDatabase(sfilepath);
                            M_GetClientFileList();
                            //labelStatus.Text = "Files deleted successfully!";
                        }

                    }
                    else
                    {
                        MessageBox.Show("Please enter a client name.");
                    }
                }

            }
        }
        private bool IsClientValid()
        {
            if (string.IsNullOrEmpty(ddlClientType.Text))
            {
                MessageBox.Show("Client Type cannot be empty !", "System Message", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                return false;
            }
            if (string.IsNullOrEmpty(txtname.Text))
            {
                MessageBox.Show("Name cannot be empty !", "System Message", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                return false;
            }

            return true;
        }

        private void M_SaveClient()
        {
            ClientModel dto = new ClientModel();
            dto.ClientType = ddlClientType.Text == "INDIVIDUAL" ? "INDV" : "CORP";
            dto.ClientName = txtname.Text;
            dto.Age = txtage.Text == "" ? 0 : Convert.ToInt32(txtage.Text);
            dto.PostalAddress = txtpostaladdress.Text;
            dto.DateOfBirth = dtpdob.Text;
            dto.Gender = ddlgender.Text == "MALE" ? true : false;
            dto.TelNumber = txttelno.Text;
            dto.Nationality = txtnationality.Text;
            dto.Occupation = txtoccupation.Text;
            dto.AnnualIncome = txtannualincome.Text == "" ? 0 : Convert.ToInt32(txtannualincome.Text);
            dto.EmployerName = txtnameofemployer.Text;
            dto.EmployerAddress = txtaddresstelephoneno.Text;
            dto.SpouseName = txtspousename.Text;
            dto.ChildrenNames = txtnameofchildren.Text;
            dto.TotalPersons = txttotalnoofperson.Text == "" ? 0 : Convert.ToInt32(txttotalnoofperson.Text);
            dto.MaidName = txtnameofmaid.Text;
            dto.DriverName = txtnameofdriver.Text;
            dto.NoVisitorsPerDay = txtnoofvisitorperday.Text == "" ? 0 : Convert.ToInt32(txtnoofvisitorperday.Text);
            dto.BuildingSecretary = 1;
            dto.EncodedBy = 1;
            dto.Message_Code = ClientContext.SaveClient(dto);
            if (dto.Message_Code.Equals("SUCCESS"))
            {
                MessageBox.Show("New Client  has been added successfully !", "System Message", MessageBoxButtons.OK, MessageBoxIcon.Information);
                strClientFormMode = "READ";


            }
            else
            {
                MessageBox.Show(dto.Message_Code, "System Message", MessageBoxButtons.OK, MessageBoxIcon.Information);
                strClientFormMode = "READ";
            }
        }
        private void btnSave_Click(object sender, EventArgs e)
        {
            if (IsClientValid())
            {
                if (MessageBox.Show("Are you sure you want to add this client ?", "System Message", MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button2) == DialogResult.Yes)
                {
                    M_SaveClient();
                }
            }
        }

        private void btnNewProject_Click(object sender, EventArgs e)
        {
            strClientFormMode = "EDIT";
        }

        private void btnUndo_Click(object sender, EventArgs e)
        {
            strClientFormMode = "READ";
        }

        private void dgvList_CellClick(object sender, Telerik.WinControls.UI.GridViewCellEventArgs e)
        {
            if (e.RowIndex >= 0)
            {
                if (this.dgvList.Columns[e.ColumnIndex].Name == "ColViewFile")
                {
                    frmGetContactSignedDocumentsByReference forms = new frmGetContactSignedDocumentsByReference();
                    forms.ClientID = Convert.ToString(dgvList.CurrentRow.Cells["ClientID"].Value);
                    forms.ReferenceID = Convert.ToString(dgvList.CurrentRow.Cells["RefId"].Value);
                    forms.ShowDialog();
                }
                else if (this.dgvList.Columns[e.ColumnIndex].Name == "ColView")
                {
                    frmEditUnitComputation forms = new frmEditUnitComputation();
                    forms.Recid = Convert.ToInt32(dgvList.CurrentRow.Cells["RecId"].Value);
                    forms.ShowDialog();
                }
                else if (this.dgvList.Columns[e.ColumnIndex].Name == "ColLedger")
                {
                    frmClosedClientTransaction forms = new frmClosedClientTransaction();
                    forms.ComputationRecid = Convert.ToInt32(dgvList.CurrentRow.Cells["RecId"].Value);
                    forms.ClientId = Convert.ToString(dgvList.CurrentRow.Cells["ClientID"].Value);
                    forms.ShowDialog();
                }
            }
        }
    }
}
