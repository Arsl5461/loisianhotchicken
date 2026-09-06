const path = require('path');
require('dotenv').config({ path: path.resolve(process.cwd(), '.env') });

const env = require('../../config/environment');
const { connectDatabase, disconnectDatabase } = require('../../config/database');
const logger = require('../../config/logger');
const { ROLE_DEFINITIONS } = require('../../constants/roles');
const {
  Organization,
  Store,
  Role,
  User,
  Product,
  Sale,
  Expense,
  ExpenseCategory,
  PaymentMethod,
  Order,
} = require('../models');

const MENU = [
  { name: 'Classic Hot Chicken Sandwich', category: 'CHICKEN', price: 12.99, costPrice: 4.8 },
  { name: 'Nashville Fire Tenders', category: 'CHICKEN', price: 14.5, costPrice: 5.2 },
  { name: 'Cajun Dirty Rice', category: 'SIDES', price: 4.5, costPrice: 1.1 },
  { name: 'Loaded Mac & Cheese', category: 'SIDES', price: 5.25, costPrice: 1.4 },
  { name: 'Sweet Tea', category: 'DRINKS', price: 2.75, costPrice: 0.4 },
  { name: 'Louisiana Combo', category: 'COMBOS', price: 18.99, costPrice: 7.1 },
];

const STORES = [
  {
    name: 'Downtown Branch',
    storeCode: 'LHC-DT',
    city: 'Baton Rouge',
    state: 'LA',
    address: '120 Third Street',
    email: 'downtown@louisianahotchicken.com',
    phone: '225-555-0101',
  },
  {
    name: 'Airport Branch',
    storeCode: 'LHC-AP',
    city: 'Kenner',
    state: 'LA',
    address: '900 Terminal Drive',
    email: 'airport@louisianahotchicken.com',
    phone: '504-555-0144',
  },
  {
    name: 'Mall Branch',
    storeCode: 'LHC-ML',
    city: 'Metairie',
    state: 'LA',
    address: '44 Lakeside Mall',
    email: 'mall@louisianahotchicken.com',
    phone: '504-555-0190',
  },
];

function randomBetween(min, max) {
  return Math.random() * (max - min) + min;
}

function pick(list) {
  return list[Math.floor(Math.random() * list.length)];
}

