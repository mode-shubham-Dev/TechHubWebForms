using System;
using System.Data.Entity;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using TechHubWebForms.DAL;

namespace TechHubWebForms.Admin
{
    public partial class ManageOrders : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Check authentication
            if (!User.Identity.IsAuthenticated)
            {
                Response.Redirect("~/Account/Login.aspx?ReturnUrl=" + Server.UrlEncode(Request.Url.PathAndQuery));
                return;
            }

            // Check admin role
            if (Session["UserRole"]?.ToString() != "Admin")
            {
                Response.Redirect("~/Default.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadOrders();
            }
        }

        /// <summary>
        /// Get CSS class for order status badge
        /// </summary>
        protected string GetStatusBadgeClass(string status)
        {
            switch (status?.ToLower())
            {
                case "pending":
                    return "status-badge status-pending";
                case "processing":
                    return "status-badge status-processing";
                case "shipped":
                    return "status-badge status-shipped";
                case "delivered":
                    return "status-badge status-delivered";
                case "cancelled":
                    return "status-badge status-cancelled";
                default:
                    return "status-badge";
            }
        }

        /// <summary>
        /// Load all orders into GridView
        /// </summary>
        private void LoadOrders(string searchTerm = "", string statusFilter = "")
        {
            try
            {
                using (var context = new TechHubContext())
                {
                    var query = context.Orders
                        .Include(o => o.User)
                        .AsQueryable();

                    // Apply status filter
                    if (!string.IsNullOrWhiteSpace(statusFilter))
                    {
                        query = query.Where(o => o.OrderStatus == statusFilter);
                    }

                    // Apply search filter
                    if (!string.IsNullOrWhiteSpace(searchTerm))
                    {
                        int orderId;
                        bool isNumeric = int.TryParse(searchTerm, out orderId);

                        if (isNumeric)
                        {
                            query = query.Where(o => o.OrderID == orderId);
                        }
                        else
                        {
                            query = query.Where(o =>
                                o.User.Name.Contains(searchTerm) ||
                                o.User.Email.Contains(searchTerm));
                        }
                    }

                    var orders = query.OrderByDescending(o => o.OrderID).ToList();

                    lblOrderCount.Text = orders.Count.ToString();

                    gvOrders.DataSource = orders;
                    gvOrders.DataBind();

                    pnlOrders.Visible = orders.Any();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading orders: " + ex.Message);
                ShowMessage("Error loading orders: " + ex.Message, false);
            }
        }

        /// <summary>
        /// Status filter changed
        /// </summary>
        protected void ddlStatusFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadOrders(txtSearch.Text.Trim(), ddlStatusFilter.SelectedValue);
        }

        /// <summary>
        /// Search orders
        /// </summary>
        protected void txtSearch_TextChanged(object sender, EventArgs e)
        {
            LoadOrders(txtSearch.Text.Trim(), ddlStatusFilter.SelectedValue);
        }

