using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Diagnostics.Eventing.Reader;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Threading;
using System.Web;
using System.Web.Management;
using System.IO;
using System.Web.SessionState;
using System.Drawing.Imaging;
using System.Drawing;

namespace Inboxd.Source.Private
{
    public class User
    {
        SqlConnection connection;


        public string Name { get; set; }
        public string Surname { get; set; }
        public string Email { get; set; }
        private string Password { get; set; }
        public int UserID { get; set; }
        public int InboxdID { get; set; }
        public DateTime DOB { get; set; }
        private string connectionString = ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString;
        public List<string> errors = new List<string>();
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
        
        public User(string Name, string Surname, string Email, DateTime DOB, string Password)
        {
            this.Email = Email;
            this.Name = Name;
            this.Surname = Surname;
            this.DOB = DOB;
            this.Password = Password;
        }

        public User(int UserID)
        {
            this.UserID = UserID;

            connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                SqlCommand command = new SqlCommand("SELECT Email, Name, Surname, DOB FROM UserDetails WHERE UserID = @UserID", connection);
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

        public static User GetUserInfo(int UserID)
        {
            SqlConnection connect = new SqlConnection(ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString);
            User user = null;

            try
            {
                connect.Open();
                string commStr = "SELECT TOP 1 * FROM [UserDetails] WHERE [UserID] = @UserID";
                SqlCommand command = new SqlCommand(commStr, connect);
                command.Parameters.AddWithValue("@UserID", UserID);
                SqlDataReader reader = command.ExecuteReader();
                if(reader.HasRows)
                    while(reader.Read())
                    {
                        DateTime tempDate;
                        DateTime.TryParse(reader[5].ToString(), out tempDate);
                        user = new User
                        {
                            InboxdID =  int.Parse(reader[0].ToString()),
                            Email = reader[1].ToString(),
                            Name = reader[2].ToString(),
                            Surname = reader[3].ToString(),
                            UserID = int.Parse(reader[4].ToString()),
                            DOB = tempDate,
                        };
                    }
            }

            catch(Exception ex)
            {
                User.LogError(ex.Message);
            }
            finally
            {
                connect.Close();
            }
            return user;
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
                        Additional.LogActivity("Login", UserID);
                        if (!UserHasFolder(UserID))
                            CreateUserFolder(UserID);
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

        public static void LogError(string error)
        {
            SqlConnection connect = new SqlConnection(ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString);
            try
            {
                connect.Open();
                SqlCommand command = new SqlCommand("INSERT INTO [Errors](ErrorMessage, Date) VALUES (@Message, @Date)", connect);
                command.Parameters.AddWithValue("@Message", error );
                command.Parameters.AddWithValue("@Date", DateTime.Now);
                command.ExecuteNonQuery();
            }
            catch
            {
                //Changed function to static method so I need to replace whatever use to be here
            }
            finally
            {
                connect .Close();
            }
        }

        public string CreateUser()
        {
            connection = new SqlConnection(connectionString);
            UserID = int.Parse(GenerateUniqueID(10).ToString());
            Email email = new Email();
            
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
                command_UserDetails.Parameters.AddWithValue("@Surname", Surname);
                command_UserDetails.Parameters.AddWithValue("@DOB", DOB);
                command_UserDetails.Parameters.AddWithValue("@UserID", UserID);
                command_UserDetails.ExecuteNonQuery();
                email.SendWelcomeEmail(UserID);
                Additional.LogActivity("Create Account",UserID);
                CreateUserFolder(UserID);
                return "success";
            }
            catch(SqlException ex)
            {
                LogError(ex.Message);
            }
            finally
            {
                connection.Close();
            }

            return "failed";
        }

        public bool UploadUserData(int UserID)
        {
            try
            {
                return true;
            }
            catch (Exception ex)
            {
                LogError(ex.Message);
            }
            return false;
        }

        public bool UserHasFolder(int UserID)
        {
            string strFolder = HttpContext.Current.Server.MapPath($"~/Source/Public/User/{UserID}");
            if (Directory.Exists(strFolder))
                return true;

            return false;
        }

        public void CreateUserFolder(int UserID)
        {
            string strFileName;
            string strFilePath;
            string strFolder;

            strFolder = HttpContext.Current.Server.MapPath($"~/Source/Public/User/{UserID}");
            try
            {
                if (!Directory.Exists(strFolder))
                {
                    Directory.CreateDirectory(String.Format("{0}",strFolder));
                    Directory.CreateDirectory(String.Format("{0}/Attachments",strFolder));
                    Directory.CreateDirectory(String.Format("{0}/Emails",strFolder));
                }
            }
            catch(Exception ex)
            {
                LogError(ex.Message);
            }
            
        }

        public static int GenerateUniqueID(int length)
        {
            // Generate a new GUID
            Guid guid = Guid.NewGuid();

            // Convert the GUID to a byte array
            byte[] bytes = guid.ToByteArray();

            // Compute the hash code of the byte array
            int hashCode = BitConverter.ToInt32(bytes, 0);

            // Truncate the hash code to the specified length
            int uniqueInt = Math.Abs(hashCode) % (int)Math.Pow(10, length);

            return uniqueInt;
        }

        /*
         * Obselete
         * private string GenerateUniqueID(int length)
        {
            int sufficientBufferSizeInBytes = (length * 6 + 7) / 8;

            var buffer = new byte[sufficientBufferSizeInBytes];
            random.GetBytes(buffer);
            return Convert.ToBase64String(buffer).Substring(0, length);
        }*/

        public int GetEmailsCount(bool incSpam = false)
        {
            int count = 0;
            connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                SqlCommand command = new SqlCommand($"SELECT COUNT(*) FROM [Emails] WHERE ReceiverID = @Receiver AND [Spam] = 0 AND [Read] = 0", connection);
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
        
        public int GetDraftCount()
        {
            int count = 0;
            connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                SqlCommand command = new SqlCommand("SELECT COUNT(*) FROM [Draft] WHERE SenderID = @Sender ", connection);
                command.Parameters.AddWithValue("@Sender", HttpContext.Current.Session["UserID"].ToString());
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

        public static string GetFullName(int UserID)
        {
            string connStr = ConfigurationManager.ConnectionStrings["connectionString"].ConnectionString;
            SqlConnection conn = new SqlConnection(connStr);
            string fullName = "";
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
                User.LogError(ex.Message);
            }

            finally 
            {
                conn.Close();
            }

            return UserID == 1 ?"Inboxd Corporate": fullName;
        }
        
        public string FullNameDisplay(int UserID)
        {
            SqlConnection conn = new SqlConnection(connectionString);
            string fullName = "";
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
                User.LogError(ex.Message);
            }

            finally 
            {
                conn.Close();
            }

            return UserID == 1 ?"Inboxd Corporate": Additional.ToUpperEveryWord(fullName);
        }

        public List<int> GetFavourites(int UserID)
        {
            List<int> list = new List<int>();
            SqlConnection conn = new SqlConnection(connectionString);

            try
            {
                conn.Open();
                string comm = "SELECT TOP 1 [FavouriteList] FROM [Favourites] WHERE UserID = @UserID";
                SqlCommand command = new SqlCommand(comm, conn);
                command.Parameters.AddWithValue("@UserID", UserID);
                SqlDataReader reader = command.ExecuteReader();

                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        string output = reader[0].ToString();
                        list = JsonConvert.DeserializeObject<List<int>>(output);
                    }
                }
            }
            catch (Exception ex)
            {
                User.LogError(ex.Message);
            }

