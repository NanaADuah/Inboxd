using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Inboxd.Source.Private
{
    public partial class EmailView : System.Web.UI.Page
    {
        public Email SingleEmail = new Email();
        public bool ValidView = false;
        public string ReadLabel = "MARK AS READ";
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("Login.aspx");

            string sessionValue = Session["filter"] != null ? Session["filter"].ToString() : "";


            if (!String.IsNullOrEmpty(Request.QueryString["read"]))
            {
                string result;
                if (sessionValue != "sent")
                {
                    Email.SetAsRead(EmailID: Request.QueryString["read"], out result);
                    if (result == "success")
                        Response.Redirect("Inbox.aspx");
                    else
                        lblMessages.Text = result;
                }
            }
            else
            if (!String.IsNullOrEmpty(Request.QueryString["star"]))
            {
                string result;
                Email.SetStarEmail(EmailID: Request.QueryString["star"], out result);
                if(result == "Success")
                    Response.Redirect("Inbox.aspx");
                else
                    lblMessages.Text = result;
            }
            else
            if (String.IsNullOrEmpty(Request.QueryString["id"]))
                Response.Redirect("Inbox.aspx");
            else
            {
                try
                {
                    string emailID = Request.QueryString["id"];
                    Email.GetEmailInformation(EmailID: emailID, int.Parse(Session["UserID"].ToString()), out SingleEmail);
                    if (SingleEmail != null)
                    {
                        ValidView = true;
                        tbEmailInformation.Text = SingleEmail.EmailBody;
                        tbEmailSubject.Text = SingleEmail.EmailSubject;
                        tbEmailDate.Text = SingleEmail.EmailDate.ToString("dd, MMM yyyy");
                        tbEmailTime.Text = SingleEmail.EmailDate.ToString("HH:mm");
                        ReadLabel = SingleEmail.EmailRead ? "MARK AS UNREAD" : "MARK AS READ";
                        string _value = "";

                        if (!SingleEmail.EmailRead && sessionValue != "sent")
                            Email.SetAsRead(SingleEmail.EmailID, out _value);

                        ReadLabel = SingleEmail.EmailRead ? "MARK AS UNREAD" : "MARK AS READ";
                    }
                }
                catch(Exception ex)
                {
                    Private.User.LogError(ex.Message);
                }
            }    
        }

        protected void btnGoBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("Inbox.aspx");
        }

        protected void btnReply_Click(object sender, EventArgs e)
        {
            if (SingleEmail != null)
            {
                if (SingleEmail.EmailSender == 1)
                {
                    lblMessages.Text = "You cannot reply to this email";
                    lblMessages.ForeColor = System.Drawing.Color.Red;
                }
            else
            {
                string url = $"NewMail.aspx?reply={SingleEmail.EmailID}";
                string prevUrl = HttpContext.Current.Request.Url.ToString();
                Session["previousUrl"] = prevUrl;
                Response.Redirect(url, false);
            }
            }
            
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {
            string url = "Inbox.aspx";
            if (Request.QueryString["id"] != null)
            {
                Email.DeactivateEmail(Request.QueryString["id"]);
                if (Session["previousUrl"] != null)
                    url = Session["previousUrl"].ToString();
                
                Response.Redirect(url, false);
            }
        }

        protected void btnSpamSet_Click(object sender, EventArgs e)
        {
            string result = "";
            Session["previousUrl"] = HttpContext.Current.Request.Url.ToString();
            if (Request.QueryString["id"] != null)
            {
                Email.SetAsSpam(Request.QueryString["id"], out result);
                Response.Redirect($"EmailView.aspx?={Request.QueryString["id"]}");
            }
        }

        protected void Button1_Click(object sender, EventArgs e)
        {

        }

        protected void btnUnsetSpam_Click(object sender, EventArgs e)
        {

        }

        protected void btnMarkRead_Click(object sender, EventArgs e)
        {
            string result;
            Email.SetAsUnread(SingleEmail.EmailID, out result);

            Response.Redirect("Inbox.aspx?filter=default");

        }
    }

}