        /// <summary>
        /// GridView Edit mode
        /// </summary>
        protected void gvOrders_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvOrders.EditIndex = e.NewEditIndex;
            LoadOrders(txtSearch.Text.Trim(), ddlStatusFilter.SelectedValue);
        }

        /// <summary>
        /// GridView Row Data Bound - Set status dropdown selected value
        /// </summary>
        protected void gvOrders_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow && gvOrders.EditIndex == e.Row.RowIndex)
            {
                DropDownList ddlEditStatus = (DropDownList)e.Row.FindControl("ddlEditStatus");

                if (ddlEditStatus != null)
                {
                    var order = (Models.Order)e.Row.DataItem;
                    if (order != null)
                    {
                        ddlEditStatus.SelectedValue = order.OrderStatus;
                    }
                }
            }
        }

        /// <summary>
        /// GridView Cancel Edit
        /// </summary>
        protected void gvOrders_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvOrders.EditIndex = -1;
            LoadOrders(txtSearch.Text.Trim(), ddlStatusFilter.SelectedValue);
        }

        /// <summary>
        /// GridView Update order status
        /// </summary>
        protected void gvOrders_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            try
            {
                int orderId = Convert.ToInt32(gvOrders.DataKeys[e.RowIndex].Value);
                GridViewRow row = gvOrders.Rows[e.RowIndex];

                // Get updated status
                string newStatus = ((DropDownList)row.FindControl("ddlEditStatus")).SelectedValue;

                using (var context = new TechHubContext())
                {
                    var order = context.Orders.Find(orderId);

                    if (order != null)
                    {
                        string oldStatus = order.OrderStatus;
                        order.OrderStatus = newStatus;

                        // If status changed to Delivered, set delivery date
                        if (newStatus == "Delivered" && oldStatus != "Delivered")
                        {
                            order.DeliveryDate = DateTime.Now;
                        }

                        context.SaveChanges();
                        ShowMessage($"Order #{order.OrderID} status updated to '{newStatus}' successfully!", true);
                    }
                }

                gvOrders.EditIndex = -1;
                LoadOrders(txtSearch.Text.Trim(), ddlStatusFilter.SelectedValue);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error updating order: " + ex.Message);
                ShowMessage("Error updating order: " + ex.Message, false);
            }
        }

        /// <summary>
        /// GridView Row Command - Handle custom commands
        /// </summary>
        protected void gvOrders_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ViewDetails")
            {
                int orderId = Convert.ToInt32(e.CommandArgument);
                LoadOrderDetails(orderId);
            }
        }

        /// <summary>
        /// Load and display order details
        /// </summary>
        private void LoadOrderDetails(int orderId)
        {
            try
            {
                using (var context = new TechHubContext())
                {
                    var order = context.Orders
                        .Include(o => o.User)
                        .Include(o => o.OrderDetails.Select(od => od.Product))
                        .FirstOrDefault(o => o.OrderID == orderId);

                    if (order != null)
                    {
                        // Order header info
                        lblOrderID.Text = order.OrderID.ToString();
                        lblCustomerName.Text = order.User.Name;
                        lblCustomerEmail.Text = order.User.Email;
                        lblCustomerPhone.Text = order.ContactPhone ?? order.User.Phone ?? "N/A";
                        lblShippingAddress.Text = order.ShippingAddress;
                        lblOrderDate.Text = order.OrderDate.ToString("MMMM dd, yyyy hh:mm tt");
                        lblPaymentMethod.Text = order.PaymentMethod;
                        lblOrderStatus.Text = order.OrderStatus;
                        lblOrderTotal.Text = String.Format("{0:N0}", order.TotalAmount);

                        // Notes
                        if (!string.IsNullOrWhiteSpace(order.Notes))
                        {
                            lblNotes.Text = order.Notes;
                            pnlNotes.Visible = true;
                        }
                        else
                        {
                            pnlNotes.Visible = false;
                        }

                        // Order items
                        gvOrderDetails.DataSource = order.OrderDetails.ToList();
                        gvOrderDetails.DataBind();

                        pnlOrderDetails.Visible = true;

                        // Scroll to details
                        ScriptManager.RegisterStartupScript(this, GetType(), "ScrollToDetails",
                            "setTimeout(function(){ document.getElementById('" + pnlOrderDetails.ClientID + "').scrollIntoView({ behavior: 'smooth' }); }, 100);", true);
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("Error loading order details: " + ex.Message);
                ShowMessage("Error loading order details: " + ex.Message, false);
            }
        }

        /// <summary>
        /// Close order details panel
        /// </summary>
        protected void btnCloseDetails_Click(object sender, EventArgs e)
        {
            pnlOrderDetails.Visible = false;
        }

        /// <summary>
        /// GridView pagination
        /// </summary>
        protected void gvOrders_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvOrders.PageIndex = e.NewPageIndex;
            LoadOrders(txtSearch.Text.Trim(), ddlStatusFilter.SelectedValue);
        }

        /// <summary>
        /// Show success or error message
        /// </summary>
        private void ShowMessage(string message, bool isSuccess)
        {
            pnlMessage.Visible = true;
            divMessage.InnerText = message;

            if (isSuccess)
            {
                divMessage.Attributes["class"] = "message-content message-success";
            }
            else
            {
                divMessage.Attributes["class"] = "message-content message-error";
            }

            // Auto-hide after 5 seconds
            ScriptManager.RegisterStartupScript(this, GetType(), "HideMessage",
                "setTimeout(function(){ document.getElementById('" + pnlMessage.ClientID + "').style.display='none'; }, 5000);", true);
        }
    }
}