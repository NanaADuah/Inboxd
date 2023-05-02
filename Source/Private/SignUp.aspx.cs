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
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnSignUp_Click(object sender, EventArgs e)
        {
            User user = new User(
                Email: tbEmail.Value,
                Surname: tbSurname.Value,
                Name: tbName.Value,
                DOB: DateTime.Parse(tbDOB.Value),
                Password: tbPassword.Value
                );

            if (user.CreateUser().Equals("success"))
                Response.Redirect("Login.aspx");

        }
    }
}