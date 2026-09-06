const { z } = require('zod');

const productLine = z.object({
  productId: z.string().optional(),
  name: z.string().min(1),
  quantity: z.number().int().positive(),
  price: z.number().nonnegative(),
});

const createSaleSchema = z.object({
  storeId: z.string().min(1),
  orderReference: z.string().optional(),
  customerName: z.string().optional(),
  products: z.array(productLine).min(1),
  paymentMethod: z.string().min(1),
  saleDate: z.string().optional(),
});

const updateSaleSchema = createSaleSchema.partial();

module.exports = { createSaleSchema, updateSaleSchema };
