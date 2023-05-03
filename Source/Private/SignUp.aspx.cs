using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Inboxd.Source.Private
{
    public partial class SignUp : System.Web.UI.Page
    {
        List<string> emailSuggests = new List<string>();
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!IsPostBack)
            {
                emailSelection.Visible = false;
                btnAccept.Visible = true;
                btnSignUp.Visible = false;
            }
        }

        protected void btnSignUp_Click(object sender, EventArgs e)
        {
            if (lbAvailEmails.SelectedItem != null)
            {
                string selectedEmail = lbAvailEmails.SelectedItem.ToString();
                User user = new User(
                    Email: selectedEmail,
                    Surname: tbSurname.Value,
                    Name: tbName.Value,
                    DOB: DateTime.Parse(tbDOB.Value),
                    Password: tbPassword.Value
                    );

                if (user.CreateUser().Equals("success"))
                    Response.Redirect("Login.aspx");
            }

        }

        protected void btnAccept_Click(object sender, EventArgs e)
        {
            emailSelection.Visible = true;
            
            btnAccept.Visible = false;
            btnSignUp.Visible = true;
            lbAvailEmails.Items.Clear();

            Email email = new Email();
            emailSuggests = email.GetSuggestedEmails(name: tbName.Value, surname: tbSurname.Value);

            foreach (var item in emailSuggests)
            {
                ListItem temp = new ListItem(item);
                temp.Attributes.Add("class", "list-group-item");
                lbAvailEmails.Items.Add(temp);

            }
        }
    }
}