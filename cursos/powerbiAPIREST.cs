using System;
using System.Net;
//Install-Package Microsoft.IdentityModel.Clients.ActiveDirectory -Version 2.21.301221612
using Microsoft.IdentityModel.Clients.ActiveDirectory;
using System.Text;
//Install-Package Newtonsoft.Json 
using Newtonsoft.Json;
using System.IO;
using System.Web;
using System.Collections.Generic;
using System.Net.Http;
using System.Collections.Specialized;

namespace ConsoleApplication39
{

    class Program
    {

        //Step 1 - Replace {client id} with your client app ID. 
        //To learn how to get a client app ID, see Register a client app (https://msdn.microsoft.com/en-US/library/dn877542.aspx#clientID)
        private static string clientID = "49df1bc7-XXXXX9XXX0d1a4";

        //RedirectUri you used when you registered your app.
        //For a client app, a redirect uri gives AAD more details on the specific application that it will authenticate.
        private static string redirectUri = "https://login.live.com/oauth20_desktop.srf";

        //Resource Uri for Power BI API
        private static string resourceUri = "https://analysis.windows.net/powerbi/api";

        //OAuth2 authority Uri
        private static string authority = "https://login.windows.net/common/oauth2/authorize";

        //the account used to login Power BI
        private static string username = "MYACOUNT";
        private static string password = "MYPASSWD";

        private static AuthenticationContext authContext = null;
        private static string token = String.Empty;

        //The power bi app workspace id(the GUID after /groups/ in below link
        //when viewing a dataset in Power BI Service, the link is like
        //https://msit.powerbi.com/groups/dc581184-XXXXf16b6c15/datasets/1f6285a5-7XXX7b7ae5637d6
        private static string groupId = "dc581184-XXXXX-5432f16b6c15";

        //The target datasetId that is to refresh(the GUID after datesets/ in above link
        private static string datasetId = "1f6285a5XXXXXae5637d6";

        static void Main(string[] args)
        {

            //token = getAccessTokenWithLoginPopUp();
            token = getAccessTokenSilently();
            refreshDataset(groupId, datasetId);

            //wait 5 seconds for the last refresh
            System.Threading.Thread.Sleep(5000);

            getRefreshHistory(groupId, datasetId);

            Console.ReadKey();

        }



        static void getRefreshHistory(string groupId, string datasetId, int lastNRrefresh = 10)
        {

            HttpWebRequest request = System.Net.HttpWebRequest.CreateHttp(String.Format("https://api.powerbi.com/v1.0/myorg/groups/{0}/datasets/{1}/refreshes/?$top={2}", groupId, datasetId,lastNRrefresh));
            //POST web request to create a datasource.
            request.KeepAlive = true;
            request.Method = "GET";
            request.ContentLength = 0;

            //Add token to the request header
            request.Headers.Add("Authorization", String.Format("Bearer {0}", token));

            //Write JSON byte[] into a Stream
            using (var response = (HttpWebResponse)request.GetResponse())
            {
                 
                var responseString = new StreamReader(response.GetResponseStream()).ReadToEnd();
                dynamic responseJson = JsonConvert.DeserializeObject<dynamic>(responseString);
                foreach (var refresh in responseJson.value) {
                    Console.WriteLine("Dataset {0} refreshed is {1}",datasetId,refresh["status"]);
                    Console.WriteLine("starttime at {0} endtime at {1}", refresh["startTime"], refresh["endTime"]);
                    Console.WriteLine("");
                } 
            } 
        }


        static void refreshDataset(string groupId, string datasetId)
        {

            HttpWebRequest request = System.Net.HttpWebRequest.CreateHttp(String.Format("https://api.powerbi.com/v1.0/myorg/groups/{0}/datasets/{1}/refreshes", groupId, datasetId));
            //POST web request to create a datasource.
            request.KeepAlive = true;
            request.Method = "POST";
            request.ContentLength = 0;

            //Add token to the request header
            request.Headers.Add("Authorization", String.Format("Bearer {0}", token));

            //Write JSON byte[] into a Stream
            using (Stream writer = request.GetRequestStream())
            {

                var response = (HttpWebResponse)request.GetResponse();
                Console.WriteLine("Dataset refresh request {0}", response.StatusCode.ToString());
            }


        }

        static string getAccessTokenSilently()
        {

            HttpWebRequest request = System.Net.HttpWebRequest.CreateHttp("https://login.windows.net/common/oauth2/token");
            //POST web request to create a datasource.
            request.KeepAlive = true;
            request.Method = "POST";
            request.ContentLength = 0;
            request.ContentType = "application/x-www-form-urlencoded";

            //Add token to the request header
            request.Headers.Add("Authorization", String.Format("Bearer {0}", token));

            NameValueCollection parsedQueryString = HttpUtility.ParseQueryString(String.Empty);
            parsedQueryString.Add("client_id", clientID);
            parsedQueryString.Add("grant_type", "password");
            parsedQueryString.Add("resource", resourceUri);
            parsedQueryString.Add("username", username);
            parsedQueryString.Add("password", password);
            string postdata = parsedQueryString.ToString();


            //POST web request
            byte[] dataByteArray = System.Text.Encoding.ASCII.GetBytes(postdata); ;
            request.ContentLength = dataByteArray.Length;

            //Write JSON byte[] into a Stream
            using (Stream writer = request.GetRequestStream())
            {
                writer.Write(dataByteArray, 0, dataByteArray.Length);
                var response = (HttpWebResponse)request.GetResponse();
                var responseString = new StreamReader(response.GetResponseStream()).ReadToEnd();
                dynamic responseJson = JsonConvert.DeserializeObject<dynamic>(responseString);
                return responseJson["access_token"];
            }


        }


        static string getAccessTokenWithLoginPopUp()
        {
            if (token == String.Empty)
            {
                //Get Azure access token
                // Create an instance of TokenCache to cache the access token
                TokenCache TC = new TokenCache();
                // Create an instance of AuthenticationContext to acquire an Azure access token
                authContext = new AuthenticationContext(authority, TC);
                // Call AcquireToken to get an Azure token from Azure Active Directory token issuance endpoint
                token = authContext.AcquireToken(resourceUri, clientID, new Uri(redirectUri), PromptBehavior.RefreshSession).AccessToken;
            }
            else
            {
                // Get the token in the cache
                token = authContext.AcquireTokenSilent(resourceUri, clientID).AccessToken;
            }

            return token;
        }
    }
}