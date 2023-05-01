using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Threading;
using System.Web;
using System.Web.SessionState;

namespace Inboxd.Source.Private
{
    public class User
    {
        SqlConnection connection;


        public string Name { get; set; }
        public string Surname { get; set; }
        public string Password { get; set; }
        public string Email { get; set; }
        public int UserID { get; set; }
        public int InboxdID { get; set; }
        public DateTime DOB { get; set; }
        private string connectionString = ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString;
        List<string> errors = new List<string>();
        private static readonly RNGCryptoServiceProvider random = new RNGCryptoServiceProvider();

        public User()
        {

        }

        public User(string Email, string Password)
        {
            this.Email = Email;
            this.Password = Password;
        }
        public User(string Name, string Surname, string Email)
        {
            this.Email = Email;
            this.Name = Name;
            this.Surname = Surname;
            this.UserID = getUserID(Email);
        }
        public User(string Name, string Surname, string Email, DateTime DOB)
        {
            this.Email = Email;
            this.Name = Name;
            this.Surname = Surname;
            this.DOB = DOB;
        }

        public User(int UserID)
        {
            this.UserID = UserID;

            connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                SqlCommand command = new SqlCommand("SELECT Email, Name, Surname, DOB FROM UserDetails WHERE UserID = @UserID");
                command.Parameters.AddWithValue("@UserID", UserID);
                SqlDataReader reader = command.ExecuteReader();

                if(reader != null)
                    while(reader.Read())
                    {

                    }    

            }catch(Exception ex)
            {
                LogError(ex.Message);
            }
            finally
            {
                connection.Close();
            }
            this.Email = Email;
            this.Name = Name;
            this.Surname = Surname;
            this.DOB = DOB;
        }

        public int calcAge(DateTime birthdate)
        {
            int age = 0;
            age = birthdate.CompareTo(DateTime.Now);
            return age;
        }

