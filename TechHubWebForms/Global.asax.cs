using System;
using System.Web;
using System.Web.Optimization;
using System.Web.Routing;
using TechHubWebForms.DAL;

namespace TechHubWebForms
{
    public class Global : HttpApplication
    {
        void Application_Start(object sender, EventArgs e)
        {
            // Code that runs on application startup
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);

            // Seed the database on application startup
            try
            {
                using (var context = new TechHubContext())
                {
                    // Ensure database is created
                    context.Database.CreateIfNotExists();

                    // Seed data
                    DbSeeder.Seed(context);
                }
            }
            catch (Exception ex)
            {
                // Log the error
                System.Diagnostics.Debug.WriteLine("Database seeding error: " + ex.Message);
            }
        }
    }
}