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
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnSignIn_Click(object sender, EventArgs e)
        {
            string connectionStr = ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString;
            string output = "Nothing changed";
            try{
                connection = new SqlConnection(connectionStr);
                connection.Open();
                string comStr = "SELECT * FROM [Users]";
                SqlCommand command = new SqlCommand(comStr, connection);
                SqlDataAdapter adapter = new SqlDataAdapter();
                SqlDataReader reader = command.ExecuteReader();
                if(reader != null)
                    while(reader.Read())
                        output = reader.GetValue(0).ToString();
                    
            }
            catch(SqlException ex){
                lblMessages.ForeColor = System.Drawing.Color.Red;
                lblMessages.Text = ex.Message;  
            }
            finally { 
                connection.Close();
                Response.Redirect("Inbox.aspx");
            }
        }
    }
}