        public bool EmailValidator(string email)
        {
            connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                SqlCommand command = new SqlCommand($"SELECT COUNT(UserID) FROM UserDetails WHERE Email = @Email", connection);
                command.Parameters.AddWithValue("@Email", email);
                int validity = ((int)command.ExecuteScalar());

                if (validity != 0)
                    return true;
            }
            catch (Exception e)
            {
                LogError(e.Message);
            }
            finally
            {
                connection.Close();
            }
            return false;
        }
        public bool Login()
        {
            connection = new SqlConnection(connectionString);
            try
            {
                if (EmailValidator(Email))
                {
                    connection.Open();

                    SqlCommand login = new SqlCommand($"SELECT Password FROM UserDetails, Users WHERE (UserDetails.Email = @Email) AND (UserDetails.UserID = Users.UserID)", connection);
                    login.Parameters.AddWithValue("@Email", Email);
                    SqlDataReader reader = login.ExecuteReader();

                    string dbPassword = "";

                    if (reader != null)
                        while (reader.Read())
                            dbPassword = reader.GetString(0);

                    if (Hasher.ValidatePassword(Password, dbPassword))
                    {
                        UserID = getUserID(Email);
                        return true;
                    }
                    
                }
            }
            catch (SqlException ex)
            {
                LogError(ex.Message);
            }
            finally
            {
                connection.Close();
            }


            return false;
        }

        public int getUserID(string Email)
        {
            connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                SqlCommand command = new SqlCommand("SELECT UserID FROM [UserDetails] WHERE Email = @Email", connection);
                command.Parameters.AddWithValue("@Email", Email);
                int value = (int)command.ExecuteScalar();
                if (value != 0)
                    return value;
            }
            catch (SqlException ex)
            {
                LogError(ex.Message);
            }
            finally
            {
                connection.Close();
            }
            return 0;
        }

        public string getUserEmail(int UserID)
        {
            connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                SqlCommand command = new SqlCommand("SELECT Email FROM [UserDetails] WHERE UserID = @UserID", connection);
                command.Parameters.AddWithValue("@UserID", UserID);
                string value = command.ExecuteScalar().ToString();
                if (!string.IsNullOrEmpty(value))
                    return value;
            }
            catch (SqlException ex)
            {
                LogError(ex.Message);
            }
            finally
            {
                connection.Close();
            }
            return null;
        }

        public void UserAssign()
        {
            try
            {
                HttpContext.Current.Session["UserID"] = UserID;
                Inbox temp = new Inbox();
                temp.loggedInUser = new User(UserID: this.UserID);
            }
            catch (Exception ex)
            {
                LogError(ex.Message);
            }
        }

        public void LogError(string error)
        {
            connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                SqlCommand command = new SqlCommand("INSERT INTO [Errors](ErrorMessage, Date) VALUES (@Message, @Date)", connection);
                command.Parameters.AddWithValue("@Message", error );
                command.Parameters.AddWithValue("@Date", DateTime.Now);
                command.ExecuteNonQuery();
            }
            catch(SqlException ex)
            {
                errors.Add(ex.Message);
            }
            finally
            {
                connection.Close();
            }
        }

        public string CreateUser()
        {
            connection = new SqlConnection(connectionString);
            UserID = int.Parse(GenerateUniqueID(10));
            
            try
            {
                connection.Open();

                string UserCommand = "INSERT INTO Users VALUES(@UserID, @Password)";
                SqlCommand command_User = new SqlCommand(UserCommand, connection);
                command_User.Parameters.AddWithValue("@UserID", UserID);
                command_User.Parameters.AddWithValue("@Password", Hasher.CreateHash(Password));
                command_User.ExecuteNonQuery();

                string UserDetailCommand = "INSERT INTO UserDetails(Email, Name, Surname, UserID, DOB) VALUES (@Email, @Name, @Surname, @UserID, @DOB)";
                SqlCommand command_UserDetails = new SqlCommand(UserDetailCommand, connection);
                command_UserDetails.Parameters.AddWithValue("@Email", Email);
                command_UserDetails.Parameters.AddWithValue("@Name", Name);
                command_UserDetails.Parameters.AddWithValue("@Surname", Name);
                command_UserDetails.Parameters.AddWithValue("@DOB", DOB);
                command_UserDetails.Parameters.AddWithValue("@UserID", UserID);
                command_UserDetails.ExecuteNonQuery();
            }
            catch(SqlException ex)
            {
                LogError(ex.Message);
            }
            finally
            {
                connection.Close();
            }

            return "Success";
        }

        private string GenerateUniqueID(int length)
        {
            int sufficientBufferSizeInBytes = (length * 6 + 7) / 8;

            var buffer = new byte[sufficientBufferSizeInBytes];
            random.GetBytes(buffer);
            return Convert.ToBase64String(buffer).Substring(0, length);
        }

        public int getEmailsCount()
        {
            int count = 0;
            connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                SqlCommand command = new SqlCommand("SELECT COUNT(*) FROM [Emails] WHERE ReceiverID = @Receiver ", connection);
                command.Parameters.AddWithValue("@Receiver", HttpContext.Current.Session["UserID"].ToString());
                count = int.Parse(command.ExecuteScalar().ToString());
            }
            catch(SqlException ex)
            {
                LogError(ex.Message);
            }
            finally
            {
                connection.Close();
            }

            return count;
        }

        public User GetUserInfo(int UserID)
        {
            User temp = new User();
            connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                SqlCommand command = new SqlCommand("SELECT TOP 1 * FROM UserDetails WHERE UserID = @UserID LIMIT 1", connection);
                command.Parameters.AddWithValue("@UserID", UserID);
                SqlDataReader reader = command.ExecuteReader();

                if(reader.HasRows)
                    while(reader.Read())
                    {
                        InboxdID = int.Parse(reader.GetValue(0).ToString());
                        Email = reader.GetValue(1).ToString();
                        Name = reader.GetValue(2).ToString();
                        Surname = reader.GetValue(3).ToString();
                        int tempID = int.Parse(reader.GetValue(4).ToString());
                        DOB = DateTime.Parse(reader.GetValue(5).ToString());
                    }
            }
            catch(SqlException ex)
            {
                LogError(ex.Message);
            }
            finally
            {
                connection.Close();
            }

            return temp;

        }

        public static string GetFullName(int UserID)
        {
            string connStr = ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString;
            SqlConnection conn = new SqlConnection(connStr);
            string fullName = "Test Name";
            User user = new User();
            try
            {
                conn.Open();
                string comm = "SELECT TOP 1 Name, Surname FROM [UserDetails] WHERE UserID = @UserID";
                SqlCommand command = new SqlCommand(comm, conn);
                command.Parameters.AddWithValue("@UserID", UserID);
                SqlDataReader reader = command.ExecuteReader();

                if (reader.HasRows)
                    while(reader.Read())
                        fullName = String.Format("{0:S} {1:S}", reader.GetValue(0).ToString(), reader.GetValue(1).ToString());
                
            }
            catch(Exception ex)
            {
                user.LogError(ex.Message);
            }

            finally 
            {
                conn.Close();
            }

            return fullName;
        }
    }
}