async function seed() {
  await connectDatabase();

  await Promise.all([
    Organization.deleteMany({}),
    Store.deleteMany({}),
    Role.deleteMany({}),
    User.deleteMany({}),
    Product.deleteMany({}),
    Sale.deleteMany({}),
    Expense.deleteMany({}),
    ExpenseCategory.deleteMany({}),
    PaymentMethod.deleteMany({}),
    Order.deleteMany({}),
  ]);

  const organization = await Organization.create({
    name: 'Louisiana Hot Chicken',
    slug: 'louisiana-hot-chicken',
    email: 'hq@louisianahotchicken.com',
    phone: '225-555-0100',
    address: 'Louisiana, United States',
    isActive: true,
  });

  const roles = await Role.insertMany(
    ROLE_DEFINITIONS.map((role) => ({
      ...role,
      organizationId: organization._id,
    }))
  );

  const roleBySlug = Object.fromEntries(roles.map((role) => [role.slug, role]));

  const stores = await Store.insertMany(
    STORES.map((store) => ({
      ...store,
      organizationId: organization._id,
      country: 'United States',
      status: 'ACTIVE',
      openingDate: new Date('2023-03-01'),
    }))
  );

  const admin = await User.create({
    organizationId: organization._id,
    name: env.superAdmin.name,
    email: env.superAdmin.email.toLowerCase(),
    password: env.superAdmin.password,
    roleId: roleBySlug.SUPER_ADMIN._id,
    stores: stores.map((store) => store._id),
    defaultStore: stores[0]._id,
    isActive: true,
  });

  await User.create([
    {
      organizationId: organization._id,
      name: 'Maya Landry',
      email: 'maya.manager@louisianahotchicken.com',
      password: 'Manager123!',
      roleId: roleBySlug.MANAGER._id,
      stores: [stores[0]._id],
      defaultStore: stores[0]._id,
    },
    {
      organizationId: organization._id,
      name: 'Chris Nguyen',
      email: 'chris.accountant@louisianahotchicken.com',
      password: 'Accountant123!',
      roleId: roleBySlug.ACCOUNTANT._id,
      stores: stores.map((store) => store._id),
      defaultStore: stores[0]._id,
    },
  ]);

  await Store.updateOne({ _id: stores[0]._id }, { manager: admin._id, createdBy: admin._id });

  const products = await Product.insertMany(
    MENU.map((item, index) => ({
      ...item,
      organizationId: organization._id,
      storeId: null,
      sku: `LHC-${String(index + 1).padStart(3, '0')}`,
      isAvailable: true,
      description: `${item.name} prepared Louisiana-style.`,
    }))
  );

  if (env.seedDemoData) {
    const sales = [];
    const expenses = [];
    const orders = [];
    const days = 90;
    let orderSeq = 1;

    for (let dayOffset = days; dayOffset >= 0; dayOffset -= 1) {
      const date = new Date();
      date.setDate(date.getDate() - dayOffset);
      date.setHours(12, 0, 0, 0);

      stores.forEach((store, storeIndex) => {
        const saleCount = 4 + ((dayOffset + storeIndex) % 5);
        for (let i = 0; i < saleCount; i += 1) {
          const product = pick(products);
          const quantity = 1 + Math.floor(Math.random() * 3);
          const lineTotal = Number((product.price * quantity).toFixed(2));
          sales.push({
            organizationId: organization._id,
            storeId: store._id,
            customerName: pick(['Walk-in Guest', 'Delivery Guest', 'Catering Guest']),
            products: [
              {
                productId: product._id,
                name: product.name,
                quantity,
                price: product.price,
                total: lineTotal,
              },
            ],
            totalAmount: lineTotal,
            paymentMethod: pick(['CASH', 'CARD', 'ONLINE']),
            saleDate: new Date(date.getTime() + i * 3600000),
            createdBy: admin._id,
            orderReference: `POS-${store.storeCode}-${dayOffset}-${i}`,
          });
        }

        const orderProduct = pick(products);
        const qty = 1 + Math.floor(Math.random() * 2);
        orders.push({
          organizationId: organization._id,
          storeId: store._id,
          orderNumber: `LHC-${date.getFullYear()}-${String(orderSeq).padStart(6, '0')}`,
          customer: { name: pick(['Jordan Blake', 'Ava Brooks', 'Walk-in Guest']), phone: '' },
          items: [
            {
              productId: orderProduct._id,
              name: orderProduct.name,
              quantity: qty,
              price: orderProduct.price,
              total: Number((orderProduct.price * qty).toFixed(2)),
            },
          ],
          total: Number((orderProduct.price * qty).toFixed(2)),
          status: pick(['COMPLETED', 'COMPLETED', 'READY', 'PREPARING']),
          paymentStatus: 'PAID',
          paymentMethod: pick(['CASH', 'CARD', 'ONLINE']),
          orderDate: date,
          createdBy: admin._id,
        });
        orderSeq += 1;

        if (dayOffset % 3 === storeIndex) {
          expenses.push({
            organizationId: organization._id,
            storeId: store._id,
            title: pick(['Chicken supply', 'Hourly payroll', 'Booth rent', 'Utility bill', 'Local ads']),
            description: 'Seeded operating expense',
            category: pick(['INGREDIENTS', 'SALARY', 'RENT', 'ELECTRICITY', 'MARKETING', 'MAINTENANCE']),
            amount: Number(randomBetween(120, 1800).toFixed(2)),
            paymentMethod: pick(['CASH', 'CARD', 'ONLINE']),
            expenseDate: date,
            createdBy: admin._id,
          });
        }
      });
    }

    await Sale.insertMany(sales);
    await Expense.insertMany(expenses);
    await Order.insertMany(orders);
    logger.info(`Seeded ${sales.length} sales, ${expenses.length} expenses, ${orders.length} orders`);
  }

  logger.info(`Super admin: ${env.superAdmin.email}`);
  await disconnectDatabase();
}

seed().catch(async (error) => {
  logger.error(error);
  await disconnectDatabase();
  process.exit(1);
});
