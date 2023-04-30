using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Linq.Expressions;
using System.Web;
using System.Web.Caching;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Inboxd.Source.Private
{
    public partial class Login : System.Web.UI.Page
    {
        SqlConnection connection;
        string connectionStr = ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnSignIn_Click(object sender, EventArgs e)
        {
            string email = tbEmail.Value;
            string password = tbPassword.Value;

            User user = new User(Email: email, Password:password);

            try
            {

                connection = new SqlConnection(connectionStr);
                connection.Open();
                string comStr = "SELECT * FROM [Users]";
                SqlCommand command = new SqlCommand(comStr, connection);
                SqlDataAdapter adapter = new SqlDataAdapter();
                SqlDataReader reader = command.ExecuteReader();
            }
            catch(SqlException ex){
                lblMessages.ForeColor = System.Drawing.Color.Red;
                lblMessages.Text = ex.Message;  
            }
            finally { 
                connection.Close();
            }

            if(user.Login())
            {
                Response.Redirect("Inbox.aspx");

            }
        }

        protected void btnSignUp_Click(object sender, EventArgs e)
        {
            Response.Redirect("SignUp.aspx");
        }
    }
}