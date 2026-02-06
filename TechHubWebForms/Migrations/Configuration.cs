namespace TechHubWebForms.Migrations
{
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Migrations;
    using System.Linq;
    using TechHubWebForms.DAL;

    internal sealed class Configuration : DbMigrationsConfiguration<TechHubWebForms.DAL.TechHubContext>
    {
        public Configuration()
        {
            AutomaticMigrationsEnabled = false;
        }

        protected override void Seed(TechHubWebForms.DAL.TechHubContext context)
        {
            // Call our custom seeder
            DbSeeder.Seed(context);
        }
    }
}