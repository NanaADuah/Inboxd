using Inboxd.Source.Private;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Net.Mail;
using System.Runtime.InteropServices;
using System.Text;
using System.Web;

namespace Inboxd.Source
{
    [Serializable]
    public class Email
    {
        private string connectionString = ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString;
        public String EmailID { get; set; }
        public String EmailSubject { get; set; }
        public String ReceipientEmail { get; set; }
        public String EmailBody { get; set; }
        public int EmailSender { get; set; }
        public DateTime EmailDate { get; set; }
        public bool EmailActive { get; set; }
        public bool EmailRead { get; set; }
        public List<String> CarbonCopy { get; set; }
        public String Reference { get; set; }
        public bool EmailStarred { get; set; }

        public Email()
        {

        }

        public Email(string Subject, string Receipient, string Body)
        {
            this.EmailBody = Body;
            this.ReceipientEmail = Receipient;
            this.EmailSubject = Subject;
        }

        private Email(int SenderID, string EmailID, string Subject, int ReceipientID, string Body, DateTime Date, bool Active, bool Read, bool Starred)
        {
            User user = new User();
            this.EmailID = EmailID;
            this.EmailSender = SenderID;
            this.EmailBody = Body;
            this.ReceipientEmail = user.getUserEmail(ReceipientID);
            this.EmailSubject = Subject;
            this.EmailDate = Date;
            this.EmailActive = Active;
            this.EmailRead = Read;
            this.EmailStarred = Starred;
        }

        private Email(int SenderID, string EmailID, string Subject, int ReceipientID, string Body, DateTime Date, bool Active, bool Read, string CarbonCopy, string Reference)
        {
            User user = new User();
            this.EmailID = EmailID;
            this.EmailSender = SenderID;
            this.EmailBody = Body;
            this.ReceipientEmail = user.getUserEmail(ReceipientID);
            this.EmailSubject = Subject;
            this.EmailDate = Date;
            this.EmailActive = Active;
            this.EmailRead = Read;
            this.Reference = Reference;
            this.CarbonCopy = !string.IsNullOrEmpty(CarbonCopy)? CarbonCopy.Split(',').ToList<String>():null;
        }

        public string SendEmail()
        {
            SqlConnection connection = new SqlConnection(connectionString);
            User user = new User();
            int currentUserID = int.Parse(HttpContext.Current.Session["UserID"].ToString());
            if (!string.IsNullOrEmpty(HttpContext.Current.Session["UserID"].ToString()))
                if (user.EmailValidator(ReceipientEmail))
                {
                    try
                    {
                        int senderID = user.getUserID(ReceipientEmail);
                        connection.Open();
                        string command = "INSERT INTO [Emails] (EmailID, [SenderID], [ReceiverID], [Email], [Read], [Date], [Active], [Subject], [Starred] ) VALUES (@EmailID, @SenderID, @ReceiverID, @Email, @Read, @Date, @Active, @Subject, @Starred) ";
                        SqlCommand cmd = new SqlCommand(command, connection);
                        cmd.Parameters.AddWithValue("@EmailID", GenerateEmailID(32));
                        cmd.Parameters.AddWithValue("@SenderID", currentUserID);
                        cmd.Parameters.AddWithValue("@ReceiverID", senderID);
                        cmd.Parameters.AddWithValue("@Email", Additional.RemoveSpecialCharacters(EmailBody));
                        cmd.Parameters.AddWithValue("@Subject", Additional.RemoveSpecialCharacters(EmailSubject));
                        cmd.Parameters.AddWithValue("@Date", DateTime.Now);
                        cmd.Parameters.AddWithValue("@Active", true);
                        cmd.Parameters.AddWithValue("@Read", false);
                        cmd.Parameters.AddWithValue("@Starred", false);
                        cmd.ExecuteNonQuery();
                        return "Success";
                    }
                    catch (SqlException ex)
                    {
                        user.LogError(ex.Message);
                    }
                    finally
                    {
                        connection.Close();
                    }
                }
                else
                    return "Receipient Email not found";
            else
                return "Insufficient permissions to send email";

            return "An error occurred";
        }

        public string GenerateEmailID(int length)
        {
            string alphabets = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            string small_alphabets = "abcdefghijklmnopqrstuvwxyz";
            string numbers = "1234567890";

            string characters = numbers;
            characters += alphabets + small_alphabets + numbers;

            string id = string.Empty;
            for (int i = 0; i < length; i++)
            {
                string character = string.Empty;
                do
                {
                    int index = new Random().Next(0, characters.Length);
                    character = characters.ToCharArray()[index].ToString();
                } while (id.IndexOf(character) != -1);
                id += character;
            }

            return id;
        }

