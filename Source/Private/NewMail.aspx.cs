using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Inboxd.Source.Private
{
    public partial class NewMail : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (String.IsNullOrEmpty(Session["UserID"].ToString()))
                Response.Redirect("Login.aspx");
            if (!IsPostBack)
            {
                tbToSender.Value = "";
                tbSubject.Value = "";
                tbMessage.Text = "";
            }
        }

        protected void btnSendMessage_Click(object sender, EventArgs e)
        {
            string Receiver = tbToSender.Value;
            string EmailBody = tbMessage.Text;
            string Subject = tbSubject.Value;

            Email email = new Email(Receipient: Receiver, Body:EmailBody, Subject: Subject);
            string output = email.SendEmail();
            tbToSender.Value = "";
            tbSubject.Value = "";
            tbMessage.Text = "";
            if (output.Equals("Success"))
                Response.Redirect("Inbox.aspx");
            else
                lblMessages.Text = output;
        }
    }
}