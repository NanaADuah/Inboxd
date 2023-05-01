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
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
                Response.Redirect("Login.aspx");

            if (!String.IsNullOrEmpty(Request.QueryString["read"]))
            {
                string result;
                Email.SetAsRead(EmailID: Request.QueryString["read"], out result);
                if(result == "Success")
                    Response.Redirect("Inbox.aspx");
                else
                    lblMessages.Text = result;
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

                        string _value = "";
                        if (!SingleEmail.EmailRead)
                            Email.SetAsRead(SingleEmail.EmailID, out _value);
                    }
                }
                catch(Exception ex)
                {
                    User user = new User();
                    user.LogError(ex.Message);
                }
            }    

        }

        protected void btnGoBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("Inbox.aspx");
        }

        protected void btnReply_Click(object sender, EventArgs e)
        {
            if(SingleEmail != null)
            {
                string url = $"NewMail.aspx?reply={SingleEmail.EmailID}";
                string prevUrl = HttpContext.Current.Request.Url.ToString();
                ViewState["previousUrl"] = prevUrl;
                Response.Redirect(url, false);
            }
            
        }

        protected void btnDelete_Click(object sender, EventArgs e)
        {

        }
    }

}