            finally
            {
                conn.Close();
            }

            return list.Distinct().ToList();
        }

        public bool isUserFavourite(int UserID)
        {
            List<int> users;
            users = GetFavourites(int.Parse(HttpContext.Current.Session["UserID"].ToString()));

            if (users.Contains(UserID))
                return true;

            return false;
            
        }
        
        public bool HasFavourite(int UserID)
        {
            connection = new SqlConnection(connectionString);
            try
            {
                connection.Open();
                SqlCommand command = new SqlCommand("SELECT COUNT(UserID) FROM [Favourites] WHERE UserID = @UserID", connection);
                command.Parameters.AddWithValue("@UserID", UserID);
                int value = int.Parse(command.ExecuteScalar().ToString());

                if (value != 0)
                    return true;
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

        public string AddAsFavourite(int UserID)
        {
            connection = new SqlConnection(connectionString);
            Notifications notif = new Notifications();
            string notifResults = "";
            string updateQuery = "";
            try
            {
                List<int> valuesToSave = GetFavourites(int.Parse(HttpContext.Current.Session["UserID"].ToString()));
                valuesToSave.Add(UserID);

                string updatedJsonString = JsonConvert.SerializeObject(valuesToSave);

                if (!HasFavourite(int.Parse(HttpContext.Current.Session["UserID"].ToString())))
                    updateQuery = $"INSERT INTO [Favourites]([UserID], [FavouriteList]) VALUES (@UserID, @favourites)";
                else
                    updateQuery = $"UPDATE [Favourites] SET [FavouriteList] = @favourites WHERE [UserID] = @UserID";


                connection.Open();
                SqlCommand command = new SqlCommand(updateQuery, connection);
                command.Parameters.AddWithValue("@favourites", updatedJsonString);
                command.Parameters.AddWithValue("@UserID", int.Parse(HttpContext.Current.Session["UserID"].ToString()));
                command.ExecuteNonQuery();
                notif.SendNotification(UserID,String.Format("{0:S} added you as their favourite", GetFullName(int.Parse(HttpContext.Current.Session["UserID"].ToString()))), out notifResults);
                notif.SendNotification(int.Parse(HttpContext.Current.Session["UserID"].ToString()),String.Format("You added {0:S} as a favourite", GetFullName(UserID)), out notifResults);
                return "success";
            }
            catch (SqlException ex)
            {
                LogError(ex.Message);
            }
            finally
            {
                connection.Close();
            }

            return "failure";
        }
        
        public string RemoveAsFavourite(int UserID)
        {
            connection = new SqlConnection(connectionString);
            Notifications notif = new Notifications();
            string notifResults = "";
            string updateQuery = "";
            try
            {
                List<int> valuesToSave = GetFavourites(int.Parse(HttpContext.Current.Session["UserID"].ToString()));
                valuesToSave.Remove(UserID);

                string updatedJsonString = JsonConvert.SerializeObject(valuesToSave);

                if (!HasFavourite(int.Parse(HttpContext.Current.Session["UserID"].ToString())))
                    updateQuery = $"INSERT INTO [Favourites]([UserID], [FavouriteList]) VALUES (@UserID, @favourites)";
                else
                    updateQuery = $"UPDATE [Favourites] SET [FavouriteList] = @favourites WHERE [UserID] = @UserID";


                connection.Open();
                SqlCommand command = new SqlCommand(updateQuery, connection);
                command.Parameters.AddWithValue("@favourites", updatedJsonString);
                command.Parameters.AddWithValue("@UserID", int.Parse(HttpContext.Current.Session["UserID"].ToString()));
                command.ExecuteNonQuery();
                notif.SendNotification(UserID,String.Format("{0:S} removed you as their favourite", GetFullName(int.Parse(HttpContext.Current.Session["UserID"].ToString()))), out notifResults);
                notif.SendNotification(int.Parse(HttpContext.Current.Session["UserID"].ToString()),String.Format("You removed {0:S} as a favourite", GetFullName(UserID)), out notifResults);
                return "success";
            }
            catch (SqlException ex)
            {
                LogError(ex.Message);
            }
            finally
            {
                connection.Close();
            }

            return "failure";
        }

        public string GetProfileImageLink(int UserID)
        {
            return HttpContext.Current.Server.MapPath($"~/Source/Public/User/{UserID}/{UserID}.jpg");
        }
        public bool UserHasProfileImage(int UserID, string extension = "jpg")
        {
            try
            {
                string file = HttpContext.Current.Server.MapPath($"~/Source/Public/User/{UserID}/{UserID}.{extension}");
                if (File.Exists(file))
                    return true;
            }
            catch (Exception ex)
            {
                LogError(ex.Message);
            }

            return false;
        }

        public void SaveProfileImage(int userID, string imagePath)
        {
            string strFolder = HttpContext.Current.Server.MapPath($"~/Source/Public/User/{userID}");
            if (HttpContext.Current.Session["UserID"].ToString() != null)
            {
                // Load the image from the specified file path
                Image originalImage = Image.FromFile(imagePath);
                string uploadDirectory = String.Format("", strFolder);

                // Check if the image size is larger than 5MB
                if (new FileInfo(imagePath).Length > 5 * 1024 * 1024)
                {
                    // Compress the image until its file size is smaller than 5MB
                    ImageCodecInfo jpgEncoder = GetEncoder(ImageFormat.Jpeg);
                    EncoderParameters encoderParams = new EncoderParameters(1);
                    encoderParams.Param[0] = new EncoderParameter(Encoder.Quality, 80L);
                    using (MemoryStream ms = new MemoryStream())
                    {
                        originalImage.Save(ms, jpgEncoder, encoderParams);
                        while (ms.Length > 5 * 1024 * 1024)
                        {
                            encoderParams.Param[0] = new EncoderParameter(Encoder.Quality, long.Parse(encoderParams.Param[0].ToString()) - 5L);
                            ms.SetLength(0);
                            originalImage.Save(ms, jpgEncoder, encoderParams);
                        }
                        originalImage = Image.FromStream(ms);
                    }
                }

                // Calculate the dimensions of the square crop
                int cropSize = Math.Min(originalImage.Width, originalImage.Height);
                int cropX = (originalImage.Width - cropSize) / 2;
                int cropY = (originalImage.Height - cropSize) / 2;

                // Create a new bitmap with the square crop and original size
                Bitmap croppedImage = new Bitmap(originalImage.Width, originalImage.Height);
                using (Graphics g = Graphics.FromImage(croppedImage))
                {
                    g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBicubic;
                    g.DrawImage(originalImage, new Rectangle(0, 0, originalImage.Width, originalImage.Height), cropX, cropY, cropSize, cropSize, GraphicsUnit.Pixel);
                }

                // Save the cropped image as a JPEG file
                string fileName = userID.ToString() + ".jpg";
                string savePath = Path.Combine(uploadDirectory, fileName);
                croppedImage.Save(savePath, ImageFormat.Jpeg);

                // Dispose of the original and cropped images
                originalImage.Dispose();
                croppedImage.Dispose();
            } 
        }

        private static ImageCodecInfo GetEncoder(ImageFormat format)
        {
            ImageCodecInfo[] codecs = ImageCodecInfo.GetImageDecoders();
            foreach (ImageCodecInfo codec in codecs)
            {
                if (codec.FormatID == format.Guid)
                {
                    return codec;
                }
            }
            return null;
        }
    }
}