        public List<Email> GetEmailList(int index = 1)
        {
            List<Email> list = new List<Email>();
            IDictionary<int, string> filters = new Dictionary<int, string>() {
                { 1, "AND [Active] = 1 ORDER BY Date DESC" },
                { 2, "AND [Active] = 1 AND [Read] = 0 ORDER BY [Date] DESC" },
                { 3, "AND [Active] = 1 ORDER BY [Date] ASC" },
                { 4, "AND [Active] = 1 AND [Starred] = 1" },
        };

            User user = new User();
            SqlConnection connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                string comm = $"SELECT TOP 20 * FROM Emails WHERE ReceiverID = @Receiver {filters[index]}";
                SqlCommand command = new SqlCommand(comm, connection);
                command.Parameters.AddWithValue("@Receiver", int.Parse(HttpContext.Current.Session["UserID"].ToString()));
                // command.Parameters.AddWithValue("@Limit", 20);
                SqlDataReader reader = command.ExecuteReader(); ;

                if (reader.HasRows)
                    while (reader.Read())
                    {
                        list.Add(new Email(EmailID: reader[0].ToString(),
                                           SenderID: int.Parse(reader[1].ToString()),
                                           ReceipientID: int.Parse(reader[2].ToString()),
                                           Body: reader[3].ToString(),
                                           Read: Boolean.Parse(reader[4].ToString()),
                                           Date: DateTime.Parse(reader[5].ToString()),
                                           Active: Boolean.Parse(reader[6].ToString()),
                                           Subject: reader[7].ToString(),
                                           Starred: Boolean.Parse(reader[10].ToString())
                                          )
                                );
                    }
            }
            catch (SqlException ex)
            {
                user.LogError(ex.Message);
            }
            finally
            {
                connection.Close();
            }
            return list;
        }

        public static void GetEmailInformation(string EmailID, int ViewerID, out Email email)
        {
            User user = new User();
            email = null;
            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString);
            try
            {
                connection.Open();
                string comm = "SELECT TOP 1 * FROM Emails WHERE (EmailID = @EmailID AND ReceiverID = @Receiver) AND Active = 1";
                SqlCommand command = new SqlCommand(comm, connection);
                command.Parameters.AddWithValue("@EmailID", EmailID);
                command.Parameters.AddWithValue("@Receiver", ViewerID);
                //command.Parameters.AddWithValue("@Limit", 20);
                SqlDataReader reader = command.ExecuteReader(); ;

                if (reader.HasRows)
                    while (reader.Read())
                    {
                        email = new Email(EmailID: reader[0].ToString(),
                                           SenderID: int.Parse(reader[1].ToString()),
                                           ReceipientID: int.Parse(reader[2].ToString()),
                                           Body: reader[3].ToString(),
                                           Read: Boolean.Parse(reader[4].ToString()),
                                           Date: DateTime.Parse(reader[5].ToString()),
                                           Active: Boolean.Parse(reader[6].ToString()),
                                           Subject: reader[7].ToString(),
                                           Starred: Boolean.Parse(reader[10].ToString())
                                        );
                    }
            }
            catch (SqlException ex)
            {
                user.LogError(ex.Message);
            }
            finally
            {
                connection.Close();
            }
        }

        public static void SetAsRead(String EmailID, out string status)
        {
            status = "Default";
            SqlConnection connect = new SqlConnection(ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString);
            int currentLoggedIn = int.Parse(HttpContext.Current.Session["UserID"].ToString());
            Email temp;
            User user = new User();
            GetEmailInformation(EmailID, currentLoggedIn,out temp);
            if (temp != null)
            {
                try
                {
                    connect.Open();
                    string commStr = "UPDATE [Emails] SET [Read] = 1 WHERE EmailID = @EmailID";
                    SqlCommand command = new SqlCommand(commStr, connect);
                    command.Parameters.AddWithValue("@EmailID", EmailID);
                    command.ExecuteNonQuery();
                    status = "Success";
    
                }catch(SqlException ex)
                {
                    user.LogError(ex.Message);
                    status = $"Error, {ex.Message}";
                }
                finally { connect.Close(); }
            }
        }
        
        public static void SetStarEmail(String EmailID, out string status)
        {
            status = "Default";
            SqlConnection connect = new SqlConnection(ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString);
            int currentLoggedIn = int.Parse(HttpContext.Current.Session["UserID"].ToString());
            Email temp;
            User user = new User();
            GetEmailInformation(EmailID, currentLoggedIn,out temp);
            
            if (temp != null)
            {
                try
                {
                    connect.Open();
                    string commStr = "UPDATE [Emails] SET [Starred] = @Starred WHERE EmailID = @EmailID";
                    SqlCommand command = new SqlCommand(commStr, connect);
                    command.Parameters.AddWithValue("@EmailID", EmailID);
                    command.Parameters.AddWithValue("@Starred", !temp.EmailStarred);
                    command.ExecuteNonQuery();
                    status = "Success";
    
                }catch(SqlException ex)
                {
                    user.LogError(ex.Message);
                    status = $"Error, {ex.Message}";
                }
                finally { connect.Close(); }
            }
        }

    }
}