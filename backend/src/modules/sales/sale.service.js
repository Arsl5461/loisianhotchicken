const saleRepository = require('./sale.repository');
const { NotFoundError, ValidationError } = require('../../utils/AppError');

function computeLines(products = []) {
  if (!products.length) throw new ValidationError('At least one product is required');
  const lines = products.map((item) => ({
    ...item,
    total: Number((item.quantity * item.price).toFixed(2)),
  }));
  const totalAmount = Number(lines.reduce((sum, item) => sum + item.total, 0).toFixed(2));
  return { lines, totalAmount };
}

async function listSales(auth, query) {
  return saleRepository.list(auth, query);
}

async function getSale(auth, id) {
  const sale = await saleRepository.findById(id, auth.organizationId);
  if (!sale) throw new NotFoundError('Sale not found');
  return sale;
}

async function createSale(auth, payload) {
  const { lines, totalAmount } = computeLines(payload.products);
  return saleRepository.create({
    ...payload,
    products: lines,
    totalAmount,
    organizationId: auth.organizationId,
    createdBy: auth.userId,
    saleDate: payload.saleDate ? new Date(payload.saleDate) : new Date(),
  });
}

async function updateSale(auth, id, payload) {
  await getSale(auth, id);
  const update = { ...payload };
  if (payload.products) {
    const computed = computeLines(payload.products);
    update.products = computed.lines;
    update.totalAmount = computed.totalAmount;
  }
  if (payload.saleDate) update.saleDate = new Date(payload.saleDate);
  return saleRepository.updateById(id, auth.organizationId, update);
}

async function deleteSale(auth, id) {
  const sale = await saleRepository.remove(id, auth.organizationId);
  if (!sale) throw new NotFoundError('Sale not found');
  return { deleted: true };
}

async function deleteSales(auth, ids) {
  const deleted = await saleRepository.removeMany(ids, auth);
  return { deleted };
}

module.exports = { listSales, getSale, createSale, updateSale, deleteSale, deleteSales };
