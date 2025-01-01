const express = require("express");
const adminRouter = express.Router();
const admin = require("../middlewares/admin");
const { Product } = require("../models/product");
const Order = require("../models/order");

// Add product
adminRouter.post("/admin/add-product", admin, async (req, res) => {
  try {
    const { name, description, images, quantity, price, category } = req.body;

    if (!name || !description || !images || !quantity || !price || !category) {
      return res.status(400).json({ error: "All fields are required" });
    }

    let product = new Product({
      name,
      description,
      images,
      quantity,
      price,
      category,
    });

    product = await product.save();
    res.status(201).json(product);
  } catch (e) {
    console.error(e.message);
    res.status(500).json({ error: "Failed to add the product" });
  }
});

// Get all products
adminRouter.get("/admin/get-products", admin, async (req, res) => {
  try {
    const products = await Product.find({});
    res.json(products);
  } catch (e) {
    console.error(e.message);
    res.status(500).json({ error: "Failed to fetch products" });
  }
});

// Delete a product
adminRouter.delete("/admin/delete-product/:id", admin, async (req, res) => {
  try {
    const { id } = req.params;

    if (!id) {
      return res.status(400).json({ error: "Product ID is required" });
    }

    const product = await Product.findByIdAndDelete(id);

    if (!product) {
      return res.status(404).json({ error: "Product not found" });
    }

    res.json({ message: "Product deleted successfully", product });
  } catch (e) {
    console.error(e.message);
    res.status(500).json({ error: "Failed to delete the product" });
  }
});

// Get all orders
adminRouter.get("/admin/get-orders", admin, async (req, res) => {
  try {
    const orders = await Order.find({});
    res.json(orders);
  } catch (e) {
    console.error(e.message);
    res.status(500).json({ error: "Failed to fetch orders" });
  }
});

// Change order status
adminRouter.patch("/admin/change-order-status", admin, async (req, res) => {
  try {
    const { id, status } = req.body;

    if (!id || !status) {
      return res.status(400).json({ error: "Order ID and status are required" });
    }

    const order = await Order.findById(id);

    if (!order) {
      return res.status(404).json({ error: "Order not found" });
    }

    order.status = status;
    await order.save();

    res.json({ message: "Order status updated successfully", order });
  } catch (e) {
    console.error(e.message);
    res.status(500).json({ error: "Failed to update order status" });
  }
});

// Get analytics
adminRouter.get("/admin/analytics", admin, async (req, res) => {
  try {
    const orders = await Order.find({});
    let totalEarnings = 0;

    orders.forEach((order) => {
      order.products.forEach((product) => {
        totalEarnings += product.quantity * product.product.price;
      });
    });

    const earnings = {
      totalEarnings,
      mobileEarnings: await fetchCategoryWiseProduct("Mobiles"),
      essentialEarnings: await fetchCategoryWiseProduct("Essentials"),
      applianceEarnings: await fetchCategoryWiseProduct("Appliances"),
      booksEarnings: await fetchCategoryWiseProduct("Books"),
      fashionEarnings: await fetchCategoryWiseProduct("Fashion"),
    };

    res.json(earnings);
  } catch (e) {
    console.error(e.message);
    res.status(500).json({ error: "Failed to fetch analytics" });
  }
});

// Helper function for category-wise earnings
async function fetchCategoryWiseProduct(category) {
  let earnings = 0;

  try {
    const categoryOrders = await Order.find({
      "products.product.category": category,
    });

    categoryOrders.forEach((order) => {
      order.products.forEach((product) => {
        if (product.product.category === category) {
          earnings += product.quantity * product.product.price;
        }
      });
    });
  } catch (e) {
    console.error(`Error fetching earnings for category ${category}: ${e.message}`);
  }

  return earnings;
}

module.exports = adminRouter;
