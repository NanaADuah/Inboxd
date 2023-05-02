using Inboxd.Source.Private;
using Microsoft.Win32.SafeHandles;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Net.Mail;
using System.Runtime.InteropServices;
using System.Text;
using System.Web;
using System.Xml.Linq;

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
        public bool EmailSpam { get; set; }

        public Email()
        {

        }

        public Email(string Subject, string Receipient, string Body)
        {
            this.EmailBody = Body;
            this.ReceipientEmail = Receipient;
            this.EmailSubject = Subject;
        }

        private Email(int SenderID, string EmailID, string Subject, int ReceipientID, string Body, DateTime Date, bool Active, bool Read, bool Starred, bool Spam)
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
            this.EmailSpam = Spam;
        }

        private Email(int SenderID, string EmailID, string Subject, int ReceipientID, string Body, DateTime Date, bool Active, bool Read, string CarbonCopy, string Reference, bool Spam)
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
            this.CarbonCopy = !string.IsNullOrEmpty(CarbonCopy) ? CarbonCopy.Split(',').ToList<String>() : null;
            this.EmailSpam = Spam;
        }
        private Email(int SenderID, string EmailID, string Subject, int ReceipientID, string Body, DateTime Date, string Reference)
        {
            User user = new User();
            this.EmailID = EmailID;
            this.EmailSender = SenderID;
            this.EmailBody = Body;
            this.ReceipientEmail = user.getUserEmail(ReceipientID);
            this.EmailSubject = Subject;
            this.EmailDate = Date;
            this.Reference = Reference;
        }

        public Email(string EmailBody, string ReceipientEmail, string EmailSubject, string EmailReference)
        {
            this.EmailBody = EmailBody;
            this.ReceipientEmail = ReceipientEmail;
            this.EmailSubject = EmailSubject;
            this.Reference = EmailReference;
        }

        public string SendEmail()
        {
            SqlConnection connection = new SqlConnection(connectionString);
            User user = new User();
            int currentUserID = int.Parse(HttpContext.Current.Session["UserID"].ToString());
            if (HttpContext.Current.Session["UserID"] != null)
                if (user.EmailValidator(ReceipientEmail))
                {
                    try
                    {
                        int senderID = user.getUserID(ReceipientEmail);
                        connection.Open();
                        string command = "INSERT INTO [Emails] (EmailID, [SenderID], [ReceiverID], [Email], [Read], [Date], [Active], [Subject], [Starred], [Spam] ) VALUES (@EmailID, @SenderID, @ReceiverID, @Email, @Read, @Date, @Active, @Subject, @Starred, @Spam) ";
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
                        cmd.Parameters.AddWithValue("@Spam", false);
                        cmd.ExecuteNonQuery();
                        return "Success";
                    }
                    catch (SqlException ex)
                    {
                        User.LogError(ex.Message);
                    }
                    finally
                    {
                        connection.Close();
                    }
                }
                else
                    return "Receipient email not found";
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

        public static void DeleteDraft(string EmailID)
        {
            SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString);
            Email temp;
            int currentLoggedIn = int.Parse(HttpContext.Current.Session["UserID"].ToString());
            GetEmailInformation(EmailID, currentLoggedIn, out temp);
            try
            {
                connection.Open();
                string commStr = "DELETE FROM [Drafts] WHERE EmailID = @EmailID AND SenderID = @SenderID";
                SqlCommand command = new SqlCommand(commStr, connection);
                command.Parameters.AddWithValue("@EmailID", EmailID);
                command.Parameters.AddWithValue("@SenderID", currentLoggedIn);
                command.ExecuteNonQuery();
            }
            catch
            {


            }
            finally
            {
                connection.Close();
            }
        }

        public List<Email> GetEmailList(int index = 1)
        {
            List<Email> list = new List<Email>();
            IDictionary<int, string> filters = new Dictionary<int, string>() {
                { 1, "WHERE ReceiverID = @Receiver AND [Active] = 1 AND [Spam] = 0 ORDER BY Date DESC" },
                { 2, "WHERE ReceiverID = @Receiver AND [Active] = 1 AND [Spam] = 0 AND [Read] = 0 ORDER BY [Date] DESC" },
                { 3, "WHERE ReceiverID = @Receiver AND [Active] = 1 AND [Spam] = 0 ORDER BY [Date] ASC" },
                { 4, "WHERE ReceiverID = @Receiver AND [Active] = 1 AND [Spam] = 0 AND [Starred] = 1" },
                { 5, "WHERE   SenderID = @Receiver AND [Active] = 1" }, //even though it doesn't make sense, it works so leave it
                { 6, "WHERE ReceiverID = @Receiver AND [Active] = 1 AND [Spam] = 1" },
        };

            SqlConnection connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                string comm = $"SELECT TOP 20 * FROM Emails {filters[index]}";
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
                                           Starred: Boolean.Parse(reader[10].ToString()),
                                           Spam: Boolean.Parse(reader[11].ToString())
                                          )
                                );
                    }
            }
            catch (SqlException ex)
            {
                User.LogError(ex.Message);
            }
            finally
            {
                connection.Close();
            }
            return list;
        }

        public List<Email> GetDraftList()
        {
            List<Email> list = new List<Email>();
            User user = new User();
            SqlConnection connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                string comm = $"SELECT TOP 20 * FROM [Draft] WHERE SenderID = @UserID";
                SqlCommand command = new SqlCommand(comm, connection);
                command.Parameters.AddWithValue("@UserID", int.Parse(HttpContext.Current.Session["UserID"].ToString()));
                SqlDataReader reader = command.ExecuteReader();

                if (reader.HasRows)
                    while (reader.Read())
                    {

                        list.Add(new Email(EmailID: reader[0].ToString(),
                                           SenderID: int.Parse(reader[1].ToString()),
                                           ReceipientID: int.Parse(reader[2].ToString()),
                                           Body: reader[3].ToString(),
                                           Date: DateTime.Parse(reader[4].ToString()),
                                           Subject: reader[5].ToString(),
                                           Reference: reader[6].ToString()
                                          )
                                );
                    }
            }
            catch (SqlException ex)
            {
                User.LogError(ex.Message);
            }
            finally
            {
                connection.Close();
            }
            return list;
        }


        public void SaveDraft(Email email, out string results)
        {
            results = "";
            User user = new User();
            SqlConnection connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                string commstr = "INSERT INTO [Draft](EmailID, SenderID, ReceiverID, Email, Date, Subject, Ref) VALUES (@EmailID, @SenderID, @ReceiverID, @Email, @Date, @Subject, @Reference)";
                SqlCommand command = new SqlCommand(commstr, connection );
                command.Parameters.AddWithValue("@EmailID", GenerateEmailID(32));
                command.Parameters.AddWithValue("@SenderID", int.Parse(HttpContext.Current.Session["UserID"].ToString()));
                command.Parameters.AddWithValue("@ReceiverID", user.getUserID(email.ReceipientEmail));
                command.Parameters.AddWithValue("@Email", Additional.RemoveSpecialCharacters(email.EmailBody));
                command.Parameters.AddWithValue("@Date", DateTime.Now);
                command.Parameters.AddWithValue("@Subject", Additional.RemoveSpecialCharacters(email.EmailSubject));
                command.Parameters.AddWithValue("@Reference", email.Reference);

                command.ExecuteNonQuery();
                results = "success";
            }
            catch(SqlException ex)
            {
                User.LogError(ex.Message);
            }
            finally
            {
                connection.Close();
            }
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
                                           Starred: Boolean.Parse(reader[10].ToString()),
                                           Spam: Boolean.Parse(reader[11].ToString())
                                        );
                    }
            }
            catch (SqlException ex)
            {
                User.LogError(ex.Message);
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
                    User.LogError(ex.Message);
                    status = $"Error, {ex.Message}";
                }
                finally { connect.Close(); }
            }
        }
        
        public static void SetAsSpam(String EmailID, out string status)
        {
            status = "Default";
            SqlConnection connect = new SqlConnection(ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString);
            int currentLoggedIn = int.Parse(HttpContext.Current.Session["UserID"].ToString());
            Email temp;
            GetEmailInformation(EmailID, currentLoggedIn,out temp);
            if (temp != null)
            {
                try
                {
                    connect.Open();
                    string commStr = "UPDATE [Emails] SET [Spam] = @Value WHERE EmailID = @EmailID";
                    SqlCommand command = new SqlCommand(commStr, connect);
                    command.Parameters.AddWithValue("@EmailID", EmailID);
                    command.Parameters.AddWithValue("@Value", !temp.EmailSpam);
                    command.ExecuteNonQuery();
                    status = "Success";
    
                }catch(SqlException ex)
                {
                    User.LogError(ex.Message);
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
                    User.LogError(ex.Message);
                    status = $"Error, {ex.Message}";
                }
                finally { connect.Close(); }
            }
        }

    }
}