using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Inboxd.Source.Private
{
    public partial class NewMail : System.Web.UI.Page
    {
        private void LoadReply(string EmailID)
        {
            Email email = new Email();
            User user = new User();
            Email.GetEmailInformation(EmailID, int.Parse(Session["UserID"].ToString()), out email);

            if(email != null)
            {
                tbSubject.Value = String.Format("RE: {0}", Additional.RemoveReFromSubject(email.EmailSubject));
                tbToSender.Value =  user.getUserEmail(email.EmailSender);

                if (includeReply.Checked)
                {
                    tbEmailArea.Text += String.Format("\n/** Type your email here **/\n\n ------------ Original Message ------------\n From: {0}\nDate: {1}\nSubject: {2}\n\n{3}", user.getUserEmail(email.EmailSender), email.EmailDate.ToString("dd\\/MM\\/yyyy HH:mm"), email.EmailSubject, email.EmailBody);
                }
            }
        }
        
        
        private void LoadEdit(string EmailID)
        {
            Email email = new Email();
            User user = new User();
            Email.GetDraftEmailInformation(EmailID, int.Parse(Session["UserID"].ToString()), out email);

            if(email != null)
            {
                tbSubject.Value  = String.Format(email.EmailSubject);
                tbToSender.Value = user.getUserEmail(email.EmailSender);
                tbEmailArea.Text = email.EmailBody;
                tbToSender.Disabled = true;
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("Login.aspx");
            if (!IsPostBack)
            {
                tbToSender.Value = "";
                tbSubject.Value = "";
                tbEmailArea.Text = "";
                
                if (!String.IsNullOrEmpty(Request.QueryString["reply"]))
                {
                    string EmailID = Request.QueryString["reply"];
                    LoadReply(EmailID: EmailID);
                }
                else
                if (!String.IsNullOrEmpty(Request.QueryString["edit"]))
                {
                    string EmailID = Request.QueryString["edit"];
                    LoadEdit(EmailID: EmailID);
                
                }
            }
        }

        protected void btnSendMessage_Click(object sender, EventArgs e)
        {
            string Receiver = tbToSender.Value;
            string EmailBody = tbEmailArea.Text;
            string Subject = tbSubject.Value;

            Email email = new Email(Receipient: Receiver, Body:EmailBody, Subject: Subject);
            string output = email.SendEmail();
            tbToSender.Value = "";
            tbSubject.Value = "";
            tbEmailArea.Text = "";
            if (output.Equals("Success"))
            {
                if (Request.QueryString["edit"] != null)
                    Email.DeleteDraft(Request.QueryString["edit"].ToString());

                Session["filter"] = "sent";
                Response.Redirect("Inbox.aspx");
            }
            else
                lblMessages.Text = output;
        }

        protected void btnDeleteEmail_Click(object sender, EventArgs e)
        {
            //TODO: Fix this!!!
            //string temp = ViewState["previousUrl"].ToString();
            //if (Session["previousUrl"] != null)
            //{
            //    Response.Redirect(Session["previousUrl"].ToString(), false);
            //    //Session["previousUrl"] = null;
            //}
            //else
            //if (Request.QueryString["edit"] != null) {
            //    Email.DeleteDraft(Request.QueryString["edit"]);
            //    Response.Redirect("Inbox.aspx", false);
            //}
            //else
            //if (Request.QueryString["id"] != null)
            //{
            //    if (Email.DeactivateEmail(Request.QueryString["id"].ToString()) == "success")
            //        
            //}

            Response.Redirect("Inbox.aspx", false);
        }

        protected void btnSaveDraft_Click(object sender, EventArgs e)
        {
            Email email = new Email(
                EmailBody: tbEmailArea.Text,
                ReceipientEmail: tbToSender.Value,
                EmailSubject: tbSubject.Value,
                EmailReference: string.IsNullOrEmpty(Request.QueryString["reply"]) ? "" : Request.QueryString["reply"]

                );
            
            string results;

            email.SaveDraft(email, out results);
            if (Request.QueryString["edit"] != null && results.Equals("success") )
            {
                Email.DeleteDraft(Request.QueryString["edit"]);
            }

            if(results.Equals("sucess"))
                Session["filter"] = "draft";

            Response.Redirect("Inbox.aspx", false);
        }

        protected void btnAddAttachments_Click(object sender, EventArgs e)
        {
            lblMessages.Text = "Doesn't work yet, sorry";
            lblMessages.ForeColor = System.Drawing.Color.Red;
        }

        protected void includeReply_CheckedChanged(object sender, EventArgs e) 
        {
            Email email;
            User user = new User();
            string EmailID = Request.QueryString["reply"];
            Email.GetEmailInformation(EmailID, int.Parse(Session["UserID"].ToString()), out email);
            if (includeReply.Checked)
            {
                tbEmailArea.Text += String.Format("\n/** Type your email here **/\n\n ------------ Original Message ------------\n From: {0}\nDate: {1}\nSubject: {2}\n\n{3}", user.getUserEmail(email.EmailSender), email.EmailDate.ToString("dd\\/MM\\/yyyy HH:mm"), email.EmailSubject, email.EmailBody);
            }
            else
            {
                string defaultStr = String.Format("\n/** Type your email here **/\n\n ------------ Original Message ------------\n From: {0}\nDate: {1}\nSubject: {2}\n\n{3}", user.getUserEmail(email.EmailSender), email.EmailDate.ToString("dd\\/MM\\/yyyy HH:mm"), email.EmailSubject, email.EmailBody);
                string value = tbEmailArea.Text;
                string newOutput = value.Replace(defaultStr, "");
                tbEmailArea.Text = ""; //temp, above code doesn't work
            }
        }

        protected void displayFiles_Click(object sender, EventArgs e)
        {
            
        }

        protected void btnDisplay_Click(object sender, EventArgs e)
        {
            if (attachmentsUpload.HasFiles)
                lblFiles.Text = attachmentsUpload.PostedFile.FileName;
        }
    }
}